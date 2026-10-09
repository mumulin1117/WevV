import Dexie, { type EntityTable } from 'dexie'
import { getRuntimeConfig } from '@/core/config/runtime-config'
import { getClientContext } from '@/core/device/client-context'
import { getProductMode } from '@/core/product-mode/runtime'

export interface StoredDraft {
  id: string
  accountId: string
  payload: string
  updatedAt: number
}

export interface StoredTask {
  id: string
  accountId: string
  kind: 'message' | 'upload'
  payload: string
  state: 'failed' | 'pending' | 'running'
  updatedAt: number
}

export interface StoredSnapshot {
  id: string
  accountId: string
  payload: string
  updatedAt: number
}

interface StoredMeta {
  key: string
  updatedAt: number
  value: string
}

export class AppDatabase extends Dexie {
  drafts!: EntityTable<StoredDraft, 'id'>
  meta!: EntityTable<StoredMeta, 'key'>
  snapshots!: EntityTable<StoredSnapshot, 'id'>
  tasks!: EntityTable<StoredTask, 'id'>

  constructor() {
    const config = getRuntimeConfig()
    const appId = config.app.appId
    // deviceNo 与产品模式进入物理库名，accountId/contentVersion 继续进入记录键；
    // 固定运行期不会热切模式，因此一个实例只可能服务一个隔离域。
    super(`room-shell-${appId}-${getClientContext().deviceNo}-${getProductMode().mode}-app-data-v2`)
    this.version(1).stores({
      drafts: '&id,accountId,updatedAt',
      snapshots: '&id,accountId,updatedAt',
      tasks: '&id,accountId,kind,state,updatedAt',
    })
    this.version(2).stores({
      drafts: '&id,accountId,updatedAt',
      meta: '&key,updatedAt',
      snapshots: '&id,accountId,updatedAt',
      tasks: '&id,accountId,kind,state,updatedAt',
    })
  }

  /**
   * v2 把 deviceNo 与产品模式加入物理库名。旧库无法判断数据最初属于哪种模式，
   * 因而只做一次保守迁移：Remote 接收草稿/待处理写，Local 接收演示快照。
   * 新库已有同 id 数据始终优先，旧库保留，便于异常时人工恢复。
   */
  async migrateLegacyAccount(accountId: string): Promise<void> {
    const mode = getProductMode().mode
    const markerKey = `legacy-v1:${mode}:${accountId}`
    if (await this.meta.get(markerKey)) return
    const config = getRuntimeConfig()
    const legacyName = `room-shell-${config.app.appId}-app-data`
    if (!(await Dexie.exists(legacyName))) {
      await this.meta.put({ key: markerKey, updatedAt: Date.now(), value: 'missing' })
      return
    }

    const legacy = new Dexie(legacyName)
    try {
      await legacy.open()
      const drafts =
        mode === 'remote'
          ? await legacy
              .table<StoredDraft, string>('drafts')
              .where('accountId')
              .equals(accountId)
              .toArray()
          : []
      const tasks =
        mode === 'remote'
          ? await legacy
              .table<StoredTask, string>('tasks')
              .where('accountId')
              .equals(accountId)
              .toArray()
          : []
      const snapshots =
        mode === 'local'
          ? await legacy
              .table<StoredSnapshot, string>('snapshots')
              .where('accountId')
              .equals(accountId)
              .toArray()
          : []
      await this.transaction('rw', this.drafts, this.snapshots, this.tasks, this.meta, async () => {
        const [draftIds, taskIds, snapshotIds] = await Promise.all([
          this.drafts.bulkGet(drafts.map((item) => item.id)),
          this.tasks.bulkGet(tasks.map((item) => item.id)),
          this.snapshots.bulkGet(snapshots.map((item) => item.id)),
        ])
        const missingDrafts = drafts.filter((_, index) => !draftIds[index])
        const missingTasks = tasks.filter((_, index) => !taskIds[index])
        const missingSnapshots = snapshots.filter((_, index) => !snapshotIds[index])
        if (missingDrafts.length) await this.drafts.bulkAdd(missingDrafts)
        if (missingTasks.length) await this.tasks.bulkAdd(missingTasks)
        if (missingSnapshots.length) await this.snapshots.bulkAdd(missingSnapshots)
        await this.meta.put({
          key: markerKey,
          updatedAt: Date.now(),
          value: JSON.stringify({
            drafts: missingDrafts.length,
            snapshots: missingSnapshots.length,
            tasks: missingTasks.length,
          }),
        })
      })
    } finally {
      legacy.close()
    }
  }

  /** 仅供“重置本账号本地数据”使用；普通退出不得调用。 */
  async resetAccount(accountId: string): Promise<void> {
    await this.transaction('rw', this.drafts, this.snapshots, this.tasks, async () => {
      await Promise.all([
        this.drafts.where('accountId').equals(accountId).delete(),
        this.snapshots.where('accountId').equals(accountId).delete(),
        this.tasks.where('accountId').equals(accountId).delete(),
      ])
    })
  }

  /** Remote 退出只清服务端派生快照，保留草稿与待处理写任务。 */
  async clearServerSnapshots(accountId: string): Promise<void> {
    await this.snapshots.where('accountId').equals(accountId).delete()
  }

  async trim(maxSnapshots = 30, maxTasks = 100): Promise<void> {
    const snapshotIds = await this.snapshots
      .orderBy('updatedAt')
      .reverse()
      .offset(maxSnapshots)
      .primaryKeys()
    const taskIds = await this.tasks.orderBy('updatedAt').reverse().offset(maxTasks).primaryKeys()
    if (snapshotIds.length) await this.snapshots.bulkDelete(snapshotIds)
    if (taskIds.length) await this.tasks.bulkDelete(taskIds)
  }

  async trimAccount(accountId: string, maxSnapshots = 30, maxTasks = 100): Promise<void> {
    const [snapshots, tasks] = await Promise.all([
      this.snapshots.where('accountId').equals(accountId).sortBy('updatedAt'),
      this.tasks.where('accountId').equals(accountId).sortBy('updatedAt'),
    ])
    const snapshotIds = snapshots
      .slice(0, Math.max(0, snapshots.length - maxSnapshots))
      .map((item) => item.id)
    const taskIds = tasks.slice(0, Math.max(0, tasks.length - maxTasks)).map((item) => item.id)
    if (snapshotIds.length) await this.snapshots.bulkDelete(snapshotIds)
    if (taskIds.length) await this.tasks.bulkDelete(taskIds)
  }
}

let database: AppDatabase | undefined

export function getAppDatabase(): AppDatabase {
  database ??= new AppDatabase()
  return database
}

export async function resetAppDatabaseForTests(): Promise<void> {
  const current = database
  database = undefined
  current?.close()
}

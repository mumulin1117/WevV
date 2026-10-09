import type { RealtimeCredential } from '@/core/realtime/contracts'
import { getNimSession, type YunxinNimClient } from './nim-session'
import type {
  AudioMessageInfo,
  GiftItem,
  InboxConversation,
  InboxMessage,
  MessageGateway,
  MessageGatewayEvent,
  MessagePage,
  PrivateMediaInfo,
} from './contracts'
import {
  asRecord,
  bool,
  first,
  integer,
  parseJsonRecord,
  text,
  type UnknownRecord,
} from './value-readers'

interface EventService extends Record<string, unknown> {
  off: (event: string, callback: (...args: unknown[]) => void) => void
  on: (event: string, callback: (...args: unknown[]) => void) => void
}

interface ConversationService extends EventService {
  clearUnreadCountByIds: (conversationIds: string[]) => Promise<unknown[]>
  clearTotalUnreadCount: () => Promise<void>
  deleteConversation: (conversationId: string, clearMessage?: boolean) => Promise<void>
  deleteConversationListByIds: (
    conversationIds: string[],
    clearMessage?: boolean,
  ) => Promise<unknown>
  getConversationListByOption: (
    offset: number,
    limit: number,
    option: { conversationTypes: number[] },
  ) => Promise<{ conversationList: unknown[]; finished: boolean; offset: number }>
  markConversationRead: (conversationId: string) => Promise<number>
}

interface MessageService extends EventService {
  getMessageListEx: (options: Record<string, unknown>) => Promise<{ messages: unknown[] }>
  sendMessage: (
    message: unknown,
    conversationId: string,
    options?: Record<string, unknown>,
  ) => Promise<{ message?: unknown } | unknown>
}

interface MessageCreator extends Record<string, unknown> {
  createImageMessage: (file: File, name?: string, sceneName?: string) => unknown
  createTextMessage: (text: string) => unknown
}

interface UserService extends EventService {
  getUserList: (
    accountIds: string[],
  ) => Promise<Array<{ accountId: string; avatar?: string; name?: string }>>
  getUserListFromCloud: (
    accountIds: string[],
  ) => Promise<Array<{ accountId: string; avatar?: string; name?: string }>>
}

const IM_CONNECT_TIMEOUT = 12_000
const IM_READ_TIMEOUT = 10_000
// 首次登录通常会立即回调；超时只用于防止 SDK 异常漏回调，不能让直达消息页长时间卡骨架。
const IM_SYNC_WAIT_TIMEOUT = 1_200
const IM_WRITE_TIMEOUT = 15_000

function withDeadline<T>(task: Promise<T>, timeout: number, operation: string): Promise<T> {
  return new Promise<T>((resolve, reject) => {
    const timer = window.setTimeout(
      () => reject(new Error(`IM_${operation.toUpperCase()}_TIMEOUT`)),
      timeout,
    )
    task.then(resolve, reject).finally(() => window.clearTimeout(timer))
  })
}

function delivery(value: UnknownRecord): InboxMessage['delivery'] {
  const state = integer(value, 'sendingState')
  if (state === 3) return 'sending'
  if (state === 2) return 'failed'
  return 'sent'
}

function nestedRecords(value: UnknownRecord): UnknownRecord[] {
  const output: UnknownRecord[] = []
  const queue = [value]
  const seen = new Set<UnknownRecord>()
  while (queue.length && output.length < 20) {
    const current = queue.shift()
    if (!current || seen.has(current)) continue
    seen.add(current)
    output.push(current)
    for (const key of [
      'data',
      'privateInfo',
      'attachment',
      'customContent',
      'messageRefer',
      'serverExtension',
      'raw',
    ]) {
      const nested = asRecord(current[key]) ?? parseJsonRecord(current[key])
      if (Object.keys(nested).length) queue.push(nested)
    }
  }
  return output
}

export function isPrivateMessagePayload(value: unknown): boolean {
  const record = asRecord(value)
  if (!record) return false
  const sources = [
    ...nestedRecords(record),
    ...nestedRecords(parseJsonRecord(record.serverExtension)),
    ...nestedRecords(parseJsonRecord(record.text)),
  ]
  return sources.some((source) => text(source, 'extensionType') === 'privateMsg')
}

function privateMediaPayload(value: UnknownRecord): PrivateMediaInfo | undefined {
  const sources = [
    ...nestedRecords(value),
    ...nestedRecords(parseJsonRecord(value.serverExtension)),
    ...nestedRecords(parseJsonRecord(value.text)),
  ]
  const extension = sources.find((source) => text(source, 'extensionType') === 'privateMsg')
  if (!extension) return undefined
  const data = asRecord(extension.data) ?? parseJsonRecord(extension.data)
  const privateId = integer(data, 'privateId')
  const recordId = integer(data, 'recordId')
  const iconType = integer(data, 'iconType')
  const price = Math.max(0, integer(data, 'giftPrice'))
  const giftIconUrl = text(data, 'gift')
  const contractValid =
    Number.isSafeInteger(privateId) &&
    privateId > 0 &&
    Number.isSafeInteger(recordId) &&
    recordId > 0 &&
    [1, 2].includes(iconType) &&
    price > 0 &&
    Boolean(giftIconUrl)
  // 私密媒体的原地址只能来自解锁后的 check 响应。NIM attachment.url 可能是原图或
  // 短期签名地址，锁定态绝不能把它带进 DOM；这里只接受扩展中明确标注的安全封面。
  return {
    coverUrl: text(data, 'coverUrl', 'thumbUrl', 'thumbnail'),
    giftIconUrl,
    mediaType: iconType === 2 ? 'video' : 'image',
    price,
    privateId,
    ...(text(data, 'qualityPrivateBadgeUrl')
      ? { qualityBadgeUrl: text(data, 'qualityPrivateBadgeUrl') }
      : {}),
    recordId,
    status: contractValid ? 'checking' : 'unavailable',
  }
}

function giftPayload(value: UnknownRecord): (GiftItem & { count: number }) | undefined {
  const attachment = asRecord(value.attachment) ?? {}
  const root = parseJsonRecord(attachment.raw ?? value.text)
  const data = asRecord(root.data) ?? parseJsonRecord(root.data)
  const source = [root, data].find(
    (item) =>
      text(item, 'type', 'attachType') === 'im_gift' ||
      text(item, 'type', 'attachType') === 'SEND_GIFT' ||
      integer(item, 'giftId') > 0,
  )
  if (!source) return undefined
  return {
    animationUrl: text(source, 'giftImg', 'animUrl'),
    count: Math.max(1, integer(source, 'giftNum', 'num', 'count')),
    iconUrl: text(source, 'smallImg', 'giftSmallImg', 'giftIcon', 'giftImg', 'icon'),
    id: text(source, 'giftId', 'id'),
    name: text(source, 'giftName', 'name', 'giftTitle') || 'Gift',
    price: Math.max(0, integer(source, 'giftPrice', 'price')),
    source: 'wallet',
  }
}

function isPlatformNotificationPayload(value: UnknownRecord): boolean {
  return nestedRecords(value).some((source) => {
    const attachType = integer(source, 'attachType')
    const viewFlag = integer(source, 'viewFlag')
    return attachType === 150 || [4, 5, 6, 7, 8, 9].includes(viewFlag)
  })
}

function imageUrl(value: UnknownRecord): string {
  const attachment = asRecord(value.attachment) ?? {}
  const direct = text(attachment, 'thumbUrl', 'thumbnail', 'thumb', 'url', 'fileUrl', 'path')
  if (direct) return direct
  const raw = parseJsonRecord(attachment.raw ?? value.text)
  const nested = asRecord(raw.data) ?? parseJsonRecord(raw.data)
  return (
    text(raw, 'thumbUrl', 'thumbnail', 'thumb', 'url', 'fileUrl', 'path') ||
    text(nested, 'thumbUrl', 'thumbnail', 'thumb', 'url', 'fileUrl', 'path')
  )
}

// OPI 的私密图片 check 只返回 lockStatus=1，不返回 privateUrl；旧站在服务端确认
// 解锁后才读取同一条 NIM 图片附件。该地址只由 Store 在已解锁分支消费，解析后的
// 锁定消息、DOM、通知和持久化快照均不携带它。私密视频不能使用这个回退。
export function privateImageAttachmentUrl(value: unknown): string {
  const raw = asRecord(value)
  if (!raw) return ''
  const refer = asRecord(raw.messageRefer) ?? {}
  const direct = asRecord(raw.attachment) ?? parseJsonRecord(raw.attachment)
  const fallback = asRecord(refer.attachment) ?? parseJsonRecord(refer.attachment)
  const attachment = Object.keys(direct).length ? direct : fallback
  return text(attachment, 'url')
}

function audioPayload(value: UnknownRecord): AudioMessageInfo | undefined {
  const attachment = asRecord(value.attachment) ?? parseJsonRecord(value.attachment)
  const url = text(attachment, 'url')
  if (!url) return undefined
  return {
    durationMs: Math.max(0, integer(attachment, 'duration')),
    url,
  }
}

export function parseNimMessage(value: unknown, ownAccount = ''): InboxMessage | null {
  const raw = asRecord(value)
  if (!raw) return null
  // V2NIMMessage 的引用字段在根节点；会话摘要 V2NIMLastMessage 则放在 messageRefer。
  // 两种对象必须走同一解析器，否则会话列表会永久退化成“Start a conversation”，
  // 同时因为 latest=null 把真实未读错误归零。
  const refer = asRecord(raw.messageRefer) ?? {}
  const conversationId = text(raw, 'conversationId') || text(refer, 'conversationId')
  if (!conversationId) return null
  const payload: UnknownRecord = {
    ...refer,
    ...raw,
    attachment: raw.attachment ?? refer.attachment,
    serverExtension: raw.serverExtension ?? refer.serverExtension,
  }
  const type = integer(raw, 'messageType') || integer(refer, 'messageType')
  const privateMedia = privateMediaPayload(payload)
  const audio = type === 2 ? audioPayload(payload) : undefined
  const gift = type === 100 ? giftPayload(payload) : undefined
  const platformNotification = type === 100 && isPlatformNotificationPayload(payload)
  const attachmentUrl = type === 1 ? imageUrl(payload) : ''
  const kind = privateMedia
    ? 'private-media'
    : audio
      ? 'audio'
      : gift
        ? 'gift'
        : attachmentUrl
          ? 'image'
          : type === 0
            ? 'text'
            : type === 5 || type === 10 || platformNotification
              ? 'system'
              : 'unsupported'
  if (kind === 'unsupported') return null
  const safeText = text(raw, 'text') || text(refer, 'text')
  return {
    ...(kind === 'image' && attachmentUrl ? { attachmentUrl } : {}),
    ...(audio ? { audio } : {}),
    conversationId,
    createdAt: Math.max(0, integer(raw, 'createTime'), integer(refer, 'createTime')) || Date.now(),
    delivery: delivery(raw),
    ...(gift ? { gift } : {}),
    id:
      text(raw, 'messageClientId', 'messageServerId') ||
      text(refer, 'messageClientId', 'messageServerId') ||
      `${conversationId}:${integer(refer, 'createTime')}:${text(refer, 'senderId')}`,
    kind: kind as InboxMessage['kind'],
    own:
      bool(raw, 'isSelf') ||
      Boolean(ownAccount && (text(raw, 'senderId') || text(refer, 'senderId')) === ownAccount),
    raw: value,
    senderId: text(raw, 'senderId') || text(refer, 'senderId'),
    ...(privateMedia ? { privateMedia } : {}),
    text:
      kind === 'private-media'
        ? privateMedia?.mediaType === 'video'
          ? '[Private Video]'
          : '[Private Photo]'
        : kind === 'image'
          ? '[Image]'
          : kind === 'audio'
            ? 'Voice message'
            : kind === 'gift'
              ? `sent ${gift?.name ?? 'Gift'} ×${gift?.count ?? 1}`
              : safeText || 'Message',
  }
}

export class NimMessageGateway implements MessageGateway {
  private account = ''
  private client: YunxinNimClient | null = null
  private readonly listeners = new Set<(event: MessageGatewayEvent) => void>()
  private readonly subscriptions: Array<() => void> = []
  private syncFinished = false
  private readonly syncWaiters = new Set<() => void>()

  constructor(private readonly credential: () => Promise<RealtimeCredential | null>) {}

  async connect(): Promise<void> {
    if (this.client?.V2NIMLoginService.getLoginStatus() === 1) return
    const credential = await withDeadline(this.credential(), IM_CONNECT_TIMEOUT, 'credential')
    if (!credential) throw new Error('IM credential is unavailable.')
    const runtime = getNimSession()
    // 先监听再登录，保证不会漏掉云端会话 onSyncFinished。
    this.client = runtime.prepareMessageClient()
    this.account = credential.imAccount
    this.syncFinished = false
    // 网络恢复会复用同一个 Gateway；重新绑定前先移除旧监听，避免每次前台恢复都叠加消息回调。
    this.subscriptions.splice(0).forEach((stop) => stop())
    this.subscribe()
    try {
      this.client = await withDeadline(
        runtime.getLoggedInClient(credential),
        IM_CONNECT_TIMEOUT,
        'connect',
      )
      await this.waitForConversationSync()
    } catch (cause) {
      this.subscriptions.splice(0).forEach((stop) => stop())
      this.account = ''
      this.client = null
      throw cause
    }
  }

  connectionState(): 'connected' | 'connecting' | 'disconnected' {
    const status = getNimSession().getLoginStatus()
    if (status === 1) return 'connected'
    if (status === 2) return 'connecting'
    return 'disconnected'
  }

  async disconnect(): Promise<void> {
    this.subscriptions.splice(0).forEach((stop) => stop())
    this.syncFinished = false
    this.syncWaiters.forEach((resolve) => resolve())
    this.syncWaiters.clear()
    this.account = ''
    this.client = null
  }

  async conversationIdFor(imAccount: string): Promise<string> {
    const client = await this.requireClient()
    return client.V2NIMConversationIdUtil.p2pConversationId(imAccount)
  }

  setVisible(visible: boolean): void {
    getNimSession().setAppVisible(visible)
  }

  observe(listener: (event: MessageGatewayEvent) => void): () => void {
    this.listeners.add(listener)
    return () => this.listeners.delete(listener)
  }

  async listConversations(cursor = '0', limit = 30): Promise<MessagePage<InboxConversation>> {
    const client = await this.requireClient()
    const offset = Math.max(0, Number(cursor) || 0)
    const pageSize = Math.min(100, Math.max(1, limit))
    const result = await withDeadline(
      this.conversations(client).getConversationListByOption(offset, pageSize, {
        conversationTypes: [1],
      }),
      IM_READ_TIMEOUT,
      'conversation_list',
    )
    const nextOffset = Math.max(0, Number(result.offset) || 0)
    const cursorAdvanced = nextOffset > offset
    const parsed = result.conversationList.map((value) => ({
      conversation: this.parseConversation(value, client),
      id: text(asRecord(value) ?? {}, 'conversationId'),
    }))
    const items = parsed
      .map((item) => item.conversation)
      .filter((item) => item !== null)
      .sort((left, right) => right.sortTime - left.sortTime)
    const hiddenIds = parsed.filter((item) => !item.conversation && item.id).map((item) => item.id)

    // REST 资料用于业务 userId/在线态，NIM 自身资料用于弱网时兜底昵称和头像。
    // 这样批量资料接口短暂失败也不会把用户直接显示成一串 yxAccid。
    const unresolved = items
      .filter((item) => item.displayName === item.imAccount || !item.avatarUrl)
      .map((item) => item.imAccount)
    if (unresolved.length) {
      const users = await withDeadline(
        this.users(client).getUserList([...new Set(unresolved)]),
        IM_READ_TIMEOUT,
        'user_list',
      ).catch(() => [])
      const userMap = new Map(users.map((user) => [user.accountId, user]))
      items.forEach((item) => {
        const user = userMap.get(item.imAccount)
        if (!user) return
        item.displayName = user.name?.trim() || item.displayName
        item.avatarUrl = user.avatar?.trim() || item.avatarUrl
      })
      const stillUnresolved = items
        .filter((item) => item.displayName === item.imAccount || !item.avatarUrl)
        .map((item) => item.imAccount)
      if (stillUnresolved.length) {
        // 与 Android 一致：云端资料拉取只做后台补全，不能拖住会话真值首绘。
        // 成功后 SDK 会触发 onUserProfileChanged，再自动重建列表展示。
        void this.users(client)
          .getUserListFromCloud([...new Set(stillUnresolved)])
          .catch(() => undefined)
      }
    }

    return {
      // 云信偶发返回 finished=false 但 offset 不前进。这里必须截断，避免列表组件无限触底请求。
      finished: result.finished || result.conversationList.length < pageSize || !cursorAdvanced,
      hiddenIds,
      items,
      nextCursor: cursorAdvanced ? String(nextOffset) : String(offset),
    }
  }

  async listMessages(
    conversationId: string,
    cursor = '',
    limit = 50,
  ): Promise<MessagePage<InboxMessage>> {
    const client = await this.requireClient()
    const endTime = cursor ? Math.max(0, Number(cursor) - 1) : Date.now()
    const pageSize = Math.min(100, Math.max(1, limit))
    const result = await withDeadline(
      this.messages(client).getMessageListEx({
        conversationId,
        direction: 0,
        endTime,
        limit: pageSize,
      }),
      IM_READ_TIMEOUT,
      'message_list',
    )
    const items = result.messages
      .map((value) => parseNimMessage(value, this.account))
      .filter(
        (item): item is InboxMessage => item !== null && item.conversationId === conversationId,
      )
      .sort((left, right) => left.createdAt - right.createdAt)
    const oldestRawTime = result.messages.reduce<number>((oldest, value) => {
      const createdAt = Math.max(0, integer(asRecord(value) ?? {}, 'createTime'))
      return createdAt && createdAt < oldest ? createdAt : oldest
    }, Number.POSITIVE_INFINITY)
    const nextCursor = Number.isFinite(oldestRawTime) ? String(oldestRawTime) : ''
    const cursorAdvanced = !cursor || (nextCursor !== '' && Number(nextCursor) < Number(cursor))
    return {
      // 游标必须根据原始消息推进，不能根据过滤掉的未知自定义消息推进。
      // 否则一整页均不可展示时会重复请求同一页并卡死。
      finished: result.messages.length < pageSize || !nextCursor || !cursorAdvanced,
      items,
      nextCursor,
    }
  }

  async sendText(conversationId: string, value: string): Promise<InboxMessage> {
    const client = await this.requireClient()
    const text = value.trim()
    if (!text) throw new Error('Message cannot be empty.')
    const message = this.creator(client).createTextMessage(text)
    const result = await withDeadline(
      this.messages(client).sendMessage(message, conversationId, {}),
      IM_WRITE_TIMEOUT,
      'send_text',
    )
    const parsed = parseNimMessage(asRecord(result)?.message ?? result, this.account)
    if (!parsed) throw new Error('The message could not be sent.')
    return parsed
  }

  async sendImage(conversationId: string, file: File): Promise<InboxMessage> {
    if (!file.type.startsWith('image/')) throw new Error('Please select an image.')
    const client = await this.requireClient()
    // 使用 SDK 默认 NOS scene。旧实现传入未注册的 `message` scene，真机会在创建
    // 消息阶段失败，表现为选择图片后一直没有真正上传。
    const message = this.creator(client).createImageMessage(file)
    // 云信图片消息需要先走 NOS 上传；弱网下 15 秒经常在上传完成前误判失败。
    // 文本仍保持 15 秒，媒体单独放宽到 60 秒并由页面维持 sending 状态。
    const result = await withDeadline(
      this.messages(client).sendMessage(message, conversationId, {}),
      60_000,
      'send_image',
    )
    const parsed = parseNimMessage(asRecord(result)?.message ?? result, this.account)
    if (!parsed) throw new Error('The image could not be sent.')
    return parsed
  }

  async markRead(conversationId: string): Promise<void> {
    const client = await this.requireClient()
    const service = this.conversations(client)
    // clearUnreadCountByIds 是 V2 10.9 的正式清未读接口；markConversationRead 同时推进
    // 云端阅读时间。两条都执行，和 Android 的“进入/停留/离开三段式补清”保持一致。
    const results = await Promise.allSettled([
      withDeadline(
        service.clearUnreadCountByIds([conversationId]),
        IM_READ_TIMEOUT,
        'clear_unread',
      ),
      withDeadline(service.markConversationRead(conversationId), IM_READ_TIMEOUT, 'mark_read'),
    ])
    if (results.every((item) => item.status === 'rejected')) throw new Error('IM_MARK_READ_FAILED')
  }

  async clearAllUnread(): Promise<void> {
    const client = await this.requireClient()
    await withDeadline(
      this.conversations(client).clearTotalUnreadCount(),
      IM_READ_TIMEOUT,
      'mark_all_read',
    )
  }

  async deleteConversation(conversationId: string): Promise<void> {
    const client = await this.requireClient()
    await withDeadline(
      this.conversations(client).deleteConversation(conversationId, true),
      IM_WRITE_TIMEOUT,
      'delete_conversation',
    )
  }

  async deleteAllConversations(): Promise<readonly string[]> {
    const client = await this.requireClient()
    const service = this.conversations(client)
    const ids: string[] = []
    let offset = 0
    for (let page = 0; page < 20; page += 1) {
      const result = await withDeadline(
        service.getConversationListByOption(offset, 100, { conversationTypes: [1] }),
        IM_READ_TIMEOUT,
        'conversation_list_for_delete',
      )
      for (const value of result.conversationList) {
        const id = text(asRecord(value) ?? {}, 'conversationId')
        if (id) ids.push(id)
      }
      const nextOffset = Math.max(0, Number(result.offset) || 0)
      if (result.finished || result.conversationList.length < 100 || nextOffset <= offset) break
      offset = nextOffset
    }
    const uniqueIds = [...new Set(ids)]
    if (uniqueIds.length)
      await withDeadline(
        service.deleteConversationListByIds(uniqueIds, true),
        IM_WRITE_TIMEOUT,
        'delete_all_conversations',
      )
    return uniqueIds
  }

  async deleteConversations(conversationIds: readonly string[]): Promise<void> {
    if (!conversationIds.length) return
    const client = await this.requireClient()
    await withDeadline(
      this.conversations(client).deleteConversationListByIds([...conversationIds], true),
      IM_WRITE_TIMEOUT,
      'delete_conversations',
    )
  }

  private async requireClient(): Promise<YunxinNimClient> {
    await this.connect()
    if (!this.client) throw new Error('IM is unavailable.')
    return this.client
  }

  private conversations(client: YunxinNimClient): ConversationService {
    return client.V2NIMConversationService as ConversationService
  }

  private messages(client: YunxinNimClient): MessageService {
    return client.V2NIMMessageService as MessageService
  }

  private users(client: YunxinNimClient): UserService {
    return client.V2NIMUserService as UserService
  }

  private creator(client: YunxinNimClient): MessageCreator {
    return client.V2NIMMessageCreator as MessageCreator
  }

  private parseConversation(value: unknown, client: YunxinNimClient): InboxConversation | null {
    const raw = asRecord(value)
    if (!raw || integer(raw, 'type') !== 1) return null
    const conversationId = text(raw, 'conversationId')
    if (!conversationId) return null
    const imAccount = client.V2NIMConversationIdUtil.parseConversationTargetId(conversationId)
    const rawLatest = first(raw, 'lastMessage')
    const latest = parseNimMessage(rawLatest, this.account)
    const hiddenLatest = Boolean(rawLatest) && !latest
    // 未知自定义消息不进入列表；正式 privateMsg 会由统一解析器生成安全摘要。
    if (hiddenLatest) return null
    return {
      avatarUrl: text(raw, 'avatar'),
      conversationId,
      displayName: text(raw, 'name') || imAccount,
      imAccount,
      latest,
      muted: bool(raw, 'mute'),
      online: false,
      sortTime: Math.max(
        integer(raw, 'sortOrder'),
        integer(raw, 'updateTime'),
        latest?.createdAt ?? 0,
      ),
      unread: Math.max(0, integer(raw, 'unreadCount')),
      userId: '',
    }
  }

  private subscribe(): void {
    if (!this.client || this.subscriptions.length) return
    const conversationService = this.conversations(this.client)
    const messageService = this.messages(this.client)
    const onMessage = (...args: unknown[]) => {
      const values = Array.isArray(args[0]) ? args[0] : args
      for (const value of values) {
        const message = parseNimMessage(value, this.account)
        if (message) this.emit({ message, type: 'message' })
      }
    }
    const onConversation = (...args: unknown[]) => {
      const values = Array.isArray(args[0]) ? args[0] : args
      for (const value of values) {
        const conversation = this.client && this.parseConversation(value, this.client)
        if (conversation) this.emit({ conversation, type: 'conversation' })
      }
    }
    const onDeleted = (...args: unknown[]) => {
      const ids = (Array.isArray(args[0]) ? args[0] : args).map(String)
      this.emit({ conversationIds: ids, type: 'conversations-deleted' })
    }
    const onUnread = (value: unknown) =>
      this.emit({ total: Math.max(0, Number(value) || 0), type: 'unread' })

    this.on(messageService, 'onReceiveMessages', onMessage)
    this.on(messageService, 'onSendMessage', onMessage)
    this.on(conversationService, 'onConversationCreated', onConversation)
    this.on(conversationService, 'onConversationChanged', onConversation)
    this.on(conversationService, 'onConversationDeleted', onDeleted)
    this.on(conversationService, 'onTotalUnreadCountChanged', onUnread)
    this.on(conversationService, 'onSyncFinished', () => {
      this.syncFinished = true
      this.syncWaiters.forEach((resolve) => resolve())
      this.syncWaiters.clear()
      this.emit({ type: 'sync' })
    })
    this.on(this.users(this.client), 'onUserProfileChanged', () => this.emit({ type: 'sync' }))
  }

  private async waitForConversationSync(): Promise<void> {
    if (this.syncFinished) return
    await new Promise<void>((resolve) => {
      let settled = false
      const finish = () => {
        if (settled) return
        settled = true
        window.clearTimeout(timer)
        this.syncWaiters.delete(finish)
        resolve()
      }
      const timer = window.setTimeout(() => {
        finish()
      }, IM_SYNC_WAIT_TIMEOUT)
      this.syncWaiters.add(finish)
      if (this.syncFinished) finish()
    })
  }

  private on(service: EventService, event: string, callback: (...args: unknown[]) => void): void {
    service.on(event, callback)
    this.subscriptions.push(() => service.off(event, callback))
  }

  private emit(event: MessageGatewayEvent): void {
    this.listeners.forEach((listener) => listener(event))
  }
}

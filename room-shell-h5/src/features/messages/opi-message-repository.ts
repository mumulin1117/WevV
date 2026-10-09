import { getApiClient } from '@/core/auth/runtime'
import type {
  CustomerAgent,
  CustomerProblem,
  GiftCatalog,
  GiftItem,
  GiftSendResult,
  MessageProfile,
  MessageRepository,
  OnlineHost,
  PrivateMediaCheckResult,
  RelationUser,
} from './contracts'
import { asRecord, bool, integer, records, text, type UnknownRecord } from './value-readers'
import { z } from 'zod'

const rawSchema = z.unknown()

function giftRows(value: unknown): UnknownRecord[] {
  const root = asRecord(value)
  const giftList = root ? asRecord(root.giftList) : null
  return records(giftList ?? value)
}

function profileFromRecord(value: UnknownRecord, fallbackAccount = ''): MessageProfile {
  const status = integer(
    value,
    'onlineGroupStatus',
    'online_group_status',
    'groupOnline',
    'group_online',
    'onlineStatus',
    'online_status',
    'groupStatus',
    'anchorStatus',
    'userStatus',
    'state',
    'status',
  )
  return {
    avatarUrl: text(value, 'icon', 'avatar', 'avatarUrl', 'itemSmallImg', 'item_small_img'),
    displayName: text(value, 'nickname', 'nick', 'nickName', 'displayName', 'name'),
    followed: bool(value, 'followed', 'followFlag', 'isFollow'),
    imAccount: text(value, 'yxAccid', 'accid', 'imAccid', 'yunxinAccid', 'imId') || fallbackAccount,
    live: bool(value, 'liveFlag', 'live', 'living', 'isLive'),
    online: bool(value, 'online', 'isOnline') || status === 1,
    signature: text(value, 'signature', 'description', 'bio'),
    userId: text(value, 'userId', 'uid', 'id'),
    userType: Math.max(0, integer(value, 'userType')),
  }
}

function profileRecords(value: unknown): UnknownRecord[] {
  const list = records(value)
  if (list.length) return list
  const root = asRecord(value)
  if (!root) return []
  return Object.entries(root)
    .map(([account, item]) => {
      const record = asRecord(item)
      return record ? { ...record, __fallbackAccount: account } : null
    })
    .filter((item) => item !== null)
}

class OpiMessageRepository implements MessageRepository {
  async batchProfiles(accounts: readonly string[]): Promise<readonly MessageProfile[]> {
    const unique = [...new Set(accounts.map((item) => item.trim()).filter(Boolean))]
    const output: MessageProfile[] = []
    for (let offset = 0; offset < unique.length; offset += 100) {
      const batch = unique.slice(offset, offset + 100)
      const value = await getApiClient().request({
        authMode: 'required',
        data: { ids: batch, yxAccIds: batch, yxAccids: batch },
        method: 'POST',
        schema: rawSchema,
        url: '/_v2/anchor/batchQueryYxStat',
      })
      output.push(
        ...profileRecords(value).map((item) =>
          profileFromRecord(item, text(item, '__fallbackAccount')),
        ),
      )
    }
    return output
  }

  async getCustomerAgents(): Promise<readonly CustomerAgent[]> {
    const value = await this.request('/_v2/user/customer-service')
    return records(value)
      .map((item) => ({
        avatarUrl: text(item, 'avatar', 'icon'),
        displayName: text(item, 'nickname', 'name') || 'Support',
        imAccount: text(item, 'imId', 'yxAccid', 'accid'),
        online: integer(item, 'state') === 1 || bool(item, 'online'),
      }))
      .filter((item) => item.imAccount)
  }

  async getCustomerProblems(): Promise<readonly CustomerProblem[]> {
    const value = await this.request('/_v2/user/customer/problems')
    return records(value)
      .map((item, index) => ({
        category: text(item, 'problemTitle', 'category') || 'Other issues',
        id: text(item, 'id') || `customer-problem-${index}`,
        operation: ['copy', 'page'].includes(text(item, 'operation').toLowerCase())
          ? (text(item, 'operation').toLowerCase() as 'copy' | 'page')
          : ('default' as const),
        operationContent: text(item, 'operationContent'),
        reply: text(item, 'problemReply', 'reply', 'content'),
        title: text(item, 'problemName', 'title'),
      }))
      .filter((item) => item.title)
  }

  async getGiftCatalog(anchorId?: string): Promise<GiftCatalog> {
    const numericAnchorId = Number(anchorId)
    // 旧站与接口文档明确：IM 使用 V3 场景目录，首礼资格可能随聊天对象变化。
    // 当前送礼面板暂不提供背包，因此这里也不请求背包目录。
    const walletValue = await this.request('/_v2/gift/list-v3', {
      ...(Number.isSafeInteger(numericAnchorId) && numericAnchorId > 0
        ? { anchorId: numericAnchorId }
        : {}),
      scene: 'IM',
    })
    const root = asRecord(walletValue) ?? {}
    const info = asRecord(root.info) ?? {}
    const balance = Number(info.draft)
    const walletGifts = giftRows(walletValue)
      .map((item) => ({
        animationUrl: text(item, 'giftImg', 'animUrl'),
        category: text(item, 'category') || 'Popular',
        iconUrl: text(item, 'giftSmallImg', 'icon', 'giftImg'),
        id: text(item, 'id', 'giftId'),
        name: text(item, 'name', 'giftName') || 'Gift',
        price: Math.max(0, integer(item, 'giftPrice', 'price')),
        source: 'wallet' as const,
      }))
      .filter((item) => item.id && item.iconUrl)
    return {
      ...(Number.isFinite(balance) ? { balance } : {}),
      gifts: walletGifts,
    }
  }

  async getOnlineHosts(): Promise<readonly OnlineHost[]> {
    const value = await this.request('/_v2/user/follow/anchors-live', {
      currentPage: 1,
      pageSize: 100,
    })
    return records(value).map((item) => {
      const profile = profileFromRecord(item)
      const status = integer(item, 'groupStatus', 'onlineGroupStatus', 'state')
      return {
        ...profile,
        age: Math.max(0, integer(item, 'age')),
        followed: true,
        live: true,
        liveRoomId: text(item, 'id', 'liveRoomId', 'roomId') || undefined,
        online: status !== 3,
        status: status === 2 ? ('busy' as const) : ('online' as const),
        userType: profile.userType || 2,
      }
    })
  }

  async getRelations(type: 1 | 2 | 3): Promise<readonly RelationUser[]> {
    const value = await this.request('/_v2/user/relations', { type })
    const relationRows = records(value)
    const userIds = relationRows.map((item) => text(item, 'userId', 'uid', 'id')).filter(Boolean)
    const statusValue = userIds.length
      ? await this.request('/_v2/anchor/batchQueryYxStatByUid', { ids: userIds, userIds })
      : []
    const statusByUserId = new Map(
      profileRecords(statusValue).map((item) => {
        const profile = profileFromRecord(item)
        return [profile.userId, { profile, raw: item }] as const
      }),
    )
    return relationRows.map((item) => {
      const relation = profileFromRecord(item)
      const status = statusByUserId.get(relation.userId)
      return {
        ...relation,
        age: Math.max(0, integer(item, 'age') || integer(status?.raw ?? {}, 'age')),
        avatarUrl: relation.avatarUrl || status?.profile.avatarUrl || '',
        countryId:
          text(item, 'countryId', 'countryCode', 'country') ||
          text(status?.raw ?? {}, 'countryId', 'countryCode', 'country'),
        displayName: relation.displayName || status?.profile.displayName || 'User',
        gender: integer(item, 'gender', 'sex'),
        imAccount: relation.imAccount || status?.profile.imAccount || '',
        level: Math.max(0, integer(item, 'level', 'userLevel')),
        live: relation.live || status?.profile.live || false,
        online: relation.online || status?.profile.online || false,
        vip: integer(item, 'vip', 'vipFlag') > 0 || bool(item, 'isVip'),
        userType: relation.userType,
      }
    })
  }

  async checkPrivateMedia(
    privateIds: readonly number[],
  ): Promise<readonly PrivateMediaCheckResult[]> {
    const ids = [
      ...new Set(
        privateIds.filter((id) => Number.isSafeInteger(id) && id > 0).map((id) => Math.trunc(id)),
      ),
    ]
    if (!ids.length) return []
    const value = await this.request('/_v2/im/private/check', { privateIds: ids })
    return records(value)
      .map((item) => ({
        deleted: integer(item, 'del') === 1,
        locked: integer(item, 'lockStatus') !== 1,
        mediaUrl: text(item, 'privateUrl'),
        privateId: integer(item, 'privateId'),
      }))
      .filter((item) => ids.includes(item.privateId))
  }

  async refreshBalance(): Promise<number | undefined> {
    const value = asRecord(await this.request('/_v2/user/info')) ?? {}
    const balance = Number(
      value.diamondNum ?? value.diamondCount ?? value.diamond ?? value.userDiamond,
    )
    return Number.isFinite(balance) && balance >= 0 ? balance : undefined
  }

  async sendGift(imAccount: string, gift: GiftItem, count: number): Promise<GiftSendResult> {
    if (gift.source !== 'wallet') throw new Error('Backpack gifts are not available here.')
    const quantity = Math.max(1, Math.trunc(count))
    const value = await this.request('/_v2/discover/im/gift/send', {
      channelId: '',
      giftId: Number(gift.id),
      isFirst: 0,
      isPay: 0,
      num: quantity,
      yxAccid: imAccount,
    })
    const result = asRecord(value) ?? {}
    const balanceValue = Number(result.newBalance)
    return {
      ...(Number.isFinite(balanceValue) ? { balance: balanceValue } : {}),
      message: text(result, 'message'),
      success: bool(result, 'success'),
    }
  }

  async setFollowed(userId: string, followed: boolean): Promise<void> {
    const followUserId = Number(userId)
    if (!Number.isSafeInteger(followUserId) || followUserId <= 0) return
    await this.request('/_v2/user/followUser', {
      followType: followed ? 1 : 2,
      followUserId,
    })
  }

  async unlockPrivateMedia(recordId: number, privateId: number): Promise<void> {
    if (
      !Number.isSafeInteger(recordId) ||
      recordId <= 0 ||
      !Number.isSafeInteger(privateId) ||
      privateId <= 0
    )
      throw new Error('Private media identifiers are invalid.')
    await this.request('/_v2/im/private/unlock', { privateId, recordId })
  }

  private request(path: string, data: Record<string, unknown> = {}): Promise<unknown> {
    return getApiClient().request({
      authMode: 'required',
      data,
      method: 'POST',
      schema: rawSchema,
      url: path,
    })
  }
}

let repository: MessageRepository | undefined

export function getOpiMessageRepository(): MessageRepository {
  repository ??= new OpiMessageRepository()
  return repository
}

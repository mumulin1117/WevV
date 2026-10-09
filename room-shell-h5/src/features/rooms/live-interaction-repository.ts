import { getApiClient } from '@/core/auth/runtime'
import type { ApiClient } from '@/core/api/client'
import {
  resetProductServiceForTests,
  resolveProductService,
} from '@/core/product-mode/product-services'
import { z } from 'zod'
import type { RoomLaunchContext } from './contracts'
import type {
  LiveAnchorCard,
  LiveAnchorCardGift,
  LiveAnchorRankItem,
  LiveAudienceSnapshot,
  LiveBackpackGift,
  LiveGiftCategory,
  LiveGiftItem,
  LiveGiftSendResult,
  LiveInteractionRepository,
  LiveRankItem,
  LiveRankPeriod,
  LiveUserCardTarget,
  LiveWishItem,
} from './live-interaction-contracts'

const text = z
  .string()
  .nullish()
  .transform((value) => value?.trim() ?? '')
const identifier = z
  .union([z.string(), z.number().finite()])
  .nullish()
  .transform((value) => (value === null || value === undefined ? '' : String(value)))
const count = z
  .union([z.string(), z.number().finite()])
  .nullish()
  .transform((value) => Math.max(0, Math.trunc(Number(value ?? 0) || 0)))
const flag = z
  .union([z.boolean(), z.number(), z.string()])
  .nullish()
  .transform((value) => value === true || value === 1 || value === '1' || value === 'true')

const ROOM_CACHE_LIMIT = 64

export function liveGiftEffectUrl(...candidates: string[]): string {
  return (
    candidates.find((candidate) => {
      const normalized = candidate.trim().toLowerCase().split(/[?#]/u, 1)[0] ?? ''
      return normalized.endsWith('.svga') || normalized.endsWith('.mp4')
    }) ?? ''
  )
}

class MemoryLruCache<K, V> {
  private readonly values = new Map<K, V>()

  constructor(private readonly limit: number) {}

  get(key: K): V | undefined {
    const value = this.values.get(key)
    if (value === undefined) return undefined
    this.values.delete(key)
    this.values.set(key, value)
    return value
  }

  delete(key: K): void {
    this.values.delete(key)
  }

  set(key: K, value: V): void {
    this.values.delete(key)
    this.values.set(key, value)
    if (this.values.size <= this.limit) return
    const oldest = this.values.keys().next().value as K | undefined
    if (oldest !== undefined) this.values.delete(oldest)
  }
}

const audienceResponse = z.object({
  rows: z
    .array(
      z.object({
        countryId: text,
        icon: text,
        nickname: text,
        userId: identifier,
        userLevelName: text,
        vipFlag: flag,
      }),
    )
    .default([]),
  total: count,
})
const wishlistResponse = z.object({
  rows: z
    .array(
      z.object({
        completeGiftNum: count,
        giftId: identifier,
        giftName: text,
        giftNum: count,
        giftPrice: count,
        giftSmallImg: text,
      }),
    )
    .default([]),
})
const rankResponse = z.object({
  rows: z
    .array(
      z.object({
        costNum: count,
        icon: text,
        nickname: text,
        rank: count,
        userId: identifier,
        userLevel: text,
        vipFlag: flag,
      }),
    )
    .default([]),
})
const anchorWeekRankResponse = z.object({
  rows: z
    .array(
      z.object({
        costNum: count,
        followFlag: count,
        headFrame: text,
        icon: text,
        nickname: text,
        num: count,
        rank: count,
        userId: identifier,
        userLevelName: text,
        vipFlag: flag,
      }),
    )
    .default([]),
})
const giftResponse = z.object({
  rows: z
    .array(
      z.object({
        animUrl: text,
        giftImg: text,
        icon: text,
        id: z.coerce.number().int().positive(),
        name: text,
        price: count,
      }),
    )
    .default([]),
})
const fullGift = z.object({
  giftImg: text,
  giftPrice: count,
  giftSmallImg: text,
  id: z.coerce.number().int().positive(),
  name: text,
})
const giftCategoriesResponse = z.object({
  tabs: z
    .array(
      z.object({
        gifts: z.array(fullGift).default([]),
        isDefault: flag,
        tabCode: text,
        tabName: text,
        tabSort: count,
      }),
    )
    .default([]),
})
const weightedGiftResponse = z.object({
  giftList: z
    .object({
      rows: z.array(fullGift).default([]),
    })
    .default({ rows: [] }),
})
const backpackResponse = z.object({
  rows: z
    .array(
      z.object({
        giftIcon: text,
        giftId: z.coerce.number().int().positive(),
        giftName: text,
        giftPrice: count,
        giftSvga: text,
        quantity: count,
        remainingTimeDesc: text,
        sendable: flag,
      }),
    )
    .default([]),
})
const backpackSendResponse = z.object({
  message: text,
  success: z.boolean().default(false),
})
const giftSendResponse = z.object({
  message: text,
  newBalance: z
    .union([z.number(), z.string()])
    .nullish()
    .transform((value) => {
      if (value === null || value === undefined || value === '') return null
      const parsed = Number(value)
      return Number.isFinite(parsed) && parsed >= 0 ? parsed : null
    }),
  success: z.boolean().default(false),
})
const mineBalanceResponse = z.object({
  diamondNum: z
    .union([z.number(), z.string()])
    .nullish()
    .transform((value) => {
      const parsed = Number(value ?? Number.NaN)
      return Number.isFinite(parsed) && parsed >= 0 ? parsed : null
    }),
})
const cardGift = z.object({
  giftCount: count,
  giftId: identifier,
  giftImg: text,
  giftName: text,
  giftPrice: count,
})
const cardMedal = z.object({
  fontColor: text,
  medalId: identifier,
  medalImageUrl: text,
  medalName: text,
  medalStatus: count,
  medalWeight: count,
})
const anchorCardResponse = z.object({
  age: count,
  cardFrame: text,
  country: text,
  fans: count,
  follow: count,
  giftWalls: z.array(cardGift).default([]),
  headFrame: text,
  icon: text,
  isBlocked: flag,
  isFollow: flag,
  levelName: text,
  liveWelcome: text,
  medals: z.array(cardMedal).default([]),
  nickName: text,
  receiveGiftWalls: z.array(cardGift).default([]),
  sex: count,
  signature: text,
  userId: identifier,
  userType: count,
  vip: flag,
  yxAccid: text,
})

function mapGift(value: z.infer<typeof cardGift>): LiveAnchorCardGift {
  return {
    count: value.giftCount,
    iconUrl: value.giftImg,
    id: value.giftId,
    name: value.giftName || 'Gift',
    price: value.giftPrice,
  }
}

function mapAnchorCard(value: z.infer<typeof anchorCardResponse>): LiveAnchorCard {
  const anchor = value.userType === 2 || value.userType === 3
  return {
    age: value.age,
    avatarUrl: value.icon,
    blocked: value.isBlocked,
    cardFrameUrl: value.cardFrame,
    countryCode: value.country,
    fansCount: value.fans,
    followed: value.isFollow,
    followingCount: value.follow,
    gender: value.sex === 1 ? 'male' : value.sex === 2 ? 'female' : 'unknown',
    headFrameUrl: value.headFrame,
    id: value.userId,
    imAccount: value.yxAccid,
    levelName: value.levelName,
    medals: value.medals
      .sort((left, right) => right.medalWeight - left.medalWeight)
      .map((medal) => ({
        fontColor: medal.fontColor,
        iconUrl: medal.medalImageUrl,
        id: medal.medalId,
        name: medal.medalName,
        weight: medal.medalWeight,
      })),
    name: value.nickName || `User ${value.userId}`,
    receivedGifts: (anchor ? value.giftWalls : value.receiveGiftWalls).map(mapGift),
    sentGifts: (anchor ? value.receiveGiftWalls : value.giftWalls).map(mapGift),
    signature: value.liveWelcome || value.signature,
    vip: value.vip,
    userType: value.userType,
  }
}

interface UserCardRequestEntry {
  consumers: number
  controller: AbortController
  promise: Promise<LiveAnchorCard>
  settled: boolean
}

export class OpiLiveInteractionRepository implements LiveInteractionRepository {
  private activeAnchorCard: { hostId: string; value: LiveAnchorCard } | null = null
  private activeAnchorRequest: {
    epoch: number
    hostId: string
    promise: Promise<LiveAnchorCard>
  } | null = null
  private activeHostId = ''
  private anchorSessionEpoch = 0
  private readonly audiences = new MemoryLruCache<string, LiveAudienceSnapshot>(ROOM_CACHE_LIMIT)
  private readonly audienceRequests = new Map<string, Promise<LiveAudienceSnapshot>>()
  private anchorWeekRank: readonly LiveAnchorRankItem[] | null = null
  private anchorWeekRankRequest: Promise<readonly LiveAnchorRankItem[]> | null = null
  private gifts: readonly LiveGiftItem[] | null = null
  private giftCategories: { hostId: string; rows: readonly LiveGiftCategory[] } | null = null
  private quickGifts: { hostId: string; rows: readonly LiveGiftItem[] } | null = null
  private readonly ranks = new MemoryLruCache<string, readonly LiveRankItem[]>(ROOM_CACHE_LIMIT)
  private readonly rankRequests = new Map<string, Promise<readonly LiveRankItem[]>>()
  private readonly userCardRequests = new Map<string, UserCardRequestEntry>()
  private readonly wishlists = new MemoryLruCache<string, readonly LiveWishItem[]>(ROOM_CACHE_LIMIT)
  private readonly wishlistRequests = new Map<string, Promise<readonly LiveWishItem[]>>()

  constructor(private readonly api: Pick<ApiClient, 'request'> = getApiClient()) {}

  private requestOnce<T>(
    requests: Map<string, Promise<T>>,
    key: string,
    loader: () => Promise<T>,
  ): Promise<T> {
    const pending = requests.get(key)
    if (pending) return pending
    const task = loader().finally(() => {
      if (requests.get(key) === task) requests.delete(key)
    })
    requests.set(key, task)
    return task
  }

  private getOrCreateUserCardRequest(userId: number): UserCardRequestEntry {
    const key = String(userId)
    const pending = this.userCardRequests.get(key)
    if (pending) return pending

    const controller = new AbortController()
    const entry: UserCardRequestEntry = {
      consumers: 0,
      controller,
      promise: this.api
        .request({
          authMode: 'required',
          data: { userId },
          method: 'POST',
          schema: anchorCardResponse,
          signal: controller.signal,
          timeout: 30_000,
          url: '/_v2/user/personalCard',
        })
        .then(mapAnchorCard),
      settled: false,
    }
    entry.promise = entry.promise.finally(() => {
      entry.settled = true
      if (this.userCardRequests.get(key) === entry) this.userCardRequests.delete(key)
    })
    this.userCardRequests.set(key, entry)
    return entry
  }

  private consumeUserCardRequest(userId: number, signal?: AbortSignal): Promise<LiveAnchorCard> {
    const key = String(userId)
    const entry = this.getOrCreateUserCardRequest(userId)
    entry.consumers += 1

    return new Promise<LiveAnchorCard>((resolve, reject) => {
      let released = false
      const release = (): boolean => {
        if (released) return false
        released = true
        signal?.removeEventListener('abort', onAbort)
        entry.consumers = Math.max(0, entry.consumers - 1)
        if (!entry.settled && entry.consumers === 0) {
          if (this.userCardRequests.get(key) === entry) this.userCardRequests.delete(key)
          entry.controller.abort('profile-card-unused')
        }
        return true
      }
      const onAbort = (): void => {
        if (release()) reject(new DOMException('Aborted', 'AbortError'))
      }

      if (signal?.aborted) {
        onAbort()
        return
      }
      signal?.addEventListener('abort', onAbort, { once: true })
      entry.promise.then(
        (card) => {
          if (release()) resolve(card)
        },
        (cause: unknown) => {
          if (release()) reject(cause)
        },
      )
    })
  }

  beginSession(context: RoomLaunchContext): void {
    this.anchorSessionEpoch += 1
    this.activeHostId = String(context.hostId ?? '')
    this.activeAnchorCard = null
    this.activeAnchorRequest = null
    this.giftCategories = null
    this.quickGifts = null
  }

  endSession(context: RoomLaunchContext): void {
    if (String(context.hostId ?? '') !== this.activeHostId) return
    this.anchorSessionEpoch += 1
    this.activeHostId = ''
    this.activeAnchorCard = null
    this.activeAnchorRequest = null
    this.giftCategories = null
    this.quickGifts = null
  }

  peekAnchorCard(hostId: string): LiveAnchorCard | null {
    return this.activeAnchorCard?.hostId === hostId ? this.activeAnchorCard.value : null
  }

  peekAudience(roomId: string): LiveAudienceSnapshot | null {
    return this.audiences.get(roomId) ?? null
  }

  peekAnchorWeekRank(): readonly LiveAnchorRankItem[] | null {
    return this.anchorWeekRank
  }

  peekGifts(): readonly LiveGiftItem[] | null {
    return this.gifts
  }

  async getGifts(signal?: AbortSignal): Promise<readonly LiveGiftItem[]> {
    const response = await this.api.request({
      authMode: 'required',
      data: {},
      method: 'POST',
      schema: giftResponse,
      signal,
      url: '/_v2/discover/live/gift/list',
    })
    const rows = response.rows.map<LiveGiftItem>((gift) => ({
      effectUrl: liveGiftEffectUrl(gift.giftImg, gift.animUrl),
      iconUrl: gift.icon,
      id: gift.id,
      name: gift.name || 'Gift',
      price: gift.price,
    }))
    this.gifts = rows
    return rows
  }

  async getGiftCategories(
    context: RoomLaunchContext,
    signal?: AbortSignal,
  ): Promise<readonly LiveGiftCategory[]> {
    const hostId = String(context.hostId ?? '')
    if (this.giftCategories?.hostId === hostId) return this.giftCategories.rows
    const response = await this.api.request({
      authMode: 'required',
      data: { anchorId: Number(context.hostId), scene: 'LIVE' },
      method: 'POST',
      schema: giftCategoriesResponse,
      signal,
      url: '/_v2/gift/list-v4',
    })
    const rows = response.tabs.map<LiveGiftCategory>((tab) => ({
      code: tab.tabCode || String(tab.tabSort),
      gifts: tab.gifts.map((gift) => ({
        effectUrl: liveGiftEffectUrl(gift.giftImg),
        iconUrl: gift.giftSmallImg || gift.giftImg,
        id: gift.id,
        name: gift.name || 'Gift',
        price: gift.giftPrice,
      })),
      name: tab.tabName || tab.tabCode || 'Gifts',
    }))
    if (this.activeHostId === hostId) this.giftCategories = { hostId, rows }
    return rows
  }

  async getBackpackGifts(
    context: RoomLaunchContext,
    signal?: AbortSignal,
  ): Promise<readonly LiveBackpackGift[]> {
    const response = await this.api.request({
      authMode: 'required',
      data: { page: 1, pageSize: 100, scene: 'LIVE_ROOM' },
      method: 'POST',
      schema: backpackResponse,
      signal,
      url: '/_v2/gift/backpack/list',
    })
    return response.rows.map((gift) => ({
      effectUrl: liveGiftEffectUrl(gift.giftSvga),
      iconUrl: gift.giftIcon,
      id: gift.giftId,
      name: gift.giftName || 'Gift',
      price: gift.giftPrice,
      quantity: gift.quantity,
      remainingTimeDescription: gift.remainingTimeDesc,
      sendable: gift.sendable,
    }))
  }

  async getQuickGifts(
    context: RoomLaunchContext,
    signal?: AbortSignal,
  ): Promise<readonly LiveGiftItem[]> {
    const hostId = String(context.hostId ?? '')
    if (this.quickGifts?.hostId === hostId) return this.quickGifts.rows
    const response = await this.api.request({
      authMode: 'required',
      data: { anchorUserId: Number(context.hostId) },
      method: 'POST',
      schema: weightedGiftResponse,
      signal,
      url: '/_v2/gift/list-by-weight',
    })
    const rows = response.giftList.rows.map((gift) => ({
      effectUrl: liveGiftEffectUrl(gift.giftImg),
      iconUrl: gift.giftSmallImg || gift.giftImg,
      id: gift.id,
      name: gift.name || 'Gift',
      price: gift.giftPrice,
    }))
    if (this.activeHostId === hostId) this.quickGifts = { hostId, rows }
    return rows
  }

  async sendGift(
    context: RoomLaunchContext,
    giftId: number,
    quantity: number,
    pkActive = false,
    signal?: AbortSignal,
  ): Promise<LiveGiftSendResult> {
    const result = await this.api.request({
      authMode: 'required',
      data: {
        anchorYxAccid: context.hostImAccount ?? '',
        giftId,
        num: quantity,
        pkState: pkActive ? 1 : 0,
        roomId: Number(context.roomId),
      },
      method: 'POST',
      schema: giftSendResponse,
      signal,
      url: '/_v2/discover/live/gift/send',
    })
    if (result.success) {
      if (this.activeAnchorCard?.hostId === String(context.hostId)) this.activeAnchorCard = null
      this.ranks.delete(`${context.roomId}:now`)
    }
    return result
  }

  async sendBackpackGift(
    context: RoomLaunchContext,
    giftId: number,
    quantity: number,
    pkActive = false,
    signal?: AbortSignal,
  ): Promise<LiveGiftSendResult> {
    const response = await this.api.request({
      authMode: 'required',
      data: {
        giftId,
        liveRoomId: Number(context.roomId),
        num: quantity,
        pkState: pkActive ? 1 : 0,
        scene: 'LIVE_ROOM',
        yxAccidList: [context.hostImAccount ?? ''],
      },
      method: 'POST',
      schema: backpackSendResponse,
      signal,
      url: '/_v2/gift/backpack/send',
    })
    return { message: response.message, newBalance: null, success: response.success }
  }

  async refreshBalance(signal?: AbortSignal): Promise<number | null> {
    const response = await this.api.request({
      authMode: 'required',
      data: {},
      method: 'POST',
      schema: mineBalanceResponse,
      signal,
      url: '/_v2/user/info',
    })
    return response.diamondNum
  }

  peekRank(roomId: string, period: LiveRankPeriod): readonly LiveRankItem[] | null {
    return this.ranks.get(`${roomId}:${period}`) ?? null
  }

  peekWishlist(roomId: string): readonly LiveWishItem[] | null {
    return this.wishlists.get(roomId) ?? null
  }

  async getAudience(
    context: RoomLaunchContext,
    signal?: AbortSignal,
  ): Promise<LiveAudienceSnapshot> {
    return this.requestOnce(this.audienceRequests, context.roomId, async () => {
      const response = await this.api.request({
        authMode: 'required',
        data: { roomId: Number(context.roomId) },
        method: 'POST',
        schema: audienceResponse,
        signal,
        url: '/_v2/discover/live/audience',
      })
      const snapshot: LiveAudienceSnapshot = {
        rows: response.rows.map((member) => ({
          avatarUrl: member.icon,
          countryCode: member.countryId,
          displayName: member.nickname || 'User',
          id: member.userId,
          levelName: member.userLevelName,
          vip: member.vipFlag,
        })),
        total: response.total,
      }
      this.audiences.set(context.roomId, snapshot)
      return snapshot
    })
  }

  async getAnchorWeekRank(
    _context: RoomLaunchContext,
    signal?: AbortSignal,
  ): Promise<readonly LiveAnchorRankItem[]> {
    if (this.anchorWeekRankRequest) return this.anchorWeekRankRequest
    const task = this.api
      .request({
        authMode: 'required',
        data: { boardType: 'charm', period: 'week' },
        method: 'POST',
        schema: anchorWeekRankResponse,
        signal,
        url: '/_v2/discover/user/rank',
      })
      .then((response) => {
        const rows = response.rows
          .filter((item) => Boolean(item.userId && item.userId !== '0'))
          .map<LiveAnchorRankItem>((item, index) => ({
            avatarUrl: item.icon,
            cost: Math.max(item.num, item.costNum),
            followed: item.followFlag === 1,
            headFrameUrl: item.headFrame,
            id: item.userId,
            levelName: item.userLevelName,
            name: item.nickname || `User ${item.userId}`,
            rank: item.rank > 0 ? item.rank : index + 1,
            vip: item.vipFlag,
          }))
        this.anchorWeekRank = rows
        return rows
      })
      .finally(() => {
        if (this.anchorWeekRankRequest === task) this.anchorWeekRankRequest = null
      })
    this.anchorWeekRankRequest = task
    return task
  }

  async getWishlist(
    context: RoomLaunchContext,
    signal?: AbortSignal,
  ): Promise<readonly LiveWishItem[]> {
    return this.requestOnce(this.wishlistRequests, context.roomId, async () => {
      const response = await this.api.request({
        authMode: 'required',
        data: { roomId: Number(context.roomId) },
        method: 'POST',
        schema: wishlistResponse,
        signal,
        url: '/_v2/discover/live/wishlist',
      })
      const rows = response.rows.map<LiveWishItem>((item) => ({
        completed: Math.min(item.completeGiftNum, item.giftNum),
        giftId: item.giftId,
        iconUrl: item.giftSmallImg,
        name: item.giftName || 'Gift',
        price: item.giftPrice,
        target: item.giftNum,
      }))
      this.wishlists.set(context.roomId, rows)
      return rows
    })
  }

  async getRank(
    context: RoomLaunchContext,
    period: LiveRankPeriod,
    signal?: AbortSignal,
  ): Promise<readonly LiveRankItem[]> {
    const key = `${context.roomId}:${period}`
    return this.requestOnce(this.rankRequests, key, async () => {
      const response = await this.api.request({
        authMode: 'required',
        data: { rankType: period, roomId: Number(context.roomId) },
        method: 'POST',
        schema: rankResponse,
        signal,
        url: '/_v2/discover/live/rank',
      })
      const rows = response.rows.map<LiveRankItem>((item, index) => ({
        avatarUrl: item.icon,
        cost: item.costNum,
        id: item.userId,
        levelName: item.userLevel,
        name: item.nickname || 'User',
        rank: item.rank > 0 ? item.rank : index + 1,
        vip: Boolean(item.vipFlag),
      }))
      this.ranks.set(key, rows)
      return rows
    })
  }

  async getAnchorCard(context: RoomLaunchContext, signal?: AbortSignal): Promise<LiveAnchorCard> {
    const key = String(context.hostId)
    const cached = this.peekAnchorCard(key)
    if (cached) return cached
    const active = this.activeAnchorRequest
    if (active?.hostId === key) return active.promise
    const epoch = this.anchorSessionEpoch
    const request = this.api
      .request({
        authMode: 'required',
        data: { userId: Number(context.hostId) },
        method: 'POST',
        schema: anchorCardResponse,
        signal,
        timeout: 30_000,
        url: '/_v2/user/personalCard',
      })
      .then((response) => {
        const card = mapAnchorCard(response)
        if (this.anchorSessionEpoch === epoch && this.activeHostId === key)
          this.activeAnchorCard = { hostId: key, value: card }
        return card
      })
      .finally(() => {
        if (this.activeAnchorRequest?.promise === request) this.activeAnchorRequest = null
      })
    this.activeAnchorRequest = { epoch, hostId: key, promise: request }
    return request
  }

  async getUserCard(target: LiveUserCardTarget, signal?: AbortSignal): Promise<LiveAnchorCard> {
    const numericUserId = Number(target.id)
    if (!Number.isSafeInteger(numericUserId) || numericUserId <= 0)
      throw new Error('Invalid profile-card user id.')
    const card = await this.consumeUserCardRequest(numericUserId, signal)
    if (card.id && card.id !== target.id)
      throw new Error('The profile-card response belongs to another user.')
    return {
      ...card,
      avatarUrl: card.avatarUrl || target.avatarUrl,
      id: card.id || target.id,
      imAccount: card.imAccount || target.imAccount || '',
      name: card.name || target.name,
      userType: card.userType || target.userType || 0,
    }
  }

  async reportEntryEffect(context: RoomLaunchContext, signal?: AbortSignal): Promise<void> {
    const anchorUserId = Number(context.hostId)
    if (!Number.isSafeInteger(anchorUserId) || anchorUserId <= 0) return
    await this.api.request({
      authMode: 'required',
      data: { anchorUserId },
      method: 'POST',
      signal,
      url: '/_v2/discover/live/openEffect',
    })
  }

  async setFollowed(context: RoomLaunchContext, followed: boolean): Promise<void> {
    await this.api.request({
      authMode: 'required',
      data: { followType: followed ? 1 : 2, followUserId: Number(context.hostId) },
      method: 'POST',
      url: '/_v2/user/followUser',
    })
    const key = String(context.hostId)
    const cached = this.peekAnchorCard(key)
    if (cached) this.activeAnchorCard = { hostId: key, value: { ...cached, followed } }
  }
}

export function getLiveInteractionRepository(): LiveInteractionRepository {
  return resolveProductService<LiveInteractionRepository>('live-interaction', {
    remote: () => new OpiLiveInteractionRepository(),
  })
}

export function resetLiveInteractionRepositoryForTests(): void {
  resetProductServiceForTests('live-interaction')
}

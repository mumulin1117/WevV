import type { RoomLaunchContext } from './contracts'

export interface LiveAudienceMember {
  avatarUrl: string
  countryCode: string
  displayName: string
  id: string
  levelName: string
  vip: boolean
  userType?: number
}

export interface LiveAudienceSnapshot {
  rows: readonly LiveAudienceMember[]
  total: number
}

export type LiveRankPeriod = 'now' | 'today' | 'week'

export interface LiveRankItem {
  avatarUrl: string
  cost: number
  id: string
  levelName: string
  name: string
  rank: number
  vip: boolean
  userType?: number
}

export interface LiveAnchorRankItem {
  avatarUrl: string
  cost: number
  followed: boolean
  headFrameUrl: string
  id: string
  levelName: string
  name: string
  rank: number
  vip: boolean
}

export interface LiveWishItem {
  completed: number
  giftId: string
  iconUrl: string
  name: string
  price: number
  target: number
}

export interface LiveGiftItem {
  effectUrl: string
  iconUrl: string
  id: number
  name: string
  price: number
}

export interface LiveGiftCategory {
  code: string
  gifts: readonly LiveGiftItem[]
  name: string
}

export interface LiveBackpackGift extends LiveGiftItem {
  quantity: number
  remainingTimeDescription: string
  sendable: boolean
}

export interface LiveGiftSendResult {
  message: string
  newBalance: number | null
  success: boolean
}

export interface LiveAnchorCardGift {
  count: number
  iconUrl: string
  id: string
  name: string
  price: number
}

export interface LiveAnchorCardMedal {
  fontColor: string
  iconUrl: string
  id: string
  name: string
  weight: number
}

export interface UserProfileCard {
  age: number
  avatarUrl: string
  blocked: boolean
  cardFrameUrl: string
  countryCode: string
  fansCount: number
  followed: boolean
  followingCount: number
  gender: 'female' | 'male' | 'unknown'
  headFrameUrl: string
  id: string
  imAccount: string
  levelName: string
  medals: readonly LiveAnchorCardMedal[]
  name: string
  receivedGifts: readonly LiveAnchorCardGift[]
  sentGifts: readonly LiveAnchorCardGift[]
  signature: string
  vip: boolean
  userType: number
}

export type LiveAnchorCard = UserProfileCard

export interface UserProfileCardTarget {
  avatarUrl: string
  id: string
  imAccount?: string
  name: string
  userType?: number
}

export type LiveUserCardTarget = UserProfileCardTarget

export interface LiveInteractionRepository {
  beginSession: (context: RoomLaunchContext) => void
  endSession: (context: RoomLaunchContext) => void
  getAnchorCard: (context: RoomLaunchContext, signal?: AbortSignal) => Promise<LiveAnchorCard>
  getUserCard: (target: LiveUserCardTarget, signal?: AbortSignal) => Promise<LiveAnchorCard>
  getAudience: (context: RoomLaunchContext, signal?: AbortSignal) => Promise<LiveAudienceSnapshot>
  getAnchorWeekRank: (
    context: RoomLaunchContext,
    signal?: AbortSignal,
  ) => Promise<readonly LiveAnchorRankItem[]>
  getBackpackGifts: (
    context: RoomLaunchContext,
    signal?: AbortSignal,
  ) => Promise<readonly LiveBackpackGift[]>
  getGiftCategories: (
    context: RoomLaunchContext,
    signal?: AbortSignal,
  ) => Promise<readonly LiveGiftCategory[]>
  getGifts: (signal?: AbortSignal) => Promise<readonly LiveGiftItem[]>
  getQuickGifts: (
    context: RoomLaunchContext,
    signal?: AbortSignal,
  ) => Promise<readonly LiveGiftItem[]>
  getRank: (
    context: RoomLaunchContext,
    period: LiveRankPeriod,
    signal?: AbortSignal,
  ) => Promise<readonly LiveRankItem[]>
  getWishlist: (
    context: RoomLaunchContext,
    signal?: AbortSignal,
  ) => Promise<readonly LiveWishItem[]>
  peekAnchorCard: (hostId: string) => LiveAnchorCard | null
  peekAudience: (roomId: string) => LiveAudienceSnapshot | null
  peekAnchorWeekRank: () => readonly LiveAnchorRankItem[] | null
  peekGifts: () => readonly LiveGiftItem[] | null
  peekRank: (roomId: string, period: LiveRankPeriod) => readonly LiveRankItem[] | null
  peekWishlist: (roomId: string) => readonly LiveWishItem[] | null
  reportEntryEffect: (context: RoomLaunchContext, signal?: AbortSignal) => Promise<void>
  refreshBalance: (signal?: AbortSignal) => Promise<number | null>
  sendGift: (
    context: RoomLaunchContext,
    giftId: number,
    quantity: number,
    pkActive?: boolean,
    signal?: AbortSignal,
  ) => Promise<LiveGiftSendResult>
  sendBackpackGift: (
    context: RoomLaunchContext,
    giftId: number,
    quantity: number,
    pkActive?: boolean,
    signal?: AbortSignal,
  ) => Promise<LiveGiftSendResult>
  setFollowed: (context: RoomLaunchContext, followed: boolean) => Promise<void>
}

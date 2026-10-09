import type { CursorPage } from '@/core/api/types'
import type { LivePkDetail } from './live-pk-contracts'

export interface RoomLaunchContext {
  announcement?: string
  appId: string
  audience?: readonly RoomAudience[]
  channelName: string
  chatRoomId?: string
  coverUrl?: string
  countryCode?: string
  description?: string
  displayName: string
  expiresAt?: number
  hostAvatarUrl?: string
  hostId?: string
  hostImAccount?: string
  hostLevelName?: string
  hostUserType?: number
  hostHeadFrameUrl?: string
  followed?: boolean
  followPromptDelaySeconds?: number
  hotScore?: number
  initialChatMessages?: readonly {
    avatarUrl: string
    createdAt: number
    id: string
    nickname: string
    text: string
    userId: string
  }[]
  mode: 'live' | 'voice'
  onlineCount?: number
  partyOpenPath?: string
  /** Direct media source used by a room-media adapter; absent for RTC-backed rooms. */
  playbackUrl?: string
  pkId?: string
  pkDetail?: LivePkDetail
  pkStatus?: number
  role: 'host' | 'cohost' | 'audience'
  roomId: string
  rtmToken?: string
  rtcToken: string
  currentAnchorRank?: number
  currentLiveIncome?: number
  topGiver?: {
    avatarUrl: string
    cost: number
    id: string
  }
  uid: number
  weekIncome?: number
  /** Initial live-room interaction wheel state from the room detail snapshot. */
  wheelEnabled?: boolean
}

export type LiveDiscoveryFilter = 'all' | 'follow' | 'live' | 'new'

export interface LiveDiscoveryQuery {
  countryIds?: string
  tagId?: string
}
export type AnchorAvailability = 'busy' | 'offline' | 'online'
export type AnchorPresence = 'available' | 'live' | 'voice'

/**
 * 首页发现墙统一领域模型。Remote 与 Local 必须先映射到此结构，页面不能读取接口私有字段。
 */
export interface LiveDiscoveryItem {
  age: number
  availability: AnchorAvailability
  countryCode: string
  cursorId: string
  followed: boolean
  gender: 'female' | 'male' | 'unknown'
  host: {
    avatarUrl: string
    displayName: string
    id: string
    imAccount: string
  }
  levelName: string
  liveRoomId?: string
  liveStateObservedAt?: number
  onlineCount: number
  pk: boolean
  presence: AnchorPresence
  vip: boolean
  voiceRoomId?: string
}

export type HomeRankBoard = 'charm' | 'couple' | 'wealth'
export type HomeRankPeriod = 'day' | 'week'

export interface HomeRankItem {
  age: number
  avatarUrl: string
  countryCode: string
  followed: boolean
  headFrameUrl: string
  id: string
  imAccount: string
  levelName: string
  name: string
  partnerAvatarUrl?: string
  partnerHeadFrameUrl?: string
  partnerId?: string
  partnerImAccount?: string
  partnerName?: string
  partnerUserType?: number
  rank: number
  score: number
  vip: boolean
  userType: number
}

export interface AnchorProfileMedia {
  coverUrl: string
  duration: string
  id: string
  title: string
  type: 'photo' | 'video'
  url: string
}

export interface AnchorProfileGift {
  count: number
  iconUrl: string
  id: string
  name: string
}

export interface AnchorProfileHonor {
  iconUrl: string
  id: string
  name: string
  type: 'badge' | 'frame' | 'vehicle'
}

export interface AnchorProfileMoment {
  avatarUrl: string
  commentCount: number
  createdAt: string
  id: string
  images: string[]
  liked: boolean
  likeCount: number
  name: string
  text: string
}

export interface AnchorProfileComment {
  avatarUrl: string
  children: AnchorProfileComment[]
  content: string
  createdAt: string
  id: string
  name: string
  parentId?: string
  userId: string
}

export interface AnchorProfile {
  age: number
  avatarUrl: string
  blocked: boolean
  countryCode: string
  description: string
  followed: boolean
  followersCount: number
  followingCount: number
  gender: 'female' | 'male' | 'unknown'
  gifts: AnchorProfileGift[]
  honors: AnchorProfileHonor[]
  id: string
  imAccount: string
  languages: string[]
  levelName: string
  likeCount: number
  likeRate: number | null
  liveRoomId?: string
  media: AnchorProfileMedia[]
  moments: AnchorProfileMoment[]
  name: string
  signature: string
  status: AnchorAvailability
  videos: AnchorProfileMedia[]
  voiceRoomId?: string
  userType: number
}

export interface AnchorProfileRepository {
  blockUser: (userId: string, signal?: AbortSignal) => Promise<void>
  commentMoment: (
    momentId: string,
    content: string,
    parentCommentId?: string,
    signal?: AbortSignal,
  ) => Promise<void>
  getMomentComments: (
    momentId: string,
    page: number,
    pageSize: number,
    signal?: AbortSignal,
  ) => Promise<readonly AnchorProfileComment[]>
  getProfile: (userId: string, imAccount?: string, signal?: AbortSignal) => Promise<AnchorProfile>
  setMomentLiked: (momentId: string, liked: boolean, signal?: AbortSignal) => Promise<void>
  setFollowed: (userId: string, followed: boolean, signal?: AbortSignal) => Promise<void>
}

export interface RoomAudience {
  avatarUrl: string
  displayName: string
  id: string
  vip: boolean
}

export interface RoomSummary {
  announcement?: string
  coverUrl: string
  currentAnchorRank?: number
  currentLiveIncome?: number
  cursorId: string
  followed?: boolean
  followPromptDelaySeconds?: number
  hotScore?: number
  host: {
    avatarUrl: string
    displayName: string
    id: string
    imAccount?: string
  }
  hostHeadFrameUrl?: string
  id: string
  /** 最近一次由“正在直播”列表/推送确认的时间，仅用于缩短进房前置校验。 */
  liveStateObservedAt?: number
  mode: 'live' | 'voice'
  onlineCount: number
  topGiver?: {
    avatarUrl: string
    cost: number
    id: string
  }
  title: string
  weekIncome?: number
}

export type RoomLaunchEnrichment = Pick<
  RoomLaunchContext,
  | 'announcement'
  | 'currentAnchorRank'
  | 'currentLiveIncome'
  | 'followPromptDelaySeconds'
  | 'hostHeadFrameUrl'
  | 'hotScore'
  | 'topGiver'
  | 'weekIncome'
>

export interface RoomRepository {
  createLaunchContext: (
    room: RoomSummary,
    audienceUserId: string,
    role: RoomLaunchContext['role'],
    signal?: AbortSignal,
  ) => Promise<RoomLaunchContext>
  getRooms: (
    mode: RoomSummary['mode'],
    cursor?: string,
    signal?: AbortSignal,
    requestedPageSize?: number,
  ) => Promise<CursorPage<RoomSummary>>
}

export interface LiveRepository {
  createLaunchContext: RoomRepository['createLaunchContext']
  isRoomAlive: (channelId: string, signal?: AbortSignal) => Promise<boolean | null>
}

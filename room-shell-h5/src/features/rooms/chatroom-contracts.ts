import type { RealtimeCredential } from '@/core/realtime/contracts'
import type { LivePkPush } from './live-pk-contracts'

export type { LivePkPush }

export type ChatroomConnectionState =
  'closed' | 'connected' | 'connecting' | 'failed' | 'kicked' | 'reconnecting'

export type ChatroomMessageState = 'failed' | 'received' | 'sending' | 'sent'

export interface LiveGiftReceiver {
  avatarUrl: string
  id: string
  name: string
}

export interface LiveChatMessage {
  activityType?: 'lucky-number-draw' | 'lucky-number-win' | 'wheel-result'
  avatarUrl: string
  chatBubbleUrl?: string
  createdAt: number
  entryItemUrl?: string
  giftCount?: number
  giftEffectUrl?: string
  giftId?: string
  giftIconUrl?: string
  giftName?: string
  giftReceiverIds?: string[]
  giftReceivers?: LiveGiftReceiver[]
  giftType?: number
  giftMysteryBox?: boolean
  giftCost?: number
  giftValue?: number
  guardianLevel?: number
  host?: boolean
  id: string
  kind: 'activity' | 'announcement' | 'enter' | 'gift' | 'text'
  luckyNumber?: number
  mentionCurrentUser?: boolean
  medalUrls?: string[]
  newUser?: boolean
  nickname: string
  own: boolean
  platformAdmin?: boolean
  roomRole?: 1 | 2 | 3
  senderHeadFrameUrl?: string
  senderId: string
  state: ChatroomMessageState
  text: string
  userId?: string
  userLevel?: number
  userType?: number
  vip?: boolean
  wheelAnchorId?: string
  wheelIncome?: number
  wheelPrice?: number
  wheelSectorCount?: number
}

export interface LiveWheelSignal {
  anchorId: string
  enabled: boolean
}

export interface LiveWheelResultMessage {
  anchorId: string
  incomeDiamondNum: number
  number: number
  text: string
  dia: number
}

export interface LiveEntryEffect {
  avatarUrl: string
  effectUrl?: string
  guardianLevel?: number
  id: string
  nickname: string
  priority: number
  style: 'entrance' | 'guardian' | 'high-level' | 'vehicle'
  userId: string
  userLevel: number
  vip: boolean
}

export interface LiveRoomMetricsPatch {
  hotScore?: number
  incomeDelta?: number
  incomeTotal?: number
  topGiver?: {
    avatarUrl: string
    cost: number
    id: string
  } | null
  wish?: {
    completed: number
    giftId: string
  }
}

export interface ChatroomSdkMessage {
  attachment?: {
    messageClientId?: string
    notificationExtension?: string
    operatorId?: string
    operatorNick?: string
    raw?: unknown
    targetIds?: string[]
    targetNicks?: string[]
    type?: number
  }
  createTime: number
  isPlatformAdmin?: boolean
  isSelf: boolean
  messageClientId: string
  messageType: number
  roomId: string
  senderId: string
  serverExtension?: string
  text?: unknown
  userInfoConfig?: {
    senderAvatar?: string
    senderNick?: string
  }
}

export interface ChatroomSdkService {
  getMessageList: (options: {
    beginTime: number
    direction: 0 | 1
    limit: number
    messageTypes: number[]
  }) => Promise<ChatroomSdkMessage[]>
  off: (event: string, listener?: (...args: unknown[]) => void) => void
  on: (event: string, listener: (...args: unknown[]) => void) => void
  sendMessage: (message: ChatroomSdkMessage) => Promise<{ message: ChatroomSdkMessage }>
}

export interface ChatroomSdkClient {
  V2NIMChatroomMessageCreator: {
    createCustomMessage?: (rawAttachment: string) => ChatroomSdkMessage
    createTextMessage: (text: string) => ChatroomSdkMessage
  }
  V2NIMChatroomService: ChatroomSdkService
  enter: (
    roomId: string,
    options: {
      accountId: string
      linkProvider: () => Promise<string[]>
      notificationExtension?: string
      roomAvatar?: string
      roomNick?: string
      serverExtension?: string
      tagConfig?: { notifyTargetTags?: string; tags: string[] }
      token: string
    },
  ) => Promise<{ chatroom: { chatBanned?: boolean; onlineUserCount: number } }>
  exit: () => void | Promise<void>
  off: (event: string, listener?: (...args: unknown[]) => void) => void
  on: (event: string, listener: (...args: unknown[]) => void) => void
}

export interface ChatroomRuntime {
  createClient: () => ChatroomSdkClient
  getLinkAddresses: (roomId: string) => Promise<string[]>
  login: (credential: RealtimeCredential) => Promise<void>
  setAppVisible: (visible: boolean) => void
}

export interface LiveChatroomConnectInput {
  announcementText?: string
  credential: RealtimeCredential
  excludeHostFromOnlineCount?: boolean
  historyLimit?: number
  hostImAccount?: string
  initialOnlineCount: number
  messageLimit?: number
  messageTrimCount?: number
  roomId: string
  user: {
    avatarUrl: string
    displayName: string
    id: string
    isVip?: boolean
    userLevel?: string
  }
  welcomeMessage?: {
    avatarUrl: string
    nickname: string
    senderId: string
    text: string
  }
  tags?: string[]
}

export interface ChatroomTextContext {
  isPlatformAdmin?: boolean
  role?: 1 | 2 | 3
}

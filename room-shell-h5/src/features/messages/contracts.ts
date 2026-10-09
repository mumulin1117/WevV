export type MessageDeliveryState = 'failed' | 'sending' | 'sent'
export type MessageKind = 'audio' | 'gift' | 'image' | 'private-media' | 'system' | 'text'

export interface AudioMessageInfo {
  durationMs: number
  url: string
}

export type PrivateMediaType = 'image' | 'video'
export type PrivateMediaStatus =
  'checking' | 'expired' | 'locked' | 'unavailable' | 'unlocked' | 'unlocking' | 'verify-pending'

export interface PrivateMediaInfo {
  coverUrl: string
  giftIconUrl: string
  mediaType: PrivateMediaType
  mediaUrl?: string
  price: number
  privateId: number
  qualityBadgeUrl?: string
  recordId: number
  status: PrivateMediaStatus
}

export interface PrivateMediaCheckResult {
  deleted: boolean
  locked: boolean
  mediaUrl: string
  privateId: number
}

export type PrivateMediaUnlockOutcome = 'insufficient' | 'pending' | 'unlocked'

export interface MessageProfile {
  avatarUrl: string
  displayName: string
  followed: boolean
  imAccount: string
  live: boolean
  online: boolean
  signature: string
  userId: string
  userType: number
}

export interface InboxMessage {
  attachmentUrl?: string
  audio?: AudioMessageInfo
  conversationId: string
  createdAt: number
  delivery: MessageDeliveryState
  gift?: GiftItem & { count: number }
  id: string
  kind: MessageKind
  own: boolean
  privateMedia?: PrivateMediaInfo
  raw?: unknown
  senderId: string
  text: string
}

export interface InboxConversation {
  avatarUrl: string
  conversationId: string
  displayName: string
  imAccount: string
  latest: InboxMessage | null
  muted: boolean
  online: boolean
  sortTime: number
  unread: number
  userId: string
}

export interface ConversationTarget {
  avatarUrl: string
  conversationId: string
  displayName: string
  imAccount: string
  userId: string
}

export interface MessagePage<T> {
  finished: boolean
  hiddenIds?: readonly string[]
  items: readonly T[]
  nextCursor: string
}

export interface OnlineHost extends MessageProfile {
  age: number
  liveRoomId?: string
  status: 'busy' | 'online'
}

export interface RelationUser extends MessageProfile {
  age: number
  countryId: string
  gender: number
  level: number
  vip: boolean
}

export interface CustomerAgent {
  avatarUrl: string
  displayName: string
  imAccount: string
  online: boolean
}

export interface CustomerProblem {
  category: string
  id: string
  operation: 'copy' | 'default' | 'page'
  operationContent: string
  reply: string
  title: string
}

export interface GiftItem {
  animationUrl: string
  category?: string
  partyGiftType?: number
  partyMysteryBox?: boolean
  iconUrl: string
  id: string
  name: string
  price: number
  quantity?: number
  remainingTime?: string
  sendable?: boolean
  source: 'backpack' | 'wallet'
}

export interface GiftCatalog {
  balance?: number
  gifts: readonly GiftItem[]
}

export interface GiftSendResult {
  balance?: number
  message?: string
  remainingQuantity?: number
  success: boolean
}

export type MessageGatewayEvent =
  | { conversation: InboxConversation; type: 'conversation' }
  | { conversationIds: readonly string[]; type: 'conversations-deleted' }
  | { message: InboxMessage; type: 'message' }
  | { type: 'sync' }
  | { total: number; type: 'unread' }

export interface MessageGateway {
  clearAllUnread(): Promise<void>
  connect(): Promise<void>
  connectionState(): 'connected' | 'connecting' | 'disconnected'
  conversationIdFor(imAccount: string): Promise<string>
  deleteAllConversations(): Promise<readonly string[]>
  deleteConversation(conversationId: string): Promise<void>
  deleteConversations(conversationIds: readonly string[]): Promise<void>
  disconnect(): Promise<void>
  listConversations(cursor?: string, limit?: number): Promise<MessagePage<InboxConversation>>
  listMessages(
    conversationId: string,
    cursor?: string,
    limit?: number,
  ): Promise<MessagePage<InboxMessage>>
  markRead(conversationId: string): Promise<void>
  observe(listener: (event: MessageGatewayEvent) => void): () => void
  sendImage(conversationId: string, file: File): Promise<InboxMessage>
  sendText(conversationId: string, text: string): Promise<InboxMessage>
  setVisible(visible: boolean): void
}

export interface MessageRepository {
  batchProfiles(accounts: readonly string[]): Promise<readonly MessageProfile[]>
  getCustomerAgents(): Promise<readonly CustomerAgent[]>
  getCustomerProblems(): Promise<readonly CustomerProblem[]>
  getGiftCatalog(anchorId?: string): Promise<GiftCatalog>
  getOnlineHosts(): Promise<readonly OnlineHost[]>
  getRelations(type: 1 | 2 | 3): Promise<readonly RelationUser[]>
  checkPrivateMedia(privateIds: readonly number[]): Promise<readonly PrivateMediaCheckResult[]>
  refreshBalance(): Promise<number | undefined>
  sendGift(imAccount: string, gift: GiftItem, count: number): Promise<GiftSendResult>
  setFollowed(userId: string, followed: boolean): Promise<void>
  unlockPrivateMedia(recordId: number, privateId: number): Promise<void>
}

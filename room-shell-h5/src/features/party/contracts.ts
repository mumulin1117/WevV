export type PartyTab = 'follow' | 'party' | 'recent'

export interface PartyMember {
  age: number
  avatarUrl: string
  cardFrameUrl?: string
  countryName: string
  displayName: string
  followed: boolean
  followerCount: number
  followingCount: number
  gender: 0 | 1 | 2
  headFrameSmallUrl: string
  headFrameUrl: string
  id: string
  imAccount: string
  level: number
  levelName?: string
  medals: string[]
  muted: boolean
  onlineStatus?: number
  owner: boolean
  platformAdmin: boolean
  roomRole: 'admin' | 'member' | 'owner'
  userType?: number
  vip: boolean
}

export interface PartyMessage {
  activityType?: 'first-gift' | 'lucky-number-draw' | 'lucky-number-win' | 'wheel-result'
  createdAt: number
  effectUrl?: string
  giftCount?: number
  giftIconUrl?: string
  giftName?: string
  giftReceiverIds?: string[]
  giftValue?: number
  giftCost?: number
  id: string
  senderLevel?: number
  senderPlatformAdmin?: boolean
  senderRoleType?: 1 | 2 | 3
  senderAvatarUrl: string
  senderId: string
  senderName: string
  senderUserId?: string
  senderVip?: boolean
  text: string
  luckyNumber?: number
  mentionCurrentUser?: boolean
  presentation?: PartyMessagePresentation
  type: 'activity' | 'entry' | 'gift' | 'system' | 'text'
}

export interface PartyGiftReceiverPresentation {
  avatarUrl: string
  id: string
  name: string
}

export interface PartyGiftPresentation {
  kind: 'gift'
  mysteryBox: boolean
  receivers: PartyGiftReceiverPresentation[]
  senderHeadFrameUrl: string
  senderMedalUrls: string[]
  senderUserType?: number
  variant: 'named' | 'standard'
}

export interface PartyEntryPresentation {
  kind: 'entry'
  priority: number
  userId: string
  variant: 'static' | 'vehicle'
}

export interface PartyFirstGiftPresentation {
  backgroundUrl: string
  giftIconUrl: string
  giftImageUrl: string
  isFirstGift: boolean
  kind: 'first-gift'
  nickname: string
  renderedText: string
  styleKey: string
  userAvatarUrl: string
}

export type PartyMessagePresentation =
  PartyEntryPresentation | PartyFirstGiftPresentation | PartyGiftPresentation

export interface PartySeat {
  cameraEnabled: boolean
  emojiUrl?: string
  giftValue: number
  host: boolean
  index: number
  locked: boolean
  member: PartyMember | null
  microphoneEnabled: boolean
  prohibited: boolean
  seatCameraEnabled: boolean
  speaking: boolean
  type: 'audio' | 'video'
}

export interface PartyRoom {
  announcement: string
  backgroundUrl: string
  coverUrl: string
  ended: boolean
  followed: boolean
  frameUrl: string
  heat: number
  honor: number
  id: string
  inviteIntervalSeconds: number
  language: string
  locked: boolean
  musicAvailable: boolean
  onSeatApplyEnabled: boolean
  pkActive?: boolean
  platformAdmin: boolean
  queueCount: number
  role: 'admin' | 'member' | 'owner'
  memberAvatars: string[]
  memberCount: number
  banners: PartyPromotion[]
  cornerBanners: PartyPromotion[]
  owner: PartyMember
  recentAt: number
  rankIndex?: 0 | 1 | 2 | 3
  seats: PartySeat[]
  showChest?: boolean
  summary: string
  title: string
  roomType: 'live-voice' | 'voice'
  safetyNotice?: string
  score: number
  snapshotId: string
  transport?: {
    channelName: string
    chatRoomId: string
    currentSeatIndex: number
    roomTempId: string
  }
}

export interface PartyQueueEntry {
  member: PartyMember
  queueIndex: number
  seatIndex: number
  seatType: PartySeat['type']
}

export interface PartyQueueState {
  entries: PartyQueueEntry[]
  myIndex: number
  total: number
}

export interface PartyBackground {
  duration: number
  id: string
  imageUrl: string
  name: string
  thumbnailUrl: string
}

export interface PartyBlacklistEntry {
  banType: 1 | 2
  duration: number
  member: PartyMember
}

export interface PartyRoomTemplate {
  createRoomLevel: number
  id: string
  imageUrl: string
  roomType: PartyRoom['roomType']
}

export interface PartyPromotion {
  directUrl: string
  id: string
  imageUrl: string
  name: string
}

export interface PartyRoomSnapshot {
  communication: {
    error?: string
    state: 'connected' | 'connecting' | 'failed' | 'paused' | 'reconnecting'
  }
  messages: PartyMessage[]
  musicSettings?: PartyMusicSettings
  queue?: PartyQueueState
  room: PartyRoom
  terminationReason?: 'banned' | 'closed' | 'kicked' | 'unknown'
}

export interface PartyDirectory {
  canCreateRoom: boolean
  createRoomLevel: number
  createRoomWhitelisted: boolean
  myRoom: PartyRoom | null
}

export interface PartyLanguageOption {
  code: string
  name: string
}

export interface PartyRoomListCursor {
  offset: number
  snapshotId: string
}

export interface PartyCreateOptions {
  backgrounds: PartyBackground[]
  canCreateRoom: boolean
  createRoomLevel: number
  createRoomWhitelisted: boolean
  languages: PartyLanguageOption[]
  templates: PartyRoomTemplate[]
}

export interface PartyCreateInput {
  backgroundId?: string
  coverUrl: string
  language: string
  templateId: string
  summary: string
  title: string
}

export interface PartyGiftInput {
  animationUrl: string
  availableQuantity?: number
  count: number
  giftType?: number
  giftId: string
  giftName: string
  iconUrl: string
  mysteryBox?: boolean
  price: number
  receiverImAccounts: string[]
  receiverIds: string[]
  receivers?: PartyGiftReceiverPresentation[]
  source: 'backpack' | 'wallet'
}

export interface PartyGiftCatalog {
  balance: number
  counts: number[]
  gifts: Array<{
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
  }>
}

export interface PartyGiftSendResult {
  balance: number
  luckyGift?: {
    draws: number
    totalReward: number
    winCount: number
    won: boolean
  }
  snapshot: PartyRoomSnapshot
}

export interface PartyRankItem {
  member: PartyMember
  rank: number
  score: number
}

export type PartyRoomRankKind = 'contribution' | 'honor'
export interface PartyRoomRankResult {
  durationSeconds: number
  entries: PartyRankItem[]
  finished: boolean
  myRank: PartyRankItem | null
}

export type PartyRankingKind = 'party-rich' | 'room'
export type PartyRankingPeriod = 'day' | 'month' | 'week'
export type PartyRankingScope = 'CURRENT' | 'LAST'

export interface PartyRankingReward {
  itemName: string
  itemSmallImg: string
  rankingPosition: number
  rewardType: number
  rewardValue: number
  threshold: number
  userType: number
  validityPeriod: number
}

export interface PartyRankingEntry {
  age: number
  avatarUrl: string
  countryId: string
  displayName: string
  medalIconUrls: string[]
  rank: number
  rewardConfigs: PartyRankingReward[]
  rewardIconUrls: string[]
  roomId: string
  score: number
  userId: string
  userType: number
}

export interface PartyRankingResult {
  durationSeconds: number
  entries: PartyRankingEntry[]
  myRank: PartyRankingEntry | null
  rewardConfigs: PartyRankingReward[]
}

export interface PartyEmojiItem {
  category: string
  categoryCover?: string
  id: string
  imageUrl: string
  playType: string
  playUrl: string
  resultImages: Array<{ imageUrl: string; key: string }>
}

export interface PartyMusicItem {
  durationSeconds: number
  id: string
  liked: boolean
  name: string
  sourceType: 1 | 3
  type: 1 | 2 | 3
  url: string
}

export interface PartyMusicSettings {
  currentSongId: string
  enabled: boolean
  muted: boolean
  playMode: 1 | 2 | 3
  playing: boolean
  positionSeconds: number
  songName: string
  url?: string
  volume: number
}

export interface PartyRoomRecoveryOptions {
  signal?: AbortSignal
}

export interface PartyRepository {
  approveQueueEntry: (roomId: string, entry: PartyQueueEntry) => Promise<PartyRoomSnapshot>
  cancelSeatApplication: (roomId: string) => Promise<PartyRoomSnapshot>
  createRoom: (input: PartyCreateInput) => Promise<PartyRoom>
  dismissEmoji: (roomId: string, memberId: string, playUrl: string) => Promise<void>
  getBackgrounds: () => Promise<PartyBackground[]>
  getCurrentBackground: (roomId: string) => Promise<PartyBackground | null>
  getAnnouncement: (roomId: string) => Promise<PartyRoomSnapshot>
  getBlacklist: (roomId: string) => Promise<PartyBlacklistEntry[]>
  getCreateOptions: () => Promise<PartyCreateOptions>
  getDirectory: () => Promise<PartyDirectory>
  getEmojis: (roomId: string) => Promise<PartyEmojiItem[]>
  getGiftCatalog: (roomId: string) => Promise<PartyGiftCatalog>
  getInviteCandidates: (roomId: string, followType?: 0 | 1) => Promise<PartyMember[]>
  getLanguages: (force?: boolean) => Promise<PartyLanguageOption[]>
  getMusic: (roomId: string, musicType?: 1 | 2 | 3) => Promise<PartyMusicItem[]>
  getMusicSettings: (roomId: string) => Promise<PartyMusicSettings>
  getQueue: (roomId: string) => Promise<PartyQueueState>
  getRank: (
    roomId: string,
    period: PartyRankingPeriod,
    kind?: PartyRoomRankKind,
    scope?: PartyRankingScope,
    offset?: number,
  ) => Promise<PartyRoomRankResult>
  getRanking: (
    kind: PartyRankingKind,
    period: PartyRankingPeriod,
    scope: PartyRankingScope,
  ) => Promise<PartyRankingResult>
  getRoom: (roomId: string) => Promise<PartyRoomSnapshot>
  getRoomMember: (roomId: string, userId: string, signal?: AbortSignal) => Promise<PartyMember>
  getRoomTemplates: (roomType: PartyRoom['roomType']) => Promise<PartyRoomTemplate[]>
  getViewers: (roomId: string) => Promise<PartyMember[]>
  holdMemberOnSeat: (
    roomId: string,
    seatIndex: number,
    member: PartyMember,
  ) => Promise<PartyRoomSnapshot>
  isAvailable: () => boolean
  managesCommunication: () => boolean
  inviteMembers: (roomId: string, imAccounts: string[]) => Promise<void>
  prepareRoomEntry: (roomId: string, password?: string) => Promise<PartyRoomSnapshot>
  joinRoom: (roomId: string) => Promise<PartyRoomSnapshot>
  kickMember: (roomId: string, member: PartyMember, banType: 1 | 2) => Promise<PartyRoomSnapshot>
  leaveSeat: (roomId: string) => Promise<PartyRoomSnapshot>
  leaveRoom: (roomId: string) => Promise<void>
  listRooms: (
    tab: PartyTab,
    language?: string,
    query?: string,
    cursor?: PartyRoomListCursor,
  ) => Promise<PartyRoom[]>
  moderateSeat: (
    roomId: string,
    seatIndex: number,
    action: 'kick' | 'lock' | 'mute' | 'unlock' | 'unmute',
  ) => Promise<PartyRoomSnapshot>
  observe: (roomId: string, listener: (snapshot: PartyRoomSnapshot) => void) => () => void
  pauseMusic: (roomId: string) => Promise<void>
  playMusic: (
    roomId: string,
    music: PartyMusicItem,
    options?: { playMode?: 1 | 2 | 3; volume?: number },
  ) => Promise<void>
  refuseQueueEntry: (roomId: string, entry: PartyQueueEntry) => Promise<PartyRoomSnapshot>
  removeFromBlacklist: (roomId: string, member: PartyMember) => Promise<void>
  retryRoomCommunication: (roomId: string, options?: PartyRoomRecoveryOptions) => Promise<void>
  sendGift: (roomId: string, input: PartyGiftInput) => Promise<PartyGiftSendResult>
  sendEmoji: (roomId: string, emoji: PartyEmojiItem) => Promise<PartyRoomSnapshot>
  sendMessage: (roomId: string, text: string) => Promise<PartyRoomSnapshot>
  setRoomVisible: (
    roomId: string,
    visible: boolean,
    options?: PartyRoomRecoveryOptions,
  ) => Promise<void>
  setAnnouncement: (roomId: string, announcement: string) => Promise<PartyRoomSnapshot>
  setBackground: (roomId: string, background: PartyBackground) => Promise<PartyRoomSnapshot>
  setMemberAdmin: (roomId: string, member: PartyMember, admin: boolean) => Promise<void>
  setMemberFollowed: (member: PartyMember, followed: boolean) => Promise<void>
  setMusicEnabled: (roomId: string, enabled: boolean) => Promise<void>
  setMusicLiked: (music: PartyMusicItem, liked: boolean) => Promise<void>
  updateMusicSettings: (
    roomId: string,
    options: { playMode?: 1 | 2 | 3; volume?: number },
  ) => Promise<void>
  setOnSeatApplyEnabled: (roomId: string, enabled: boolean) => Promise<PartyRoomSnapshot>
  setRoomLock: (roomId: string, locked: boolean, password?: string) => Promise<PartyRoomSnapshot>
  setRoomTemplate: (roomId: string, template: PartyRoomTemplate) => Promise<PartyRoomSnapshot>
  setSeatMedia: (
    roomId: string,
    seatIndex: number,
    media: 'camera' | 'microphone',
    enabled: boolean,
  ) => Promise<PartyRoomSnapshot>
  setSoundEnabled: (enabled: boolean) => Promise<void>
  takeSeat: (roomId: string, seatIndex: number) => Promise<PartyRoomSnapshot>
  uploadMusic: (roomId: string, files: File[], signal?: AbortSignal) => Promise<void>
  uploadRoomCover: (blob: Blob, signal?: AbortSignal) => Promise<string>
}

export class PartyServiceUnavailableError extends Error {
  constructor() {
    super('Voice rooms are not available for this server configuration.')
    this.name = 'PartyServiceUnavailableError'
  }
}

export type PartyRoomEntryFailure = 'banned' | 'level' | 'password' | 'temporary-ban' | 'unknown'

export class PartyRoomEntryError extends Error {
  constructor(
    readonly reason: PartyRoomEntryFailure,
    message: string,
  ) {
    super(message)
    this.name = 'PartyRoomEntryError'
  }
}

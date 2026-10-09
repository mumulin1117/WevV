import { getSapiClient } from '@/core/auth/runtime'
import { ApiClientError } from '@/core/api/client'
import { getServerRuntimeConfig } from '@/core/config/server-runtime-config'
import { reportRuntimeMetric } from '@/core/observability/runtime'
import type { GiftItem } from '@/features/messages/contracts'
import { getMediaRepository } from '@/features/media/media-repository'
import { getLivePkRepository } from '@/features/rooms/live-pk-repository'
import { getAnchorProfileRepository } from '@/features/rooms/anchor-profile-repository'
import type { LiveChatMessage } from '@/features/rooms/chatroom-contracts'
import { useSessionStore } from '@/main/stores/session'
import { watch, type WatchStopHandle } from 'vue'
import { PartyRoomEntryError } from './contracts'
import type {
  PartyCreateInput,
  PartyCreateOptions,
  PartyBackground,
  PartyBlacklistEntry,
  PartyDirectory,
  PartyEmojiItem,
  PartyGiftCatalog,
  PartyGiftInput,
  PartyGiftSendResult,
  PartyLanguageOption,
  PartyMessage,
  PartyMember,
  PartyMusicItem,
  PartyMusicSettings,
  PartyQueueEntry,
  PartyQueueState,
  PartyRankItem,
  PartyRankingEntry,
  PartyRankingKind,
  PartyRankingPeriod,
  PartyRankingReward,
  PartyRankingResult,
  PartyRankingScope,
  PartyRepository,
  PartyRoom,
  PartyRoomListCursor,
  PartyRoomRankKind,
  PartyRoomRankResult,
  PartyRoomRecoveryOptions,
  PartyRoomSnapshot,
  PartyRoomTemplate,
  PartySeat,
  PartyTab,
} from './contracts'
import {
  createPartyChatroomController,
  PartyHeartbeatSession,
  partyRoomRtc,
  type PartyChatroomController,
} from './party-room-runtime'

type UnknownRecord = Record<string, unknown>

interface PartyCommunicationAttempt {
  communicationEpoch: number
  roomId: string
  visibilityEpoch: number
}

const PATH = {
  announcementGet: '/sapi/weidou/v1/client/party/room/getAnnouncement',
  announcementEdit: '/sapi/weidou/v1/client/party/room/editAnnouncement',
  create: '/sapi/weidou/v1/client/party/room/create',
  backgrounds: '/sapi/weidou/v1/client/party/room/getBgImages',
  backgroundGet: '/sapi/weidou/v1/client/party/room/getRoomBgImage',
  backgroundSet: '/sapi/weidou/v1/client/party/room/setBgImages',
  blacklist: '/sapi/weidou/v1/client/party/room/getKickOutBlacklist',
  blacklistRemove: '/sapi/weidou/v1/client/party/room/removeKickOutBlacklist',
  createConditions: '/sapi/weidou/v1/client/party/room/getCreateRoomConditions',
  emojis: '/sapi/weidou/v1/client/party/room/getPartyRoomEmojis',
  enter: '/sapi/weidou/v1/client/party/room/enter',
  exit: '/sapi/weidou/v1/client/party/room/exitRoom',
  giftPanel: '/sapi/weidou/v1/client/party/gift/getPartyRoomGift',
  invite: '/sapi/weidou/v1/client/party/room/inviteUserRoom',
  inviteFollow: '/sapi/weidou/v1/client/party/room/getFollowInfoList',
  inviteRecommend: '/sapi/weidou/v1/client/party/room/getRecommendInviteList',
  kickMember: '/sapi/weidou/v1/client/party/room/kickOutRoom',
  language: '/sapi/weidou/v1/client/party/room/language/list',
  list: '/sapi/weidou/v1/client/party/room/list',
  listFollowed: '/sapi/weidou/v1/client/party/room/followed/list',
  listRecent: '/sapi/weidou/v1/client/party/room/recent/list',
  messageList: '/sapi/weidou/v1/client/party/room/message/list',
  messageSend: '/sapi/weidou/v1/client/party/room/message/send',
  myRoom: '/sapi/weidou/v1/client/party/room/getMyRoomAndFamilyInfo',
  music: '/sapi/weidou/v1/client/party/music/list',
  musicEnable: '/sapi/weidou/v1/client/party/music/enableMusic',
  musicLike: '/sapi/weidou/v1/client/party/music/like',
  musicPlay: '/sapi/weidou/v1/client/party/music/play',
  musicSettings: '/sapi/weidou/v1/client/party/music/settings',
  musicUpdate: '/sapi/weidou/v1/client/party/music/update',
  musicUpload: '/sapi/weidou/v1/client/party/music/uploadLocalMusic',
  openEffect: '/sapi/weidou/v1/client/party/room/openEffect',
  onSeat: '/sapi/weidou/v1/client/party/seat/onSeat',
  queueAgree: '/sapi/weidou/v1/client/party/seat/agreeSeat',
  queueCancel: '/sapi/weidou/v1/client/party/seat/giveUpQueueSeat',
  queueList: '/sapi/weidou/v1/client/party/seat/getQueueSeatList',
  queueRefuse: '/sapi/weidou/v1/client/party/seat/refuseQueueSeat',
  rank: '/sapi/weidou/v1/client/party/room/rank/getContributionRanks',
  rankHonor: '/sapi/weidou/v1/client/party/room/rank/getHonorRanks',
  rankingPartyRich: '/sapi/weidou/v1/client/party/room/rank/getPartyRichRanks',
  rankingRoom: '/sapi/weidou/v1/client/party/room/rank/getRoomRanks',
  roomTemp: '/sapi/weidou/v1/client/party/room/getRoomTempList',
  roomInfoCard: '/sapi/weidou/v1/client/party/room/getRoomInfoCard',
  roomLock: '/sapi/weidou/v1/client/party/room/lockRoom',
  roomSeatApply: '/sapi/weidou/v1/client/party/room/updateOnSeatEnable',
  roomSetAdmin: '/sapi/weidou/v1/client/party/room/setAdmin',
  seatDown: '/sapi/weidou/v1/client/party/seat/downSeat',
  seatExchange: '/sapi/weidou/v1/client/party/seat/exchangeSeat',
  seatList: '/sapi/weidou/v1/client/party/seat/list',
  seatLock: '/sapi/weidou/v1/client/party/seat/lockSeat',
  seatMedia: '/sapi/weidou/v1/client/party/seat/updateMedia',
  seatProhibit: '/sapi/weidou/v1/client/party/seat/prohibitSeat',
  seatSwitchTemplate: '/sapi/weidou/v1/client/party/seat/switchRoomTemp',
  seatHold: '/sapi/weidou/v1/client/party/seat/holdSeat',
  sendGift: '/sapi/weidou/v1/client/party/gift/sendGift',
  userGet: '/sapi/weidou/v1/client/user/get',
  viewers: '/sapi/weidou/v1/client/party/room/getViewers',
} as const

function record(value: unknown): UnknownRecord {
  return value && typeof value === 'object' && !Array.isArray(value) ? (value as UnknownRecord) : {}
}

function rows(value: unknown, ...keys: string[]): UnknownRecord[] {
  if (Array.isArray(value)) return value.map(record)
  const root = record(value)
  for (const key of keys) if (Array.isArray(root[key])) return (root[key] as unknown[]).map(record)
  for (const key of ['records', 'rows', 'list', 'items'])
    if (Array.isArray(root[key])) return (root[key] as unknown[]).map(record)
  return []
}

function text(value: unknown, fallback = ''): string {
  if (typeof value === 'string') return value.trim()
  if (typeof value === 'number' && Number.isFinite(value)) return String(value)
  return fallback
}

function integer(value: unknown, fallback = 0): number {
  const parsed = Number(value)
  return Number.isFinite(parsed) ? Math.trunc(parsed) : fallback
}

function roomRankIndex(value: unknown): 0 | 1 | 2 | 3 {
  const rankIndex = integer(value)
  return rankIndex === 1 || rankIndex === 2 || rankIndex === 3 ? rankIndex : 0
}

function requiredRoomId(value: string): number {
  const parsed = Number(value)
  if (!Number.isSafeInteger(parsed) || parsed <= 0) throw new Error('The voice-room ID is invalid.')
  return parsed
}

function normalizeEntryError(cause: unknown): PartyRoomEntryError {
  const code = cause instanceof ApiClientError ? cause.code : undefined
  if (code === '10006')
    return new PartyRoomEntryError('password', 'The room password is incorrect.')
  if (code === '10012')
    return new PartyRoomEntryError('temporary-ban', 'You are temporarily blocked from this room.')
  if (code === '10013') return new PartyRoomEntryError('banned', 'You are blocked from this room.')
  if (code === '10080')
    return new PartyRoomEntryError('level', 'Your level does not meet this room requirement.')
  return new PartyRoomEntryError(
    'unknown',
    cause instanceof Error ? cause.message : 'Unable to enter the voice room.',
  )
}

function levelNumber(value: unknown): number {
  const direct = Number(value)
  if (Number.isFinite(direct)) return Math.max(0, Math.trunc(direct))
  const matched = text(value).match(/\d+/u)?.[0]
  return matched ? Math.max(0, integer(matched)) : 0
}

function boolean(value: unknown): boolean {
  return value === true || value === 1 || value === '1' || value === 'true'
}

function persistedPartyMessage(value: unknown): PartyMessage | null {
  const item = record(value)
  const id = text(item.id)
  const content = text(item.text || item.content)
  if (!id || !content) return null
  const userId = text(item.userId)
  const gift = text(item.messageType).toUpperCase() === 'GIFT'
  const receiverId = text(item.receiverId)
  return {
    createdAt: Math.max(0, integer(item.createdAt, Date.now())),
    id: `persisted-party-${gift ? 'gift' : 'chat'}:${id}`,
    senderAvatarUrl: text(item.avatarUrl || item.icon),
    senderId: text(item.imAccount || item.yxAccid || userId),
    senderLevel: Math.max(0, integer(item.userLevel)),
    senderName: text(item.nickname),
    senderUserId: userId,
    senderVip: boolean(item.vip),
    text: content,
    ...(gift
      ? {
          effectUrl: text(item.giftEffectUrl),
          giftCount: Math.max(1, integer(item.giftCount, 1)),
          giftCost: Math.max(0, integer(item.giftCost)),
          giftIconUrl: text(item.giftIconUrl),
          giftName: text(item.giftName),
          giftReceiverIds: receiverId ? [receiverId] : [],
          giftValue: Math.max(0, integer(item.giftCost)),
          presentation: {
            kind: 'gift' as const,
            mysteryBox: false,
            receivers: receiverId ? [{ avatarUrl: '', id: receiverId, name: '' }] : [],
            senderHeadFrameUrl: '',
            senderMedalUrls: [],
            variant: 'standard' as const,
          },
        }
      : {}),
    type: gift ? 'gift' : 'text',
  }
}

function partyBackground(value: unknown): PartyBackground | null {
  const item = record(value)
  const id = text(item.id || item.bgImgId)
  const imageUrl = text(item.bigImgUrl || item.imgUrl || item.bgImgUrl)
  if (!id || !imageUrl) return null
  return {
    duration: integer(item.duration, -1),
    id,
    imageUrl,
    name: text(item.bgImgName || item.name, 'Background'),
    thumbnailUrl: text(item.imgUrl || item.bigImgUrl || item.bgImgUrl),
  }
}

function partyRoomRoleType(role: PartyRoom['role']): 1 | 2 | 3 {
  if (role === 'owner') return 1
  if (role === 'admin') return 2
  return 3
}

function assertSeatMutationSucceeded(value: unknown): void {
  const result = record(value)
  if (!Object.keys(result).length) return
  const code = text(result.code)
  const message = text(result.msg || result.message)
  if (code || message) throw new Error(message || code || 'The seat operation failed.')
}

function member(value: unknown, owner = false): PartyMember {
  const item = record(value)
  const id = text(item.userId || item.ownerId || item.id)
  const isOwner = owner || integer(item.roomRoleType) === 1
  return {
    age: Math.max(0, integer(item.age)),
    avatarUrl: text(item.avatar || item.icon || item.roomAvatar),
    cardFrameUrl: text(item.cardFrame),
    countryName: text(item.countryName || item.countryId),
    displayName: text(item.nickname || item.nickName || item.roomName || item.name, `User ${id}`),
    followed: boolean(item.followFlag || item.isFollow),
    followerCount: Math.max(0, integer(item.beFollowCount)),
    followingCount: Math.max(0, integer(item.followCount)),
    gender: [1, 2].includes(integer(item.gender)) ? (integer(item.gender) as 1 | 2) : 0,
    headFrameSmallUrl: text(item.headFrameSmallImg),
    headFrameUrl: text(item.headFrame || item.avatarFrame || item.frame),
    id,
    imAccount: text(item.yxAccid || item.accid || item.imAccid),
    level: levelNumber(item.levelName || item.userLevel || item.level),
    levelName: text(item.levelName || item.userLevel || item.level),
    medals: rows(item.medals)
      .map((entry) => text(entry.icon || entry.imgUrl))
      .filter(Boolean),
    muted: integer(item.microphoneEnabled, 1) === 0 || integer(item.seatMicrophoneEnabled, 1) === 0,
    onlineStatus: Math.max(0, integer(item.onlineGroupStatus || item.onlineStatus)),
    owner: isOwner,
    platformAdmin: boolean(item.isPlatformAdmin),
    roomRole: isOwner ? 'owner' : integer(item.roomRoleType) === 2 ? 'admin' : 'member',
    userType: Math.max(0, integer(item.userType)) || (isOwner ? 2 : 0),
    vip: boolean(item.isVip || item.vip),
  }
}

function inviteMember(value: unknown): PartyMember {
  const item = record(value)
  const mapped = member(item)
  return {
    ...mapped,
    avatarUrl: text(item.icon),
    headFrameSmallUrl: '',
    headFrameUrl: text(item.avatar),
    // Java 私信与房间邀请都支持数字用户 ID。历史数据可能没有 yx_accid，
    // 不能因此把真实的关注/粉丝候选人从列表中丢掉。
    imAccount: mapped.imAccount || mapped.id,
  }
}

function roomInfoCardMember(value: unknown, owner = false): PartyMember {
  const item = record(value)
  return {
    ...member(item, owner),
    avatarUrl: text(item.icon),
    headFrameSmallUrl: text(item.headFrameSmallImg),
    headFrameUrl: text(item.headFrame || item.avatarFrame || item.frame),
  }
}

function seat(value: unknown): PartySeat {
  const item = record(value)
  const nested = record(item.userInfo || item.user || item.memberInfo || item.member)
  const source = { ...nested, ...item }
  const userId = text(source.userId || source.seatUserId || source.memberId || source.uid)
  return {
    cameraEnabled: integer(item.cameraEnabled) === 1,
    giftValue: Math.max(0, integer(item.giftValueCount)),
    // 房主身份与主持麦位是两个独立概念；只有 isHostSeat 才显示 MC 麦位装饰。
    host: integer(source.isHostSeat) === 1,
    index: Math.max(0, integer(item.seatIndex || item.seatNo || item.index, 1) - 1),
    locked: boolean(item.lockFlag || item.isLocked || item.locked),
    member: userId && userId !== '0' ? member(source) : null,
    microphoneEnabled: integer(item.microphoneEnabled, 1) === 1,
    prohibited: integer(item.seatMicrophoneEnabled, 1) === 0,
    seatCameraEnabled: integer(item.seatCameraEnabled, 1) === 1,
    speaking: false,
    type: integer(item.seatType, 2) === 1 ? 'video' : 'audio',
  }
}

function promotion(value: unknown, fallbackId: string) {
  const item = record(value)
  return {
    directUrl: text(item.directUrl),
    id: text(item.id || item.activityId, fallbackId),
    imageUrl: text(item.picUrl || item.imgUrl || item.imageUrl),
    name: text(item.activityName || item.name),
  }
}

function listRoom(value: unknown): PartyRoom {
  const item = record(value)
  const ownerId = text(item.ownerId)
  const roomOwner = member(
    {
      avatar: item.ownerAvatar || item.roomAvatar,
      nickname: item.ownerName || item.roomName,
      userId: ownerId,
      yxAccid: item.ownerYxAccid,
    },
    true,
  )
  const onlineUsers = rows(item.onlineUserList)
  return {
    announcement: text(item.announcement || item.greetingMessage),
    banners: rows(item.bannerList).map((entry, index) => promotion(entry, `banner-${index}`)),
    backgroundUrl: text(item.bigImgUrl || item.bgImgUrl),
    coverUrl: text(item.roomAvatar),
    cornerBanners: rows(item.cornerBannerList).map((entry, index) =>
      promotion(entry, `corner-${index}`),
    ),
    ended: item.roomStatus !== undefined && [0, 2].includes(integer(item.roomStatus)),
    followed: boolean(item.isFollowOwner || item.followFlag || item.followed),
    frameUrl: '',
    heat: Math.max(0, integer(item.heatValue)),
    honor: Math.max(0, integer(item.honorDailyTotal)),
    id: text(item.id),
    inviteIntervalSeconds: Math.max(1, integer(item.inviteInterval, 3600)),
    language: text(item.roomLanguage),
    locked:
      boolean(item.needPassword) || integer(item.lockFlag) === 1 || integer(item.roomStatus) === 3,
    musicAvailable: integer(item.roomMusicSwitc, 1) === 1,
    onSeatApplyEnabled: boolean(item.onSeatApplySwitch),
    pkActive: boolean(item.pkStatus),
    platformAdmin: boolean(item.isPlatformAdmin),
    queueCount: Math.max(0, integer(item.queueSeatNum)),
    role:
      integer(item.roomRoleType) === 1
        ? 'owner'
        : integer(item.roomRoleType) === 2
          ? 'admin'
          : 'member',
    memberAvatars: onlineUsers.map((entry) => text(entry.avatar)).filter(Boolean),
    memberCount: Math.max(onlineUsers.length, integer(item.audienceNum || item.onlineCount)),
    owner: roomOwner,
    recentAt: 0,
    rankIndex: roomRankIndex(item.rangIndex),
    seats: [],
    showChest: boolean(item.showChest),
    summary: text(item.greetingMessage),
    title: text(item.roomName, `Room ${text(item.id)}`),
    roomType: integer(item.roomTempType, 1) === 2 ? 'live-voice' : 'voice',
    safetyNotice: text(item.convention),
    score: integer(item.score),
    snapshotId: text(item.snapshotId),
    transport: {
      channelName: text(item.agoraChannelId),
      chatRoomId: text(item.yxRoomId),
      currentSeatIndex: -1,
      roomTempId: text(item.roomTempId),
    },
  }
}

function enterRoom(value: unknown): PartyRoom {
  const item = record(value)
  const base = listRoom(item)
  const ownerInfo = record(item.ownerInfo)
  const ownerId = text(item.ownerId)
  const roomOwner = member(
    {
      avatar: ownerInfo.avatar || item.roomAvatar,
      nickname: ownerInfo.nickname || item.roomName,
      userId: ownerInfo.userId || ownerId,
      yxAccid: ownerInfo.yxAccid,
    },
    true,
  )
  const ownerFollowed = boolean(item.isFollowOwner)
  return {
    ...base,
    announcement: text(item.announcement),
    backgroundUrl: text(item.bigImgUrl || item.bgImgUrl),
    followed: ownerFollowed,
    memberCount: Math.max(0, integer(item.audienceNum)),
    musicAvailable: integer(item.roomMusicSwitc, 1) === 1,
    onSeatApplyEnabled: boolean(item.onSeatApplySwitch),
    owner: { ...roomOwner, followed: ownerFollowed },
    platformAdmin: boolean(item.isPlatformAdmin),
    queueCount: Math.max(0, integer(item.queueSeatNum)),
    role:
      integer(item.roomRoleType) === 1
        ? 'owner'
        : integer(item.roomRoleType) === 2
          ? 'admin'
          : 'member',
    seats: rows(item.roomSeatList, 'roomSeatList', 'seatList', 'seats')
      .map(seat)
      .sort((a, b) => a.index - b.index),
  }
}

function rankingReward(value: unknown): PartyRankingReward {
  const item = record(value)
  return {
    itemName: text(item.itemName || item.name),
    itemSmallImg: text(item.itemSmallImg || item.smallImg || item.imageUrl),
    rankingPosition: Math.max(0, integer(item.rankingPosition || item.rankIndex)),
    rewardType: Math.max(0, integer(item.rewardType)),
    rewardValue: Math.max(0, integer(item.rewardValue || item.value)),
    threshold: Math.max(0, integer(item.threshold)),
    userType: Math.max(0, integer(item.userType)),
    validityPeriod: Math.max(0, integer(item.validityPeriod)),
  }
}

function rankingEntry(value: unknown, fallbackRank = 0, fallbackUserType = 1): PartyRankingEntry {
  const item = record(value)
  const rewardConfigs = rows(item.rewardConfig).map(rankingReward)
  const userType = integer(item.userType)
  return {
    age: Math.max(0, integer(item.age)),
    avatarUrl: text(item.avatar || item.roomAvatar || item.ownerAvatar),
    countryId: text(item.countryId),
    displayName: text(item.nickname || item.roomName || item.ownerName),
    medalIconUrls: rows(item.medals)
      .map((medal) => text(medal.icon || medal.imgUrl || medal.imageUrl))
      .filter(Boolean),
    rank: Math.max(0, integer(item.rankIndex ?? item.rank, fallbackRank)),
    rewardConfigs,
    rewardIconUrls: rewardConfigs
      .map((reward) => reward.itemSmallImg)
      .filter(Boolean)
      .slice(0, 2),
    roomId: text(item.roomId || item.id),
    score: Math.max(0, integer(item.rankValue ?? item.value)),
    userId: text(item.userId || item.ownerId),
    userType: userType > 0 ? userType : fallbackUserType,
  }
}

function partyGift(value: unknown, category: string, exclusive: boolean): GiftItem | null {
  const item = record(value)
  const id = text(item.id || item.giftId)
  if (!id) return null
  return {
    animationUrl: text(item.giftImg || item.animationUrl || item.giftIcon),
    category: text(category || item.category, 'Gift'),
    partyGiftType: integer(item.giftTypeV2 ?? item.giftType),
    partyMysteryBox: integer(item.mysteryBoxFlag) === 1,
    iconUrl: text(item.giftSmallImg || item.smallImg || item.giftIcon || item.giftImg),
    id,
    name: text(item.name || item.giftName, 'Gift'),
    price: Math.max(0, integer(item.giftPrice || item.price)),
    // The legacy Party rack only applies `unlock` to the Exclusive tab. Regular
    // tabs commonly return unlock=0 as a non-applicable default; treating that
    // as a lock makes the entire catalog unavailable.
    sendable: !boolean(item.vipLocked) && (!exclusive || integer(item.unlock) === 1),
    source: 'wallet',
  }
}

function partyMessagePresentation(
  item: LiveChatMessage,
): PartyRoomSnapshot['messages'][number]['presentation'] {
  if (item.kind === 'gift') {
    return {
      kind: 'gift',
      mysteryBox: item.giftMysteryBox === true,
      receivers: (item.giftReceivers ?? []).map((receiver) => ({ ...receiver })),
      senderHeadFrameUrl: item.senderHeadFrameUrl ?? '',
      senderMedalUrls: [...(item.medalUrls ?? [])],
      senderUserType: item.userType,
      // Party 2049 compatibility only; do not reuse this as the generic OPI enum.
      variant: item.giftType === 8 ? 'named' : 'standard',
    }
  }
  if (item.kind === 'enter' && !item.entryItemUrl) {
    return {
      kind: 'entry',
      priority: 100 + Math.min(99, Math.max(0, item.userLevel ?? 0)),
      userId: item.userId?.trim() || item.senderId,
      variant: 'static',
    }
  }
  return undefined
}

function giftCounts(value: unknown): number[] {
  if (!Array.isArray(value)) return []
  return [
    ...new Set(
      value
        .map((entry) => {
          const item = record(entry)
          return Math.max(0, integer(item.text || item.value || item.num || entry))
        })
        .filter(Boolean),
    ),
  ]
}

export class RemotePartyRepository implements PartyRepository {
  private readonly api = getSapiClient()
  private readonly heartbeat = new PartyHeartbeatSession({
    onTerminalFailure: ({ error, roomId }) => this.handleHeartbeatTerminalFailure(roomId, error),
  })
  private readonly snapshots = new Map<string, PartyRoomSnapshot>()
  private readonly enteredRooms = new Set<string>()
  private readonly rtcDisabledRoomIds = new Set<string>()
  private readonly roomTypes = new Map<string, PartyRoom['roomType']>()
  private readonly listRequests = new Map<string, Promise<PartyRoom[]>>()
  private readonly listeners = new Map<string, Set<(snapshot: PartyRoomSnapshot) => void>>()
  private readonly emojiQueues = new Map<string, string[]>()
  private chatroom: PartyChatroomController | null = null
  private readonly communicationStops: WatchStopHandle[] = []
  private readonly languageCodes = new Map<string, string>()
  private languagesCache: PartyLanguageOption[] | undefined
  private languagesRequest: Promise<PartyLanguageOption[]> | undefined
  private directoryRequest: Promise<PartyDirectory> | undefined
  private activeRoomId = ''
  private communicationEpoch = 0
  private communicationPromise: Promise<void> | null = null
  private communicationRoomId = ''
  private communicationVisible = true
  private communicationVisibilityEpoch = 0
  private chatroomObserversBoundTo: PartyChatroomController | null = null
  private recoveryPromise: Promise<void> | null = null
  private retainedResumeCommunicationEpoch = -1
  private retainedResumePromise: Promise<void> | null = null
  private communicationPhase: 'connecting' | 'reconnecting' | null = null
  private reconnectNoticeTimer = 0
  private reconnectRecoveryTimer = 0
  private publishedMusicId = ''
  private readonly musicRevisions = new Map<string, number>()

  isAvailable(): boolean {
    return true
  }

  managesCommunication(): boolean {
    return true
  }

  async getDirectory(): Promise<PartyDirectory> {
    if (this.directoryRequest) return this.directoryRequest
    this.directoryRequest = this.loadDirectory().finally(() => {
      this.directoryRequest = undefined
    })
    return this.directoryRequest
  }

  async setMemberFollowed(memberValue: PartyMember, followed: boolean): Promise<void> {
    await getAnchorProfileRepository().setFollowed(memberValue.id, followed)
  }

  private async loadDirectory(): Promise<PartyDirectory> {
    const [conditionResult, myRoomResult] = await Promise.all([
      this.api.post<unknown>({ data: {}, path: PATH.createConditions }),
      this.api.post<unknown>({ data: {}, path: PATH.myRoom }),
    ])
    const conditions = record(conditionResult)
    const myRoomValue = record(record(myRoomResult).myRoom)
    return {
      canCreateRoom: boolean(conditions.canCreateRoom),
      createRoomLevel: Math.max(0, integer(conditions.createRoomLevel)),
      createRoomWhitelisted: boolean(conditions.isWithlist),
      myRoom: text(myRoomValue.id) ? this.mapListRoom(myRoomValue) : null,
    }
  }

  async getLanguages(force = false): Promise<PartyLanguageOption[]> {
    if (!force && this.languagesCache) return structuredClone(this.languagesCache)
    if (this.languagesRequest) return structuredClone(await this.languagesRequest)
    this.languagesRequest = this.loadLanguages().finally(() => {
      this.languagesRequest = undefined
    })
    return structuredClone(await this.languagesRequest)
  }

  private async loadLanguages(): Promise<PartyLanguageOption[]> {
    const result = await this.api.post<unknown>({ data: {}, path: PATH.language })
    const languages = rows(result)
      .map((item) => ({ code: text(item.languageCode), name: text(item.languageName) }))
      .filter((item) => item.name)
    const unique = new Map<string, PartyLanguageOption>()
    unique.set('', { code: '', name: 'All' })
    this.languageCodes.clear()
    languages.forEach((item) => {
      unique.set(item.code, item)
      this.languageCodes.set(item.name, item.code)
    })
    this.languagesCache = [...unique.values()]
    return this.languagesCache
  }

  async listRooms(
    tab: PartyTab,
    language = '',
    query = '',
    cursor?: PartyRoomListCursor,
  ): Promise<PartyRoom[]> {
    const languageCode = language === 'All' ? '' : language
    return await this.loadRoomList(tab, languageCode, query.trim(), cursor)
  }

  async getCreateOptions(): Promise<PartyCreateOptions> {
    const [languages, conditionResult, templateResult, backgroundResult] = await Promise.all([
      this.getLanguages(),
      this.api.post<unknown>({ data: {}, path: PATH.createConditions }),
      this.api.post<unknown>({ data: { type: 1 }, path: PATH.roomTemp }),
      this.api.post<unknown>({ data: { offset: 0, pageSize: 100 }, path: PATH.backgrounds }),
    ])
    const conditions = record(conditionResult)
    const templates = rows(templateResult)
      .map((item) => ({
        createRoomLevel: Math.max(0, integer(item.createRoomLevel)),
        id: text(item.roomTempId),
        imageUrl: text(item.imgUrl),
        roomType: 'voice' as const,
      }))
      .filter((item) => item.id && item.imageUrl)
    templates.forEach((item) => this.roomTypes.set(item.id, item.roomType))
    return {
      backgrounds: rows(backgroundResult)
        .filter((item) => integer(item.vaild, 1) === 1)
        .map(partyBackground)
        .filter((item): item is PartyBackground => item !== null),
      canCreateRoom: boolean(conditions.canCreateRoom),
      createRoomLevel: Math.max(0, integer(conditions.createRoomLevel)),
      createRoomWhitelisted: boolean(conditions.isWithlist),
      // 创建页沿用接口返回的 All（空 code）选项，不能因列表筛选改造改变默认建房语言。
      languages,
      templates,
    }
  }

  async getRanking(
    kind: PartyRankingKind,
    period: PartyRankingPeriod,
    scope: PartyRankingScope,
  ): Promise<PartyRankingResult> {
    // The legacy ranking page always sends both fields, including CURRENT. Some
    // deployments reject the otherwise documented optional omission.
    const data: Record<string, unknown> = { periodType: scope, rankType: period }
    const result = record(
      await this.api.post<unknown>({
        data,
        path: kind === 'room' ? PATH.rankingRoom : PATH.rankingPartyRich,
      }),
    )
    const own = record(result.myRank)
    const fallbackUserType = kind === 'room' ? 2 : 1
    return {
      durationSeconds: Math.max(0, integer(result.duration)),
      entries: rows(result.rankList).map((item, index) =>
        rankingEntry(item, index + 1, fallbackUserType),
      ),
      myRank: Object.keys(own).length ? rankingEntry(own, 0, fallbackUserType) : null,
      rewardConfigs: rows(result.rewardConfigs).map(rankingReward),
    }
  }

  async prepareRoomEntry(roomId: string, password?: string): Promise<PartyRoomSnapshot> {
    const cached = this.snapshots.get(roomId)
    if (cached && this.enteredRooms.has(roomId)) return structuredClone(cached)
    const value = await this.api
      .post<unknown>({
        data: {
          ...(password ? { password } : {}),
          roomId: requiredRoomId(roomId),
        },
        path: PATH.enter,
      })
      .catch((cause: unknown) => {
        throw normalizeEntryError(cause)
      })
    const snapshot: PartyRoomSnapshot = {
      communication: { state: 'paused' },
      messages: [],
      room: await this.completeRoom(enterRoom(value)),
    }
    this.snapshots.set(roomId, snapshot)
    this.enteredRooms.add(roomId)
    return structuredClone(snapshot)
  }

  async getRoom(roomId: string): Promise<PartyRoomSnapshot> {
    return await this.prepareRoomEntry(roomId)
  }

  async joinRoom(roomId: string): Promise<PartyRoomSnapshot> {
    let room = this.snapshots.get(roomId)?.room
    if (!room || !this.enteredRooms.has(roomId)) {
      room = (await this.prepareRoomEntry(roomId)).room
    }
    // 语聊 RTC 暂停期间仍以后台麦位与申请队列为唯一数据源。
    this.rtcDisabledRoomIds.add(roomId)
    this.enteredRooms.add(roomId)
    const now = Date.now()
    const persistedMessages = await this.api
      .post<unknown>({
        data: { limit: 30, roomId: Number(roomId) },
        path: PATH.messageList,
      })
      .then((result) =>
        rows(result)
          .map((item) => persistedPartyMessage(item))
          .filter((item): item is PartyMessage => item !== null),
      )
      .catch(() => [])
    const configuredGreeting = room.summary.trim()
    const configuredAnnouncement = room.announcement.trim()
    const snapshot: PartyRoomSnapshot = {
      communication: { state: 'connected' },
      messages: [
        ...(configuredAnnouncement
          ? [
              {
                createdAt: now - 18_000,
                id: `party-system:${room.id}`,
                senderAvatarUrl: '',
                senderId: room.owner.id,
                senderName: '',
                text: configuredAnnouncement,
                type: 'system' as const,
              },
            ]
          : []),
        ...(configuredGreeting && configuredGreeting !== configuredAnnouncement
          ? [
              {
                createdAt: now - 12_000,
                id: `party-greeting:${room.id}`,
                senderAvatarUrl: room.owner.avatarUrl,
                senderId: room.owner.imAccount || room.owner.id,
                senderName: room.owner.displayName,
                senderUserId: room.owner.id,
                senderVip: room.owner.vip,
                text: configuredGreeting,
                type: 'text' as const,
              },
            ]
          : []),
        ...persistedMessages,
      ],
      room,
    }
    this.snapshots.set(roomId, snapshot)
    void this.api
      .post({
        data: { roomId: Number(roomId), type: 2 },
        path: PATH.openEffect,
      })
      .catch(() => undefined)
    return structuredClone(snapshot)
  }

  async leaveRoom(roomId: string): Promise<void> {
    if (!this.enteredRooms.has(roomId)) {
      this.snapshots.delete(roomId)
      this.rtcDisabledRoomIds.delete(roomId)
      this.musicRevisions.delete(roomId)
      this.clearEmojiQueues(roomId)
      return
    }
    const snapshot = this.snapshots.get(roomId)
    const transport = snapshot?.room.transport
    this.communicationVisible = false
    this.communicationVisibilityEpoch += 1
    partyRoomRtc.setAppVisible(false)
    this.heartbeat.stop()
    await this.stopCommunication().catch(() => undefined)
    try {
      await this.api.post({
        data: {
          roomId: Number(roomId),
          seatIndex:
            (transport?.currentSeatIndex ?? -1) >= 0 ? (transport?.currentSeatIndex ?? -1) + 1 : -1,
          yxRoomId: transport?.chatRoomId ?? '',
        },
        path: PATH.exit,
      })
    } finally {
      this.snapshots.delete(roomId)
      this.enteredRooms.delete(roomId)
      this.rtcDisabledRoomIds.delete(roomId)
      this.musicRevisions.delete(roomId)
      this.clearEmojiQueues(roomId)
    }
  }

  async setRoomVisible(
    roomId: string,
    _visible: boolean,
    _options: PartyRoomRecoveryOptions = {},
  ): Promise<void> {
    if (!this.enteredRooms.has(roomId)) return
    this.setCommunication(roomId, _visible ? 'connected' : 'paused')
  }

  async retryRoomCommunication(
    roomId: string,
    _options: PartyRoomRecoveryOptions = {},
  ): Promise<void> {
    if (this.enteredRooms.has(roomId)) this.setCommunication(roomId, 'connected')
  }

  async createRoom(input: PartyCreateInput): Promise<PartyRoom> {
    const conditions = record(
      await this.api.post<unknown>({ data: {}, path: PATH.createConditions }),
    )
    if (!boolean(conditions.canCreateRoom))
      throw new Error('This account cannot create a voice room yet.')
    const roomTempId = integer(input.templateId)
    if (roomTempId <= 0) throw new Error('No voice-room template is available.')
    const session = useSessionStore()
    const created = record(
      await this.api.post<unknown>({
        data: {
          greetingMessage: input.summary.trim(),
          roomAvatar: input.coverUrl,
          roomLanguage:
            input.language === 'All'
              ? ''
              : (this.languageCodes.get(input.language) ?? input.language),
          roomName: input.title.trim(),
          roomTempId,
          bgImgId: input.backgroundId ? Number(input.backgroundId) : undefined,
        },
        path: PATH.create,
      }),
    )
    const id = text(created.id)
    if (!id) throw new Error('The voice-room response did not include a room ID.')
    const user = session.user
    const roomOwner = member(
      {
        avatar: user?.avatar ?? '',
        nickname: user?.displayName ?? '',
        roomRoleType: 1,
        userId: user?.id ?? '',
        yxAccid: session.profile?.imAccount || user?.id || '',
      },
      true,
    )
    const room: PartyRoom = {
      announcement: input.summary.trim(),
      backgroundUrl: '',
      banners: [],
      coverUrl: input.coverUrl,
      cornerBanners: [],
      ended: false,
      followed: true,
      frameUrl: '',
      heat: 0,
      honor: 0,
      id,
      inviteIntervalSeconds: 3600,
      language: input.language,
      locked: false,
      musicAvailable: true,
      onSeatApplyEnabled: false,
      platformAdmin: false,
      queueCount: 0,
      role: 'owner',
      memberAvatars: [user?.avatar ?? ''].filter(Boolean),
      memberCount: 1,
      owner: roomOwner,
      recentAt: Date.now(),
      seats: [],
      summary: input.summary.trim(),
      title: input.title.trim(),
      roomType: this.roomTypes.get(input.templateId) ?? 'voice',
      score: 0,
      snapshotId: '',
      transport: {
        channelName: text(created.agoraChannelId),
        chatRoomId: text(created.yxRoomId),
        currentSeatIndex: -1,
        roomTempId: String(roomTempId),
      },
    }
    return structuredClone(room)
  }

  async uploadRoomCover(blob: Blob, signal?: AbortSignal): Promise<string> {
    return await getMediaRepository().uploadImage(blob, signal)
  }

  async getGiftCatalog(roomId: string): Promise<PartyGiftCatalog> {
    let response: unknown
    try {
      response = await this.api.post<unknown>({
        data: { apiVersion: 2, roomId: Number(roomId), showType: '0' },
        path: PATH.giftPanel,
      })
    } catch {
      response = await this.api.post<unknown>({
        data: { apiVersion: 1, roomId: Number(roomId), showType: '0' },
        path: PATH.giftPanel,
      })
    }
    const result = record(response)
    const v2Tabs = rows(result.tabs)
      .map((tab, index) => ({ index, tab, tabSort: integer(tab.tabSort, index) }))
      .sort((left, right) => left.tabSort - right.tabSort || left.index - right.index)
    const categories: Array<{ tab: UnknownRecord; version: 1 | 2 }> = v2Tabs.length
      ? v2Tabs.map(({ tab }) => ({ tab, version: 2 }))
      : rows(result.giftInfoDtoList).map((tab) => ({ tab, version: 1 }))
    const gifts = categories.flatMap(({ tab, version }) => {
      const category = text(tab.tabName || tab.tabCode, 'Gift')
      const exclusive =
        text(tab.tabCode || tab.tabName)
          .replace(/[\s_-]+/gu, '')
          .toLowerCase() === 'exclusive'
      const primaryValues = version === 2 ? rows(tab.gifts) : rows(tab.giftVoList)
      const values = primaryValues.length ? primaryValues : rows(tab, 'giftInfoDtoList')
      return values
        .map((gift) => partyGift(gift, category, exclusive))
        .filter((gift): gift is GiftItem => gift !== null)
    })
    const counts = giftCounts(result.sendGiftConfig)
    return {
      balance: Math.max(0, integer(result.userDiamond)),
      counts: counts.length ? counts : [1, 5, 10, 99],
      gifts,
    }
  }

  async getViewers(roomId: string): Promise<PartyMember[]> {
    const room = this.snapshots.get(roomId)?.room
    const canManage = room?.role === 'owner' || room?.role === 'admin' || room?.platformAdmin
    const result = await this.api.post<unknown>({
      data: { pageNum: 1, pageSize: 100, roomId: Number(roomId), type: canManage ? 1 : 0 },
      path: PATH.viewers,
    })
    return rows(result).map((item) =>
      member(item, text(item.userId) === this.snapshots.get(roomId)?.room.owner.id),
    )
  }

  async getRoomMember(roomId: string, userId: string, signal?: AbortSignal): Promise<PartyMember> {
    const result = await this.api.post<unknown>({
      data: { roomId: Number(roomId), userId: Number(userId) },
      path: PATH.roomInfoCard,
      signal,
    })
    return roomInfoCardMember(result, userId === this.requireSnapshot(roomId).room.owner.id)
  }

  async getBackgrounds(): Promise<PartyBackground[]> {
    const result = await this.api.post<unknown>({
      data: { offset: 0, pageSize: 100 },
      path: PATH.backgrounds,
    })
    return rows(result)
      .filter((item) => integer(item.vaild, 1) === 1)
      .map(partyBackground)
      .filter((item): item is PartyBackground => item !== null)
  }

  async getCurrentBackground(roomId: string): Promise<PartyBackground | null> {
    const result = await this.api.post<unknown>({
      data: { roomId: Number(roomId) },
      path: PATH.backgroundGet,
    })
    return partyBackground(result)
  }

  async getRoomTemplates(roomType: PartyRoom['roomType']): Promise<PartyRoomTemplate[]> {
    const result = await this.api.post<unknown>({
      data: { type: roomType === 'live-voice' ? 2 : 1 },
      path: PATH.roomTemp,
    })
    const templates = rows(result)
      .map((item) => ({
        createRoomLevel: Math.max(0, integer(item.createRoomLevel)),
        id: text(item.roomTempId),
        imageUrl: text(item.imgUrl),
        roomType,
      }))
      .filter((item) => item.id && item.imageUrl)
    templates.forEach((item) => this.roomTypes.set(item.id, item.roomType))
    return templates
  }

  async getBlacklist(roomId: string): Promise<PartyBlacklistEntry[]> {
    const result = await this.api.post<unknown>({
      data: { roomId: Number(roomId) },
      path: PATH.blacklist,
    })
    return rows(result).map((item) => ({
      banType: integer(item.banType, 1) === 2 ? 2 : 1,
      duration: Math.max(0, integer(item.duration)),
      member: member(item),
    }))
  }

  async removeFromBlacklist(roomId: string, target: PartyMember): Promise<void> {
    await this.api.post({
      data: { roomId: Number(roomId), targetUserId: Number(target.id) },
      path: PATH.blacklistRemove,
    })
  }

  async inviteMembers(roomId: string, imAccounts: string[]): Promise<void> {
    const inviteYxAccIds = [...new Set(imAccounts.filter(Boolean))]
    if (!inviteYxAccIds.length) return
    await this.api.post({
      data: { inviteYxAccIds, roomId: Number(roomId) },
      path: PATH.invite,
    })
  }

  async getInviteCandidates(roomId: string, followType?: 0 | 1): Promise<PartyMember[]> {
    const result =
      followType === undefined
        ? await this.api.post<unknown>({
            data: { pageNum: 1, pageSize: 100, roomId: Number(roomId) },
            path: PATH.inviteRecommend,
          })
        : await this.api.post<unknown>({
            data: { followType },
            path: PATH.inviteFollow,
          })
    const values = rows(result).map(inviteMember)
    return [
      ...new Map(
        values.filter((item) => item.id && item.imAccount).map((item) => [item.id, item]),
      ).values(),
    ]
  }

  async kickMember(
    roomId: string,
    target: PartyMember,
    banType: 1 | 2,
  ): Promise<PartyRoomSnapshot> {
    const snapshot = this.requireSnapshot(roomId)
    const seatIndex = snapshot.room.seats.find((item) => item.member?.id === target.id)?.index ?? -2
    await this.api.post({
      data: {
        banType,
        roomId: Number(roomId),
        seatIndex: seatIndex + 1,
        targetUserId: Number(target.id),
        yxRoomId: snapshot.room.transport?.chatRoomId ?? '',
      },
      path: PATH.kickMember,
    })
    snapshot.room.seats.forEach((seatItem) => {
      if (seatItem.member?.id === target.id) seatItem.member = null
    })
    snapshot.room.memberAvatars = snapshot.room.memberAvatars.filter(
      (avatarUrl) => avatarUrl !== target.avatarUrl,
    )
    snapshot.room.memberCount = Math.max(1, snapshot.room.memberCount - 1)
    this.emit(roomId)
    return structuredClone(snapshot)
  }

  async setMemberAdmin(roomId: string, target: PartyMember, admin: boolean): Promise<void> {
    await this.api.post({
      data: { operationType: admin ? 1 : 2, roomId: Number(roomId), userId: Number(target.id) },
      path: PATH.roomSetAdmin,
    })
    const snapshot = this.requireSnapshot(roomId)
    const active = snapshot.room.seats.find((item) => item.member?.id === target.id)?.member
    if (active) active.roomRole = admin ? 'admin' : 'member'
    this.emit(roomId)
  }

  async getQueue(roomId: string): Promise<PartyQueueState> {
    const result = record(
      await this.api.post<unknown>({ data: { roomId: Number(roomId) }, path: PATH.queueList }),
    )
    return {
      entries: rows(result.records).map((item) => ({
        member: member(item),
        queueIndex: Math.max(0, integer(item.queueIndex)),
        seatIndex: Math.max(0, integer(item.seatIndex, 1) - 1),
        seatType: integer(item.seatType, 2) === 1 ? 'video' : 'audio',
      })),
      myIndex: Math.max(0, integer(result.myIndex)),
      total: Math.max(0, integer(result.totalNum)),
    }
  }

  async approveQueueEntry(roomId: string, entry: PartyQueueEntry): Promise<PartyRoomSnapshot> {
    const room = this.requireSnapshot(roomId).room
    const result = await this.api.post<unknown>({
      data: {
        operatorType: 1,
        roomId: Number(roomId),
        roomTempId: Number(room.transport?.roomTempId),
        seatIndex: entry.seatIndex + 1,
        targetUserId: Number(entry.member.id),
        yxRoomId: room.transport?.chatRoomId ?? '',
      },
      path: PATH.queueAgree,
    })
    assertSeatMutationSucceeded(result)
    return await this.refreshSeats(roomId)
  }

  async refuseQueueEntry(roomId: string, entry: PartyQueueEntry): Promise<PartyRoomSnapshot> {
    const room = this.requireSnapshot(roomId).room
    await this.api.post({
      data: {
        roomId: Number(roomId),
        targetUserId: Number(entry.member.id),
        yxRoomId: room.transport?.chatRoomId ?? '',
      },
      path: PATH.queueRefuse,
    })
    return structuredClone(this.requireSnapshot(roomId))
  }

  async cancelSeatApplication(roomId: string): Promise<PartyRoomSnapshot> {
    const room = this.requireSnapshot(roomId).room
    await this.api.post({
      data: { roomId: Number(roomId), yxRoomId: room.transport?.chatRoomId ?? '' },
      path: PATH.queueCancel,
    })
    room.queueCount = Math.max(0, room.queueCount - 1)
    this.emit(roomId)
    return structuredClone(this.requireSnapshot(roomId))
  }

  async getRank(
    roomId: string,
    period: PartyRankingPeriod,
    kind: PartyRoomRankKind = 'contribution',
    scope: PartyRankingScope = 'CURRENT',
    offset?: number,
  ): Promise<PartyRoomRankResult> {
    const data: Record<string, unknown> = {
      rankType: period,
      roomId: Number(roomId),
    }
    if (scope === 'LAST') data.periodType = scope
    if (offset !== undefined) data.score = offset
    const result = record(
      await this.api.post<unknown>({
        data,
        path: kind === 'contribution' ? PATH.rank : PATH.rankHonor,
      }),
    )
    const mapItem = (value: unknown, fallbackRank = 0): PartyRankItem => {
      const item = record(value)
      return {
        member: member(item),
        rank: Math.max(0, integer(item.rank || item.rankIndex, fallbackRank)),
        score: Math.max(0, integer(item.value || item.rankValue)),
      }
    }
    const own = record(result.myRank)
    const entries = rows(result.rankList).map((item, index) => mapItem(item, index + 1))
    return {
      durationSeconds: Math.max(0, integer(result.duration)),
      entries,
      finished: entries.length < 10,
      myRank: Object.keys(own).length ? mapItem(own) : null,
    }
  }

  async getEmojis(_roomId: string): Promise<PartyEmojiItem[]> {
    const result = await this.api.post<unknown>({
      data: {},
      path: PATH.emojis,
    })
    return rows(result).flatMap((category) =>
      rows(category.emojisList).map((emoji) => ({
        category: text(category.classType),
        categoryCover: text(category.coverImage),
        id: text(emoji.id),
        imageUrl: text(emoji.minImage),
        playType: text(emoji.playType, 'normal'),
        playUrl: text(emoji.gifImage || emoji.minImage),
        resultImages: rows(emoji.resultImages)
          .map((result) => ({
            imageUrl: text(result.image),
            key: text(result.key),
          }))
          .filter((result) => result.imageUrl),
      })),
    )
  }

  async getAnnouncement(roomId: string): Promise<PartyRoomSnapshot> {
    const result = record(
      await this.api.post<unknown>({
        data: { roomId: Number(roomId) },
        path: PATH.announcementGet,
      }),
    )
    const snapshot = this.requireSnapshot(roomId)
    snapshot.room.announcement = text(result.announcement)
    this.emit(roomId)
    return structuredClone(snapshot)
  }

  async dismissEmoji(roomId: string, memberId: string, playUrl: string): Promise<void> {
    const seat = this.snapshots.get(roomId)?.room.seats.find((item) => item.member?.id === memberId)
    if (!seat || seat.emojiUrl !== playUrl) return
    const key = this.emojiQueueKey(roomId, memberId)
    const queue = this.emojiQueues.get(key)
    seat.emojiUrl = queue?.shift() ?? ''
    if (!queue?.length) this.emojiQueues.delete(key)
    this.emit(roomId)
  }

  async getMusic(_roomId: string, musicType: 1 | 2 | 3 = 1): Promise<PartyMusicItem[]> {
    const result = await this.api.post<unknown>({
      data: { musicType, offset: 0, pageSize: 100 },
      path: PATH.music,
    })
    return rows(result).map((item) => ({
      durationSeconds: Math.max(0, integer(item.durationSeconds)),
      id: text(item.songId || item.id),
      liked: boolean(item.isLike || item.like),
      name: text(item.songName, 'Untitled'),
      sourceType: integer(item.musicType) === 3 ? (3 as const) : (1 as const),
      // `type` represents the selected list tab. The API returns the source
      // type (system/local), which would otherwise make Liked rows disappear.
      type: musicType,
      url: text(item.musicUrl),
    }))
  }

  async playMusic(
    roomId: string,
    music: PartyMusicItem,
    options?: { playMode?: 1 | 2 | 3; volume?: number },
  ): Promise<void> {
    const current =
      this.snapshots.get(roomId)?.musicSettings ??
      (await this.getMusicSettings(roomId).catch(() => null))
    const volume = Math.min(200, Math.max(0, options?.volume ?? current?.volume ?? 100))
    if (!music.url) throw new Error('The selected music file is unavailable.')
    const mode = options?.playMode ?? current?.playMode ?? 1
    const rtcDisabled = this.rtcDisabledRoomIds.has(roomId)
    this.markMusicMutation(roomId)
    const newTrack = rtcDisabled
      ? this.publishedMusicId !== music.id
      : this.publishedMusicId !== music.id || !partyRoomRtc.hasRoomMusicTrack()
    if (!rtcDisabled) {
      if (!newTrack) {
        partyRoomRtc.setRoomMusicVolume(volume)
        partyRoomRtc.setRoomMusicLoop(mode === 2)
        if (!current?.playing) partyRoomRtc.resumeRoomMusic(current?.positionSeconds)
      } else {
        await partyRoomRtc.playRoomMusic(music.url, {
          loop: mode === 2,
          positionSeconds: current?.currentSongId === music.id ? current.positionSeconds : 0,
          volume,
        })
      }
    }
    this.publishedMusicId = music.id
    try {
      const succeeded = await this.api.post<unknown>({
        data: {
          actionType: 1,
          musicType: music.type === 2 ? 2 : 1,
          playMode: mode,
          roomId: Number(roomId),
          songId: Number(music.id),
          volume,
        },
        path: PATH.musicPlay,
      })
      if (!boolean(succeeded)) throw new Error('The server did not start music playback.')
    } catch (cause) {
      if (!rtcDisabled && newTrack) {
        await partyRoomRtc.stopRoomMusic().catch(() => undefined)
        this.publishedMusicId = ''
      } else if (!rtcDisabled) {
        partyRoomRtc.setRoomMusicVolume(current?.volume ?? 100)
        partyRoomRtc.setRoomMusicLoop(current?.playMode === 2)
        if (!current?.playing) partyRoomRtc.pauseRoomMusic()
      }
      throw cause
    }
    const snapshot = this.snapshots.get(roomId)
    if (snapshot) {
      snapshot.musicSettings = {
        currentSongId: music.id,
        enabled: true,
        muted: current?.muted ?? false,
        playMode: mode,
        playing: true,
        positionSeconds:
          !newTrack && current?.currentSongId === music.id ? current.positionSeconds : 0,
        songName: music.name,
        url: music.url,
        volume,
      }
      this.emit(roomId)
    }
  }

  async pauseMusic(roomId: string): Promise<void> {
    this.markMusicMutation(roomId)
    const succeeded = await this.api.post<unknown>({
      data: { actionType: 2, roomId: Number(roomId) },
      path: PATH.musicPlay,
    })
    if (!boolean(succeeded)) throw new Error('The server did not pause music playback.')
    if (!this.rtcDisabledRoomIds.has(roomId)) partyRoomRtc.pauseRoomMusic()
    const snapshot = this.snapshots.get(roomId)
    if (snapshot?.musicSettings) {
      snapshot.musicSettings = { ...snapshot.musicSettings, playing: false }
      this.emit(roomId)
    }
  }

  async setMusicLiked(music: PartyMusicItem, liked: boolean): Promise<void> {
    await this.api.post({
      data: {
        musicType: music.sourceType,
        songId: Number(music.id),
        type: liked ? 1 : 2,
      },
      path: PATH.musicLike,
    })
  }

  async getMusicSettings(roomId: string): Promise<PartyMusicSettings> {
    const startedAtRevision = this.musicRevision(roomId)
    const item = record(
      await this.api.post<unknown>({ data: { roomId: Number(roomId) }, path: PATH.musicSettings }),
    )
    const mode = integer(item.playMode, 1)
    const settings: PartyMusicSettings = {
      currentSongId: text(item.currentSongId),
      enabled: integer(item.isEnabled) === 1,
      muted: integer(item.isMuted) === 1,
      playMode: ([1, 2, 3].includes(mode) ? mode : 1) as 1 | 2 | 3,
      playing: integer(item.playStatus) === 1,
      positionSeconds: Math.max(0, integer(item.currentPlayPosition)),
      songName: text(item.songName),
      url: text(item.musicUrl),
      volume: Math.min(200, Math.max(0, integer(item.volume, 100))),
    }
    const snapshot = this.snapshots.get(roomId)
    if (this.musicRevision(roomId) !== startedAtRevision)
      return snapshot?.musicSettings ? structuredClone(snapshot.musicSettings) : settings
    if (snapshot) {
      snapshot.musicSettings = settings
      this.emit(roomId)
    }
    return settings
  }

  async setMusicEnabled(roomId: string, enabled: boolean): Promise<void> {
    const transport = this.requireSnapshot(roomId).room.transport
    this.markMusicMutation(roomId)
    const succeeded = await this.api.post<unknown>({
      data: {
        isEnable: enabled ? 1 : 0,
        roomId: Number(roomId),
        yxRoomId: transport?.chatRoomId ?? '',
      },
      path: PATH.musicEnable,
    })
    if (!boolean(succeeded)) throw new Error('The server did not update the music switch.')
    if (!enabled && !this.rtcDisabledRoomIds.has(roomId)) {
      await partyRoomRtc.stopRoomMusic().catch(() => undefined)
      this.publishedMusicId = ''
    } else if (!enabled) {
      this.publishedMusicId = ''
    }
    const snapshot = this.snapshots.get(roomId)
    if (snapshot) {
      const current = snapshot.musicSettings
      snapshot.musicSettings = current
        ? { ...current, enabled, playing: enabled && current.playing }
        : {
            currentSongId: '',
            enabled,
            muted: false,
            playMode: 1,
            playing: false,
            positionSeconds: 0,
            songName: '',
            volume: 100,
          }
      this.emit(roomId)
    }
  }

  async updateMusicSettings(
    roomId: string,
    options: { playMode?: 1 | 2 | 3; volume?: number },
  ): Promise<void> {
    const snapshot = this.requireSnapshot(roomId)
    const current = snapshot.musicSettings
    if (!current?.currentSongId) throw new Error('Select a song before changing music settings.')
    const playMode = options.playMode ?? current.playMode
    const volume = Math.min(200, Math.max(0, options.volume ?? current.volume))
    const rtcDisabled = this.rtcDisabledRoomIds.has(roomId)
    this.markMusicMutation(roomId)
    if (!rtcDisabled) {
      partyRoomRtc.setRoomMusicLoop(playMode === 2)
      partyRoomRtc.setRoomMusicVolume(volume)
    }
    try {
      const succeeded = await this.api.post<unknown>({
        data: {
          playMode,
          playStatus: current.playing ? 1 : 0,
          roomId: Number(roomId),
          songId: Number(current.currentSongId),
          volume,
        },
        path: PATH.musicUpdate,
      })
      if (!boolean(succeeded)) throw new Error('The server did not update the music settings.')
    } catch (cause) {
      if (!rtcDisabled) {
        partyRoomRtc.setRoomMusicLoop(current.playMode === 2)
        partyRoomRtc.setRoomMusicVolume(current.volume)
      }
      throw cause
    }
    snapshot.musicSettings = { ...current, playMode, volume }
    this.emit(roomId)
  }

  async uploadMusic(roomId: string, files: File[], signal?: AbortSignal): Promise<void> {
    if (!files.length) return
    if (files.some((file) => file.size > 10 * 1024 * 1024))
      throw new Error('Each music file must be 10 MB or smaller.')
    const musicList = await Promise.all(
      files.map(async (file) => ({
        songName: file.name.replace(/\.[^.]+$/u, '').trim() || 'Untitled',
        musicUrl: await getMediaRepository().uploadAudio(file, signal),
      })),
    )
    await this.api.post({
      data: { musicList, roomId: Number(roomId) },
      path: PATH.musicUpload,
    })
  }

  async setSoundEnabled(enabled: boolean): Promise<void> {
    if ([...this.rtcDisabledRoomIds].some((roomId) => this.enteredRooms.has(roomId))) return
    await partyRoomRtc.setVoiceSoundEnabled(enabled)
  }

  async takeSeat(roomId: string, seatIndex: number): Promise<PartyRoomSnapshot> {
    const snapshot = this.requireSnapshot(roomId)
    const transport = snapshot.room.transport!
    const targetSeat = snapshot.room.seats.find((item) => item.index === seatIndex)
    const currentSeatIndex = transport.currentSeatIndex
    if (!targetSeat || targetSeat.locked || targetSeat.member)
      throw new Error('This seat is unavailable.')
    const rtcDisabled = this.rtcDisabledRoomIds.has(roomId)
    if (!rtcDisabled) await partyRoomRtc.prepareVoicePublishing(targetSeat.type === 'video')
    let refreshed: PartyRoomSnapshot
    try {
      if (currentSeatIndex >= 0 && currentSeatIndex !== seatIndex)
        assertSeatMutationSucceeded(
          await this.api.post<unknown>({
            data: {
              operatorType: 10,
              roomId: Number(roomId),
              roomTempId: Number(transport.roomTempId),
              seatIndex: seatIndex + 1,
              seatType: targetSeat?.type === 'video' ? 1 : 2,
              yxRoomId: transport.chatRoomId,
            },
            path: PATH.seatExchange,
          }),
        )
      else
        assertSeatMutationSucceeded(
          await this.api.post<unknown>({
            data: {
              isAdmin: snapshot.room.role !== 'member' || snapshot.room.platformAdmin,
              isSelf: true,
              roomId: Number(roomId),
              roomTempId: Number(transport.roomTempId),
              seatIndex: seatIndex + 1,
              yxRoomId: transport.chatRoomId,
            },
            path: PATH.onSeat,
          }),
        )
      refreshed = await this.refreshSeats(roomId)
    } catch (cause) {
      if (!rtcDisabled) {
        const previousSeat = snapshot.room.seats.find((item) => item.index === currentSeatIndex)
        await partyRoomRtc
          .setVoicePublishing(currentSeatIndex >= 0, previousSeat?.type === 'video')
          .catch(() => undefined)
      }
      throw cause
    }
    const currentUserId = useSessionStore().user?.id ?? ''
    const confirmed = refreshed.room.seats.some(
      (item) => item.index === seatIndex && item.member?.id === currentUserId,
    )
    const confirmedSeat = refreshed.room.seats.find((item) => item.index === seatIndex)
    // 开启申请时等待后台审批推送；关闭申请时以后台刷新结果确认直接上麦。
    transport.currentSeatIndex = confirmed ? seatIndex : -1
    this.heartbeat.updateSeat(confirmed ? seatIndex + 1 : -1)
    if (!rtcDisabled)
      await partyRoomRtc.setVoicePublishing(confirmed, confirmed && confirmedSeat?.type === 'video')
    return structuredClone(this.requireSnapshot(roomId))
  }

  async leaveSeat(roomId: string): Promise<PartyRoomSnapshot> {
    const snapshot = this.requireSnapshot(roomId)
    const transport = snapshot.room.transport!
    const seatIndex = transport.currentSeatIndex
    if (seatIndex < 0) return structuredClone(snapshot)
    await this.api.post({
      data: {
        roomId: Number(roomId),
        roomTempId: Number(transport.roomTempId),
        seatIndex: seatIndex + 1,
        yxRoomId: transport.chatRoomId,
      },
      path: PATH.seatDown,
    })
    transport.currentSeatIndex = -1
    this.heartbeat.updateSeat(-1)
    if (!this.rtcDisabledRoomIds.has(roomId)) await partyRoomRtc.setVoicePublishing(false)
    return await this.refreshSeats(roomId)
  }

  async holdMemberOnSeat(
    roomId: string,
    seatIndex: number,
    member: PartyMember,
  ): Promise<PartyRoomSnapshot> {
    const snapshot = this.requireSnapshot(roomId)
    const transport = snapshot.room.transport!
    const targetSeat = snapshot.room.seats.find((item) => item.index === seatIndex)
    const result = await this.api.post<unknown>({
      data: {
        operatorType: targetSeat?.type === 'video' ? 4 : 1,
        roomId: Number(roomId),
        roomTempId: Number(transport.roomTempId),
        seatIndex: seatIndex + 1,
        targetUserId: Number(member.id),
        yxRoomId: transport.chatRoomId,
      },
      path: PATH.seatHold,
    })
    assertSeatMutationSucceeded(result)
    return await this.refreshSeats(roomId)
  }

  async moderateSeat(
    roomId: string,
    seatIndex: number,
    action: 'kick' | 'lock' | 'mute' | 'unlock' | 'unmute',
  ): Promise<PartyRoomSnapshot> {
    const snapshot = this.requireSnapshot(roomId)
    const transport = snapshot.room.transport!
    const target = snapshot.room.seats.find((item) => item.index === seatIndex)
    const rtcDisabled = this.rtcDisabledRoomIds.has(roomId)
    const base = {
      roomId: Number(roomId),
      roomTempId: Number(transport.roomTempId),
      seatIndex: seatIndex + 1,
      yxRoomId: transport.chatRoomId,
    }
    if (action === 'lock' || action === 'unlock')
      await this.api.post({
        data: { ...base, operatorType: action === 'lock' ? 8 : 9 },
        path: PATH.seatLock,
      })
    else if (action === 'kick')
      assertSeatMutationSucceeded(
        await this.api.post<unknown>({
          data: { ...base, operatorType: 3, targetUserId: Number(target?.member?.id) },
          path: PATH.seatHold,
        }),
      )
    else if (target && target.member?.id === useSessionStore().user?.id) {
      const wasPublishing = !rtcDisabled && partyRoomRtc.voicePublishing.value
      const withVideo = target.type === 'video'
      if (action === 'unmute' && !rtcDisabled) {
        try {
          await partyRoomRtc.prepareVoicePublishing(withVideo)
          await partyRoomRtc.setVoicePublishing(true, withVideo)
        } catch (cause) {
          if (!wasPublishing) await partyRoomRtc.setVoicePublishing(false).catch(() => undefined)
          throw cause
        }
      }
      try {
        await this.api.post({
          data: {
            enable: action === 'unmute' ? 1 : 0,
            roomId: Number(roomId),
            seatIndex: seatIndex + 1,
            type: 1,
            yxRoomId: transport.chatRoomId,
          },
          path: PATH.seatMedia,
        })
      } catch (cause) {
        if (!rtcDisabled && action === 'unmute' && !wasPublishing)
          await partyRoomRtc.setVoicePublishing(false).catch(() => undefined)
        else if (!rtcDisabled && action === 'unmute')
          await partyRoomRtc.setMicrophoneMuted(true).catch(() => undefined)
        throw cause
      }
      if (!rtcDisabled) await partyRoomRtc.setMicrophoneMuted(action === 'mute')
    } else
      await this.api.post({
        data: { ...base, operatorType: action === 'mute' ? 6 : 7 },
        path: PATH.seatProhibit,
      })
    if ((action === 'mute' || action === 'unmute') && target) {
      const enabled = action === 'unmute'
      if (target.member?.id === useSessionStore().user?.id) target.microphoneEnabled = enabled
      else target.prohibited = !enabled
      if (target.member) target.member.muted = !target.microphoneEnabled || target.prohibited
      this.emit(roomId)
      return structuredClone(snapshot)
    }
    return await this.refreshSeats(roomId)
  }

  async setSeatMedia(
    roomId: string,
    seatIndex: number,
    media: 'camera' | 'microphone',
    enabled: boolean,
  ): Promise<PartyRoomSnapshot> {
    const snapshot = this.requireSnapshot(roomId)
    const room = snapshot.room
    const target = room.seats.find((item) => item.index === seatIndex)
    const rtcDisabled = this.rtcDisabledRoomIds.has(roomId)
    const wasPublishing = !rtcDisabled && partyRoomRtc.voicePublishing.value
    if (enabled && !rtcDisabled) {
      try {
        await partyRoomRtc.prepareVoicePublishing(media === 'camera')
        await partyRoomRtc.setVoicePublishing(true, media === 'camera')
      } catch (cause) {
        if (media === 'camera' && wasPublishing)
          await partyRoomRtc.setVoicePublishing(true, false).catch(() => undefined)
        else if (!wasPublishing) await partyRoomRtc.setVoicePublishing(false).catch(() => undefined)
        throw cause
      }
    }
    try {
      await this.api.post({
        data: {
          enable: enabled ? 1 : 0,
          roomId: Number(roomId),
          seatIndex: seatIndex + 1,
          type: media === 'camera' ? 2 : 1,
          yxRoomId: room.transport?.chatRoomId ?? '',
        },
        path: PATH.seatMedia,
      })
    } catch (cause) {
      if (!rtcDisabled && enabled && media === 'camera' && wasPublishing)
        await partyRoomRtc.setVoicePublishing(true, false).catch(() => undefined)
      else if (!rtcDisabled && enabled && !wasPublishing)
        await partyRoomRtc.setVoicePublishing(false).catch(() => undefined)
      else if (!rtcDisabled && enabled)
        await partyRoomRtc.setMicrophoneMuted(true).catch(() => undefined)
      throw cause
    }
    if (!rtcDisabled) {
      if (media === 'camera') await partyRoomRtc.setCameraMuted(!enabled)
      else await partyRoomRtc.setMicrophoneMuted(!enabled)
    }
    if (target) {
      if (media === 'camera') target.cameraEnabled = enabled
      else {
        target.microphoneEnabled = enabled
        if (target.member) target.member.muted = !enabled || target.prohibited
      }
    }
    this.emit(roomId)
    return structuredClone(snapshot)
  }

  async setAnnouncement(roomId: string, announcement: string): Promise<PartyRoomSnapshot> {
    await this.api.post({
      data: { announcement: announcement.trim().slice(0, 240), roomId: Number(roomId) },
      path: PATH.announcementEdit,
    })
    const snapshot = this.requireSnapshot(roomId)
    snapshot.room.announcement = announcement.trim().slice(0, 240)
    this.emit(roomId)
    return structuredClone(snapshot)
  }

  async setRoomLock(
    roomId: string,
    locked: boolean,
    password?: string,
  ): Promise<PartyRoomSnapshot> {
    if (locked && !/^\d{4}$/u.test(password ?? ''))
      throw new Error('Enter a 4-digit room password.')
    await this.api.post({
      data: {
        lockRoomFlag: locked ? 1 : 0,
        password: locked ? password : undefined,
        roomId: Number(roomId),
      },
      path: PATH.roomLock,
    })
    const snapshot = this.requireSnapshot(roomId)
    snapshot.room.locked = locked
    this.emit(roomId)
    return structuredClone(snapshot)
  }

  async setOnSeatApplyEnabled(roomId: string, enabled: boolean): Promise<PartyRoomSnapshot> {
    await this.api.post({
      data: { enable: enabled ? 1 : 0, roomId: Number(roomId) },
      path: PATH.roomSeatApply,
    })
    const snapshot = this.requireSnapshot(roomId)
    snapshot.room.onSeatApplyEnabled = enabled
    this.emit(roomId)
    return structuredClone(snapshot)
  }

  async setBackground(roomId: string, background: PartyBackground): Promise<PartyRoomSnapshot> {
    await this.api.post({
      data: { bgImgId: Number(background.id), roomId: Number(roomId) },
      path: PATH.backgroundSet,
    })
    const snapshot = this.requireSnapshot(roomId)
    snapshot.room.backgroundUrl = background.imageUrl
    this.emit(roomId)
    return structuredClone(snapshot)
  }

  async setRoomTemplate(roomId: string, template: PartyRoomTemplate): Promise<PartyRoomSnapshot> {
    const snapshot = this.requireSnapshot(roomId)
    const transport = snapshot.room.transport
    await this.api.post({
      data: {
        oldTempId: Number(transport?.roomTempId),
        roomId: Number(roomId),
        roomTempId: Number(template.id),
        yxRoomId: transport?.chatRoomId ?? '',
      },
      path: PATH.seatSwitchTemplate,
    })
    if (transport) transport.roomTempId = template.id
    snapshot.room.roomType = template.roomType
    return await this.refreshSeats(roomId)
  }

  async sendMessage(roomId: string, value: string): Promise<PartyRoomSnapshot> {
    if (!this.chatroom) {
      const snapshot = this.requireSnapshot(roomId)
      const content = value.trim()
      if (!content) return structuredClone(snapshot)
      const result = await this.api.post<unknown>({
        data: { content, roomId: Number(roomId) },
        path: PATH.messageSend,
      })
      const message = persistedPartyMessage(result)
      if (!message) throw new Error('The saved voice-room message is invalid.')
      snapshot.messages.push(message)
      snapshot.messages = snapshot.messages.slice(-100)
      this.emit(roomId)
      return structuredClone(snapshot)
    }
    const room = this.requireSnapshot(roomId).room
    await this.chatroom.sendText(value, {
      isPlatformAdmin: room.platformAdmin,
      role: partyRoomRoleType(room.role),
    })
    this.syncChatMessages(roomId)
    return structuredClone(this.requireSnapshot(roomId))
  }

  async sendEmoji(roomId: string, emoji: PartyEmojiItem): Promise<PartyRoomSnapshot> {
    const snapshot = this.requireSnapshot(roomId)
    const currentUserId = useSessionStore().user?.id ?? ''
    const currentSeat = snapshot.room.seats.find((item) => item.member?.id === currentUserId)
    if (!currentSeat) throw new Error('Only members on a seat can use expressions.')
    const isPlayEmoji = Boolean(emoji.playType && emoji.playType !== 'normal')
    const result = isPlayEmoji
      ? emoji.resultImages[Math.floor(Math.random() * emoji.resultImages.length)]
      : undefined
    const playUrl = result?.imageUrl || emoji.playUrl || emoji.imageUrl
    if (!playUrl) throw new Error('The expression result is unavailable.')
    await this.chatroom?.sendCustom(isPlayEmoji ? -11 : -10, {
      id: Number(emoji.id),
      minImage: emoji.imageUrl,
      playUrl,
      playType: isPlayEmoji ? emoji.playType : undefined,
      resultKey: result?.key,
      sendUserId: Number(currentUserId),
      timestamp: Date.now(),
    })
    this.enqueueEmoji(roomId, currentUserId, playUrl)
    this.emit(roomId)
    return structuredClone(snapshot)
  }

  async sendGift(roomId: string, input: PartyGiftInput): Promise<PartyGiftSendResult> {
    const snapshot = this.requireSnapshot(roomId)
    const recipients = input.receiverIds
      .map((id, index) => input.receiverImAccounts[index]?.trim() || id.trim())
      .filter(Boolean)
    if (!recipients.length) throw new Error('Select a gift receiver.')
    const result = record(
      await this.api.post<unknown>({
        data: {
          giftId: Number(input.giftId),
          num: Math.max(1, Math.floor(input.count)),
          roomId: Number(roomId),
          scene: 'PARTY_ROOM',
          yxAccidList: recipients,
        },
        path: PATH.sendGift,
      }),
    )
    const session = useSessionStore()
    if (result.userDiamond !== undefined)
      await session.updateBalance(Math.max(0, integer(result.userDiamond)))
    else {
      const catalog = await this.getGiftCatalog(roomId).catch(() => null)
      if (catalog) await session.updateBalance(catalog.balance)
    }
    const members = [
      snapshot.room.owner,
      ...snapshot.room.seats.flatMap((seat) => (seat.member ? [seat.member] : [])),
    ]
    const currentMember = members.find((member) => member.id === (session.user?.id ?? ''))
    this.chatroom?.appendLocalGift({
      avatarUrl: session.user?.avatar ?? '',
      count: input.count,
      giftEffectUrl: input.animationUrl,
      giftId: input.giftId,
      giftIconUrl: input.iconUrl,
      giftMysteryBox: input.mysteryBox,
      giftName: input.giftName,
      giftReceivers: input.receivers,
      giftType: input.giftType,
      headFrameUrl: currentMember?.headFrameSmallUrl,
      medalUrls: currentMember?.medals,
      nickname: session.user?.displayName ?? '',
      platformAdmin: snapshot.room.platformAdmin,
      receiverIds: input.receiverIds,
      roomRole: snapshot.room.role === 'owner' ? 1 : snapshot.room.role === 'admin' ? 2 : 3,
      senderId: session.user?.id ?? '',
      userLevel: currentMember?.level,
      userType: currentMember?.userType,
      value: Math.max(0, input.price * input.count),
      vip: currentMember?.vip,
    })
    if (this.chatroom) this.syncChatMessages(roomId)
    else {
      const giftValue = Math.max(0, input.price * input.count)
      const giftCost = giftValue * Math.max(1, input.receiverIds.length)
      snapshot.room.honor += giftCost
      snapshot.room.score += giftCost
      snapshot.room.seats.forEach((seat) => {
        if (seat.member && input.receiverIds.includes(seat.member.id)) seat.giftValue += giftValue
      })
      snapshot.messages.push({
        createdAt: Date.now(),
        effectUrl: input.animationUrl,
        giftCount: input.count,
        giftIconUrl: input.iconUrl,
        giftName: input.giftName,
        giftReceiverIds: input.receiverIds,
        giftValue,
        giftCost,
        id: `party-gift:${Date.now()}`,
        presentation: {
          kind: 'gift',
          mysteryBox: input.mysteryBox === true,
          receivers: [...(input.receivers ?? [])],
          senderHeadFrameUrl: currentMember?.headFrameSmallUrl ?? '',
          senderMedalUrls: [...(currentMember?.medals ?? [])],
          senderUserType: currentMember?.userType,
          variant: input.giftType === 8 ? 'named' : 'standard',
        },
        senderAvatarUrl: session.user?.avatar ?? '',
        senderLevel: currentMember?.level,
        senderPlatformAdmin: snapshot.room.platformAdmin,
        senderRoleType: snapshot.room.role === 'owner' ? 1 : snapshot.room.role === 'admin' ? 2 : 3,
        senderId: session.user?.id ?? '',
        senderName: session.user?.displayName ?? '',
        senderUserId: session.user?.id ?? '',
        senderVip: currentMember?.vip,
        text: `sent ${input.giftName} ×${input.count}`,
        type: 'gift',
      })
      this.emit(roomId)
    }
    const balance = Math.max(0, integer(result.userDiamond, session.balance))
    const luckyGift = boolean(result.luckyGift)
    const luckyTotalReward = Math.max(0, integer(result.luckyTotalReward))
    const luckyWinCount = Math.max(0, integer(result.luckyWinCount))
    const luckyDraws = rows(result.luckyDraws).length
    return {
      balance,
      ...(luckyGift
        ? {
            luckyGift: {
              draws: luckyDraws,
              totalReward: luckyTotalReward,
              winCount: luckyWinCount,
              won: luckyTotalReward > 0 || luckyWinCount > 0,
            },
          }
        : {}),
      snapshot: structuredClone(snapshot),
    }
  }

  observe(roomId: string, listener: (snapshot: PartyRoomSnapshot) => void): () => void {
    const bucket = this.listeners.get(roomId) ?? new Set()
    bucket.add(listener)
    this.listeners.set(roomId, bucket)
    const current = this.snapshots.get(roomId)
    if (current) listener(structuredClone(current))
    return () => bucket.delete(listener)
  }

  private async startCommunication(
    snapshot: PartyRoomSnapshot,
    phase: 'connecting' | 'reconnecting',
  ): Promise<void> {
    const room = snapshot.room
    if (this.communicationRoomId === room.id && this.communicationPromise) {
      if (this.communicationVisible && this.communicationHealthy())
        this.setCommunication(room.id, 'connected')
      return this.communicationPromise
    }
    if (this.activeRoomId && this.activeRoomId !== room.id)
      await this.stopCommunication().catch(() => undefined)
    const epoch = ++this.communicationEpoch
    const attempt: PartyCommunicationAttempt = {
      communicationEpoch: epoch,
      roomId: room.id,
      visibilityEpoch: this.communicationVisibilityEpoch,
    }
    this.activeRoomId = room.id
    this.communicationRoomId = room.id
    this.communicationPhase = phase
    this.setCommunication(room.id, phase)
    const task = this.initializeCommunication(snapshot, attempt)
    this.communicationPromise = task
    try {
      await task
      if (this.isCurrentCommunicationAttempt(attempt)) {
        this.communicationPhase = null
        if (this.communicationVisible && this.communicationHealthy()) {
          // NIM 与 Agora 已经是房间音频/消息连接成功的唯一门槛。心跳启动和
          // 本地麦克风发布是后续能力，不能让已进入的房间长期停在 Connecting。
          this.clearReconnectTimers()
          this.setCommunication(room.id, 'connected')
          void this.resumeRetainedCommunication(room.id, this.communicationVisibilityEpoch).catch(
            (cause) => {
              console.warn('[party] failed to activate retained room capabilities', cause)
            },
          )
        } else this.reconcileCommunication(room.id)
      }
    } catch (cause) {
      const isCurrent =
        this.communicationPromise === task &&
        this.communicationRoomId === room.id &&
        this.activeRoomId === room.id &&
        this.communicationEpoch === epoch
      if (!isCurrent) throw cause
      const canReportFailure = this.isCurrentVisibleCommunicationAttempt(attempt)
      this.communicationPromise = null
      this.communicationPhase = null
      if (!canReportFailure) {
        if (!this.communicationVisible) this.setCommunication(room.id, 'paused')
        if (this.communicationVisible) this.reconcileCommunication(room.id)
        return
      }
      this.communicationRoomId = ''
      this.setCommunication(
        room.id,
        'failed',
        cause instanceof Error ? cause.message : 'The room connection failed.',
      )
      await this.stopCommunication().catch(() => undefined)
      throw cause
    }
  }

  private async initializeCommunication(
    snapshot: PartyRoomSnapshot,
    attempt: PartyCommunicationAttempt,
  ): Promise<void> {
    const room = snapshot.room
    const transport = room.transport
    if (!transport?.chatRoomId || !transport.channelName)
      throw new Error('The voice-room connection credentials are incomplete.')
    this.communicationStops.push(
      watch(partyRoomRtc.activeSpeakers, (speakers) => {
        if (!this.isCurrentCommunicationAttempt(attempt)) return
        const current = this.snapshots.get(room.id)
        if (!current) return
        const active = new Set(speakers.map(String))
        current.room.seats = current.room.seats.map((item) => ({
          ...item,
          speaking: Boolean(item.member && active.has(item.member.id)),
        }))
        this.emit(room.id)
      }),
      watch(partyRoomRtc.state, () => {
        if (!this.isCurrentCommunicationAttempt(attempt)) return
        this.syncCommunication(room.id)
      }),
    )
    // Keep the Android/legacy ordering: chatroom -> Agora audience -> heartbeat/publishing.
    // Backgrounding may finish the retained SDK joins, but must never publish or start a beat.
    await this.startChatroom(snapshot, attempt)
    if (!this.isCurrentCommunicationAttempt(attempt)) return
    await this.startRtc(snapshot, attempt)
    if (!this.isCurrentCommunicationAttempt(attempt)) return
    if (!this.communicationHealthy())
      throw new Error('The voice-room audio or message channel failed to connect.')
  }

  private async startChatroom(
    snapshot: PartyRoomSnapshot,
    attempt: PartyCommunicationAttempt,
  ): Promise<void> {
    const room = snapshot.room
    const transport = room.transport
    if (!transport?.chatRoomId || !this.isCurrentCommunicationAttempt(attempt)) return
    const session = useSessionStore()
    const credential = await session.ensureRealtimeCredential()
    if (!this.isCurrentCommunicationAttempt(attempt)) return
    if (!credential) throw new Error('The voice-room message credential is unavailable.')
    const profile = session.profile
    const controller = createPartyChatroomController()
    const previous = this.chatroom
    this.chatroom = controller
    if (previous && previous !== controller) await previous.close().catch(() => undefined)
    await controller.connect({
      credential,
      hostImAccount: room.owner.imAccount,
      historyLimit: 30,
      initialOnlineCount: room.memberCount,
      messageLimit: 100,
      roomId: transport.chatRoomId,
      tags: ['party_room'],
      user: {
        avatarUrl: profile?.avatarUrl || session.user?.avatar || '',
        displayName: profile?.displayName || session.user?.displayName || '',
        id: profile?.id || session.user?.id || '',
        ...(profile ? { isVip: profile.vip || profile.vipExpireAt > Date.now() } : {}),
        ...(profile?.levelName.trim() ? { userLevel: profile.levelName.trim() } : {}),
      },
      ...(room.announcement.trim() ? { announcementText: room.announcement.trim() } : {}),
      ...(this.shouldShowWelcome(room)
        ? {
            welcomeMessage: {
              avatarUrl: room.owner.avatarUrl,
              nickname: room.owner.displayName,
              senderId: room.owner.imAccount || room.owner.id,
              text: room.summary.trim(),
            },
          }
        : {}),
    })
    if (!this.isCurrentCommunicationAttempt(attempt)) {
      await controller.close().catch(() => undefined)
      if (this.chatroom === controller) this.chatroom = null
      return
    }
    if (controller.state.value !== 'connected')
      throw controller.error.value ?? new Error('The voice-room message channel failed to connect.')
    this.bindChatroomObservers(controller, room, attempt.communicationEpoch)
  }

  private bindChatroomObservers(
    controller: PartyChatroomController,
    room: PartyRoom,
    epoch: number,
  ): void {
    if (this.chatroomObserversBoundTo === controller) return
    this.chatroomObserversBoundTo = controller
    const session = useSessionStore()
    this.syncChatMessages(room.id)
    this.communicationStops.push(
      watch(controller.messages, () => this.syncChatMessages(room.id)),
      watch(controller.onlineCount, () => this.syncChatMessages(room.id)),
      watch(controller.state, (state) => {
        if (epoch !== this.communicationEpoch) return
        const current = this.snapshots.get(room.id)
        if (!current) return
        if (state === 'kicked') {
          current.room.ended = true
          current.terminationReason = 'kicked'
          this.emit(room.id)
        } else this.syncCommunication(room.id, controller)
      }),
      watch(controller.entryEffectRevision, () => {
        if (epoch !== this.communicationEpoch) return
        const effect = controller.entryEffect.value
        const current = this.snapshots.get(room.id)
        if (!effect || !current) return
        current.messages.push({
          createdAt: Date.now(),
          effectUrl: effect.effectUrl,
          id: effect.id,
          senderAvatarUrl: effect.avatarUrl,
          senderId: effect.userId,
          senderLevel: effect.userLevel,
          senderName: effect.nickname,
          senderUserId: effect.userId,
          senderVip: effect.vip,
          text: 'Entered Room!',
          presentation: {
            kind: 'entry',
            priority: effect.priority,
            userId: effect.userId,
            variant: 'vehicle',
          },
          type: 'entry',
        })
        this.emit(room.id)
      }),
      watch(controller.businessRevision, () => {
        if (epoch !== this.communicationEpoch) return
        const business = controller.latestBusiness.value
        if (business?.attachType === -10 || business?.attachType === -11) {
          const senderId = text(business.data.sendUserId)
          // 发送方已在 sendEmoji() 本地回显，忽略 IM 自发回流，避免同一表情播放两次。
          if (senderId === (session.user?.id ?? '')) return
          const playUrl = text(
            business.data.playUrl || business.data.gifImage || business.data.minImage,
          )
          const active = this.snapshots
            .get(room.id)
            ?.room.seats.find((item) => item.member?.id === senderId)
          if (active && playUrl) {
            this.enqueueEmoji(room.id, senderId, playUrl)
            this.emit(room.id)
          }
          return
        }
        const current = this.snapshots.get(room.id)
        if (!business || !current) return
        if (business.attachType === 197) {
          const backgroundUrl = text(business.data.bgImageUrl)
          const renderedText = text(business.data.renderedText)
          if (!backgroundUrl && !renderedText) return
          if (current.messages.some((message) => message.id === business.id)) return
          const nickname = text(business.data.nickname)
          const userAvatarUrl = text(business.data.userIcon)
          current.messages.push({
            activityType: 'first-gift',
            createdAt: business.createdAt || Date.now(),
            id: business.id,
            presentation: {
              backgroundUrl,
              giftIconUrl: text(business.data.giftSmallImg),
              giftImageUrl: text(business.data.giftImg),
              isFirstGift: boolean(business.data.isFirstGift),
              kind: 'first-gift',
              nickname,
              renderedText,
              styleKey: text(business.data.styleKey),
              userAvatarUrl,
            },
            senderAvatarUrl: userAvatarUrl,
            senderId: text(business.data.userId || business.data.sendUserId),
            senderName: nickname,
            text: renderedText || 'First Gift Moment',
            type: 'activity',
          })
          this.emit(room.id)
          return
        }
        if (business.attachType === 1009) {
          current.room.ended = true
          current.terminationReason = 'closed'
          this.emit(room.id)
          return
        }
        if (
          business.attachType === 1003 &&
          text(business.data.userId) === (session.user?.id ?? '')
        ) {
          current.room.ended = true
          current.terminationReason = 'kicked'
          this.emit(room.id)
          return
        }
        if (business.attachType === 1025) {
          const url = text(business.data.bigImgUrl || business.data.imgUrl)
          if (url) current.room.backgroundUrl = url
          this.emit(room.id)
          return
        }
        if (business.attachType === 1011 || business.attachType === 1013) {
          this.applyMusicBusinessNotice(room.id, business.attachType, business.data)
          return
        }
        if (business.attachType === 1015) {
          this.applySeatMicrophoneNotice(room.id, business.data)
          return
        }
        if (business.attachType === 1001 || business.attachType === 1017) {
          const seats = rows(business.data, 'seats', 'roomSeatList', 'seatList')
          if (seats.length)
            void this.applySeatList(room.id, business.data).catch(() => this.refreshSeats(room.id))
          else void this.refreshSeats(room.id).catch(() => undefined)
          return
        }
        void this.refreshRoomState(room.id).catch(() => undefined)
      }),
    )
  }

  private applySeatMicrophoneNotice(roomId: string, data: Record<string, unknown>): void {
    const snapshot = this.snapshots.get(roomId)
    if (!snapshot || data.seatMicrophoneEnabled === undefined) return
    const seatIndex = integer(data.seatIndex) - 1
    const target = snapshot.room.seats.find((item) => item.index === seatIndex)
    if (!target) return
    target.prohibited = integer(data.seatMicrophoneEnabled, 1) === 0
    const muted = !target.microphoneEnabled || target.prohibited
    if (target.member) target.member.muted = muted
    if (target.member?.id === useSessionStore().user?.id)
      void partyRoomRtc.setMicrophoneMuted(muted).catch(() => undefined)
    this.emit(roomId)
  }

  private async startRtc(
    snapshot: PartyRoomSnapshot,
    attempt: PartyCommunicationAttempt,
  ): Promise<void> {
    const room = snapshot.room
    const transport = room.transport
    if (!transport?.channelName || !this.isCurrentCommunicationAttempt(attempt)) return
    const credentialRtc = await getLivePkRepository().getRtcCredential()
    if (!this.isCurrentCommunicationAttempt(attempt)) return
    await partyRoomRtc.join(
      {
        appId: getServerRuntimeConfig().rtcAppId,
        channelName: transport.channelName,
        displayName: room.title,
        mode: 'voice',
        role: 'audience',
        roomId: room.id,
        rtcToken: credentialRtc.rtcToken,
        uid: credentialRtc.uid,
      },
      {
        tokenProvider: async () => (await getLivePkRepository().getRtcCredential()).rtcToken,
      },
    )
    if (!this.isCurrentCommunicationAttempt(attempt)) {
      await partyRoomRtc.leave().catch(() => undefined)
      return
    }
  }

  private shouldShowWelcome(room: PartyRoom): boolean {
    const currentUserId = useSessionStore().user?.id ?? ''
    return Boolean(currentUserId && currentUserId !== room.owner.id)
  }

  private async stopCommunication(): Promise<void> {
    const pendingRetainedResume = this.retainedResumePromise
    this.clearReconnectTimers()
    this.communicationEpoch += 1
    this.activeRoomId = ''
    this.communicationPhase = null
    this.communicationPromise = null
    this.communicationRoomId = ''
    this.communicationStops.splice(0).forEach((stop) => stop())
    this.heartbeat.stop()
    this.chatroomObserversBoundTo = null
    const chatroom = this.chatroom
    this.chatroom = null
    this.publishedMusicId = ''
    await Promise.all([
      chatroom?.close().catch(() => undefined),
      pendingRetainedResume?.catch(() => undefined),
    ])
    // retained resume 可能在失效前已经进入异步加密或 Agora 发布；等它退出后
    // 再清一次心跳并离开频道，避免迟到任务污染下一次显式 Retry。
    this.heartbeat.stop()
    await partyRoomRtc.leave().catch(() => undefined)
  }

  private setCommunication(
    roomId: string,
    state: PartyRoomSnapshot['communication']['state'],
    error?: string,
  ): void {
    const snapshot = this.snapshots.get(roomId)
    if (!snapshot) return
    snapshot.communication = { ...(error ? { error } : {}), state }
    this.emit(roomId)
  }

  private syncCommunication(roomId: string, controller = this.chatroom): void {
    if (!controller) return
    const snapshot = this.snapshots.get(roomId)
    if (!this.communicationVisible || snapshot?.communication.state === 'paused') {
      this.clearReconnectTimers()
      return
    }
    const chatState = controller.state.value
    const rtcState = partyRoomRtc.state.value
    if (chatState === 'failed' || rtcState === 'failed') {
      this.clearReconnectTimers()
      this.setCommunication(
        roomId,
        'failed',
        controller.error.value?.message || partyRoomRtc.error.value?.message,
      )
      return
    }
    if (this.communicationPhase) return
    if (chatState === 'connected' && (rtcState === 'active' || rtcState === 'waiting-stream')) {
      this.clearReconnectTimers()
      if (snapshot?.communication.state !== 'connected')
        void this.resumeRetainedCommunication(roomId, this.communicationVisibilityEpoch).catch(
          (cause) => {
            console.warn('[party] failed to resume retained room communication', cause)
          },
        )
      return
    }
    if (chatState === 'kicked' || !this.enteredRooms.has(roomId)) return
    if (!snapshot) return
    if (!this.reconnectNoticeTimer) {
      const communicationEpoch = this.communicationEpoch
      const visibilityEpoch = this.communicationVisibilityEpoch
      this.reconnectNoticeTimer = window.setTimeout(() => {
        this.reconnectNoticeTimer = 0
        if (
          !this.isCurrentVisibleCommunicationAttempt({
            communicationEpoch,
            roomId,
            visibilityEpoch,
          })
        )
          return
        if (this.communicationHealthy(controller) || this.activeRoomId !== roomId) return
        this.setCommunication(roomId, 'reconnecting')
        this.scheduleCommunicationRecovery(roomId, controller, visibilityEpoch, communicationEpoch)
      }, 1_200)
    }
  }

  private communicationHealthy(controller = this.chatroom): boolean {
    if (!controller) return false
    return (
      controller.state.value === 'connected' &&
      (partyRoomRtc.state.value === 'active' || partyRoomRtc.state.value === 'waiting-stream')
    )
  }

  private communicationCanResume(roomId: string): boolean {
    return (
      this.activeRoomId === roomId &&
      !this.communicationPhase &&
      this.communicationHealthy() &&
      partyRoomRtc.canResumeWithoutRejoin(roomId)
    )
  }

  private isCurrentCommunicationAttempt(attempt: PartyCommunicationAttempt): boolean {
    return Boolean(
      this.communicationEpoch === attempt.communicationEpoch &&
      this.activeRoomId === attempt.roomId &&
      this.communicationRoomId === attempt.roomId &&
      this.enteredRooms.has(attempt.roomId),
    )
  }

  private isCurrentVisibleCommunicationAttempt(attempt: PartyCommunicationAttempt): boolean {
    return Boolean(
      this.communicationVisible &&
      this.communicationVisibilityEpoch === attempt.visibilityEpoch &&
      this.isCurrentCommunicationAttempt(attempt),
    )
  }

  private reconcileCommunication(roomId: string): void {
    if (this.activeRoomId !== roomId || !this.enteredRooms.has(roomId)) return
    if (!this.communicationVisible) {
      this.clearReconnectTimers()
      this.setCommunication(roomId, 'paused')
      return
    }
    this.syncCommunication(roomId)
  }

  private handleHeartbeatTerminalFailure(roomId: string, error: Error): void {
    if (this.activeRoomId !== roomId || !this.enteredRooms.has(roomId)) return
    // 旧站的 Socket 心跳独立于 NIM/Agora；心跳耗尽重试不能把仍然健康的
    // 房间音频和消息通道降级成失败。下次生命周期恢复会重新启动心跳。
    console.warn('[party] retained room heartbeat stopped after retries', error)
  }

  private async resumeRetainedCommunication(
    roomId: string,
    visibilityEpoch: number,
    signal?: AbortSignal,
  ): Promise<void> {
    if (this.retainedResumePromise) {
      const pendingCommunicationEpoch = this.retainedResumeCommunicationEpoch
      await this.retainedResumePromise.catch(() => undefined)
      if (!this.shouldRecoverCommunication(roomId, visibilityEpoch, signal)) return
      const current = this.snapshots.get(roomId)
      if (
        pendingCommunicationEpoch === this.communicationEpoch &&
        current?.communication.state === 'connected' &&
        this.communicationCanResume(roomId)
      )
        return
    }
    const resumeCommunicationEpoch = this.communicationEpoch
    const task = (async () => {
      const isCurrentCommunication = (): boolean =>
        this.communicationEpoch === resumeCommunicationEpoch
      const shouldContinue = (): boolean =>
        isCurrentCommunication() && this.shouldRecoverCommunication(roomId, visibilityEpoch, signal)
      if (!shouldContinue() || !this.communicationCanResume(roomId)) return
      const snapshot = this.requireSnapshot(roomId)
      const ownSeat = snapshot.room.seats.find(
        (item) => item.member?.id === useSessionStore().user?.id,
      )
      const shouldPublish = Boolean(ownSeat && !ownSeat.prohibited && !ownSeat.member?.muted)
      this.clearReconnectTimers()
      this.setCommunication(roomId, 'connected')
      const [heartbeatResult, publishingResult] = await Promise.allSettled([
        this.heartbeat.start(roomId, ownSeat ? ownSeat.index + 1 : -1),
        partyRoomRtc.setVoicePublishing(shouldPublish, shouldPublish && ownSeat?.type === 'video'),
      ])
      if (heartbeatResult.status === 'rejected') {
        this.heartbeat.stop()
        console.warn('[party] failed to start retained room heartbeat', heartbeatResult.reason)
      }
      if (publishingResult.status === 'rejected') {
        await partyRoomRtc.setVoicePublishing(false).catch(() => undefined)
        console.warn(
          '[party] failed to restore retained room microphone publishing',
          publishingResult.reason,
        )
      }
      // 显式 Retry/离房已经建立新 communication epoch 时，旧任务无权再静音、
      // 写 Reconnecting 或安排失败计时器；新代任务会接管这些共享 SDK 能力。
      if (!isCurrentCommunication()) return
      if (!shouldContinue() || !this.communicationCanResume(roomId)) {
        this.heartbeat.stop()
        await partyRoomRtc.setVoicePublishing(false).catch(() => undefined)
        if (shouldContinue()) {
          this.setCommunication(roomId, 'reconnecting')
          this.scheduleCommunicationRecovery(roomId, undefined, visibilityEpoch)
        }
        return
      }
      if (this.publishedMusicId && snapshot.musicSettings?.playing) partyRoomRtc.resumeRoomMusic()
      this.clearReconnectTimers()
      if (snapshot.communication.state !== 'connected') this.setCommunication(roomId, 'connected')
    })()
      .catch((cause) => {
        if (this.shouldRecoverCommunication(roomId, visibilityEpoch, signal))
          this.setCommunication(
            roomId,
            'failed',
            cause instanceof Error ? cause.message : 'The room connection failed.',
          )
        throw cause
      })
      .finally(() => {
        if (this.retainedResumePromise === task) {
          this.retainedResumePromise = null
          this.retainedResumeCommunicationEpoch = -1
        }
      })
    this.retainedResumeCommunicationEpoch = resumeCommunicationEpoch
    this.retainedResumePromise = task
    await task
  }

  private shouldRecoverCommunication(
    roomId: string,
    visibilityEpoch: number,
    signal?: AbortSignal,
  ): boolean {
    return Boolean(
      !signal?.aborted &&
      this.communicationVisible &&
      this.communicationVisibilityEpoch === visibilityEpoch &&
      this.enteredRooms.has(roomId),
    )
  }

  private scheduleCommunicationRecovery(
    roomId: string,
    controller = this.chatroom,
    visibilityEpoch = this.communicationVisibilityEpoch,
    communicationEpoch = this.communicationEpoch,
  ): void {
    if (this.reconnectRecoveryTimer) return
    this.reconnectRecoveryTimer = window.setTimeout(() => {
      this.reconnectRecoveryTimer = 0
      if (
        !this.isCurrentVisibleCommunicationAttempt({
          communicationEpoch,
          roomId,
          visibilityEpoch,
        })
      )
        return
      if (this.communicationHealthy(controller) || this.activeRoomId !== roomId) return
      this.setCommunication(
        roomId,
        'failed',
        controller?.error.value?.message ||
          partyRoomRtc.error.value?.message ||
          'The room connection failed.',
      )
    }, 12_000)
  }

  private clearReconnectTimers(): void {
    window.clearTimeout(this.reconnectNoticeTimer)
    window.clearTimeout(this.reconnectRecoveryTimer)
    this.reconnectNoticeTimer = 0
    this.reconnectRecoveryTimer = 0
  }

  private syncChatMessages(roomId: string): void {
    const snapshot = this.snapshots.get(roomId)
    if (!snapshot || !this.chatroom) return
    const previousIds = new Set(snapshot.messages.map((item) => item.id))
    const firstGiftMessages = snapshot.messages.filter(
      (message) => message.activityType === 'first-gift',
    )
    snapshot.messages = this.chatroom.messages.value.map((item) => ({
      activityType: item.activityType,
      createdAt: item.createdAt,
      effectUrl: item.giftEffectUrl,
      giftCount: item.giftCount,
      giftCost: item.giftCost,
      id: item.id,
      giftIconUrl: item.giftIconUrl,
      giftName: item.giftName,
      giftReceiverIds: item.giftReceiverIds,
      giftValue: item.giftValue,
      luckyNumber: item.luckyNumber,
      mentionCurrentUser: item.mentionCurrentUser,
      presentation: partyMessagePresentation(item),
      senderLevel: item.userLevel,
      senderPlatformAdmin: item.platformAdmin,
      senderRoleType: item.roomRole,
      senderAvatarUrl: item.avatarUrl,
      senderId: item.senderId,
      senderName: item.nickname,
      senderUserId: item.userId,
      senderVip: item.vip,
      text: item.text,
      type: item.kind === 'announcement' ? 'system' : item.kind === 'enter' ? 'entry' : item.kind,
    }))
    snapshot.messages.push(
      ...firstGiftMessages.filter(
        (message) => !snapshot.messages.some((candidate) => candidate.id === message.id),
      ),
    )
    snapshot.messages.sort((left, right) => left.createdAt - right.createdAt)
    snapshot.messages
      .filter((message) => message.type === 'gift' && !previousIds.has(message.id))
      .forEach((message) => {
        const value = Math.max(0, message.giftValue ?? 0)
        if (value > 0)
          snapshot.room.seats.forEach((seat) => {
            if (seat.member && message.giftReceiverIds?.includes(seat.member.id))
              seat.giftValue += value
          })
        snapshot.room.score += Math.max(0, message.giftCost ?? 0)
      })
    snapshot.room.memberCount = this.chatroom.onlineCount.value
    this.emit(roomId)
  }

  private async refreshSeats(roomId: string): Promise<PartyRoomSnapshot> {
    const result = await this.api.post<unknown>({
      data: { roomId: Number(roomId) },
      path: PATH.seatList,
    })
    return await this.applySeatList(roomId, result)
  }

  private async applySeatList(roomId: string, result: unknown): Promise<PartyRoomSnapshot> {
    const snapshot = this.requireSnapshot(roomId)
    const previous = snapshot.room.seats
    const currentUserId = useSessionStore().user?.id ?? ''
    const previousOwnSeat = previous.find((item) => item.member?.id === currentUserId)
    snapshot.room.seats = rows(result, 'roomSeatList', 'seatList', 'seats')
      .map(seat)
      .map((item) => {
        const old = previous.find(
          (candidate) => candidate.index === item.index && candidate.member?.id === item.member?.id,
        )
        return old ? { ...item, emojiUrl: old.emojiUrl, speaking: old.speaking } : item
      })
      .sort((a, b) => a.index - b.index)
    const ownSeat = snapshot.room.seats.find((item) => item.member?.id === currentUserId)
    const nextSeatIndex = ownSeat?.index ?? -1
    const previousSeatIndex = snapshot.room.transport?.currentSeatIndex ?? -1
    if (snapshot.room.transport) snapshot.room.transport.currentSeatIndex = nextSeatIndex
    if (nextSeatIndex !== previousSeatIndex || ownSeat?.type !== previousOwnSeat?.type) {
      this.heartbeat.updateSeat(nextSeatIndex >= 0 ? nextSeatIndex + 1 : -1)
      if (!this.rtcDisabledRoomIds.has(roomId))
        await partyRoomRtc
          .setVoicePublishing(nextSeatIndex >= 0, ownSeat?.type === 'video')
          .catch(async (cause) => {
            await partyRoomRtc.setVoicePublishing(false).catch(() => undefined)
            console.warn('[party] failed to synchronize local seat publishing', cause)
          })
    }
    if (ownSeat && !this.rtcDisabledRoomIds.has(roomId)) {
      await partyRoomRtc.setMicrophoneMuted(ownSeat.prohibited || ownSeat.member?.muted === true)
      if (ownSeat.type === 'video')
        await partyRoomRtc.setCameraMuted(!ownSeat.seatCameraEnabled || !ownSeat.cameraEnabled)
    }
    this.emit(roomId)
    return structuredClone(snapshot)
  }

  private emojiQueueKey(roomId: string, memberId: string): string {
    return `${roomId}:${memberId}`
  }

  private enqueueEmoji(roomId: string, memberId: string, playUrl: string): void {
    const seat = this.snapshots.get(roomId)?.room.seats.find((item) => item.member?.id === memberId)
    if (!seat) return
    if (!seat.emojiUrl) {
      seat.emojiUrl = playUrl
      return
    }
    const key = this.emojiQueueKey(roomId, memberId)
    const queue = this.emojiQueues.get(key) ?? []
    queue.push(playUrl)
    this.emojiQueues.set(key, queue)
  }

  private clearEmojiQueues(roomId: string): void {
    const prefix = `${roomId}:`
    for (const key of this.emojiQueues.keys())
      if (key.startsWith(prefix)) this.emojiQueues.delete(key)
  }

  private async refreshRoomState(roomId: string): Promise<void> {
    const snapshot = this.requireSnapshot(roomId)
    const [announcementResult, queueResult, viewersResult, seatsResult] = await Promise.allSettled([
      this.api.post<unknown>({ data: { roomId: Number(roomId) }, path: PATH.announcementGet }),
      this.getQueue(roomId),
      this.getViewers(roomId),
      this.refreshSeats(roomId),
    ])
    if (announcementResult.status === 'fulfilled') {
      const value = record(announcementResult.value)
      snapshot.room.announcement = text(value.announcement, snapshot.room.announcement)
    }
    if (queueResult.status === 'fulfilled') {
      snapshot.queue = queueResult.value
      snapshot.room.queueCount = queueResult.value.total
    }
    if (viewersResult.status === 'fulfilled') {
      const current = viewersResult.value.find((item) => item.id === useSessionStore().user?.id)
      if (current) snapshot.room.role = current.roomRole
      // The viewers endpoint is paged and therefore cannot be used as the room total.
      // NIM's online count is authoritative while the chatroom is connected; otherwise
      // retain the greater server-provided value instead of visibly shrinking the room.
      snapshot.room.memberCount = this.chatroom
        ? this.chatroom.onlineCount.value
        : Math.max(snapshot.room.memberCount, viewersResult.value.length)
    }
    if (seatsResult.status === 'rejected')
      console.warn('[party] failed to synchronize room seats', seatsResult.reason)
    this.emit(roomId)
  }

  private loadRoomList(
    tab: PartyTab,
    languageCode: string,
    query: string,
    cursor?: PartyRoomListCursor,
  ): Promise<PartyRoom[]> {
    const requestKey = `${tab}:${languageCode}:${query}:${cursor?.offset ?? ''}:${cursor?.snapshotId ?? ''}`
    const current = this.listRequests.get(requestKey)
    if (current) return current
    const startedAt = performance.now()
    let count = 0
    let outcome = 'success'
    const request = this.api
      .post<unknown>({
        data: {
          // The archived client omits language filtering for Follow/Recent.
          languageCode: tab === 'party' ? languageCode : null,
          offset: cursor?.offset,
          pageSize: 10,
          queryParam: query || undefined,
          snapshotId: cursor?.snapshotId || undefined,
          version: 'v2',
        },
        path: tab === 'follow' ? PATH.listFollowed : tab === 'recent' ? PATH.listRecent : PATH.list,
      })
      .then((result) => {
        const rooms = rows(result).map((item) => this.mapListRoom(item))
        rooms.forEach((room) => {
          const currentSnapshot = this.snapshots.get(room.id)
          this.snapshots.set(room.id, {
            communication: currentSnapshot?.communication ?? { state: 'paused' },
            messages: currentSnapshot?.messages ?? [],
            room: currentSnapshot?.room.transport?.roomTempId ? currentSnapshot.room : room,
            ...(currentSnapshot?.terminationReason
              ? { terminationReason: currentSnapshot.terminationReason }
              : {}),
          })
        })
        count = rooms.length
        return rooms
      })
      .catch((cause: unknown) => {
        outcome = 'failure'
        throw cause
      })
      .finally(() => {
        reportRuntimeMetric('party.list.request-duration', performance.now() - startedAt, {
          count,
          outcome,
          paginated: Boolean(cursor),
          tab,
        })
      })
      .finally(() => this.listRequests.delete(requestKey))
    this.listRequests.set(requestKey, request)
    return request
  }

  private mapListRoom(value: unknown): PartyRoom {
    const room = listRoom(value)
    return room
  }

  private async completeRoom(room: PartyRoom): Promise<PartyRoom> {
    const [ownerResult, seatsResult, backgroundResult] = await Promise.all([
      !room.owner.imAccount && room.owner.id
        ? this.api
            .post<unknown>({ data: { userId: Number(room.owner.id) }, path: PATH.userGet })
            .catch(() => null)
        : Promise.resolve(null),
      !room.seats.length
        ? this.api
            .post<unknown>({ data: { roomId: Number(room.id) }, path: PATH.seatList })
            .catch(() => null)
        : Promise.resolve(null),
      !room.backgroundUrl
        ? this.api
            .post<unknown>({ data: { roomId: Number(room.id) }, path: PATH.backgroundGet })
            .catch(() => null)
        : Promise.resolve(null),
    ])
    if (ownerResult) {
      const ownerInfo = record(ownerResult)
      const fullOwner = member(ownerInfo, true)
      room.owner = {
        ...room.owner,
        ...(fullOwner.avatarUrl ? { avatarUrl: fullOwner.avatarUrl } : {}),
        ...(fullOwner.displayName ? { displayName: fullOwner.displayName } : {}),
        ...(fullOwner.imAccount ? { imAccount: fullOwner.imAccount } : {}),
      }
    }
    if (!room.seats.length && seatsResult) {
      room.seats = rows(seatsResult, 'roomSeatList', 'seatList', 'seats')
        .map(seat)
        .sort((left, right) => left.index - right.index)
    }
    if (!room.backgroundUrl && backgroundResult) {
      const background = record(backgroundResult)
      room.backgroundUrl = text(background.bigImgUrl || background.imgUrl || background.bgImgUrl)
    }
    const currentUserId = useSessionStore().user?.id ?? ''
    if (room.transport) {
      room.transport.currentSeatIndex =
        room.seats.find((seatItem) => seatItem.member?.id === currentUserId)?.index ?? -1
    }
    return room
  }

  private requireSnapshot(roomId: string): PartyRoomSnapshot {
    const snapshot = this.snapshots.get(roomId)
    if (!snapshot) throw new Error('The voice-room session is unavailable.')
    return snapshot
  }

  private musicRevision(roomId: string): number {
    return this.musicRevisions.get(roomId) ?? 0
  }

  private markMusicMutation(roomId: string): void {
    this.musicRevisions.set(roomId, this.musicRevision(roomId) + 1)
  }

  private applyMusicBusinessNotice(
    roomId: string,
    attachType: 1011 | 1013,
    data: UnknownRecord,
  ): void {
    const snapshot = this.snapshots.get(roomId)
    if (!snapshot) return
    const current = snapshot.musicSettings ?? {
      currentSongId: '',
      enabled: false,
      muted: false,
      playMode: 1 as const,
      playing: false,
      positionSeconds: 0,
      songName: '',
      volume: 100,
    }
    this.markMusicMutation(roomId)
    if (attachType === 1013) {
      snapshot.musicSettings = {
        ...current,
        enabled: boolean(data.isEnable ?? data.isEnabled),
        playing: boolean(data.isEnable ?? data.isEnabled) && current.playing,
      }
      this.emit(roomId)
      return
    }
    const rawMode = integer(data.playMode, current.playMode)
    const nextMode = ([1, 2, 3].includes(rawMode) ? rawMode : current.playMode) as 1 | 2 | 3
    snapshot.musicSettings = {
      ...current,
      currentSongId:
        data.currentSongId !== undefined || data.songId !== undefined
          ? text(data.currentSongId ?? data.songId)
          : current.currentSongId,
      enabled:
        data.isEnabled !== undefined || data.isEnable !== undefined
          ? boolean(data.isEnabled ?? data.isEnable)
          : current.enabled,
      muted: data.isMuted !== undefined ? boolean(data.isMuted) : current.muted,
      playMode: nextMode,
      playing: data.playStatus !== undefined ? integer(data.playStatus) === 1 : current.playing,
      positionSeconds:
        data.currentPlayPosition !== undefined
          ? Math.max(0, integer(data.currentPlayPosition))
          : current.positionSeconds,
      songName: data.songName !== undefined ? text(data.songName) : current.songName,
      volume:
        data.volume !== undefined
          ? Math.min(200, Math.max(0, integer(data.volume, current.volume)))
          : current.volume,
    }
    this.emit(roomId)
  }

  private emit(roomId: string): void {
    const snapshot = this.snapshots.get(roomId)
    if (!snapshot) return
    for (const listener of this.listeners.get(roomId) ?? []) listener(structuredClone(snapshot))
  }
}

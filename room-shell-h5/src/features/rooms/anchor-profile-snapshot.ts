import type { AnchorProfile, HomeRankItem, LiveDiscoveryItem } from './contracts'

const MAX_SNAPSHOTS = 80
const snapshots = new Map<string, AnchorProfile>()

function put(profile: AnchorProfile): AnchorProfile {
  snapshots.delete(profile.id)
  snapshots.set(profile.id, profile)
  if (snapshots.size > MAX_SNAPSHOTS) {
    const oldest = snapshots.keys().next().value
    if (oldest) snapshots.delete(oldest)
  }
  return profile
}

export function rememberDiscoveryProfile(item: LiveDiscoveryItem): AnchorProfile {
  return put({
    age: item.age,
    avatarUrl: item.host.avatarUrl,
    blocked: false,
    countryCode: item.countryCode,
    description: '',
    followed: item.followed,
    followersCount: 0,
    followingCount: 0,
    gender: item.gender,
    gifts: [],
    honors: [],
    id: item.host.id,
    imAccount: item.host.imAccount,
    languages: [],
    levelName: item.levelName,
    likeCount: 0,
    likeRate: null,
    liveRoomId: item.liveRoomId,
    media: [],
    moments: [],
    name: item.host.displayName,
    signature: '',
    status: item.availability,
    videos: [],
    voiceRoomId: item.voiceRoomId,
    userType: 2,
  })
}

export function rememberRankProfile(item: HomeRankItem): AnchorProfile {
  return put({
    age: item.age,
    avatarUrl: item.avatarUrl,
    blocked: false,
    countryCode: item.countryCode,
    description: '',
    followed: item.followed,
    followersCount: 0,
    followingCount: 0,
    gender: 'unknown',
    gifts: [],
    honors: [],
    id: item.id,
    imAccount: item.imAccount,
    languages: [],
    levelName: item.levelName,
    likeCount: 0,
    likeRate: null,
    media: [],
    moments: [],
    name: item.name,
    signature: '',
    status: 'offline',
    videos: [],
    userType: item.userType,
  })
}

export function getAnchorProfileSnapshot(userId: string): AnchorProfile | null {
  return snapshots.get(userId) ?? null
}

export function rememberAnchorProfile(profile: AnchorProfile): AnchorProfile {
  return put(profile)
}

/**
 * 会话列表的批量资料只包含基础字段，但足以让聊天页先展示资料卡，避免 REST 详情接口
 * 返回前整块内容消失。详情成功后仍会由完整 AnchorProfile 覆盖。
 */
export function createConversationProfile(input: {
  avatarUrl: string
  displayName: string
  followed?: boolean
  imAccount: string
  online?: boolean
  signature?: string
  userType?: number
  userId: string
}): AnchorProfile {
  return {
    age: 0,
    avatarUrl: input.avatarUrl,
    blocked: false,
    countryCode: '',
    description: '',
    followed: input.followed ?? false,
    followersCount: 0,
    followingCount: 0,
    gender: 'unknown',
    gifts: [],
    honors: [],
    id: input.userId,
    imAccount: input.imAccount,
    languages: [],
    levelName: '',
    likeCount: 0,
    likeRate: null,
    media: [],
    moments: [],
    name: input.displayName,
    signature: input.signature ?? '',
    status: input.online ? 'online' : 'offline',
    videos: [],
    userType: input.userType ?? 0,
  }
}

export function mergeAnchorProfile(
  snapshot: AnchorProfile | null,
  remote: AnchorProfile,
): AnchorProfile {
  if (!snapshot) return put(remote)
  return put({
    ...remote,
    avatarUrl: remote.avatarUrl || snapshot.avatarUrl,
    countryCode: remote.countryCode || snapshot.countryCode,
    id: remote.id || snapshot.id,
    imAccount: remote.imAccount || snapshot.imAccount,
    levelName: remote.levelName || snapshot.levelName,
    liveRoomId: remote.liveRoomId ?? snapshot.liveRoomId,
    name: remote.name || snapshot.name,
    userType: remote.userType || snapshot.userType,
    voiceRoomId: remote.voiceRoomId ?? snapshot.voiceRoomId,
  })
}

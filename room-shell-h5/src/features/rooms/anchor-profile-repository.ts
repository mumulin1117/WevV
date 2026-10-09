import { getRelationshipRepository } from '@/features/relationships/relationship-repository'
import type {
  AnchorProfile,
  AnchorProfileComment,
  AnchorProfileGift,
  AnchorProfileHonor,
  AnchorProfileMedia,
  AnchorProfileMoment,
  AnchorProfileRepository,
} from './contracts'
import { resolveProductService } from '@/core/product-mode/product-services'
import { getApiClient } from '@/core/auth/runtime'
import { z } from 'zod'

type RecordValue = Record<string, unknown>

const record = (value: unknown): RecordValue | null =>
  value !== null && typeof value === 'object' && !Array.isArray(value)
    ? (value as RecordValue)
    : null
const first = (source: RecordValue, keys: readonly string[]): unknown => {
  for (const key of keys) if (source[key] !== undefined && source[key] !== null) return source[key]
  return undefined
}
const text = (source: RecordValue, ...keys: string[]): string => {
  const value = first(source, keys)
  return value === undefined ? '' : String(value).trim()
}
const number = (source: RecordValue, ...keys: string[]): number => {
  const value = Number(first(source, keys) ?? 0)
  return Number.isFinite(value) ? Math.max(0, Math.trunc(value)) : 0
}
const signedNumber = (source: RecordValue, ...keys: string[]): number => {
  const value = Number(first(source, keys) ?? 0)
  return Number.isFinite(value) ? Math.trunc(value) : 0
}
const objects = (source: RecordValue, ...keys: string[]): RecordValue[] => {
  const value = first(source, keys)
  return Array.isArray(value) ? value.map(record).filter((item) => item !== null) : []
}
const strings = (source: RecordValue, ...keys: string[]): string[] => {
  const value = first(source, keys)
  if (!Array.isArray(value)) return []
  return value
    .map((item) =>
      typeof item === 'string'
        ? item.trim()
        : text(record(item) ?? {}, 'url', 'imgUrl', 'imageUrl', 'photoUrl'),
    )
    .filter(Boolean)
}

function parseMedia(value: RecordValue, fallback: AnchorProfileMedia['type']): AnchorProfileMedia {
  const rawType = text(value, 'type', 'mediaType').toLowerCase()
  const type = ['2', 'video', 'mp4', 'movie'].includes(rawType)
    ? 'video'
    : ['1', 'photo', 'image', 'img', 'picture'].includes(rawType)
      ? 'photo'
      : fallback
  return {
    coverUrl: text(
      value,
      'coverUrl',
      'cover',
      'thumb',
      'thumbnail',
      'poster',
      'imgUrl',
      'imageUrl',
    ),
    duration: text(value, 'duration', 'durationText', 'time'),
    id: text(value, 'id', 'mediaId', 'photoId', 'videoId'),
    title: text(value, 'title', 'name', 'desc', 'description'),
    type,
    url: text(
      value,
      'url',
      'mediaUrl',
      'fileUrl',
      'photoUrl',
      'imageUrl',
      'imgUrl',
      'videoUrl',
      'playUrl',
    ),
  }
}

function parseGift(value: RecordValue): AnchorProfileGift {
  const nested = record(first(value, ['giftData', 'gift', 'giftInfo'])) ?? {}
  return {
    count: number(value, 'giftNum', 'num', 'giftCount', 'count', 'totalNum', 'quantity'),
    iconUrl:
      text(
        value,
        'giftSmallImg',
        'smallImg',
        'giftIcon',
        'giftImg',
        'icon',
        'img',
        'imgUrl',
        'imageUrl',
        'url',
      ) ||
      text(
        nested,
        'giftSmallImg',
        'smallImg',
        'giftIcon',
        'giftImg',
        'icon',
        'img',
        'imgUrl',
        'imageUrl',
        'url',
      ),
    id: text(value, 'giftId', 'id') || text(nested, 'giftId', 'id'),
    name: text(value, 'giftName', 'name', 'title') || text(nested, 'giftName', 'name', 'title'),
  }
}

function parseMoment(value: RecordValue): AnchorProfileMoment {
  return {
    avatarUrl: text(value, 'icon', 'avatar', 'userAvatar'),
    commentCount: number(value, 'commentNum', 'commentCount', 'comments', 'replyCount'),
    createdAt: text(value, 'createTime', 'createdAt', 'publishTime', 'time'),
    id: text(value, 'id', 'momentId', 'dynamicId', 'postId'),
    images: strings(value, 'imgUrls', 'images', 'imageList', 'imgs', 'photos', 'picList'),
    liked: number(value, 'likeFlag', 'liked') === 1,
    likeCount: number(value, 'likeNum', 'likeCount', 'likes', 'upCount', 'praiseCount'),
    name: text(value, 'nickname', 'nick', 'name'),
    text: text(value, 'textContent', 'content', 'text', 'body', 'desc', 'description'),
  }
}

function parseHonor(value: RecordValue, type: AnchorProfileHonor['type']): AnchorProfileHonor {
  return {
    iconUrl: text(value, 'medalImageUrl', 'itemIcon', 'icon', 'imgUrl', 'imageUrl', 'url'),
    id: text(value, 'medalId', 'itemId', 'id'),
    name: text(value, 'medalName', 'itemName', 'name', 'title') || 'Honor',
    type,
  }
}

function parseComment(value: RecordValue): AnchorProfileComment {
  return {
    avatarUrl: text(value, 'icon', 'avatar', 'userAvatar'),
    children: objects(value, 'subComments', 'children', 'replies').map(parseComment),
    content: text(value, 'commentContent', 'content', 'text'),
    createdAt: text(value, 'createTime', 'createdAt', 'time'),
    id: text(value, 'id', 'commentId'),
    name: text(value, 'nickname', 'nickName', 'name') || 'User',
    parentId: text(value, 'parentCommentId', 'parentId') || undefined,
    userId: text(value, 'userId', 'uid'),
  }
}

const commentsSchema = z.unknown().transform((value): readonly AnchorProfileComment[] => {
  const root = record(value) ?? {}
  return objects(root, 'rows', 'list', 'records').map(parseComment)
})

const anchorProfileSchema = z.unknown().transform((value, context): AnchorProfile => {
  const root = record(value)
  if (!root) {
    context.addIssue({ code: 'custom', message: 'Invalid anchor profile.' })
    return z.NEVER
  }
  const detail = record(first(root, ['detail', 'profile', 'anchor', 'userDetail', 'user'])) ?? root
  const live = record(first(detail, ['agoraLiveSimpleVO', 'liveRoom', 'live'])) ?? {}
  const counts = record(first(detail, ['firendCountMap', 'friendCountMap'])) ?? {}
  const rawMedia = objects(
    detail,
    'picList',
    'mediaList',
    'albumList',
    'albums',
    'photoList',
    'photos',
    'userAlbumList',
    'anchorAlbumList',
    'pictureList',
    'imageList',
    'imgs',
  ).map((item) => parseMedia(item, 'photo'))
  const media = rawMedia.filter((item) => item.type === 'photo')
  const embeddedVideos = rawMedia.filter((item) => item.type === 'video')
  const videos = embeddedVideos.length
    ? embeddedVideos
    : objects(
        detail,
        'videoList',
        'videos',
        'userVideoList',
        'anchorVideoList',
        'shortVideoList',
        'worksList',
      ).map((item) => parseMedia(item, 'video'))
  const gifts = objects(
    detail,
    'giftWall',
    'giftWallList',
    'receivedGiftList',
    'topGiftList',
    'charmGiftList',
    'giftList',
  )
  const honors = objects(detail, 'medals', 'medalList').map((item) => parseHonor(item, 'badge'))
  const headFrame = text(detail, 'headFrame')
  const cardFrame = text(detail, 'cardFrame')
  if (headFrame)
    honors.push({ iconUrl: headFrame, id: 'head-frame', name: 'Avatar Frame', type: 'frame' })
  if (cardFrame)
    honors.push({ iconUrl: cardFrame, id: 'card-frame', name: 'Profile Frame', type: 'frame' })
  const moments = objects(
    detail,
    'momentList',
    'moments',
    'dynamicList',
    'dynamics',
    'feedList',
    'postList',
    'friendCircleList',
    'circleList',
  )
  const id = text(detail, 'userId', 'id', 'uid')
  if (!id || id === '0') context.addIssue({ code: 'custom', message: 'Anchor id is missing.' })
  const liveRoomId =
    text(detail, 'liveRoomId', 'roomId') || text(live, 'id', 'roomId', 'liveRoomId')
  const partyRoomId = text(detail, 'partyRoomId', 'party_room_id')
  const language = text(detail, 'language', 'languages', 'languageName')
  const groupStatus = number(
    detail,
    'onlineGroupStatus',
    'groupStatus',
    'onlineStatus',
    'online_status',
    'userStatus',
    'status',
  )
  const gender = number(detail, 'gender')
  const isBlocked = number(detail, 'isBlocked')
  const blacklistStatus = number(detail, 'blacklistStatus', 'blackStatus', 'blockStatus')
  const rawLikeRate =
    first(counts, ['likeRate']) !== undefined
      ? signedNumber(counts, 'likeRate')
      : signedNumber(detail, 'likeRate')
  return {
    age: number(detail, 'age'),
    avatarUrl: text(
      detail,
      'icon',
      'avatar',
      'itemSmallImg',
      'item_small_img',
      'headIcon',
      'userAvatar',
    ),
    blocked: isBlocked === 1 || blacklistStatus === 2 || blacklistStatus === 4,
    countryCode: text(detail, 'countryId', 'countryCode', 'country'),
    description: text(detail, 'description', 'desc', 'bio'),
    followed: number(detail, 'followFlag', 'followed', 'isFollow') === 1,
    followersCount:
      number(counts, 'fansNum') ||
      number(detail, 'followeds', 'followers', 'fans', 'fansCount', 'beFollowCount'),
    followingCount:
      number(counts, 'followNum') ||
      number(detail, 'upsNum', 'follows', 'following', 'follow', 'followCount'),
    gender: gender === 1 ? 'male' : gender === 2 ? 'female' : 'unknown',
    gifts: (gifts.length
      ? gifts
      : objects(root, 'giftWall', 'giftWalls', 'receivedGifts', 'receiveGiftList', 'giftList')
    ).map(parseGift),
    honors,
    id,
    imAccount: text(detail, 'yxAccid', 'accid', 'imAccid', 'yunxinAccid'),
    languages: language
      .split(/[,/|]/u)
      .map((item) => item.trim())
      .filter(Boolean),
    levelName: text(detail, 'anchorLevelName', 'levelName', 'userLevel', 'level'),
    likeCount: number(counts, 'likeNum') || number(detail, 'likeNum'),
    likeRate:
      first(counts, ['likeRate']) !== undefined || first(detail, ['likeRate']) !== undefined
        ? rawLikeRate >= 0
          ? rawLikeRate
          : null
        : null,
    liveRoomId: liveRoomId && liveRoomId !== '0' ? liveRoomId : undefined,
    media,
    moments: (moments.length
      ? moments
      : objects(
          root,
          'moments',
          'friendsCircleList',
          'friendCircleList',
          'circleList',
          'records',
          'rows',
        )
    ).map(parseMoment),
    name: text(detail, 'nickname', 'nick', 'userName', 'name') || `User ${id}`,
    signature: text(detail, 'signature', 'intro', 'introduce'),
    status: groupStatus === 3 ? 'offline' : groupStatus === 2 ? 'busy' : 'online',
    videos,
    voiceRoomId: partyRoomId && partyRoomId !== '0' ? partyRoomId : undefined,
    userType: number(detail, 'userType'),
  }
})

class OpiAnchorProfileRepository implements AnchorProfileRepository {
  async blockUser(userId: string, signal?: AbortSignal): Promise<void> {
    await getRelationshipRepository().block({ userId }, signal)
  }

  async getProfile(userId: string, imAccount = '', signal?: AbortSignal): Promise<AnchorProfile> {
    const numericId = Number(userId)
    if (!Number.isSafeInteger(numericId) || numericId <= 0) throw new Error('Invalid anchor id.')
    return getApiClient().request({
      authMode: 'required',
      data: { userId: numericId, ...(imAccount ? { yxAccid: imAccount } : {}) },
      method: 'POST',
      schema: anchorProfileSchema,
      signal,
      url: '/_v2/anchor/detail',
    })
  }

  async getMomentComments(
    momentId: string,
    page: number,
    pageSize: number,
    signal?: AbortSignal,
  ): Promise<readonly AnchorProfileComment[]> {
    const friendsCircleId = Number(momentId)
    if (!Number.isSafeInteger(friendsCircleId) || friendsCircleId <= 0)
      throw new Error('Invalid moment id.')
    return getApiClient().request({
      authMode: 'required',
      data: { currentPage: Math.max(1, page), friendsCircleId, pageSize: Math.min(50, pageSize) },
      method: 'POST',
      schema: commentsSchema,
      signal,
      url: '/_v2/moments/getComments',
    })
  }

  async commentMoment(
    momentId: string,
    content: string,
    parentCommentId?: string,
    signal?: AbortSignal,
  ): Promise<void> {
    const friendsCircleId = Number(momentId)
    const parentId = Number(parentCommentId)
    if (!Number.isSafeInteger(friendsCircleId) || friendsCircleId <= 0)
      throw new Error('Invalid moment id.')
    const commentContent = content.trim()
    if (!commentContent || commentContent.length > 900) throw new Error('Invalid comment.')
    await getApiClient().request({
      authMode: 'required',
      data: {
        commentContent,
        friendsCircleId,
        ...(Number.isSafeInteger(parentId) && parentId > 0 ? { parentCommentId: parentId } : {}),
      },
      method: 'POST',
      schema: z.object({ success: z.boolean().default(false) }),
      signal,
      url: '/_v2/moments/comment',
    })
  }

  async setFollowed(userId: string, followed: boolean, signal?: AbortSignal): Promise<void> {
    await this.updateRelationship(userId, followed ? 1 : 2, signal)
  }

  async setMomentLiked(momentId: string, liked: boolean, signal?: AbortSignal): Promise<void> {
    const id = Number(momentId)
    if (!Number.isSafeInteger(id) || id <= 0) throw new Error('Invalid moment id.')
    await getApiClient().request({
      authMode: 'required',
      data: { id, optionType: liked ? 1 : 0 },
      method: 'POST',
      schema: z.object({ success: z.boolean().default(false) }),
      signal,
      url: '/_v2/moments/like',
    })
  }

  private async updateRelationship(
    userId: string,
    followType: 1 | 2 | 3,
    signal?: AbortSignal,
  ): Promise<void> {
    const followUserId = Number(userId)
    if (!Number.isSafeInteger(followUserId) || followUserId <= 0)
      throw new Error('Invalid anchor id.')
    await getApiClient().request({
      authMode: 'required',
      data: { followType, followUserId },
      method: 'POST',
      schema: z.unknown(),
      signal,
      url: '/_v2/user/followUser',
    })
  }
}

export function getAnchorProfileRepository(): AnchorProfileRepository {
  return resolveProductService<AnchorProfileRepository>('anchor-profile', {
    remote: () => new OpiAnchorProfileRepository(),
  })
}

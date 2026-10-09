import { getApiClient } from '@/core/auth/runtime'
import { z } from 'zod'
import {
  LIVE_PK_STATUS,
  isLivePkScoreVisible,
  type LivePkDetail,
  type LivePkRankEntry,
  type LivePkRankItem,
  type LivePkRepository,
} from './live-pk-contracts'

const text = z
  .union([z.string(), z.number().finite()])
  .nullish()
  .transform((value) => (value === null || value === undefined ? '' : String(value).trim()))
const nullableCount = z
  .union([z.string(), z.number().finite()])
  .nullish()
  .transform((value) => {
    if (value === null || value === undefined || value === '') return null
    const parsed = Number(value)
    return Number.isFinite(parsed) ? Math.max(0, Math.trunc(parsed)) : null
  })
const count = nullableCount.transform((value) => value ?? 0)
const flag = z
  .union([z.boolean(), z.literal(0), z.literal(1), z.literal('0'), z.literal('1')])
  .nullish()
  .transform((value) => value === true || value === 1 || value === '1')

function isPositiveSafeInteger(value: string): boolean {
  const parsed = Number(value)
  return Number.isSafeInteger(parsed) && parsed > 0
}
const rankItemSchema = z.object({
  anchorId: text,
  avatar: text,
  contribution: nullableCount,
  countryId: text,
  icon: text.optional(),
  isVip: flag,
  levelName: text,
  nickName: text,
  nickname: text.optional(),
})

export const livePkDetailResponseSchema = z
  .object({
    leftAgoraChannelId: text,
    leftAvatar: text,
    leftName: text,
    leftScore: nullableCount,
    leftTop3: z
      .array(rankItemSchema)
      .nullish()
      .transform((value) => value ?? []),
    leftUserId: text,
    pkDuration: nullableCount,
    pkId: text,
    pkPunishingDuration: nullableCount,
    pkStatus: count,
    remainSeconds: nullableCount,
    rightAgoraChannelId: text,
    rightAvatar: text,
    rightName: text,
    rightRoomId: text,
    rightScore: nullableCount,
    rightTop3: z
      .array(rankItemSchema)
      .nullish()
      .transform((value) => value ?? []),
    rightUserId: text,
  })
  .superRefine((value, context) => {
    if (!isLivePkScoreVisible(value.pkStatus)) return
    const requiredTextFields = [
      ['pkId', value.pkId],
      ['leftUserId', value.leftUserId],
      ['rightUserId', value.rightUserId],
    ] as const
    for (const [field, fieldValue] of requiredTextFields) {
      if (fieldValue && (field === 'pkId' || isPositiveSafeInteger(fieldValue))) continue
      context.addIssue({
        code: z.ZodIssueCode.custom,
        message: `Active PK detail is missing a valid ${field}.`,
        path: [field],
      })
    }
    for (const [field, fieldValue] of [
      ['leftScore', value.leftScore],
      ['rightScore', value.rightScore],
    ] as const) {
      if (fieldValue !== null) continue
      context.addIssue({
        code: z.ZodIssueCode.custom,
        message: `Active PK detail is missing ${field}.`,
        path: [field],
      })
    }
  })
  .transform((value): LivePkDetail => {
    const mapRank = (item: z.infer<typeof rankItemSchema>): LivePkRankItem => ({
      avatarUrl: item.avatar || item.icon || '',
      countryCode: item.countryId,
      contribution: item.contribution ?? 0,
      id: item.anchorId,
      levelName: item.levelName,
      nickname: item.nickName || item.nickname || '',
      vip: item.isVip,
    })
    const duration =
      value.pkStatus === LIVE_PK_STATUS.punishing ? value.pkPunishingDuration : value.pkDuration
    return {
      leftAgoraChannelId: value.leftAgoraChannelId,
      leftAvatarUrl: value.leftAvatar,
      leftName: value.leftName,
      leftScore: value.leftScore,
      leftTop3: value.leftTop3.map(mapRank),
      leftUserId: value.leftUserId,
      pkId: value.pkId,
      remainSeconds: Math.max(
        0,
        value.remainSeconds ?? (duration === null ? 0 : Math.trunc(duration / 1000)),
      ),
      rightAgoraChannelId: value.rightAgoraChannelId,
      rightAvatarUrl: value.rightAvatar,
      rightName: value.rightName,
      rightRoomId: value.rightRoomId,
      rightScore: value.rightScore,
      rightTop3: value.rightTop3.map(mapRank),
      rightUserId: value.rightUserId,
      status: value.pkStatus,
    }
  })

const rankEntrySchema = z.object({
  contribution: nullableCount,
  countryId: text,
  icon: text,
  nickname: text,
  rank: count,
  userId: text,
  userLevelName: text,
  vipFlag: flag,
})

export const livePkRankResponseSchema = z
  .object({
    rows: z
      .array(rankEntrySchema)
      .nullish()
      .transform((value) => value ?? []),
    total: count,
  })
  .transform((value): readonly LivePkRankEntry[] =>
    value.rows
      .map((item) => ({
        avatarUrl: item.icon,
        countryCode: item.countryId,
        contribution: item.contribution ?? 0,
        id: item.userId,
        levelName: item.userLevelName,
        nickname: item.nickname,
        rank: item.rank,
        vip: item.vipFlag,
      }))
      .sort((left, right) => left.rank - right.rank)
      .slice(0, Math.min(30, value.total || 30)),
  )

const rtcCredentialSchema = z.object({
  rtcToken: text,
  uid: z.coerce.number().int().positive().max(4_294_967_295),
})

class OpiLivePkRepository implements LivePkRepository {
  private readonly api = getApiClient()

  getDetail(roomIdValue: string, pkId?: string, signal?: AbortSignal): Promise<LivePkDetail> {
    const roomId = Number(roomIdValue)
    if (!Number.isSafeInteger(roomId) || roomId <= 0) throw new Error('Invalid live room ID.')
    return this.api.request({
      authMode: 'required',
      data: { pkId: pkId?.trim() || undefined, roomId },
      method: 'POST',
      schema: livePkDetailResponseSchema,
      signal,
      timeout: 8_000,
      url: '/_v2/discover/live/pk/detail',
    })
  }

  getRank(
    pkIdValue: string,
    anchorIdValue: string,
    signal?: AbortSignal,
  ): Promise<readonly LivePkRankEntry[]> {
    const pkId = pkIdValue.trim()
    const anchorId = Number(anchorIdValue)
    if (!pkId) throw new Error('Invalid PK ID.')
    if (!Number.isSafeInteger(anchorId) || anchorId <= 0) throw new Error('Invalid anchor ID.')
    return this.api.request({
      authMode: 'required',
      data: { anchorId, pkId },
      method: 'POST',
      schema: livePkRankResponseSchema,
      signal,
      timeout: 8_000,
      url: '/_v2/discover/live/pk/rank',
    })
  }

  getRtcCredential(signal?: AbortSignal) {
    return this.api.request({
      authMode: 'required',
      data: {},
      method: 'POST',
      schema: rtcCredentialSchema,
      signal,
      timeout: 8_000,
      url: '/_v2/discover/rtc/user-token',
    })
  }
}

let repository: LivePkRepository | null = null

export function getLivePkRepository(): LivePkRepository {
  repository ??= new OpiLivePkRepository()
  return repository
}

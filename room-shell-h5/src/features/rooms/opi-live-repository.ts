import { ApiClientError, type ApiClient, type ApiRequest } from '@/core/api/client'
import { getApiClient } from '@/core/auth/runtime'
import { z } from 'zod'
import type { LiveRepository, RoomLaunchContext, RoomSummary } from './contracts'
import { LiveRoomUnavailableError } from './live-errors'

const identifier = z
  .union([z.string().trim().min(1), z.number().finite()])
  .transform((value) => String(value))
const text = z
  .string()
  .nullish()
  .transform((value) => value?.trim() ?? '')
const integer = z
  .union([z.number().finite(), z.string().trim()])
  .nullish()
  .transform((value) => {
    const parsed = Number(value ?? 0)
    return Number.isFinite(parsed) ? Math.trunc(parsed) : 0
  })
const optionalIdentifier = z
  .union([z.string(), z.number().finite()])
  .nullish()
  .transform((value) => (value === null || value === undefined ? '' : String(value).trim()))
const optionalFlag = z
  .union([z.boolean(), z.number().finite(), z.string().trim()])
  .nullish()
  .transform((value) => {
    if (value === null || value === undefined || value === '') return undefined
    if (typeof value === 'boolean') return value ? 1 : 0
    const parsed = Number(value)
    return Number.isFinite(parsed) ? Math.trunc(parsed) : undefined
  })
const liveRoomSchema = z
  .object({
    agoraChannelId: text,
    announcement: text,
    anchorLevelName: text,
    countryId: text,
    followFlag: optionalFlag,
    icon: text,
    id: identifier,
    joinNum: integer,
    liveDescribe: text,
    nickname: z.string().trim().min(1),
    pkId: optionalIdentifier,
    pkStatus: integer,
    userId: identifier,
    videoUrl: text,
    wheelEnabled: optionalFlag,
    yxAccid: text,
  })
  .passthrough()
  .nullable()
const roomStatusSchema = z.object({ alive: z.boolean() })

function positiveRoomId(value: string): number {
  const id = Number(value)
  if (!Number.isSafeInteger(id) || id <= 0) throw new Error('Invalid live room ID.')
  return id
}

export class OpiLiveRepository implements LiveRepository {
  constructor(private readonly api: Pick<ApiClient, 'request'> = getApiClient()) {}

  async isRoomAlive(channelId: string, signal?: AbortSignal): Promise<boolean | null> {
    if (!channelId.trim()) return false
    try {
      return (
        await this.api.request({
          authMode: 'required',
          data: { channelId: channelId.trim() },
          method: 'POST',
          schema: roomStatusSchema,
          signal,
          url: '/_v2/live/room-status',
        })
      ).alive
    } catch (cause) {
      if (cause instanceof ApiClientError && ['aborted', 'unauthorized'].includes(cause.kind))
        throw cause
      return null
    }
  }

  async createLaunchContext(
    room: RoomSummary,
    _audienceUserId: string,
    role: RoomLaunchContext['role'],
    signal?: AbortSignal,
  ): Promise<RoomLaunchContext> {
    if (room.mode !== 'live' || role !== 'audience')
      throw new Error('This bundle only supports the live audience role.')
    const detailTask = this.api.request({
      authMode: 'required',
      data: { roomId: positiveRoomId(room.id) },
      method: 'POST',
      schema: liveRoomSchema,
      signal,
      url: '/_v2/discover/live/room/get',
    } satisfies ApiRequest<z.infer<typeof liveRoomSchema>>)
    const statusTask = detailTask.then((detail) =>
      detail?.agoraChannelId ? this.isRoomAlive(detail.agoraChannelId, signal) : null,
    )
    const [detailResult, statusResult] = await Promise.allSettled([detailTask, statusTask])
    if (statusResult.status === 'fulfilled' && statusResult.value === false)
      throw new LiveRoomUnavailableError('ended')
    if (detailResult.status === 'rejected') throw detailResult.reason
    if (statusResult.status === 'rejected') throw statusResult.reason
    const detail = detailResult.value
    if (!detail) throw new LiveRoomUnavailableError('ended')
    if (detail.id !== room.id || (room.host.id && detail.userId !== room.host.id))
      throw new LiveRoomUnavailableError('invalid-room')
    return {
      ...(detail.announcement ? { announcement: detail.announcement } : {}),
      appId: '',
      channelName: detail.agoraChannelId || `live-${detail.id}`,
      coverUrl: room.coverUrl || detail.icon,
      ...(detail.countryId ? { countryCode: detail.countryId } : {}),
      ...(detail.liveDescribe ? { description: detail.liveDescribe } : {}),
      displayName: detail.nickname,
      followed: detail.followFlag === 1,
      hostAvatarUrl: detail.icon,
      hostId: detail.userId,
      hostImAccount: detail.yxAccid || undefined,
      hostLevelName: detail.anchorLevelName,
      hostUserType: 2,
      mode: 'live',
      onlineCount: Math.max(0, detail.joinNum),
      ...(detail.videoUrl ? { playbackUrl: detail.videoUrl } : {}),
      ...(detail.pkId ? { pkId: detail.pkId } : {}),
      pkStatus: detail.pkStatus,
      role: 'audience',
      roomId: detail.id,
      rtcToken: '',
      uid: 0,
      ...(detail.wheelEnabled !== undefined ? { wheelEnabled: detail.wheelEnabled === 1 } : {}),
    }
  }
}

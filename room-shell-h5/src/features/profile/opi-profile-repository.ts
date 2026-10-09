import { z } from 'zod'
import { getApiClient } from '@/core/auth/runtime'
import { asRecord, bool, integer, text } from '@/features/messages/value-readers'
import type { ProfileRepository, UserProfile } from './contracts'

const unknownValue = z.unknown()

function mapProfile(value: unknown): UserProfile {
  const source = asRecord(value) ?? {}
  const level = Math.max(0, integer(source, 'realUserLevel'))
  return {
    avatarUrl: text(source, 'icon'),
    birthday: text(source, 'birthday'),
    countryId: text(source, 'countryId'),
    diamondCount: Math.max(0, integer(source, 'diamondNum')),
    displayName: text(source, 'nickname', 'nickName') || 'Guest',
    fansCount: Math.max(0, integer(source, 'fansNum')),
    followingCount: Math.max(0, integer(source, 'upsNum')),
    friendCount: Math.max(0, integer(source, 'friendNum')),
    gender: [1, 2].includes(integer(source, 'gender')) ? (integer(source, 'gender') as 1 | 2) : 0,
    headFrameUrl: '',
    id: text(source, 'userId', 'id'),
    imAccount: text(source, 'yxAccid'),
    level,
    levelIcon: text(source, 'levelIcon'),
    levelName: text(source, 'userLevel') || `Lv.${level}`,
    signature: text(source, 'signature'),
    vip: bool(source, 'vip'),
    vipExpireAt: Math.max(0, integer(source, 'vipExpireMs')),
  }
}

export class OpiProfileRepository implements ProfileRepository {
  async getProfile(signal?: AbortSignal): Promise<UserProfile> {
    return mapProfile(
      await getApiClient().request({
        authMode: 'required',
        data: {},
        method: 'POST',
        schema: unknownValue,
        signal,
        url: '/_v2/user/info',
      }),
    )
  }
}

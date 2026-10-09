import { describe, expect, it } from 'vitest'
import type { UserProfile } from '@/features/profile/contracts'
import { mergeProfileIdentity } from './session'

function profile(id = ''): UserProfile {
  return {
    avatarUrl: 'https://cdn.example/avatar.png',
    birthday: '',
    countryId: '',
    diamondCount: 12,
    displayName: 'Tester',
    fansCount: 0,
    followingCount: 0,
    friendCount: 0,
    gender: 0,
    headFrameUrl: '',
    id,
    imAccount: '',
    level: 1,
    levelIcon: '',
    levelName: 'Lv.1',
    signature: '',
    vip: false,
    vipExpireAt: 0,
  }
}

describe('room session profile identity', () => {
  it('uses the native account ID when the profile response omits userId', () => {
    expect(mergeProfileIdentity(profile(), '456').id).toBe('456')
  })

  it('accepts a matching profile identity', () => {
    expect(mergeProfileIdentity(profile('456'), '456').id).toBe('456')
  })

  it('rejects a profile belonging to another account', () => {
    expect(() => mergeProfileIdentity(profile('789'), '456')).toThrow(
      'The profile response belongs to another account.',
    )
  })
})

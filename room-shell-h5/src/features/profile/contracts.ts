export interface UserProfile {
  avatarUrl: string
  birthday: string
  countryId: string
  diamondCount: number
  displayName: string
  fansCount: number
  followingCount: number
  friendCount: number
  gender: 0 | 1 | 2
  headFrameUrl: string
  id: string
  imAccount: string
  level: number
  levelIcon: string
  levelName: string
  signature: string
  vip: boolean
  vipExpireAt: number
}

export interface ProfileRepository {
  getProfile: (signal?: AbortSignal) => Promise<UserProfile>
}

export type AppUserType = 0 | 1 | 2 | 3 | 4

export interface RelationshipTarget {
  imAccount?: string
  userId: string
  userType?: number
}

export interface UserRelationship {
  blocked: boolean
  blockedKnown: boolean
  followed: boolean
  followedKnown: boolean
  userType: number
}

export interface UserRelationshipSeed extends RelationshipTarget {
  blocked?: boolean
  followed?: boolean
}

export interface RelationshipRepository {
  block: (target: RelationshipTarget, signal?: AbortSignal) => Promise<void>
  getBlockedUserIds: (signal?: AbortSignal) => Promise<readonly string[]>
  setFollowed: (
    target: RelationshipTarget,
    followed: boolean,
    signal?: AbortSignal,
  ) => Promise<void>
  unblock: (target: RelationshipTarget, signal?: AbortSignal) => Promise<void>
}

export function isAnchorUserType(userType: number | null | undefined): boolean {
  return userType === 2 || userType === 3
}

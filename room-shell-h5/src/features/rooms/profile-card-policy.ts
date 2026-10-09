import { isAnchorUserType } from '@/features/relationships/contracts'

export type ProfileCardRole = 'anchor' | 'unknown' | 'user'
export type ProfileCardScene = 'blocklist' | 'live' | 'party' | 'ranking' | 'relation'

export interface ProfileCardPolicyInput {
  blocked: boolean
  followAvailable: boolean
  hasImAccount: boolean
  messageAvailable: boolean
  scene: ProfileCardScene
  self: boolean
  userType: number | null | undefined
}

export interface ProfileCardPolicy {
  canOpenDetail: boolean
  role: ProfileCardRole
  showFollow: boolean
  showGiftWall: boolean
  showLevel: boolean
  showMessage: boolean
}

export function profileCardRole(userType: number | null | undefined): ProfileCardRole {
  if (isAnchorUserType(userType)) return 'anchor'
  return Number.isInteger(userType) && Number(userType) > 0 ? 'user' : 'unknown'
}

export function resolveProfileCardPolicy(input: ProfileCardPolicyInput): ProfileCardPolicy {
  const role = profileCardRole(input.userType)
  const anchorActionsAllowed =
    role === 'anchor' && !input.self && !input.blocked && input.scene !== 'blocklist'
  const messageAllowed = !input.self && !input.blocked && input.scene !== 'blocklist'

  return {
    canOpenDetail: role === 'anchor',
    role,
    showFollow: anchorActionsAllowed && input.followAvailable,
    showGiftWall: ['live', 'ranking', 'relation'].includes(input.scene),
    showLevel: role === 'user',
    showMessage: messageAllowed && input.hasImAccount && input.messageAvailable,
  }
}

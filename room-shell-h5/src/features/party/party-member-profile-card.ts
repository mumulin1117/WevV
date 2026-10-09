import type {
  UserProfileCard,
  UserProfileCardTarget,
} from '@/features/rooms/live-interaction-contracts'
import type { PartyMember } from './contracts'

export function partyMemberProfileTarget(member: PartyMember): UserProfileCardTarget {
  return {
    avatarUrl: member.avatarUrl,
    id: member.id,
    imAccount: member.imAccount,
    name: member.displayName,
    userType: member.userType,
  }
}

export function partyMemberProfileCard(member: PartyMember): UserProfileCard {
  return {
    age: member.age,
    avatarUrl: member.avatarUrl,
    blocked: false,
    cardFrameUrl: member.cardFrameUrl ?? '',
    countryCode: member.countryName,
    fansCount: member.followerCount,
    followed: member.followed,
    followingCount: member.followingCount,
    gender: member.gender === 2 ? 'female' : member.gender === 1 ? 'male' : 'unknown',
    headFrameUrl: member.headFrameUrl || member.headFrameSmallUrl,
    id: member.id,
    imAccount: member.imAccount,
    levelName: member.levelName?.trim() || (member.level > 0 ? String(member.level) : ''),
    medals: member.medals.map((iconUrl, index) => ({
      fontColor: '',
      iconUrl,
      id: `party-medal:${index}:${iconUrl}`,
      name: '',
      weight: index,
    })),
    name: member.displayName,
    receivedGifts: [],
    sentGifts: [],
    signature: '',
    userType: member.userType ?? 0,
    vip: member.vip,
  }
}

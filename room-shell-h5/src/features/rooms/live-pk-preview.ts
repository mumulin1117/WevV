import type { RoomAudience, RoomLaunchContext } from './contracts'
import {
  LIVE_PK_STATUS,
  type LivePkDetail,
  type LivePkRankEntry,
  type LivePkRankItem,
} from './live-pk-contracts'

export interface LivePkPreviewPerson {
  avatarUrl: string
  countryCode?: string
  id: string
  levelName?: string
  name: string
  vip?: boolean
}

export interface LivePkPreviewFixture {
  detail: LivePkDetail
  ranks: Record<'left' | 'right', readonly LivePkRankEntry[]>
}

const PREVIEW_NAMES = [
  'Glow Muse',
  'Rose Beauty',
  'Velvet Bloom',
  'Peach Studio',
  'Luna Makeup',
  'Crystal Skin',
  'Blush Diary',
  'Beauty Insider',
] as const
const PREVIEW_CONTRIBUTIONS = [18_860, 13_420, 9_680, 6_350, 3_220, 1_880, 960, 420] as const

function audiencePerson(audience: RoomAudience): LivePkPreviewPerson {
  return {
    avatarUrl: audience.avatarUrl,
    id: audience.id,
    name: audience.displayName,
    vip: audience.vip,
  }
}

function previewPeople(
  context: RoomLaunchContext,
  currentUser: LivePkPreviewPerson | null,
): readonly LivePkPreviewPerson[] {
  const people = (context.audience ?? [])
    .filter((audience) => audience.id && audience.id !== currentUser?.id)
    .map(audiencePerson)
  for (let index = people.length; index < 5; index += 1) {
    people.push({
      avatarUrl: '',
      id: `pk-preview-fan-${index + 1}`,
      name: PREVIEW_NAMES[index],
      vip: index === 1,
    })
  }
  if (currentUser?.id) people.push(currentUser)
  for (let index = people.length; index < PREVIEW_NAMES.length; index += 1) {
    people.push({
      avatarUrl: '',
      id: `pk-preview-fan-${index + 1}`,
      name: PREVIEW_NAMES[index],
      vip: index === 6,
    })
  }
  return people.slice(0, PREVIEW_NAMES.length)
}

function rankRows(
  people: readonly LivePkPreviewPerson[],
  countryCode: string,
  reverse = false,
): readonly LivePkRankEntry[] {
  const ordered = reverse ? [...people].reverse() : [...people]
  return ordered.map((person, index) => ({
    avatarUrl: person.avatarUrl,
    contribution: PREVIEW_CONTRIBUTIONS[index] ?? 0,
    countryCode: person.countryCode || countryCode,
    id: person.id,
    levelName: person.levelName || `Lv.${Math.max(1, 36 - index * 4)}`,
    nickname: person.name,
    rank: index + 1,
    vip: Boolean(person.vip),
  }))
}

function topThree(rows: readonly LivePkRankEntry[]): readonly LivePkRankItem[] {
  return rows.slice(0, 3).map(({ rank: _rank, ...row }) => row)
}

/**
 * 仅供显式联调入口预览 PK UI。返回值不得写入 PK Session、Repository 或真实送礼参数。
 */
export function createLivePkPreviewFixture(
  context: RoomLaunchContext,
  opponent: LivePkPreviewPerson,
  currentUser: LivePkPreviewPerson | null,
): LivePkPreviewFixture {
  const people = previewPeople(context, currentUser)
  const countryCode = context.countryCode?.toUpperCase() || 'IN'
  const leftRanks = rankRows(people, countryCode)
  const rightRanks = rankRows(people, countryCode, true)
  return {
    detail: {
      leftAgoraChannelId: context.channelName,
      leftAvatarUrl: context.hostAvatarUrl ?? '',
      leftName: context.displayName,
      leftScore: 1_280,
      leftTop3: topThree(leftRanks),
      leftUserId: context.hostId ?? `pk-preview-host:${context.roomId}`,
      pkId: `pk-preview:${context.roomId}`,
      remainSeconds: 12,
      rightAgoraChannelId: '',
      rightAvatarUrl: opponent.avatarUrl,
      rightName: opponent.name,
      rightRoomId: '',
      rightScore: 1_160,
      rightTop3: topThree(rightRanks),
      rightUserId: opponent.id,
      status: LIVE_PK_STATUS.inPk,
    },
    ranks: { left: leftRanks, right: rightRanks },
  }
}

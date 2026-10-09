/** 对齐 Android PkStatus；只有 7/8 展示 PK 双画面和比分。 */
export const LIVE_PK_STATUS = {
  end: 9,
  inPk: 7,
  invited: 6,
  inviting: 5,
  live: 2,
  matching: 3,
  matchingRetry: 4,
  none: 0,
  offline: 1,
  punishing: 8,
  toJoin: 10,
} as const

export interface LivePkRankItem {
  avatarUrl: string
  countryCode: string
  contribution: number
  id: string
  levelName: string
  nickname: string
  vip: boolean
}

export interface LivePkRankEntry extends LivePkRankItem {
  rank: number
}

export interface LivePkDetail {
  leftAgoraChannelId: string
  leftAvatarUrl: string
  leftName: string
  leftScore: number | null
  leftTop3: readonly LivePkRankItem[]
  leftUserId: string
  pkId: string
  remainSeconds: number
  rightAgoraChannelId: string
  rightAvatarUrl: string
  rightName: string
  rightRoomId: string
  rightScore: number | null
  rightTop3: readonly LivePkRankItem[]
  rightUserId: string
  status: number
}

export type LivePkPush = Partial<Omit<LivePkDetail, 'leftTop3' | 'rightTop3'>> & {
  leftTop3?: readonly LivePkRankItem[]
  rightTop3?: readonly LivePkRankItem[]
  status: number
}

export interface LivePkRtcCredential {
  rtcToken: string
  uid: number
}

export interface LivePkRepository {
  getDetail: (roomId: string, pkId?: string, signal?: AbortSignal) => Promise<LivePkDetail>
  getRank: (
    pkId: string,
    anchorId: string,
    signal?: AbortSignal,
  ) => Promise<readonly LivePkRankEntry[]>
  getRtcCredential: (signal?: AbortSignal) => Promise<LivePkRtcCredential>
}

export function isLivePkScoreVisible(status: number): boolean {
  return status === LIVE_PK_STATUS.inPk || status === LIVE_PK_STATUS.punishing
}

export function shouldRefreshLivePk(status: number): boolean {
  return (
    status === LIVE_PK_STATUS.matching ||
    status === LIVE_PK_STATUS.matchingRetry ||
    status === LIVE_PK_STATUS.inviting ||
    status === LIVE_PK_STATUS.invited ||
    status === LIVE_PK_STATUS.inPk ||
    status === LIVE_PK_STATUS.punishing ||
    status === LIVE_PK_STATUS.toJoin
  )
}

export type GameBridgeType = 'default' | 'lingxian' | 'vvvapis' | 'yomi'

export interface GameItem {
  appIds: string
  category: string
  gameId: string
  gameLink: string
  gameType: string
  id: string
  imageUrl: string
  isClick: boolean
  isNew: boolean
  isRecommend: boolean
  isShowBack: boolean
  loadingIconUrl: string
  name: string
  onlineCount: number
}

export interface GameNotice {
  avatarUrl: string
  diamondCount: number
  gameName: string
  nickname: string
}

export interface GameCatalog {
  games: readonly GameItem[]
  noticeIntervalMs: number
  notices: readonly GameNotice[]
}

export interface GameLaunchIdentity {
  imToken: string
  userId: string
}

export interface GameLaunchRequest {
  game: GameItem
  identity: GameLaunchIdentity
  roomId?: string
  scene: 'game_tab' | 'live_room'
  size: 'full' | 'half'
}

export interface GameLaunchSpec {
  accountId: string
  allowedOrigin: string
  bridgeType: GameBridgeType
  gameId: string
  isShowBack: boolean
  loadingIconUrl: string
  url: string
}

export type GameHostEvent =
  { type: 'close' } | { type: 'ready' } | { type: 'recharge' } | { raw: unknown; type: 'unknown' }

export type LiveRpsMove = 'PAPER' | 'ROCK' | 'SCISSORS'
export type LiveRpsRoundResult = 'ANCHOR_WIN' | 'DRAW' | 'USER_WIN'
export type LiveRpsFinalResult =
  'ANCHOR_WIN' | 'FINISHED_ANCHOR_WIN' | 'FINISHED_USER_WIN' | 'USER_WIN'

export interface LiveRpsConfig {
  floatingBubbles: number
  grantedHours: number
  price: number
  secondsToDayEnd: number
  todayPlayCount: number
}

export interface LiveRpsOrder {
  orderId: string
}

export interface LiveRpsOrderRequest {
  anchorId: string
  roomId: string
}

export interface LiveRpsPlayRequest {
  move: LiveRpsMove
  orderId: string
  smallRoundNo: number
}

export interface LiveRpsPlayResult {
  anchorMove: LiveRpsMove
  finalResult: LiveRpsFinalResult | null
  orderFinished: boolean
  playResult: LiveRpsRoundResult
  smallRoundNo: number
  userMove: LiveRpsMove
}

export interface LiveWheelSector {
  id: string
  presetId: string
  text: string
  wheelId: string
}

export interface LiveWheelConfig {
  anchorId: string
  enabled: boolean
  id: string
  originalPrice: number
  price: number
  sectors: readonly LiveWheelSector[]
}

export interface LiveWheelRotateResult {
  anchorId: string
  balance: number
  incomeDiamondNum: number
  sector: LiveWheelSector
}

export interface GameRepository {
  buildLaunch: (request: GameLaunchRequest, signal?: AbortSignal) => Promise<GameLaunchSpec>
  createLiveRpsOrder: (request: LiveRpsOrderRequest, signal?: AbortSignal) => Promise<LiveRpsOrder>
  exitLiveRps: (orderId: string, signal?: AbortSignal) => Promise<boolean>
  getFullCatalog: (signal?: AbortSignal) => Promise<GameCatalog>
  getHalfCatalog: (signal?: AbortSignal) => Promise<GameCatalog>
  getLiveRpsConfig: (signal?: AbortSignal) => Promise<LiveRpsConfig | null>
  getLiveWheelConfig: (anchorId: string, signal?: AbortSignal) => Promise<LiveWheelConfig | null>
  playLiveRps: (request: LiveRpsPlayRequest, signal?: AbortSignal) => Promise<LiveRpsPlayResult>
  rotateLiveWheel: (anchorId: string, signal?: AbortSignal) => Promise<LiveWheelRotateResult>
}

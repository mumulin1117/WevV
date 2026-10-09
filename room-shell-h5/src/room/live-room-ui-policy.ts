import type { RoomLaunchContext } from '@/features/rooms/contracts'
import type { LiveRankItem } from '@/features/rooms/live-interaction-contracts'
import type { RoomEngineState } from './runtime/rtc-room-engine'

interface LiveRoomUiInput {
  liveUiReady: boolean
  mode: RoomLaunchContext['mode']
  role: RoomLaunchContext['role']
}

interface LiveRoomMinimizeInput extends LiveRoomUiInput {
  rtcState: RoomEngineState
  terminal: boolean
}

interface ChatScrollMetrics {
  clientHeight: number
  scrollHeight: number
  scrollTop: number
}

interface InitialChatScrollInput {
  chatConnected: boolean
  chatSurfaceAvailable: boolean
  completed: boolean
  liveUiReady: boolean
}

export const CHAT_BOTTOM_THRESHOLD_PX = 36

export type LiveTopGiver = NonNullable<RoomLaunchContext['topGiver']>

function normalizeUserId(value: string): string {
  const normalized = value.trim()
  return normalized === '0' ? '' : normalized
}

export function isValidLiveTopGiver(value: RoomLaunchContext['topGiver']): value is LiveTopGiver {
  return Boolean(
    value &&
    (normalizeUserId(value.id) || value.avatarUrl.trim()) &&
    Number.isFinite(value.cost) &&
    value.cost > 0,
  )
}

export function selectLiveTopGiver(ranks: readonly LiveRankItem[]): LiveTopGiver | undefined {
  const first = ranks.find(
    (item) =>
      item.rank === 1 &&
      (normalizeUserId(item.id) || item.avatarUrl.trim()) &&
      Number.isFinite(item.cost) &&
      item.cost > 0,
  )
  if (!first) return undefined
  return { avatarUrl: first.avatarUrl, cost: first.cost, id: normalizeUserId(first.id) }
}

export function shouldObscureLiveCover(input: LiveRoomUiInput): boolean {
  return input.mode === 'live' && input.role === 'audience' && !input.liveUiReady
}

export function canMinimizeRoom(input: LiveRoomMinimizeInput): boolean {
  if (input.mode !== 'live' || input.role !== 'audience') return true
  return input.liveUiReady && !input.terminal && input.rtcState !== 'failed'
}

export function shouldStartInitialChatScroll(input: InitialChatScrollInput): boolean {
  return input.chatSurfaceAvailable && input.liveUiReady && input.chatConnected && !input.completed
}

export function isChatNearBottom(
  metrics: ChatScrollMetrics,
  threshold = CHAT_BOTTOM_THRESHOLD_PX,
): boolean {
  return metrics.scrollHeight - metrics.scrollTop - metrics.clientHeight <= threshold
}

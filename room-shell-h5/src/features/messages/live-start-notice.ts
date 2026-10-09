import type { NotificationPresentation } from './presentation'

export const LIVE_START_NOTICE_DURATION_MS = 5_000
export const LIVE_START_NOTICE_QUEUE_GAP_MS = 220

const BLOCKED_ROUTE_NAMES = new Set([
  'conversation',
  'customer-service',
  'customer-service-chat',
  'external-web',
  'game-web',
  'message-likes',
  'message-recharge',
  'party',
  'party-create',
  'party-ranking',
  'party-search',
  'profile-diamonds',
  'profile-vip',
])

export function localCalendarDay(timestamp = Date.now()): string {
  const date = new Date(timestamp)
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(
    date.getDate(),
  ).padStart(2, '0')}`
}

export function liveStartNoticeIdentity(presentation: NotificationPresentation): string | null {
  if (presentation.kind !== 'live') return null
  if (presentation.targetUserId) return `host:${presentation.targetUserId}`
  if (presentation.targetRoomId) return `room:${presentation.targetRoomId}`
  return presentation.targetImAccount ? `im:${presentation.targetImAccount}` : null
}

export function canShowLiveStartNotice(context: {
  activeRoomMode?: 'live' | 'voice'
  appPhase: 'active' | 'background' | 'inactive'
  gameSurfaceVisible: boolean
  mutedDay: string | null
  paymentSurfaceVisible: boolean
  routeName: string
}): boolean {
  return (
    context.appPhase === 'active' &&
    !context.gameSurfaceVisible &&
    !context.paymentSurfaceVisible &&
    context.activeRoomMode !== 'voice' &&
    !BLOCKED_ROUTE_NAMES.has(context.routeName) &&
    context.mutedDay !== localCalendarDay()
  )
}

export function liveNoticeProgress(remainingMs: number): number {
  return Math.max(0, Math.min(1, remainingMs / LIVE_START_NOTICE_DURATION_MS))
}

export function liveNoticeSeconds(remainingMs: number): number {
  return Math.max(0, Math.ceil(remainingMs / 1_000))
}

import type { AppLifecyclePhase } from '@/core/runtime/app-activity'
import type { InboxMessage, MessageKind } from './contracts'

export type IncomingNoticeSource = '' | 'platform' | 'recharge'

export interface IncomingNoticeContext {
  activeConversationId: string
  activeRoomMode?: 'live' | 'voice'
  appPhase: AppLifecyclePhase
  doNotDisturb: boolean
  gameSurfaceVisible: boolean
  message: InboxMessage
  muted: boolean
  paymentSurfaceVisible: boolean
  routeConversationId: string
  routeName: string
  senderIsAnchor: boolean
  specialSource: IncomingNoticeSource
}

export interface IncomingNoticeDecision {
  playSound: boolean
  show: boolean
}

const MESSAGE_ROUTE_NAMES = new Set([
  'conversation',
  'customer-service',
  'customer-service-chat',
  'message-likes',
  'message-recharge',
  'message-system',
  'messages',
])

const PAYMENT_AND_EXTERNAL_ROUTE_NAMES = new Set([
  'external-web',
  'game-web',
  'profile-diamonds',
  'profile-vip',
])

const REGULAR_MESSAGE_KINDS = new Set<MessageKind>([
  'audio',
  'gift',
  'image',
  'private-media',
  'text',
])

const HIDDEN_DECISION: IncomingNoticeDecision = Object.freeze({
  playSound: false,
  show: false,
})

/**
 * 普通前台来信只支持用户消息和已确认的平台/充值账号。其他 NIM system/custom
 * 消息仍可进入会话历史，但不能在缺少业务契约时伪造成顶部提醒。
 */
export function isSupportedIncomingNotice(
  message: InboxMessage,
  specialSource: IncomingNoticeSource,
): boolean {
  return REGULAR_MESSAGE_KINDS.has(message.kind) || Boolean(specialSource)
}

/**
 * 顶部提醒只是消息入库后的表现决策，不参与未读、历史或支付到账处理。
 * Live 房只展示主播来信且静音；Party 房同样只展示主播来信，但保持旧站铃声。
 */
export function incomingNoticeDecision(context: IncomingNoticeContext): IncomingNoticeDecision {
  if (
    context.message.own ||
    context.appPhase !== 'active' ||
    context.muted ||
    context.doNotDisturb ||
    context.gameSurfaceVisible ||
    context.paymentSurfaceVisible ||
    !isSupportedIncomingNotice(context.message, context.specialSource)
  )
    return HIDDEN_DECISION

  if (
    context.activeConversationId === context.message.conversationId ||
    (context.routeName === 'conversation' &&
      context.routeConversationId === context.message.conversationId)
  )
    return HIDDEN_DECISION

  if (context.activeRoomMode) {
    if (!context.senderIsAnchor) return HIDDEN_DECISION
    return {
      playSound: context.activeRoomMode === 'voice',
      show: true,
    }
  }

  if (
    MESSAGE_ROUTE_NAMES.has(context.routeName) ||
    PAYMENT_AND_EXTERNAL_ROUTE_NAMES.has(context.routeName)
  )
    return HIDDEN_DECISION

  return { playSound: true, show: true }
}

/** 保留布尔入口供既有调用方使用，新代码应读取完整决策中的铃声策略。 */
export function shouldPresentIncomingNotice(context: IncomingNoticeContext): boolean {
  return incomingNoticeDecision(context).show
}

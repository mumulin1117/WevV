import type { InboxMessage } from './contracts'
import { getRuntimeConfig } from '@/core/config/runtime-config'
import { asRecord, integer, text, type UnknownRecord } from './value-readers'

function activeLocale(): string {
  return document.documentElement.lang || 'en'
}

function relativeDay(offset: number): string {
  return new Intl.RelativeTimeFormat(activeLocale(), { numeric: 'auto' }).format(offset, 'day')
}

export function formatMessageTime(timestamp: number, now = Date.now()): string {
  if (!timestamp) return ''
  const value = new Date(timestamp)
  const today = new Date(now)
  if (value.toDateString() === today.toDateString())
    return value.toLocaleTimeString(activeLocale(), { hour: '2-digit', minute: '2-digit' })
  const yesterday = new Date(today)
  yesterday.setDate(today.getDate() - 1)
  if (value.toDateString() === yesterday.toDateString()) return relativeDay(-1)
  return value.toLocaleDateString(activeLocale(), { day: '2-digit', month: 'short' })
}

export function formatMessageDay(timestamp: number): string {
  const value = new Date(timestamp)
  const today = new Date()
  if (value.toDateString() === today.toDateString()) return relativeDay(0)
  const yesterday = new Date(today)
  yesterday.setDate(today.getDate() - 1)
  if (value.toDateString() === yesterday.toDateString()) return relativeDay(-1)
  return value.toLocaleDateString(activeLocale(), {
    day: 'numeric',
    month: 'long',
    year: 'numeric',
  })
}

export function beginsNewMessageDay(messages: readonly InboxMessage[], index: number): boolean {
  if (index === 0) return true
  const current = messages[index]
  const previous = messages[index - 1]
  if (!current || !previous) return false
  return new Date(current.createdAt).toDateString() !== new Date(previous.createdAt).toDateString()
}

export interface NotificationPresentation {
  actionLabel: string
  actionUrl: string
  avatarUrl: string
  body: string
  diamondCount: string
  imageUrl: string
  kind:
    | 'diamonds-received'
    | 'general'
    | 'live'
    | 'payment-success'
    | 'recharge-restored'
    | 'recharge-restricted'
  senderName: string
  targetImAccount: string
  targetRoomId: string
  targetUserId: string
  title: string
  viewFlag: number
}

const INTERNAL_NOTIFICATION_PATHS = new Set([
  '/home',
  '/messages',
  '/moments',
  '/party',
  '/profile',
  '/profile/diamonds',
  '/profile/vip',
])

function decodedRecord(value: unknown): UnknownRecord | null {
  let current = value
  // V1 直接返回对象，V2 返回 JSON 字符串；历史数据中还存在被服务端再次
  // JSON.stringify 的扩展。这里只解码正式扩展字段，不根据消息文案猜业务类型。
  for (let depth = 0; depth < 3; depth += 1) {
    const record = asRecord(current)
    if (record) return record
    if (typeof current !== 'string' || !current.trim()) return null
    try {
      current = JSON.parse(current) as unknown
    } catch {
      return null
    }
  }
  return asRecord(current)
}

function notificationSources(value: unknown): UnknownRecord[] {
  const root = decodedRecord(value)
  if (!root) return []
  const sources: UnknownRecord[] = []
  const queue: UnknownRecord[] = [root]
  const seen = new Set<UnknownRecord>()

  while (queue.length && sources.length < 32) {
    const current = queue.shift()
    if (!current || seen.has(current)) continue
    seen.add(current)
    sources.push(current)
    // 这些均是 NIM V1/V2 消息对象或自定义消息正式存在的固定容器。
    for (const key of [
      'messageRefer',
      'serverExtension',
      'attachment',
      'raw',
      'customContent',
      'data',
    ]) {
      const nested = decodedRecord(current[key])
      if (nested && !seen.has(nested)) queue.push(nested)
    }
  }

  // 业务字段位于扩展层，扩展必须优先于 NIM 根消息的 text/title。
  return sources.reverse()
}

export function safeNotificationActionUrl(value: string): string {
  const candidate = value.trim()
  if (!candidate) return ''
  if (candidate.startsWith('/')) {
    const path = candidate.split(/[?#]/u, 1)[0] ?? ''
    return INTERNAL_NOTIFICATION_PATHS.has(path) ? candidate : ''
  }
  try {
    const url = new URL(candidate)
    const host = url.hostname.toLowerCase()
    const apiHost = new URL(getRuntimeConfig().api.baseUrl).hostname.toLowerCase()
    return url.protocol === 'https:' && (host === apiHost || host.endsWith(`.${apiHost}`))
      ? url.href
      : ''
  } catch {
    return ''
  }
}

export function presentNotificationMessage(
  message: InboxMessage,
  fallbackTitle = 'Notification',
): NotificationPresentation {
  // 私密消息的通知只能展示安全摘要。不要扫描 raw/serverExtension，也不要把封面、
  // 礼物价格或解锁后的短期地址带到全局顶部通知。
  if (message.kind === 'private-media')
    return {
      actionLabel: '',
      actionUrl: '',
      avatarUrl: '',
      body: message.text,
      diamondCount: '',
      imageUrl: '',
      kind: 'general',
      senderName: '',
      targetImAccount: '',
      targetRoomId: '',
      targetUserId: '',
      title: fallbackTitle,
      viewFlag: 0,
    }
  const sources = notificationSources(message.raw)
  const pick = (...keys: string[]) => {
    for (const source of sources) {
      const value = text(source, ...keys)
      if (value) return value
    }
    return ''
  }
  const pickInteger = (...keys: string[]) => {
    for (const source of sources) {
      const value = integer(source, ...keys)
      if (value) return value
    }
    return 0
  }
  const title = pick('title', 'subject', 'notificationTitle') || fallbackTitle
  const body = pick('body', 'content', 'message', 'description', 'text') || message.text
  const attachType = pickInteger('attachType')
  const viewFlag = pickInteger('viewFlag')
  const targetRoomId = pick('liveRoomId', 'live_room_id', 'roomId', 'room_id')
  const targetUserId = pick(
    'userId',
    'anchorId',
    'anchorUid',
    'anchorUserId',
    'hostId',
    'hostUserId',
  )
  const targetImAccount = pick(
    'yxAccid',
    'yxAccount',
    'imAccount',
    'anchorYxAccid',
    'hostImAccount',
  )
  const livePayload = Boolean(
    targetUserId &&
    senderNameFromSources(sources) &&
    pick('icon', 'avatar', 'avatarUrl', 'anchorIcon') &&
    pick('liveRoomId', 'yxRoomId', 'agoraChannelId'),
  )
  const kind: NotificationPresentation['kind'] =
    attachType === 150 || livePayload
      ? 'live'
      : viewFlag === 4
        ? 'payment-success'
        : [5, 7, 9].includes(viewFlag)
          ? 'recharge-restricted'
          : viewFlag === 6
            ? 'recharge-restored'
            : viewFlag === 8
              ? 'diamonds-received'
              : 'general'
  return {
    actionLabel: pick('actionText', 'buttonText', 'actionLabel', 'btnText'),
    actionUrl: safeNotificationActionUrl(pick('actionUrl', 'jumpUrl', 'linkUrl', 'url', 'link')),
    avatarUrl: pick(
      'avatar',
      'avatarUrl',
      'anchorAvatar',
      'anchorIcon',
      'hostAvatar',
      'icon',
      'userIcon',
    ),
    body,
    diamondCount: pick('diamondNum', 'diamondCount', 'diamonds', 'coinNum'),
    imageUrl: message.attachmentUrl || pick('imageUrl', 'image', 'coverUrl', 'icon'),
    kind,
    senderName: senderNameFromSources(sources),
    targetImAccount,
    targetRoomId,
    targetUserId,
    title,
    viewFlag,
  }
}

function senderNameFromSources(sources: readonly UnknownRecord[]): string {
  for (const source of sources) {
    const value = text(
      source,
      'nickname',
      'nickName',
      'anchorName',
      'anchorNickname',
      'hostName',
      'senderName',
    )
    if (value) return value
  }
  return ''
}

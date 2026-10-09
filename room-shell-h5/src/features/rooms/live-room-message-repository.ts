import { getApiClient } from '@/core/auth/runtime'
import type { LiveChatMessage } from './chatroom-contracts'

interface LiveRoomMessageRow {
  avatarUrl: string
  createdAt: number
  id: string
  imAccount: string
  nickname: string
  text: string
  userId: string
  userLevel: number
  messageType: 'GIFT' | 'TEXT'
  giftId: string
  giftName: string
  giftIconUrl: string
  giftEffectUrl: string
  giftCount: number
  giftCost: number
  receiverId: string
}

function record(value: unknown): Record<string, unknown> {
  return value && typeof value === 'object' && !Array.isArray(value)
    ? (value as Record<string, unknown>)
    : {}
}

function row(value: unknown): LiveRoomMessageRow | null {
  const item = record(value)
  const id = String(item.id ?? '').trim()
  const text = String(item.text ?? '').trim()
  if (!id || !text) return null
  const createdAt = Number(item.createdAt)
  const userLevel = Number(item.userLevel)
  return {
    avatarUrl: String(item.avatarUrl ?? ''),
    createdAt: Number.isFinite(createdAt) ? createdAt : Date.now(),
    id,
    imAccount: String(item.imAccount ?? ''),
    nickname: String(item.nickname ?? ''),
    text,
    userId: String(item.userId ?? ''),
    userLevel: Number.isFinite(userLevel) ? Math.max(0, Math.trunc(userLevel)) : 0,
    messageType: String(item.messageType ?? '').toUpperCase() === 'GIFT' ? 'GIFT' : 'TEXT',
    giftId: String(item.giftId ?? ''),
    giftName: String(item.giftName ?? ''),
    giftIconUrl: String(item.giftIconUrl ?? ''),
    giftEffectUrl: String(item.giftEffectUrl ?? ''),
    giftCount: Math.max(0, Number(item.giftCount) || 0),
    giftCost: Math.max(0, Number(item.giftCost) || 0),
    receiverId: String(item.receiverId ?? ''),
  }
}

function message(value: LiveRoomMessageRow, currentUserId: string): LiveChatMessage {
  return {
    avatarUrl: value.avatarUrl,
    createdAt: value.createdAt,
    id: `persisted-live-chat:${value.id}`,
    kind: value.messageType === 'GIFT' ? 'gift' : 'text',
    nickname: value.nickname,
    own: Boolean(currentUserId) && value.userId === currentUserId,
    senderId: value.imAccount || value.userId,
    state: 'sent',
    text: value.text,
    ...(value.messageType === 'GIFT'
      ? {
          giftCount: value.giftCount || 1,
          giftCost: value.giftCost,
          giftEffectUrl: value.giftEffectUrl,
          giftIconUrl: value.giftIconUrl,
          giftId: value.giftId,
          giftName: value.giftName,
          ...(value.receiverId ? { giftReceiverIds: [value.receiverId] } : {}),
        }
      : {}),
    ...(value.userId ? { userId: value.userId } : {}),
    ...(value.userLevel > 0 ? { userLevel: value.userLevel } : {}),
  }
}

export async function loadLiveRoomMessages(
  roomId: string,
  currentUserId: string,
): Promise<LiveChatMessage[]> {
  const result = await getApiClient().request<unknown>({
    authMode: 'required',
    data: { limit: 30, roomId: Number(roomId) },
    method: 'POST',
    retryAfterAuthRecovery: true,
    url: '/_v2/discover/live/message/list',
  })
  return (Array.isArray(result) ? result : [])
    .map(row)
    .filter((item): item is LiveRoomMessageRow => Boolean(item))
    .filter((item) => item.messageType === 'TEXT')
    .map((item) => message(item, currentUserId))
}

export async function sendLiveRoomMessage(
  roomId: string,
  currentUserId: string,
  content: string,
): Promise<LiveChatMessage> {
  const result = await getApiClient().request<unknown>({
    authMode: 'required',
    data: { content, roomId: Number(roomId) },
    method: 'POST',
    retryAfterAuthRecovery: true,
    url: '/_v2/discover/live/message/send',
  })
  const parsed = row(result)
  if (!parsed) throw new Error('The saved live-room message is invalid.')
  return message(parsed, currentUserId)
}

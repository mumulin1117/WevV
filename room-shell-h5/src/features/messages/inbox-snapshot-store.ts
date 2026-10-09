import { productStorageNamespace } from '@/core/product-mode/runtime'
import { getAppDatabase } from '@/core/storage/app-database'
import type { InboxConversation, InboxMessage, PrivateMediaInfo } from './contracts'
import { asRecord, bool, integer, text } from './value-readers'

const INBOX_SNAPSHOT_SCHEMA_VERSION = 6

export interface InboxSnapshot {
  conversations: InboxConversation[]
  readWatermarks: Record<string, number>
}

function snapshotId(accountId: string): string {
  return `${productStorageNamespace(accountId, 'message-inbox-v6')}:snapshot`
}

function snapshotPrivateMedia(value: unknown): PrivateMediaInfo | undefined {
  const raw = asRecord(value)
  if (!raw) return undefined
  const privateId = integer(raw, 'privateId')
  const recordId = integer(raw, 'recordId')
  return {
    coverUrl: text(raw, 'coverUrl'),
    giftIconUrl: text(raw, 'giftIconUrl'),
    mediaType: text(raw, 'mediaType') === 'video' ? 'video' : 'image',
    price: Math.max(0, integer(raw, 'price')),
    privateId,
    ...(text(raw, 'qualityBadgeUrl') ? { qualityBadgeUrl: text(raw, 'qualityBadgeUrl') } : {}),
    recordId,
    status: privateId > 0 && recordId > 0 ? 'checking' : 'unavailable',
  }
}

function snapshotMessage(value: unknown, conversationId: string): InboxMessage | null {
  const raw = asRecord(value)
  if (!raw) return null
  const id = text(raw, 'id')
  const kind = text(raw, 'kind')
  if (!id || !['audio', 'gift', 'image', 'private-media', 'system', 'text'].includes(kind))
    return null
  const attachmentUrl = text(raw, 'attachmentUrl')
  const delivery = text(raw, 'delivery')
  const rawGift = asRecord(raw.gift)
  const gift = rawGift
    ? {
        animationUrl: text(rawGift, 'animationUrl'),
        count: Math.max(1, integer(rawGift, 'count')),
        iconUrl: text(rawGift, 'iconUrl'),
        id: text(rawGift, 'id'),
        name: text(rawGift, 'name') || 'Gift',
        price: Math.max(0, integer(rawGift, 'price')),
        source:
          text(rawGift, 'source') === 'backpack' ? ('backpack' as const) : ('wallet' as const),
      }
    : undefined
  const privateMedia = kind === 'private-media' ? snapshotPrivateMedia(raw.privateMedia) : undefined
  return {
    ...(attachmentUrl ? { attachmentUrl } : {}),
    conversationId,
    createdAt: Math.max(0, integer(raw, 'createdAt')),
    delivery: ['failed', 'sending', 'sent'].includes(delivery)
      ? (delivery as InboxMessage['delivery'])
      : 'sent',
    ...(gift ? { gift } : {}),
    id,
    kind: kind as InboxMessage['kind'],
    own: bool(raw, 'own'),
    ...(privateMedia ? { privateMedia } : {}),
    senderId: text(raw, 'senderId'),
    text: text(raw, 'text'),
  }
}

function snapshotConversation(value: unknown): InboxConversation | null {
  const raw = asRecord(value)
  if (!raw) return null
  const conversationId = text(raw, 'conversationId')
  const imAccount = text(raw, 'imAccount')
  if (!conversationId || !imAccount) return null
  const latest = snapshotMessage(raw.latest, conversationId)
  return {
    avatarUrl: text(raw, 'avatarUrl'),
    conversationId,
    displayName: text(raw, 'displayName') || imAccount,
    imAccount,
    latest,
    muted: bool(raw, 'muted'),
    online: bool(raw, 'online'),
    sortTime: Math.max(0, integer(raw, 'sortTime'), latest?.createdAt ?? 0),
    unread: Math.max(0, integer(raw, 'unread')),
    userId: text(raw, 'userId'),
  }
}

export async function restoreInboxSnapshot(accountId: string): Promise<InboxSnapshot | null> {
  const id = snapshotId(accountId)
  const stored = await getAppDatabase().snapshots.get(id)
  if (!stored) return null
  try {
    const value = JSON.parse(stored.payload) as {
      conversations?: unknown[]
      readWatermarks?: Record<string, number>
      schemaVersion?: number
    }
    if (value.schemaVersion !== INBOX_SNAPSHOT_SCHEMA_VERSION)
      throw new Error('MESSAGE_SNAPSHOT_VERSION_MISMATCH')
    const readWatermarks = Object.fromEntries(
      Object.entries(value.readWatermarks ?? {})
        .filter(
          ([conversationId, timestamp]) =>
            Boolean(conversationId) && Number.isFinite(timestamp) && timestamp > 0,
        )
        .map(([conversationId, timestamp]) => [conversationId, Number(timestamp)]),
    )
    let conversations = (value.conversations ?? [])
      .map(snapshotConversation)
      .filter((item): item is InboxConversation => item !== null)
      .sort((left, right) => right.sortTime - left.sortTime)
    conversations.forEach((conversation) => {
      if (!conversation.unread && conversation.latest)
        readWatermarks[conversation.conversationId] = Math.max(
          readWatermarks[conversation.conversationId] ?? 0,
          conversation.latest.createdAt,
        )
    })
    conversations = conversations.map((conversation) => {
      const watermark = readWatermarks[conversation.conversationId] ?? 0
      if (!watermark || (conversation.latest?.createdAt ?? conversation.sortTime) > watermark)
        return conversation
      return conversation.unread ? { ...conversation, unread: 0 } : conversation
    })
    return { conversations, readWatermarks }
  } catch {
    await getAppDatabase().snapshots.delete(id)
    return null
  }
}

export async function persistInboxSnapshot(
  accountId: string,
  snapshot: InboxSnapshot,
): Promise<void> {
  const conversations = snapshot.conversations.map((conversation) => {
    const latest = conversation.latest
    return {
      ...conversation,
      latest: latest
        ? {
            ...latest,
            audio: undefined,
            ...(latest.privateMedia
              ? {
                  privateMedia: {
                    ...latest.privateMedia,
                    mediaUrl: undefined,
                    status:
                      latest.privateMedia.privateId > 0 && latest.privateMedia.recordId > 0
                        ? 'checking'
                        : 'unavailable',
                  },
                }
              : {}),
            raw: undefined,
          }
        : null,
    }
  })
  await getAppDatabase().snapshots.put({
    accountId,
    id: snapshotId(accountId),
    payload: JSON.stringify({
      conversations,
      readWatermarks: snapshot.readWatermarks,
      schemaVersion: INBOX_SNAPSHOT_SCHEMA_VERSION,
    }),
    updatedAt: Date.now(),
  })
}

export async function deleteInboxSnapshot(accountId: string): Promise<void> {
  await getAppDatabase().snapshots.delete(snapshotId(accountId))
}

import { z } from 'zod'
import { getApiClient } from '@/core/auth/runtime'
import type {
  InboxConversation,
  InboxMessage,
  MessageGateway,
  MessageGatewayEvent,
  MessagePage,
} from './contracts'

const messageSchema = z.object({
  attachmentUrl: z.string().optional(),
  conversationId: z.string(),
  createdAt: z.number(),
  delivery: z.enum(['failed', 'sending', 'sent']),
  id: z.string(),
  kind: z.enum(['audio', 'gift', 'image', 'private-media', 'system', 'text']),
  own: z.boolean(),
  senderId: z.string(),
  text: z.string(),
})

const conversationSchema = z.object({
  avatarUrl: z.string(),
  conversationId: z.string(),
  displayName: z.string(),
  imAccount: z.string(),
  latest: messageSchema.nullable(),
  muted: z.boolean(),
  online: z.boolean(),
  sortTime: z.number(),
  unread: z.number(),
  userId: z.string(),
})

const messagePageSchema = z.object({
  finished: z.boolean(),
  items: z.array(messageSchema),
  nextCursor: z.string(),
})

const conversationPageSchema = z.object({
  finished: z.boolean(),
  items: z.array(conversationSchema),
  nextCursor: z.string(),
})

const deletedSchema = z.object({ conversationIds: z.array(z.string()) })
const emptySchema = z.object({}).passthrough()

export class HttpMessageGateway implements MessageGateway {
  private connected = false
  private readonly listeners = new Set<(event: MessageGatewayEvent) => void>()
  private receiveCursor = '0'
  private receiveTimer = 0
  private receivePending = false
  private receiveBaselined = false
  private visible = true

  async connect(): Promise<void> {
    if (this.connected) return
    this.connected = true
    await this.receive(true)
  }

  async disconnect(): Promise<void> {
    this.connected = false
    window.clearTimeout(this.receiveTimer)
    this.receiveTimer = 0
  }

  connectionState(): 'connected' | 'connecting' | 'disconnected' {
    return this.connected ? 'connected' : 'disconnected'
  }

  setVisible(visible: boolean): void {
    this.visible = visible
    if (!this.connected || this.receivePending) return
    window.clearTimeout(this.receiveTimer)
    this.scheduleReceive()
  }

  observe(listener: (event: MessageGatewayEvent) => void): () => void {
    this.listeners.add(listener)
    return () => this.listeners.delete(listener)
  }

  async conversationIdFor(imAccount: string): Promise<string> {
    const account = imAccount.trim().replace(/^p2p:/u, '')
    if (!account) throw new Error('Message recipient is unavailable.')
    return `p2p:${account}`
  }

  async listConversations(cursor = '0', limit = 40): Promise<MessagePage<InboxConversation>> {
    return getApiClient().request({
      authMode: 'required',
      data: { cursor: Number(cursor) || 0, limit },
      method: 'POST',
      schema: conversationPageSchema,
      url: '/_v2/message/conversations',
    })
  }

  async listMessages(
    conversationId: string,
    cursor = '0',
    limit = 50,
  ): Promise<MessagePage<InboxMessage>> {
    return getApiClient().request({
      authMode: 'required',
      data: { conversationId, cursor: Number(cursor) || 0, limit },
      method: 'POST',
      schema: messagePageSchema,
      url: '/_v2/message/history',
    })
  }

  async sendText(conversationId: string, text: string): Promise<InboxMessage> {
    const message = await getApiClient().request({
      authMode: 'required',
      data: { conversationId, kind: 'text', text },
      method: 'POST',
      schema: messageSchema,
      url: '/_v2/message/send',
    })
    this.emit({ message, type: 'message' })
    return message
  }

  async sendImage(conversationId: string, file: File): Promise<InboxMessage> {
    if (!file.type.startsWith('image/')) throw new Error('Please select an image.')
    const attachmentUrl = await fileToDataUrl(file)
    const message = await getApiClient().request({
      authMode: 'required',
      data: { attachmentUrl, conversationId, kind: 'image', text: '[Image]' },
      method: 'POST',
      schema: messageSchema,
      url: '/_v2/message/send',
    })
    this.emit({ message, type: 'message' })
    return message
  }

  async markRead(conversationId: string): Promise<void> {
    await this.empty('/_v2/message/read', { conversationId })
  }

  async clearAllUnread(): Promise<void> {
    const page = await this.listConversations('0', 100)
    await Promise.all(page.items.map((item) => this.markRead(item.conversationId)))
  }

  async deleteConversation(conversationId: string): Promise<void> {
    await this.empty('/_v2/message/delete', { conversationId })
    this.emit({ conversationIds: [conversationId], type: 'conversations-deleted' })
  }

  async deleteConversations(conversationIds: readonly string[]): Promise<void> {
    await Promise.all(
      conversationIds.map((id) => this.empty('/_v2/message/delete', { conversationId: id })),
    )
    this.emit({ conversationIds, type: 'conversations-deleted' })
  }

  async deleteAllConversations(): Promise<readonly string[]> {
    const result = await getApiClient().request({
      authMode: 'required',
      data: {},
      method: 'POST',
      schema: deletedSchema,
      url: '/_v2/message/delete-all',
    })
    this.emit({ conversationIds: result.conversationIds, type: 'conversations-deleted' })
    return result.conversationIds
  }

  private async empty(url: string, data: Record<string, unknown>): Promise<void> {
    await getApiClient().request({
      authMode: 'required',
      data,
      method: 'POST',
      schema: emptySchema,
      url,
    })
  }

  private async receive(initial = false): Promise<void> {
    if (!this.connected || this.receivePending) return
    this.receivePending = true
    window.clearTimeout(this.receiveTimer)
    try {
      const page = await getApiClient().request({
        authMode: 'required',
        data: { afterId: Number(this.receiveCursor) || 0, limit: 100 },
        method: 'POST',
        schema: messagePageSchema,
        url: '/_v2/message/events',
      })
      const wasBaselined = this.receiveBaselined
      this.receiveBaselined = true
      this.receiveCursor = page.nextCursor || this.receiveCursor
      if (wasBaselined && !initial) {
        page.items.forEach((message) => this.emit({ message, type: 'message' }))
      }
    } catch {
      // A temporary receive failure must not take the composer offline. The next
      // incremental request resumes from the last confirmed server message id.
    } finally {
      this.receivePending = false
      this.scheduleReceive()
    }
  }

  private scheduleReceive(): void {
    if (!this.connected) return
    window.clearTimeout(this.receiveTimer)
    this.receiveTimer = window.setTimeout(() => void this.receive(), this.visible ? 2_000 : 8_000)
  }

  private emit(event: MessageGatewayEvent): void {
    this.listeners.forEach((listener) => listener(event))
  }
}

function fileToDataUrl(file: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.onerror = () => reject(new Error('The image could not be read.'))
    reader.onload = () => resolve(String(reader.result ?? ''))
    reader.readAsDataURL(file)
  })
}

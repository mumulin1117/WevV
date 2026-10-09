import type { InboxConversation, InboxMessage } from './contracts'

const STARTUP_REPLAY_GRACE_MS = 5_000

export class IncomingNoticeGate {
  private readyAt = 0
  private readonly watermarks = new Map<string, number>()

  begin(): void {
    this.readyAt = 0
    this.watermarks.clear()
  }

  arm(conversations: readonly InboxConversation[], now = Date.now()): void {
    conversations.forEach((conversation) => {
      this.watermarks.set(
        conversation.conversationId,
        Math.max(
          this.watermarks.get(conversation.conversationId) ?? 0,
          conversation.sortTime,
          conversation.latest?.createdAt ?? 0,
        ),
      )
    })
    this.readyAt = now
  }

  accept(message: InboxMessage): boolean {
    const previous = this.watermarks.get(message.conversationId) ?? 0
    this.watermarks.set(message.conversationId, Math.max(previous, message.createdAt))
    if (!this.readyAt) return false
    if (message.createdAt <= previous) return false
    return message.createdAt >= this.readyAt - STARTUP_REPLAY_GRACE_MS
  }

  reset(): void {
    this.begin()
  }
}

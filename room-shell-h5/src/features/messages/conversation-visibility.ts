import type { InboxConversation } from './contracts'

export function selectRegularConversations(
  conversations: readonly InboxConversation[],
  noticeAccount: string,
  rechargeAccount: string,
): InboxConversation[] {
  return conversations.filter(
    (conversation) =>
      conversation.imAccount !== noticeAccount && conversation.imAccount !== rechargeAccount,
  )
}

export function sumConversationUnread(conversations: readonly InboxConversation[]): number {
  return conversations.reduce(
    (total, conversation) => total + Math.max(0, Number(conversation.unread) || 0),
    0,
  )
}

export function preserveHiddenConversationSummaries(
  loaded: readonly InboxConversation[],
  previous: readonly InboxConversation[],
  hiddenIds: readonly string[],
  requestedAt: number,
): InboxConversation[] {
  const loadedIds = new Set(loaded.map((item) => item.conversationId))
  const hidden = new Set(hiddenIds)
  const preserved = previous.filter(
    (item) => hidden.has(item.conversationId) && !loadedIds.has(item.conversationId),
  )
  const arrivedDuringRequest = previous.filter(
    (item) =>
      !loadedIds.has(item.conversationId) &&
      !hidden.has(item.conversationId) &&
      item.sortTime >= requestedAt,
  )
  return [...loaded, ...preserved, ...arrivedDuringRequest].sort(
    (left, right) => right.sortTime - left.sortTime,
  )
}

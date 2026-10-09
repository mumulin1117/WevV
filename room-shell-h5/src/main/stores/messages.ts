import { ApiClientError } from '@/core/api/client'
import { getServerRuntimeConfigOrNull } from '@/core/config/server-runtime-config'
import type { RuntimeScope } from '@/core/runtime/runtime-scope'
import { appActivity } from '@/core/runtime/app-activity'
import type {
  CustomerAgent,
  CustomerProblem,
  GiftItem,
  InboxConversation,
  InboxMessage,
  MessageGateway,
  MessageGatewayEvent,
  MessageProfile,
  MessageRepository,
  OnlineHost,
  PrivateMediaCheckResult,
  PrivateMediaInfo,
  PrivateMediaUnlockOutcome,
  RelationUser,
} from '@/features/messages/contracts'
import { getRemoteMessageRepositoryOrNull, InboxSession } from '@/features/messages/inbox-session'
import {
  deleteInboxSnapshot,
  persistInboxSnapshot as saveInboxSnapshot,
  restoreInboxSnapshot as loadInboxSnapshot,
} from '@/features/messages/inbox-snapshot-store'
import {
  effectivePresence,
  presenceSnapshot,
  type PresenceUpdate,
} from '@/features/messages/presence-runtime'
import { liveStartNoticeIdentity } from '@/features/messages/live-start-notice'
import { presentNotificationMessage } from '@/features/messages/presentation'
import { privateImageAttachmentUrl } from '@/features/messages/nim-message-gateway'
import { createId } from '@/shared/id'
import {
  preserveHiddenConversationSummaries,
  selectRegularConversations,
  sumConversationUnread,
} from '@/features/messages/conversation-visibility'
import { IncomingNoticeGate } from '@/features/messages/incoming-notice-gate'
import { acceptHMRUpdate, defineStore } from 'pinia'
import { computed, ref, shallowRef } from 'vue'
import { useSessionStore } from './session'
import { useRelationshipsStore } from './relationships'

type RuntimeStatus = 'error' | 'idle' | 'loading' | 'ready'

export const useMessagesStore = defineStore('messages', () => {
  const session = useSessionStore()
  const relationships = useRelationshipsStore()
  const status = ref<RuntimeStatus>('idle')
  const error = shallowRef<unknown>(null)
  const conversations = ref<InboxConversation[]>([])
  const onlineHosts = ref<OnlineHost[]>([])
  const messages = ref<Record<string, InboxMessage[]>>({})
  const messageCursors = ref<Record<string, string>>({})
  const messageFinished = ref<Record<string, boolean>>({})
  const profiles = ref<Record<string, MessageProfile>>({})
  const identitiesReady = ref(false)
  const unread = ref(0)
  const incomingMessages = ref<InboxMessage[]>([])
  const latestIncoming = computed(() => incomingMessages.value[0] ?? null)
  const incomingSequence = ref(0)
  const activeConversationId = ref('')
  const nextConversationCursor = ref('0')
  const conversationFinished = ref(false)
  let gateway: MessageGateway | null = null
  let repository: MessageRepository | null = null
  const inboxSession = new InboxSession()
  let startPromise: Promise<void> | undefined
  let stopPromise: Promise<void> | undefined
  let refreshPromise: Promise<void> | undefined
  let presentationRefreshPromise: Promise<void> | undefined
  let onlineHostsRefreshPromise: Promise<void> | undefined
  let customerAgentsPromise: Promise<readonly CustomerAgent[]> | undefined
  let customerAgentsCache: readonly CustomerAgent[] | undefined
  const giftCatalogByTarget = new Map<string, { at: number; gifts: readonly GiftItem[] }>()
  const giftCatalogPromises = new Map<string, Promise<readonly GiftItem[]>>()
  const profileHydrationPromises = new Map<string, Promise<void>>()
  let loadMorePromise: Promise<void> | undefined
  const loadEarlierPromises = new Map<string, Promise<void>>()
  const markReadPromises = new Map<string, Promise<void>>()
  const privateCheckPromises = new Map<number, Promise<void>>()
  const privateUnlockPromises = new Map<number, Promise<PrivateMediaUnlockOutcome>>()
  let lastRefreshAt = 0
  let lastPresentationRefreshAt = 0
  let lastOnlineHostsRefreshAt = 0
  let snapshotTimer = 0
  let unknownConversationRefreshTimer = 0
  let runtimeScope: RuntimeScope | undefined
  let readWatermarks: Record<string, number> = {}
  const pendingImageUrls = new Set<string>()
  const pendingUnknownConversationIds = new Set<string>()
  const incomingNoticeGate = new IncomingNoticeGate()

  const rechargeAccount = ''
  const noticeAccount = (): string => getServerRuntimeConfigOrNull()?.noticeAccount ?? ''
  const notificationConversation = computed(() =>
    conversations.value.find((item) => item.imAccount === noticeAccount()),
  )
  const rechargeConversation = computed(() =>
    conversations.value.find((item) => item.imAccount === rechargeAccount),
  )
  const regularConversations = computed(() =>
    selectRegularConversations(conversations.value, noticeAccount(), rechargeAccount),
  )
  const regularUnread = computed(() => sumConversationUnread(regularConversations.value))

  function ownsRuntime(scope: RuntimeScope | undefined): scope is RuntimeScope {
    return Boolean(scope?.active && runtimeScope === scope)
  }

  function ownsAccount(ownerId: string): boolean {
    return Boolean(session.authenticated && session.user?.id === ownerId)
  }

  async function ensureDirectoryRepository(): Promise<MessageRepository> {
    if (repository) return repository
    const remoteRepository = getRemoteMessageRepositoryOrNull()
    if (remoteRepository) return (repository = remoteRepository)
    await start()
    if (!repository) throw new Error('Message data is unavailable.')
    return repository
  }

  async function start(scope = runtimeScope): Promise<void> {
    await stopPromise
    if (!scope) throw new Error('The account runtime has not started the inbox session.')
    if (!session.authenticated || !session.user) return
    const ownerId = session.user.id
    if (status.value === 'ready' && ownsRuntime(scope)) return
    if (runtimeScope && runtimeScope !== scope) await stop()
    if (!session.authenticated || session.user?.id !== ownerId) return
    if (startPromise) return startPromise
    runtimeScope = scope
    const activeScope = scope
    incomingNoticeGate.begin()
    status.value = 'loading'
    identitiesReady.value = false
    error.value = null
    const task = (async () => {
      await restoreInboxSnapshot(ownerId)
      if (!ownsRuntime(activeScope) || !session.authenticated || session.user?.id !== ownerId)
        return
      // Remote 的资料、礼物、关系等数据来自 OPI，与 NIM 会话连接是两条链路。
      // 先建立 OPI repository，避免 NIM 暂时不可用时连普通资料页也一起失效。
      repository = getRemoteMessageRepositoryOrNull() ?? repository
      const connected = await inboxSession.connect(activeScope, {
        credential: session.ensureRealtimeCredential,
        getBalance: () => session.balance,
        onEvent: handleGatewayEvent,
        onPresence: applyPresence,
        ownerId,
        setBalance: session.updateBalance,
        visible: appActivity.value.visible,
      })
      gateway = connected.gateway
      repository = connected.repository
      await refresh(true)
      if (!ownsRuntime(activeScope) || !session.authenticated || session.user?.id !== ownerId)
        return
      // 首次会话同步返回的是 NIM account 级摘要，OPI 用户资料会提供最终昵称和头像。
      // 先完成这一批资料合并再宣布运行时 ready，避免列表和聊天 Header 先显示 account、
      // 下一帧再跳成昵称。关注中直播主播列表仍后台加载，不拉长消息主链路。
      await hydrateProfiles(conversations.value.map((item) => item.imAccount))
      if (!ownsRuntime(activeScope) || !session.authenticated || session.user?.id !== ownerId)
        return
      mergeProfilesIntoConversations()
      identitiesReady.value = true
      incomingNoticeGate.arm(conversations.value)
      status.value = 'ready'
    })()
      .catch(async (cause) => {
        if (!ownsRuntime(activeScope)) return
        await inboxSession.stop()
        gateway = null
        if (!getRemoteMessageRepositoryOrNull()) repository = null
        error.value = cause
        status.value = 'error'
        throw cause
      })
      .finally(() => {
        if (startPromise === task) startPromise = undefined
      })
    startPromise = task
    return task
  }

  async function stop(): Promise<void> {
    if (stopPromise) return stopPromise
    const task = (async () => {
      runtimeScope = undefined
      startPromise = undefined
      refreshPromise = undefined
      presentationRefreshPromise = undefined
      onlineHostsRefreshPromise = undefined
      customerAgentsPromise = undefined
      customerAgentsCache = undefined
      giftCatalogPromises.clear()
      giftCatalogByTarget.clear()
      profileHydrationPromises.clear()
      loadMorePromise = undefined
      loadEarlierPromises.clear()
      markReadPromises.clear()
      privateCheckPromises.clear()
      privateUnlockPromises.clear()
      await inboxSession.stop()
      window.clearTimeout(snapshotTimer)
      window.clearTimeout(unknownConversationRefreshTimer)
      unknownConversationRefreshTimer = 0
      pendingUnknownConversationIds.clear()
      incomingNoticeGate.reset()
      pendingImageUrls.forEach((url) => URL.revokeObjectURL(url))
      pendingImageUrls.clear()
      gateway = null
      repository = null
      readWatermarks = {}
      conversations.value = []
      onlineHosts.value = []
      messages.value = {}
      messageCursors.value = {}
      messageFinished.value = {}
      profiles.value = {}
      identitiesReady.value = false
      unread.value = 0
      incomingMessages.value = []
      incomingSequence.value = 0
      activeConversationId.value = ''
      nextConversationCursor.value = '0'
      conversationFinished.value = false
      lastRefreshAt = 0
      lastPresentationRefreshAt = 0
      lastOnlineHostsRefreshAt = 0
      error.value = null
      status.value = 'idle'
    })().finally(() => {
      if (stopPromise === task) stopPromise = undefined
    })
    stopPromise = task
    return task
  }

  async function refresh(force = false, includePresentation = false): Promise<void> {
    if (!gateway || !repository) return
    const now = Date.now()
    const refreshInbox = force || now - lastRefreshAt >= 4_000
    const refreshPresentation =
      includePresentation && (force || now - lastPresentationRefreshAt >= 15_000)
    const tasks: Promise<void>[] = []
    if (refreshInbox || refreshPromise) tasks.push(refreshInboxData())
    if (refreshPresentation || presentationRefreshPromise) tasks.push(refreshPresentationData())
    await Promise.all(tasks)
  }

  async function resume(scope: RuntimeScope): Promise<void> {
    // Inbox 首次启动失败会主动清掉内部 runtimeScope。前台恢复和页面手动重试
    // 必须重新传入账号 Scope，不能依赖已经失效的 Store 内部默认值。
    await start(scope)
    if (!ownsRuntime(scope) || !gateway) return
    const reconnected = await inboxSession.resume(appActivity.value.visible)
    if (reconnected) await refresh(true)
  }

  function refreshInboxData(): Promise<void> {
    if (refreshPromise) return refreshPromise
    if (!gateway) return Promise.resolve()
    const activeScope = runtimeScope
    const task = (async () => {
      const requestedAt = Date.now()
      const conversationPage = await gateway?.listConversations('0', 40)
      if (!conversationPage || !ownsRuntime(activeScope)) return
      const current = new Map(conversations.value.map((item) => [item.conversationId, item]))
      const loaded = conversationPage.items.map((source) => {
        const item = applyReadWatermark(source)
        const existing = current.get(item.conversationId)
        // 查询飞行期间可能已经收到实时消息。旧查询结果不能倒灌覆盖更新的摘要和红点。
        if (
          existing?.latest &&
          (!item.latest || existing.latest.createdAt > item.latest.createdAt)
        ) {
          return stableConversation(
            {
              ...item,
              latest: existing.latest,
              sortTime: Math.max(item.sortTime, existing.sortTime),
              unread: Math.max(item.unread, existing.unread),
            },
            existing,
          )
        }
        return stableConversation(item, existing)
      })
      conversations.value = preserveHiddenConversationSummaries(
        loaded,
        conversations.value,
        conversationPage.hiddenIds ?? [],
        requestedAt,
      )
      nextConversationCursor.value = conversationPage.nextCursor
      conversationFinished.value = conversationPage.finished
      lastRefreshAt = Date.now()
      mergeProfilesIntoConversations()
      unread.value = conversations.value.reduce((sum, item) => sum + item.unread, 0)
      scheduleInboxSnapshot()
      void reconcilePrivateMedia(
        conversations.value.flatMap((item) => (item.latest ? [item.latest] : [])),
      ).catch(() => undefined)
    })().finally(() => {
      if (refreshPromise === task) refreshPromise = undefined
    })
    refreshPromise = task
    return task
  }

  function refreshPresentationData(): Promise<void> {
    if (presentationRefreshPromise) return presentationRefreshPromise
    if (!repository) return Promise.resolve()
    const activeScope = runtimeScope
    const activeRepository = repository
    const task = (async () => {
      await refreshOnlineHostsData(true, activeRepository)
      if (!ownsRuntime(activeScope)) return
      await hydrateProfiles(conversations.value.map((item) => item.imAccount))
      if (!ownsRuntime(activeScope)) return
      mergeProfilesIntoConversations()
      lastPresentationRefreshAt = Date.now()
      scheduleInboxSnapshot()
    })().finally(() => {
      if (presentationRefreshPromise === task) presentationRefreshPromise = undefined
    })
    presentationRefreshPromise = task
    return task
  }

  function refreshOnlineHostsData(
    force = false,
    source: MessageRepository | null = repository,
  ): Promise<void> {
    if (!source || (!force && Date.now() - lastOnlineHostsRefreshAt < 4_000))
      return Promise.resolve()
    if (onlineHostsRefreshPromise) return onlineHostsRefreshPromise
    const ownerId = session.user?.id ?? ''
    const task = source
      .getOnlineHosts()
      .then((hosts) => {
        if (!ownsAccount(ownerId)) return
        hosts.forEach((profile) =>
          relationships.seed({
            followed: profile.followed,
            imAccount: profile.imAccount,
            userId: profile.userId,
            userType: profile.userType || 2,
          }),
        )
        onlineHosts.value = [...hosts]
        applyKnownPresence()
        lastOnlineHostsRefreshAt = Date.now()
      })
      .finally(() => {
        if (onlineHostsRefreshPromise === task) onlineHostsRefreshPromise = undefined
      })
    onlineHostsRefreshPromise = task
    return task
  }

  async function refreshOnlineHosts(): Promise<void> {
    const source = await ensureDirectoryRepository()
    await refreshOnlineHostsData(false, source)
  }

  async function loadMoreConversations(): Promise<void> {
    if (loadMorePromise) return loadMorePromise
    if (!gateway || conversationFinished.value) return
    const activeScope = runtimeScope
    const requestedCursor = nextConversationCursor.value
    const task = (async () => {
      const page = await gateway?.listConversations(requestedCursor, 30)
      if (!page || !ownsRuntime(activeScope)) return
      const advanced = page.nextCursor !== requestedCursor
      mergeConversations(page.items)
      nextConversationCursor.value = advanced ? page.nextCursor : requestedCursor
      conversationFinished.value = page.finished || !advanced || page.items.length === 0
      await hydrateProfiles(page.items.map((item) => item.imAccount))
      if (!ownsRuntime(activeScope)) return
      mergeProfilesIntoConversations()
    })().finally(() => {
      if (loadMorePromise === task) loadMorePromise = undefined
    })
    loadMorePromise = task
    return task
  }

  async function loadConversation(conversationId: string, refreshLatest = true): Promise<void> {
    await start()
    if (!gateway) return
    if (!refreshLatest && messages.value[conversationId]?.length) return
    const activeScope = runtimeScope
    const page = await gateway.listMessages(conversationId, '', 50)
    if (!ownsRuntime(activeScope)) return
    // 历史查询期间仍可能收到实时消息或发送 optimistic 消息；不能用查询结果整页覆盖它们。
    const merged = new Map((messages.value[conversationId] ?? []).map((item) => [item.id, item]))
    // 云端历史是通知 serverExtension 的真值。相同消息必须用本次查询结果覆盖，
    // 否则旧内存项缺失 raw 时会持续退化为默认头像和普通消息卡片。
    for (const item of page.items) merged.set(item.id, item)
    messages.value = {
      ...messages.value,
      [conversationId]: [...merged.values()].sort(
        (left, right) => left.createdAt - right.createdAt,
      ),
    }
    messageCursors.value = { ...messageCursors.value, [conversationId]: page.nextCursor }
    messageFinished.value = { ...messageFinished.value, [conversationId]: page.finished }
    void reconcilePrivateMedia(page.items).catch(() => undefined)
    // 历史已经进入 Store 后即可结束页面加载；清未读是旁路写操作，弱网时不能继续压住骨架和输入区。
    void markRead(conversationId)
  }

  async function loadEarlier(conversationId: string): Promise<void> {
    const pending = loadEarlierPromises.get(conversationId)
    if (pending) return pending
    if (!gateway || messageFinished.value[conversationId]) return
    const activeScope = runtimeScope
    const requestedCursor = messageCursors.value[conversationId] ?? ''
    const task = (async () => {
      const page = await gateway?.listMessages(conversationId, requestedCursor, 50)
      if (!page || !ownsRuntime(activeScope)) return
      const current = messages.value[conversationId] ?? []
      const known = new Set(current.map((item) => item.id))
      const visible = page.items.filter((item) => !known.has(item.id))
      messages.value = { ...messages.value, [conversationId]: [...visible, ...current] }
      const advanced = Boolean(page.nextCursor) && page.nextCursor !== requestedCursor
      messageCursors.value = {
        ...messageCursors.value,
        [conversationId]: advanced ? page.nextCursor : requestedCursor,
      }
      messageFinished.value = {
        ...messageFinished.value,
        [conversationId]: page.finished || !advanced,
      }
      void reconcilePrivateMedia(page.items).catch(() => undefined)
    })().finally(() => {
      if (loadEarlierPromises.get(conversationId) === task)
        loadEarlierPromises.delete(conversationId)
    })
    loadEarlierPromises.set(conversationId, task)
    return task
  }

  async function conversationIdFor(imAccount: string): Promise<string> {
    await start()
    if (!gateway) throw new Error('Messages are unavailable.')
    return gateway.conversationIdFor(imAccount)
  }

  async function profileFor(imAccount: string): Promise<MessageProfile | undefined> {
    await ensureDirectoryRepository()
    if (!imAccount) return undefined
    await hydrateProfiles([imAccount])
    mergeProfilesIntoConversations()
    return profiles.value[imAccount]
  }

  async function sendText(conversationId: string, text: string): Promise<InboxMessage> {
    if (!gateway) throw new Error('Messages are unavailable.')
    const value = text.trim()
    if (!value) throw new Error('Message cannot be empty.')
    const pending: InboxMessage = {
      conversationId,
      createdAt: Date.now(),
      delivery: 'sending',
      id: createId('pending-message'),
      kind: 'text',
      own: true,
      senderId: session.user?.id ?? '',
      text: value,
    }
    mergeMessage(pending)
    const activeScope = runtimeScope
    try {
      const message = await gateway.sendText(conversationId, value)
      if (ownsRuntime(activeScope)) replaceMessage(pending.id, message)
      return message
    } catch (cause) {
      setMessageDelivery(conversationId, pending.id, 'failed')
      throw cause
    }
  }

  async function retryText(message: InboxMessage): Promise<void> {
    if (!gateway || message.kind !== 'text' || message.delivery !== 'failed') return
    const activeScope = runtimeScope
    setMessageDelivery(message.conversationId, message.id, 'sending')
    try {
      const delivered = await gateway.sendText(message.conversationId, message.text)
      if (ownsRuntime(activeScope)) replaceMessage(message.id, delivered)
    } catch (cause) {
      setMessageDelivery(message.conversationId, message.id, 'failed')
      throw cause
    }
  }

  async function sendImage(conversationId: string, file: File): Promise<InboxMessage> {
    if (!gateway) throw new Error('Messages are unavailable.')
    const previewUrl = URL.createObjectURL(file)
    pendingImageUrls.add(previewUrl)
    const pending: InboxMessage = {
      attachmentUrl: previewUrl,
      conversationId,
      createdAt: Date.now(),
      delivery: 'sending',
      id: createId('pending-image'),
      kind: 'image',
      own: true,
      senderId: session.user?.id ?? '',
      text: '[Image]',
    }
    mergeMessage(pending)
    const activeScope = runtimeScope
    try {
      const message = await gateway.sendImage(conversationId, file)
      if (ownsRuntime(activeScope)) replaceMessage(pending.id, message)
      URL.revokeObjectURL(previewUrl)
      pendingImageUrls.delete(previewUrl)
      return message
    } catch (cause) {
      setMessageDelivery(conversationId, pending.id, 'failed')
      throw cause
    }
  }

  async function markRead(conversationId: string): Promise<void> {
    if (!conversationId) return
    const requestedWatermark = markConversationLocallyRead(conversationId)
    const pending = markReadPromises.get(conversationId)
    if (pending) return pending
    if (!gateway) return
    const task = (async () => {
      await gateway?.markRead(conversationId).catch(() => undefined)
    })().finally(() => {
      if (markReadPromises.get(conversationId) === task) markReadPromises.delete(conversationId)
      // 停留在会话期间若又收到消息，第一条清未读仍在途时先更新本地水位；完成后
      // 再补一次云端清理，防止刷新后“幽灵未读”重新出现。
      if ((readWatermarks[conversationId] ?? 0) > requestedWatermark) void markRead(conversationId)
    })
    markReadPromises.set(conversationId, task)
    return task
  }

  function markConversationLocallyRead(conversationId: string): number {
    const conversation = getConversation(conversationId)
    const latestTime = Math.max(
      readWatermarks[conversationId] ?? 0,
      conversation?.sortTime ?? 0,
      conversation?.latest?.createdAt ?? 0,
      ...(messages.value[conversationId] ?? []).map((item) => item.createdAt),
    )
    if (latestTime > 0) readWatermarks[conversationId] = latestTime
    if (conversation?.unread) conversation.unread = 0
    incomingMessages.value = incomingMessages.value.filter(
      (message) => message.conversationId !== conversationId,
    )
    unread.value = conversations.value.reduce((sum, item) => sum + item.unread, 0)
    scheduleInboxSnapshot()
    return latestTime
  }

  function enterConversation(conversationId: string): void {
    if (!conversationId) return
    activeConversationId.value = conversationId
    void markRead(conversationId)
  }

  function leaveConversation(conversationId: string): void {
    if (!conversationId) return
    void markRead(conversationId)
    if (activeConversationId.value === conversationId) activeConversationId.value = ''
  }

  async function markAllRead(): Promise<void> {
    if (!gateway) return
    await gateway.clearAllUnread()
    conversations.value.forEach((item) => {
      item.unread = 0
      readWatermarks[item.conversationId] = Math.max(
        readWatermarks[item.conversationId] ?? 0,
        item.latest?.createdAt ?? 0,
        item.sortTime,
      )
    })
    unread.value = 0
    incomingMessages.value = []
    scheduleInboxSnapshot()
  }

  async function deleteConversation(conversationId: string): Promise<void> {
    if (!gateway) return
    await gateway.deleteConversation(conversationId)
    removeConversations([conversationId])
  }

  async function deleteAllConversations(): Promise<void> {
    if (!gateway) return
    const ids = await gateway.deleteAllConversations()
    removeConversations(ids)
    incomingMessages.value = []
  }

  async function getRelations(type: 1 | 2 | 3): Promise<readonly RelationUser[]> {
    const source = await ensureDirectoryRepository()
    const values = await source.getRelations(type)
    values.forEach((profile) =>
      relationships.seed({
        followed: profile.followed,
        imAccount: profile.imAccount,
        userId: profile.userId,
        userType: profile.userType,
      }),
    )
    return values
  }

  async function getCustomerAgents(): Promise<readonly CustomerAgent[]> {
    const source = await ensureDirectoryRepository()
    if (customerAgentsCache) return customerAgentsCache
    if (customerAgentsPromise) return customerAgentsPromise
    const ownerId = session.user?.id ?? ''
    const task = Promise.resolve(source.getCustomerAgents())
      .then((value) => {
        if (ownsAccount(ownerId)) customerAgentsCache = value
        return value
      })
      .finally(() => {
        if (customerAgentsPromise === task) customerAgentsPromise = undefined
      })
    customerAgentsPromise = task
    return task
  }

  async function getCustomerProblems(): Promise<readonly CustomerProblem[]> {
    return (await ensureDirectoryRepository()).getCustomerProblems()
  }

  async function getGifts(anchorId = ''): Promise<readonly GiftItem[]> {
    const source = await ensureDirectoryRepository()
    const targetKey = anchorId.trim() || 'default'
    const cached = giftCatalogByTarget.get(targetKey)
    if (cached?.gifts.length && Date.now() - cached.at < 5 * 60_000) return cached.gifts
    const pending = giftCatalogPromises.get(targetKey)
    if (pending) return pending
    const ownerId = session.user?.id ?? ''
    const task = (async () => {
      const catalog = await source.getGiftCatalog(anchorId)
      if (!ownsAccount(ownerId)) return cached?.gifts ?? []
      const gifts = [...catalog.gifts]
      giftCatalogByTarget.set(targetKey, { at: Date.now(), gifts })
      if (catalog.balance !== undefined) await session.updateBalance(catalog.balance)
      return gifts
    })().finally(() => {
      if (giftCatalogPromises.get(targetKey) === task) giftCatalogPromises.delete(targetKey)
    })
    giftCatalogPromises.set(targetKey, task)
    return task
  }

  async function sendGift(imAccount: string, gift: GiftItem, count: number): Promise<void> {
    const source = await ensureDirectoryRepository()
    const result = await source.sendGift(imAccount, gift, count)
    if (!result.success) throw new Error(result.message || 'The gift could not be sent.')
    const balance = result.balance ?? (await source.refreshBalance().catch(() => undefined))
    if (balance !== undefined) await session.updateBalance(balance)
    if (gift.source === 'backpack') {
      for (const [key, catalog] of giftCatalogByTarget) {
        const gifts = catalog.gifts
          .map((item) =>
            item.id === gift.id && item.source === 'backpack'
              ? {
                  ...item,
                  quantity:
                    result.remainingQuantity ??
                    Math.max(0, (item.quantity ?? 0) - Math.max(1, count)),
                }
              : item,
          )
          .filter((item) => item.source !== 'backpack' || (item.quantity ?? 0) > 0)
        giftCatalogByTarget.set(key, { ...catalog, gifts })
      }
    }
  }

  function privateMediaCopies(privateId: number): InboxMessage[] {
    const copies: InboxMessage[] = []
    const seen = new Set<InboxMessage>()
    Object.values(messages.value)
      .flat()
      .forEach((message) => {
        if (message.privateMedia?.privateId !== privateId || seen.has(message)) return
        seen.add(message)
        copies.push(message)
      })
    conversations.value.forEach((conversation) => {
      const message = conversation.latest
      if (!message || message.privateMedia?.privateId !== privateId || seen.has(message)) return
      seen.add(message)
      copies.push(message)
    })
    return copies
  }

  function privateMediaFor(message: InboxMessage): PrivateMediaInfo | undefined {
    const privateId = message.privateMedia?.privateId
    if (!privateId) return message.privateMedia
    return privateMediaCopies(privateId)[0]?.privateMedia ?? message.privateMedia
  }

  function patchPrivateMedia(
    privateId: number,
    patch: Partial<PrivateMediaInfo> & { mediaUrl?: string },
  ): void {
    privateMediaCopies(privateId).forEach((message) => {
      if (!message.privateMedia) return
      const next = { ...message.privateMedia, ...patch }
      if (Object.hasOwn(patch, 'mediaUrl') && !patch.mediaUrl) delete next.mediaUrl
      message.privateMedia = next
    })
    scheduleInboxSnapshot()
  }

  function applyPrivateChecks(
    privateIds: readonly number[],
    rows: readonly PrivateMediaCheckResult[],
  ): void {
    const byId = new Map(rows.map((row) => [row.privateId, row]))
    privateIds.forEach((privateId) => {
      const row = byId.get(privateId)
      if (!row) {
        patchPrivateMedia(privateId, { mediaUrl: '', status: 'unavailable' })
        return
      }
      if (row.deleted) {
        patchPrivateMedia(privateId, { mediaUrl: '', status: 'expired' })
        return
      }
      if (row.locked) {
        patchPrivateMedia(privateId, { mediaUrl: '', status: 'locked' })
        return
      }
      const current = privateMediaCopies(privateId)
      const media = current[0]?.privateMedia
      const mediaUrl =
        row.mediaUrl ||
        (media?.mediaType === 'image'
          ? current.map((message) => privateImageAttachmentUrl(message.raw)).find(Boolean) || ''
          : '')
      patchPrivateMedia(privateId, {
        mediaUrl,
        status: mediaUrl ? 'unlocked' : 'verify-pending',
      })
    })
  }

  async function reconcilePrivateMedia(
    candidates: readonly InboxMessage[],
    force = false,
  ): Promise<void> {
    if (!repository) return
    const ids = [
      ...new Set(
        candidates
          .filter((message) => message.kind === 'private-media')
          .map((message) => message.privateMedia)
          .filter((item): item is PrivateMediaInfo => Boolean(item))
          .filter(
            (item) =>
              Number.isSafeInteger(item.privateId) &&
              item.privateId > 0 &&
              Number.isSafeInteger(item.recordId) &&
              item.recordId > 0 &&
              (force || !['expired', 'unavailable', 'unlocked'].includes(item.status)),
          )
          .map((item) => item.privateId),
      ),
    ]
    if (!ids.length) return
    const pending = new Set<Promise<void>>()
    const fresh = ids.filter((id) => {
      const current = privateCheckPromises.get(id)
      if (current) pending.add(current)
      return !current
    })
    if (fresh.length) {
      const activeScope = runtimeScope
      const source = repository
      const task = source
        .checkPrivateMedia(fresh)
        .then((rows) => {
          if (ownsRuntime(activeScope)) applyPrivateChecks(fresh, rows)
        })
        .catch((cause) => {
          if (ownsRuntime(activeScope))
            fresh.forEach((id) => patchPrivateMedia(id, { status: 'verify-pending' }))
          throw cause
        })
        .finally(() => {
          fresh.forEach((id) => {
            if (privateCheckPromises.get(id) === task) privateCheckPromises.delete(id)
          })
        })
      fresh.forEach((id) => privateCheckPromises.set(id, task))
      pending.add(task)
    }
    await Promise.all(pending)
  }

  async function checkPrivateMessage(message: InboxMessage): Promise<PrivateMediaInfo> {
    const privateMedia = message.privateMedia
    if (!privateMedia) throw new Error('Private media is unavailable.')
    await ensureDirectoryRepository()
    await reconcilePrivateMedia([message], true)
    return privateMediaFor(message) ?? privateMedia
  }

  function isInsufficientBalance(cause: unknown): boolean {
    const code = cause instanceof ApiClientError ? cause.code : ''
    const message = cause instanceof Error ? cause.message : String(cause ?? '')
    return code === '1080' || message.toLowerCase().includes('diamond.not.enough')
  }

  function waitForPrivateVerification(delay: number): Promise<void> {
    return new Promise((resolve) => window.setTimeout(resolve, delay))
  }

  async function verifyPrivateUnlock(message: InboxMessage, attempts = 3): Promise<boolean> {
    for (let attempt = 0; attempt < attempts; attempt += 1) {
      if (attempt) await waitForPrivateVerification(attempt === 1 ? 400 : 1_200)
      await reconcilePrivateMedia([message], true)
      const current = privateMediaFor(message)
      if (current?.status === 'unlocked' && current.mediaUrl) return true
      if (current?.status === 'expired') throw new Error('Private media has expired.')
    }
    return false
  }

  async function refreshPrivateBalance(source: MessageRepository): Promise<void> {
    const balance = await source.refreshBalance().catch(() => undefined)
    if (balance !== undefined) await session.updateBalance(balance)
  }

  async function unlockPrivateMessage(message: InboxMessage): Promise<PrivateMediaUnlockOutcome> {
    const privateId = message.privateMedia?.privateId ?? 0
    const pending = privateUnlockPromises.get(privateId)
    if (pending) return pending
    const ownerId = session.user?.id ?? ''
    const activeScope = runtimeScope
    const task = (async (): Promise<PrivateMediaUnlockOutcome> => {
      const source = await ensureDirectoryRepository()
      const current = privateMediaFor(message) ?? message.privateMedia
      const checked =
        current?.status === 'locked' || (current?.status === 'unlocked' && current.mediaUrl)
          ? current
          : await checkPrivateMessage(message)
      if (checked.status === 'unlocked' && checked.mediaUrl) return 'unlocked'
      if (checked.status !== 'locked') throw new Error('Private media is unavailable.')
      patchPrivateMedia(privateId, { mediaUrl: '', status: 'unlocking' })
      try {
        await source.unlockPrivateMedia(checked.recordId, privateId)
      } catch (cause) {
        if (isInsufficientBalance(cause)) {
          patchPrivateMedia(privateId, { mediaUrl: '', status: 'locked' })
          return 'insufficient'
        }
        const verified = await verifyPrivateUnlock(message, 1).catch(() => false)
        if (verified) {
          await refreshPrivateBalance(source)
          return 'unlocked'
        }
        if (
          cause instanceof ApiClientError &&
          ['aborted', 'network', 'server', 'timeout'].includes(cause.kind)
        ) {
          patchPrivateMedia(privateId, { mediaUrl: '', status: 'verify-pending' })
          return 'pending'
        }
        patchPrivateMedia(privateId, { mediaUrl: '', status: 'locked' })
        throw cause
      }
      const verified = await verifyPrivateUnlock(message).catch(() => false)
      if (ownsRuntime(activeScope) && ownsAccount(ownerId)) await refreshPrivateBalance(source)
      if (verified) return 'unlocked'
      patchPrivateMedia(privateId, { mediaUrl: '', status: 'verify-pending' })
      return 'pending'
    })().finally(() => {
      if (privateUnlockPromises.get(privateId) === task) privateUnlockPromises.delete(privateId)
    })
    privateUnlockPromises.set(privateId, task)
    return task
  }

  async function setFollowed(userId: string, followed: boolean): Promise<void> {
    const profile = Object.values(profiles.value).find((item) => item.userId === userId)
    const onlineHost = onlineHosts.value.find((item) => item.userId === userId)
    const target = profile ?? onlineHost
    await relationships.setFollowed(
      {
        imAccount: target?.imAccount,
        userId,
        userType: target?.userType ?? 0,
      },
      followed,
    )
    for (const profile of Object.values(profiles.value)) {
      if (profile.userId === userId) profile.followed = followed
    }
  }

  function setVisible(visible: boolean): void {
    inboxSession.setVisible(visible)
  }

  function getConversation(conversationId: string): InboxConversation | undefined {
    return conversations.value.find((item) => item.conversationId === conversationId)
  }

  function getConversationByAccount(imAccount: string): InboxConversation | undefined {
    return conversations.value.find((item) => item.imAccount === imAccount)
  }

  async function hydrateProfiles(accounts: readonly string[]): Promise<void> {
    if (!repository) return
    const unique = [...new Set(accounts.map((account) => account.trim()).filter(Boolean))]
    const pending = new Set<Promise<void>>()
    const missing: string[] = []
    unique.forEach((account) => {
      if (profiles.value[account]) return
      const existing = profileHydrationPromises.get(account)
      if (existing) pending.add(existing)
      else missing.push(account)
    })
    if (!missing.length) {
      await Promise.all(pending)
      return
    }
    const ownerId = session.user?.id ?? ''
    const activeRepository = repository
    const task = (async () => {
      const loaded = await activeRepository.batchProfiles(missing).catch(() => [])
      if (!ownsAccount(ownerId)) return
      const next = { ...profiles.value }
      loaded.forEach((profile) => (next[profile.imAccount] = profile))
      loaded.forEach((profile) =>
        relationships.seed({
          followed: profile.followed,
          imAccount: profile.imAccount,
          userId: profile.userId,
          userType: profile.userType,
        }),
      )
      profiles.value = next
    })().finally(() => {
      missing.forEach((account) => {
        if (profileHydrationPromises.get(account) === task) profileHydrationPromises.delete(account)
      })
    })
    missing.forEach((account) => profileHydrationPromises.set(account, task))
    pending.add(task)
    await Promise.all(pending)
  }

  function mergeProfilesIntoConversations(): void {
    conversations.value.forEach((conversation) => {
      const profile = profiles.value[conversation.imAccount]
      if (!profile) return
      conversation.avatarUrl = profile.avatarUrl || conversation.avatarUrl
      conversation.displayName = profile.displayName || conversation.displayName
      const realtime = effectivePresence(profile.userId)
      conversation.online = realtime ? realtime !== 'offline' : profile.online
      conversation.userId = profile.userId
    })
  }

  function applyPresence(update: PresenceUpdate): void {
    const realtime = effectivePresence(update.userId)
    if (!realtime) return
    const online = realtime !== 'offline'
    conversations.value.forEach((item) => {
      if (item.userId === update.userId) item.online = online
    })
    onlineHosts.value.forEach((item) => {
      if (item.userId !== update.userId) return
      item.online = online
      item.live = update.live ?? item.live
      item.status = realtime === 'busy' ? 'busy' : 'online'
    })
    Object.values(profiles.value).forEach((item) => {
      if (item.userId !== update.userId) return
      item.online = online
      item.live = update.live ?? item.live
    })
  }

  function applyKnownPresence(): void {
    const userIds = new Set([
      ...conversations.value.map((item) => item.userId),
      ...onlineHosts.value.map((item) => item.userId),
      ...Object.values(profiles.value).map((item) => item.userId),
    ])
    userIds.forEach((userId) => {
      const realtime = presenceSnapshot(userId)
      if (realtime) applyPresence({ ...realtime, userId })
    })
  }

  function handleGatewayEvent(event: MessageGatewayEvent): void {
    if (event.type === 'message') {
      const messageSeen = hasMessage(event.message)
      const alreadyRead = isCoveredByReadWatermark(event.message)
      const noticeEligible = !event.message.own && incomingNoticeGate.accept(event.message)
      const conversationAlreadyUpdated =
        getConversation(event.message.conversationId)?.latest?.id === event.message.id
      mergeMessage(event.message)
      if (event.message.kind === 'private-media')
        void reconcilePrivateMedia([event.message]).catch(() => undefined)
      if (!event.message.own) {
        if (activeConversationId.value === event.message.conversationId) {
          void markRead(event.message.conversationId)
        } else if (alreadyRead) {
          const conversation = getConversation(event.message.conversationId)
          if (conversation) conversation.unread = 0
          unread.value = conversations.value.reduce((sum, item) => sum + item.unread, 0)
          void gateway?.markRead(event.message.conversationId).catch(() => undefined)
          scheduleInboxSnapshot()
        } else if (!messageSeen) {
          const conversation = getConversation(event.message.conversationId)
          if (conversation && !conversationAlreadyUpdated) {
            conversation.unread += 1
            unread.value = conversations.value.reduce((sum, item) => sum + item.unread, 0)
            scheduleInboxSnapshot()
          }
          const paymentSuccess =
            presentNotificationMessage(event.message).kind === 'payment-success'
          // viewFlag=4 还承担权威余额刷新和到账提示去重，不能被普通前台横幅的
          // 可见性门禁一起吞掉。后台收到时立即完成业务处理，但不会在回前台重播。
          if (noticeEligible && (appActivity.value.visible || paymentSuccess))
            enqueueIncoming(event.message)
          incomingSequence.value += 1
        }
      }
      return
    }
    if (event.type === 'conversation') {
      mergeConversations([applyReadWatermark(event.conversation)])
      void hydrateProfiles([event.conversation.imAccount]).then(mergeProfilesIntoConversations)
      return
    }
    if (event.type === 'conversations-deleted') {
      removeConversations(event.conversationIds)
      return
    }
    if (event.type === 'sync') {
      // NIM 同步只刷新会话；消息页直播栏由 MessagesPage 激活时按需加载。
      void refresh(true, false).catch(() => undefined)
      return
    }
    // 底部角标以当前可见会话为真值，避免 SDK 总数包含不支持的系统自定义消息。
    unread.value = conversations.value.reduce((sum, item) => sum + item.unread, 0)
  }

  function enqueueIncoming(message: InboxMessage): void {
    if (incomingMessages.value.some((item) => item.id === message.id)) return
    const liveIdentity = liveStartNoticeIdentity(presentNotificationMessage(message))
    if (
      liveIdentity &&
      incomingMessages.value.some(
        (item) => liveStartNoticeIdentity(presentNotificationMessage(item)) === liveIdentity,
      )
    )
      return
    // 同一会话短时间连续来信也必须逐条消费；覆盖队列项会让提醒和未读表现丢消息。
    incomingMessages.value = [...incomingMessages.value, message].slice(-20)
  }

  function dismissIncoming(messageId?: string): void {
    if (!messageId) {
      incomingMessages.value = incomingMessages.value.slice(1)
      return
    }
    incomingMessages.value = incomingMessages.value.filter((message) => message.id !== messageId)
  }

  function hasMessage(message: InboxMessage): boolean {
    return Boolean(messages.value[message.conversationId]?.some((item) => item.id === message.id))
  }

  function mergeMessage(message: InboxMessage): void {
    const list = messages.value[message.conversationId]
    if (list) {
      const index = list.findIndex((item) => item.id === message.id)
      if (index >= 0) list[index] = message
      else {
        const optimisticIndex = message.own
          ? list.findIndex(
              (item) =>
                item.own &&
                item.delivery === 'sending' &&
                item.kind === message.kind &&
                item.text === message.text &&
                Math.abs(item.createdAt - message.createdAt) < 30_000,
            )
          : -1
        if (optimisticIndex >= 0) list[optimisticIndex] = message
        else list.push(message)
      }
    } else messages.value = { ...messages.value, [message.conversationId]: [message] }
    const conversation = getConversation(message.conversationId)
    if (conversation) {
      conversation.latest = message
      conversation.sortTime = message.createdAt
      conversations.value.sort((left, right) => right.sortTime - left.sortTime)
      scheduleInboxSnapshot()
    } else {
      scheduleUnknownConversationRefresh(message.conversationId)
    }
  }

  function scheduleUnknownConversationRefresh(conversationId: string): void {
    pendingUnknownConversationIds.add(conversationId)
    if (unknownConversationRefreshTimer) return
    const activeScope = runtimeScope
    unknownConversationRefreshTimer = window.setTimeout(() => {
      unknownConversationRefreshTimer = 0
      const activeRefresh = refreshPromise
      void (async () => {
        await activeRefresh?.catch(() => undefined)
        if (!ownsRuntime(activeScope)) return
        const missing = [...pendingUnknownConversationIds].some((id) => !getConversation(id))
        pendingUnknownConversationIds.clear()
        if (missing) await refresh(true, false)
      })().catch(() => undefined)
    }, 80)
  }

  function replaceMessage(pendingId: string, message: InboxMessage): void {
    const list = messages.value[message.conversationId]
    const index = list?.findIndex((item) => item.id === pendingId) ?? -1
    if (list && index >= 0) {
      const deliveredIndex = list.findIndex((item) => item.id === message.id)
      if (deliveredIndex >= 0 && deliveredIndex !== index) list.splice(index, 1)
      else list[index] = message
    } else mergeMessage(message)
    const conversation = getConversation(message.conversationId)
    if (conversation?.latest?.id === pendingId) conversation.latest = message
  }

  function setMessageDelivery(
    conversationId: string,
    messageId: string,
    delivery: InboxMessage['delivery'],
  ): void {
    const list = messages.value[conversationId]
    const message = list?.find((item) => item.id === messageId)
    if (message) message.delivery = delivery
  }

  function mergeConversations(values: readonly InboxConversation[]): void {
    const next = new Map(conversations.value.map((item) => [item.conversationId, item]))
    values.map(applyReadWatermark).forEach((item) => {
      pendingUnknownConversationIds.delete(item.conversationId)
      const existing = next.get(item.conversationId)
      next.set(item.conversationId, stableConversation({ ...existing, ...item }, existing))
    })
    conversations.value = [...next.values()].sort((left, right) => right.sortTime - left.sortTime)
    unread.value = conversations.value.reduce((sum, item) => sum + item.unread, 0)
    scheduleInboxSnapshot()
  }

  function stableConversation(
    source: InboxConversation,
    existing?: InboxConversation,
  ): InboxConversation {
    const sourceName = source.displayName.trim()
    const sourceHasResolvedName = Boolean(sourceName && sourceName !== source.imAccount)
    const existingName = existing?.displayName.trim() ?? ''
    return {
      ...source,
      avatarUrl: source.avatarUrl.trim() || existing?.avatarUrl || '',
      displayName:
        (sourceHasResolvedName ? sourceName : '') ||
        (existingName && existingName !== existing?.imAccount ? existingName : '') ||
        sourceName ||
        source.imAccount,
      latest: source.latest ?? existing?.latest ?? null,
      userId: source.userId.trim() || existing?.userId || '',
    }
  }

  function removeConversations(ids: readonly string[]): void {
    const removed = new Set(ids)
    conversations.value = conversations.value.filter((item) => !removed.has(item.conversationId))
    const nextMessages = { ...messages.value }
    ids.forEach((id) => {
      delete nextMessages[id]
      delete readWatermarks[id]
    })
    messages.value = nextMessages
    unread.value = conversations.value.reduce((sum, item) => sum + item.unread, 0)
    scheduleInboxSnapshot()
  }

  async function restoreInboxSnapshot(accountId: string): Promise<void> {
    if (!accountId || !session.authenticated || session.user?.id !== accountId) return
    const stored = await loadInboxSnapshot(accountId)
    if (!stored || !session.authenticated || session.user?.id !== accountId) return
    conversations.value = stored.conversations
    readWatermarks = stored.readWatermarks
    unread.value = conversations.value.reduce(
      (sum, item) => sum + Math.max(0, Number(item.unread) || 0),
      0,
    )
  }

  function scheduleInboxSnapshot(): void {
    window.clearTimeout(snapshotTimer)
    snapshotTimer = window.setTimeout(() => void persistInboxSnapshot(), 280)
  }

  async function persistInboxSnapshot(): Promise<void> {
    const accountId = session.user?.id
    if (!accountId || !session.authenticated) return
    await saveInboxSnapshot(accountId, { conversations: conversations.value, readWatermarks })
    if (session.user?.id !== accountId || !session.authenticated)
      await deleteInboxSnapshot(accountId)
  }

  function isCoveredByReadWatermark(message: InboxMessage): boolean {
    return !message.own && message.createdAt <= (readWatermarks[message.conversationId] ?? 0)
  }

  function applyReadWatermark(conversation: InboxConversation): InboxConversation {
    const watermark = readWatermarks[conversation.conversationId] ?? 0
    if (!watermark || (conversation.latest?.createdAt ?? conversation.sortTime) > watermark)
      return conversation
    return conversation.unread ? { ...conversation, unread: 0 } : conversation
  }

  return {
    activeConversationId,
    conversationFinished,
    conversations,
    deleteAllConversations,
    deleteConversation,
    enterConversation,
    error,
    checkPrivateMessage,
    getConversation,
    getConversationByAccount,
    getCustomerAgents,
    getCustomerProblems,
    getGifts,
    getRelations,
    incomingSequence,
    incomingMessages,
    identitiesReady,
    latestIncoming,
    loadConversation,
    loadEarlier,
    leaveConversation,
    loadMoreConversations,
    markAllRead,
    markRead,
    messageFinished,
    messages,
    notificationConversation,
    onlineHosts,
    profileFor,
    rechargeConversation,
    profiles,
    refresh,
    refreshOnlineHosts,
    regularConversations,
    regularUnread,
    dismissIncoming,
    retryText,
    resume,
    sendGift,
    sendImage,
    sendText,
    setFollowed,
    setVisible,
    start,
    status,
    stop,
    unread,
    unlockPrivateMessage,
    conversationIdFor,
  }
})

if (import.meta.hot) import.meta.hot.accept(acceptHMRUpdate(useMessagesStore, import.meta.hot))

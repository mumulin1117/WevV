<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import {
  deleteAccountDraft,
  readAccountDraft,
  writeAccountDraft,
} from '@/features/drafts/draft-actions'
import { accountPreferences } from '@/core/storage/account-preferences'
import MessageBubble from '@/features/messages/components/MessageBubble.vue'
import MessageComposer from '@/features/messages/components/MessageComposer.vue'
import type { ConversationTarget, GiftItem, InboxMessage } from '@/features/messages/contracts'
import { formatMessageTime } from '@/features/messages/presentation'
import { openNativeRecharge } from '@/core/bridge/room-native-bridge'
import { getRoomEntry } from '@/core/entry/room-entry'
import { createConversationProfile } from '@/features/rooms/anchor-profile-snapshot'
import type { AnchorProfile } from '@/features/rooms/contracts'
import { anchorProfileQueries } from '@/features/rooms/live-operations'
import { clearGiftEffects, enqueueGiftEffect } from '@/shared/gifts/gift-effect-queue'
import type { GiftPanelRechargeRequest } from '@/shared/gifts/contracts'
import { isGiftBalanceError, useGiftSendFlow } from '@/shared/gifts/useGiftSendFlow'
import { useKeyboardViewport } from '@/main/composables/useKeyboardViewport'
import { ensureMessagingReady } from '@/main/startup/room-message-runtime'
import { useMessagesStore } from '@/main/stores/messages'
import { useRelationshipsStore } from '@/main/stores/relationships'
import { useSessionStore } from '@/main/stores/session'
import { closeConfirmDialog } from '@/main/ui/confirm-dialog-state'
import { useAppFeedback } from '@/main/ui/feedback'
import { useAppOverlay } from '@/main/ui/overlay'
import AppGiftPanel from './AppGiftPanel.vue'
import AppAvatar from './AppAvatar.vue'
import AppIcon from './AppIcon.vue'
import AppLoading from './AppLoading.vue'
import AppReverseList from './AppReverseList.vue'

interface ReverseListApi {
  isNearBottom: () => boolean
  scrollToBottom: (force?: boolean, behavior?: ScrollBehavior) => Promise<void>
}

const props = defineProps<{
  target: ConversationTarget
  variant: 'live' | 'party'
}>()
const emit = defineEmits<{
  back: []
  keyboardChange: [value: { bottom: number; height: number }]
}>()

const messagesStore = useMessagesStore()
const relationships = useRelationshipsStore()
const session = useSessionStore()
const feedback = useAppFeedback()
const overlay = useAppOverlay()
const keyboard = useKeyboardViewport()
const { locale, t } = useI18n()
const conversationId = ref(props.target.conversationId)
const profile = ref<AnchorProfile | null>(null)
const historyLoading = ref(true)
const historyFailed = ref(false)
const loadingEarlier = ref(false)
const input = ref('')
const sending = ref(false)
const reverseList = ref<ReverseListApi | null>(null)
const unreadAtBottom = ref(0)
const giftVisible = ref(false)
const giftLoading = ref(false)
const giftFailed = ref(false)
const gifts = ref<readonly GiftItem[]>([])
const { pending: giftPending, run: runGiftSend } = useGiftSendFlow()
let draftTimer = 0
let loadGeneration = 0
let profileController: AbortController | undefined
let enteredConversationId = ''
let giftCloseTimer = 0
let giftSendSequence = 0
let resolveGiftClose: (() => void) | undefined
let messageEffectsReady = false
const composerScrollTimers = new Set<number>()

const conversation = computed(
  () =>
    messagesStore.getConversation(conversationId.value) ||
    messagesStore.getConversation(props.target.conversationId),
)
const chatMessages = computed(() => messagesStore.messages[conversationId.value] ?? [])
const imAccount = computed(
  () => conversation.value?.imAccount || profile.value?.imAccount || props.target.imAccount,
)
const userId = computed(
  () => conversation.value?.userId || profile.value?.id || props.target.userId,
)
const displayName = computed(
  () =>
    profile.value?.name ||
    conversation.value?.displayName ||
    props.target.displayName ||
    imAccount.value ||
    t('messages.title'),
)
const avatarUrl = computed(
  () => profile.value?.avatarUrl || conversation.value?.avatarUrl || props.target.avatarUrl,
)
const imageList = computed(() =>
  chatMessages.value.map((item) => item.attachmentUrl ?? '').filter(Boolean),
)
const headerMeta = computed(() => {
  if (!profile.value) return ''
  return [profile.value.age || '', countryLabel(profile.value.countryCode)]
    .filter(Boolean)
    .join(' | ')
})
const initialLoading = computed(() => historyLoading.value && !chatMessages.value.length)
const isRtl = computed(() => locale.value === 'ar')
const giftRechargeCovered = false

const PRIVATE_CONFIRM_PREFERENCE = 'messages:private-unlock-confirm-skipped'

function countryLabel(countryId: string): string {
  const code = countryId.trim().toUpperCase()
  if (!/^[A-Z]{2}$/u.test(code)) return code
  return String.fromCodePoint(...[...code].map((letter) => 127397 + letter.charCodeAt(0)))
}

function beginsMessageTimeGroup(index: number): boolean {
  if (index === 0) return false
  const current = chatMessages.value[index]
  const previous = chatMessages.value[index - 1]
  if (!current || !previous) return false
  return current.createdAt - previous.createdAt > 5 * 60 * 1_000
}

function giftEffectOwner(): string {
  return `room-conversation:${props.variant}:${props.target.conversationId}`
}

function requestNativeRecharge(requiredDiamonds: number): void {
  const entry = getRoomEntry()
  openNativeRecharge({
    requiredDiamonds: Math.max(0, Math.floor(requiredDiamonds)),
    roomId: entry.roomId,
    roomType: entry.roomType,
    source: entry.roomType === 'voice' ? 'party' : 'live',
  })
}

function draftName(): string {
  return `conversation-draft:${conversationId.value}`
}

function preloadGifts(targetUserId: string, generation: number): void {
  const target = targetUserId.trim()
  if (!target) return
  void messagesStore
    .getGifts(target)
    .then((items) => {
      if (generation === loadGeneration && userId.value === target) gifts.value = items
    })
    .catch(() => {
      // 礼物目录是房内私信增强数据，预热失败后仍由礼物弹层提供显式重试。
    })
}

async function load(): Promise<void> {
  const generation = ++loadGeneration
  const routeKey = props.target.conversationId
  if (!routeKey) return
  messageEffectsReady = false
  historyLoading.value = !(messagesStore.messages[routeKey] ?? []).length
  historyFailed.value = false
  profileController?.abort()
  const controller = new AbortController()
  profileController = controller
  try {
    await ensureMessagingReady({
      allowSnapshot: true,
      reason: `room-${props.variant}-conversation`,
    })
    if (generation !== loadGeneration) return
    const known =
      messagesStore.getConversation(routeKey) ||
      messagesStore.getConversationByAccount(props.target.imAccount)
    const activeId =
      known?.conversationId ||
      (props.target.imAccount
        ? await messagesStore.conversationIdFor(props.target.imAccount)
        : routeKey)
    if (generation !== loadGeneration) return
    conversationId.value = activeId
    enteredConversationId = activeId
    messagesStore.enterConversation(activeId)
    preloadGifts(known?.userId || props.target.userId, generation)
    void messagesStore.markRead(activeId)
    historyLoading.value = !(messagesStore.messages[activeId] ?? []).length
    const historyTask = messagesStore.loadConversation(activeId).catch((cause) => {
      if (generation !== loadGeneration) return
      historyFailed.value = true
      feedback.error(cause)
    })
    const draftTask = restoreDraft().catch(() => undefined)
    void loadProfile(known, controller, generation)
    await Promise.all([historyTask, draftTask])
  } catch (cause) {
    if (generation === loadGeneration) {
      historyFailed.value = true
      feedback.error(cause)
    }
  } finally {
    if (generation === loadGeneration) {
      historyLoading.value = false
      await nextTick()
      await reverseList.value?.scrollToBottom(true)
      messageEffectsReady = true
    }
  }
}

async function loadProfile(
  known: ReturnType<typeof messagesStore.getConversation>,
  controller: AbortController,
  generation: number,
): Promise<void> {
  try {
    let resolvedUserId = known?.userId || props.target.userId
    const resolvedAccount = known?.imAccount || props.target.imAccount
    if (!resolvedUserId && resolvedAccount) {
      const summary = await messagesStore.profileFor(resolvedAccount)
      resolvedUserId = summary?.userId ?? ''
      if (summary && resolvedUserId && generation === loadGeneration) {
        profile.value = createConversationProfile({
          avatarUrl: summary.avatarUrl,
          displayName: summary.displayName || props.target.displayName || resolvedAccount,
          followed: summary.followed,
          imAccount: summary.imAccount || resolvedAccount,
          online: summary.online,
          signature: summary.signature,
          userId: resolvedUserId,
          userType: summary.userType,
        })
      }
    }
    if (!resolvedUserId || generation !== loadGeneration) return
    preloadGifts(resolvedUserId, generation)
    if (!profile.value) {
      profile.value = createConversationProfile({
        avatarUrl: known?.avatarUrl || props.target.avatarUrl,
        displayName: known?.displayName || props.target.displayName,
        imAccount: resolvedAccount,
        online: known?.online,
        userId: resolvedUserId,
        userType: 0,
      })
    }
    const loaded = await anchorProfileQueries.getProfile(
      resolvedUserId,
      resolvedAccount,
      controller.signal,
    )
    if (generation !== loadGeneration) return
    relationships.seed({
      blocked: loaded.blocked,
      followed: loaded.followed,
      imAccount: loaded.imAccount,
      userId: loaded.id,
      userType: loaded.userType,
    })
    const state = relationships.relationship(loaded.id)
    profile.value = { ...loaded, blocked: state.blocked, followed: state.followed }
  } catch {
    // 资料增强失败不阻塞 NIM 历史与消息发送。
  }
}

async function restoreDraft(): Promise<void> {
  const accountId = session.user?.id ?? 'anonymous'
  input.value = await readAccountDraft(accountId, draftName())
}

async function persistDraft(): Promise<void> {
  const accountId = session.user?.id
  const id = conversationId.value
  if (!id || !accountId || !session.authenticated) return
  if (!input.value) await deleteAccountDraft(accountId, draftName())
  else await writeAccountDraft(accountId, draftName(), input.value)
  if (session.user?.id !== accountId || !session.authenticated)
    await deleteAccountDraft(accountId, draftName())
}

async function sendText(value: string): Promise<void> {
  if (sending.value || !conversationId.value) return
  sending.value = true
  try {
    await messagesStore.sendText(conversationId.value, value)
    if (input.value.trim() === value) input.value = ''
    await persistDraft()
    await reverseList.value?.scrollToBottom(true, 'smooth')
  } catch (cause) {
    feedback.error(cause)
  } finally {
    sending.value = false
  }
}

async function loadEarlier(): Promise<void> {
  if (loadingEarlier.value) return
  loadingEarlier.value = true
  try {
    await messagesStore.loadEarlier(conversationId.value)
  } catch (cause) {
    feedback.error(cause)
  } finally {
    loadingEarlier.value = false
  }
}

async function retryMessage(message: InboxMessage): Promise<void> {
  if (message.kind !== 'text') {
    feedback.warning(t('messages.imageAgain'))
    return
  }
  const close = feedback.loading()
  try {
    await messagesStore.retryText(message)
  } catch (cause) {
    feedback.error(cause)
  } finally {
    close()
  }
}

function previewPrivateMessage(message: InboxMessage): void {
  const media = message.privateMedia
  if (!media?.mediaUrl) {
    feedback.warning(t('messages.privateUnavailable'))
    return
  }
  void overlay.previewMedia({
    items: [
      {
        ...(media.mediaType === 'video' && media.coverUrl ? { poster: media.coverUrl } : {}),
        type: media.mediaType,
        url: media.mediaUrl,
      },
    ],
  })
}

async function unlockPrivateMessage(message: InboxMessage): Promise<void> {
  const close = feedback.loading()
  try {
    const outcome = await messagesStore.unlockPrivateMessage(message)
    if (outcome === 'insufficient') {
      requestNativeRecharge(message.privateMedia?.price ?? 0)
      return
    }
    if (outcome === 'pending') {
      feedback.warning(t('messages.privateSyncing'))
      return
    }
    previewPrivateMessage(message)
  } catch (cause) {
    feedback.error(cause)
  } finally {
    close()
  }
}

async function activatePrivateMessage(message: InboxMessage): Promise<void> {
  if (!message.privateMedia) return
  const close = feedback.loading()
  try {
    const media = await messagesStore.checkPrivateMessage(message)
    if (media.status === 'unlocked' && media.mediaUrl) {
      previewPrivateMessage(message)
      return
    }
    if (media.status === 'expired') {
      feedback.warning(t('messages.privateExpired'))
      return
    }
    if (media.status !== 'locked') {
      feedback.warning(
        t(
          media.status === 'verify-pending'
            ? 'messages.privateSyncing'
            : 'messages.privateUnavailable',
        ),
      )
      return
    }
    const accountId = session.user?.id ?? ''
    if (accountPreferences.get(accountId, PRIVATE_CONFIRM_PREFERENCE) === '1') {
      void unlockPrivateMessage(message)
      return
    }
    close()
    const result = await overlay.confirmWithOption({
      cancelButtonText: t('common.cancel'),
      checkboxLabel: t('messages.privateDontRemind'),
      confirmButtonText: t('messages.privateUnlock'),
      message: t('messages.privateUnlockDescription', {
        price: media.price,
        type: t(media.mediaType === 'video' ? 'messages.privateVideo' : 'messages.privateImage'),
      }),
      title: t('messages.reminder'),
    })
    if (!result.confirmed) return
    if (result.checked) accountPreferences.set(accountId, PRIVATE_CONFIRM_PREFERENCE, '1')
    void unlockPrivateMessage(message)
  } catch (cause) {
    feedback.error(cause)
  } finally {
    close()
  }
}

async function openGifts(): Promise<void> {
  giftVisible.value = true
  if (gifts.value.length || giftLoading.value) return
  giftLoading.value = true
  giftFailed.value = false
  try {
    gifts.value = await messagesStore.getGifts(userId.value)
  } catch (cause) {
    giftFailed.value = true
    feedback.error(cause)
  } finally {
    giftLoading.value = false
  }
}

async function sendGift(gift: GiftItem, count: number): Promise<void> {
  if (!imAccount.value) return
  const outcome = await runGiftSend(async () => {
    await messagesStore.sendGift(imAccount.value, gift, count)
    await closeGiftAfterSend()
    return { count, gift }
  })
  if (outcome.status === 'failed') {
    if (isGiftBalanceError(outcome.cause))
      requestRecharge({ requiredDiamonds: gift.price * count, selection: null })
    else feedback.error(outcome.cause)
    return
  }
  if (outcome.status !== 'sent') return
  gifts.value = []
  const played = enqueueGiftEffect({
    dedupeKey: `room-conversation:self:${conversationId.value}:${++giftSendSequence}`,
    fallbackUrl: gift.iconUrl,
    owner: giftEffectOwner(),
    url: gift.animationUrl,
  })
  if (!played) feedback.success(t('messages.giftSent', { name: gift.name }))
  void messagesStore.loadConversation(conversationId.value)
}

function closeGiftAfterSend(): Promise<void> {
  return new Promise((resolve) => {
    window.clearTimeout(giftCloseTimer)
    resolveGiftClose?.()
    resolveGiftClose = resolve
    giftVisible.value = false
    giftCloseTimer = window.setTimeout(finishGiftCloseWait, 600)
  })
}

function finishGiftCloseWait(): void {
  window.clearTimeout(giftCloseTimer)
  giftCloseTimer = 0
  const resolve = resolveGiftClose
  resolveGiftClose = undefined
  resolve?.()
}

function requestRecharge(request: GiftPanelRechargeRequest): void {
  requestNativeRecharge(request.requiredDiamonds)
}

function handleNewMessage(value?: InboxMessage, previous?: InboxMessage): void {
  if (!value || value.id === previous?.id) return
  if (messageEffectsReady && !value.own && value.kind === 'gift' && value.gift)
    enqueueGiftEffect({
      dedupeKey: `room-conversation:${conversationId.value}:${value.id}`,
      fallbackUrl: value.gift.iconUrl,
      owner: giftEffectOwner(),
      url: value.gift.animationUrl,
    })
  if (!value.own && reverseList.value && !reverseList.value.isNearBottom())
    unreadAtBottom.value += 1
}

async function scrollToLatest(): Promise<void> {
  unreadAtBottom.value = 0
  await reverseList.value?.scrollToBottom(true, 'smooth')
}

function keyboardPosition(): { bottom: number; height: number } {
  const visualBottom = keyboard.offsetTop.value + keyboard.height.value
  return {
    bottom: Math.max(0, window.innerHeight - visualBottom),
    height: Math.max(240, keyboard.height.value - keyboard.offsetTop.value),
  }
}

function handleComposerFocus(): void {
  keyboard.focus()
  emit('keyboardChange', keyboardPosition())
  composerScrollTimers.forEach((timer) => window.clearTimeout(timer))
  composerScrollTimers.clear()
  void reverseList.value?.scrollToBottom()
  for (const delay of [80, 180, 320]) {
    const timer = window.setTimeout(() => {
      composerScrollTimers.delete(timer)
      emit('keyboardChange', keyboardPosition())
      void reverseList.value?.scrollToBottom()
    }, delay)
    composerScrollTimers.add(timer)
  }
}

function handleComposerBlur(): void {
  keyboard.blur()
  composerScrollTimers.forEach((timer) => window.clearTimeout(timer))
  composerScrollTimers.clear()
  emit('keyboardChange', { bottom: 0, height: window.innerHeight })
}

function handleBack(): void {
  handleComposerBlur()
  emit('back')
}

watch(() => chatMessages.value.at(-1), handleNewMessage)
watch(input, () => {
  window.clearTimeout(draftTimer)
  draftTimer = window.setTimeout(() => void persistDraft(), 320)
})
onMounted(load)
onBeforeUnmount(() => {
  loadGeneration += 1
  profileController?.abort()
  keyboard.blur()
  window.clearTimeout(draftTimer)
  composerScrollTimers.forEach((timer) => window.clearTimeout(timer))
  composerScrollTimers.clear()
  clearGiftEffects(giftEffectOwner())
  closeConfirmDialog(false)
  finishGiftCloseWait()
  emit('keyboardChange', { bottom: 0, height: window.innerHeight })
  if (session.authenticated) void persistDraft()
  if (enteredConversationId) void messagesStore.leaveConversation(enteredConversationId)
  enteredConversationId = ''
})
</script>

<template>
  <section class="room-conversation-sheet">
    <header class="room-conversation-sheet__header">
      <button type="button" :aria-label="t('common.back')" @click="handleBack">
        <AppIcon name="back" :size="22" :class="{ 'is-rtl': isRtl }" />
      </button>
      <div class="room-conversation-sheet__identity">
        <span>
          <i v-if="conversation?.online" aria-hidden="true" />
          <strong>{{ displayName }}</strong>
        </span>
        <small v-if="headerMeta">{{ headerMeta }}</small>
      </div>
      <span class="room-conversation-sheet__spacer" aria-hidden="true" />
    </header>

    <div class="room-conversation-sheet__body">
      <div v-if="initialLoading" class="room-conversation-sheet__loading"><AppLoading /></div>
      <div v-else class="room-conversation-sheet__messages">
        <AppReverseList
          ref="reverseList"
          :earlier-label="t('common.earlierMessages')"
          :items="chatMessages"
          :loading="loadingEarlier"
          :more="!messagesStore.messageFinished[conversationId]"
          @load-earlier="loadEarlier"
        >
          <template #before>
            <div v-if="historyFailed" class="room-conversation-sheet__error">
              <span>{{ t('list.loadFailed') }}</span>
              <button type="button" @click="load">{{ t('common.retry') }}</button>
            </div>
          </template>
          <template #default="{ item, index }">
            <time v-if="beginsMessageTimeGroup(index)" class="message-time">
              {{ formatMessageTime(item.createdAt) }}
            </time>
            <div class="room-conversation-message" :class="{ 'is-own': item.own }">
              <AppAvatar
                :alt="item.own ? session.user?.displayName || '' : displayName"
                :size="46"
                :src="item.own ? session.user?.avatar || '' : avatarUrl"
              />
              <MessageBubble
                :image-list="imageList"
                :message="item"
                @private-activate="activatePrivateMessage(item)"
                @retry="retryMessage(item)"
              />
            </div>
          </template>
        </AppReverseList>
        <button
          v-if="unreadAtBottom"
          class="room-conversation-sheet__new"
          type="button"
          @click="scrollToLatest"
        >
          {{
            t(unreadAtBottom === 1 ? 'messages.newMessage' : 'messages.newMessages', {
              count: unreadAtBottom,
            })
          }}
        </button>
      </div>

      <MessageComposer
        v-model="input"
        class="room-conversation-sheet__composer"
        :disabled="!conversationId"
        :show-image="false"
        @blur="handleComposerBlur"
        @focus="handleComposerFocus"
        @gift="openGifts"
        @send="sendText"
      />
    </div>

    <AppGiftPanel
      v-model:show="giftVisible"
      :avatar-url="avatarUrl"
      :balance="session.balance"
      :failed="giftFailed"
      :gifts="gifts"
      :loading="giftLoading"
      :name="displayName"
      :pending="giftPending"
      :suspended="giftRechargeCovered"
      @closed="finishGiftCloseWait"
      @recharge="requestRecharge"
      @retry="openGifts"
      @send="sendGift"
    />
  </section>
</template>

<style scoped lang="less">
.room-conversation-sheet {
  display: grid;
  height: 100%;
  min-height: 0;
  grid-template-rows: 64px minmax(0, 1fr);
  overflow: hidden;
  background: var(--panel-bg);
  color: var(--color-on-dark);
}

.room-conversation-sheet__header {
  display: grid;
  min-width: 0;
  grid-template-columns: 52px minmax(0, 1fr) 52px;
  align-items: center;
  box-sizing: border-box;
  padding-top: 20px;
}

.room-conversation-sheet__header > button {
  display: grid;
  width: 52px;
  height: 44px;
  padding: 0;
  place-items: center;
  border: 0;
  background: transparent;
  color: var(--color-on-dark);
}

.room-conversation-sheet__header :deep(.is-rtl) {
  transform: scaleX(-1);
}

.room-conversation-sheet__identity {
  display: grid;
  min-width: 0;
  overflow: hidden;
  justify-items: center;
  gap: 3px;
}

.room-conversation-sheet__identity > span {
  display: flex;
  width: 100%;
  min-width: 0;
  max-width: 100%;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.room-conversation-sheet__identity i {
  width: 7px;
  height: 7px;
  flex: 0 0 7px;
  margin-inline-end: 4px;
  border-radius: 50%;
  background: var(--color-success);
}

.room-conversation-sheet__identity strong {
  display: block;
  min-width: 0;
  max-width: 240px;
  flex: 0 1 auto;
  overflow: hidden;
  font-size: 15px;
  font-weight: 800;
  line-height: 18px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.room-conversation-sheet__identity small {
  display: block;
  width: 100%;
  min-width: 0;
  max-width: 240px;
  overflow: hidden;
  color: var(--color-on-dark-muted);
  font-size: 12px;
  line-height: 16px;
  text-overflow: ellipsis;
  text-align: center;
  white-space: nowrap;
}

.room-conversation-sheet__spacer {
  width: 52px;
}

.room-conversation-sheet__body {
  display: grid;
  min-height: 0;
  grid-template-rows: minmax(0, 1fr) auto;
  overflow: hidden;
}

.room-conversation-sheet__messages {
  position: relative;
  min-height: 0;
  overflow: hidden;
}

.room-conversation-sheet__messages :deep(.reverse-list__items) {
  min-height: calc(100% - 36px);
  padding: 8px 15px 4px;
}

.room-conversation-message {
  display: flex;
  width: 100%;
  min-width: 0;
  align-items: flex-end;
  gap: 8px;
  margin-top: 22px;
}

.room-conversation-message.is-own {
  flex-direction: row-reverse;
}

.room-conversation-message :deep(.msg-row) {
  max-width: calc(100% - 54px);
  align-self: auto;
  margin: 0;
}

.room-conversation-message :deep(.msg > p) {
  max-width: 210px;
  background: var(--color-message-recharge-bubble);
  color: var(--color-message-recharge-text);
  font-size: 15px;
  line-height: 19px;
}

.room-conversation-message :deep(.msg-row--image .app-image) {
  width: 100px;
  max-height: 240px;
}

.room-conversation-sheet__loading {
  display: grid;
  min-height: 0;
  place-items: center;
}

.room-conversation-sheet__error {
  display: flex;
  min-height: 40px;
  align-items: center;
  justify-content: center;
  gap: 8px;
  color: var(--color-on-dark-muted);
  font-size: 12px;
}

.room-conversation-sheet__error button,
.room-conversation-sheet__new {
  min-height: 30px;
  padding: 0 12px;
  border: 0;
  border-radius: 16px;
  background: var(--color-message-sheet-action);
  color: var(--color-on-dark);
  font-size: 11px;
}

.room-conversation-sheet__new {
  position: absolute;
  right: 14px;
  bottom: 8px;
  z-index: 2;
}

.message-time {
  display: block;
  margin: 9px 0 -13px;
  color: var(--color-on-dark-subtle);
  font-size: 12px;
  text-align: center;
}

.room-conversation-sheet__composer {
  flex: 0 0 auto;
  padding: 10px 15px 0;
  background: var(--panel-bg);
}
</style>

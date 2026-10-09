<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import type { ConversationTarget, InboxConversation } from '@/features/messages/contracts'
import { formatMessageTime } from '@/features/messages/presentation'
import { publicAsset } from '@/core/media/public-asset'
import { ensureMessagingReady } from '@/main/startup/room-message-runtime'
import { useMessagesStore } from '@/main/stores/messages'
import { useAppFeedback } from '@/main/ui/feedback'
import AppAvatar from './AppAvatar.vue'
import AppEmptyState from './AppEmptyState.vue'
import AppLoading from './AppLoading.vue'
import AppPopup from './AppPopup.vue'
import RoomConversationSheet from './RoomConversationSheet.vue'

const props = withDefaults(
  defineProps<{
    conversationTarget?: ConversationTarget | null
    modelValue: boolean
    variant: 'live' | 'party'
  }>(),
  { conversationTarget: null },
)
const emit = defineEmits<{
  'update:conversationTarget': [value: ConversationTarget | null]
  'update:modelValue': [value: boolean]
}>()
const messages = useMessagesStore()
const feedback = useAppFeedback()
const { t } = useI18n()
const selected = computed({
  get: () => props.conversationTarget,
  set: (value) => emit('update:conversationTarget', value),
})
const loadingMore = ref(false)
const failed = ref(false)
const conversationOpener = ref<HTMLElement | null>(null)
const conversationBottom = ref(0)
const conversationViewportHeight = ref(typeof window === 'undefined' ? 408 : window.innerHeight)
const visible = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value),
})
const initialLoading = computed(
  () =>
    !messages.regularConversations.length &&
    (messages.status === 'idle' || messages.status === 'loading'),
)

async function ensureLoaded(): Promise<void> {
  failed.value = false
  try {
    await ensureMessagingReady({ allowSnapshot: true, reason: `room-${props.variant}-messages` })
  } catch {
    if (!messages.regularConversations.length) failed.value = true
  }
}

function targetOf(conversation: InboxConversation): ConversationTarget {
  return {
    avatarUrl: conversation.avatarUrl,
    conversationId: conversation.conversationId,
    displayName: conversation.displayName,
    imAccount: conversation.imAccount,
    userId: conversation.userId,
  }
}

function openConversation(event: MouseEvent, conversation: InboxConversation): void {
  conversationOpener.value = event.currentTarget as HTMLElement
  if (document.activeElement instanceof HTMLElement) document.activeElement.blur()
  selected.value = targetOf(conversation)
  void messages.markRead(conversation.conversationId)
}

async function removeConversation(conversation: InboxConversation): Promise<void> {
  try {
    await messages.deleteConversation(conversation.conversationId)
  } catch (cause) {
    feedback.error(cause)
  }
}

async function loadMore(): Promise<void> {
  if (loadingMore.value || messages.conversationFinished) return
  loadingMore.value = true
  try {
    await messages.loadMoreConversations()
  } catch (cause) {
    feedback.error(cause)
  } finally {
    loadingMore.value = false
  }
}

function handleScroll(event: Event): void {
  const node = event.currentTarget as HTMLElement
  if (node.scrollHeight - node.scrollTop - node.clientHeight <= 80) void loadMore()
}

function updateConversationVisible(open: boolean): void {
  if (open) return
  if (document.activeElement instanceof HTMLElement) document.activeElement.blur()
  selected.value = null
  conversationBottom.value = 0
  conversationViewportHeight.value = window.innerHeight
  void nextTick(() => conversationOpener.value?.focus({ preventScroll: true }))
}

function updateConversationKeyboard(value: { bottom: number; height: number }): void {
  conversationBottom.value = value.bottom
  conversationViewportHeight.value = value.height
}

watch(
  () => props.modelValue,
  (open) => {
    if (open) void ensureLoaded()
    else {
      if (document.activeElement instanceof HTMLElement) document.activeElement.blur()
      if (!selected.value) conversationOpener.value = null
    }
  },
)
onBeforeUnmount(() => {
  if (document.activeElement instanceof HTMLElement) document.activeElement.blur()
})
</script>

<template>
  <AppPopup
    v-model="visible"
    class="room-message-popup"
    :closeable="false"
    flush
    panel-height="408px"
    panel-max-height="408px"
    :expand-for-bottom-inset="false"
    :surface-radius="16"
    :suspended="Boolean(selected)"
  >
    <section class="room-message-stack" :class="`is-${variant}`">
      <header class="room-message-stack__header">
        <strong>{{ t('messages.title') }}</strong>
      </header>

      <div class="room-message-stack__list" data-room-scroll @scroll.passive="handleScroll">
        <div v-if="initialLoading" class="room-message-stack__state"><AppLoading /></div>
        <AppEmptyState
          v-else-if="failed"
          :action="t('common.retry')"
          :description="t('list.loadFailed')"
          size="popup"
          variant="feedback"
          @action="ensureLoaded"
        />
        <template v-else-if="messages.regularConversations.length">
          <VanSwipeCell
            v-for="conversation in messages.regularConversations"
            :key="conversation.conversationId"
            class="room-message-row"
            :stop-propagation="true"
          >
            <button
              class="room-message-row__button"
              type="button"
              @click="openConversation($event, conversation)"
            >
              <AppAvatar
                :alt="conversation.displayName"
                :online="conversation.online"
                :size="44"
                :src="conversation.avatarUrl"
              />
              <span class="room-message-row__copy">
                <strong>{{ conversation.displayName }}</strong>
                <small>{{ conversation.latest?.text || t('messages.startConversation') }}</small>
              </span>
              <span class="room-message-row__meta">
                <time>{{ formatMessageTime(conversation.sortTime) }}</time>
                <i v-if="conversation.unread">{{
                  conversation.unread > 99 ? '99+' : conversation.unread
                }}</i>
              </span>
            </button>
            <template #right>
              <button
                class="room-message-row__delete"
                type="button"
                :aria-label="t('messages.delete')"
                @click="removeConversation(conversation)"
              >
                <img :src="publicAsset('messages/message_delete_icon.png')" alt="" />
              </button>
            </template>
          </VanSwipeCell>
          <button
            v-if="!messages.conversationFinished"
            class="room-message-stack__more"
            :disabled="loadingMore"
            type="button"
            @click="loadMore"
          >
            <span>{{ t(loadingMore ? 'common.loading' : 'common.more') }}</span>
          </button>
        </template>
        <AppEmptyState v-else :description="t('messages.empty')" size="popup" />
      </div>
    </section>
  </AppPopup>

  <AppPopup
    :model-value="Boolean(selected)"
    class="room-message-popup room-message-popup--conversation"
    :closeable="false"
    flush
    panel-height="408px"
    panel-max-height="408px"
    :available-height="`${conversationViewportHeight}px`"
    :bottom-offset="conversationBottom"
    :expand-for-bottom-inset="false"
    :surface-radius="16"
    @update:model-value="updateConversationVisible"
  >
    <section v-if="selected" class="room-message-conversation">
      <RoomConversationSheet
        :key="selected.conversationId"
        :target="selected"
        :variant="variant"
        @back="updateConversationVisible(false)"
        @keyboard-change="updateConversationKeyboard"
      />
    </section>
  </AppPopup>
</template>

<style scoped lang="less">
:deep(.room-message-popup.app-popup-host),
:deep(.room-message-popup .app-popup) {
  background: var(--panel-bg) !important;
}

.room-message-stack {
  position: relative;
  display: flex;
  height: 100%;
  min-height: 0;
  flex-direction: column;
  overflow: hidden;
  background: var(--panel-bg);
  color: var(--color-on-dark);
}

.room-message-conversation {
  position: relative;
  height: 100%;
  min-height: 0;
  overflow: hidden;
  background: var(--panel-bg);
}

.room-message-stack__header {
  display: flex;
  min-height: 58px;
  flex: 0 0 58px;
  align-items: center;
  justify-content: center;
}

.room-message-stack__header strong {
  font-size: 18px;
  font-weight: 800;
}

.room-message-stack__list {
  min-height: 0;
  flex: 1;
  overflow: hidden auto;
  overscroll-behavior: contain;
  scrollbar-width: none;
  -webkit-overflow-scrolling: touch;
}

.room-message-stack__list::-webkit-scrollbar {
  display: none;
}

.room-message-stack__state {
  display: grid;
  width: 100%;
  min-height: 280px;
  place-items: center;
  border: 0;
  background: transparent;
  color: var(--color-on-dark-muted);
}

.room-message-row {
  display: block;
  background: transparent;
}

.room-message-row__button {
  display: grid;
  width: 100%;
  min-height: 60px;
  grid-template-columns: 44px minmax(0, 1fr) auto;
  align-items: center;
  gap: 10px;
  padding: 0 15px;
  border: 0;
  background: transparent;
  color: var(--color-on-dark);
  text-align: start;
}

.room-message-row__button:active {
  background: var(--color-message-row-active);
}

.room-message-row__copy,
.room-message-row__meta {
  display: grid;
  min-width: 0;
}

.room-message-row__copy {
  gap: 5px;
}

.room-message-row__copy strong,
.room-message-row__copy small {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.room-message-row__copy strong {
  font-size: 15px;
  font-weight: 800;
}

.room-message-row__copy small {
  color: var(--color-on-dark-muted);
  font-size: 12px;
}

.room-message-row__meta {
  align-self: stretch;
  justify-items: end;
  align-content: space-between;
  padding: 5px 0;
}

.room-message-row__meta time {
  color: var(--color-on-dark-subtle);
  font-size: 10px;
}

.room-message-row__meta i {
  display: grid;
  min-width: 18px;
  height: 18px;
  padding: 0 5px;
  place-items: center;
  border-radius: 9px;
  background: var(--color-badge);
  color: var(--color-on-badge);
  font-size: 10px;
  font-style: normal;
}

.room-message-row__delete {
  display: grid;
  width: 64px;
  height: 60px;
  padding: 0;
  place-items: center;
  border: 0;
  background: var(--color-danger);
}

.room-message-row__delete img {
  width: 20px;
  height: 20px;
  object-fit: contain;
}

.room-message-stack__more {
  display: grid;
  min-width: 88px;
  min-height: 38px;
  margin: 4px auto 10px;
  padding: 0 16px;
  place-items: center;
  border: 0;
  border-radius: 19px;
  background: transparent;
  color: var(--color-primary);
  font-size: 12px;
}
</style>

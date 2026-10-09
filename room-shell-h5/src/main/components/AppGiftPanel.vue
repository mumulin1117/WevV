<script setup lang="ts">
import { computed } from 'vue'
import type { GiftItem } from '@/features/messages/contracts'
import type {
  GiftPanelRechargeRequest,
  GiftPanelSelection,
  GiftPanelTab,
} from '@/shared/gifts/contracts'
import SharedGiftPanel from '@/shared/gifts/SharedGiftPanel.vue'
import AppPopup from './AppPopup.vue'

const props = withDefaults(
  defineProps<{
    avatarUrl?: string
    balance: number
    failed?: boolean
    gifts: readonly GiftItem[]
    loading?: boolean
    name?: string
    pending?: boolean
    show: boolean
    suspended?: boolean
  }>(),
  { avatarUrl: '', failed: false, loading: false, name: 'User', pending: false, suspended: false },
)
const emit = defineEmits<{
  closed: []
  recharge: [request: GiftPanelRechargeRequest]
  retry: []
  send: [gift: GiftItem, count: number]
  'update:show': [value: boolean]
}>()

const tabs = computed<readonly GiftPanelTab[]>(() => {
  const categories = new Map<string, { items: GiftPanelTab['items'][number][]; label: string }>()
  for (const gift of props.gifts) {
    if (gift.source !== 'wallet') continue
    const label = gift.category?.trim() || 'Popular'
    const id = label.toLocaleLowerCase()
    const category = categories.get(id) ?? { items: [], label }
    category.items.push({
      effectUrl: gift.animationUrl,
      iconUrl: gift.iconUrl,
      id: gift.id,
      name: gift.name,
      price: gift.price,
      sendable: gift.sendable !== false,
      source: 'catalog',
    })
    if (!categories.has(id)) categories.set(id, category)
  }
  return [...categories].map(([id, category]) => ({
    id: `catalog:${id}`,
    items: category.items,
    label: category.label,
  }))
})

function close(value: boolean): void {
  if (!value && props.pending) return
  emit('update:show', value)
}

function send(selection: GiftPanelSelection): void {
  const gift = props.gifts.find((item) => item.id === selection.item.id && item.source === 'wallet')
  if (gift) emit('send', gift, selection.quantity)
}
</script>

<template>
  <AppPopup
    bottom-inset-owner="content"
    class="message-gift-popup"
    :closeable="false"
    flush
    :model-value="show"
    panel-height="368px"
    :show-handle="false"
    :suspended="suspended"
    @closed="emit('closed')"
    @update:model-value="close"
  >
    <SharedGiftPanel
      :balance="balance"
      :failed="failed"
      :loading="loading"
      :pending="pending"
      :recipient="{ avatarUrl, id: '', imAccount: '', name }"
      retry-label="Gifts unavailable · Tap to retry"
      send-label="Send"
      sending-label="Sending…"
      :show="show"
      :tabs="tabs"
      @recharge="emit('recharge', $event)"
      @retry="emit('retry')"
      @send="send"
    />
  </AppPopup>
</template>

<style scoped lang="less">
:deep(.message-gift-popup.app-popup-host) {
  border: 0;
  background: transparent !important;
  box-shadow: none;
}

.message-gift-popup :deep(.app-popup) {
  background: var(--panel-bg);
}
</style>

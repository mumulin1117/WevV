<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { publicAsset } from '@/core/media/public-asset'
import type { GiftItem } from '@/features/messages/contracts'
import type { PartyMember } from '@/features/party/contracts'
import type {
  GiftPanelRechargeRequest,
  GiftPanelSelection,
  GiftPanelTab,
} from '@/shared/gifts/contracts'
import AppAvatar from '@/main/components/AppAvatar.vue'
import SharedGiftPanel from '@/shared/gifts/SharedGiftPanel.vue'
import PartySheet from './PartySheet.vue'

interface PartyGiftReceiver extends PartyMember {
  seatIndex: number
}

const props = withDefaults(
  defineProps<{
    balance: number
    failed?: boolean
    gifts: readonly GiftItem[]
    loading?: boolean
    countChoices?: readonly number[]
    pending?: boolean
    preferredReceiverId?: string
    receivers: readonly PartyGiftReceiver[]
    show: boolean
    suspended?: boolean
  }>(),
  {
    countChoices: () => [1, 5, 10, 99],
    failed: false,
    loading: false,
    pending: false,
    preferredReceiverId: '',
    suspended: false,
  },
)
const emit = defineEmits<{
  closed: []
  recharge: [request: GiftPanelRechargeRequest]
  retry: []
  send: [gift: GiftItem, count: number, receiverImAccounts: string[], receiverIds: string[]]
  'update:show': [value: boolean]
}>()

const categories = computed(() => [
  ...new Set(
    props.gifts.filter((gift) => gift.source === 'wallet').map((gift) => gift.category || 'Gift'),
  ),
])
const tabs = computed<readonly GiftPanelTab[]>(() => {
  const catalog = categories.value.map((category) => ({
    id: `catalog:${category}`,
    items: props.gifts
      .filter((gift) => gift.source === 'wallet' && (gift.category || 'Gift') === category)
      .map((gift) => ({
        effectUrl: gift.animationUrl,
        iconUrl: gift.iconUrl,
        id: gift.id,
        name: gift.name,
        price: gift.price,
        sendable: gift.sendable !== false,
        source: 'catalog' as const,
      })),
    label: category,
  }))
  const bag = props.gifts
    .filter((gift) => gift.source === 'backpack')
    .map((gift) => ({
      effectUrl: gift.animationUrl,
      iconUrl: gift.iconUrl,
      id: gift.id,
      name: gift.name,
      price: gift.price,
      quantity: gift.quantity,
      remainingTime: gift.remainingTime,
      sendable: gift.sendable !== false,
      source: 'backpack' as const,
    }))
  return bag.length ? [...catalog, { id: 'backpack', items: bag, label: 'BACKPACK' }] : catalog
})
const selectedReceiverIds = ref<string[]>([])
const availableReceivers = computed(() => props.receivers.filter((member) => member.id))
const selectedReceivers = computed(() =>
  availableReceivers.value.filter((member) => selectedReceiverIds.value.includes(member.id)),
)
const allSelected = computed(
  () =>
    availableReceivers.value.length > 0 &&
    selectedReceiverIds.value.length === availableReceivers.value.length,
)

function initializeReceivers(): void {
  const available = availableReceivers.value
  if (!available.length) {
    selectedReceiverIds.value = []
    return
  }
  const retained = selectedReceiverIds.value.filter((id) =>
    available.some((member) => member.id === id),
  )
  if (
    props.preferredReceiverId &&
    available.some((member) => member.id === props.preferredReceiverId)
  ) {
    selectedReceiverIds.value = [props.preferredReceiverId]
    return
  }
  if (retained.length) {
    selectedReceiverIds.value = retained
    return
  }
  selectedReceiverIds.value = [available.find((member) => member.owner)?.id ?? available[0]!.id]
}

function toggleReceiver(id: string): void {
  selectedReceiverIds.value = selectedReceiverIds.value.includes(id)
    ? selectedReceiverIds.value.filter((value) => value !== id)
    : [...selectedReceiverIds.value, id]
}

function toggleAll(): void {
  selectedReceiverIds.value = allSelected.value
    ? []
    : availableReceivers.value.map((member) => member.id)
}

watch(
  () => [props.show, availableReceivers.value.map((member) => member.id).join(':')] as const,
  ([show]) => {
    if (show) initializeReceivers()
  },
  { immediate: true },
)

function updateShow(value: boolean): void {
  if (!value && props.pending) return
  emit('update:show', value)
}

function send(selection: GiftPanelSelection): void {
  const source = selection.item.source === 'backpack' ? 'backpack' : 'wallet'
  const gift = props.gifts.find((item) => item.id === selection.item.id && item.source === source)
  if (gift)
    emit(
      'send',
      gift,
      selection.quantity,
      selectedReceivers.value.map((member) => member.imAccount || member.id),
      selectedReceivers.value.map((member) => member.id),
    )
}
</script>

<template>
  <PartySheet
    bottom-inset-owner="content"
    flat
    :overlay="true"
    :show="show"
    size="gift"
    :suspended="suspended"
    @closed="emit('closed')"
    @update:show="updateShow"
  >
    <SharedGiftPanel
      :balance="balance"
      :cost-multiplier="Math.max(1, selectedReceivers.length)"
      :disabled="!selectedReceivers.length"
      :failed="failed"
      :loading="loading"
      :pending="pending"
      :quantity-presets="countChoices"
      :recipient="{
        avatarUrl: selectedReceivers[0]?.avatarUrl || '',
        id: selectedReceivers[0]?.id || '',
        imAccount: selectedReceivers[0]?.imAccount || '',
        name: selectedReceivers[0]?.displayName || '',
      }"
      retry-label="Gifts unavailable · Tap to retry"
      send-label="Send"
      sending-label="Sending…"
      :show="show"
      stepper
      :tabs="tabs"
      @recharge="emit('recharge', $event)"
      @retry="emit('retry')"
      @send="send"
    >
      <template #header>
        <section v-if="availableReceivers.length" class="party-gift-receivers">
          <span class="party-gift-receivers__count">{{ selectedReceivers.length }}</span>
          <div class="party-gift-receivers__list">
            <button
              v-for="member in availableReceivers"
              :key="member.id"
              :aria-pressed="selectedReceiverIds.includes(member.id)"
              :class="{ 'is-selected': selectedReceiverIds.includes(member.id) }"
              type="button"
              @click="toggleReceiver(member.id)"
            >
              <span class="party-gift-receivers__avatar">
                <AppAvatar :size="32" :src="member.avatarUrl" />
                <img
                  v-if="selectedReceiverIds.includes(member.id)"
                  alt=""
                  class="party-gift-receivers__selected-frame"
                  :src="publicAsset('party/room/gift_popup_avatar_selected_bg.webp')"
                />
              </span>
              <span class="party-gift-receivers__seat">{{ member.seatIndex }}</span>
            </button>
          </div>
          <button
            class="party-gift-receivers__all"
            :class="{ 'is-active': allSelected }"
            type="button"
            @click="toggleAll"
          >
            <em>All</em>
            <span aria-hidden="true" />
          </button>
        </section>
      </template>
    </SharedGiftPanel>
  </PartySheet>
</template>

<style scoped lang="less">
.party-gift-receivers {
  box-sizing: border-box;
  display: flex;
  height: 48px;
  align-items: center;
  gap: 8px;
  padding: 8px 16px 0;
}

.party-gift-receivers__count {
  min-width: 24px;
  flex: 0 0 24px;
  color: var(--color-text);
  font-size: 12px;
  font-weight: 500;
  text-align: center;
}

.party-gift-receivers__list {
  display: flex;
  min-width: 0;
  flex: 1;
  align-items: center;
  gap: 5px;
  overflow: auto hidden;
  scrollbar-width: none;
}

.party-gift-receivers__list::-webkit-scrollbar {
  display: none;
}

.party-gift-receivers__list button {
  position: relative;
  width: 38px;
  height: 40px;
  box-sizing: border-box;
  display: flex;
  flex: 0 0 38px;
  flex-direction: column;
  align-items: center;
  padding: 0;
  border: 0;
  background: transparent;
  touch-action: manipulation;
  -webkit-tap-highlight-color: transparent;
}

.party-gift-receivers__list button::before {
  position: absolute;
  inset: -2px 0;
  content: '';
}

.party-gift-receivers__avatar {
  position: relative;
  width: 38px;
  height: 38px;
  display: grid;
  flex: 0 0 38px;
  place-items: center;
}

.party-gift-receivers__avatar :deep(.app-image) {
  border: 0;
}

.party-gift-receivers__selected-frame {
  position: absolute;
  inset: 0;
  z-index: 2;
  width: 38px;
  height: 38px;
  pointer-events: none;
}

.party-gift-receivers__seat {
  position: relative;
  top: -10px;
  z-index: 3;
  box-sizing: border-box;
  width: max-content;
  min-width: 16px;
  height: 12px;
  display: grid;
  padding: 1px 5px;
  border-radius: 16px;
  background: var(--color-party-gift-receiver);
  color: var(--color-text);
  font-size: 9px;
  font-weight: 500;
  line-height: 10px;
  place-items: center;
}

.party-gift-receivers__list button.is-selected .party-gift-receivers__seat {
  background: var(--color-party-gift-receiver-selected);
}

.party-gift-receivers__all {
  position: relative;
  box-sizing: border-box;
  display: flex;
  width: 48px;
  min-width: 48px;
  height: 26px;
  align-items: center;
  justify-content: flex-end;
  padding: 4px 6px;
  border: 0;
  border-radius: 13px;
  background: var(--color-party-gift-receiver);
  color: var(--color-text);
  font-size: 12px;
  transition: background 220ms cubic-bezier(0.2, 0, 0, 1);
  touch-action: manipulation;
  -webkit-tap-highlight-color: transparent;
}

.party-gift-receivers__all::before {
  position: absolute;
  inset: -9px 0;
  content: '';
}

.party-gift-receivers__all.is-active {
  justify-content: flex-start;
  background: var(--color-party-gift-all-active);
}

.party-gift-receivers__all span {
  position: absolute;
  left: 4px;
  width: 18px;
  height: 18px;
  border-radius: 50%;
  background: var(--color-text);
  transition: transform 220ms cubic-bezier(0.2, 0, 0, 1);
}

.party-gift-receivers__all.is-active span {
  transform: translateX(22px);
}

.party-gift-receivers__all em {
  font-style: normal;
}
</style>

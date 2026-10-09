<script setup lang="ts">
import { computed, onBeforeUnmount, ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import type { RoomLaunchContext } from '@/features/rooms/contracts'
import type { LiveGiftCategory, LiveGiftItem } from '@/features/rooms/live-interaction-contracts'
import { liveInteractionActions, liveInteractionQueries } from '@/features/rooms/live-operations'
import AppPopup from '@/main/components/AppPopup.vue'
import { useSessionStore } from '@/main/stores/session'
import { useAppFeedback } from '@/main/ui/feedback'
import type {
  GiftPanelRechargeRequest,
  GiftPanelSelection,
  GiftPanelTab,
} from '@/shared/gifts/contracts'
import SharedGiftPanel from '@/shared/gifts/SharedGiftPanel.vue'
import { isGiftBalanceError, useGiftSendFlow } from '@/shared/gifts/useGiftSendFlow'

const props = defineProps<{
  context: RoomLaunchContext
  initialGiftId?: number | null
  modelValue: boolean
  pkActive?: boolean
  suspended?: boolean
}>()
const emit = defineEmits<{
  recharge: [request: GiftPanelRechargeRequest]
  sent: [payload: { gift: LiveGiftItem; quantity: number }]
  'update:modelValue': [value: boolean]
}>()
const { t } = useI18n()
const session = useSessionStore()
const feedback = useAppFeedback()
const categories = ref<readonly LiveGiftCategory[]>([])
const loading = ref(false)
const failed = ref(false)
const { pending, run: runGiftSend } = useGiftSendFlow()
let loadController: AbortController | undefined
let closeTimer = 0
let resolveClose: (() => void) | undefined
let active = true
let initialGiftMissingNotified = false

const tabs = computed<readonly GiftPanelTab[]>(() => {
  return categories.value.map((category) => ({
    id: `catalog:${category.code}`,
    items: category.gifts.map((gift) => ({
      effectUrl: gift.effectUrl,
      iconUrl: gift.iconUrl,
      id: String(gift.id),
      name: gift.name,
      price: gift.price,
      sendable: true,
      source: 'catalog' as const,
    })),
    label: category.name,
  }))
})

async function load(): Promise<void> {
  loadController?.abort()
  const controller = new AbortController()
  loadController = controller
  loading.value = !categories.value.length
  failed.value = false
  const [catalogResult, quickResult] = await Promise.allSettled([
    liveInteractionQueries.getGiftCategories(props.context, controller.signal),
    liveInteractionQueries.getQuickGifts(props.context, controller.signal),
  ])
  if (controller.signal.aborted || !props.modelValue) return

  const next: LiveGiftCategory[] = []
  if (quickResult.status === 'fulfilled' && quickResult.value.length)
    next.push({
      code: 'recommended',
      gifts: quickResult.value,
      name: t('room.recommended'),
    })
  if (catalogResult.status === 'fulfilled') next.push(...catalogResult.value)
  if (!next.length) {
    const fallbackGifts = await liveInteractionQueries.getGifts(controller.signal).catch(() => [])
    if (controller.signal.aborted || !props.modelValue) return
    if (fallbackGifts.length)
      next.push({
        code: 'all',
        gifts: fallbackGifts,
        name: t('room.gifts'),
      })
  }
  if (next.length) categories.value = next
  if (
    catalogResult.status === 'fulfilled' &&
    next.length &&
    props.initialGiftId &&
    !next.some((category) => category.gifts.some((gift) => gift.id === props.initialGiftId)) &&
    !initialGiftMissingNotified
  ) {
    initialGiftMissingNotified = true
    feedback.warning(t('room.giftsUnavailable'))
  }
  failed.value = categories.value.length === 0
  loading.value = false
}

async function send(selection: GiftPanelSelection): Promise<void> {
  if (selection.item.source !== 'catalog') {
    feedback.error('Backpack gifts are not available here.')
    return
  }
  const outcome = await runGiftSend(async () => {
    const giftId = Number(selection.item.id)
    const result = await liveInteractionActions.sendGift(
      props.context,
      giftId,
      selection.quantity,
      props.pkActive,
    )
    if (result.message === 'diamond.not.enough') return { status: 'insufficient' as const }
    if (!result.success) throw new Error(t('room.giftSendFailed'))
    if (result.newBalance !== null) await session.updateBalance(result.newBalance)
    else {
      const balance = await liveInteractionActions.refreshBalance().catch(() => null)
      if (balance !== null) await session.updateBalance(balance)
    }
    const gift = categories.value.flatMap((item) => item.gifts).find((item) => item.id === giftId)
    if (!gift) throw new Error(t('room.giftSendFailed'))
    if (active) await closeAfterSend()
    return { gift, quantity: selection.quantity, status: 'sent' as const }
  })
  if (outcome.status === 'failed') {
    if (isGiftBalanceError(outcome.cause)) {
      emit('recharge', {
        requiredDiamonds: selection.item.price * selection.quantity,
        selection,
      })
      return
    }
    const balance = await liveInteractionActions.refreshBalance().catch(() => null)
    if (balance !== null) await session.updateBalance(balance)
    feedback.warning(t('room.giftSendUnknown'))
    return
  }
  if (outcome.status !== 'sent') return
  if (!active) return
  if (outcome.value.status === 'insufficient') {
    emit('recharge', {
      requiredDiamonds: selection.item.price * selection.quantity,
      selection,
    })
    return
  }
  emit('sent', { gift: outcome.value.gift, quantity: outcome.value.quantity })
}

function closeAfterSend(): Promise<void> {
  return new Promise((resolve) => {
    window.clearTimeout(closeTimer)
    resolveClose?.()
    resolveClose = resolve
    emit('update:modelValue', false)
    closeTimer = window.setTimeout(finishCloseWait, 600)
  })
}

function finishCloseWait(): void {
  window.clearTimeout(closeTimer)
  closeTimer = 0
  const resolve = resolveClose
  resolveClose = undefined
  resolve?.()
}

function updateVisible(value: boolean): void {
  if (props.suspended || (!value && pending.value)) return
  emit('update:modelValue', value)
}

watch(
  () => props.modelValue,
  (visible) => {
    if (visible) {
      initialGiftMissingNotified = false
      void load()
    } else loadController?.abort()
  },
  { immediate: true },
)
onBeforeUnmount(() => {
  active = false
  loadController?.abort()
  finishCloseWait()
})
</script>

<template>
  <AppPopup
    bottom-inset-owner="content"
    class="live-gift-popup"
    :closeable="false"
    flush
    :model-value="modelValue"
    panel-height="368px"
    :show-handle="false"
    :suspended="suspended"
    @closed="finishCloseWait"
    @update:model-value="updateVisible"
  >
    <SharedGiftPanel
      :balance="session.balance"
      :failed="failed"
      :initial-item-id="initialGiftId ? String(initialGiftId) : ''"
      :loading="loading"
      :pending="pending"
      :recipient="{
        avatarUrl: context.hostAvatarUrl || '',
        id: context.hostId || '',
        imAccount: context.hostImAccount || '',
        name: context.displayName,
      }"
      retry-label="Gifts unavailable · Tap to retry"
      send-label="Send"
      sending-label="Sending…"
      :show="modelValue"
      :tabs="tabs"
      @recharge="emit('recharge', $event)"
      @retry="load"
      @send="send"
    />
  </AppPopup>
</template>

<style scoped lang="less">
:deep(.live-gift-popup.app-popup-host) {
  border: 0;
  background: var(--gift-panel-bg) !important;
  box-shadow: none;
}

.live-gift-popup :deep(.app-popup) {
  background: var(--gift-panel-bg);
}
</style>

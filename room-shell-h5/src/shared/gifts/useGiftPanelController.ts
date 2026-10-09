import type { MaybeRefOrGetter } from 'vue'
import { computed, ref, toValue, watch } from 'vue'
import type { GiftPanelItem, GiftPanelTab } from './contracts'

interface GiftPanelControllerOptions {
  balance: MaybeRefOrGetter<number>
  costMultiplier?: MaybeRefOrGetter<number>
  initialItemId?: MaybeRefOrGetter<string>
  maxQuantity?: number
  pending: MaybeRefOrGetter<boolean>
  tabs: MaybeRefOrGetter<readonly GiftPanelTab[]>
  visible: MaybeRefOrGetter<boolean>
}

const DEFAULT_MAX_QUANTITY = 999

export function giftPanelItemKey(item: GiftPanelItem): string {
  return `${item.source}:${item.id}`
}

export function useGiftPanelController(options: GiftPanelControllerOptions) {
  const activeTabId = ref('')
  const selectedKey = ref('')
  const quantity = ref(1)
  const customOpen = ref(false)
  const appliedInitialItemId = ref('')
  const tabs = computed(() => toValue(options.tabs))
  const activeTab = computed(
    () => tabs.value.find((tab) => tab.id === activeTabId.value) ?? tabs.value[0] ?? null,
  )
  const selectedItem = computed(
    () =>
      activeTab.value?.items.find((item) => giftPanelItemKey(item) === selectedKey.value) ?? null,
  )
  const maxQuantity = computed(() => {
    const configured = Math.max(1, Math.floor(options.maxQuantity ?? DEFAULT_MAX_QUANTITY))
    const item = selectedItem.value
    const multiplier = Math.max(1, Math.floor(toValue(options.costMultiplier ?? 1)))
    return item?.source === 'backpack'
      ? Math.max(1, Math.min(configured, Math.floor((item.quantity ?? 0) / multiplier)))
      : configured
  })
  const totalCost = computed(() =>
    selectedItem.value?.source === 'catalog'
      ? selectedItem.value.price *
        quantity.value *
        Math.max(1, Math.floor(toValue(options.costMultiplier ?? 1)))
      : 0,
  )
  const insufficient = computed(() => totalCost.value > Math.max(0, toValue(options.balance)))
  const unavailable = computed(() => {
    const item = selectedItem.value
    if (!item || !item.sendable) return true
    const multiplier = Math.max(1, Math.floor(toValue(options.costMultiplier ?? 1)))
    return item.source === 'backpack' && quantity.value * multiplier > (item.quantity ?? 0)
  })
  const canSend = computed(
    () =>
      Boolean(selectedItem.value) &&
      !toValue(options.pending) &&
      !unavailable.value &&
      !insufficient.value,
  )

  function selectTab(id: string): void {
    activeTabId.value = id
    selectedKey.value = ''
    quantity.value = 1
    customOpen.value = false
  }

  function selectItem(item: GiftPanelItem): void {
    selectedKey.value = giftPanelItemKey(item)
    quantity.value = 1
    customOpen.value = false
  }

  function selectQuantity(value: number): void {
    const normalized = Number.isFinite(value) ? Math.floor(value) : 1
    quantity.value = Math.max(1, Math.min(maxQuantity.value, normalized))
    customOpen.value = false
  }

  function applyInitialItem(): void {
    const id = String(toValue(options.initialItemId ?? '') || '')
    if (!id) {
      appliedInitialItemId.value = ''
      return
    }
    if (id === appliedInitialItemId.value) return
    const tab = tabs.value.find((candidate) => candidate.items.some((item) => item.id === id))
    const item = tab?.items.find((candidate) => candidate.id === id)
    if (!tab || !item) return
    activeTabId.value = tab.id
    selectedKey.value = giftPanelItemKey(item)
    appliedInitialItemId.value = id
  }

  function reset(): void {
    if (!tabs.value.some((tab) => tab.id === activeTabId.value))
      activeTabId.value = tabs.value[0]?.id ?? ''
    selectedKey.value = ''
    quantity.value = 1
    customOpen.value = false
    applyInitialItem()
  }

  watch(
    tabs,
    (nextTabs) => {
      if (!nextTabs.some((tab) => tab.id === activeTabId.value))
        activeTabId.value = nextTabs[0]?.id ?? ''
      const itemExists = activeTab.value?.items.some(
        (item) => giftPanelItemKey(item) === selectedKey.value,
      )
      if (!itemExists) selectedKey.value = ''
      quantity.value = Math.min(quantity.value, maxQuantity.value)
      applyInitialItem()
    },
    { immediate: true },
  )
  watch(
    () => toValue(options.visible),
    (visible) => {
      if (visible) reset()
    },
  )
  watch(
    () => String(toValue(options.initialItemId ?? '') || ''),
    () => applyInitialItem(),
  )
  watch(maxQuantity, (value) => (quantity.value = Math.min(quantity.value, value)))

  return {
    activeTab,
    activeTabId,
    canSend,
    customOpen,
    insufficient,
    maxQuantity,
    quantity,
    reset,
    selectItem,
    selectQuantity,
    selectedItem,
    selectedKey,
    selectTab,
    tabs,
    totalCost,
    unavailable,
  }
}

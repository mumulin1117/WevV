<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, reactive, ref, toRef, useSlots, watch } from 'vue'
import { publicAsset } from '@/core/media/public-asset'
import AppEmptyState from '@/main/components/AppEmptyState.vue'
import AppIcon from '@/main/components/AppIcon.vue'
import AppImage from '@/main/components/AppImage.vue'
import AppLoading from '@/main/components/AppLoading.vue'
import { preloadGiftEffect, preloadGiftEffects } from './gift-effect-assets'
import type {
  GiftPanelRechargeRequest,
  GiftPanelRecipient,
  GiftPanelSelection,
  GiftPanelTab,
} from './contracts'
import { giftPanelItemKey, useGiftPanelController } from './useGiftPanelController'

const props = withDefaults(
  defineProps<{
    balance: number
    costMultiplier?: number
    disabled?: boolean
    failed?: boolean
    initialItemId?: string
    loading?: boolean
    pending?: boolean
    quantityPresets?: readonly number[]
    recipient: GiftPanelRecipient
    retryLabel: string
    sendLabel: string
    sendingLabel: string
    show: boolean
    stepper?: boolean
    tabs: readonly GiftPanelTab[]
  }>(),
  {
    disabled: false,
    costMultiplier: 1,
    failed: false,
    initialItemId: '',
    loading: false,
    pending: false,
    quantityPresets: () => [1, 5, 10, 99],
    stepper: false,
  },
)
const emit = defineEmits<{
  recharge: [request: GiftPanelRechargeRequest]
  retry: []
  send: [selection: GiftPanelSelection]
}>()
const slots = useSlots()
const hasHeader = Boolean(slots.header)
const controller = useGiftPanelController({
  balance: toRef(props, 'balance'),
  costMultiplier: toRef(props, 'costMultiplier'),
  initialItemId: toRef(props, 'initialItemId'),
  pending: toRef(props, 'pending'),
  tabs: toRef(props, 'tabs'),
  visible: toRef(props, 'show'),
})
const quantityOpen = ref(false)
const customQuantity = ref('')
const swipe = ref<{ swipeTo: (index: number, options?: { immediate?: boolean }) => void } | null>(
  null,
)
const swipeIndex = ref(0)
const settledSwipeIndex = ref(0)
const tabsNav = ref<HTMLElement | null>(null)
const tabButtons = new Map<string, HTMLElement>()
const pageElements = new Map<string, HTMLElement>()
const pageViewportHeights = reactive<Record<string, number>>({})
const pageScrollTops = reactive<Record<string, number>>({})
const scrollFrames = new Map<string, number>()
let panelPreloadTimer = 0
const GIFT_COLUMNS = 4
const GIFT_ROW_HEIGHT = 91
const GIFT_OVERSCAN_ROWS = 1
const DEFAULT_PAGE_HEIGHT = GIFT_ROW_HEIGHT * 3
const primaryPresets = computed(() =>
  [...new Set(props.quantityPresets)]
    .map((value) => Math.max(1, Math.floor(value)))
    .filter((value) => value <= controller.maxQuantity.value),
)
const visibleTabs = computed(() => controller.tabs.value)
const renderedTabIndexes = computed(() => {
  const indexes = new Set<number>()
  const include = (index: number): void => {
    if (index >= 0 && index < visibleTabs.value.length) indexes.add(index)
  }
  include(swipeIndex.value - 1)
  include(swipeIndex.value)
  include(swipeIndex.value + 1)
  include(settledSwipeIndex.value)
  return indexes
})
const displayedTabId = computed(
  () => visibleTabs.value[swipeIndex.value]?.id ?? controller.activeTabId.value,
)

function giftRows(tab: GiftPanelTab): number {
  return Math.ceil(tab.items.length / GIFT_COLUMNS)
}

function visibleGiftWindow(tab: GiftPanelTab): {
  items: readonly GiftPanelTab['items'][number][]
  offset: number
  totalHeight: number
} {
  const scrollTop = pageScrollTops[tab.id] ?? 0
  const viewportHeight = pageViewportHeights[tab.id] ?? DEFAULT_PAGE_HEIGHT
  const rowCount = giftRows(tab)
  const firstRow = Math.max(0, Math.floor(scrollTop / GIFT_ROW_HEIGHT) - GIFT_OVERSCAN_ROWS)
  const lastRow = Math.min(
    rowCount,
    Math.ceil((scrollTop + viewportHeight) / GIFT_ROW_HEIGHT) + GIFT_OVERSCAN_ROWS,
  )
  return {
    items: tab.items.slice(firstRow * GIFT_COLUMNS, lastRow * GIFT_COLUMNS),
    offset: firstRow * GIFT_ROW_HEIGHT,
    totalHeight: rowCount * GIFT_ROW_HEIGHT,
  }
}

function send(): void {
  const item = controller.selectedItem.value
  if (!item || props.disabled || props.pending || controller.unavailable.value) return
  if (controller.insufficient.value) {
    recharge()
    return
  }
  void preloadGiftEffect(item.effectUrl, {
    decodeSvga: true,
    priority: 'critical',
    trigger: 'send',
  }).catch(() => undefined)
  emit('send', { item, quantity: controller.quantity.value })
}

function recharge(): void {
  const item = controller.selectedItem.value
  emit('recharge', {
    requiredDiamonds: controller.totalCost.value,
    selection: item ? { item, quantity: controller.quantity.value } : null,
  })
}

function selectTab(id: string): void {
  quantityOpen.value = false
  const index = visibleTabs.value.findIndex((tab) => tab.id === id)
  if (index >= 0) swipeIndex.value = index
  if (index >= 0) swipe.value?.swipeTo(index)
  revealTab(id)
}

function changeTab(index: number): void {
  swipeIndex.value = index
  settledSwipeIndex.value = index
  quantityOpen.value = false
  const tab = visibleTabs.value[index]
  if (tab && tab.id !== controller.activeTabId.value) controller.selectTab(tab.id)
  if (tab) revealTab(tab.id)
}

function bindTabButton(id: string, element: Element | null): void {
  if (element instanceof HTMLElement) tabButtons.set(id, element)
  else tabButtons.delete(id)
}

function bindPage(id: string, element: Element | null): void {
  if (element instanceof HTMLElement) {
    pageElements.set(id, element)
    pageViewportHeights[id] = element.clientHeight || DEFAULT_PAGE_HEIGHT
  } else pageElements.delete(id)
}

function handlePageScroll(tabId: string, event: Event): void {
  const target = event.currentTarget as HTMLElement
  const currentFrame = scrollFrames.get(tabId)
  if (currentFrame !== undefined) window.cancelAnimationFrame(currentFrame)
  scrollFrames.set(
    tabId,
    window.requestAnimationFrame(() => {
      scrollFrames.delete(tabId)
      pageScrollTops[tabId] = target.scrollTop
      pageViewportHeights[tabId] = target.clientHeight || DEFAULT_PAGE_HEIGHT
    }),
  )
}

function revealTab(id: string): void {
  void nextTick(() => {
    const nav = tabsNav.value
    const button = tabButtons.get(id)
    if (!nav || !button) return
    const left = button.offsetLeft - (nav.clientWidth - button.offsetWidth) / 2
    nav.scrollTo({ behavior: 'instant', left: Math.max(0, left) })
  })
}

function revealInitialItem(): void {
  if (!props.show || !props.initialItemId) return
  void nextTick(() => {
    window.requestAnimationFrame(() => {
      const tabId = controller.activeTabId.value
      const page = pageElements.get(tabId)
      const tab = visibleTabs.value.find((candidate) => candidate.id === tabId)
      const itemIndex = tab?.items.findIndex((item) => item.id === props.initialItemId) ?? -1
      if (!page || itemIndex < 0) return
      const itemTop = Math.floor(itemIndex / GIFT_COLUMNS) * GIFT_ROW_HEIGHT
      const itemBottom = itemTop + GIFT_ROW_HEIGHT
      const visibleTop = page.scrollTop
      const visibleBottom = visibleTop + page.clientHeight
      if (itemTop >= visibleTop && itemBottom <= visibleBottom) return
      page.scrollTo({
        behavior: 'instant',
        top: Math.max(0, itemTop - Math.max(8, (page.clientHeight - GIFT_ROW_HEIGHT) / 2)),
      })
      pageScrollTops[tabId] = page.scrollTop
    })
  })
}

function applyCustomQuantity(): void {
  const value = Number(customQuantity.value)
  if (!Number.isFinite(value) || value < 1) return
  controller.selectQuantity(value)
  quantityOpen.value = false
  customQuantity.value = ''
}

function selectPresetQuantity(value: number): void {
  controller.selectQuantity(value)
  quantityOpen.value = false
}

function schedulePanelEffectPreload(): void {
  window.clearTimeout(panelPreloadTimer)
  if (!props.show) return
  panelPreloadTimer = window.setTimeout(() => {
    panelPreloadTimer = 0
    const tab = visibleTabs.value[settledSwipeIndex.value]
    if (!props.show || !tab) return
    void preloadGiftEffects(
      tab.items.map((item) => item.effectUrl),
      { limit: 6, priority: 'visible', trigger: 'panel' },
    )
  }, 120)
}

watch(
  () => [props.show, settledSwipeIndex.value, visibleTabs.value] as const,
  schedulePanelEffectPreload,
  { immediate: true },
)

watch(
  () => [props.show, controller.selectedItem.value] as const,
  ([show, item]) => {
    if (!show || !item?.effectUrl) return
    void preloadGiftEffect(item.effectUrl, {
      decodeSvga: true,
      priority: 'critical',
      trigger: 'selection',
    }).catch(() => undefined)
  },
)

onBeforeUnmount(() => {
  window.clearTimeout(panelPreloadTimer)
  scrollFrames.forEach((frame) => window.cancelAnimationFrame(frame))
  scrollFrames.clear()
})

watch(
  () => controller.activeTabId.value,
  (id) => {
    const index = visibleTabs.value.findIndex((tab) => tab.id === id)
    if (index < 0) return
    if (index !== swipeIndex.value) {
      swipeIndex.value = index
      settledSwipeIndex.value = index
      void nextTick(() => swipe.value?.swipeTo(index, { immediate: true }))
    }
    revealTab(id)
    revealInitialItem()
  },
  { immediate: true },
)

watch(
  () => [props.show, props.initialItemId, controller.selectedKey.value] as const,
  ([show]) => {
    if (!show) return
    revealInitialItem()
  },
)

watch(
  () => props.show,
  (show) => {
    if (show) revealInitialItem()
  },
)
</script>

<template>
  <section
    class="shared-gift-panel"
    :class="{ 'shared-gift-panel--has-header': hasHeader }"
    :aria-busy="pending || loading"
  >
    <div v-if="hasHeader" class="shared-gift-panel__header">
      <slot name="header" />
    </div>
    <nav ref="tabsNav" class="shared-gift-panel__tabs" aria-label="Gift categories">
      <button
        v-for="tab in visibleTabs"
        :key="tab.id"
        :ref="(element) => bindTabButton(tab.id, element as Element | null)"
        :aria-current="displayedTabId === tab.id ? 'page' : undefined"
        :class="{ 'is-active': displayedTabId === tab.id }"
        type="button"
        @click="selectTab(tab.id)"
      >
        {{ tab.label }}
      </button>
    </nav>

    <div class="shared-gift-panel__content">
      <div v-if="loading" class="shared-gift-panel__state" role="status">
        <AppLoading />
      </div>
      <button
        v-else-if="failed"
        class="shared-gift-panel__state shared-gift-panel__state--retry"
        type="button"
        @click="emit('retry')"
      >
        <span>{{ retryLabel }}</span>
      </button>
      <AppEmptyState v-else-if="!tabs.length" size="popup" />
      <VanSwipe
        v-else
        ref="swipe"
        class="shared-gift-panel__swipe"
        :loop="false"
        :duration="220"
        :lazy-render="true"
        :show-indicators="false"
        @change="changeTab"
      >
        <VanSwipeItem v-for="(tab, tabIndex) in visibleTabs" :key="tab.id">
          <div
            v-if="renderedTabIndexes.has(tabIndex)"
            :ref="(element) => bindPage(tab.id, element as Element | null)"
            class="shared-gift-panel__page"
            @scroll.passive="handlePageScroll(tab.id, $event)"
          >
            <AppEmptyState v-if="!tab.items.length" size="popup" />
            <div
              v-else
              class="shared-gift-panel__virtual-space"
              :style="{ height: `${visibleGiftWindow(tab).totalHeight}px` }"
            >
              <div
                class="shared-gift-panel__grid"
                :style="{ transform: `translate3d(0, ${visibleGiftWindow(tab).offset}px, 0)` }"
              >
                <button
                  v-for="item in visibleGiftWindow(tab).items"
                  :key="giftPanelItemKey(item)"
                  :aria-pressed="controller.selectedKey.value === giftPanelItemKey(item)"
                  :class="{
                    'is-selected': controller.selectedKey.value === giftPanelItemKey(item),
                  }"
                  type="button"
                  @click="controller.selectItem(item)"
                >
                  <span>
                    <AppImage :alt="item.name" fit="contain" :lazy="true" :src="item.iconUrl" />
                    <i v-if="item.source === 'backpack'">×{{ item.quantity ?? 0 }}</i>
                  </span>
                  <strong>{{ item.name }}</strong>
                  <small>
                    <template v-if="item.source === 'catalog'">
                      <img alt="" :src="publicAsset('common/diamond.png')" />{{ item.price }}
                    </template>
                    <template v-else>{{ item.remainingTime || `×${item.quantity ?? 0}` }}</template>
                  </small>
                  <em v-if="!item.sendable">Unavailable</em>
                </button>
              </div>
            </div>
          </div>
        </VanSwipeItem>
      </VanSwipe>
    </div>

    <footer class="shared-gift-panel__footer">
      <button class="shared-gift-panel__balance" type="button" @click="recharge">
        <img alt="" :src="publicAsset('common/diamond.png')" />
        <strong>{{ balance.toLocaleString('en') }}</strong>
        <img
          class="shared-gift-panel__balance-arrow"
          alt=""
          :src="publicAsset('messages/gift-coin-arrow.png')"
        />
      </button>
      <div class="shared-gift-panel__send-group" :class="{ 'is-stepper': stepper }">
        <button
          v-if="stepper"
          class="shared-gift-panel__stepper"
          :disabled="controller.quantity.value <= 1"
          type="button"
          @click="controller.selectQuantity(controller.quantity.value - 1)"
        >
          −
        </button>
        <button
          class="shared-gift-panel__quantity"
          type="button"
          @click="quantityOpen = !quantityOpen"
        >
          {{ controller.quantity.value }}
          <AppIcon class="shared-gift-panel__quantity-chevron" name="chevron" :size="16" />
        </button>
        <button
          v-if="stepper"
          class="shared-gift-panel__stepper"
          :disabled="controller.quantity.value >= controller.maxQuantity.value"
          type="button"
          @click="controller.selectQuantity(controller.quantity.value + 1)"
        >
          +
        </button>
        <button
          class="shared-gift-panel__send"
          :disabled="
            disabled || !controller.selectedItem.value || pending || controller.unavailable.value
          "
          type="button"
          @click="send"
        >
          {{ pending ? sendingLabel : controller.insufficient.value ? 'Recharge' : sendLabel }}
        </button>
      </div>
      <div v-if="quantityOpen" class="shared-gift-panel__quantity-menu">
        <button
          v-for="value in primaryPresets"
          :key="value"
          type="button"
          @click="selectPresetQuantity(value)"
        >
          ×{{ value }}
        </button>
        <label>
          <input
            v-model="customQuantity"
            aria-label="Custom quantity"
            :max="controller.maxQuantity.value"
            min="1"
            inputmode="numeric"
            placeholder="Custom"
            type="number"
            @change="applyCustomQuantity"
            @keydown.enter.prevent="applyCustomQuantity"
          />
        </label>
      </div>
    </footer>
  </section>
</template>

<style scoped lang="less">
.shared-gift-panel {
  display: grid;
  height: 100%;
  min-height: 0;
  grid-template-rows: 44px minmax(0, 1fr) calc(60px + var(--app-popup-content-bottom-inset));
  background: var(--gift-panel-bg);
  color: var(--color-text);
  font-family:
    'TT Norms Pro',
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    sans-serif;
}

.shared-gift-panel--has-header {
  grid-template-rows:
    auto 44px minmax(0, 1fr)
    calc(60px + var(--app-popup-content-bottom-inset));
}

.shared-gift-panel__header {
  min-height: 0;
}

.shared-gift-panel__tabs {
  display: flex;
  height: 44px;
  align-items: stretch;
  gap: 24px;
  padding: 0 12px;
  overflow: auto hidden;
  background: var(--gift-panel-bg);
  scrollbar-width: none;
}

.shared-gift-panel__tabs button {
  position: relative;
  flex: 0 0 auto;
  padding: 0;
  border: 0;
  background: transparent;
  color: var(--color-message-tab-inactive);
  font-size: 14px;
  font-weight: 700;
  touch-action: manipulation;
  -webkit-tap-highlight-color: transparent;
}

.shared-gift-panel__tabs button.is-active {
  color: var(--color-text);
}

.shared-gift-panel__tabs button.is-active::after {
  position: absolute;
  right: 0;
  bottom: 0;
  left: 0;
  height: 2px;
  border-radius: 999px;
  background: var(--gradient-primary);
  content: '';
}

.shared-gift-panel__content {
  min-height: 0;
  overflow: hidden;
  padding: 0;
  overscroll-behavior: contain;
}

.shared-gift-panel__swipe,
.shared-gift-panel__swipe :deep(.van-swipe__track),
.shared-gift-panel__swipe :deep(.van-swipe-item) {
  height: 100%;
}

.shared-gift-panel__page {
  height: 100%;
  padding: 8px 8px 10px;
  overflow: hidden auto;
  overscroll-behavior: contain;
  scrollbar-width: none;
  touch-action: pan-y;
}

.shared-gift-panel__page::-webkit-scrollbar {
  display: none;
}

.shared-gift-panel__grid {
  position: absolute;
  top: 0;
  right: 0;
  left: 0;
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  align-content: start;
}

.shared-gift-panel__virtual-space {
  position: relative;
  min-height: 100%;
}

.shared-gift-panel__grid > button {
  position: relative;
  display: grid;
  min-width: 0;
  height: 91px;
  grid-template-rows: 60px 16px 13px;
  justify-items: center;
  padding: 0 2px 4px;
  overflow: hidden;
  border: 1px solid transparent;
  border-radius: 8px;
  background: transparent;
  color: var(--color-text);
  touch-action: manipulation;
  -webkit-tap-highlight-color: transparent;
}

.shared-gift-panel__grid > button.is-selected {
  border-color: var(--color-accent);
  background: var(--gift-panel-selected-bg);
}

.shared-gift-panel__grid > button > span {
  position: relative;
  width: 60px;
  height: 60px;
}

.shared-gift-panel__grid :deep(.app-image) {
  width: 60px !important;
  height: 60px !important;
  background: transparent;
}

.shared-gift-panel__grid i {
  position: absolute;
  right: 0;
  bottom: 1px;
  font-size: 9px;
  font-style: normal;
  text-shadow: 0 1px 3px rgb(0 0 0 / 70%);
}

.shared-gift-panel__grid strong,
.shared-gift-panel__grid small {
  max-width: 100%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.shared-gift-panel__grid strong {
  font-size: 11px;
  font-weight: 500;
}

.shared-gift-panel__grid small {
  display: flex;
  align-items: center;
  gap: 2px;
  color: var(--color-text);
  font-size: 10px;
}

.shared-gift-panel__grid small img {
  width: 10px;
  height: 9px;
  object-fit: contain;
}

.shared-gift-panel__grid em {
  position: absolute;
  inset: 0;
  display: grid;
  background: var(--gift-panel-unavailable-bg);
  color: var(--color-text-muted);
  font-size: 10px;
  font-style: normal;
  place-items: center;
}

.shared-gift-panel__state {
  display: grid;
  width: 100%;
  height: 100%;
  min-height: 190px;
  margin: 0;
  padding: 0;
  border: 0;
  background: transparent;
  color: var(--color-text-muted);
  font-size: 13px;
  place-items: center;
}

.shared-gift-panel__state--retry {
  color: var(--color-text-muted);
}

.shared-gift-panel__footer {
  position: relative;
  z-index: 2;
  display: flex;
  height: calc(60px + var(--app-popup-content-bottom-inset));
  align-items: center;
  justify-content: space-between;
  padding: 6px 12px calc(5px + var(--app-popup-content-bottom-inset));
  border-top: 0;
  background: var(--gift-panel-footer-bg);
}

.shared-gift-panel__balance {
  display: flex;
  height: 34px;
  align-items: center;
  gap: 4px;
  padding: 0;
  border: 0;
  background: transparent;
  color: var(--color-text);
}

.shared-gift-panel__balance > img:first-child {
  width: 24px;
  height: 22px;
  object-fit: contain;
}

.shared-gift-panel__balance strong {
  font-size: 13px;
  font-weight: 800;
}

.shared-gift-panel__balance .shared-gift-panel__balance-arrow {
  width: 4px;
  height: 8px;
}

.shared-gift-panel__send-group {
  display: flex;
  width: 152px;
  height: 34px;
  overflow: hidden;
  border: 1px solid var(--gift-panel-control-border-color);
  border-radius: 999px;
}

.shared-gift-panel__send-group.is-stepper {
  width: 184px;
}

.shared-gift-panel__quantity,
.shared-gift-panel__stepper,
.shared-gift-panel__send {
  height: 32px;
  border: 0;
  color: var(--color-text);
  font-size: 12px;
  font-weight: 700;
}

.shared-gift-panel__stepper {
  width: 24px;
  flex: 0 0 24px;
  padding: 0;
  background: var(--gift-panel-control-bg);
  font-size: 18px;
}

.shared-gift-panel__stepper:disabled {
  color: var(--color-text-muted);
}

.shared-gift-panel__send-group.is-stepper .shared-gift-panel__quantity {
  width: 52px;
}

.shared-gift-panel__send-group.is-stepper .shared-gift-panel__send {
  width: 84px;
}

.shared-gift-panel__quantity {
  display: flex;
  width: 76px;
  align-items: center;
  justify-content: center;
  gap: 8px;
  background: var(--gift-panel-control-bg);
}

.shared-gift-panel__quantity-chevron {
  transform: rotate(90deg);
}

.shared-gift-panel__send {
  width: 76px;
  background: var(--gradient-primary);
}

.shared-gift-panel__send:disabled {
  background: var(--gift-panel-disabled-bg);
  color: var(--color-text-muted);
}

.shared-gift-panel__quantity-menu {
  position: absolute;
  right: 76px;
  bottom: calc(66px + var(--app-popup-content-bottom-inset));
  display: grid;
  width: 83px;
  height: 146px;
  grid-template-rows: repeat(5, minmax(0, 1fr));
  padding: 0 7px;
  border-radius: 10px;
  background-color: var(--gift-panel-quantity-menu-bg);
}

.shared-gift-panel__send-group.is-stepper ~ .shared-gift-panel__quantity-menu {
  right: 96px;
}

.shared-gift-panel__quantity-menu > button,
.shared-gift-panel__quantity-menu label {
  display: grid;
  min-width: 0;
  min-height: 0;
  place-items: center;
  border: 0;
  border-bottom: 1px solid var(--gift-panel-quantity-menu-divider);
  background: transparent;
  color: var(--gift-panel-quantity-menu-text);
  font-size: 13px;
  font-weight: 400;
  line-height: 13px;
}

.shared-gift-panel__quantity-menu label {
  border-bottom: 0;
}

.shared-gift-panel__quantity-menu input {
  width: 100%;
  height: 100%;
  padding: 0;
  border: 0;
  outline: 0;
  appearance: textfield;
  background: transparent;
  color: var(--gift-panel-quantity-menu-text);
  font: inherit;
  text-align: center;
}

.shared-gift-panel__quantity-menu input::placeholder {
  color: var(--gift-panel-quantity-menu-placeholder);
  opacity: 1;
}

.shared-gift-panel__quantity-menu input::-webkit-inner-spin-button,
.shared-gift-panel__quantity-menu input::-webkit-outer-spin-button {
  margin: 0;
  appearance: none;
}
</style>

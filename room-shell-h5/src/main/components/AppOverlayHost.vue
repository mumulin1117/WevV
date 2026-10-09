<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import { useAppNavigation } from '@/core/navigation/coordinator'
import AppConfirmDialogHost from '@/main/components/AppConfirmDialogHost.vue'
import AppGiftEffectHost from '@/main/components/AppGiftEffectHost.vue'
import AppLoadLoadingIcon from '@/main/components/AppLoadLoadingIcon.vue'
import AppMediaPreviewHost from '@/main/components/AppMediaPreviewHost.vue'
import { globalLoadingState } from '@/main/ui/global-loading-state'
import {
  actionSheetState,
  closeActionSheet,
  notifyActionSheetClosed,
} from '@/main/ui/overlay-state'

const navigation = useAppNavigation()
const { t } = useI18n()
let release: (() => void) | undefined
const card = ref<HTMLElement | null>(null)
const dragOffset = ref(0)
const dragging = ref(false)
let dragActive = false
let dragStartedAt = 0
let dragStartX = 0
let dragStartY = 0
let returnFocus: HTMLElement | null = null
let suppressActionUntil = 0

const cardStyle = computed(() => ({ transform: `translate3d(0, ${dragOffset.value}px, 0)` }))

watch(
  () => actionSheetState.visible,
  (visible) => {
    if (visible) {
      release ??= navigation.acquireGestureLock('action-sheet')
      returnFocus = document.activeElement instanceof HTMLElement ? document.activeElement : null
      dragOffset.value = 0
      void nextTick(() => card.value?.querySelector<HTMLElement>('button:not(:disabled)')?.focus())
    }
  },
  { immediate: true },
)
function unlock(): void {
  release?.()
  release = undefined
  returnFocus?.focus()
  returnFocus = null
}

function handleClosed(): void {
  notifyActionSheetClosed()
  if (!actionSheetState.visible) unlock()
}

function onSelect(action: { disabled?: boolean; value: string }): void {
  if (action.disabled || performance.now() < suppressActionUntil) return
  closeActionSheet(action.value)
}

function beginDrag(event: PointerEvent): void {
  if (event.pointerType === 'mouse' && event.button !== 0) return
  dragActive = true
  dragging.value = false
  dragStartedAt = performance.now()
  dragStartX = event.clientX
  dragStartY = event.clientY
}

function moveDrag(event: PointerEvent): void {
  const target = event.currentTarget as HTMLElement
  if (!dragActive) return
  const deltaX = event.clientX - dragStartX
  const deltaY = event.clientY - dragStartY
  if (!dragging.value) {
    if (Math.abs(deltaX) + Math.abs(deltaY) < 8) return
    if (deltaY <= 0 || Math.abs(deltaX) > Math.abs(deltaY)) {
      dragActive = false
      if (target.hasPointerCapture(event.pointerId)) target.releasePointerCapture(event.pointerId)
      return
    }
    dragging.value = true
    target.setPointerCapture(event.pointerId)
  }
  event.preventDefault()
  dragOffset.value = Math.max(0, deltaY)
}

function endDrag(event: PointerEvent): void {
  const target = event.currentTarget as HTMLElement
  if (target.hasPointerCapture(event.pointerId)) target.releasePointerCapture(event.pointerId)
  if (!dragActive && !dragging.value) return
  const elapsed = Math.max(1, performance.now() - dragStartedAt)
  const velocity = dragOffset.value / elapsed
  const shouldClose = dragOffset.value >= 72 || (dragOffset.value >= 28 && velocity > 0.55)
  if (dragging.value) suppressActionUntil = performance.now() + 360
  dragActive = false
  dragging.value = false
  dragOffset.value = 0
  if (shouldClose) closeActionSheet()
}

onBeforeUnmount(() => {
  closeActionSheet()
  notifyActionSheetClosed()
  unlock()
})
</script>

<template>
  <AppMediaPreviewHost />
  <AppConfirmDialogHost />
  <AppGiftEffectHost />
  <Teleport to="body">
    <Transition name="global-loading">
      <div
        v-if="globalLoadingState.visible"
        class="global-loading"
        role="status"
        aria-live="polite"
        aria-busy="true"
        aria-label="Loading"
      >
        <AppLoadLoadingIcon animated :size="60" />
      </div>
    </Transition>
  </Teleport>
  <VanPopup
    class="app-action-sheet-host"
    close-on-popstate
    position="bottom"
    :show="actionSheetState.visible"
    teleport="body"
    @click-overlay="closeActionSheet()"
    @closed="handleClosed"
    @update:show="!$event && closeActionSheet()"
  >
    <section
      ref="card"
      class="app-action-sheet"
      :class="{ 'is-dragging': dragging }"
      :style="cardStyle"
      role="dialog"
      aria-modal="true"
      :aria-label="actionSheetState.title || t('common.options')"
      @pointercancel="endDrag"
      @pointerdown="beginDrag"
      @pointermove="moveDrag"
      @pointerup="endDrag"
      @keydown.esc="closeActionSheet()"
    >
      <header v-if="actionSheetState.title || actionSheetState.description">
        <h2 v-if="actionSheetState.title">{{ actionSheetState.title }}</h2>
        <p v-if="actionSheetState.description">{{ actionSheetState.description }}</p>
      </header>
      <button
        v-for="(action, index) in actionSheetState.actions"
        :key="action.value"
        class="app-action-sheet__action"
        :class="[`is-${action.tone || 'default'}`, { 'is-leading': index === 0 }]"
        :disabled="action.disabled"
        type="button"
        @click="onSelect(action)"
      >
        {{ action.label }}
      </button>
      <button
        class="app-action-sheet__action app-action-sheet__cancel"
        type="button"
        @click="closeActionSheet()"
      >
        {{ actionSheetState.cancelLabel || t('common.cancel') }}
      </button>
    </section>
  </VanPopup>
</template>

<style lang="less">
.global-loading {
  position: fixed;
  inset: 0;
  z-index: var(--z-blocking-loading);
  display: grid;
  place-content: center;
  justify-items: center;
  background: var(--color-loading-mask);
  touch-action: none;
}

.global-loading-enter-active,
.global-loading-leave-active {
  transition: opacity 160ms ease-out;
}

.global-loading-leave-active {
  z-index: var(--z-overlay);
  pointer-events: none;
}

.global-loading-enter-from,
.global-loading-leave-to {
  opacity: 0;
}

.app-action-sheet-host.van-popup {
  right: 0;
  bottom: 0;
  left: 0;
  width: 100%;
  padding-bottom: calc(5px + var(--safe-bottom));
  overflow: visible;
  border: 0;
  border-radius: 0;
  background: transparent;
  box-shadow: none;
}

.app-action-sheet {
  display: grid;
  width: min(calc(100vw - 36px), 394px);
  gap: 12px;
  margin: 0 auto;
  padding: 18px 34px;
  border: 0;
  border-radius: 22px;
  background: var(--color-action-sheet);
  box-shadow: 0 18px 54px rgb(0 0 0 / 38%);
  color: var(--color-text);
  touch-action: pan-x;
  transition: transform 220ms cubic-bezier(0.2, 0, 0, 1);
}

.app-action-sheet.is-dragging {
  transition: none;
}

.app-action-sheet header {
  display: grid;
  gap: 6px;
  padding: 2px 2px 6px;
  text-align: center;
}

.app-action-sheet h2 {
  margin: 0;
  color: var(--color-text);
  font-size: 17px;
  font-weight: 800;
}

.app-action-sheet p {
  margin: 0;
  color: var(--color-action-sheet-description);
  font-size: 13px;
  line-height: 1.45;
}

.app-action-sheet__action {
  display: flex;
  width: 100%;
  min-height: 54px;
  align-items: center;
  justify-content: center;
  padding: 0 16px;
  border: 0;
  border-radius: 999px;
  background: var(--color-action-sheet-action);
  color: var(--color-text);
  font-size: 15px;
  font-weight: 700;
}

.app-action-sheet__action.is-leading,
.app-action-sheet__action.is-primary {
  background: var(--gradient-action-sheet-primary);
  color: var(--color-on-action-sheet-primary);
}

.app-action-sheet__action.is-danger {
  color: var(--color-text);
}

.app-action-sheet__action:disabled {
  background: var(--color-action-sheet-action);
  color: var(--color-text-subtle);
  opacity: 0.58;
}

.app-action-sheet__cancel {
  background: var(--color-action-sheet-cancel);
}
</style>

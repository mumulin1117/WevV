<script setup lang="ts">
import { computed, onBeforeUnmount, provide, ref, useSlots, watch, type CSSProperties } from 'vue'
import { useI18n } from 'vue-i18n'
import { useAppNavigation } from '@/core/navigation/coordinator'
import AppIcon from './AppIcon.vue'
import { appPopupContextKey } from './app-popup-context'
const props = withDefaults(
  defineProps<{
    bottomInsetOwner?: 'content' | 'layout'
    bottomOffset?: number
    closeable?: boolean
    closeOnClickOverlay?: boolean
    closeOnPopstate?: boolean
    expandForBottomInset?: boolean
    flush?: boolean
    modelValue: boolean
    overlayStyle?: CSSProperties
    panelHeight?: string
    panelMaxHeight?: string
    availableHeight?: string
    position?: 'bottom' | 'center' | 'left' | 'right'
    round?: boolean
    scrollable?: boolean
    showHandle?: boolean
    surfaceRadius?: number
    swipeToClose?: boolean
    surface?: 'gift' | 'standard' | 'transparent'
    suspended?: boolean
    title?: string
  }>(),
  {
    bottomInsetOwner: 'layout',
    bottomOffset: 0,
    closeable: true,
    closeOnClickOverlay: true,
    closeOnPopstate: true,
    expandForBottomInset: true,
    flush: false,
    overlayStyle: () => ({}),
    panelHeight: '',
    panelMaxHeight: '',
    availableHeight: '',
    position: 'bottom',
    round: true,
    scrollable: false,
    showHandle: false,
    surfaceRadius: undefined,
    swipeToClose: false,
    surface: 'gift',
    suspended: false,
    title: '',
  },
)
const emit = defineEmits<{ closed: []; 'update:modelValue': [value: boolean] }>()
const { t } = useI18n()
const slots = useSlots()
provide(appPopupContextKey, true)
const navigation = useAppNavigation()
let release: (() => void) | undefined
const dragOffset = ref(0)
const dragging = ref(false)
let dragStartY = 0
let dragStartedAt = 0

const hasFooter = computed(() => Boolean(slots.footer))
const effectiveBottomInsetOwner = computed<'content' | 'layout'>(() => props.bottomInsetOwner)
const hasSurfaceRadius = computed(() => props.surfaceRadius !== undefined)
const normalizedSurfaceRadius = computed(() => {
  const radius = props.surfaceRadius
  return typeof radius === 'number' && Number.isFinite(radius) ? Math.max(0, radius) : 0
})

const popupHostStyle = computed(() => ({
  ...(props.bottomOffset > 0 ? { bottom: `${props.bottomOffset}px` } : {}),
  ...(hasSurfaceRadius.value
    ? { '--app-popup-surface-radius': `${normalizedSurfaceRadius.value}px` }
    : {}),
}))

function safeAreaSize(value: string): string {
  return `min(calc(${value} + var(--safe-bottom)), calc(100dvh - var(--safe-top)))`
}

const popupStyle = computed(() => {
  const expandsForBottomInset = props.position === 'bottom' && props.expandForBottomInset
  const requestedMaxHeight =
    props.panelMaxHeight && expandsForBottomInset
      ? safeAreaSize(props.panelMaxHeight)
      : props.panelMaxHeight || ''
  const maxHeight =
    requestedMaxHeight && props.availableHeight
      ? `min(${requestedMaxHeight}, ${props.availableHeight})`
      : requestedMaxHeight || props.availableHeight || undefined
  return {
    height:
      props.panelHeight && expandsForBottomInset
        ? safeAreaSize(props.panelHeight)
        : props.panelHeight || undefined,
    maxHeight,
    transform: `translate3d(0, ${dragOffset.value}px, 0)`,
  }
})

watch(
  () => props.modelValue,
  (visible) => {
    if (visible) release ??= navigation.acquireGestureLock('app-popup')
    else {
      dragOffset.value = 0
      dragging.value = false
    }
  },
  { immediate: true },
)

function handleClosed(): void {
  if (!props.modelValue) {
    release?.()
    release = undefined
  }
  emit('closed')
}

function beginDrag(event: PointerEvent): void {
  if (props.suspended || !props.swipeToClose || props.position !== 'bottom') return
  if ((event.target as HTMLElement).closest('button, a, input, textarea, select')) return
  if (event.pointerType === 'mouse' && event.button !== 0) return
  dragStartY = event.clientY
  dragStartedAt = performance.now()
  dragging.value = true
  ;(event.currentTarget as HTMLElement).setPointerCapture(event.pointerId)
}

function moveDrag(event: PointerEvent): void {
  const target = event.currentTarget as HTMLElement
  if (!dragging.value || !target.hasPointerCapture(event.pointerId)) return
  event.preventDefault()
  dragOffset.value = Math.max(0, event.clientY - dragStartY)
}

function endDrag(event: PointerEvent): void {
  const target = event.currentTarget as HTMLElement
  if (target.hasPointerCapture(event.pointerId)) target.releasePointerCapture(event.pointerId)
  if (!dragging.value) return
  const elapsed = Math.max(1, performance.now() - dragStartedAt)
  const velocity = dragOffset.value / elapsed
  const shouldClose = dragOffset.value >= 72 || (dragOffset.value >= 28 && velocity > 0.55)
  dragging.value = false
  dragOffset.value = 0
  if (shouldClose) emit('update:modelValue', false)
}

onBeforeUnmount(() => release?.())
</script>
<template>
  <VanPopup
    :aria-hidden="suspended ? 'true' : undefined"
    class="app-popup-host"
    :class="{
      'is-flush': flush,
      'is-standard': surface === 'standard',
      'is-transparent': surface === 'transparent',
      'has-surface-radius': hasSurfaceRadius,
    }"
    :closeable="false"
    :close-on-click-overlay="!suspended && closeOnClickOverlay"
    :close-on-popstate="!suspended && closeOnPopstate"
    :inert="suspended || undefined"
    :position="position"
    :round="hasSurfaceRadius ? false : flush ? false : round"
    :show="modelValue"
    :overlay-style="overlayStyle"
    :style="popupHostStyle"
    teleport="body"
    @closed="handleClosed"
    @update:show="emit('update:modelValue', $event)"
    ><section
      class="app-popup"
      :class="[
        `app-popup--${position}`,
        {
          'has-footer': hasFooter,
          'is-dragging': dragging,
          'is-scrollable': scrollable,
          'owns-bottom-inset': position === 'bottom' && effectiveBottomInsetOwner === 'layout',
          'delegates-bottom-inset':
            position === 'bottom' && effectiveBottomInsetOwner === 'content',
          'is-flush': flush,
          'is-standard': surface === 'standard',
          'is-transparent': surface === 'transparent',
        },
      ]"
      :style="popupStyle"
    >
      <i
        v-if="position === 'bottom' && showHandle"
        class="app-popup__handle"
        aria-hidden="true"
        @pointercancel="endDrag"
        @pointerdown="beginDrag"
        @pointermove="moveDrag"
        @pointerup="endDrag"
      />
      <header
        v-if="title || closeable"
        :class="{
          'is-swipe-target': position === 'bottom' && swipeToClose,
        }"
        @pointercancel="endDrag"
        @pointerdown="beginDrag"
        @pointermove="moveDrag"
        @pointerup="endDrag"
      >
        <h2>{{ title }}</h2>
        <button
          v-if="closeable"
          class="app-popup__close"
          type="button"
          :aria-label="t('common.close')"
          @click="emit('update:modelValue', false)"
        >
          <AppIcon name="close" :size="15" />
        </button>
      </header>
      <div class="app-popup__body" data-popup-scroll><slot /></div>
      <footer v-if="hasFooter" class="app-popup__footer" data-popup-footer>
        <slot name="footer" />
      </footer></section
  ></VanPopup>
</template>
<style scoped lang="less">
.app-popup {
  --app-popup-content-bottom-inset: 0px;

  min-width: min(100vw, 430px);
  background: var(--panel-bg);
  color: var(--color-text);
  transition: transform 220ms cubic-bezier(0.2, 0, 0, 1);
}

.app-popup.is-transparent {
  background: transparent;
}

.app-popup.is-dragging {
  transition: none;
}

.app-popup--bottom {
  display: flex;
  max-height: calc(100dvh - var(--safe-top));
  box-sizing: border-box;
  flex-direction: column;
  padding: 0 16px;
}

.app-popup--bottom.owns-bottom-inset:not(.has-footer, .is-scrollable) {
  padding-bottom: calc(5px + var(--safe-bottom));
}

.app-popup--bottom.delegates-bottom-inset .app-popup__body {
  --app-popup-content-bottom-inset: var(--safe-bottom);
}

.app-popup--bottom.is-flush {
  padding-right: 0;
  padding-left: 0;
  overflow: hidden;
}

.app-popup--center {
  min-width: min(88vw, 380px);
  max-width: calc(100vw - max(24px, var(--safe-right)) - max(24px, var(--safe-left)));
  max-height: calc(100dvh - max(24px, var(--safe-top)) - max(24px, var(--safe-bottom)));
  box-sizing: border-box;
  padding: 20px;
}

.app-popup--center.is-transparent {
  padding: 0;
}

.app-popup__body {
  display: flex;
  min-width: 0;
  min-height: 0;
  flex: 1 1 auto;
  flex-direction: column;
}

.app-popup--bottom.is-scrollable .app-popup__body {
  overflow: hidden auto;
  overscroll-behavior: contain;
  -webkit-overflow-scrolling: touch;
}

.app-popup--bottom.owns-bottom-inset.is-scrollable:not(.has-footer) .app-popup__body {
  padding-bottom: calc(5px + var(--safe-bottom));
  scroll-padding-bottom: calc(5px + var(--safe-bottom));
}

.app-popup__footer {
  min-width: 0;
  flex: 0 0 auto;
}

.app-popup--bottom.owns-bottom-inset.has-footer .app-popup__footer {
  padding-bottom: calc(5px + var(--safe-bottom));
}

.app-popup header {
  display: flex;
  min-height: 44px;
  align-items: center;
}

.app-popup header.is-swipe-target {
  touch-action: none;
}

.app-popup h2 {
  min-width: 0;
  flex: 1;
  font-size: 15px;
  font-weight: 800;
}

.app-popup__handle {
  display: block;
  width: 40px;
  height: 4px;
  margin: 10px auto 6px;
  border-radius: 999px;
  background: var(--color-text-subtle);
  touch-action: none;
}

.app-popup__close {
  display: grid;
  width: 28px;
  height: 28px;
  padding: 0;
  border: 0;
  border-radius: 50%;
  background: var(--color-on-dark-fill);
  color: var(--color-text);
  place-items: center;
}

.app-popup-host {
  border: 0;
  background: var(--panel-bg) !important;
  box-shadow: none;
}

.app-popup-host.is-standard {
  border: 1px solid var(--color-border);
  background: var(--color-bg) !important;
  box-shadow: 0 -18px 48px rgb(0 0 0 / 48%);
}

.app-popup-host.is-transparent {
  border: 0;
  background: transparent !important;
  box-shadow: none;
}

.app-popup-host.van-popup--bottom {
  border-radius: 0;
}

.app-popup-host.is-standard.van-popup--bottom {
  border-radius: 28px 28px 0 0;
}

.app-popup-host.is-flush.van-popup--bottom {
  overflow: hidden;
  border: 0;
  border-radius: 0;
  box-shadow: none;
}

.app-popup-host.has-surface-radius {
  overflow: hidden;
}

.app-popup-host.has-surface-radius.van-popup--bottom {
  border-radius: var(--app-popup-surface-radius) var(--app-popup-surface-radius) 0 0;
}

.app-popup-host.has-surface-radius.van-popup--center {
  border-radius: var(--app-popup-surface-radius);
}

.app-popup-host.has-surface-radius.van-popup--left {
  border-radius: 0 var(--app-popup-surface-radius) var(--app-popup-surface-radius) 0;
}

.app-popup-host.has-surface-radius.van-popup--right {
  border-radius: var(--app-popup-surface-radius) 0 0 var(--app-popup-surface-radius);
}
</style>

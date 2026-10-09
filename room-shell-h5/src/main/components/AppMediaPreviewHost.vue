<script setup lang="ts">
import type { ComponentPublicInstance } from 'vue'
import type { SwipeInstance } from 'vant'
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import { useAppNavigation } from '@/core/navigation/coordinator'
import { appActivity } from '@/core/runtime/app-activity'
import AppIcon from './AppIcon.vue'
import AppImage from './AppImage.vue'
import AppLoadLoadingIcon from './AppLoadLoadingIcon.vue'
import {
  mediaPreviewDragPresentation,
  resolveMediaPreviewDragDirection,
  shouldDismissMediaPreview,
} from '@/main/ui/media-preview-gesture'
import type {
  MediaPreviewDragDirection,
  MediaPreviewDragPresentation,
} from '@/main/ui/media-preview-gesture'
import {
  clearMediaPreview,
  closeMediaPreview,
  mediaPreviewState,
} from '@/main/ui/media-preview-state'
import type { AppMediaPreviewItem } from '@/main/ui/media-preview-state'

const navigation = useAppNavigation()
const { t } = useI18n()
const activeIndex = ref(0)
const closeButton = ref<HTMLButtonElement | null>(null)
const mediaSwipeRef = ref<SwipeInstance>()
const renderItems = ref<AppMediaPreviewItem[]>([])
const videoLoadingMap = ref<Record<number, boolean>>({})
const videoRefs = new Map<number, HTMLVideoElement>()
const dragDirection = ref<MediaPreviewDragDirection | null>(null)
const dragPresentation = ref<MediaPreviewDragPresentation>(mediaPreviewDragPresentation(0, 0))
const isDraggingPreview = ref(false)
const isClosingFromGesture = ref(false)
const isVideoPausedByUser = ref(false)
const isVideoPlaying = ref(false)
let autoPlayTimer: number | null = null
let playbackSequence = 0
let hasMovedPreviewTouch = false
let releaseGesture: (() => void) | undefined
let returnFocus: HTMLElement | null = null
let stopAppActivity: (() => void) | undefined
let suppressClickTimer: number | null = null
let suppressNextPreviewClick = false
let touchStartX: number | null = null
let touchStartY: number | null = null

const previewCount = computed(() => renderItems.value.length)
const displayIndex = computed(() =>
  previewCount.value ? Math.min(activeIndex.value + 1, previewCount.value) : 0,
)
const activeItem = computed(() => renderItems.value[activeIndex.value])
const showVideoPlayButton = computed(
  () => activeItem.value?.type === 'video' && !isVideoPlaying.value,
)
const popupStyle = computed(() => ({
  '--app-media-preview-backdrop-opacity': String(dragPresentation.value.backdropOpacity),
}))
const activeItemStyle = computed(() => ({
  transform: `translate3d(${dragPresentation.value.offsetX}px, ${dragPresentation.value.offsetY}px, 0) scale(${dragPresentation.value.scale})`,
}))

function clearAutoPlayTimer(): void {
  if (autoPlayTimer === null) return
  window.clearTimeout(autoPlayTimer)
  autoPlayTimer = null
}

function clearSuppressClickTimer(): void {
  if (suppressClickTimer === null) return
  window.clearTimeout(suppressClickTimer)
  suppressClickTimer = null
}

function suppressNextClick(): void {
  suppressNextPreviewClick = true
  clearSuppressClickTimer()
  suppressClickTimer = window.setTimeout(() => {
    suppressNextPreviewClick = false
    suppressClickTimer = null
  }, 350)
}

function setSwipeTouchEnabled(enabled: boolean): void {
  if (mediaSwipeRef.value?.state) mediaSwipeRef.value.state.swiping = enabled
}

function resetDragState(): void {
  touchStartX = null
  touchStartY = null
  dragDirection.value = null
  dragPresentation.value = mediaPreviewDragPresentation(0, 0)
  isDraggingPreview.value = false
  isClosingFromGesture.value = false
  hasMovedPreviewTouch = false
  setSwipeTouchEnabled(true)
}

function canPlayActiveVideo(): boolean {
  return (
    mediaPreviewState.visible &&
    activeItem.value?.type === 'video' &&
    !isVideoPausedByUser.value &&
    appActivity.value.phase === 'active'
  )
}

function normalizeVideoPlaybackRate(video: HTMLVideoElement): void {
  if (video.defaultPlaybackRate !== 1) video.defaultPlaybackRate = 1
  if (video.playbackRate !== 1) video.playbackRate = 1
}

function pauseInactiveVideos(): void {
  for (const [index, video] of videoRefs) if (index !== activeIndex.value) video.pause()
}

function pauseAllVideos(): void {
  playbackSequence += 1
  clearAutoPlayTimer()
  for (const video of videoRefs.values()) video.pause()
  isVideoPlaying.value = false
}

function releaseVideo(video: HTMLVideoElement): void {
  video.pause()
  video.removeAttribute('src')
  video.load()
}

function releaseAllVideos(): void {
  clearAutoPlayTimer()
  for (const video of videoRefs.values()) releaseVideo(video)
  videoRefs.clear()
  videoLoadingMap.value = {}
  isVideoPlaying.value = false
}

async function syncVideoPlayback(resetTime = false): Promise<void> {
  const sequence = ++playbackSequence
  clearAutoPlayTimer()
  pauseInactiveVideos()
  const video = videoRefs.get(activeIndex.value)
  if (!video) return
  if (!canPlayActiveVideo()) {
    video.pause()
    return
  }

  await nextTick()
  if (sequence !== playbackSequence || videoRefs.get(activeIndex.value) !== video) return

  normalizeVideoPlaybackRate(video)
  const restoreSound = () => {
    autoPlayTimer = window.setTimeout(() => {
      autoPlayTimer = null
      if (videoRefs.get(activeIndex.value) !== video || !canPlayActiveVideo()) return
      video.muted = false
    }, 100)
  }

  if (!video.paused) {
    isVideoPlaying.value = true
    restoreSound()
    return
  }

  try {
    if (resetTime) video.currentTime = 0
    video.muted = true
    await video.play()
    if (sequence !== playbackSequence || videoRefs.get(activeIndex.value) !== video) {
      if (videoRefs.get(activeIndex.value) !== video || !canPlayActiveVideo()) video.pause()
      return
    }
    restoreSound()
  } catch {
    if (sequence === playbackSequence && videoRefs.get(activeIndex.value) === video)
      isVideoPlaying.value = false
  }
}

function setVideoRef(element: Element | ComponentPublicInstance | null, index: number): void {
  const previous = videoRefs.get(index)
  if (element instanceof HTMLVideoElement) {
    if (previous === element) return
    if (previous && previous !== element) releaseVideo(previous)
    normalizeVideoPlaybackRate(element)
    videoRefs.set(index, element)
    if (index === activeIndex.value) void syncVideoPlayback()
    return
  }
  if (previous) releaseVideo(previous)
  videoRefs.delete(index)
}

function setVideoLoading(index: number, loading: boolean): void {
  videoLoadingMap.value = { ...videoLoadingMap.value, [index]: loading }
}

function isVideoLoading(index: number): boolean {
  return Boolean(videoLoadingMap.value[index])
}

function handleVideoLoadStart(index: number): void {
  setVideoLoading(index, true)
}

function handleVideoReady(index: number): void {
  setVideoLoading(index, false)
  if (index === activeIndex.value) void syncVideoPlayback()
}

function handleVideoRateChange(index: number): void {
  const video = videoRefs.get(index)
  if (video) normalizeVideoPlaybackRate(video)
}

function handleVideoPlay(index: number): void {
  setVideoLoading(index, false)
  if (index === activeIndex.value) isVideoPlaying.value = true
}

function handleVideoPause(index: number): void {
  if (index === activeIndex.value) isVideoPlaying.value = false
}

function handleVideoError(index: number): void {
  setVideoLoading(index, false)
  if (index === activeIndex.value) isVideoPlaying.value = false
}

async function handleVideoToggle(): Promise<void> {
  const sequence = ++playbackSequence
  clearAutoPlayTimer()
  const video = videoRefs.get(activeIndex.value)
  if (!video || activeItem.value?.type !== 'video') return
  if (video.paused) {
    isVideoPausedByUser.value = false
    video.muted = false
    normalizeVideoPlaybackRate(video)
    try {
      await video.play()
      if (sequence !== playbackSequence || videoRefs.get(activeIndex.value) !== video) {
        if (videoRefs.get(activeIndex.value) !== video || !canPlayActiveVideo()) video.pause()
        return
      }
    } catch {
      if (sequence === playbackSequence && videoRefs.get(activeIndex.value) === video)
        isVideoPlaying.value = false
    }
    return
  }
  isVideoPausedByUser.value = true
  video.pause()
}

async function handleVideoTap(): Promise<void> {
  if (suppressNextPreviewClick) {
    suppressNextPreviewClick = false
    clearSuppressClickTimer()
    return
  }

  await handleVideoToggle()
}

function handleChange(index: number): void {
  activeIndex.value = index
  isVideoPausedByUser.value = false
  isVideoPlaying.value = false
  resetDragState()
  void nextTick(() => syncVideoPlayback(true))
}

function close(): void {
  closeMediaPreview()
}

function handlePreviewTap(event: MouseEvent, index: number, item: AppMediaPreviewItem): void {
  if (index !== activeIndex.value || !mediaPreviewState.visible || item.type !== 'image') return
  if (suppressNextPreviewClick) {
    suppressNextPreviewClick = false
    clearSuppressClickTimer()
    return
  }
  if (event.target instanceof Element && event.target.closest('button, [role="button"]')) return
  close()
}

function handleTouchStart(event: TouchEvent, index: number): void {
  if (index !== activeIndex.value || !mediaPreviewState.visible || event.touches.length !== 1)
    return
  touchStartX = event.touches[0]?.clientX ?? null
  touchStartY = event.touches[0]?.clientY ?? null
  dragDirection.value = null
  isClosingFromGesture.value = false
  hasMovedPreviewTouch = false
}

function handleTouchMove(event: TouchEvent, index: number): void {
  if (
    index !== activeIndex.value ||
    touchStartX === null ||
    touchStartY === null ||
    !mediaPreviewState.visible ||
    event.touches.length !== 1
  )
    return

  const currentX = event.touches[0]?.clientX ?? touchStartX
  const currentY = event.touches[0]?.clientY ?? touchStartY
  const deltaX = currentX - touchStartX
  const deltaY = currentY - touchStartY
  dragDirection.value ??= resolveMediaPreviewDragDirection(deltaX, deltaY)
  if (dragDirection.value) hasMovedPreviewTouch = true
  if (dragDirection.value === 'horizontal') return
  if (dragDirection.value !== 'vertical') return

  event.preventDefault()
  event.stopPropagation()
  setSwipeTouchEnabled(false)
  isDraggingPreview.value = true
  dragPresentation.value = mediaPreviewDragPresentation(deltaX, deltaY)
}

function handleTouchEnd(event: TouchEvent, index: number): void {
  if (index !== activeIndex.value) return
  const shouldSuppressClick = hasMovedPreviewTouch
  if (!isDraggingPreview.value) {
    resetDragState()
    if (shouldSuppressClick) suppressNextClick()
    return
  }

  event.stopPropagation()
  if (
    shouldDismissMediaPreview(
      dragPresentation.value.offsetY,
      typeof window === 'undefined' ? 0 : window.innerHeight,
    )
  ) {
    isClosingFromGesture.value = true
    close()
    return
  }

  resetDragState()
  if (shouldSuppressClick) suppressNextClick()
}

function hydratePreview(): void {
  releaseAllVideos()
  renderItems.value = mediaPreviewState.items.map((item) => ({ ...item }))
  activeIndex.value = Math.min(
    Math.max(mediaPreviewState.startIndex, 0),
    Math.max(0, renderItems.value.length - 1),
  )
  isVideoPausedByUser.value = false
  isVideoPlaying.value = false
  resetDragState()
  void nextTick(() => {
    mediaSwipeRef.value?.swipeTo(activeIndex.value, { immediate: true })
    void syncVideoPlayback(true)
    closeButton.value?.focus({ preventScroll: true })
  })
}

function handleClosed(): void {
  if (mediaPreviewState.visible) return
  releaseAllVideos()
  resetDragState()
  activeIndex.value = 0
  renderItems.value = []
  clearMediaPreview()
  returnFocus?.focus({ preventScroll: true })
  returnFocus = null
}

watch(
  [() => mediaPreviewState.visible, () => mediaPreviewState.key],
  ([visible], [wasVisible]) => {
    if (visible) {
      if (!wasVisible)
        returnFocus = document.activeElement instanceof HTMLElement ? document.activeElement : null
      releaseGesture ??= navigation.acquireGestureLock('app-media-preview')
      hydratePreview()
      return
    }
    pauseAllVideos()
    releaseGesture?.()
    releaseGesture = undefined
  },
  { immediate: true },
)

onMounted(() => {
  stopAppActivity = appActivity.subscribe((snapshot) => {
    if (snapshot.phase !== 'active') {
      pauseAllVideos()
      return
    }
    void syncVideoPlayback()
  })
})

onBeforeUnmount(() => {
  closeMediaPreview()
  clearAutoPlayTimer()
  clearSuppressClickTimer()
  stopAppActivity?.()
  stopAppActivity = undefined
  releaseAllVideos()
  releaseGesture?.()
  releaseGesture = undefined
  renderItems.value = []
})
</script>

<template>
  <VanPopup
    class="app-media-preview-popup"
    :close-on-click-overlay="false"
    :close-on-popstate="false"
    :show="mediaPreviewState.visible"
    :style="popupStyle"
    teleport="body"
    transition="van-fade"
    @closed="handleClosed"
    @update:show="!$event && close()"
  >
    <section
      class="app-media-preview"
      role="dialog"
      aria-modal="true"
      :aria-label="t('mediaPreview.title')"
      @keydown.esc="close"
    >
      <header class="app-media-preview__header">
        <button ref="closeButton" type="button" :aria-label="t('common.close')" @click.stop="close">
          <AppIcon name="back" :size="22" />
        </button>
        <strong aria-live="polite">{{ displayIndex }} / {{ previewCount }}</strong>
        <span aria-hidden="true" />
      </header>

      <VanSwipe
        v-if="renderItems.length"
        ref="mediaSwipeRef"
        class="app-media-preview__swipe"
        :duration="280"
        :initial-swipe="mediaPreviewState.startIndex"
        :loop="false"
        :show-indicators="false"
        @change="handleChange"
      >
        <VanSwipeItem
          v-for="(item, index) in renderItems"
          :key="`${item.type}-${item.url}-${index}`"
        >
          <div
            class="app-media-preview__stage"
            :class="{
              'is-active': index === activeIndex,
              'is-dragging': index === activeIndex && isDraggingPreview,
              'is-closing': index === activeIndex && isClosingFromGesture,
            }"
            :style="index === activeIndex ? activeItemStyle : undefined"
            @click="handlePreviewTap($event, index, item)"
            @touchcancel="handleTouchEnd($event, index)"
            @touchend="handleTouchEnd($event, index)"
            @touchmove="handleTouchMove($event, index)"
            @touchstart="handleTouchStart($event, index)"
          >
            <AppImage
              v-if="item.type === 'image'"
              :alt="t('mediaPreview.image', { current: index + 1, total: previewCount })"
              fit="contain"
              :lazy="false"
              :priority="index === activeIndex"
              :src="item.url"
            />

            <div v-else class="app-media-preview__video-wrap">
              <video
                :ref="(element) => setVideoRef(element, index)"
                :aria-label="
                  t(
                    isVideoPlaying && index === activeIndex
                      ? 'mediaPreview.pause'
                      : 'mediaPreview.play',
                  )
                "
                loop
                playsinline
                preload="metadata"
                :poster="item.poster"
                :src="item.url"
                tabindex="0"
                webkit-playsinline
                @canplay="handleVideoReady(index)"
                @click.stop="index === activeIndex && handleVideoTap()"
                @error="handleVideoError(index)"
                @keydown.enter.prevent="index === activeIndex && handleVideoToggle()"
                @keydown.space.prevent="index === activeIndex && handleVideoToggle()"
                @loadstart="handleVideoLoadStart(index)"
                @pause="handleVideoPause(index)"
                @play="handleVideoPlay(index)"
                @ratechange="handleVideoRateChange(index)"
                @waiting="handleVideoLoadStart(index)"
              />
              <div
                v-if="isVideoLoading(index) && index === activeIndex"
                class="app-media-preview__video-loading"
                role="status"
                :aria-label="t('common.loading')"
              >
                <AppLoadLoadingIcon animated :size="60" />
              </div>
              <button
                v-if="showVideoPlayButton && index === activeIndex && !isVideoLoading(index)"
                class="app-media-preview__play"
                type="button"
                :aria-label="t('mediaPreview.play')"
                @click.stop="handleVideoToggle"
              >
                <AppIcon name="play" :size="32" />
              </button>
            </div>
          </div>
        </VanSwipeItem>
      </VanSwipe>
    </section>
  </VanPopup>
</template>

<style lang="less">
.app-media-preview-popup.van-popup {
  width: 100%;
  height: 100%;
  max-width: none;
  max-height: none;
  overflow: hidden;
  background: transparent;
}

.app-media-preview-popup::before {
  position: absolute;
  z-index: 0;
  background: var(--color-ink);
  content: '';
  inset: 0;
  opacity: var(--app-media-preview-backdrop-opacity, 1);
  pointer-events: none;
  transition: opacity 180ms ease;
}

.app-media-preview {
  position: relative;
  z-index: 1;
  width: 100%;
  height: 100%;
  overflow: hidden;
}

.app-media-preview__header {
  position: absolute;
  top: 0;
  right: 0;
  left: 0;
  z-index: 4;
  display: grid;
  min-height: calc(68px + var(--safe-top));
  grid-template-columns: 44px 1fr 44px;
  align-items: center;
  gap: 8px;
  padding: calc(12px + var(--safe-top)) 16px 12px;
  color: var(--color-on-dark);
  pointer-events: none;
}

.app-media-preview__header button {
  display: grid;
  width: 44px;
  height: 44px;
  padding: 0;
  border: 0;
  background: transparent;
  color: var(--color-on-dark);
  cursor: pointer;
  pointer-events: auto;
  place-items: center;
}

.app-media-preview__header strong {
  font-size: 18px;
  font-weight: 700;
  line-height: 1;
  text-align: center;
}

.app-media-preview__swipe,
.app-media-preview__swipe :is(.van-swipe__track, .van-swipe-item) {
  width: 100%;
  height: 100%;
}

.app-media-preview__stage {
  display: grid;
  width: 100%;
  height: 100%;
  overflow: hidden;
  transform-origin: center;
  transition: transform 220ms ease;
  user-select: none;
  place-items: center;
  touch-action: none;
  -webkit-user-select: none;
}

.app-media-preview__stage.is-dragging,
.app-media-preview__stage.is-closing {
  transition: none;
}

.app-media-preview__stage > .app-image {
  width: 100%;
  height: 100%;
}

.app-media-preview__video-wrap {
  position: relative;
  display: grid;
  width: 100%;
  height: 100%;
  place-items: center;
}

.app-media-preview__video-wrap video {
  display: block;
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
}

.app-media-preview__video-loading {
  position: absolute;
  z-index: 2;
  display: grid;
  inset: 0;
  pointer-events: none;
  place-items: center;
}

.app-media-preview__play {
  position: absolute;
  z-index: 3;
  display: grid;
  width: 60px;
  height: 60px;
  padding: 0;
  border: 0;
  border-radius: 50%;
  background: var(--color-scrim-soft);
  color: var(--color-on-dark);
  cursor: pointer;
  place-items: center;
}

@media (prefers-reduced-motion: reduce) {
  .app-media-preview-popup::before,
  .app-media-preview__stage {
    transition: none;
  }
}
</style>

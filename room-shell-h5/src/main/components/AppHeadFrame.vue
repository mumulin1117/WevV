<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, ref, watch } from 'vue'
import type { Player as SvgaPlayer } from 'svgaplayerweb'
import { resolveImageUrl } from '@/core/media/image-cdn'
import { loadSvgaRuntime } from '@/core/media/svga-runtime'
import { isSvgaSource, loadSvgaVideo } from '@/core/media/svga-video-cache'
import { reportRuntimeMetric } from '@/core/observability/runtime'
import { responsiveCssLength } from '@/main/ui/responsive-unit'
import AppImage from './AppImage.vue'

const props = withDefaults(
  defineProps<{
    lazy?: boolean
    priority?: boolean
    size?: number
    src?: string
  }>(),
  {
    lazy: true,
    priority: false,
    size: 60,
    src: '',
  },
)

const resolvedSource = computed(() => resolveImageUrl(props.src))
const frameType = computed<'image' | 'svga' | null>(() => {
  const source = resolvedSource.value
  if (!source) return null
  return isSvgaSource(source) ? 'svga' : 'image'
})
const staticSource = computed(() => (frameType.value === 'image' ? resolvedSource.value : ''))
const svgaSource = computed(() => (frameType.value === 'svga' ? resolvedSource.value : ''))
const frameStyle = computed(() => {
  const size = responsiveCssLength(props.size)
  return { height: size, width: size }
})
const svgaContainer = ref<HTMLDivElement | null>(null)
let generation = 0
let player: SvgaPlayer | null = null
let intersectionObserver: IntersectionObserver | null = null
let lifecycleListenersInstalled = false
let frameVisible = true
const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)')

function syncPlayback(): void {
  const activePlayer = player
  if (!activePlayer) return
  try {
    if (reducedMotion.matches) {
      activePlayer.stopAnimation(false)
      activePlayer.stepToFrame(0, false)
    } else if (frameVisible && document.visibilityState !== 'hidden') {
      activePlayer.startAnimation()
    } else {
      activePlayer.pauseAnimation()
    }
  } catch {
    // 弹层切换与播放器回调可能同帧发生，下一次可见性同步会恢复状态。
  }
}

function installLifecycleListeners(): void {
  if (lifecycleListenersInstalled) return
  lifecycleListenersInstalled = true
  document.addEventListener('visibilitychange', syncPlayback)
  reducedMotion.addEventListener('change', syncPlayback)
}

function removeLifecycleListeners(): void {
  if (!lifecycleListenersInstalled) return
  lifecycleListenersInstalled = false
  document.removeEventListener('visibilitychange', syncPlayback)
  reducedMotion.removeEventListener('change', syncPlayback)
}

function clearPlayer(): void {
  intersectionObserver?.disconnect()
  intersectionObserver = null
  removeLifecycleListeners()
  try {
    player?.stopAnimation(true)
    player?.clear()
  } catch {
    // A parser callback can race with a user-card switch; cleanup still needs to finish.
  }
  player = null
  svgaContainer.value?.replaceChildren()
}

async function renderSvga(source: string): Promise<void> {
  const activeGeneration = ++generation
  clearPlayer()
  if (!source) return

  await nextTick()
  const target = svgaContainer.value
  if (!target || activeGeneration !== generation) return

  installLifecycleListeners()
  let started = false
  const start = async (): Promise<void> => {
    if (started || activeGeneration !== generation) return
    started = true
    const startedAt = performance.now()
    try {
      const [video, { Player }] = await Promise.all([loadSvgaVideo(source), loadSvgaRuntime()])
      if (activeGeneration !== generation || target !== svgaContainer.value) return
      const nextPlayer = new Player(target)
      player = nextPlayer
      nextPlayer.loops = 0
      nextPlayer.clearsAfterStop = false
      nextPlayer.setContentMode('AspectFit')
      nextPlayer.setClipsToBounds(true)
      nextPlayer.setVideoItem(video)
      syncPlayback()
      reportRuntimeMetric(
        'avatar-frame.render-duration',
        Math.round(performance.now() - startedAt),
        { outcome: 'ready' },
      )
    } catch {
      reportRuntimeMetric(
        'avatar-frame.render-duration',
        Math.round(performance.now() - startedAt),
        { outcome: 'failed' },
      )
      if (activeGeneration === generation) clearPlayer()
    }
  }

  if (props.lazy && 'IntersectionObserver' in window) {
    frameVisible = false
    intersectionObserver = new IntersectionObserver(
      ([entry]) => {
        if (activeGeneration !== generation) return
        frameVisible = Boolean(entry?.isIntersecting)
        if (frameVisible) void start()
        syncPlayback()
      },
      { rootMargin: '80px' },
    )
    intersectionObserver.observe(target)
  } else {
    frameVisible = true
    void start()
  }
}

watch([svgaSource, () => props.lazy], ([source]) => void renderSvga(source), {
  flush: 'post',
  immediate: true,
})

onBeforeUnmount(() => {
  generation += 1
  clearPlayer()
})
</script>

<template>
  <span v-if="frameType" class="app-head-frame" :style="frameStyle">
    <AppImage
      v-if="staticSource"
      aria-hidden="true"
      fit="contain"
      :height="size"
      :lazy="lazy"
      :priority="priority"
      :src="staticSource"
      :width="size"
    >
      <template #loading><span /></template>
      <template #error><span /></template>
      <template #empty><span /></template>
    </AppImage>
    <div v-else ref="svgaContainer" aria-hidden="true" class="app-head-frame__svga" dir="ltr" />
  </span>
</template>

<style scoped lang="less">
.app-head-frame {
  display: block;
  overflow: visible;
  background: transparent;
  pointer-events: none;
}

.app-head-frame :deep(.app-image),
.app-head-frame :deep(.van-image),
.app-head-frame :deep(.van-image__img),
.app-head-frame :deep(.van-image__loading),
.app-head-frame :deep(.van-image__error) {
  background: transparent;
}

.app-head-frame__svga {
  display: block;
  width: 100%;
  height: 100%;
}

.app-head-frame__svga :deep(canvas) {
  display: block;
  max-width: none;
  pointer-events: none;
}
</style>

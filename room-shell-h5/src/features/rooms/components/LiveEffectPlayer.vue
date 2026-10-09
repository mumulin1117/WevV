<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref, watch } from 'vue'
import type { Player as SvgaPlayer } from 'svgaplayerweb'
import type { YYEvaType } from 'yyeva'
import { loadSvgaRuntime } from '@/core/media/svga-runtime'
import { reportRuntimeMetric } from '@/core/observability/runtime'
import { acquireGiftEffectAsset, loadEvaEffectRuntime } from '@/shared/gifts/gift-effect-assets'

const props = withDefaults(
  defineProps<{
    fit?: 'contain' | 'cover'
    layout?: 'fill' | 'legacy-gift'
    muted?: boolean
    url: string
  }>(),
  {
    fit: 'contain',
    layout: 'fill',
    muted: true,
  },
)

const emit = defineEmits<{
  error: []
  finished: []
  started: []
}>()

const container = ref<HTMLDivElement | null>(null)
let generation = 0
let startedGeneration = 0
let svgaPlayer: SvgaPlayer | null = null
let evaPlayer: YYEvaType | null = null

function effectType(url: string): 'mp4' | 'svga' | null {
  const normalized = url.trim().toLowerCase().split(/[?#]/u, 1)[0] ?? ''
  if (normalized.endsWith('.svga')) return 'svga'
  if (normalized.endsWith('.mp4')) return 'mp4'
  return null
}

function clearContainer(): void {
  try {
    svgaPlayer?.stopAnimation(true)
    svgaPlayer?.clear()
  } catch {
    // 播放器可能正在异步解码；销毁流程必须继续。
  }
  try {
    evaPlayer?.destroy()
  } catch {
    // YYEVA 内部可能已在播放结束时自行释放。
  }
  svgaPlayer = null
  evaPlayer = null
  container.value?.replaceChildren()
}

async function play(url: string): Promise<void> {
  const currentGeneration = ++generation
  const requestedAt = performance.now()
  clearContainer()
  const target = container.value
  const type = effectType(url)
  if (!target || !type) {
    if (url.trim()) emit('error')
    return
  }

  const prepared = await acquireGiftEffectAsset(url)
  if (currentGeneration !== generation || target !== container.value) return

  const markStarted = (): void => {
    if (currentGeneration !== generation || startedGeneration === currentGeneration) return
    startedGeneration = currentGeneration
    reportRuntimeMetric('gift.effect.start-latency', Math.round(performance.now() - requestedAt), {
      kind: type,
      muted: props.muted,
      prepared: Boolean(prepared),
    })
    emit('started')
  }

  if (type === 'svga') {
    const { Parser: SvgaParser, Player } = await loadSvgaRuntime()
    if (currentGeneration !== generation || target !== container.value) return
    const player = new Player(target)
    svgaPlayer = player
    player.loops = 1
    player.clearsAfterStop = true
    player.setContentMode(props.fit === 'cover' ? 'AspectFill' : 'AspectFit')
    // Match the legacy live-room player: authored coordinates are fitted as one
    // surface and clipped at its bounds. Letting sprites escape the surface makes
    // some gifts appear vertically or horizontally displaced.
    player.setClipsToBounds(true)
    player.onFinished(() => {
      if (currentGeneration === generation) emit('finished')
    })
    const start = (video: Parameters<SvgaPlayer['setVideoItem']>[0]): void => {
      if (currentGeneration !== generation || player !== svgaPlayer) return
      player.setVideoItem(video)
      player.startAnimation()
      markStarted()
    }
    if (prepared?.kind === 'svga') start(prepared.video)
    else
      new SvgaParser().load(url, start, () => {
        if (currentGeneration === generation) emit('error')
      })
    return
  }

  let evaFallbackStarted = false
  const playEva = async (usePreparedFile: boolean): Promise<void> => {
    const { yyEva } = await loadEvaEffectRuntime()
    if (currentGeneration !== generation || target !== container.value) return
    const source = usePreparedFile && prepared?.kind === 'mp4' ? prepared.file : url
    const player = await yyEva({
      autoplay: true,
      checkTimeout: true,
      container: target,
      hevcUrl: source,
      loop: 1,
      mode: props.fit === 'cover' ? 'AspectFill' : 'AspectFit',
      mute: props.muted,
      onEnd: () => {
        if (currentGeneration === generation) emit('finished')
      },
      onError: () => {
        if (currentGeneration !== generation) return
        if (usePreparedFile) {
          if (evaFallbackStarted) return
          evaFallbackStarted = true
          evaPlayer = null
          target.replaceChildren()
          void playEva(false).catch(() => {
            if (currentGeneration === generation) emit('error')
          })
          return
        }
        emit('error')
      },
      // 真机禁止带声自动播放时，YYEVA 会自动降级为静音播放；不要再渲染其
      // 默认点击播放层，否则礼物队列会被一个不可操作的浮层阻塞。
      onRequestClickPlay: () => undefined,
      onStart: markStarted,
      showPlayerInfo: false,
      useVideoDBCache: typeof source === 'string',
      videoUrl: source,
    })
    if (currentGeneration !== generation) {
      player.destroy()
      return
    }
    evaPlayer = player
    player.start()
  }

  try {
    await playEva(prepared?.kind === 'mp4')
  } catch {
    if (currentGeneration !== generation) return
    if (prepared?.kind === 'mp4' && !evaFallbackStarted) {
      evaFallbackStarted = true
      target.replaceChildren()
      try {
        await playEva(false)
        return
      } catch {
        // Fall through to the player error event after both prepared and URL paths fail.
      }
    }
    if (currentGeneration === generation) emit('error')
  }
}

watch(
  () => [props.fit, props.muted, props.url] as const,
  ([, , url]) => {
    if (container.value) void play(url)
  },
  { flush: 'post' },
)

onMounted(() => void play(props.url))

onBeforeUnmount(() => {
  generation += 1
  clearContainer()
})
</script>

<template>
  <div
    ref="container"
    class="live-effect-player"
    :class="`live-effect-player--${layout}`"
    aria-hidden="true"
  />
</template>

<style scoped lang="less">
.live-effect-player {
  width: 100%;
  overflow: visible;
  pointer-events: none;
}

.live-effect-player--fill {
  height: 100%;
}

.live-effect-player--legacy-gift {
  height: 100%;
}

.live-effect-player :deep(canvas) {
  display: block;
  width: 100% !important;
  height: 100% !important;
  max-width: none;
  pointer-events: none;
}
</style>

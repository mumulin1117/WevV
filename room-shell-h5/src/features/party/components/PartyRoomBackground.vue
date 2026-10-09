<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, ref, watch } from 'vue'
import type { Player as SvgaPlayer } from 'svgaplayerweb'
import { loadSvgaRuntime } from '@/core/media/svga-runtime'
import { loadSvgaVideo } from '@/core/media/svga-video-cache'

const props = defineProps<{
  active: boolean
  source: string
}>()

const videoSource = computed(() => (/\.mp4(?:[?#]|$)/iu.test(props.source) ? props.source : ''))
const svgaSource = computed(() => (/\.svga(?:[?#]|$)/iu.test(props.source) ? props.source : ''))
const video = ref<HTMLVideoElement | null>(null)
const svgaContainer = ref<HTMLDivElement | null>(null)
let generation = 0
let player: SvgaPlayer | null = null

function syncVideoPlayback(): void {
  const target = video.value
  if (!target) return
  if (!props.active) {
    target.pause()
    return
  }
  void target.play().catch(() => {
    // The static room background remains visible if the WebView cannot resume the video.
  })
}

function syncSvgaPlayback(): void {
  if (!player) return
  try {
    if (props.active) player.startAnimation()
    else player.pauseAnimation()
  } catch {
    // Native lifecycle callbacks can race with SVGA parser completion; the next sync retries.
  }
}

function clearSvgaPlayer(): void {
  generation += 1
  try {
    player?.stopAnimation(true)
    player?.clear()
  } catch {
    // A late parser callback must not prevent DOM cleanup.
  }
  player = null
  svgaContainer.value?.replaceChildren()
}

async function renderSvga(source: string): Promise<void> {
  clearSvgaPlayer()
  if (!source) return
  const currentGeneration = generation
  await nextTick()
  const target = svgaContainer.value
  if (!target || currentGeneration !== generation) return
  try {
    const [asset, { Player }] = await Promise.all([loadSvgaVideo(source), loadSvgaRuntime()])
    if (!target.isConnected || currentGeneration !== generation || target !== svgaContainer.value)
      return
    const nextPlayer = new Player(target)
    player = nextPlayer
    nextPlayer.loops = 0
    nextPlayer.clearsAfterStop = false
    nextPlayer.setContentMode('AspectFill')
    nextPlayer.setClipsToBounds(true)
    nextPlayer.setVideoItem(asset)
    syncSvgaPlayback()
  } catch {
    if (currentGeneration === generation) clearSvgaPlayer()
  }
}

watch(videoSource, () => void nextTick(syncVideoPlayback), { immediate: true })
watch(svgaSource, (source) => void renderSvga(source), { immediate: true })
watch(
  () => props.active,
  () => {
    syncVideoPlayback()
    syncSvgaPlayback()
  },
)

onBeforeUnmount(clearSvgaPlayer)
</script>

<template>
  <div v-if="videoSource || svgaSource" aria-hidden="true" class="party-room-background">
    <video
      v-if="videoSource"
      ref="video"
      autoplay
      loop
      muted
      playsinline
      :src="videoSource"
      @canplay="syncVideoPlayback"
      @loadeddata="syncVideoPlayback"
    />
    <div v-else ref="svgaContainer" class="party-room-background__svga" dir="ltr" />
  </div>
</template>

<style scoped lang="less">
.party-room-background,
.party-room-background > video,
.party-room-background__svga {
  position: absolute;
  z-index: -2;
  inset: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
  pointer-events: none;
}

.party-room-background > video {
  object-fit: cover;
}

.party-room-background__svga :deep(canvas) {
  width: 100% !important;
  height: 100% !important;
}
</style>

<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref } from 'vue'
import { publicAsset } from '@/core/media/public-asset'

const frame = ref(0)
let timer = 0
let _preloadedFrames: HTMLImageElement[] = []

onMounted(() => {
  _preloadedFrames = Array.from({ length: 49 }, (_, index) => {
    const image = new Image()
    image.src = publicAsset(`party/volume/volume_${index}.png`)
    return image
  })
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return
  timer = window.setInterval(() => {
    frame.value = (frame.value + 1) % 49
  }, 50)
})

onBeforeUnmount(() => {
  window.clearInterval(timer)
  _preloadedFrames = []
})
</script>

<template>
  <img
    class="party-speaking-frames"
    :src="publicAsset(`party/volume/volume_${frame}.png`)"
    alt=""
    aria-hidden="true"
  />
</template>

<style scoped lang="less">
.party-speaking-frames {
  position: absolute;
  z-index: 1;
  top: 50%;
  left: 50%;
  width: 74px;
  height: 74px;
  max-width: none;
  object-fit: contain;
  pointer-events: none;
  transform: translate(-50%, -50%);
}
</style>

<script setup lang="ts">
import { onBeforeUnmount, watch } from 'vue'
import LiveEffectPlayer from '@/features/rooms/components/LiveEffectPlayer.vue'
import AppImage from '@/main/components/AppImage.vue'

const props = defineProps<{ url: string }>()
const emit = defineEmits<{ finished: [] }>()

let fallbackTimer = 0

function isAnimation(value: string): boolean {
  return /\.(?:mp4|svga)(?:[?#]|$)/iu.test(value.trim())
}

function resetFallback(): void {
  window.clearTimeout(fallbackTimer)
  fallbackTimer = 0
  if (!props.url || isAnimation(props.url)) return
  fallbackTimer = window.setTimeout(() => emit('finished'), 3_000)
}

watch(() => props.url, resetFallback, { immediate: true })
onBeforeUnmount(() => window.clearTimeout(fallbackTimer))
</script>

<template>
  <LiveEffectPlayer
    v-if="isAnimation(url)"
    class="party-seat-expression"
    :url="url"
    @error="emit('finished')"
    @finished="emit('finished')"
  />
  <AppImage v-else class="party-seat-expression" :lazy="false" :src="url" />
</template>

<style scoped lang="less">
.party-seat-expression {
  width: 100%;
  height: 100%;
  overflow: visible;
  background: transparent;
  pointer-events: none;
}

.party-seat-expression :deep(img) {
  object-fit: contain;
}

// 麦位表情固定在头像画布内，避免 SVGA 内部缩放矩阵再次偏移画布。
.party-seat-expression :deep(canvas) {
  width: 100% !important;
  height: 100% !important;
  transform: none !important;
}
</style>

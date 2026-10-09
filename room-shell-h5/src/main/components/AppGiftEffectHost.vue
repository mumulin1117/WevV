<script setup lang="ts">
import { onBeforeUnmount, onMounted } from 'vue'
import LiveEffectPlayer from '@/features/rooms/components/LiveEffectPlayer.vue'
import AppImage from '@/main/components/AppImage.vue'
import {
  clearGiftEffects,
  fallbackGiftEffect,
  finishGiftEffect,
  giftEffectQueueState,
  startGiftEffect,
} from '@/shared/gifts/gift-effect-queue'

function finishCurrentEffect(): void {
  const id = giftEffectQueueState.current?.id
  if (id !== undefined) finishGiftEffect(id)
}

function handleCurrentEffectError(): void {
  const id = giftEffectQueueState.current?.id
  if (id !== undefined && fallbackGiftEffect(id)) return
  finishCurrentEffect()
}

function handleCurrentEffectStarted(): void {
  const id = giftEffectQueueState.current?.id
  if (id !== undefined) startGiftEffect(id)
}

function handleVisibilityChange(): void {
  if (document.visibilityState === 'hidden') clearGiftEffects()
}

onMounted(() => document.addEventListener('visibilitychange', handleVisibilityChange))
onBeforeUnmount(() => {
  document.removeEventListener('visibilitychange', handleVisibilityChange)
  clearGiftEffects()
})
</script>

<template>
  <Teleport to="body">
    <div
      v-if="giftEffectQueueState.current"
      class="app-gift-effect-host"
      :class="`app-gift-effect-host--${giftEffectQueueState.current.kind}`"
      aria-hidden="true"
    >
      <LiveEffectPlayer
        v-if="giftEffectQueueState.current.kind === 'fullscreen'"
        :key="giftEffectQueueState.current.id"
        :fit="giftEffectQueueState.current.fit"
        layout="legacy-gift"
        :muted="false"
        :url="giftEffectQueueState.current.url"
        @error="handleCurrentEffectError"
        @finished="finishCurrentEffect"
        @started="handleCurrentEffectStarted"
      />
      <AppImage
        v-else
        :key="giftEffectQueueState.current.id"
        alt=""
        class="app-gift-effect-host__normal-image"
        fit="contain"
        :lazy="false"
        priority
        :src="giftEffectQueueState.current.url"
        @animationend="finishCurrentEffect"
        @error="handleCurrentEffectError"
      />
    </div>
  </Teleport>
</template>

<style scoped lang="less">
.app-gift-effect-host {
  position: fixed;
  top: 0;
  left: 50%;
  z-index: var(--z-gift-effect);
  width: min(100vw, 600px);
  height: 100vh;
  height: 100dvh;
  transform: translateX(-50%);
  pointer-events: none;
}

.app-gift-effect-host--normal {
  display: grid;
  place-items: center;
}

.app-gift-effect-host__normal-image {
  width: min(40vw, 240px);
  height: min(40vw, 240px);
  background: transparent;
  animation: app-gift-zoom 1.5s ease-out forwards;
}

.app-gift-effect-host__normal-image :deep(.app-image__loading) {
  background: transparent;
}

@keyframes app-gift-zoom {
  0% {
    opacity: 0;
    transform: scale(0);
  }

  30%,
  70% {
    opacity: 1;
    transform: scale(1);
  }

  100% {
    opacity: 0;
  }
}

@media (prefers-reduced-motion: reduce) {
  .app-gift-effect-host__normal-image {
    animation-duration: 1ms;
  }
}
</style>

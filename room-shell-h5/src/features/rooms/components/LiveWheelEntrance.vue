<script setup lang="ts">
import { publicAsset } from '@/core/media/public-asset'
import { useI18n } from 'vue-i18n'

defineProps<{
  visible: boolean
}>()

const emit = defineEmits<{
  open: []
}>()

const { t } = useI18n()
</script>

<template>
  <Transition name="live-wheel-entrance">
    <button
      v-if="visible"
      class="live-wheel-entrance"
      type="button"
      :aria-label="t('room.liveWheelTitle')"
      @click.stop="emit('open')"
    >
      <img alt="" :src="publicAsset('live-room/wheel/icon.webp')" />
    </button>
  </Transition>
</template>

<style scoped lang="less">
.live-wheel-entrance {
  position: fixed;
  z-index: 13;
  top: calc(var(--safe-top) + 70px);
  right: 10px;
  display: grid;
  width: 50px;
  height: 50px;
  padding: 0;
  overflow: hidden;
  border: 0;
  border-radius: 10%;
  background: transparent;
  place-items: center;
}

.live-wheel-entrance img {
  width: 100%;
  height: 100%;
  border-radius: 10%;
  object-fit: cover;
}

.live-wheel-entrance-enter-active,
.live-wheel-entrance-leave-active {
  transition:
    opacity 160ms ease,
    transform 160ms ease;
}

.live-wheel-entrance-enter-from,
.live-wheel-entrance-leave-to {
  opacity: 0;
  transform: translateY(-8px) scale(0.92);
}
</style>

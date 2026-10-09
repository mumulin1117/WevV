<script setup lang="ts">
import { responsiveCssLength } from '@/main/ui/responsive-unit'

withDefaults(
  defineProps<{
    aspectRatio?: number | string
    height?: number | string
    radius?: number | string
    width?: number | string
  }>(),
  { aspectRatio: undefined, height: 16, radius: 8, width: '100%' },
)
</script>
<template>
  <span
    class="skeleton-block"
    aria-hidden="true"
    :style="{
      aspectRatio,
      borderRadius: responsiveCssLength(radius),
      height: responsiveCssLength(height),
      width: responsiveCssLength(width),
    }"
  />
</template>
<style scoped lang="less">
.skeleton-block {
  position: relative;
  display: block;
  flex: 0 0 auto;
  overflow: hidden;
  background: var(--skeleton-base);
  transform: translateZ(0);
}

.skeleton-block::after {
  position: absolute;
  inset: 0;
  background: var(--skeleton-shimmer);
  content: '';
  transform: translate3d(-100%, 0, 0);
  animation: skeleton-shimmer 1.6s linear infinite;
  will-change: transform;
}

@keyframes skeleton-shimmer {
  to {
    transform: translate3d(100%, 0, 0);
  }
}

@media (prefers-reduced-motion: reduce) {
  .skeleton-block::after {
    display: none;
  }
}
</style>

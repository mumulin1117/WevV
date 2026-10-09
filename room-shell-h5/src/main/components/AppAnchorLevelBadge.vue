<script setup lang="ts">
import { computed } from 'vue'
import { publicAsset } from '@/core/media/public-asset'
import { parseAnchorLevel } from './anchor-level'

const props = withDefaults(
  defineProps<{
    level?: string | null
    size?: 'l' | 'm' | 's'
  }>(),
  {
    level: null,
    size: 's',
  },
)

const grade = computed(() => parseAnchorLevel(props.level))
</script>

<template>
  <img
    v-if="grade"
    class="app-anchor-level-badge"
    :class="`is-${size}`"
    :alt="grade"
    :src="publicAsset(`home/top_${grade}_bg.webp`)"
  />
</template>

<style scoped lang="less">
.app-anchor-level-badge {
  display: block;
  flex: 0 0 auto;
  object-fit: contain;
}

.app-anchor-level-badge.is-s {
  width: 18px;
  height: 18px;
}

.app-anchor-level-badge.is-m {
  width: 32px;
  height: 32px;
}

.app-anchor-level-badge.is-l {
  width: 40px;
  height: 40px;
}
</style>

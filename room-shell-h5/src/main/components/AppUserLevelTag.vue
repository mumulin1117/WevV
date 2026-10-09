<script setup lang="ts">
import { computed } from 'vue'
import { publicAsset } from '@/core/media/public-asset'
import { parseUserLevel, type UserLevelInput } from './user-level'

const props = withDefaults(
  defineProps<{
    level?: UserLevelInput
    size?: 'm' | 's'
  }>(),
  {
    level: null,
    size: 'm',
  },
)

const numericLevel = computed(() => parseUserLevel(props.level))
const stage = computed(() => Math.min(10, Math.floor((numericLevel.value ?? 0) / 10)))
const label = computed(() => `Lv.${numericLevel.value ?? 0}`)
const tagStyle = computed(() => ({
  '--app-user-level-gradient': `var(--gradient-user-level-${stage.value})`,
  '--app-user-level-icon': `url(${publicAsset(`level/icon-lv-${stage.value}.webp`)})`,
}))
</script>

<template>
  <span
    v-if="numericLevel !== null"
    class="app-user-level-tag"
    :class="`is-${size}`"
    dir="ltr"
    :style="tagStyle"
  >
    <i aria-hidden="true" />
    <span>{{ label }}</span>
  </span>
</template>

<style scoped lang="less">
.app-user-level-tag {
  display: inline-flex;
  max-width: 100%;
  flex: 0 0 auto;
  align-items: center;
  overflow: hidden;
  border-radius: 999px;
  background: var(--app-user-level-gradient);
  color: var(--color-user-level-text);
  font-family:
    'TT Norms Pro',
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    sans-serif;
  font-weight: 800;
  white-space: nowrap;
}

.app-user-level-tag.is-m {
  height: 14px;
  gap: 1px;
  padding: 0 4px 0 3px;
  font-size: 8px;
  line-height: 14px;
}

.app-user-level-tag.is-m > i {
  width: 10px;
  height: 10px;
}

.app-user-level-tag.is-s {
  height: 12px;
  gap: 1px;
  padding: 0 3px 0 2px;
  font-size: 8px;
  line-height: 12px;
}

.app-user-level-tag.is-s > i {
  width: 9px;
  height: 9px;
}

.app-user-level-tag > i {
  flex: 0 0 auto;
  margin-top: -1px;
  background: var(--app-user-level-icon) center / contain no-repeat;
}

.app-user-level-tag > span {
  overflow: hidden;
  text-overflow: ellipsis;
}
</style>

<script setup lang="ts">
import { computed } from 'vue'
import defaultAvatar from '@/assets/ui/default-avatar.png'
import { responsiveCssLength } from '@/main/ui/responsive-unit'
import AppImage from './AppImage.vue'

const props = withDefaults(
  defineProps<{
    alt?: string
    lazy?: boolean
    online?: boolean
    priority?: boolean
    size?: number
    src?: string
  }>(),
  {
    alt: '',
    lazy: true,
    online: false,
    priority: false,
    size: 48,
    src: '',
  },
)

const avatarStyle = computed(() => {
  const size = responsiveCssLength(props.size)
  return { height: size, width: size }
})
</script>

<template>
  <span class="avatar" :style="avatarStyle">
    <AppImage
      :alt="alt"
      :fallback-src="defaultAvatar"
      :height="size"
      :lazy="lazy"
      :priority="priority"
      radius="50%"
      :src="src"
      :width="size"
    >
      <template #loading>
        <img aria-hidden="true" class="avatar__fallback" :src="defaultAvatar" />
      </template>
      <template #error>
        <img aria-hidden="true" class="avatar__fallback" :src="defaultAvatar" />
      </template>
      <template #empty>
        <img aria-hidden="true" class="avatar__fallback" :src="defaultAvatar" />
      </template>
    </AppImage>
    <i v-if="online" class="avatar__online" aria-label="Online" />
  </span>
</template>

<style scoped lang="less">
.avatar {
  position: relative;
  display: inline-flex;
  flex: 0 0 auto;
}

.avatar :deep(.app-image) {
  border: 1px solid var(--color-border);
  background: transparent;
}

.avatar__fallback {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.avatar__online {
  position: absolute;
  right: 1px;
  bottom: 1px;
  width: 22%;
  min-width: 9px;
  aspect-ratio: 1;
  border: 2px solid var(--color-surface);
  border-radius: 50%;
  background: var(--color-success);
}
</style>

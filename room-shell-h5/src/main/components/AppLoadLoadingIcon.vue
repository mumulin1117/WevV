<script setup lang="ts">
import { publicAsset } from '@/core/media/public-asset'
import { responsiveCssLength } from '@/main/ui/responsive-unit'
import { computed, ref } from 'vue'

const props = withDefaults(defineProps<{ animated?: boolean; size?: number }>(), {
  animated: false,
  size: 60,
})

const imageFailed = ref(false)
const size = computed(() => responsiveCssLength(props.size))
</script>
<template>
  <span
    class="load-icon"
    :data-animated="animated || undefined"
    :style="{ height: size, width: size }"
    aria-hidden="true"
  >
    <img
      :class="['load-icon__image', { 'load-icon__image--failed': imageFailed }]"
      :src="publicAsset('common/app-loading.svg')"
      alt=""
      decoding="sync"
      draggable="false"
      fetchpriority="high"
      @error="imageFailed = true"
    />
  </span>
</template>
<style scoped lang="less">
.load-icon {
  position: relative;
  display: inline-grid;
  flex: 0 0 auto;
  place-items: center;
  object-fit: contain;
  transform: translateZ(0);
}

.load-icon__image {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.load-icon__image--failed {
  visibility: hidden;
}
</style>

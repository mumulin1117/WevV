<script setup lang="ts">
import { computed, inject, onActivated, onDeactivated, onMounted, ref } from 'vue'
import { useGlobalLoadingSource } from '@/main/composables/useGlobalLoadingSource'
import AppLoadLoadingIcon from './AppLoadLoadingIcon.vue'
import { appPopupContextKey } from './app-popup-context'

defineOptions({ inheritAttrs: false })

const props = withDefaults(defineProps<{ active?: boolean; scope?: 'auto' | 'page' }>(), {
  active: true,
  scope: 'auto',
})
const pageActive = ref(true)
const root = ref<HTMLElement | null>(null)
const mounted = ref(false)
const insidePopup = ref(inject(appPopupContextKey, false))

onMounted(() => {
  insidePopup.value ||= Boolean(
    root.value?.closest('.app-popup-host, .party-sheet-host, .app-action-sheet-host'),
  )
  mounted.value = true
})

onActivated(() => {
  pageActive.value = true
})
onDeactivated(() => {
  pageActive.value = false
})

useGlobalLoadingSource(
  computed(
    () =>
      mounted.value &&
      (!insidePopup.value || props.scope === 'page') &&
      props.active &&
      pageActive.value,
  ),
)
</script>
<template>
  <div
    v-if="insidePopup && scope === 'auto' && active"
    ref="root"
    class="popup-loading"
    role="status"
    aria-label="Loading"
  >
    <AppLoadLoadingIcon animated :size="60" />
  </div>
  <div v-else ref="root" class="loading-placeholder" aria-hidden="true" />
</template>
<style scoped lang="less">
.popup-loading {
  display: grid;
  width: 100%;
  min-height: 160px;
  place-items: center;
}

.loading-placeholder {
  display: none;
}
</style>

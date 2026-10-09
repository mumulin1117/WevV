<script setup lang="ts">
import AppEmptyState from './AppEmptyState.vue'
import AppLoading from './AppLoading.vue'
withDefaults(
  defineProps<{
    description?: string
    loadingActive?: boolean
    size?: 'page' | 'popup'
    state: 'content' | 'empty' | 'error' | 'loading' | 'offline'
    title?: string
  }>(),
  { description: '', loadingActive: true, size: 'page', title: '' },
)
defineEmits<{ retry: [] }>()
</script>
<template>
  <AppLoading v-if="state === 'loading'" :active="loadingActive" />
  <AppEmptyState v-else-if="state === 'empty'" :size="size" />
  <AppEmptyState
    v-else-if="state === 'offline'"
    action="Try again"
    :description="description || 'Check your internet connection.'"
    :size="size"
    :title="title || 'You’re offline'"
    variant="feedback"
    @action="$emit('retry')"
  />
  <AppEmptyState
    v-else-if="state === 'error'"
    action="Try again"
    :description="description || 'We couldn’t load this content.'"
    :size="size"
    :title="title || 'Something went wrong'"
    variant="feedback"
    @action="$emit('retry')"
  />
  <slot v-else />
</template>

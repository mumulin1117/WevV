<script setup lang="ts">
type PartySegmentedTabKey = number | string

defineProps<{
  items: readonly { key: PartySegmentedTabKey; label: string }[]
  label: string
  modelValue: PartySegmentedTabKey
}>()

const emit = defineEmits<{
  'update:modelValue': [value: PartySegmentedTabKey]
}>()
</script>

<template>
  <nav class="party-segmented-tabs" :aria-label="label" role="tablist">
    <button
      v-for="item in items"
      :key="item.key"
      :aria-selected="modelValue === item.key"
      :class="{ 'is-active': modelValue === item.key }"
      role="tab"
      :tabindex="modelValue === item.key ? 0 : -1"
      type="button"
      @click="emit('update:modelValue', item.key)"
    >
      {{ item.label }}
    </button>
  </nav>
</template>

<style scoped lang="less">
.party-segmented-tabs {
  display: grid;
  width: 100%;
  height: 40px;
  min-width: 0;
  flex: 0 0 40px;
  grid-auto-columns: minmax(0, 1fr);
  grid-auto-flow: column;
  overflow: hidden;
  border-radius: 999px;
  background: var(--color-party-music-tabs);
}

.party-segmented-tabs button {
  min-width: 0;
  padding: 0 8px;
  border: 0;
  border-radius: 999px;
  background: transparent;
  color: var(--color-party-panel-muted);
  cursor: pointer;
  font-size: 13px;
  font-weight: 600;
  overflow: hidden;
  text-overflow: ellipsis;
  transition:
    background 220ms cubic-bezier(0.2, 0, 0, 1),
    color 220ms cubic-bezier(0.2, 0, 0, 1);
  white-space: nowrap;
}

.party-segmented-tabs button.is-active {
  background: var(--gradient-primary);
  color: var(--color-text);
  font-weight: 800;
}

.party-segmented-tabs button:focus-visible {
  outline: 2px solid var(--color-secondary);
  outline-offset: -2px;
}

@media (prefers-reduced-motion: reduce) {
  .party-segmented-tabs button {
    transition: none;
  }
}
</style>

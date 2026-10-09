<script setup lang="ts" generic="T extends { id: string | number }">
import { nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue'

const props = withDefaults(
  defineProps<{
    earlierLabel?: string
    items: T[]
    loading?: boolean
    more?: boolean
  }>(),
  {
    earlierLabel: 'Earlier messages',
    loading: false,
    more: false,
  },
)
const emit = defineEmits<{ loadEarlier: [] }>()
const scroller = ref<HTMLElement | null>(null)
const content = ref<HTMLElement | null>(null)
const stickToBottom = ref(true)
let previousHeight = 0
let previousFirst = ''
let resizeObserver: ResizeObserver | undefined

function isNearBottom(node: HTMLElement): boolean {
  return node.scrollHeight - node.scrollTop - node.clientHeight < 80
}

function handleScroll(): void {
  if (scroller.value) stickToBottom.value = isNearBottom(scroller.value)
}

function loadEarlier(): void {
  if (!props.loading && props.more && scroller.value) {
    previousHeight = scroller.value.scrollHeight
    previousFirst = String(props.items[0]?.id ?? '')
    emit('loadEarlier')
  }
}

async function scrollToBottom(force = false, behavior: ScrollBehavior = 'auto'): Promise<void> {
  await nextTick()
  const node = scroller.value
  if (!node || (!force && !stickToBottom.value)) return
  node.scrollTo({ behavior, top: node.scrollHeight })
  stickToBottom.value = true
}

watch(
  () => props.items[0]?.id,
  async (first) => {
    await nextTick()
    if (previousFirst && String(first ?? '') !== previousFirst && scroller.value) {
      scroller.value.scrollTop += scroller.value.scrollHeight - previousHeight
    }
    previousFirst = ''
  },
)

watch(
  () => props.items.at(-1)?.id,
  () => void scrollToBottom(),
)

onMounted(() => {
  void scrollToBottom(true)
  if (content.value && typeof ResizeObserver !== 'undefined') {
    resizeObserver = new ResizeObserver(() => void scrollToBottom())
    resizeObserver.observe(content.value)
  }
})

onBeforeUnmount(() => resizeObserver?.disconnect())

defineExpose({
  getScrollElement: () => scroller.value,
  isNearBottom: () => (scroller.value ? isNearBottom(scroller.value) : true),
  scrollToBottom,
  stickToBottom,
})
</script>

<template>
  <div ref="scroller" class="reverse-list" @scroll.passive="handleScroll">
    <button
      v-if="more"
      class="reverse-list__earlier"
      :disabled="loading"
      type="button"
      @click="loadEarlier"
    >
      {{ loading ? 'Loading…' : earlierLabel }}
    </button>
    <div ref="content" class="reverse-list__items">
      <slot name="before" />
      <div v-for="(item, index) in items" :key="item.id" data-message-anchor>
        <slot :index="index" :item="item" />
      </div>
    </div>
  </div>
</template>

<style scoped lang="less">
.reverse-list {
  width: 100%;
  height: 100%;
  overflow: hidden auto;
  overscroll-behavior: contain;
  scrollbar-width: none;
  -webkit-overflow-scrolling: touch;
}

.reverse-list::-webkit-scrollbar {
  display: none;
}

.reverse-list__items {
  display: flex;
  min-height: calc(100% - 48px);
  flex-direction: column;
  justify-content: flex-end;
  padding: 16px;
  padding-bottom: calc(16px + var(--app-page-content-bottom-inset, 0));
}

.reverse-list__items > div {
  display: flex;
  min-width: 0;
  flex-direction: column;
}

.reverse-list__earlier {
  display: block;
  min-height: 36px;
  margin: 8px auto;
  padding: 0 16px;
  border: 0;
  border-radius: 20px;
  background: var(--color-surface);
  color: var(--color-primary);
}
</style>

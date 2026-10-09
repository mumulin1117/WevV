<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import imageError from '@/assets/ui/image-error.png'
import { resolveImageUrl } from '@/core/media/image-cdn'
import { useAppOverlay } from '@/main/ui/overlay'
import { responsiveCssLength } from '@/main/ui/responsive-unit'

type ImageFit = 'contain' | 'cover' | 'fill' | 'none' | 'scale-down'
type ImageState = 'empty' | 'error' | 'loaded' | 'loading'

const props = withDefaults(
  defineProps<{
    alt?: string
    aspectRatio?: string
    errorText?: string
    fallbackSrc?: string
    fit?: ImageFit
    height?: number | string
    lazy?: boolean
    preview?: boolean
    previewList?: string[]
    priority?: boolean
    radius?: string
    showErrorText?: boolean
    src?: string
    width?: number | string
  }>(),
  {
    alt: '',
    aspectRatio: '',
    errorText: 'Image unavailable',
    fallbackSrc: '',
    fit: 'cover',
    height: undefined,
    lazy: true,
    preview: false,
    previewList: undefined,
    priority: false,
    radius: '0px',
    showErrorText: false,
    src: '',
    width: undefined,
  },
)

const emit = defineEmits<{
  error: []
  load: []
  stateChange: [state: ImageState]
}>()

const overlay = useAppOverlay()
const attempt = ref(0)
const activeSrc = ref('')
const fallbackAttempted = ref(false)
const state = ref<ImageState>('empty')

const style = computed(() => ({
  aspectRatio: props.aspectRatio || undefined,
  borderRadius: responsiveCssLength(props.radius),
  height: responsiveCssLength(props.height),
  width: responsiveCssLength(props.width),
}))
const imageKey = computed(() => `${activeSrc.value}:${attempt.value}`)
const resolvedSrc = computed(() => resolveImageUrl(props.src))
const resolvedFallbackSrc = computed(() => resolveImageUrl(props.fallbackSrc))
const canPreview = computed(
  () =>
    props.preview &&
    state.value === 'loaded' &&
    Boolean(resolvedSrc.value) &&
    activeSrc.value === resolvedSrc.value,
)

function updateState(nextState: ImageState): void {
  if (state.value === nextState) return
  state.value = nextState
  emit('stateChange', nextState)
}

function resetSource(): void {
  attempt.value = 0
  fallbackAttempted.value = false
  activeSrc.value = resolvedSrc.value || resolvedFallbackSrc.value
  updateState(activeSrc.value ? 'loading' : 'empty')
}

function handleLoad(): void {
  updateState('loaded')
  emit('load')
}

function handleError(): void {
  if (
    !fallbackAttempted.value &&
    resolvedFallbackSrc.value &&
    activeSrc.value !== resolvedFallbackSrc.value
  ) {
    fallbackAttempted.value = true
    activeSrc.value = resolvedFallbackSrc.value
    attempt.value += 1
    updateState('loading')
    return
  }

  updateState('error')
  emit('error')
}

function retry(): void {
  if (!resolvedSrc.value && !resolvedFallbackSrc.value) return
  fallbackAttempted.value = false
  activeSrc.value = resolvedSrc.value || resolvedFallbackSrc.value
  attempt.value += 1
  updateState('loading')
}

function previewImage(): void {
  if (!canPreview.value) return
  const images = (props.previewList?.filter(Boolean) ?? [props.src]).map(resolveImageUrl)
  void overlay.previewImages({
    images,
    startIndex: Math.max(0, images.indexOf(resolvedSrc.value)),
  })
}

watch(() => [props.fallbackSrc, props.src], resetSource, { immediate: true })

defineExpose({ retry, state })
</script>

<template>
  <div
    class="app-image"
    :class="{
      'app-image--preview': canPreview,
      'is-error': state === 'error',
      'is-loading': state === 'loading',
    }"
    :style="style"
    @click="previewImage"
  >
    <VanImage
      v-if="activeSrc"
      :key="imageKey"
      :alt="alt"
      decoding="async"
      :fit="fit"
      :lazy-load="priority ? false : lazy"
      :src="activeSrc"
      @error="handleError"
      @load="handleLoad"
    >
      <template #loading>
        <slot name="loading">
          <div class="app-image__loading" aria-hidden="true">
            <span />
          </div>
        </slot>
      </template>
      <template #error>
        <slot name="error" :retry="retry">
          <div class="app-image__error" role="img" :aria-label="errorText">
            <img :src="imageError" alt="" />
            <span v-if="showErrorText">{{ errorText }}</span>
          </div>
        </slot>
      </template>
    </VanImage>

    <slot v-else name="empty">
      <div class="app-image__empty" role="img" :aria-label="alt || 'No image'">
        <svg aria-hidden="true" viewBox="0 0 24 24">
          <path d="M4 5h16v14H4zM4 16l4.5-4.5 3.5 3.5 2-2 6 6M16 9h.01" />
        </svg>
      </div>
    </slot>
  </div>
</template>

<style scoped lang="less">
.app-image {
  position: relative;
  flex: 0 0 auto;
  overflow: hidden;
  // background: var(--skeleton-base);
  contain: layout paint;
}

.app-image--preview {
  cursor: pointer;
}

.app-image :deep(.van-image),
.app-image :deep(.van-image__img),
.app-image :deep(.van-image__loading),
.app-image :deep(.van-image__error) {
  width: 100%;
  height: 100%;
}

.app-image :deep(.van-image) {
  display: block;
}

.app-image__loading,
.app-image__empty,
.app-image__error {
  display: grid;
  width: 100%;
  height: 100%;
  min-height: 40px;
  place-items: center;
  background: var(--skeleton-surface);
}

.app-image__loading {
  position: relative;
  overflow: hidden;
}

.app-image__loading::after {
  position: absolute;
  inset: 0;
  background: var(--skeleton-shimmer);
  content: '';
  transform: translate3d(-100%, 0, 0);
  animation: image-shimmer 1.6s linear infinite;
  will-change: transform;
}

.app-image__loading span {
  width: 30%;
  max-width: 42px;
  min-width: 22px;
  aspect-ratio: 1;
  border-radius: 50%;
  background: color-mix(in srgb, var(--skeleton-highlight) 52%, transparent);
}

.app-image__error {
  align-content: center;
  gap: 6px;
  color: var(--color-text-muted);
  font-size: 11px;
  text-align: center;
}

.app-image__error img {
  width: min(48px, 42%);
  height: min(48px, 42%);
  object-fit: contain;
  opacity: 0.68;
}

.app-image__empty svg {
  width: min(34px, 36%);
  color: var(--color-text-subtle);
  fill: none;
  opacity: 0.52;
  stroke: currentColor;
  stroke-linecap: round;
  stroke-linejoin: round;
  stroke-width: 1.6;
}

@keyframes image-shimmer {
  to {
    transform: translate3d(100%, 0, 0);
  }
}

@media (prefers-reduced-motion: reduce) {
  .app-image__loading::after {
    display: none;
  }
}
</style>

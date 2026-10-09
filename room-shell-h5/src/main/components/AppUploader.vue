<script setup lang="ts">
import { onBeforeUnmount, ref, useAttrs } from 'vue'
import AppIcon, { type AppIconName } from './AppIcon.vue'
import { MediaPipeline } from '@/features/media/media-pipeline'

defineOptions({ inheritAttrs: false })

const props = withDefaults(
  defineProps<{
    accept?: string
    disabled?: boolean
    icon?: AppIconName
    label?: string
    maxSizeMb?: number
    multiple?: boolean
  }>(),
  {
    accept: 'image/*',
    disabled: false,
    icon: 'image',
    label: 'Add media',
    maxSizeMb: 12,
    multiple: false,
  },
)
const emit = defineEmits<{
  error: [message: string]
  processed: [files: { blob: Blob; hash: string; height: number; name: string; width: number }[]]
}>()
const input = ref<HTMLInputElement | null>(null)
const attrs = useAttrs()
const processing = ref(false)
const pipeline = new MediaPipeline()
const MAX_SOURCE_SIZE_MB = 64
async function change(event: Event): Promise<void> {
  const files = [...((event.target as HTMLInputElement).files ?? [])]
  if (!files.length) return
  processing.value = true
  try {
    if (files.some((file) => file.size > MAX_SOURCE_SIZE_MB * 1024 * 1024))
      throw new Error(`Each source image must be under ${MAX_SOURCE_SIZE_MB} MB.`)
    const results = []
    for (const file of files) {
      const result = await pipeline.processImage(file)
      if (result.blob.size > props.maxSizeMb * 1024 * 1024)
        throw new Error(`Each prepared image must be under ${props.maxSizeMb} MB.`)
      results.push({ ...result, name: file.name })
    }
    emit('processed', results)
  } catch (error) {
    emit('error', error instanceof Error ? error.message : 'Upload preparation failed.')
  } finally {
    processing.value = false
    if (input.value) input.value.value = ''
  }
}
onBeforeUnmount(() => pipeline.dispose())
</script>
<template>
  <button
    v-bind="attrs"
    class="uploader"
    :disabled="disabled || processing"
    type="button"
    @click="input?.click()"
  >
    <AppLoading v-if="processing" /><AppIcon v-else :name="icon" :size="24" /><span
      v-if="processing || label"
      >{{ processing ? 'Preparing…' : label }}</span
    >
  </button>
  <input ref="input" :accept="accept" hidden :multiple="multiple" type="file" @change="change" />
</template>
<style scoped>
.uploader {
  display: grid;
  min-height: 112px;
  place-content: center;
  justify-items: center;
  gap: 8px;
  border: 1px dashed color-mix(in srgb, var(--color-primary) 44%, var(--color-border));
  border-radius: 8px;
  background: color-mix(in srgb, var(--color-primary) 5%, var(--color-surface));
  color: var(--color-primary);
  font-weight: 650;
}

.uploader:disabled {
  opacity: 0.55;
}
</style>

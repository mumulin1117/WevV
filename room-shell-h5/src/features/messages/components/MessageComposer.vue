<script setup lang="ts">
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { publicAsset } from '@/core/media/public-asset'

const props = withDefaults(
  defineProps<{
    disabled?: boolean
    modelValue: string
    sendingImage?: boolean
    showImage?: boolean
  }>(),
  { disabled: false, sendingImage: false, showImage: true },
)
const emit = defineEmits<{
  blur: []
  focus: []
  gift: []
  image: []
  send: [value: string]
  'update:modelValue': [value: string]
}>()
const { t } = useI18n()
const composing = ref(false)
const field = ref<HTMLElement | null>(null)

function handleEnter(event: KeyboardEvent): void {
  if (composing.value || event.isComposing || event.shiftKey) return
  event.preventDefault()
  const value = props.modelValue.trim()
  if (value && !props.disabled) emit('send', value)
}

function handleFocus(): void {
  emit('focus')
}

function handleBlur(): void {
  emit('blur')
}

function focus(): void {
  field.value?.querySelector<HTMLTextAreaElement>('textarea')?.focus()
}

defineExpose({ focus })
</script>

<template>
  <div class="message-composer">
    <div ref="field" class="message-composer__field">
      <VanField
        :autosize="{ maxHeight: 92, minHeight: 22 }"
        autocapitalize="sentences"
        autocorrect="on"
        :disabled="disabled"
        enterkeyhint="send"
        :maxlength="2000"
        :model-value="modelValue"
        :placeholder="t('messages.inputPlaceholder')"
        rows="1"
        :spellcheck="true"
        type="textarea"
        @blur="handleBlur"
        @compositionend="composing = false"
        @compositionstart="composing = true"
        @focus="handleFocus"
        @keydown.enter="handleEnter"
        @update:model-value="emit('update:modelValue', String($event))"
      />
      <button
        v-if="showImage"
        :disabled="disabled || sendingImage"
        type="button"
        :aria-label="t('messages.sendImage')"
        @click="emit('image')"
      >
        <AppLoading v-if="sendingImage" />
        <img v-else :src="publicAsset('messages/chat_upload_icon.png')" alt="" />
      </button>
    </div>
    <button class="message-composer__gift" :disabled="disabled" type="button" @click="emit('gift')">
      <img :src="publicAsset('common/gift_icon.png')" alt="" />
      <span class="sr-only">{{ t('messages.sendGift') }}</span>
    </button>
  </div>
</template>

<style scoped lang="less">
.message-composer {
  display: flex;
  align-items: center;
  gap: 8px;
  // AppPage Footer 已负责宿主安全区；6px 与 Footer 默认 8px 合成蓝湖的 14px 内容边距。
  padding: 9px 6px 3px;
  border: 0;
  background: var(--color-message-bg);
}

.message-composer__field {
  display: flex;
  min-width: 0;
  min-height: 44px;
  flex: 1;
  align-items: center;
  gap: 8px;
  padding: 0 8px 0 5px;
  border-radius: 24px;
  background: var(--color-message-bubble);
}

.message-composer :deep(.van-field) {
  --van-cell-horizontal-padding: 11px;
  --van-cell-vertical-padding: 10px;

  min-width: 0;
  flex: 1;
  border: 0;
  background: transparent;
  color: var(--color-text);
  font-size: 13px;
}

.message-composer :deep(.van-field::after) {
  display: none;
}

.message-composer :deep(.van-field__control) {
  color: var(--color-text);
  line-height: 22px;
  scrollbar-width: none;
}

.message-composer :deep(.van-field__control::-webkit-scrollbar) {
  display: none;
}

.message-composer :deep(.van-field__control::placeholder) {
  color: var(--color-text-subtle);
}

.message-composer button {
  display: grid;
  flex: 0 0 auto;
  padding: 0;
  place-items: center;
  border: 0;
  border-radius: 50%;
  background: transparent;
}

.message-composer__field button {
  width: 30px;
  height: 30px;
}

.message-composer__field img {
  width: 30px;
  height: 30px;
}

.message-composer__gift {
  width: 40px;
  height: 40px;
}

.message-composer__gift img {
  width: 27px;
  height: 27px;
  object-fit: contain;
}

.message-composer button:active:not(:disabled) {
  transform: scale(0.94);
  opacity: 0.82;
}

.message-composer button:disabled,
.message-composer :deep(.van-field--disabled) {
  opacity: 0.48;
}

.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
}
</style>

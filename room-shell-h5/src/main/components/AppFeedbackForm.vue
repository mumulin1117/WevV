<script setup lang="ts">
import { computed, useId } from 'vue'
import { useI18n } from 'vue-i18n'
import { publicAsset } from '@/core/media/public-asset'
import AppIcon from './AppIcon.vue'
import AppImage from './AppImage.vue'
import AppUploader from './AppUploader.vue'

const props = withDefaults(
  defineProps<{
    categories: readonly { label: string; value: string }[]
    category: string
    description: string
    descriptionMaxLength?: number
    email: string
    formId?: string
    pictures: readonly string[]
    showSubmit?: boolean
    submitDisabled?: boolean
    submitting?: boolean
    uploadDisabled?: boolean
    variant?: 'page' | 'sheet'
  }>(),
  {
    descriptionMaxLength: 200,
    formId: '',
    showSubmit: true,
    submitDisabled: false,
    submitting: false,
    uploadDisabled: false,
    variant: 'page',
  },
)

const emit = defineEmits<{
  processed: [files: { blob: Blob; hash: string; height: number; name: string; width: number }[]]
  removePicture: [index: number]
  submit: []
  'update:category': [value: string]
  'update:description': [value: string]
  'update:email': [value: string]
  uploadError: [message: string]
}>()

const { t } = useI18n()
const generatedFormId = useId()
const effectiveFormId = computed(() => props.formId || generatedFormId)
const emailId = computed(() => `${effectiveFormId.value}-email`)

function inputValue(event: Event): string {
  return (event.target as HTMLInputElement | HTMLTextAreaElement).value
}
</script>

<template>
  <form
    :id="effectiveFormId"
    class="app-feedback-form"
    :class="`app-feedback-form--${variant}`"
    :aria-busy="submitting || uploadDisabled"
    @submit.prevent="emit('submit')"
  >
    <div class="app-feedback-form__categories" :aria-label="t('feedbackPage.category')">
      <button
        v-for="item in categories"
        :key="item.value"
        :aria-pressed="category === item.value"
        :class="{ 'is-active': category === item.value }"
        :disabled="submitting"
        type="button"
        @click="emit('update:category', item.value)"
      >
        {{ item.label }}
      </button>
    </div>

    <label class="app-feedback-form__textarea">
      <span class="sr-only">{{ t('feedbackPage.description') }}</span>
      <textarea
        :maxlength="descriptionMaxLength"
        :placeholder="t('feedbackPage.descriptionPlaceholder')"
        rows="7"
        :value="description"
        @input="emit('update:description', inputValue($event))"
      />
    </label>

    <label class="app-feedback-form__label" :for="emailId">
      {{ t('feedbackPage.email') }}
    </label>
    <input
      :id="emailId"
      autocomplete="email"
      class="app-feedback-form__email"
      inputmode="email"
      :placeholder="t('feedbackPage.emailPlaceholder')"
      type="email"
      :value="email"
      @input="emit('update:email', inputValue($event))"
    />

    <span class="app-feedback-form__label">{{ t('feedbackPage.addPicture') }}</span>
    <section class="app-feedback-form__pictures">
      <button
        v-for="(picture, index) in pictures"
        :key="picture"
        type="button"
        :aria-label="t('feedbackPage.removePicture')"
        @click="emit('removePicture', index)"
      >
        <AppImage alt="" :src="picture" />
        <span><AppIcon name="close" :size="12" /></span>
      </button>
      <AppUploader
        v-if="pictures.length < 3"
        class="app-feedback-form__uploader"
        :disabled="uploadDisabled"
        label=""
        :max-size-mb="12"
        multiple
        :style="{
          '--app-feedback-upload-image': `url(${publicAsset('feedback/upload@2x.png')})`,
        }"
        @error="emit('uploadError', $event)"
        @processed="emit('processed', $event)"
      />
    </section>

    <button
      v-if="showSubmit"
      class="app-feedback-form__submit"
      :disabled="submitDisabled || submitting"
      type="submit"
    >
      {{ submitting ? t('feedbackPage.submitting') : t('feedbackPage.submit') }}
    </button>
  </form>
</template>

<style scoped lang="less">
.app-feedback-form {
  display: grid;
  gap: 12px;
  padding: 12px 20px 32px;
}

.app-feedback-form__categories {
  display: grid;
  width: 100%;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 15px 19px;
  justify-self: center;
}

.app-feedback-form__categories button {
  min-height: 37px;
  padding: 7px 8px;
  border: 1px solid var(--color-border-strong);
  border-radius: 19px;
  background: var(--color-message-sheet-action);
  color: var(--color-text);
  cursor: pointer;
  font-size: 15px;
  font-weight: 700;
  line-height: 20px;
  transition:
    border-color 220ms cubic-bezier(0.2, 0, 0, 1),
    background 220ms cubic-bezier(0.2, 0, 0, 1),
    opacity 220ms cubic-bezier(0.2, 0, 0, 1);
}

.app-feedback-form__categories button.is-active {
  border-color: transparent;
  background: var(--gradient-primary);
}

.app-feedback-form__categories button:disabled {
  cursor: default;
  opacity: 0.6;
}

.app-feedback-form__categories button:focus-visible,
.app-feedback-form__pictures > button:focus-visible,
.app-feedback-form__submit:focus-visible {
  outline: 2px solid var(--color-primary);
  outline-offset: 2px;
}

.app-feedback-form__textarea {
  position: relative;
  display: block;
  height: 209px;
  margin-top: 4px;
}

.app-feedback-form__textarea textarea {
  width: 100%;
  height: 100%;
  padding: 15px;
  resize: none;
  border: 0;
  border-radius: 12px;
  outline: 0;
  background: var(--color-feedback-field);
  caret-color: var(--color-primary);
  color: var(--color-text);
  font:
    500 12px/18px 'TT Norms Pro',
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    sans-serif;
}

.app-feedback-form__textarea textarea::placeholder,
.app-feedback-form__email::placeholder {
  color: var(--color-feedback-placeholder);
}

.app-feedback-form__label {
  color: var(--color-text);
  font-size: 12px;
  font-weight: 500;
}

.app-feedback-form__email {
  width: 100%;
  height: 48px;
  padding: 0 16px;
  border: 0;
  border-radius: 12px;
  outline: 0;
  background: var(--color-feedback-field);
  caret-color: var(--color-primary);
  color: var(--color-text);
  font:
    500 12px 'TT Norms Pro',
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    sans-serif;
}

.app-feedback-form__email:focus,
.app-feedback-form__textarea textarea:focus {
  border-color: transparent;
  outline: 0;
}

.app-feedback-form__pictures {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 105px));
  justify-content: space-between;
  gap: 10px;
}

.app-feedback-form__pictures > button,
.app-feedback-form__pictures :deep(.app-feedback-form__uploader.uploader) {
  position: relative;
  width: 100%;
  max-width: 105px;
  min-height: 0;
  aspect-ratio: 1;
  overflow: hidden;
  padding: 0;
  border: 0;
  border-radius: 12px;
  background: var(--color-feedback-field);
  cursor: pointer;
}

.app-feedback-form__pictures :deep(.app-feedback-form__uploader.uploader) {
  background-image: var(--app-feedback-upload-image);
  background-repeat: no-repeat;
  background-position: center;
  background-size: contain;
}

.app-feedback-form__pictures :deep(.app-feedback-form__uploader.uploader > svg),
.app-feedback-form__pictures :deep(.app-feedback-form__uploader.uploader > span) {
  display: none;
}

.app-feedback-form__pictures :deep(.app-image) {
  width: 100% !important;
  height: 100% !important;
}

.app-feedback-form__pictures > button > span {
  position: absolute;
  top: 5px;
  right: 5px;
  display: grid;
  width: 22px;
  height: 22px;
  border-radius: 50%;
  background: var(--color-mask);
  color: var(--color-text);
  place-items: center;
}

.app-feedback-form__submit {
  width: min(315px, 100%);
  height: 46px;
  justify-self: center;
  margin-top: 6px;
  border: 0;
  border-radius: 23px;
  background: var(--gradient-primary);
  color: var(--color-text);
  cursor: pointer;
  font-size: 15px;
  font-weight: 700;
  transition: opacity 220ms cubic-bezier(0.2, 0, 0, 1);
}

.app-feedback-form__submit:disabled {
  cursor: default;
  opacity: 0.48;
}

.app-feedback-form--sheet {
  gap: 10px;
  padding: 12px 4px 16px;
}

.app-feedback-form--sheet .app-feedback-form__categories {
  gap: 9px 12px;
}

.app-feedback-form--sheet .app-feedback-form__categories button {
  min-height: 40px;
  padding: 8px 10px;
  border-color: var(--color-on-dark-border);
  background: var(--color-on-dark-fill);
  font-size: 14px;
  font-weight: 650;
}

.app-feedback-form--sheet .app-feedback-form__categories button.is-active {
  border-color: transparent;
  background: var(--gradient-primary);
}

.app-feedback-form--sheet .app-feedback-form__textarea {
  height: 124px;
  margin-top: 2px;
}

.app-feedback-form--sheet .app-feedback-form__textarea textarea,
.app-feedback-form--sheet .app-feedback-form__email {
  border: 1px solid var(--color-on-dark-border);
  border-radius: 14px;
  background: color-mix(in srgb, var(--color-message-sheet-action) 55%, transparent);
  font-size: 13px;
}

.app-feedback-form--sheet .app-feedback-form__label {
  margin-top: 2px;
  color: var(--color-on-dark-secondary);
  font-size: 13px;
  font-weight: 600;
}

.app-feedback-form--sheet .app-feedback-form__email {
  height: 44px;
}

.app-feedback-form--sheet .app-feedback-form__pictures {
  grid-template-columns: repeat(3, minmax(0, 76px));
  justify-content: start;
  gap: 12px;
}

.app-feedback-form--sheet .app-feedback-form__pictures > button,
.app-feedback-form--sheet
  .app-feedback-form__pictures
  :deep(.app-feedback-form__uploader.uploader) {
  max-width: 76px;
  border: 1px solid var(--color-on-dark-border);
  border-radius: 14px;
  background-color: color-mix(in srgb, var(--color-message-sheet-action) 55%, transparent);
}

.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
}

@media (prefers-reduced-motion: reduce) {
  .app-feedback-form__categories button,
  .app-feedback-form__submit {
    transition-duration: 1ms;
  }
}
</style>

<script setup lang="ts">
import { computed, onBeforeUnmount, ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import type { ReportContext, ReportReason } from '@/features/safety/contracts'
import { REPORT_REASONS } from '@/features/safety/contracts'
import { reportActions, reportQueries } from '@/features/safety/report-actions'
import AppFeedbackForm from '@/main/components/AppFeedbackForm.vue'
import AppPopup from '@/main/components/AppPopup.vue'
import { useAsyncAction } from '@/main/composables/useAsyncAction'
import { useAppFeedback } from '@/main/ui/feedback'

const MAX_PICTURES = 3

const props = defineProps<{
  context: ReportContext
  modelValue: boolean
}>()

const emit = defineEmits<{ closed: []; 'update:modelValue': [value: boolean] }>()
const { t } = useI18n()
const feedback = useAppFeedback()
const reason = ref<ReportReason>(REPORT_REASONS[0])
const suggestion = ref('')
const email = ref('')
const pictures = ref<string[]>([])
const uploading = ref(false)
let uploadController: AbortController | undefined
let submitController: AbortController | undefined

const categoryOptions = computed(() =>
  REPORT_REASONS.map((value) => ({
    label: t(`safety.reasons.${value.toLowerCase()}`),
    value,
  })),
)
const targetUserId = computed(() => Number(props.context.targetUserId))
const validRemoteTarget = computed(
  () => Number.isSafeInteger(targetUserId.value) && targetUserId.value > 0,
)
const canSubmit = computed(
  () =>
    suggestion.value.trim().length > 0 &&
    !uploading.value &&
    (!reportQueries.requiresTarget() || validRemoteTarget.value),
)
const canClose = computed(() => !submitAction.pending.value && !uploading.value)

function selectReason(value: string): void {
  if (REPORT_REASONS.includes(value as ReportReason)) reason.value = value as ReportReason
}

async function handlePrepared(
  files: { blob: Blob; hash: string; height: number; name: string; width: number }[],
): Promise<void> {
  const available = files.slice(0, Math.max(0, MAX_PICTURES - pictures.value.length))
  if (!available.length || uploading.value) return
  uploadController?.abort()
  uploadController = new AbortController()
  const controller = uploadController
  const uploaded: string[] = []
  uploading.value = true
  const closeLoading = feedback.loading(t('safety.uploading'))
  try {
    for (const file of available) {
      uploaded.push(await reportActions.uploadEvidence(file.blob, controller.signal))
    }
    if (!props.modelValue) {
      uploaded.forEach(revokeLocalPicture)
      return
    }
    pictures.value = [...pictures.value, ...uploaded].slice(0, MAX_PICTURES)
  } catch {
    uploaded.forEach(revokeLocalPicture)
    if (!controller.signal.aborted) feedback.error(t('safety.uploadFailed'))
  } finally {
    if (uploadController === controller) uploading.value = false
    closeLoading()
  }
}

function revokeLocalPicture(url: string): void {
  if (url.startsWith('blob:')) URL.revokeObjectURL(url)
}

function removePicture(index: number): void {
  const url = pictures.value[index]
  if (!url) return
  pictures.value.splice(index, 1)
  revokeLocalPicture(url)
}

async function performSubmit(): Promise<void> {
  if (!suggestion.value.trim()) throw new Error(t('feedbackPage.required'))
  if (reportQueries.requiresTarget() && !validRemoteTarget.value)
    throw new Error(t('safety.targetUnavailable'))
  const numericRoomId = Number(props.context.roomId)
  submitController?.abort()
  submitController = new AbortController()
  await reportActions.submit(
    {
      email: email.value.trim(),
      pictureUrls: pictures.value,
      reason: reason.value,
      roomId:
        props.context.source === 'live' && Number.isSafeInteger(numericRoomId) && numericRoomId > 0
          ? numericRoomId
          : undefined,
      source: props.context.source,
      suggestion: suggestion.value.trim(),
      targetUserId: validRemoteTarget.value ? targetUserId.value : 0,
    },
    submitController.signal,
  )
  feedback.success(t('feedbackPage.successTitle'))
  emit('update:modelValue', false)
}

const submitAction = useAsyncAction(performSubmit, {
  errorMessage: () => t('safety.submitFailed'),
  feedback: 'blocking',
  loadingMessage: () => t('safety.submitting'),
  minimumIntervalMs: 900,
})

function reset(): void {
  reason.value = REPORT_REASONS[0]
  suggestion.value = ''
  email.value = ''
  pictures.value.forEach(revokeLocalPicture)
  pictures.value = []
}

watch(
  () => props.modelValue,
  (visible, previous) => {
    if (!visible && previous) {
      uploadController?.abort()
      submitController?.abort()
      reset()
    }
  },
)

onBeforeUnmount(() => {
  uploadController?.abort()
  submitController?.abort()
  reset()
})
</script>

<template>
  <AppPopup
    class="report-sheet-popup"
    :model-value="modelValue"
    panel-height="min(620px, 82dvh)"
    panel-max-height="min(620px, 82dvh)"
    scrollable
    surface="standard"
    :surface-radius="0"
    :swipe-to-close="canClose"
    :title="t('safety.report')"
    @closed="emit('closed')"
    @update:model-value="canClose && emit('update:modelValue', $event)"
  >
    <AppFeedbackForm
      v-model:description="suggestion"
      v-model:email="email"
      :categories="categoryOptions"
      :category="reason"
      form-id="report-feedback-form"
      :pictures="pictures"
      :show-submit="false"
      :submit-disabled="!canSubmit"
      :submitting="submitAction.pending.value"
      :upload-disabled="uploading"
      variant="sheet"
      @processed="handlePrepared"
      @remove-picture="removePicture"
      @submit="submitAction.run().catch(() => undefined)"
      @update:category="selectReason"
      @upload-error="feedback.error"
    />
    <template #footer>
      <div class="report-sheet__footer">
        <button
          class="report-sheet__footer-action"
          :disabled="!canSubmit || submitAction.pending.value"
          type="button"
          @click="submitAction.run().catch(() => undefined)"
        >
          {{ submitAction.pending.value ? t('safety.submitting') : t('safety.submit') }}
        </button>
      </div>
    </template>
  </AppPopup>
</template>

<style scoped lang="less">
:global(.report-sheet-popup.app-popup-host .app-popup > header) {
  position: relative;
  min-height: 54px;
  justify-content: center;
}

:global(.report-sheet-popup.app-popup-host .app-popup h2) {
  margin: 0;
  padding-inline: 48px;
  font-size: 17px;
  font-weight: 750;
  text-align: center;
}

:global(.report-sheet-popup.app-popup-host .app-popup__close) {
  position: absolute;
  right: 0;
  width: 34px;
  height: 34px;
  cursor: pointer;
}

.report-sheet__footer {
  padding: 8px 4px 3px;
}

.report-sheet__footer-action {
  width: 100%;
  min-height: 48px;
  padding: 0 20px;
  border: 0;
  border-radius: 24px;
  background: var(--gradient-primary);
  color: var(--color-text);
  cursor: pointer;
  font-size: 15px;
  font-weight: 750;
  transition: opacity 180ms cubic-bezier(0.2, 0, 0, 1);
}

.report-sheet__footer-action:disabled {
  cursor: default;
  opacity: 0.48;
}

.report-sheet__footer-action:focus-visible {
  outline: 2px solid var(--color-text);
  outline-offset: -4px;
}

@media (prefers-reduced-motion: reduce) {
  .report-sheet__footer-action {
    transition-duration: 1ms;
  }
}
</style>

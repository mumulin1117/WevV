<script setup lang="ts">
import { computed } from 'vue'
import { useI18n } from 'vue-i18n'
import { activityFrameUrl } from '@/features/promotions/promotion-target'
import AppPopup from '@/main/components/AppPopup.vue'
import { useAppFeedback } from '@/main/ui/feedback'
import ActivityWebFrame from '@/features/promotions/components/ActivityWebFrame.vue'

const props = defineProps<{
  roomId: string
  source: string
  suspended?: boolean
}>()

const emit = defineEmits<{
  close: []
  navigate: [scene: string, payload: Record<string, unknown>]
  'open-gift': []
}>()

const feedback = useAppFeedback()
const { t } = useI18n()
const show = computed(() => Boolean(props.source))
const frameSource = computed(() => activityFrameUrl(props.source, true))

function handleNavigate(scene: string, payload: Record<string, unknown>): void {
  if (['GO_LIVE', 'GO_LIVE_OF_ANCHOR', 'GO_PROFILE', 'GO_ROOM'].includes(scene)) {
    feedback.warning(t('party.roomAlreadyOpen'))
    return
  }
  emit('navigate', scene, payload)
}
</script>

<template>
  <AppPopup
    bottom-inset-owner="content"
    class="party-activity-popup"
    :closeable="false"
    :close-on-click-overlay="true"
    :expand-for-bottom-inset="false"
    flush
    :model-value="show"
    :overlay-style="{ background: 'var(--color-activity-overlay)' }"
    panel-height="75dvh"
    :surface-radius="16"
    surface="standard"
    :suspended="suspended"
    @update:model-value="!$event && emit('close')"
  >
    <ActivityWebFrame
      display-mode="popup"
      report-path="party"
      :room-id="roomId"
      room-type="1"
      :source="frameSource"
      @close="emit('close')"
      @navigate="handleNavigate"
      @open-gift="emit('open-gift')"
    />
  </AppPopup>
</template>

<style scoped lang="less">
:deep(.party-activity-popup.van-popup) {
  width: min(100vw, 450px);
  overflow: hidden;
  border-radius: 16px 16px 0 0;
  background: var(--color-activity-surface);
}

:deep(.party-activity-popup .app-popup),
:deep(.party-activity-popup .app-popup__body) {
  width: 100%;
  height: 100%;
  min-height: 0;
  padding: 0;
  overflow: hidden;
  background: var(--color-activity-surface);
}
</style>

<script setup lang="ts">
import { computed } from 'vue'
import { useI18n } from 'vue-i18n'
import { publicAsset } from '@/core/media/public-asset'
import AppPopup from '@/main/components/AppPopup.vue'

const props = withDefaults(
  defineProps<{
    modelValue: boolean
    pkPreviewAvailable?: boolean
    pkPreviewLabel?: string
  }>(),
  {
    pkPreviewAvailable: false,
    pkPreviewLabel: '',
  },
)
const emit = defineEmits<{
  closed: []
  effect: []
  pkPreview: []
  report: []
  'update:modelValue': [value: boolean]
}>()
const { t } = useI18n()

const visible = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value),
})
</script>

<template>
  <AppPopup
    v-model="visible"
    class="live-more-popup"
    :closeable="false"
    :surface-radius="20"
    surface="gift"
    @closed="emit('closed')"
  >
    <section class="live-more-sheet">
      <h2>{{ t('room.liveTools') }}</h2>
      <div class="live-more-sheet__grid">
        <button type="button" @click="emit('effect')">
          <img alt="" :src="publicAsset('live-room/legacy/effect-switch.webp')" />
          <span>{{ t('room.effectSwitch') }}</span>
        </button>
        <button type="button" @click="emit('report')">
          <img alt="" :src="publicAsset('live-room/legacy/report.webp')" />
          <span>{{ t('room.report') }}</span>
        </button>
        <button v-if="pkPreviewAvailable" type="button" @click="emit('pkPreview')">
          <img alt="" :src="publicAsset('live-room/legacy/pk/score.webp')" />
          <span>{{ pkPreviewLabel }}</span>
        </button>
      </div>
    </section>
  </AppPopup>
</template>

<style scoped lang="less">
.live-more-popup :deep(.app-popup) {
  padding-right: 0;
  padding-left: 0;
  background: var(--panel-bg);
}

.live-more-sheet {
  padding: 20px 20px 4px;
  color: var(--color-text);
}

.live-more-sheet h2 {
  margin: 0 0 16px;
  font-size: 14px;
  font-weight: 700;
  line-height: 18px;
}

.live-more-sheet__grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 20px 13px;
}

.live-more-sheet__grid button {
  display: grid;
  min-width: 0;
  min-height: 74px;
  align-content: center;
  justify-items: center;
  gap: 8px;
  padding: 0;
  border: 0;
  background: transparent;
  color: var(--color-text-muted);
  font-size: 12px;
  line-height: 15px;
  text-align: center;
  touch-action: manipulation;
}

.live-more-sheet__grid img {
  width: 36px;
  height: 36px;
  object-fit: contain;
}

.live-more-sheet__grid span {
  width: 100%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.live-more-sheet__grid button:focus-visible {
  border-radius: 10px;
  outline: 2px solid var(--color-primary);
  outline-offset: 2px;
}
</style>

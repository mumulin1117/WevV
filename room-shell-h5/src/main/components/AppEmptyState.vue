<script setup lang="ts">
import { computed } from 'vue'
import { useI18n } from 'vue-i18n'
import { publicAsset } from '@/core/media/public-asset'
import AppButton from './AppButton.vue'

const props = withDefaults(
  defineProps<{
    action?: string
    description?: string
    size?: 'page' | 'popup'
    title?: string
    variant?: 'empty' | 'feedback'
  }>(),
  { action: '', description: '', size: 'page', title: '', variant: 'empty' },
)
const { t } = useI18n()
const accessibleLabel = computed(() =>
  props.variant === 'empty' ? t('common.noData') : props.title || props.description,
)
defineEmits<{ action: [] }>()
</script>

<template>
  <section
    class="empty-state"
    :class="[`empty-state--${size}`, `empty-state--${variant}`]"
    role="status"
    :aria-label="accessibleLabel"
  >
    <img :src="publicAsset('common/no-data.png')" alt="" aria-hidden="true" />
    <template v-if="variant === 'feedback'">
      <p v-if="description">{{ description }}</p>
      <AppButton v-if="action" size="small" tone="secondary" @click="$emit('action')">
        {{ action }}
      </AppButton>
    </template>
    <p v-else>{{ description || t('common.noData') }}</p>
  </section>
</template>

<style scoped lang="less">
.empty-state {
  display: grid;
  width: 100%;
  height: 100%;
  min-height: 280px;
  box-sizing: border-box;
  grid-auto-rows: max-content;
  align-content: center;
  gap: 8px;
  padding: 32px 24px;
  justify-items: center;
  text-align: center;
}

.empty-state img {
  width: 167px;
  max-width: 100%;
  height: auto;
  object-fit: contain;
}

.empty-state--popup {
  min-height: 180px;
  padding: 20px 16px;
}

.empty-state--popup img {
  width: 100px;
}

.empty-state p {
  max-width: 280px;
  margin: 0;
  color: var(--color-text-muted);
  font-size: 13px;
  line-height: 18px;
}

.empty-state--popup p {
  font-size: 12px;
  line-height: 15px;
}

.empty-state--feedback :deep(.app-button) {
  margin-top: 8px;
}
</style>

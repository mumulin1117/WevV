<script setup lang="ts">
import { computed } from 'vue'
import { useI18n } from 'vue-i18n'
import type { InboxMessage } from '../contracts'
import { publicAsset } from '@/core/media/public-asset'
import AppIcon from '@/main/components/AppIcon.vue'
import AppImage from '@/main/components/AppImage.vue'

const props = defineProps<{
  message: InboxMessage
}>()
defineEmits<{ activate: [] }>()

const { t } = useI18n()
const media = computed(() => props.message.privateMedia)
const busy = computed(() => ['checking', 'unlocking'].includes(media.value?.status ?? ''))
const statusLabel = computed(() => {
  if (media.value?.status === 'expired') return t('messages.privateExpired')
  if (media.value?.status === 'unavailable') return t('messages.privateUnavailable')
  if (media.value?.status === 'verify-pending') return t('messages.privateCheckStatus')
  if (media.value?.status === 'unlocked') return t('messages.privateView')
  if (['checking', 'unlocking'].includes(media.value?.status ?? '')) return t('common.loading')
  return t('messages.privateGiftUnlock')
})
</script>

<template>
  <button
    class="private-card"
    :class="[`is-${media?.status ?? 'unavailable'}`]"
    :disabled="busy"
    type="button"
    @click="$emit('activate')"
  >
    <AppImage
      v-if="media?.coverUrl"
      :alt="message.text"
      class="cover"
      :lazy="false"
      :src="media.coverUrl"
    />
    <span v-else class="placeholder" aria-hidden="true" />

    <span class="media-type" aria-hidden="true">
      <AppIcon :name="media?.mediaType === 'video' ? 'video' : 'image'" :size="18" />
    </span>

    <span v-if="media?.status !== 'unlocked'" class="veil">
      <template v-if="media?.status === 'locked'">
        <span class="gift-halo">
          <AppImage
            v-if="media.giftIconUrl"
            :alt="t('messages.gift')"
            class="gift"
            :lazy="false"
            :src="media.giftIconUrl"
          />
          <img v-else class="gift-fallback" :src="publicAsset('common/gift_icon.png')" alt="" />
        </span>
        <span class="price">
          <img :src="publicAsset('common/diamond.png')" alt="" />{{ media.price }}
        </span>
      </template>
      <span v-else-if="busy" class="busy" aria-hidden="true" />
      <span v-else class="state-icon" aria-hidden="true">!</span>
    </span>

    <span class="action">{{ statusLabel }}</span>
  </button>
</template>

<style scoped lang="less">
.private-card {
  position: relative;
  display: block;
  width: 210px;
  height: 280px;
  padding: 0;
  overflow: hidden;
  border: 0;
  border-radius: 16px;
  background: var(--color-surface);
  color: var(--color-text);
  text-align: center;
}

.private-card:disabled {
  opacity: 1;
}

.cover,
.placeholder,
.private-card :deep(.cover.app-image) {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
}

.private-card:not(.is-unlocked) .cover,
.private-card:not(.is-unlocked) :deep(.cover.app-image) {
  transform: scale(1.12);
  filter: blur(8px);
}

.placeholder {
  background: var(--gradient-message-page);
}

.veil {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 76px;
  background: var(--color-scrim-soft);
}

.gift-halo {
  display: grid;
  width: 64px;
  height: 64px;
  border-radius: 50%;
  background: var(--color-on-dark-border);
  place-items: center;
}

.gift,
.private-card :deep(.gift.app-image),
.gift-fallback {
  width: 40px;
  height: 40px;
  object-fit: contain;
}

.price {
  display: flex;
  height: 16px;
  align-items: center;
  justify-content: center;
  gap: 4px;
  margin-top: 9px;
  font-size: 16px;
  font-weight: 600;
}

.price img {
  width: 16px;
  height: 16px;
  object-fit: contain;
}

.action {
  position: absolute;
  right: 22px;
  bottom: 18px;
  left: 22px;
  display: flex;
  height: 40px;
  align-items: center;
  justify-content: center;
  padding: 0 9px;
  border-radius: 25px;
  background: var(--gradient-action);
  font-size: 13px;
  font-weight: 800;
  line-height: 16px;
}

.media-type {
  position: absolute;
  z-index: 2;
  top: 12px;
  left: 12px;
  display: flex;
  color: var(--color-text);
}

.busy {
  width: 32px;
  height: 32px;
  margin-top: 34px;
  border: 3px solid var(--color-on-dark-disabled);
  border-top-color: var(--color-text);
  border-radius: 50%;
  animation: private-media-spin 0.75s linear infinite;
}

.state-icon {
  margin-top: 37px;
  font-size: 24px;
  font-weight: 800;
}

@keyframes private-media-spin {
  to {
    transform: rotate(1turn);
  }
}

@media (prefers-reduced-motion: reduce) {
  .busy {
    animation: none;
  }
}
</style>

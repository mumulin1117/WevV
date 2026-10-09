<script setup lang="ts">
import { publicAsset } from '@/core/media/public-asset'
import type { GameCatalog, GameItem } from '@/features/game/contracts'
import AppImage from '@/main/components/AppImage.vue'
import AppPopup from '@/main/components/AppPopup.vue'
import AppStateView from '@/main/components/AppStateView.vue'
import SkeletonBlock from '@/main/components/SkeletonBlock.vue'
import { computed } from 'vue'
import { useI18n } from 'vue-i18n'

const props = defineProps<{
  catalog: GameCatalog | null
  error: boolean
  launchingId?: string
  loading: boolean
  modelValue: boolean
  rpsAvailable: boolean
  suspended?: boolean
  wheelAvailable: boolean
}>()
const emit = defineEmits<{
  closed: []
  'update:modelValue': [value: boolean]
  retry: []
  select: [game: GameItem]
  selectRps: []
  selectWheel: []
}>()
const { t } = useI18n()

const externalGames = computed(() => props.catalog?.games ?? [])
const hasAnyGame = computed(
  () => props.rpsAvailable || props.wheelAvailable || externalGames.value.length > 0,
)
</script>

<template>
  <AppPopup
    class="live-game-center"
    :close-on-click-overlay="!launchingId"
    :closeable="!launchingId"
    :model-value="modelValue"
    panel-max-height="min(430px, 68dvh)"
    scrollable
    :suspended="suspended"
    swipe-to-close
    :title="t('room.gameCenterTitle')"
    @closed="emit('closed')"
    @update:model-value="emit('update:modelValue', $event)"
  >
    <div class="live-game-center__content" :aria-busy="loading || Boolean(launchingId)">
      <div v-if="hasAnyGame" class="live-game-center__grid">
        <button
          v-if="rpsAvailable"
          type="button"
          :disabled="Boolean(launchingId)"
          @click="emit('selectRps')"
        >
          <span class="live-game-center__media is-native">
            <img alt="" :src="publicAsset('live-room/rps/champion.webp')" />
          </span>
          <strong>{{ t('room.rpsTitle') }}</strong>
        </button>
        <button
          v-if="wheelAvailable"
          type="button"
          :disabled="Boolean(launchingId)"
          @click="emit('selectWheel')"
        >
          <span class="live-game-center__media is-native">
            <img alt="" :src="publicAsset('live-room/wheel/icon.webp')" />
          </span>
          <strong>{{ t('room.liveWheelTitle') }}</strong>
        </button>
        <button
          v-for="game in externalGames"
          :key="game.id"
          type="button"
          :disabled="Boolean(launchingId)"
          @click="emit('select', game)"
        >
          <span class="live-game-center__media">
            <AppImage :alt="game.name" fit="cover" :src="game.imageUrl" />
            <small v-if="game.isNew">{{ t('game.new') }}</small>
            <i v-if="launchingId === game.id" aria-hidden="true" />
          </span>
          <strong>{{ game.name }}</strong>
        </button>
      </div>

      <div v-if="loading && externalGames.length === 0" class="live-game-center__skeleton">
        <span v-for="index in 6" :key="index">
          <SkeletonBlock aspect-ratio="1" height="auto" radius="12px" />
          <SkeletonBlock height="14px" radius="7px" width="72%" />
        </span>
      </div>

      <AppStateView
        v-else-if="error && externalGames.length === 0 && !rpsAvailable && !wheelAvailable"
        :description="t('room.gameCenterFailed')"
        size="popup"
        state="error"
        @retry="emit('retry')"
      />
      <AppStateView v-else-if="!loading && !hasAnyGame" size="popup" state="empty" />
      <button
        v-else-if="error"
        class="live-game-center__retry"
        type="button"
        @click="emit('retry')"
      >
        {{ t('common.retry') }}
      </button>
    </div>
  </AppPopup>
</template>

<style scoped lang="less">
.live-game-center :deep(.app-popup) {
  background: var(--panel-bg);
}

.live-game-center__content {
  min-height: 196px;
  padding: 4px 5px 20px;
}

.live-game-center__grid,
.live-game-center__skeleton {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 12px 10px;
}

.live-game-center__grid > button {
  display: grid;
  min-width: 0;
  padding: 0;
  border: 0;
  background: transparent;
  color: var(--color-on-dark);
  gap: 8px;
  place-items: center;
}

.live-game-center__grid > button:disabled {
  opacity: 0.7;
}

.live-game-center__media {
  position: relative;
  display: block;
  width: 100%;
  overflow: hidden;
  border: 1px solid var(--color-on-dark-fill);
  border-radius: 12px;
  aspect-ratio: 1;
  background: color-mix(in srgb, var(--panel-bg) 80%, var(--color-text) 8%);
}

.live-game-center__media :deep(.app-image),
.live-game-center__media > img {
  width: 100% !important;
  height: 100% !important;
  object-fit: cover;
}

.live-game-center__media.is-native > img {
  padding: 9px;
  object-fit: contain;
}

.live-game-center__media small {
  position: absolute;
  top: 5px;
  right: 5px;
  padding: 2px 5px;
  border-radius: 7px;
  background: linear-gradient(90deg, var(--color-secondary), var(--color-primary));
  color: var(--color-on-dark);
  font-size: 9px;
  font-style: normal;
  font-weight: 800;
}

.live-game-center__media i {
  position: absolute;
  inset: 0;
  background: var(--color-scrim);
}

.live-game-center__media i::after {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 22px;
  height: 22px;
  border: 2px solid var(--color-on-dark-disabled);
  border-top-color: var(--color-on-dark);
  border-radius: 50%;
  content: '';
  transform: translate(-50%, -50%);
  animation: live-game-center-spin 700ms linear infinite;
}

.live-game-center__grid strong {
  display: block;
  width: 100%;
  overflow: hidden;
  font-size: 14px;
  line-height: 18px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.live-game-center__skeleton > span {
  display: grid;
  gap: 8px;
  justify-items: center;
}

.live-game-center__retry {
  display: block;
  min-width: 96px;
  min-height: 36px;
  margin: 18px auto 0;
  border: 0;
  border-radius: 18px;
  background: var(--color-surface-raised);
  color: var(--color-text-muted);
  font-weight: 700;
}

@keyframes live-game-center-spin {
  to {
    transform: translate(-50%, -50%) rotate(360deg);
  }
}
</style>

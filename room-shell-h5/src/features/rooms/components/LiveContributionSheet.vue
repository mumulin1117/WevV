<script setup lang="ts">
import { publicAsset } from '@/core/media/public-asset'
import AppAvatar from '@/main/components/AppAvatar.vue'
import AppEmptyState from '@/main/components/AppEmptyState.vue'
import AppPopup from '@/main/components/AppPopup.vue'
import AppUserLevelTag from '@/main/components/AppUserLevelTag.vue'
import { parseUserLevel } from '@/main/components/user-level'
import { computed, onBeforeUnmount, ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import type { RoomLaunchContext } from '../contracts'
import type { LiveRankItem } from '../live-interaction-contracts'
import { liveInteractionQueries } from '../live-operations'

const props = defineProps<{
  context: RoomLaunchContext
  income: number
  modelValue: boolean
}>()
const emit = defineEmits<{
  profile: [member: { avatarUrl: string; id: string; name: string }]
  'update:modelValue': [value: boolean]
}>()

const { t } = useI18n()
const rows = ref<readonly LiveRankItem[]>(
  liveInteractionQueries.peekRank(props.context.roomId, 'now') ?? [],
)
const loading = ref(false)
const failed = ref(false)
let controller: AbortController | undefined
let requestSequence = 0

const visible = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value),
})

function formatValue(value: number): string {
  return Math.max(0, value).toLocaleString('en')
}

async function load(): Promise<void> {
  controller?.abort()
  const active = new AbortController()
  controller = active
  const sequence = ++requestSequence
  loading.value = rows.value.length === 0
  failed.value = false
  try {
    const result = await liveInteractionQueries.getRank(props.context, 'now', active.signal)
    if (active.signal.aborted || sequence !== requestSequence) return
    rows.value = result
  } catch {
    if (!active.signal.aborted && sequence === requestSequence && rows.value.length === 0)
      failed.value = true
  } finally {
    if (!active.signal.aborted && sequence === requestSequence) loading.value = false
  }
}

watch(
  () => props.modelValue,
  (open) => {
    if (open) void load()
    else controller?.abort()
  },
  { immediate: true },
)

onBeforeUnmount(() => controller?.abort())
</script>

<template>
  <AppPopup
    v-model="visible"
    class="live-contribution-sheet"
    :closeable="false"
    flush
    panel-height="min(430px, 72dvh)"
    panel-max-height="min(430px, 72dvh)"
    :surface-radius="18"
  >
    <header class="live-contribution-sheet__header">
      <div>
        <h2>{{ t('room.contributionThisLive') }}</h2>
        <p>{{ t('room.rankedByLiveContribution') }}</p>
      </div>
      <strong>
        <img alt="" :src="publicAsset('common/diamond.png')" />
        {{ formatValue(income) }}
      </strong>
    </header>

    <div v-if="loading" class="live-contribution-sheet__skeleton" role="status">
      <i v-for="index in 4" :key="index" />
    </div>
    <button v-else-if="failed" class="live-contribution-sheet__state" type="button" @click="load">
      {{ t('room.rankingUnavailable') }} · {{ t('room.chatRetry') }}
    </button>
    <div v-else-if="rows.length" class="live-contribution-sheet__list" data-room-scroll>
      <button
        v-for="row in rows"
        :key="row.id"
        type="button"
        @click="emit('profile', { avatarUrl: row.avatarUrl, id: row.id, name: row.name })"
      >
        <img
          v-if="row.rank >= 1 && row.rank <= 3"
          alt=""
          class="live-contribution-sheet__rank-image"
          :src="publicAsset(`live-room/legacy/crown-${row.rank}.webp`)"
        />
        <b v-else>{{ row.rank > 99 ? '99+' : row.rank || '-' }}</b>
        <AppAvatar :alt="row.name" :size="44" :src="row.avatarUrl" />
        <span>
          <strong>{{ row.name }}</strong>
          <small v-if="parseUserLevel(row.levelName) !== null || row.vip">
            <AppUserLevelTag :level="row.levelName" size="s" />
            <img v-if="row.vip" alt="VIP" :src="publicAsset('common/vip.webp')" />
          </small>
        </span>
        <em>
          <img alt="" :src="publicAsset('common/diamond.png')" />
          {{ formatValue(row.cost) }}
        </em>
      </button>
    </div>
    <AppEmptyState v-else class="live-contribution-sheet__state" size="popup" />
  </AppPopup>
</template>

<style scoped lang="less">
.live-contribution-sheet :deep(.app-popup) {
  background: var(--panel-bg) !important;
  min-height: 0;
  overflow: hidden;
  padding: 0;
}

.live-contribution-sheet :deep(.app-popup__body) {
  display: flex;
  min-height: 0;
  flex: 1;
  flex-direction: column;
}

.live-contribution-sheet__header {
  display: flex;
  min-height: 76px;
  box-sizing: border-box;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 14px 18px;
  border-bottom: 1px solid var(--color-on-dark-fill);
}

.live-contribution-sheet__header h2,
.live-contribution-sheet__header p {
  margin: 0;
}

.live-contribution-sheet__header h2 {
  font-size: 19px;
  line-height: 1.25;
}

.live-contribution-sheet__header p {
  margin-top: 3px;
  color: var(--color-text-muted);
  font-size: 12px;
}

.live-contribution-sheet__header > strong,
.live-contribution-sheet__list em {
  display: flex;
  align-items: center;
  gap: 4px;
  color: var(--color-party-rank-score);
  font-style: normal;
  font-weight: 600;
  white-space: nowrap;
}

.live-contribution-sheet__header img,
.live-contribution-sheet__list em img {
  width: 17px;
  height: 17px;
  object-fit: contain;
}

.live-contribution-sheet__list {
  min-height: 0;
  flex: 1;
  overflow: hidden auto;
  overscroll-behavior: contain;
  padding: 0 16px var(--app-popup-content-bottom-inset);
  -webkit-overflow-scrolling: touch;
}

.live-contribution-sheet__list > button {
  display: grid;
  width: 100%;
  min-width: 0;
  min-height: 68px;
  grid-template-columns: 30px 44px minmax(0, 1fr) auto;
  align-items: center;
  gap: 10px;
  padding: 9px 0;
  border: 0;
  border-bottom: 1px solid var(--color-on-dark-fill);
  background: transparent;
  color: var(--color-on-dark);
  text-align: left;
}

.live-contribution-sheet__list > button > b {
  text-align: center;
}

.live-contribution-sheet__rank-image {
  width: 27px;
  height: 27px;
  object-fit: contain;
}

.live-contribution-sheet__list > button > span {
  display: grid;
  min-width: 0;
  gap: 4px;
}

.live-contribution-sheet__list > button > span > strong {
  overflow: hidden;
  font-size: 15px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.live-contribution-sheet__list small {
  display: flex;
  min-height: 18px;
  align-items: center;
  gap: 4px;
}

.live-contribution-sheet__list small > img {
  width: 28px;
  height: 14px;
  object-fit: contain;
}

.live-contribution-sheet__skeleton {
  display: grid;
  gap: 1px;
  padding: 0 16px;
}

.live-contribution-sheet__skeleton i {
  height: 68px;
  background: linear-gradient(
    100deg,
    var(--color-on-dark-divider) 20%,
    var(--color-on-dark-fill) 38%,
    var(--color-on-dark-divider) 56%
  );
  background-size: 200% 100%;
  animation: contribution-skeleton 1.2s linear infinite;
}

.live-contribution-sheet__state {
  display: grid;
  min-height: 220px;
  flex: 1;
  border: 0;
  background: transparent;
  color: var(--color-text-muted);
  place-items: center;
}

@keyframes contribution-skeleton {
  to {
    background-position-x: -200%;
  }
}

@media (prefers-reduced-motion: reduce) {
  .live-contribution-sheet__skeleton i {
    animation: none;
  }
}
</style>

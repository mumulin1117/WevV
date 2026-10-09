<script setup lang="ts">
import { publicAsset } from '@/core/media/public-asset'
import AppAvatar from '@/main/components/AppAvatar.vue'
import AppIcon from '@/main/components/AppIcon.vue'
import AppLoading from '@/main/components/AppLoading.vue'
import AppPopup from '@/main/components/AppPopup.vue'
import AppUserLevelTag from '@/main/components/AppUserLevelTag.vue'
import { parseUserLevel } from '@/main/components/user-level'
import { useSessionStore } from '@/main/stores/session'
import { computed, nextTick, onBeforeUnmount, ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import type { LivePkDetail, LivePkRankEntry } from '../live-pk-contracts'
import {
  getLivePkRankContext,
  LivePkRankContextError,
  livePkQueries,
  type LivePkSide,
} from '../live-pk-operations'

const props = defineProps<{
  detail: LivePkDetail
  modelValue: boolean
  previewRows?: readonly LivePkRankEntry[]
  resolveDetail?: () => Promise<LivePkDetail | null>
  side: LivePkSide
}>()
const emit = defineEmits<{
  closed: []
  support: []
  'update:modelValue': [value: boolean]
}>()

const { t } = useI18n()
const session = useSessionStore()
const rows = ref<readonly LivePkRankEntry[]>([])
const listRef = ref<HTMLElement | null>(null)
const contextUnavailable = ref(false)
const loading = ref(false)
const failed = ref(false)
let requestController: AbortController | undefined
let requestSequence = 0

const visible = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value),
})
const anchor = computed(() =>
  props.side === 'left'
    ? {
        avatarUrl: props.detail.leftAvatarUrl,
        id: props.detail.leftUserId,
        name: props.detail.leftName,
      }
    : {
        avatarUrl: props.detail.rightAvatarUrl,
        id: props.detail.rightUserId,
        name: props.detail.rightName,
      },
)
const selfRank = computed(() => {
  const id = session.user?.id?.trim()
  return id ? (rows.value.find((row) => row.id === id) ?? null) : null
})
const selfFallback = computed<LivePkRankEntry>(() => ({
  avatarUrl: session.user?.avatar ?? '',
  contribution: 0,
  countryCode: '',
  id: session.user?.id ?? '',
  levelName: '',
  nickname: session.user?.displayName ?? '',
  rank: 0,
  vip: false,
}))
const self = computed(() => selfRank.value ?? selfFallback.value)

function formatContribution(value: number): string {
  return value > 0 ? value.toLocaleString('en') : '-'
}

function rankAsset(rank: number): string {
  return publicAsset(`live-room/legacy/crown-${rank}.webp`)
}

function hasBadges(row: LivePkRankEntry): boolean {
  return parseUserLevel(row.levelName) !== null || row.vip
}

async function resetListPosition(): Promise<void> {
  await nextTick()
  if (listRef.value) listRef.value.scrollTop = 0
}

async function load(): Promise<void> {
  requestController?.abort()
  rows.value = []
  contextUnavailable.value = false
  await resetListPosition()
  if (props.previewRows) {
    rows.value = props.previewRows
    loading.value = false
    failed.value = false
    await resetListPosition()
    return
  }
  const controller = new AbortController()
  requestController = controller
  const sequence = ++requestSequence
  loading.value = true
  failed.value = false
  try {
    let detail = props.detail
    if (!getLivePkRankContext(detail, props.side) && props.resolveDetail)
      detail = (await props.resolveDetail()) ?? detail
    if (controller.signal.aborted || sequence !== requestSequence) return
    if (!getLivePkRankContext(detail, props.side)) throw new LivePkRankContextError()
    const result = await livePkQueries.getRank(detail, props.side, controller.signal)
    if (controller.signal.aborted || sequence !== requestSequence) return
    rows.value = result
    await resetListPosition()
  } catch (cause) {
    if (!controller.signal.aborted && sequence === requestSequence) {
      contextUnavailable.value = cause instanceof LivePkRankContextError
      failed.value = !contextUnavailable.value
    }
  } finally {
    if (!controller.signal.aborted && sequence === requestSequence) loading.value = false
  }
}

function support(): void {
  emit('support')
  visible.value = false
}

watch(
  () => ({ open: props.modelValue, pkId: props.detail.pkId, side: props.side }),
  (current, previous) => {
    if (!current.open) {
      requestController?.abort()
      return
    }
    if (
      !previous ||
      !previous.open ||
      current.pkId !== previous.pkId ||
      current.side !== previous.side
    )
      void load()
  },
  { immediate: true },
)

onBeforeUnmount(() => requestController?.abort())
</script>

<template>
  <AppPopup
    v-model="visible"
    class="live-pk-rank-sheet"
    :closeable="false"
    flush
    panel-height="min(510px, 78dvh)"
    panel-max-height="min(510px, 78dvh)"
    :surface-radius="16"
    @closed="emit('closed')"
  >
    <img
      alt=""
      aria-hidden="true"
      class="live-pk-rank-sheet__mask"
      :src="
        publicAsset(
          side === 'right'
            ? 'live-room/legacy/pk/rank-top-opponent.webp'
            : 'live-room/legacy/pk/rank-top-current.webp',
        )
      "
    />
    <header class="live-pk-rank-sheet__header">
      <span class="live-pk-rank-sheet__header-avatar">
        <AppAvatar :alt="anchor.name" :lazy="false" :size="24" :src="anchor.avatarUrl" />
      </span>
      <strong>{{ t('room.pkGuardianFans') }}</strong>
    </header>

    <div v-if="loading" class="live-pk-rank-sheet__state" role="status">
      <AppLoading />
    </div>
    <button
      v-else-if="contextUnavailable"
      class="live-pk-rank-sheet__state live-pk-rank-sheet__retry"
      type="button"
      @click="load"
    >
      {{ t('room.pkUnavailable') }} · {{ t('room.chatRetry') }}
    </button>
    <button
      v-else-if="failed"
      class="live-pk-rank-sheet__state live-pk-rank-sheet__retry"
      type="button"
      @click="load"
    >
      {{ t('room.rankingUnavailable') }} · {{ t('room.chatRetry') }}
    </button>
    <div v-else-if="rows.length" ref="listRef" class="live-pk-rank-sheet__list" data-room-scroll>
      <article v-for="row in rows" :key="`${row.rank}:${row.id}`">
        <img
          v-if="row.rank >= 1 && row.rank <= 3"
          alt=""
          class="live-pk-rank-sheet__rank-image"
          :src="rankAsset(row.rank)"
        />
        <b v-else>{{ row.rank > 99 ? '99+' : row.rank || '-' }}</b>
        <AppAvatar :alt="row.nickname" :size="44" :src="row.avatarUrl" />
        <span class="live-pk-rank-sheet__identity">
          <span>
            <strong>{{ row.nickname || row.id }}</strong>
            <small v-if="hasBadges(row)" class="live-pk-rank-sheet__badges">
              <AppUserLevelTag :level="row.levelName" size="s" />
              <img v-if="row.vip" alt="VIP" :src="publicAsset('common/vip.webp')" />
            </small>
          </span>
          <small v-if="row.countryCode" class="live-pk-rank-sheet__country">
            <AppIcon name="globe" :size="11" />
            {{ row.countryCode }}
          </small>
        </span>
        <em>
          <img alt="" :src="publicAsset('party/legacy-list/pk-history.webp')" />
          {{ formatContribution(row.contribution) }}
        </em>
      </article>
      <p>{{ t('room.pkRankComplete') }}</p>
    </div>
    <div v-else class="live-pk-rank-sheet__empty">
      <img alt="" :src="publicAsset('live-room/legacy/pk/rank-no-data.webp')" />
      <p>{{ t('common.noData') }}</p>
      <button v-if="side === 'left'" type="button" @click="support">
        {{ t('room.pkSupportStreamer') }}
      </button>
    </div>

    <template v-if="!loading && !failed && rows.length" #footer>
      <article class="live-pk-rank-sheet__self">
        <img
          v-if="self.rank >= 1 && self.rank <= 3"
          alt=""
          class="live-pk-rank-sheet__rank-image"
          :src="rankAsset(self.rank)"
        />
        <b v-else>{{ self.rank > 99 ? '99+' : self.rank || '-' }}</b>
        <AppAvatar :alt="self.nickname" :lazy="false" :size="44" :src="self.avatarUrl" />
        <span class="live-pk-rank-sheet__identity">
          <span>
            <strong>{{ self.nickname || self.id }}</strong>
            <small v-if="hasBadges(self)" class="live-pk-rank-sheet__badges">
              <AppUserLevelTag :level="self.levelName" size="s" />
              <img v-if="self.vip" alt="VIP" :src="publicAsset('common/vip.webp')" />
            </small>
          </span>
          <small class="live-pk-rank-sheet__self-score">
            <img alt="" :src="publicAsset('party/legacy-list/pk-history.webp')" />
            {{ formatContribution(self.contribution) }}
          </small>
        </span>
        <button v-if="side === 'left'" type="button" @click="support">
          {{ t('messages.support') }}
        </button>
      </article>
    </template>
  </AppPopup>
</template>

<style scoped lang="less">
.live-pk-rank-sheet :deep(.app-popup) {
  background: color-mix(in srgb, var(--color-accent) 16%, var(--color-bg)) !important;
  position: relative;
  overflow: hidden;
  isolation: isolate;
}

.live-pk-rank-sheet :deep(.app-popup__body),
.live-pk-rank-sheet :deep(.app-popup__footer) {
  position: relative;
  z-index: 1;
}

.live-pk-rank-sheet__mask {
  position: absolute;
  top: 0;
  right: 0;
  left: 0;
  z-index: 0;
  width: 100%;
  height: 64px;
  object-fit: fill;
  pointer-events: none;
}

.live-pk-rank-sheet__header {
  position: relative;
  display: flex;
  min-height: 56px;
  box-sizing: border-box;
  align-items: center;
  flex: 0 0 56px;
  gap: 8px;
  padding: 12px 16px;
  z-index: 1;
  border: 0;
  background: transparent;
}

.live-pk-rank-sheet__header-avatar {
  display: grid;
  width: 26px;
  height: 26px;
  flex: 0 0 26px;
  padding: 1px;
  border: 1px solid var(--color-pk-rank-avatar-border);
  border-radius: 50%;
  place-items: center;
}

.live-pk-rank-sheet__identity,
.live-pk-rank-sheet__identity > span {
  display: flex;
  min-width: 0;
}

.live-pk-rank-sheet__identity {
  flex: 1;
  flex-direction: column;
  justify-content: center;
  gap: 4px;
}

.live-pk-rank-sheet__header strong,
.live-pk-rank-sheet__identity strong {
  overflow: hidden;
  color: var(--color-text);
  text-overflow: ellipsis;
  white-space: nowrap;
}

.live-pk-rank-sheet__header strong {
  min-width: 0;
  flex: 1;
  font-size: 18px;
  font-weight: 500;
  line-height: 22px;
}

.live-pk-rank-sheet__state {
  display: grid;
  min-height: 0;
  flex: 1;
  border: 0;
  background: transparent;
  color: var(--color-text-muted);
  place-items: center;
}

.live-pk-rank-sheet__retry {
  width: 100%;
}

.live-pk-rank-sheet__list {
  min-height: 0;
  flex: 1;
  overflow: hidden auto;
  overscroll-behavior: contain;
  padding: 0 22px 0 18px;
  scrollbar-width: none;
  touch-action: pan-y;
  -webkit-overflow-scrolling: touch;
}

.live-pk-rank-sheet__list::-webkit-scrollbar {
  display: none;
}

.live-pk-rank-sheet__list article,
.live-pk-rank-sheet__self {
  display: flex;
  height: 64px;
  min-width: 0;
  box-sizing: border-box;
  align-items: center;
  gap: 8px;
}

.live-pk-rank-sheet__list article + article {
  border-top: 1px solid var(--color-border);
}

.live-pk-rank-sheet__list article > b,
.live-pk-rank-sheet__self > b,
.live-pk-rank-sheet__rank-image {
  width: 26px;
  flex: 0 0 26px;
  text-align: center;
}

.live-pk-rank-sheet__list article > b,
.live-pk-rank-sheet__self > b {
  color: var(--color-pk-rank-number);
  font-size: 14px;
}

.live-pk-rank-sheet__rank-image {
  height: 24px;
  object-fit: contain;
}

.live-pk-rank-sheet :deep(.avatar .app-image) {
  border: 0;
  background: transparent;
}

.live-pk-rank-sheet__identity > span {
  align-items: center;
  gap: 4px;
}

.live-pk-rank-sheet__identity strong {
  max-width: 142px;
  font-size: 14px;
  line-height: 17px;
}

.live-pk-rank-sheet__badges {
  display: flex;
  height: 14px;
  flex: 0 0 auto;
  align-items: center;
  gap: 3px;
}

.live-pk-rank-sheet__badges > img {
  width: 33px;
  height: 14px;
  object-fit: contain;
}

.live-pk-rank-sheet__country,
.live-pk-rank-sheet__self-score {
  display: flex;
  align-items: center;
  gap: 3px;
  overflow: hidden;
  color: var(--color-text-muted);
  font-size: 10px;
  line-height: 12px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.live-pk-rank-sheet__list article > em {
  display: flex;
  flex: 0 0 auto;
  align-items: center;
  gap: 3px;
  color: var(--color-pk-rank-contribution);
  font-size: 14px;
  font-style: normal;
}

.live-pk-rank-sheet__list article > em img,
.live-pk-rank-sheet__self-score img {
  width: 16px;
  height: 16px;
  object-fit: contain;
}

.live-pk-rank-sheet__list > p {
  margin: 8px 0 14px;
  color: var(--color-text-muted);
  font-size: 10px;
  text-align: center;
}

.live-pk-rank-sheet__empty {
  display: flex;
  min-height: 0;
  flex: 1;
  align-items: center;
  flex-direction: column;
  justify-content: center;
}

.live-pk-rank-sheet__empty > img {
  width: 160px;
  height: 160px;
  object-fit: contain;
}

.live-pk-rank-sheet__empty > p {
  margin: 16px 0 0;
  color: var(--color-text-muted);
  font-size: 16px;
  line-height: 20px;
}

.live-pk-rank-sheet__empty > button,
.live-pk-rank-sheet__self > button {
  border: 0;
  background: var(--gradient-primary);
  color: var(--color-text);
  font-weight: 700;
}

.live-pk-rank-sheet__empty > button {
  width: calc(100% - 24px);
  height: 44px;
  flex: 0 0 44px;
  margin-top: 88px;
  border-radius: 22px;
  font-size: 16px;
  font-weight: 500;
}

.live-pk-rank-sheet :deep(.app-popup__footer) {
  border-radius: 14px 14px 0 0;
  background: var(--gradient-pk-rank-self);
}

.live-pk-rank-sheet__self {
  height: 88px;
  padding: 0 12px;
}

.live-pk-rank-sheet__self > button {
  min-width: 70px;
  height: 30px;
  padding: 0 14px;
  border-radius: 15px;
  background: var(--gradient-pk-support);
  color: var(--color-pk-support-text);
  font-size: 13px;
}
</style>

<script setup lang="ts">
import { publicAsset } from '@/core/media/public-asset'
import AppAvatar from '@/main/components/AppAvatar.vue'
import AppEmptyState from '@/main/components/AppEmptyState.vue'
import AppPopup from '@/main/components/AppPopup.vue'
import AppUserLevelTag from '@/main/components/AppUserLevelTag.vue'
import { parseUserLevel } from '@/main/components/user-level'
import { useSessionStore } from '@/main/stores/session'
import { computed, nextTick, onBeforeUnmount, ref, shallowRef, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import type { Swiper as SwiperInstance } from 'swiper'
import { Swiper as SwiperView, SwiperSlide } from 'swiper/vue'
import 'swiper/css'
import type { RoomLaunchContext } from '../contracts'
import type {
  LiveAudienceMember,
  LiveAudienceSnapshot,
  LiveRankItem,
  LiveRankPeriod,
} from '../live-interaction-contracts'
import { liveInteractionQueries } from '../live-operations'

const props = withDefaults(
  defineProps<{
    context: RoomLaunchContext
    initialTab?: 'rank' | 'viewers'
    modelValue: boolean
  }>(),
  { initialTab: 'viewers' },
)
const emit = defineEmits<{
  profile: [member: { avatarUrl: string; id: string; name: string }]
  total: [value: number]
  'update:modelValue': [value: boolean]
}>()

const session = useSessionStore()
const { t } = useI18n()
const tab = ref<'rank' | 'viewers'>(props.initialTab)
const period = ref<LiveRankPeriod>('now')
const periods: readonly LiveRankPeriod[] = ['now', 'today', 'week']
const snapshot = ref<LiveAudienceSnapshot>(
  liveInteractionQueries.peekAudience(props.context.roomId) ?? {
    rows: (props.context.audience ?? []).map((member) => ({
      avatarUrl: member.avatarUrl,
      countryCode: '',
      displayName: member.displayName,
      id: member.id,
      levelName: '',
      vip: member.vip,
    })),
    total: props.context.onlineCount ?? 0,
  },
)
const ranks = ref<readonly LiveRankItem[]>(
  liveInteractionQueries.peekRank(props.context.roomId, period.value) ?? [],
)
const audienceLoading = ref(false)
const audienceFailed = ref(false)
const rankLoading = ref(false)
const rankFailed = ref(false)
let audienceController: AbortController | undefined
let rankController: AbortController | undefined
const mainSwiper = shallowRef<SwiperInstance>()
const rankSwiper = shallowRef<SwiperInstance>()

const visible = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value),
})
const boardRanks = computed(() => {
  const selfId = session.user?.id?.trim()
  const last = ranks.value.at(-1)
  if (!selfId || !last || last.id !== selfId) return ranks.value
  const occursEarlier = ranks.value.slice(0, -1).some((item) => item.id === selfId)
  const isPersonalTail = occursEarlier || last.rank <= 0 || last.rank > ranks.value.length
  return isPersonalTail ? ranks.value.slice(0, -1) : ranks.value
})
const podiumPlaces = [2, 1, 3] as const
const podium = computed(() =>
  period.value === 'week'
    ? podiumPlaces.map((place) => boardRanks.value.find((item) => item.rank === place) ?? null)
    : [],
)
const rankList = computed(() =>
  period.value === 'week'
    ? boardRanks.value.filter((item) => item.rank < 1 || item.rank > 3)
    : boardRanks.value,
)

function formatRankCost(value: number): string {
  if (value <= 0) return '-'
  if (value < 1_000) return value.toLocaleString('en')
  const units = [
    { divisor: 1_000_000_000, suffix: 'B' },
    { divisor: 1_000_000, suffix: 'M' },
    { divisor: 1_000, suffix: 'K' },
  ] as const
  const unit = units.find((candidate) => value >= candidate.divisor) ?? units[2]
  const compact = (value / unit.divisor)
    .toFixed(2)
    .replace(/\.00$/, '')
    .replace(/(\.\d)0$/, '$1')
  return `${compact}${unit.suffix}`
}

function hasRankBadges(ranker: LiveRankItem | null): boolean {
  return Boolean(ranker && (parseUserLevel(ranker.levelName) !== null || ranker.vip))
}

function showMember(member: LiveAudienceMember): void {
  emit('profile', { avatarUrl: member.avatarUrl, id: member.id, name: member.displayName })
}

function showRanker(member: LiveRankItem): void {
  emit('profile', { avatarUrl: member.avatarUrl, id: member.id, name: member.name })
}

async function loadAudience(): Promise<void> {
  audienceController?.abort()
  const controller = new AbortController()
  audienceController = controller
  audienceLoading.value = snapshot.value.rows.length === 0
  audienceFailed.value = false
  try {
    snapshot.value = await liveInteractionQueries.getAudience(props.context, controller.signal)
    emit('total', snapshot.value.total)
  } catch {
    if (!controller.signal.aborted && snapshot.value.rows.length === 0) audienceFailed.value = true
  } finally {
    if (!controller.signal.aborted) audienceLoading.value = false
  }
}

async function loadRank(): Promise<void> {
  const cached = liveInteractionQueries.peekRank(props.context.roomId, period.value)
  if (cached) ranks.value = cached
  rankController?.abort()
  const controller = new AbortController()
  rankController = controller
  rankLoading.value = ranks.value.length === 0
  rankFailed.value = false
  try {
    ranks.value = await liveInteractionQueries.getRank(
      props.context,
      period.value,
      controller.signal,
    )
  } catch {
    if (!controller.signal.aborted && ranks.value.length === 0) rankFailed.value = true
  } finally {
    if (!controller.signal.aborted) rankLoading.value = false
  }
}

function selectTab(next: 'rank' | 'viewers'): void {
  if (tab.value === next) return
  tab.value = next
  const nextIndex = next === 'viewers' ? 0 : 1
  if (mainSwiper.value?.activeIndex !== nextIndex) mainSwiper.value?.slideTo(nextIndex)
  if (next === 'rank') void loadRank()
  else void loadAudience()
}

function handleMainSwipe(swiper: SwiperInstance): void {
  const next = swiper.activeIndex === 0 ? 'viewers' : 'rank'
  if (tab.value === next) return
  tab.value = next
  if (next === 'rank') void loadRank()
  else void loadAudience()
}

function activatePeriod(next: LiveRankPeriod): void {
  if (period.value === next) return
  period.value = next
  ranks.value = liveInteractionQueries.peekRank(props.context.roomId, next) ?? []
  void loadRank()
}

function selectPeriod(next: LiveRankPeriod): void {
  activatePeriod(next)
  const nextIndex = periods.indexOf(next)
  if (rankSwiper.value?.activeIndex !== nextIndex) rankSwiper.value?.slideTo(nextIndex)
}

function handlePeriodSwipe(swiper: SwiperInstance): void {
  const next = periods[swiper.activeIndex]
  if (next) activatePeriod(next)
}

watch(
  () => props.modelValue,
  (open) => {
    if (!open) {
      audienceController?.abort()
      rankController?.abort()
      return
    }
    tab.value = props.initialTab
    void nextTick(() => mainSwiper.value?.slideTo(tab.value === 'viewers' ? 0 : 1, 0))
    if (tab.value === 'rank') void loadRank()
    else void loadAudience()
  },
)
onBeforeUnmount(() => {
  audienceController?.abort()
  rankController?.abort()
})
</script>

<template>
  <AppPopup
    v-model="visible"
    bottom-inset-owner="content"
    class="legacy-live-rank"
    :closeable="false"
    :expand-for-bottom-inset="false"
    panel-height="min(419px, 68dvh)"
    panel-max-height="min(419px, 68dvh)"
  >
    <nav class="legacy-live-rank__main-tabs" role="tablist">
      <button
        :aria-selected="tab === 'viewers'"
        :class="{ active: tab === 'viewers' }"
        role="tab"
        type="button"
        @click="selectTab('viewers')"
      >
        {{ t('room.viewers') }}
      </button>
      <button
        :aria-selected="tab === 'rank'"
        :class="{ active: tab === 'rank' }"
        role="tab"
        type="button"
        @click="selectTab('rank')"
      >
        {{ t('room.topGifter') }}
      </button>
    </nav>

    <SwiperView
      class="legacy-live-rank__pages"
      :initial-slide="initialTab === 'rank' ? 1 : 0"
      @slide-change="handleMainSwipe"
      @swiper="mainSwiper = $event"
    >
      <SwiperSlide>
        <section class="legacy-viewers" data-room-scroll>
          <div v-if="audienceLoading" class="legacy-sheet-loading">
            <AppLoading />
          </div>
          <button
            v-else-if="audienceFailed"
            class="legacy-sheet-state"
            type="button"
            @click="loadAudience"
          >
            {{ t('room.viewersUnavailable') }} · {{ t('room.chatRetry') }}
          </button>
          <div v-else-if="snapshot.rows.length" class="legacy-viewers__list">
            <button
              v-for="viewer in snapshot.rows"
              :key="viewer.id"
              type="button"
              @click="showMember(viewer)"
            >
              <AppAvatar :alt="viewer.displayName" :size="38" :src="viewer.avatarUrl" />
              <span class="legacy-viewers__identity">
                <strong>{{ viewer.displayName }}</strong>
                <small v-if="parseUserLevel(viewer.levelName) !== null || viewer.vip">
                  <AppUserLevelTag :level="viewer.levelName" size="s" />
                  <img
                    v-if="viewer.vip"
                    alt="VIP"
                    class="legacy-vip-badge"
                    :src="publicAsset('common/vip.webp')"
                  />
                </small>
              </span>
            </button>
          </div>
          <AppEmptyState v-else class="legacy-sheet-state legacy-sheet-state--empty" size="popup" />
        </section>
      </SwiperSlide>

      <SwiperSlide>
        <section class="legacy-fans-rank">
          <nav class="legacy-fans-rank__periods" role="tablist">
            <button
              v-for="item in periods"
              :key="item"
              :aria-selected="period === item"
              :class="{ active: period === item }"
              role="tab"
              type="button"
              @click="selectPeriod(item)"
            >
              {{ t(`room.${item}`) }}
            </button>
          </nav>
          <SwiperView
            class="legacy-fans-rank__pages"
            :show-indicators="false"
            @slide-change="handlePeriodSwipe"
            @swiper="rankSwiper = $event"
          >
            <SwiperSlide v-for="item in periods" :key="item">
              <div class="legacy-fans-rank__body" data-room-scroll>
                <div v-if="rankLoading" class="legacy-sheet-loading">
                  <AppLoading />
                </div>
                <button
                  v-else-if="rankFailed"
                  class="legacy-sheet-state"
                  type="button"
                  @click="loadRank"
                >
                  {{ t('room.rankingUnavailable') }} · {{ t('room.chatRetry') }}
                </button>
                <template v-else-if="boardRanks.length">
                  <div v-if="podium.length" class="legacy-rank-podium">
                    <img
                      alt=""
                      aria-hidden="true"
                      class="legacy-rank-podium__stage"
                      :src="publicAsset('live-room/rank/podium.png')"
                    />
                    <button
                      v-for="(ranker, index) in podium"
                      :key="ranker?.id || `empty-${podiumPlaces[index]}`"
                      :class="[
                        `place-${podiumPlaces[index]}`,
                        { 'has-badges': hasRankBadges(ranker), 'is-empty': !ranker },
                      ]"
                      :disabled="!ranker"
                      type="button"
                      @click="ranker && showRanker(ranker)"
                    >
                      <span class="legacy-rank-podium__profile">
                        <AppAvatar
                          :alt="ranker?.name || ''"
                          :size="55"
                          :src="ranker?.avatarUrl || ''"
                        />
                        <img
                          alt=""
                          class="legacy-rank-podium__crown"
                          :src="publicAsset(`live-room/legacy/crown-${podiumPlaces[index]}.webp`)"
                        />
                      </span>
                      <strong>{{ ranker?.name || '-' }}</strong>
                      <span v-if="hasRankBadges(ranker)" class="legacy-rank-podium__badges">
                        <AppUserLevelTag :level="ranker?.levelName" size="s" />
                        <img
                          v-if="ranker?.vip"
                          alt="VIP"
                          class="legacy-vip-badge"
                          :src="publicAsset('common/vip.webp')"
                        />
                      </span>
                      <small>
                        <img alt="" :src="publicAsset('common/diamond.png')" />
                        {{ ranker ? formatRankCost(ranker.cost) : '-' }}
                      </small>
                    </button>
                  </div>
                  <div class="legacy-rank-list">
                    <button
                      v-for="ranker in rankList"
                      :key="ranker.id"
                      type="button"
                      @click="showRanker(ranker)"
                    >
                      <img
                        v-if="ranker.rank >= 1 && ranker.rank <= 3"
                        alt=""
                        class="legacy-rank-list__rank"
                        :src="publicAsset(`live-room/legacy/crown-${ranker.rank}.webp`)"
                      />
                      <b v-else>{{ ranker.rank }}</b>
                      <AppAvatar :alt="ranker.name" :size="38" :src="ranker.avatarUrl" />
                      <span class="legacy-rank-list__identity">
                        <strong>{{ ranker.name }}</strong>
                        <small v-if="parseUserLevel(ranker.levelName) !== null || ranker.vip">
                          <AppUserLevelTag :level="ranker.levelName" size="s" />
                          <img
                            v-if="ranker.vip"
                            alt="VIP"
                            class="legacy-vip-badge"
                            :src="publicAsset('common/vip.webp')"
                          />
                        </small>
                      </span>
                      <i>
                        <img alt="" :src="publicAsset('common/diamond.png')" />
                        {{ formatRankCost(ranker.cost) }}
                      </i>
                    </button>
                  </div>
                </template>
                <AppEmptyState
                  v-else
                  class="legacy-sheet-state legacy-sheet-state--empty"
                  size="popup"
                />
              </div>
            </SwiperSlide>
          </SwiperView>
        </section>
      </SwiperSlide>
    </SwiperView>
  </AppPopup>
</template>

<style scoped lang="less">
:deep(.legacy-live-rank.app-popup-host) {
  border: 0;
  background: var(--panel-bg) !important;
  box-shadow: none;
}

.legacy-live-rank :deep(.app-popup) {
  display: flex;
  height: min(419px, 68dvh);
  max-height: min(419px, 68dvh);
  min-height: 0;
  box-sizing: border-box;
  flex-direction: column;
  overflow: hidden;
  padding: 0;
  border-radius: 0;
  background: var(--panel-bg);
}

.legacy-live-rank :deep(.app-popup__handle) {
  display: none;
}

.legacy-live-rank__main-tabs {
  position: relative;
  display: flex;
  width: 239px;
  height: 52px;
  box-sizing: border-box;
  justify-content: space-between;
  margin: 0 auto;
  padding-top: 23px;
  flex: 0 0 52px;
}

.legacy-live-rank__main-tabs::before {
  position: absolute;
  bottom: 0;
  left: 50%;
  width: min(100vw, 430px);
  height: 1px;
  background: var(--color-live-rank-tab-divider);
  content: '';
  transform: translateX(-50%);
}

.legacy-live-rank__main-tabs button {
  position: relative;
  height: 18px;
  padding: 0;
  border: 0;
  background: transparent;
  color: var(--color-text);
  font-family:
    'TT Norms Pro',
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    sans-serif;
  font-size: 15px;
  font-weight: 700;
  line-height: 15px;
}

.legacy-live-rank__main-tabs button.active::after {
  position: absolute;
  bottom: -11px;
  left: 50%;
  z-index: 1;
  width: 14px;
  height: 3px;
  border-radius: 34px;
  background: var(--gradient-live-rank-tab-indicator);
  content: '';
  transform: translateX(-50%);
}

.legacy-viewers,
.legacy-fans-rank__body {
  min-height: 0;
  flex: 1;
  overflow-y: auto;
  overscroll-behavior: contain;
  scrollbar-width: none;
  touch-action: pan-y;
  -webkit-overflow-scrolling: touch;
}

.legacy-viewers::-webkit-scrollbar,
.legacy-fans-rank__body::-webkit-scrollbar {
  display: none;
}

.legacy-fans-rank__pages {
  width: 100%;
  min-height: 0;
  margin-top: 16px;
  flex: 1;
}

.legacy-fans-rank__pages :deep(.swiper-wrapper),
.legacy-fans-rank__pages :deep(.swiper-slide) {
  height: 100%;
  min-height: 0;
}

.legacy-fans-rank__pages :deep(.swiper-slide) {
  display: flex;
  overflow: hidden;
  flex-direction: column;
}

.legacy-live-rank__pages {
  width: 100%;
  min-height: 0;
  flex: 1;
}

.legacy-live-rank__pages :deep(.swiper-wrapper),
.legacy-live-rank__pages :deep(.swiper-slide) {
  height: 100%;
  min-height: 0;
}

.legacy-live-rank__pages :deep(.swiper-slide) {
  display: flex;
  min-width: 0;
  overflow: hidden;
  flex-direction: column;
}

.legacy-viewers__list {
  display: grid;
  width: min(100%, 375px);
  margin: 0 auto;
  padding: 11px 0 calc(19px + var(--app-popup-content-bottom-inset));
}

.legacy-viewers__list > button,
.legacy-rank-list > button {
  display: flex;
  width: 100%;
  height: 56px;
  min-width: 0;
  box-sizing: border-box;
  align-items: center;
  border: 0;
  background: transparent;
  color: var(--color-text);
  text-align: left;
}

.legacy-viewers__list > button {
  gap: 6px;
}

.legacy-viewers__identity,
.legacy-rank-list__identity {
  display: flex;
  min-width: 0;
  flex: 1;
  flex-direction: column;
  gap: 3px;
}

.legacy-viewers strong,
.legacy-rank-list strong {
  max-width: 100%;
  overflow: hidden;
  font-family:
    'TT Norms Pro',
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    sans-serif;
  font-size: 14px;
  font-weight: 700;
  line-height: 14px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.legacy-viewers small,
.legacy-rank-list small {
  display: flex;
  height: 14px;
  min-width: 0;
  align-items: center;
  gap: 4px;
  color: var(--color-live-rank-meta);
}

.legacy-vip-badge {
  display: block;
  width: 33px;
  height: 14px;
  flex: 0 0 33px;
  object-fit: contain;
}

.legacy-fans-rank {
  display: flex;
  min-height: 0;
  flex: 1;
  flex-direction: column;
}

.legacy-fans-rank__periods {
  display: flex;
  width: min(330px, calc(100% - 32px));
  height: 34px;
  justify-content: space-between;
  gap: 15px;
  margin: 12px auto 0;
  flex: 0 0 34px;
}

.legacy-fans-rank__periods button {
  width: 100px;
  height: 34px;
  padding: 0;
  flex: 1 1 100px;
  border: 0;
  border-radius: 60px;
  background: var(--color-live-rank-period-bg);
  color: var(--color-text);
  font-family:
    'TT Norms Pro',
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    sans-serif;
  font-size: 14px;
  font-weight: 700;
  line-height: 14px;
}

.legacy-fans-rank__periods button.active {
  background: var(--gradient-live-rank-period-active);
}

.legacy-fans-rank__body {
  min-height: 0;
  flex: 1;
}

.legacy-rank-podium {
  position: relative;
  display: grid;
  width: min(336px, calc(100% - 16px));
  height: 165px;
  grid-template-columns: 35.4167% 30.3571% 34.2262%;
  margin: 10px auto 0;
}

.legacy-rank-podium__stage {
  position: absolute;
  bottom: 0;
  left: 50%;
  z-index: 0;
  display: block;
  width: min(335px, 100%);
  height: auto;
  pointer-events: none;
  transform: translateX(-50%);
}

.legacy-rank-podium > button {
  position: relative;
  display: block;
  min-width: 0;
  height: 165px;
  padding: 0;
  border: 0;
  background: transparent;
  color: var(--color-text);
}

.legacy-rank-podium > button.is-empty {
  opacity: 0.42;
}

.legacy-rank-podium__profile {
  position: absolute;
  left: 50%;
  z-index: 2;
  display: block;
  width: 55px;
  height: 55px;
  transform: translateX(-50%);
}

.legacy-rank-podium .place-1 .legacy-rank-podium__profile {
  top: 8px;
}

.legacy-rank-podium .place-2 .legacy-rank-podium__profile {
  top: 25px;
}

.legacy-rank-podium .place-3 .legacy-rank-podium__profile {
  top: 32px;
}

.legacy-rank-podium__crown {
  position: absolute;
  top: -20px;
  left: 50%;
  z-index: 2;
  width: 25px;
  height: 25px;
  object-fit: contain;
  transform: translateX(-50%);
}

.legacy-rank-podium strong {
  position: absolute;
  left: 50%;
  z-index: 3;
  width: calc(100% - 8px);
  overflow: hidden;
  font-family:
    'TT Norms Pro',
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    sans-serif;
  font-size: 13px;
  font-weight: 700;
  line-height: 13px;
  text-align: center;
  text-overflow: ellipsis;
  transform: translateX(-50%);
  white-space: nowrap;
}

.legacy-rank-podium .place-1 > strong {
  top: 66px;
}

.legacy-rank-podium .place-2 > strong {
  top: 86px;
}

.legacy-rank-podium .place-3 > strong {
  top: 93px;
}

.legacy-rank-podium__badges {
  position: absolute;
  left: 50%;
  z-index: 3;
  display: flex;
  max-width: calc(100% - 8px);
  height: 14px;
  align-items: center;
  justify-content: center;
  gap: 3px;
  transform: translateX(-50%);
}

.legacy-rank-podium .place-1 .legacy-rank-podium__badges {
  top: 83px;
}

.legacy-rank-podium .place-2 .legacy-rank-podium__badges {
  top: 103px;
}

.legacy-rank-podium .place-3 .legacy-rank-podium__badges {
  top: 110px;
}

.legacy-rank-podium small,
.legacy-rank-list i {
  display: flex;
  align-items: center;
  gap: 2px;
  color: var(--color-live-rank-meta);
  font-family:
    'TT Norms Pro',
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    sans-serif;
  font-size: 11px;
  line-height: 18px;
  font-style: normal;
}

.legacy-rank-podium small {
  position: absolute;
  left: 50%;
  z-index: 3;
  transform: translateX(-50%);
  white-space: nowrap;
}

.legacy-rank-podium .place-1 > small {
  top: 83px;
}

.legacy-rank-podium .place-2 > small {
  top: 103px;
}

.legacy-rank-podium .place-3 > small {
  top: 110px;
}

.legacy-rank-podium .place-1.has-badges > small {
  top: 100px;
}

.legacy-rank-podium .place-2.has-badges > small {
  top: 120px;
}

.legacy-rank-podium .place-3.has-badges > small {
  top: 127px;
}

.legacy-rank-podium small img,
.legacy-rank-list i img {
  width: 14px;
  height: 14px;
  object-fit: contain;
}

.legacy-rank-list {
  display: grid;
  width: min(100%, 375px);
  margin: 0 auto;
  padding: 0 0 calc(20px + var(--app-popup-content-bottom-inset));
}

.legacy-rank-list > button {
  gap: 6px;
  padding: 0 26px 0 7px;
}

.legacy-rank-list > button > b,
.legacy-rank-list__rank {
  display: grid;
  width: 25px;
  height: 25px;
  flex: 0 0 25px;
  color: var(--color-live-rank-number);
  font-size: 14px;
  font-weight: 700;
  place-items: center;
}

.legacy-rank-list__rank {
  object-fit: contain;
}

.legacy-rank-list i {
  min-width: 42px;
  justify-content: flex-end;
  margin-left: auto;
  color: var(--color-text);
  font-size: 12px;
  font-weight: 700;
  text-align: right;
  white-space: nowrap;
}

.legacy-sheet-loading,
.legacy-sheet-state {
  display: grid;
  width: 100%;
  height: 100%;
  min-height: 220px;
  margin: 0;
  padding: 0;
  border: 0;
  background: transparent;
  color: var(--color-text-muted);
  font-size: 13px;
  place-items: center;
}

.legacy-live-rank button:focus-visible {
  outline: 2px solid var(--color-link);
  outline-offset: -2px;
}

@media (prefers-reduced-motion: reduce) {
  .legacy-live-rank :deep(.swiper-wrapper) {
    transition-duration: 1ms !important;
  }
}
</style>

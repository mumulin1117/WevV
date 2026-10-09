<script setup lang="ts">
import { publicAsset } from '@/core/media/public-asset'
import AppAvatar from '@/main/components/AppAvatar.vue'
import AppIcon from '@/main/components/AppIcon.vue'
import LiveEffectPlayer from './LiveEffectPlayer.vue'
import type { PkRoomEngineState } from '@/room/runtime/rtc-room-engine'
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import type { LivePkSessionPhase } from '../live-pk-session'
import { LIVE_PK_STATUS, type LivePkDetail } from '../live-pk-contracts'
import { displayLivePkRanks } from '../live-pk-display'

const props = defineProps<{
  detail: LivePkDetail
  muted: boolean
  phase: LivePkSessionPhase
  reducedMotion: boolean
  state: PkRoomEngineState
  status: number
}>()

const emit = defineEmits<{
  opponent: []
  rank: [side: 'left' | 'right']
  surfaceChange: [side: 'left' | 'right', element: HTMLElement | null]
  toggleMute: []
}>()

const { t } = useI18n()
const hostSurface = ref<HTMLElement | null>(null)
const opponentSurface = ref<HTMLElement | null>(null)
const remaining = ref(0)
let countdownTimer = 0
let pkAnimationSequence = 0
let readyAnimationPkId = ''
type PkAnimationKind = 'ready' | 'result' | 'start'
interface PkAnimationState {
  align: 'center' | 'left'
  id: number
  kind: PkAnimationKind
  url: string
}
const pkAnimation = ref<PkAnimationState | null>(null)

const leftScore = computed(() => props.detail.leftScore ?? 0)
const rightScore = computed(() => props.detail.rightScore ?? 0)
const leftRatio = computed(() => {
  const total = leftScore.value + rightScore.value
  if (total <= 0) return 50
  return Math.max(20, Math.min(80, (leftScore.value / total) * 100))
})
const scoreStateAsset = computed(() => {
  if (leftRatio.value > 50) return 'progress-win.webp'
  if (leftRatio.value < 50) return 'progress-loss.webp'
  return 'progress-draw.webp'
})
const punishing = computed(() => props.status === LIVE_PK_STATUS.punishing)
const countdown = computed(() => {
  const seconds = Math.max(0, remaining.value)
  return `${punishing.value ? t('room.pkPunish') : ''}${Math.floor(seconds / 60)}:${String(
    seconds % 60,
  ).padStart(2, '0')}`
})

function finishPkAnimation(id: number): void {
  if (pkAnimation.value?.id === id) pkAnimation.value = null
}

function playPkAnimation(kind: PkAnimationKind): void {
  if (props.reducedMotion) return
  let asset = 'pk-start.svga'
  let align: PkAnimationState['align'] = 'center'
  if (kind === 'ready') asset = 'pk-ready-end.svga'
  if (kind === 'result') {
    align = leftScore.value === rightScore.value ? 'center' : 'left'
    asset =
      leftScore.value === rightScore.value
        ? 'pk-result-draw.svga'
        : leftScore.value > rightScore.value
          ? 'pk-result-win.svga'
          : 'pk-result-lose.svga'
  }
  pkAnimationSequence += 1
  pkAnimation.value = {
    align,
    id: pkAnimationSequence,
    kind,
    url: publicAsset('live-room/legacy/pk/' + asset),
  }
}

function restartCountdown(value: number): void {
  window.clearInterval(countdownTimer)
  remaining.value = Math.max(0, Math.trunc(value))
  if (!remaining.value) return
  countdownTimer = window.setInterval(() => {
    remaining.value = Math.max(0, remaining.value - 1)
    if (!remaining.value) window.clearInterval(countdownTimer)
  }, 1_000)
}

watch(() => props.detail.remainSeconds, restartCountdown, { immediate: true })
watch(
  () => props.status,
  (status, previous) => {
    if (status === LIVE_PK_STATUS.inPk && previous !== LIVE_PK_STATUS.inPk) {
      readyAnimationPkId = ''
      playPkAnimation('start')
    } else if (status === LIVE_PK_STATUS.punishing && previous !== LIVE_PK_STATUS.punishing) {
      playPkAnimation('result')
    }
  },
  { immediate: true },
)
watch(remaining, (value, previous) => {
  if (
    props.status === LIVE_PK_STATUS.inPk &&
    value > 0 &&
    value <= 5 &&
    previous > 5 &&
    readyAnimationPkId !== props.detail.pkId
  ) {
    readyAnimationPkId = props.detail.pkId
    playPkAnimation('ready')
  }
})
watch(
  () => props.reducedMotion,
  (reduced) => {
    if (reduced) pkAnimation.value = null
  },
)

onMounted(() => {
  emit('surfaceChange', 'left', hostSurface.value)
  emit('surfaceChange', 'right', opponentSurface.value)
})
onBeforeUnmount(() => {
  window.clearInterval(countdownTimer)
  emit('surfaceChange', 'left', null)
  emit('surfaceChange', 'right', null)
})
</script>

<template>
  <section class="legacy-pk" :aria-label="t('room.pkBattle')">
    <div class="legacy-pk__scoreboard">
      <div class="legacy-pk__progress">
        <div class="legacy-pk__progress-left" :style="{ width: `${leftRatio}%` }">
          <img
            alt=""
            class="legacy-pk__result"
            :src="publicAsset(`live-room/legacy/pk/${scoreStateAsset}`)"
          />
        </div>
        <div class="legacy-pk__progress-right" :style="{ width: `${100 - leftRatio}%` }" />
        <div
          class="legacy-pk__progress-mask"
          :style="{
            backgroundImage: `url(${publicAsset('live-room/legacy/pk/progress-mask.webp')})`,
          }"
        />
        <strong class="legacy-pk__score legacy-pk__score--left">
          <img alt="" :src="publicAsset('live-room/legacy/pk/score.webp')" />
          {{ leftScore }}
        </strong>
        <strong class="legacy-pk__score legacy-pk__score--right">
          {{ rightScore }}
          <img alt="" :src="publicAsset('live-room/legacy/pk/score.webp')" />
        </strong>
      </div>
      <time>{{ countdown }}</time>
      <span v-if="phase === 'recovering'" class="legacy-pk__sync" role="status">
        {{ t('room.pkRecovering') }}
      </span>
    </div>

    <div
      v-if="pkAnimation"
      class="legacy-pk__animation"
      :class="{ 'legacy-pk__animation--left': pkAnimation.align === 'left' }"
      aria-hidden="true"
    >
      <div class="legacy-pk__animation-half">
        <div
          :key="pkAnimation.id"
          class="legacy-pk__animation-player"
          :class="{
            'is-ready': pkAnimation.kind === 'ready',
            'is-start': pkAnimation.kind === 'start',
          }"
        >
          <LiveEffectPlayer
            :url="pkAnimation.url"
            @error="finishPkAnimation(pkAnimation.id)"
            @finished="finishPkAnimation(pkAnimation.id)"
          />
        </div>
      </div>
    </div>

    <div class="legacy-pk__pane legacy-pk__pane--left">
      <div ref="hostSurface" class="legacy-pk__host-video" />
      <button
        class="legacy-pk__rank legacy-pk__rank--left"
        type="button"
        :aria-label="t('room.pkLeftRank')"
        @click="emit('rank', 'left')"
      >
        <AppIcon class="legacy-pk__rank-arrow" name="chevron" :size="17" />
        <span
          v-for="(item, index) in displayLivePkRanks(detail.leftTop3)"
          :key="item?.id || `left-empty-${index}`"
        >
          <AppAvatar v-if="item" :alt="item.nickname" :size="26" :src="item.avatarUrl" />
          <img
            v-else
            alt=""
            class="legacy-pk__rank-empty"
            :src="publicAsset('live-room/legacy/pk/top-empty.webp')"
          />
          <img
            alt=""
            class="legacy-pk__rank-medal"
            :src="publicAsset(`live-room/legacy/pk/top-${index + 1}.webp`)"
          />
        </span>
      </button>
    </div>

    <div class="legacy-pk__pane legacy-pk__pane--right">
      <div class="legacy-pk__opponent-fallback">
        <AppAvatar :alt="detail.rightName" :lazy="false" :size="100" :src="detail.rightAvatarUrl" />
      </div>
      <div ref="opponentSurface" class="legacy-pk__opponent-video" />
      <button
        class="legacy-pk__volume"
        type="button"
        :aria-label="muted ? t('room.pkUnmute') : t('room.pkMute')"
        @click="emit('toggleMute')"
      >
        <img alt="" :src="publicAsset(`live-room/legacy/pk/volume-${muted ? 'off' : 'on'}.webp`)" />
      </button>
      <div
        v-if="state !== 'active'"
        class="legacy-pk__opponent-wait"
        :class="{ failed: state === 'failed' }"
      >
        <i v-if="state !== 'failed'" />
        <span>{{
          state === 'failed' ? t('room.pkVideoUnavailable') : t('room.pkConnecting')
        }}</span>
      </div>
      <button class="legacy-pk__opponent" type="button" @click="emit('opponent')">
        <span>
          <AppAvatar :alt="detail.rightName" :size="24" :src="detail.rightAvatarUrl" />
        </span>
        <strong>{{ detail.rightName }}</strong>
      </button>
      <button
        class="legacy-pk__rank legacy-pk__rank--right"
        type="button"
        :aria-label="t('room.pkRightRank')"
        @click="emit('rank', 'right')"
      >
        <AppIcon class="legacy-pk__rank-arrow" name="chevron" :size="17" />
        <span
          v-for="(item, index) in displayLivePkRanks(detail.rightTop3)"
          :key="item?.id || `right-empty-${index}`"
        >
          <AppAvatar v-if="item" :alt="item.nickname" :size="26" :src="item.avatarUrl" />
          <img
            v-else
            alt=""
            class="legacy-pk__rank-empty"
            :src="publicAsset('live-room/legacy/pk/top-empty.webp')"
          />
          <img
            alt=""
            class="legacy-pk__rank-medal"
            :src="publicAsset(`live-room/legacy/pk/top-${index + 1}.webp`)"
          />
        </span>
      </button>
    </div>
  </section>
</template>

<style scoped lang="less">
.legacy-pk {
  position: absolute;
  top: var(--pk-stage-top, calc(var(--safe-top) + 95px));
  right: 0;
  left: 0;
  z-index: 10;
  display: flex;
  height: var(--pk-stage-height, 366px);
  overflow: hidden;
  pointer-events: none;
}

.legacy-pk__animation {
  position: absolute;
  top: 0;
  right: 0;
  left: 0;
  z-index: 9;
  display: flex;
  height: var(--pk-video-height, 334px);
  justify-content: center;
  pointer-events: none;
}

.legacy-pk__animation--left {
  justify-content: flex-start;
}

.legacy-pk__animation-half {
  display: grid;
  width: 50%;
  height: 100%;
  place-items: center;
}

.legacy-pk__animation-player {
  width: 100px;
  height: 100px;
}

.legacy-pk__animation-player.is-start {
  width: 171px;
  height: 64px;
}

.legacy-pk__animation-player.is-ready {
  width: 80px;
  height: 80px;
}

.legacy-pk__pane {
  position: relative;
  width: 50%;
  height: 100%;
  overflow: hidden;
}

.legacy-pk__pane--right {
  background: var(--color-media-bg);
}

.legacy-pk__host-video,
.legacy-pk__opponent-fallback,
.legacy-pk__opponent-video {
  position: absolute;
  top: 0;
  right: 0;
  left: 0;
  height: var(--pk-video-height, 334px);
  overflow: hidden;
}

.legacy-pk__host-video {
  z-index: 1;

  :deep(video) {
    width: 100% !important;
    height: 100% !important;
    object-fit: cover !important;
  }
}

.legacy-pk__opponent-fallback {
  display: grid;
  z-index: 1;
  place-items: center;
}

.legacy-pk__opponent-fallback :deep(.avatar) {
  overflow: hidden;
  border-radius: 50%;
}

.legacy-pk__opponent-video {
  z-index: 2;

  :deep(video) {
    width: 100% !important;
    height: 100% !important;
    object-fit: cover !important;
  }
}

.legacy-pk__opponent-wait {
  position: absolute;
  z-index: 3;
  top: 0;
  right: 0;
  left: 0;
  display: grid;
  height: var(--pk-video-height, 334px);
  align-content: center;
  justify-items: center;
  gap: 8px;
  color: var(--color-on-dark-secondary);
  font-size: 11px;
  pointer-events: none;

  i {
    width: 22px;
    height: 22px;
    border: 2px solid var(--color-on-dark-border-strong);
    border-top-color: var(--color-on-dark);
    border-radius: 50%;
    animation: legacy-pk-spin 0.8s linear infinite;
  }

  &.failed {
    background: var(--color-scrim-soft);
  }
}

.legacy-pk__scoreboard {
  position: absolute;
  top: 0;
  right: 0;
  left: 0;
  z-index: 10;
  display: flex;
  align-items: center;
  flex-direction: column;
}

.legacy-pk__progress {
  position: relative;
  width: calc(100% - 32px);
  height: 20px;
  overflow: hidden;
  border-radius: 999px;
  background: var(--color-on-dark-fill);
}

.legacy-pk__progress-left,
.legacy-pk__progress-right {
  position: absolute;
  top: 0;
  height: 100%;
  transition: width 0.3s ease;
}

.legacy-pk__progress-left {
  left: 0;
  z-index: 1;
  background: linear-gradient(90deg, var(--color-pk-team-pink), var(--color-primary));
}

.legacy-pk__progress-right {
  right: 0;
  background: linear-gradient(90deg, var(--color-pk-team-blue), var(--color-link));
}

.legacy-pk__result {
  position: absolute;
  top: -4px;
  right: -14px;
  width: 28px;
  height: 28px;
  object-fit: contain;
}

.legacy-pk__progress-mask {
  position: absolute;
  z-index: 2;
  inset: 0;
  background-position: center;
  background-repeat: no-repeat;
  background-size: 100% 100%;
}

.legacy-pk__score {
  position: absolute;
  top: 0;
  z-index: 3;
  display: flex;
  height: 20px;
  align-items: center;
  gap: 2px;
  color: var(--color-pk-rank-number);
  font-size: 13px;
  font-weight: 600;

  img {
    width: 16px;
    height: 16px;
    object-fit: contain;
  }
}

.legacy-pk__score--left {
  left: 14px;
}

.legacy-pk__score--right {
  right: 14px;
}

.legacy-pk__scoreboard time {
  min-width: 54px;
  height: 20px;
  padding: 0 12px;
  border-radius: 0 0 12px 12px;
  background: var(--color-scrim-soft);
  color: var(--color-pk-rank-number);
  font-size: 13px;
  font-style: normal;
  line-height: 20px;
  text-align: center;
  backdrop-filter: blur(10px);
}

.legacy-pk__sync {
  margin-top: 4px;
  padding: 3px 8px;
  border-radius: 999px;
  background: var(--color-scrim);
  color: var(--color-on-dark-strong);
  font-size: 10px;
  line-height: 14px;
  backdrop-filter: blur(8px);
}

.legacy-pk__volume {
  position: absolute;
  top: 28px;
  right: 8px;
  z-index: 5;
  display: grid;
  width: 32px;
  height: 32px;
  padding: 6px;
  border: 0;
  border-radius: 50%;
  background: transparent;
  pointer-events: auto;
  place-items: center;

  img {
    width: 100%;
    height: 100%;
    object-fit: contain;
  }
}

.legacy-pk__opponent {
  position: absolute;
  right: 0;
  bottom: 40px;
  z-index: 4;
  display: flex;
  height: 32px;
  max-width: 100%;
  align-items: center;
  padding: 0 3px;
  border: 0;
  border-radius: 16px 0 0 16px;
  background: var(--color-scrim-soft);
  pointer-events: auto;

  > span {
    display: grid;
    width: 26px;
    height: 26px;
    flex: 0 0 auto;
    border-radius: 50%;
    background: color-mix(in srgb, var(--color-pk-team-blue) 62%, var(--color-text));
    place-items: center;
  }

  strong {
    max-width: 120px;
    overflow: hidden;
    padding: 0 4px;
    color: var(--color-on-dark);
    font-size: 13px;
    line-height: 15px;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
}

.legacy-pk__rank {
  position: absolute;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 5;
  display: flex;
  width: 100%;
  height: 32px;
  align-items: center;
  gap: 8px;
  padding: 0 16px;
  border: 0;
  background: linear-gradient(
    90deg,
    color-mix(in srgb, var(--color-pk-team-pink) 20%, transparent),
    transparent
  );
  color: var(--color-on-dark-disabled);
  pointer-events: auto;

  > span {
    position: relative;
    display: grid;
    width: 28px;
    height: 28px;
    flex: 0 0 auto;
    border: 1px solid var(--color-rank-gold);
    border-radius: 50%;
    place-items: center;
  }

  > span:nth-of-type(2) {
    border-color: var(--color-pk-team-blue);
  }

  > span:nth-of-type(3) {
    border-color: var(--color-rank-bronze);
  }
}

.legacy-pk__rank > span :deep(.avatar .app-image),
.legacy-pk__opponent > span :deep(.avatar .app-image),
.legacy-pk__opponent-fallback :deep(.avatar .app-image) {
  border: 0;
  background: transparent;
}

.legacy-pk__volume::before {
  position: absolute;
  inset: -6px;
  content: '';
}

.legacy-pk__rank--left {
  flex-direction: row-reverse;
}

.legacy-pk__rank--right {
  justify-content: flex-end;
  background: linear-gradient(
    90deg,
    transparent,
    color-mix(in srgb, var(--color-pk-team-blue) 20%, transparent)
  );
}

.legacy-pk__rank-arrow {
  flex: 0 0 auto;
  opacity: 0.3;
}

.legacy-pk__rank--left .legacy-pk__rank-arrow {
  transform: rotate(180deg);
}

.legacy-pk__rank-empty {
  width: 26px;
  height: 26px;
  object-fit: contain;
}

.legacy-pk__rank-medal {
  position: absolute;
  right: 0;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 12px;
  object-fit: contain;
}

@keyframes legacy-pk-spin {
  to {
    transform: rotate(360deg);
  }
}

@media (prefers-reduced-motion: reduce) {
  .legacy-pk__progress-left,
  .legacy-pk__progress-right {
    transition: none;
  }

  .legacy-pk__opponent-wait i {
    animation: none;
  }
}
</style>

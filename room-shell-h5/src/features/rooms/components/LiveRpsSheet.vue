<script setup lang="ts">
import { publicAsset } from '@/core/media/public-asset'
import type { RoomLaunchContext } from '@/features/rooms/contracts'
import type {
  LiveRpsConfig,
  LiveRpsMove,
  LiveRpsPlayResult,
  LiveRpsRoundResult,
} from '@/features/game/contracts'
import {
  createLiveRpsOrder,
  exitLiveRps,
  playLiveRps,
  queryLiveRpsConfig,
} from '@/features/game/game-operations'
import { liveInteractionActions } from '@/features/rooms/live-operations'
import AppImage from '@/main/components/AppImage.vue'
import AppPopup from '@/main/components/AppPopup.vue'
import { useSessionStore } from '@/main/stores/session'
import { useAppFeedback } from '@/main/ui/feedback'
import { isGiftBalanceError } from '@/shared/gifts/useGiftSendFlow'
import { computed, onBeforeUnmount, ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'

type RpsPhase = 'battle' | 'idle' | 'loading' | 'playing' | 'settled' | 'unavailable'
type DisplayResult = 'draw' | 'lose' | 'win'
interface MoveOption {
  key: 'paper' | 'rock' | 'scissors'
  move: LiveRpsMove
}

const props = defineProps<{
  context: RoomLaunchContext
  initialConfig?: LiveRpsConfig | null
  modelValue: boolean
  suspended?: boolean
}>()
const emit = defineEmits<{
  recharge: [requiredDiamonds: number]
  'update:modelValue': [value: boolean]
}>()

const { t } = useI18n()
const feedback = useAppFeedback()
const session = useSessionStore()
const config = ref<LiveRpsConfig | null>(null)
const phase = ref<RpsPhase>('loading')
const rulesVisible = ref(false)
const pending = ref(false)
const selectedMove = ref<LiveRpsMove>('ROCK')
const orderId = ref('')
const roundNumber = ref(1)
const roundResults = ref<Exclude<DisplayResult, 'draw'>[]>([])
const battleResult = ref<LiveRpsPlayResult | null>(null)
const battleRevealed = ref(false)
const cyclingMoveIndex = ref(0)
const finalWon = ref(false)
let initialConfigConsumed = false
const secondsLeft = ref(10)
const secondsToDayEnd = ref(0)
let configController: AbortController | undefined
let playController: AbortController | undefined
let countdownTimer = 0
let dayTimer = 0
let battleTimer = 0
let revealTimer = 0
let lifecycle = 0
let active = true

const moves: readonly MoveOption[] = [
  { key: 'rock', move: 'ROCK' },
  { key: 'paper', move: 'PAPER' },
  { key: 'scissors', move: 'SCISSORS' },
]
const visible = computed({
  get: () => props.modelValue,
  set: (value) => {
    if (!value) close()
  },
})
const userWins = computed(() => roundResults.value.filter((result) => result === 'win').length)
const anchorWins = computed(() => roundResults.value.filter((result) => result === 'lose').length)
const displayedAnchorMove = computed<LiveRpsMove>(() =>
  battleRevealed.value && battleResult.value
    ? battleResult.value.anchorMove
    : (moves[cyclingMoveIndex.value]?.move ?? 'ROCK'),
)
const displayedUserMove = computed(() => battleResult.value?.userMove ?? selectedMove.value)
const displayedRoundResult = computed<DisplayResult | null>(() => {
  if (!battleRevealed.value || !battleResult.value) return null
  return mapRoundResult(battleResult.value.playResult)
})
const countdownLabel = computed(() =>
  t('room.rpsCountdown', { seconds: String(secondsLeft.value).padStart(2, '0') }),
)
const dayCountdown = computed(() => {
  const seconds = Math.max(0, secondsToDayEnd.value)
  const hours = Math.floor(seconds / 3_600)
  const minutes = Math.floor((seconds % 3_600) / 60)
  const remaining = seconds % 60
  return [hours, minutes, remaining].map((value) => String(value).padStart(2, '0')).join(':')
})

function asset(name: string): string {
  return publicAsset(`live-room/rps/${name}.webp`)
}

function moveKey(move: LiveRpsMove): MoveOption['key'] {
  return moves.find((item) => item.move === move)?.key ?? 'rock'
}

function mapRoundResult(result: LiveRpsRoundResult): DisplayResult {
  if (result === 'USER_WIN') return 'win'
  if (result === 'ANCHOR_WIN') return 'lose'
  return 'draw'
}

function clearTimers(): void {
  window.clearInterval(countdownTimer)
  window.clearInterval(dayTimer)
  window.clearInterval(battleTimer)
  window.clearTimeout(revealTimer)
  countdownTimer = 0
  dayTimer = 0
  battleTimer = 0
  revealTimer = 0
}

function startDayCountdown(): void {
  window.clearInterval(dayTimer)
  dayTimer = window.setInterval(() => {
    secondsToDayEnd.value = Math.max(0, secondsToDayEnd.value - 1)
  }, 1_000)
}

function startRoundCountdown(): void {
  window.clearInterval(countdownTimer)
  secondsLeft.value = 10
  const startedAt = performance.now()
  countdownTimer = window.setInterval(() => {
    secondsLeft.value = Math.max(0, 10 - Math.floor((performance.now() - startedAt) / 1_000))
    if (secondsLeft.value <= 0) {
      window.clearInterval(countdownTimer)
      countdownTimer = 0
      void playRound()
    }
  }, 250)
}

function resetGame(nextPhase: RpsPhase = 'idle'): void {
  window.clearInterval(countdownTimer)
  window.clearInterval(battleTimer)
  window.clearTimeout(revealTimer)
  countdownTimer = 0
  battleTimer = 0
  revealTimer = 0
  phase.value = nextPhase
  pending.value = false
  rulesVisible.value = false
  selectedMove.value = 'ROCK'
  roundNumber.value = 1
  roundResults.value = []
  battleResult.value = null
  battleRevealed.value = false
  cyclingMoveIndex.value = 0
  finalWon.value = false
  secondsLeft.value = 10
}

async function refreshBalance(): Promise<void> {
  const balance = await liveInteractionActions.refreshBalance().catch(() => null)
  if (balance !== null && active) await session.updateBalance(balance)
}

async function loadConfig(force = false): Promise<void> {
  configController?.abort()
  const controller = new AbortController()
  configController = controller
  const sequence = ++lifecycle
  phase.value = 'loading'
  if (!force && !initialConfigConsumed && props.initialConfig) {
    initialConfigConsumed = true
    config.value = props.initialConfig
    secondsToDayEnd.value = props.initialConfig.secondsToDayEnd
    phase.value = 'idle'
    startDayCountdown()
    return
  }
  initialConfigConsumed = true
  try {
    const next = await queryLiveRpsConfig(controller.signal)
    if (controller.signal.aborted || sequence !== lifecycle || !props.modelValue) return
    config.value = next
    if (!next) {
      phase.value = 'unavailable'
      return
    }
    secondsToDayEnd.value = next.secondsToDayEnd
    phase.value = 'idle'
    startDayCountdown()
  } catch {
    if (!controller.signal.aborted && sequence === lifecycle && props.modelValue)
      phase.value = 'unavailable'
  }
}

async function createOrder(): Promise<void> {
  const game = config.value
  const anchorId = props.context.hostId?.trim() ?? ''
  if (!game || !anchorId || !props.context.roomId || pending.value) return
  if (session.balance < game.price) {
    emit('recharge', game.price)
    return
  }
  pending.value = true
  const closeLoading = feedback.loading()
  try {
    const order = await createLiveRpsOrder({
      anchorId,
      roomId: props.context.roomId,
    })
    if (!props.modelValue || !active) {
      void exitLiveRps(order.orderId).catch(() => false)
      return
    }
    orderId.value = order.orderId
    config.value = { ...game, todayPlayCount: game.todayPlayCount + 1 }
    phase.value = 'playing'
    await refreshBalance()
    startRoundCountdown()
  } catch (error) {
    if (isGiftBalanceError(error)) emit('recharge', game.price)
    else feedback.warning(t('room.rpsUnavailable'))
  } finally {
    closeLoading()
    if (active) pending.value = false
  }
}

function selectMove(move: LiveRpsMove): void {
  if (phase.value === 'playing' && !pending.value) selectedMove.value = move
}

async function revealRound(sequence: number, result: LiveRpsPlayResult): Promise<void> {
  battleResult.value = result
  await new Promise<void>((resolve) => {
    revealTimer = window.setTimeout(resolve, 1_250)
  })
  if (!active || sequence !== lifecycle || !props.modelValue) return
  window.clearInterval(battleTimer)
  battleTimer = 0
  battleRevealed.value = true
  const mapped = mapRoundResult(result.playResult)
  if (mapped !== 'draw') roundResults.value.push(mapped)
  await new Promise<void>((resolve) => {
    revealTimer = window.setTimeout(resolve, 1_650)
  })
  if (!active || sequence !== lifecycle || !props.modelValue) return

  if (result.orderFinished) {
    finalWon.value = result.finalResult === 'USER_WIN' || result.finalResult === 'FINISHED_USER_WIN'
    orderId.value = ''
    phase.value = 'settled'
    await refreshBalance()
    return
  }
  if (mapped !== 'draw') roundNumber.value += 1
  battleResult.value = null
  battleRevealed.value = false
  phase.value = 'playing'
  startRoundCountdown()
}

async function playRound(): Promise<void> {
  if (phase.value !== 'playing' || pending.value || !orderId.value) return
  pending.value = true
  window.clearInterval(countdownTimer)
  countdownTimer = 0
  phase.value = 'battle'
  battleResult.value = null
  battleRevealed.value = false
  cyclingMoveIndex.value = 0
  battleTimer = window.setInterval(() => {
    cyclingMoveIndex.value = (cyclingMoveIndex.value + 1) % moves.length
  }, 180)
  const sequence = lifecycle
  const activeOrderId = orderId.value
  playController?.abort()
  const controller = new AbortController()
  playController = controller
  try {
    const result = await playLiveRps(
      {
        move: selectedMove.value,
        orderId: activeOrderId,
        smallRoundNo: roundNumber.value,
      },
      controller.signal,
    )
    if (!active || sequence !== lifecycle || activeOrderId !== orderId.value) return
    pending.value = false
    await revealRound(sequence, result)
  } catch {
    if (!active || sequence !== lifecycle) return
    window.clearInterval(battleTimer)
    battleTimer = 0
    pending.value = false
    phase.value = 'playing'
    feedback.warning(t('room.rpsNetworkRetry'))
    startRoundCountdown()
  }
}

async function exitActiveOrder(): Promise<void> {
  const id = orderId.value
  orderId.value = ''
  if (!id) return
  const exited = await exitLiveRps(id).catch(() => false)
  await refreshBalance()
  if (exited && active) feedback.warning(t('room.rpsRefunded'))
}

function close(): void {
  if (pending.value && phase.value === 'battle') return
  lifecycle += 1
  clearTimers()
  emit('update:modelValue', false)
}

function challengeAgain(): void {
  resetGame('idle')
  void createOrder()
}

watch(
  () => props.modelValue,
  (open) => {
    if (open) {
      resetGame('loading')
      void loadConfig()
      return
    }
    lifecycle += 1
    configController?.abort()
    playController?.abort()
    clearTimers()
    void exitActiveOrder()
  },
  { immediate: true },
)

onBeforeUnmount(() => {
  active = false
  lifecycle += 1
  configController?.abort()
  playController?.abort()
  clearTimers()
  void exitActiveOrder()
})
</script>

<template>
  <AppPopup
    v-model="visible"
    class="live-rps-sheet"
    :closeable="false"
    :close-on-click-overlay="false"
    flush
    panel-height="min(535px, 88dvh)"
    panel-max-height="min(535px, 88dvh)"
    :surface-radius="20"
    surface="transparent"
    :suspended="suspended"
  >
    <section class="live-rps-sheet__panel" :class="`is-${phase}`">
      <AppImage alt="" aria-hidden="true" class="live-rps-sheet__background" :src="asset('bg')" />

      <template v-if="phase === 'loading'">
        <div class="live-rps-sheet__loading" role="status">
          <i />
          <i />
          <i />
        </div>
      </template>

      <template v-else-if="phase === 'unavailable'">
        <header class="live-rps-sheet__header">
          <AppImage alt="" :src="asset('title')" />
          <h2>{{ t('room.rpsTitle') }}</h2>
          <button type="button" :aria-label="t('common.close')" @click="close">
            <AppImage alt="" :src="asset('close')" />
          </button>
        </header>
        <div class="live-rps-sheet__unavailable">
          <AppImage alt="" :src="asset('hero')" />
          <p>{{ t('room.rpsUnavailable') }}</p>
          <button type="button" @click="loadConfig(true)">{{ t('room.chatRetry') }}</button>
        </div>
      </template>

      <template v-else>
        <header v-if="phase !== 'settled'" class="live-rps-sheet__header">
          <AppImage alt="" :src="asset('title')" />
          <h2>{{ t('room.rpsTitle') }}</h2>
          <button
            class="live-rps-sheet__rules-button"
            type="button"
            :aria-label="t('room.rpsRules')"
            @click="rulesVisible = !rulesVisible"
          >
            ?
          </button>
          <button type="button" :aria-label="t('common.close')" @click="close">
            <AppImage alt="" :src="asset('close')" />
          </button>
        </header>

        <template v-if="phase === 'idle'">
          <div class="live-rps-sheet__idle">
            <AppImage alt="" :src="asset('hero')" />
            <button type="button" :disabled="pending" @click="createOrder">
              {{ t('room.rpsChallenge') }} ·
              <AppImage alt="" :src="publicAsset('common/diamond.png')" />
              {{ config?.price.toLocaleString('en') }}
            </button>
            <p>
              {{ t('room.rpsPlayedToday', { count: config?.todayPlayCount ?? 0 }) }}
              <span>{{ dayCountdown }}</span>
            </p>
          </div>
        </template>

        <template v-else-if="phase === 'playing'">
          <div class="live-rps-sheet__playing">
            <div class="live-rps-sheet__stages">
              <span v-for="index in 3" :key="index">
                <AppImage
                  v-if="roundResults[index - 1]"
                  :alt="roundResults[index - 1]"
                  :src="asset(roundResults[index - 1] ?? 'win')"
                />
                <i v-else>
                  <b>{{ index }}</b>
                  {{ t('room.rpsStage') }}
                </i>
              </span>
            </div>
            <p class="live-rps-sheet__countdown">{{ countdownLabel }}</p>
            <div class="live-rps-sheet__moves">
              <button
                v-for="move in moves"
                :key="move.move"
                :class="{ selected: selectedMove === move.move }"
                type="button"
                @click="selectMove(move.move)"
              >
                <AppImage
                  class="live-rps-sheet__choice"
                  alt=""
                  :src="asset(selectedMove === move.move ? 'choice-selected' : 'choice')"
                />
                <AppImage class="live-rps-sheet__hand" alt="" :src="asset(move.key)" />
                <AppImage
                  class="live-rps-sheet__move-name"
                  alt=""
                  :src="asset(`${move.key}-text`)"
                />
              </button>
            </div>
            <button class="live-rps-sheet__primary" type="button" @click="playRound">
              {{ t('room.rpsStart') }}
            </button>
          </div>
        </template>

        <template v-else-if="phase === 'battle'">
          <div class="live-rps-sheet__battle">
            <AppImage
              v-if="displayedRoundResult"
              class="live-rps-sheet__round-result"
              alt=""
              :src="
                asset(
                  displayedRoundResult === 'win'
                    ? 'you-win'
                    : displayedRoundResult === 'lose'
                      ? 'you-lose'
                      : 'draw',
                )
              "
            />
            <AppImage class="live-rps-sheet__side-label" alt="" :src="asset('host')" />
            <AppImage
              class="live-rps-sheet__battle-hand"
              :class="{ revealed: battleRevealed }"
              alt=""
              :src="asset(moveKey(displayedAnchorMove))"
            />
            <AppImage class="live-rps-sheet__versus" alt="" :src="asset('vs')" />
            <AppImage
              class="live-rps-sheet__battle-hand"
              :class="{ revealed: battleRevealed }"
              alt=""
              :src="asset(moveKey(displayedUserMove))"
            />
            <AppImage class="live-rps-sheet__side-label" alt="" :src="asset('you')" />
            <p v-if="!battleRevealed">{{ t('room.rpsBattling') }}</p>
          </div>
        </template>

        <template v-else-if="phase === 'settled'">
          <div class="live-rps-sheet__settled">
            <AppImage class="live-rps-sheet__settled-hero" alt="" :src="asset('hero')" />
            <article>
              <h2>{{ finalWon ? t('room.rpsChampion') : t('room.rpsBetterLuck') }}</h2>
              <AppImage alt="" :src="asset(finalWon ? 'final-win' : 'final-lose')" />
              <div v-if="finalWon" class="live-rps-sheet__reward">
                <AppImage alt="" :src="asset('champion')" />
                <p>
                  <strong>{{ t('room.rpsMedal') }}</strong>
                  <small>{{
                    t('room.rpsMedalValidity', { hours: config?.grantedHours ?? 0 })
                  }}</small>
                </p>
              </div>
              <p class="live-rps-sheet__score">{{ userWins }} : {{ anchorWins }}</p>
              <button type="button" @click="challengeAgain">
                {{ t('room.rpsChallengeAgain') }}
              </button>
            </article>
            <button
              class="live-rps-sheet__settled-close"
              type="button"
              :aria-label="t('common.close')"
              @click="close"
            >
              <AppImage alt="" :src="asset('close')" />
            </button>
          </div>
        </template>

        <Transition name="rps-rules">
          <button
            v-if="rulesVisible && phase !== 'settled'"
            class="live-rps-sheet__rules"
            type="button"
            :style="{ backgroundImage: `url(${asset('rules')})` }"
            @click="rulesVisible = false"
          >
            {{
              t('room.rpsRulesText', {
                hours: config?.grantedHours ?? 0,
                price: config?.price ?? 0,
              })
            }}
          </button>
        </Transition>
      </template>
    </section>
  </AppPopup>
</template>

<style scoped lang="less">
.live-rps-sheet :deep(.app-popup) {
  overflow: hidden;
  padding: 0;
  background: var(--gradient-live-rps-header);
}

.live-rps-sheet :deep(.app-popup__body) {
  min-height: 0;
}

.live-rps-sheet__panel {
  position: relative;
  min-height: 100%;
  box-sizing: border-box;
  overflow: hidden;
  padding-bottom: var(--app-popup-content-bottom-inset);
  color: var(--color-on-dark);
}

.live-rps-sheet__background {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: fill;
  pointer-events: none;
}

.live-rps-sheet__header {
  position: relative;
  z-index: 2;
  display: flex;
  height: 58px;
  box-sizing: border-box;
  align-items: center;
  gap: 9px;
  padding: 12px 15px 8px;
}

.live-rps-sheet__header > .app-image {
  width: 30px;
  height: 30px;
  object-fit: contain;
}

.live-rps-sheet__header h2 {
  min-width: 0;
  margin: 0 auto 0 0;
  font-size: 18px;
  line-height: 24px;
}

.live-rps-sheet__header > button {
  display: grid;
  width: 34px;
  height: 34px;
  padding: 0;
  border: 0;
  background: transparent;
  color: var(--color-on-dark);
  place-items: center;
}

.live-rps-sheet__header > button .app-image {
  width: 24px;
  height: 24px;
}

.live-rps-sheet__rules-button {
  border: 2px solid var(--color-on-dark) !important;
  border-radius: 50%;
  font-size: 16px;
  font-weight: 800;
}

.live-rps-sheet__idle,
.live-rps-sheet__playing,
.live-rps-sheet__battle,
.live-rps-sheet__settled,
.live-rps-sheet__unavailable {
  position: relative;
  z-index: 1;
}

.live-rps-sheet__idle {
  display: flex;
  align-items: center;
  flex-direction: column;
}

.live-rps-sheet__idle > .app-image {
  width: min(284px, 76vw);
  height: 267px;
  object-fit: contain;
}

.live-rps-sheet__idle > button,
.live-rps-sheet__primary,
.live-rps-sheet__unavailable button,
.live-rps-sheet__settled article > button {
  display: flex;
  width: calc(100% - 30px);
  min-height: 48px;
  align-items: center;
  justify-content: center;
  gap: 5px;
  padding: 0 18px;
  border: 0;
  border-radius: 24px;
  background: var(--gradient-live-rps-action);
  color: var(--color-on-dark);
  font-size: 15px;
  font-weight: 800;
}

.live-rps-sheet__idle > button .app-image {
  width: 16px;
  height: 16px;
}

.live-rps-sheet__idle > button:disabled {
  opacity: 0.55;
}

.live-rps-sheet__idle > p {
  display: flex;
  align-items: center;
  gap: 8px;
  margin: 7px 0 0;
  color: var(--color-on-dark-secondary);
  font-size: 12px;
}

.live-rps-sheet__idle > p span {
  padding: 4px 10px;
  border-radius: 14px;
  background: var(--color-live-rps-control);
  color: var(--color-on-dark);
}

.live-rps-sheet__playing {
  display: flex;
  align-items: center;
  flex-direction: column;
  padding: 8px 15px 16px;
}

.live-rps-sheet__stages {
  display: flex;
  height: 66px;
  align-items: flex-end;
  gap: 30px;
}

.live-rps-sheet__stages > span {
  display: grid;
  width: 50px;
  height: 62px;
  place-items: center;
}

.live-rps-sheet__stages .app-image {
  width: 50px;
  height: 62px;
  object-fit: contain;
}

.live-rps-sheet__stages i {
  display: grid;
  width: 50px;
  height: 50px;
  border: 1px solid var(--color-live-rps-control-border);
  border-radius: 50%;
  background: var(--gradient-live-rps-control);
  color: var(--color-on-dark-disabled);
  font-size: 10px;
  font-style: normal;
  place-content: center;
  text-align: center;
}

.live-rps-sheet__stages i b {
  font-size: 21px;
  line-height: 22px;
}

.live-rps-sheet__countdown {
  min-width: 100px;
  margin: 10px 0 47px;
  padding: 4px 12px;
  border-radius: 14px;
  background: var(--color-on-dark-fill);
  font-size: 14px;
  font-weight: 700;
  text-align: center;
}

.live-rps-sheet__moves {
  display: grid;
  width: 100%;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 10px;
}

.live-rps-sheet__moves button {
  position: relative;
  height: 84px;
  padding: 0;
  border: 0;
  background: transparent;
}

.live-rps-sheet__choice {
  width: 100%;
  height: 84px;
  object-fit: fill;
}

.live-rps-sheet__hand {
  position: absolute;
  top: -38px;
  left: 50%;
  width: 88px;
  height: 88px;
  object-fit: contain;
  transform: translateX(-50%);
}

.live-rps-sheet__move-name {
  position: absolute;
  bottom: 6px;
  left: 50%;
  width: 87px;
  height: 26px;
  object-fit: contain;
  transform: translateX(-50%);
}

.live-rps-sheet__primary {
  margin-top: 18px;
}

.live-rps-sheet__battle {
  display: flex;
  min-height: 440px;
  align-items: center;
  flex-direction: column;
  justify-content: center;
  padding: 16px 20px 24px;
  background: var(--color-scrim-soft);
}

.live-rps-sheet__round-result {
  width: min(260px, 74vw);
  height: 62px;
  margin-bottom: 8px;
  object-fit: contain;
}

.live-rps-sheet__side-label {
  width: auto;
  height: 34px;
  object-fit: contain;
}

.live-rps-sheet__battle-hand {
  width: 88px;
  height: 88px;
  margin: 8px 0;
  object-fit: contain;
}

.live-rps-sheet__battle-hand.revealed {
  filter: drop-shadow(0 0 10px rgb(255 0 222 / 60%));
}

.live-rps-sheet__versus {
  width: auto;
  height: 36px;
  object-fit: contain;
}

.live-rps-sheet__battle p {
  margin: 9px 0 0;
  color: var(--color-on-dark-secondary);
  font-weight: 700;
}

.live-rps-sheet__settled {
  display: grid;
  min-height: 500px;
  padding: 88px 30px 54px;
  place-items: center;
}

.live-rps-sheet__settled-hero {
  position: absolute;
  top: 8px;
  left: 50%;
  z-index: 2;
  width: 167px;
  height: 157px;
  object-fit: contain;
  transform: translateX(-50%);
}

.live-rps-sheet__settled article {
  display: flex;
  width: min(315px, calc(100vw - 40px));
  min-height: 360px;
  box-sizing: border-box;
  align-items: center;
  flex-direction: column;
  padding: 78px 20px 24px;
  border-radius: 16px;
  background: var(--gradient-live-rps-summary);
}

.live-rps-sheet__settled h2 {
  margin: 0;
  font-size: 18px;
  text-align: center;
}

.live-rps-sheet__settled article > .app-image {
  width: 100px;
  height: 100px;
  margin-top: 10px;
  object-fit: contain;
}

.live-rps-sheet__reward {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 8px;
  padding: 8px;
  border-radius: 12px;
  background: var(--color-on-dark-border);
}

.live-rps-sheet__reward > .app-image {
  width: 80px;
  height: 23px;
  object-fit: contain;
}

.live-rps-sheet__reward p {
  display: grid;
  gap: 2px;
  margin: 0;
}

.live-rps-sheet__reward small {
  color: var(--color-on-dark-subtle);
}

.live-rps-sheet__score {
  margin: auto 0 8px;
  color: var(--color-on-dark-secondary);
}

.live-rps-sheet__settled article > button {
  width: 100%;
}

.live-rps-sheet__settled-close {
  position: absolute;
  bottom: 10px;
  left: 50%;
  display: grid;
  width: 40px;
  height: 40px;
  padding: 0;
  border: 0;
  background: transparent;
  transform: translateX(-50%);
  place-items: center;
}

.live-rps-sheet__settled-close .app-image {
  width: 32px;
  height: 32px;
}

.live-rps-sheet__rules {
  position: absolute;
  z-index: 5;
  top: 52px;
  left: 80px;
  width: 284px;
  min-height: 140px;
  padding: 14px;
  border: 0;
  background: center / 100% 100% no-repeat;
  color: var(--color-on-dark);
  font-size: 12px;
  font-weight: 600;
  line-height: 1.45;
  text-align: left;
}

.live-rps-sheet__unavailable {
  display: flex;
  min-height: 430px;
  align-items: center;
  flex-direction: column;
  justify-content: center;
  gap: 15px;
  padding: 20px 15px;
}

.live-rps-sheet__unavailable .app-image {
  width: 190px;
  height: 180px;
  object-fit: contain;
}

.live-rps-sheet__unavailable p {
  color: var(--color-on-dark-secondary);
}

.live-rps-sheet__loading {
  position: relative;
  z-index: 1;
  display: grid;
  min-height: 460px;
  align-content: center;
  gap: 14px;
  padding: 30px;
}

.live-rps-sheet__loading i {
  height: 70px;
  border-radius: 18px;
  background: linear-gradient(
    100deg,
    var(--color-on-dark-divider) 20%,
    var(--color-on-dark-border) 38%,
    var(--color-on-dark-divider) 56%
  );
  background-size: 200% 100%;
  animation: rps-loading 1.2s linear infinite;
}

.rps-rules-enter-active,
.rps-rules-leave-active {
  transition:
    opacity 220ms ease,
    transform 220ms cubic-bezier(0.2, 0, 0, 1);
}

.rps-rules-enter-from,
.rps-rules-leave-to {
  opacity: 0;
  transform: translateY(-8px);
}

@keyframes rps-loading {
  to {
    background-position-x: -200%;
  }
}

@media (height <= 660px) {
  .live-rps-sheet__panel {
    overflow-y: auto;
  }

  .live-rps-sheet__idle > .app-image {
    height: 225px;
  }

  .live-rps-sheet__settled {
    min-height: 470px;
  }
}

@media (prefers-reduced-motion: reduce) {
  .live-rps-sheet__loading i {
    animation: none;
  }

  .rps-rules-enter-active,
  .rps-rules-leave-active {
    transition: none;
  }
}
</style>

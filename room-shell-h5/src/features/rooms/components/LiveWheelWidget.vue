<script setup lang="ts">
import { publicAsset } from '@/core/media/public-asset'
import type { RoomLaunchContext } from '@/features/rooms/contracts'
import type { LiveWheelConfig } from '@/features/game/contracts'
import { rotateLiveWheel } from '@/features/game/game-operations'
import AppPopup from '@/main/components/AppPopup.vue'
import { useSessionStore } from '@/main/stores/session'
import { useAppFeedback } from '@/main/ui/feedback'
import { isGiftBalanceError } from '@/shared/gifts/useGiftSendFlow'
import { computed, nextTick, onBeforeUnmount, ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'

const props = defineProps<{
  config: LiveWheelConfig
  context: RoomLaunchContext
  suspended?: boolean
}>()
const emit = defineEmits<{
  interactionLock: [locked: boolean]
  recharge: [requiredDiamonds: number]
  result: [
    payload: {
      anchorId: string
      dia: number
      incomeDiamondNum: number
      number: number
      text: string
    },
  ]
}>()

const { t } = useI18n()
const feedback = useAppFeedback()
const session = useSessionStore()
const confirmVisible = ref(false)
const wheel = ref<HTMLElement | null>(null)
const pending = ref(false)
const spinning = ref(false)
const idleDelay = ref('0s')
let active = true
let settleTimer = 0
let resumeTimer = 0
let rotation = 0

const sectorAngle = computed(() => 360 / props.config.sectors.length)

watch(
  () => confirmVisible.value || pending.value || spinning.value,
  (locked) => emit('interactionLock', locked),
  { immediate: true },
)

function asset(name: string): string {
  const extension = name === 'icon' || name === 'spin' ? 'webp' : 'png'
  return publicAsset(`live-room/wheel/${name}.${extension}`)
}

function currentAngle(): number {
  const element = wheel.value
  if (!element) return rotation % 360
  const transform = getComputedStyle(element).transform
  if (!transform || transform === 'none') return rotation % 360
  const matrix = new DOMMatrixReadOnly(transform)
  return ((Math.atan2(matrix.b, matrix.a) * 180) / Math.PI + 360) % 360
}

function openConfirmation(): void {
  if (!pending.value && !spinning.value) confirmVisible.value = true
}

function closeConfirmation(): void {
  if (!pending.value) confirmVisible.value = false
}

defineExpose({ close: closeConfirmation, open: openConfirmation })

function resumeIdleSpin(angle: number): void {
  const element = wheel.value
  const normalized = ((angle % 360) + 360) % 360
  rotation = normalized
  if (element) {
    element.style.transition = 'none'
    element.style.transform = `rotate(${normalized}deg)`
  }
  resumeTimer = window.setTimeout(() => {
    if (!active) return
    if (element) {
      element.style.transition = ''
      element.style.transform = ''
      element.style.animation = ''
    }
    idleDelay.value = `${-normalized / 6}s`
    spinning.value = false
  }, 1_800)
}

async function spin(): Promise<void> {
  if (pending.value || spinning.value) return
  if (props.config.price <= 0 || props.config.sectors.length < 2) {
    feedback.warning(t('room.liveWheelUnavailable'))
    return
  }
  if (session.balance < props.config.price) {
    emit('recharge', props.config.price)
    return
  }
  pending.value = true
  confirmVisible.value = false
  const element = wheel.value
  const startAngle = currentAngle()
  spinning.value = true
  await nextTick()
  if (element) {
    element.style.animation = 'none'
    element.style.transition = 'none'
    element.style.transform = `rotate(${startAngle}deg)`
    void element.offsetHeight
  }

  try {
    const result = await rotateLiveWheel(props.context.hostId ?? props.config.anchorId)
    const index = props.config.sectors.findIndex((sector) => sector.id === result.sector.id)
    const expectedAnchorId = props.context.hostId?.trim() || props.config.anchorId
    const validWheelIds = new Set([
      props.config.id,
      ...props.config.sectors.map((sector) => sector.wheelId).filter(Boolean),
    ])
    if (
      index < 0 ||
      (result.anchorId && result.anchorId !== expectedAnchorId) ||
      (result.sector.wheelId && !validWheelIds.has(result.sector.wheelId))
    )
      throw new Error('The live wheel result is not in the current configuration.')
    await session.updateBalance(result.balance)
    const targetWithinTurn = index * sectorAngle.value + sectorAngle.value / 2
    const currentWithinTurn = ((startAngle % 360) + 360) % 360
    const forwardOffset = (targetWithinTurn - currentWithinTurn + 360) % 360
    const targetAngle = startAngle + 5 * 360 + forwardOffset
    rotation = targetAngle
    if (element) {
      element.style.transition = 'transform 3s cubic-bezier(0.7, 0.005, 0.205, 1)'
      element.style.transform = `rotate(${targetAngle}deg)`
    }
    settleTimer = window.setTimeout(() => {
      if (!active) return
      emit('result', {
        anchorId: result.anchorId || expectedAnchorId,
        dia: props.config.price,
        incomeDiamondNum: result.incomeDiamondNum,
        number: props.config.sectors.length,
        text: result.sector.text,
      })
      resumeIdleSpin(targetAngle)
    }, 3_050)
  } catch (error) {
    if (isGiftBalanceError(error)) {
      spinning.value = false
      if (element) {
        element.style.animation = ''
        element.style.transition = ''
        element.style.transform = ''
      }
      emit('recharge', props.config.price)
    } else {
      spinning.value = false
      if (element) {
        element.style.animation = ''
        element.style.transition = ''
        element.style.transform = ''
      }
      feedback.warning(t('room.liveWheelUnavailable'))
    }
  } finally {
    if (active) pending.value = false
  }
}

onBeforeUnmount(() => {
  emit('interactionLock', false)
  active = false
  window.clearTimeout(settleTimer)
  window.clearTimeout(resumeTimer)
})
</script>

<template>
  <section
    class="live-wheel-widget"
    :class="{ 'is-pending': pending }"
    :aria-label="t('room.liveWheelTitle')"
  >
    <img
      class="live-wheel-widget__frame"
      alt=""
      aria-hidden="true"
      draggable="false"
      :src="asset('bg-wheel')"
    />
    <div
      ref="wheel"
      class="live-wheel-widget__wheel"
      :class="{ 'is-idle': !spinning }"
      :style="{ '--wheel-idle-delay': idleDelay }"
    >
      <span
        v-for="(sector, index) in config.sectors"
        :key="`line-${sector.id}`"
        class="live-wheel-widget__separator"
        :style="{ transform: `rotate(${-index * sectorAngle}deg)` }"
      />
      <span
        v-for="(sector, index) in config.sectors"
        :key="sector.id"
        class="live-wheel-widget__sector"
        :style="{ transform: `rotate(${-index * sectorAngle - sectorAngle / 2}deg)` }"
      >
        <b>{{ sector.text }}</b>
      </span>
    </div>
    <button type="button" :disabled="pending || spinning" @click.stop="openConfirmation">
      <img alt="" aria-hidden="true" draggable="false" :src="asset('start')" />
    </button>
    <img
      class="live-wheel-widget__pointer"
      alt=""
      aria-hidden="true"
      draggable="false"
      :src="asset('pointer')"
    />
  </section>

  <AppPopup
    v-model="confirmVisible"
    class="live-wheel-confirm"
    bottom-inset-owner="content"
    :closeable="false"
    :expand-for-bottom-inset="false"
    flush
    overlay-class="live-wheel-confirm-overlay"
    panel-height="120px"
    panel-max-height="120px"
    :surface-radius="16"
    surface="transparent"
    :suspended="suspended"
    @closed="closeConfirmation"
  >
    <section class="live-wheel-confirm__content">
      <img alt="" aria-hidden="true" draggable="false" :src="asset('icon')" />
      <div>
        <h2>{{ t('room.liveWheelTitle') }}</h2>
        <p>
          <img
            alt=""
            aria-hidden="true"
            draggable="false"
            :src="publicAsset('common/diamond.png')"
          />
          <strong>{{ config.price.toLocaleString('en') }}</strong>
          <span>/ {{ t('room.liveWheelOnce') }}</span>
        </p>
      </div>
      <button type="button" :aria-label="t('room.liveWheelSpin')" :disabled="pending" @click="spin">
        <img alt="" aria-hidden="true" draggable="false" :src="asset('spin')" />
      </button>
    </section>
  </AppPopup>
</template>

<style scoped lang="less">
.live-wheel-widget {
  position: absolute;
  z-index: 12;
  top: calc(var(--safe-top) + 60px);
  right: -64px;
  display: grid;
  width: 190px;
  height: 190px;
  place-items: center;
  direction: ltr;
  transition: opacity 160ms ease;
}

.live-wheel-widget.is-pending {
  opacity: 0.88;
}

.live-wheel-widget__frame {
  position: absolute;
  inset: 0;
  width: 190px;
  height: 190px;
  margin: auto;
  object-fit: contain;
  pointer-events: none;
  user-select: none;
}

.live-wheel-widget__wheel {
  position: relative;
  width: 154px;
  height: 154px;
  overflow: hidden;
  border-radius: 50%;
  backface-visibility: hidden;
  background: var(--gradient-live-wheel-result);
  will-change: transform;
}

.live-wheel-widget__wheel.is-idle {
  animation: live-wheel-idle-spin 60s linear infinite;
  animation-delay: var(--wheel-idle-delay);
}

.live-wheel-widget__separator {
  position: absolute;
  top: calc(50% - 1px);
  left: 0;
  width: 77px;
  height: 2px;
  transform-origin: 100% 50%;
  background: var(--color-live-wheel-danger);
}

.live-wheel-widget__sector {
  position: absolute;
  top: 50%;
  right: 50%;
  left: 0;
  z-index: 2;
  width: auto;
  height: 77px;
  margin-top: -38.5px;
  transform-origin: 100% 50%;
}

.live-wheel-widget__sector b {
  display: flex;
  width: 100%;
  height: 100%;
  box-sizing: border-box;
  align-items: center;
  justify-content: center;
  padding: 0 21px 0 6px;
  overflow: hidden;
  color: var(--color-live-wheel-danger-text);
  font-size: 9px;
  font-weight: 700;
  line-height: 10px;
  text-align: center;
  overflow-wrap: anywhere;
}

.live-wheel-widget > button {
  position: absolute;
  z-index: 2;
  inset: 0;
  display: grid;
  width: 42px;
  height: 42px;
  margin: auto;
  padding: 0;
  border: 0;
  border-radius: 50%;
  background: transparent;
  place-items: center;
}

.live-wheel-widget > button img {
  width: 42px;
  height: 42px;
  object-fit: contain;
  user-select: none;
}

.live-wheel-widget__pointer {
  position: absolute;
  z-index: 2;
  top: 50%;
  left: -7px;
  width: 34px;
  height: 25px;
  transform: translateY(-50%);
  pointer-events: none;
}

.live-wheel-confirm :deep(.app-popup) {
  width: 100%;
  min-width: 0;
  overflow: hidden;
  padding: 0;
  background: var(--gradient-party-sheet);
}

.live-wheel-confirm :deep(.app-popup__body) {
  min-height: 0;
}

.live-wheel-confirm__content {
  display: flex;
  width: 100%;
  height: 120px;
  min-height: 0;
  box-sizing: border-box;
  align-items: center;
  gap: 12px;
  overflow: hidden;
  padding: 0 20px var(--app-popup-content-bottom-inset);
  color: var(--color-on-dark);
}

.live-wheel-confirm__content > img {
  width: 60px;
  height: 60px;
  flex: 0 0 60px;
  object-fit: contain;
}

.live-wheel-confirm__content > div {
  min-width: 0;
  flex: 1;
}

.live-wheel-confirm__content h2 {
  margin: 0 0 8px;
  font-size: 18px;
  line-height: 22px;
}

.live-wheel-confirm__content p {
  display: flex;
  align-items: center;
  margin: 0;
  font-size: 16px;
}

.live-wheel-confirm__content p img {
  width: 16px;
  height: 16px;
}

.live-wheel-confirm__content p strong {
  margin: 0 2px 0 6px;
  color: var(--color-live-wheel-accent);
}

.live-wheel-confirm__content > button {
  display: grid;
  width: 74px;
  height: 42px;
  flex: 0 0 74px;
  padding: 0;
  border: 0;
  background: transparent;
  place-items: center;
}

.live-wheel-confirm__content > button img {
  width: 74px;
  height: 42px;
  object-fit: contain;
}

:global(.live-wheel-confirm-overlay.van-overlay) {
  background: transparent !important;
}

@keyframes live-wheel-idle-spin {
  to {
    transform: rotate(360deg);
  }
}
</style>

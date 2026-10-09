<script setup lang="ts">
import type { GameLaunchSpec } from '@/features/game/contracts'
import { parseGameHostEvent, rechargeSuccessPayload } from '@/features/game/game-messages'
import AppIcon from '@/main/components/AppIcon.vue'
import AppImage from '@/main/components/AppImage.vue'
import AppLoadLoadingIcon from '@/main/components/AppLoadLoadingIcon.vue'
import { useSessionStore } from '@/main/stores/session'
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'

const props = defineProps<{
  launch: GameLaunchSpec | null
  modelValue: boolean
  suspended?: boolean
}>()
const emit = defineEmits<{
  closed: []
  'update:modelValue': [value: boolean]
  recharge: [requiredDiamonds: number]
}>()
const session = useSessionStore()
const { t } = useI18n()
const frame = ref<HTMLIFrameElement | null>(null)
const loading = ref(false)
const failed = ref(false)
const frameRevision = ref(0)
let baselineBalance = session.balance
let loadingTimer = 0

const frameKey = computed(() => `${props.launch?.gameId ?? 'none'}:${frameRevision.value}`)

function clearLoadingTimer(): void {
  window.clearTimeout(loadingTimer)
  loadingTimer = 0
}

function armLoading(): void {
  clearLoadingTimer()
  failed.value = false
  loading.value = Boolean(props.launch?.url)
  if (!loading.value) return
  loadingTimer = window.setTimeout(() => {
    loading.value = false
    failed.value = true
  }, 15_000)
}

function finishLoading(): void {
  clearLoadingTimer()
  loading.value = false
  failed.value = false
}

function postToGame(payload: unknown): void {
  if (!props.launch?.allowedOrigin) return
  frame.value?.contentWindow?.postMessage(payload, props.launch.allowedOrigin)
}

function notifyGameClosing(): void {
  if (props.launch?.bridgeType !== 'lingxian') return
  postToGame(JSON.stringify({ method: 'appQuitGame', param: '' }))
}

function close(notifyGame = true): void {
  if (props.suspended) return
  if (notifyGame) notifyGameClosing()
  emit('update:modelValue', false)
}

function retry(): void {
  frameRevision.value += 1
  armLoading()
}

function handleMessage(event: MessageEvent): void {
  if (
    !props.modelValue ||
    !props.launch ||
    event.source !== frame.value?.contentWindow ||
    event.origin !== props.launch.allowedOrigin
  )
    return
  const message = parseGameHostEvent(event.data, props.launch.bridgeType)
  if (message.type === 'ready') finishLoading()
  else if (message.type === 'close') close(false)
  else if (message.type === 'recharge') emit('recharge', 0)
}

watch(
  () => props.modelValue,
  (visible) => {
    if (!visible) {
      clearLoadingTimer()
      return
    }
    baselineBalance = session.balance
    frameRevision.value += 1
    armLoading()
  },
)

watch(
  () => session.balance,
  (balance) => {
    if (!props.modelValue || balance <= baselineBalance) {
      baselineBalance = balance
      return
    }
    if (props.launch) postToGame(rechargeSuccessPayload(props.launch.bridgeType, balance))
    baselineBalance = balance
  },
)

onMounted(() => window.addEventListener('message', handleMessage))
onBeforeUnmount(() => {
  clearLoadingTimer()
  window.removeEventListener('message', handleMessage)
})
</script>

<template>
  <Transition name="live-half-game" @after-leave="emit('closed')">
    <section
      v-if="modelValue && launch"
      class="live-half-game"
      :class="{ 'is-suspended': suspended }"
      :inert="suspended || undefined"
      role="dialog"
      :aria-label="t('room.halfGameTitle')"
      aria-modal="true"
      @click.self="close()"
    >
      <button
        class="live-half-game__dismiss"
        type="button"
        :aria-label="t('common.close')"
        @click="close()"
      >
        <AppIcon name="close" :size="18" />
      </button>
      <div class="live-half-game__panel" @click.stop>
        <iframe
          :key="frameKey"
          ref="frame"
          allow="autoplay; clipboard-read; clipboard-write; fullscreen; gamepad"
          allowfullscreen
          :src="launch.url"
          :title="t('room.halfGameTitle')"
          @load="finishLoading"
        />

        <div v-if="loading" class="live-half-game__loading" role="status">
          <AppImage
            v-if="launch.loadingIconUrl"
            :alt="t('game.loading')"
            fit="contain"
            :lazy="false"
            :priority="true"
            :src="launch.loadingIconUrl"
          />
          <AppLoadLoadingIcon v-else animated :size="60" />
          <span>{{ t('game.loading') }}</span>
        </div>

        <div v-else-if="failed" class="live-half-game__failed" role="alert">
          <strong>{{ t('room.halfGameFailed') }}</strong>
          <div>
            <button type="button" @click="retry">{{ t('common.retry') }}</button>
            <button type="button" @click="close()">{{ t('common.close') }}</button>
          </div>
        </div>
      </div>
    </section>
  </Transition>
</template>

<style scoped lang="less">
.live-half-game {
  position: absolute;
  inset: 0;
  z-index: 80;
  background: var(--color-scrim-soft);
}

.live-half-game.is-suspended {
  pointer-events: none;
}

.live-half-game__dismiss {
  position: absolute;
  right: 14px;
  bottom: calc(min(100vw, 430px) + var(--room-bottom-inset, 0px) + 12px);
  z-index: 2;
  display: grid;
  width: 38px;
  height: 38px;
  padding: 0;
  border: 0;
  border-radius: 50%;
  background: var(--color-scrim);
  color: var(--color-on-dark);
  place-items: center;
}

.live-half-game__panel {
  position: absolute;
  right: 0;
  bottom: 0;
  left: 0;
  height: calc(min(100vw, 430px) + var(--room-bottom-inset, 0px));
  overflow: hidden;
  padding-bottom: var(--room-bottom-inset, 0);
  border-radius: 16px 16px 0 0;
  background: var(--color-media-bg);
  box-shadow: 0 -10px 34px rgb(0 0 0 / 35%);
}

.live-half-game__panel iframe {
  display: block;
  width: 100%;
  height: min(100vw, 430px);
  margin: 0;
  padding: 0;
  border: 0;
  background: var(--color-media-bg);
}

.live-half-game__loading,
.live-half-game__failed {
  position: absolute;
  inset: 0 0 var(--room-bottom-inset, 0);
  display: grid;
  align-content: center;
  justify-items: center;
  gap: 12px;
  background: color-mix(in srgb, var(--color-media-bg) 94%, transparent);
  color: var(--color-on-dark);
}

.live-half-game__loading :deep(.app-image) {
  width: 60px !important;
  height: 60px !important;
  background: transparent;
}

.live-half-game__loading span {
  color: var(--color-on-dark-muted);
  font-size: 13px;
}

.live-half-game__failed strong {
  font-size: 18px;
}

.live-half-game__failed div {
  display: flex;
  gap: 10px;
}

.live-half-game__failed button {
  min-width: 96px;
  min-height: 40px;
  border: 1px solid var(--color-on-dark-border);
  border-radius: 20px;
  background: linear-gradient(90deg, var(--color-secondary), var(--color-primary));
  color: var(--color-on-dark);
  font-weight: 800;
}

.live-half-game__failed button + button {
  background: var(--color-on-dark-fill);
}

.live-half-game-enter-active,
.live-half-game-leave-active {
  transition: opacity 180ms ease;
}

.live-half-game-enter-active .live-half-game__panel,
.live-half-game-leave-active .live-half-game__panel {
  transition: transform 240ms cubic-bezier(0.2, 0, 0, 1);
}

.live-half-game-enter-from,
.live-half-game-leave-to {
  opacity: 0;
}

.live-half-game-enter-from .live-half-game__panel,
.live-half-game-leave-to .live-half-game__panel {
  transform: translate3d(0, 100%, 0);
}
</style>

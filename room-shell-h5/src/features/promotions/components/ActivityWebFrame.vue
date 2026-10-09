<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import { getRuntimeConfig } from '@/core/config/runtime-config'
import AppLoadLoadingIcon from '@/main/components/AppLoadLoadingIcon.vue'
import { useSessionStore } from '@/main/stores/session'

type ActivityDisplayMode = 'fullscreen' | 'popup'

const props = withDefaults(
  defineProps<{
    displayMode: ActivityDisplayMode
    reportPath: string
    roomId?: string
    roomType?: string
    source: string
  }>(),
  { roomId: '', roomType: '' },
)

const emit = defineEmits<{
  close: []
  loaded: []
  navigate: [scene: string, payload: Record<string, unknown>]
  'open-gift': []
  'set-nav': [visible: boolean]
}>()

const session = useSessionStore()
const { t, locale } = useI18n()
const frame = ref<HTMLIFrameElement | null>(null)
const frameKey = ref(0)
const loading = ref(true)
const failed = ref(false)
const allowedOrigin = computed(() => {
  try {
    const url = new URL(props.source)
    return ['http:', 'https:'].includes(url.protocol) ? url.origin : ''
  } catch {
    return ''
  }
})
let loadingTimer = 0

function messageRecord(value: unknown): Record<string, unknown> | null {
  let parsed = value
  if (typeof value === 'string') {
    try {
      parsed = JSON.parse(value) as unknown
    } catch {
      return null
    }
  }
  return parsed && typeof parsed === 'object' && !Array.isArray(parsed)
    ? (parsed as Record<string, unknown>)
    : null
}

function nestedData(message: Record<string, unknown>): Record<string, unknown> {
  const value = message.data
  return value && typeof value === 'object' && !Array.isArray(value)
    ? (value as Record<string, unknown>)
    : message
}

function startLoading(): void {
  window.clearTimeout(loadingTimer)
  loading.value = Boolean(props.source && allowedOrigin.value)
  failed.value = !props.source || !allowedOrigin.value
  if (!loading.value) return
  loadingTimer = window.setTimeout(() => {
    loading.value = false
    failed.value = true
  }, 15_000)
}

function appParams(): Record<string, unknown> {
  return {
    type: 'getAppParams',
    token: session.token,
    appId: getRuntimeConfig().app.appId,
    clientType: 'user',
    platform: 'web',
    displayMode: props.displayMode,
    acceptLanguage: locale.value,
    roomId: props.roomId,
    roomType: props.roomType,
    reportParams: { path: props.reportPath },
    userAvatar: session.user?.avatar ?? '',
    userNickname: session.user?.displayName ?? '',
  }
}

function postAppParams(target = frame.value?.contentWindow): void {
  if (!target || !allowedOrigin.value || !session.token) return
  target.postMessage(appParams(), allowedOrigin.value)
}

function finishLoading(): void {
  window.clearTimeout(loadingTimer)
  loading.value = false
  failed.value = false
  postAppParams()
  emit('loaded')
}

function retry(): void {
  frameKey.value += 1
  startLoading()
}

function handleMessage(event: MessageEvent): void {
  if (
    !frame.value?.contentWindow ||
    event.source !== frame.value.contentWindow ||
    !allowedOrigin.value ||
    event.origin !== allowedOrigin.value
  )
    return
  const message = messageRecord(event.data)
  const type = typeof message?.type === 'string' ? message.type : ''
  if (!message || !type) return
  const data = nestedData(message)

  if (type === 'getAppParams') {
    if (!message.token) postAppParams(event.source as Window)
    return
  }
  if (type === 'SET_NAV') {
    emit('set-nav', data.visible !== false)
    return
  }
  if (type === 'CLOSE') {
    emit('close')
    return
  }
  if (type === 'OPEN_GIFT_PANEL') {
    emit('open-gift')
    return
  }
  if (type === 'NAVIGATE') {
    const scene =
      typeof message.scene === 'string'
        ? message.scene
        : typeof data.scene === 'string'
          ? data.scene
          : ''
    const payload = messageRecord(message.payload) ?? messageRecord(data.payload) ?? data
    if (scene) emit('navigate', scene, payload)
    return
  }
  if (['GO_LIVE', 'GO_LIVE_OF_ANCHOR', 'GO_PROFILE', 'GO_ROOM'].includes(type))
    emit('navigate', type, data)
}

watch(
  () => props.source,
  () => {
    frameKey.value += 1
    startLoading()
  },
)

onMounted(() => {
  window.addEventListener('message', handleMessage)
  startLoading()
})

onBeforeUnmount(() => {
  window.removeEventListener('message', handleMessage)
  window.clearTimeout(loadingTimer)
})
</script>

<template>
  <div class="activity-web-frame">
    <iframe
      v-if="source && allowedOrigin"
      :key="frameKey"
      ref="frame"
      allow="autoplay; clipboard-read; clipboard-write; fullscreen"
      class="activity-web-frame__iframe"
      :src="source"
      :title="t('common.webContent')"
      @load="finishLoading"
    />
    <div v-if="loading" class="activity-web-frame__state" role="status">
      <AppLoadLoadingIcon animated :size="60" />
    </div>
    <div v-else-if="failed" class="activity-web-frame__state is-error" role="alert">
      <p>{{ t('common.unableToOpenPage') }}</p>
      <button type="button" @click="retry">{{ t('common.retry') }}</button>
    </div>
  </div>
</template>

<style scoped lang="less">
.activity-web-frame {
  position: relative;
  width: 100%;
  height: 100%;
  min-height: 0;
  overflow: hidden;
  background: var(--color-activity-surface);
}

.activity-web-frame__iframe {
  display: block;
  width: 100%;
  height: 100%;
  margin: 0;
  padding: 0;
  border: 0;
}

.activity-web-frame__state {
  position: absolute;
  inset: 0;
  display: grid;
  place-content: center;
  place-items: center;
  gap: 14px;
  background: var(--color-activity-surface);
  color: var(--color-activity-text);
}

.activity-web-frame__state p {
  margin: 0;
}

.activity-web-frame__state button {
  min-width: 96px;
  min-height: 42px;
  padding: 0 18px;
  border: 0;
  border-radius: 21px;
  background: var(--color-primary);
  color: var(--color-activity-action-text);
  font: inherit;
  font-weight: 700;
}
</style>

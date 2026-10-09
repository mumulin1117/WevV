import '@/styles/base.less'
import '@/styles/vant.less'
import { VueQueryPlugin } from '@tanstack/vue-query'
import { createPinia } from 'pinia'
import { Lazyload } from 'vant'
import { createApp } from 'vue'
import { createAppQueryClient } from '@/core/api/query-client'
import { getAuthProvider, initializeAuthRuntime } from '@/core/auth/runtime'
import {
  closeNativeRoom,
  installRoomNativeReceiver,
  notifyNativeRoomReady,
  onRechargeSucceeded,
} from '@/core/bridge/room-native-bridge'
import { getRuntimeConfig } from '@/core/config/runtime-config'
import { initializeClientContext } from '@/core/device/client-context'
import { initializeMobileConsole } from '@/core/debug/mobile-console'
import { initializeRoomEntry } from '@/core/entry/room-entry'
import { i18n, initializeLocale } from '@/core/i18n'
import { initializeImageCdn } from '@/core/media/image-cdn'
import { createNavigationCoordinator, navigationKey } from '@/core/navigation/coordinator'
import {
  createObservabilityAdapter,
  installGlobalErrorCapture,
} from '@/core/observability/observability'
import { initializeObservabilityRuntime } from '@/core/observability/runtime'
import { initializeProductMode } from '@/core/product-mode/runtime'
import { initializeProductServices } from '@/core/product-mode/product-services'
import { appActivity } from '@/core/runtime/app-activity'
import { applicationRecoveryCoordinator } from '@/core/runtime/application-recovery-coordinator'
import { initializeTheme } from '@/core/theme/theme'
import { installNativeInteractionGuards } from '@/core/ui/native-interaction-guards'
import { profileQueries } from '@/features/profile/profile-operations'
import MainApp from './MainApp.vue'
import AppLoading from './components/AppLoading.vue'
import { router } from './router'
import { useSessionStore } from './stores/session'
import { disposeRoomMessageRuntime } from './startup/room-message-runtime'

function escapeHtml(value: string): string {
  const node = document.createElement('div')
  node.textContent = value
  return node.innerHTML
}

function showFatalError(cause: unknown): void {
  const details = cause instanceof Error ? cause.message : 'Unknown startup error.'
  const match = location.hash.match(/^#\/(live|voice)\/([1-9]\d*)/u)
  const roomType = match?.[1] === 'voice' ? 'voice' : 'live'
  const roomId = match?.[2] ?? ''
  document.body.innerHTML = `<main class="boot-error"><section><h1>Unable to open room</h1><p>${escapeHtml(details)}</p><button id="close-room-error" type="button">Close</button></section></main>`
  requestAnimationFrame(() => {
    requestAnimationFrame(() => {
      try {
        notifyNativeRoomReady({ roomId, roomType })
      } catch {
        // A malformed runtime config cannot provide a usable native bridge name.
      }
    })
  })
  document.querySelector('#close-room-error')?.addEventListener('click', () => {
    closeNativeRoom({ reason: 'fatal', roomId, roomType })
  })
}

async function bootstrap(): Promise<void> {
  try {
    const config = getRuntimeConfig()
    initializeTheme()
    installNativeInteractionGuards()
    const entry = initializeRoomEntry(config.app.defaultLocale, config.build.minimumHostVersion)
    initializeClientContext(entry)
    await initializeLocale(entry.locale)

    const observability = createObservabilityAdapter()
    initializeObservabilityRuntime(observability)
    installGlobalErrorCapture(observability)
    initializeAuthRuntime(observability)
    const stopAuthEvents = getAuthProvider().subscribe((event) => {
      if (event.type === 'invalidated')
        closeNativeRoom({
          reason: 'auth-invalid',
          roomId: entry.roomId,
          roomType: entry.roomType,
        })
    })
    initializeProductMode(1)
    initializeProductServices()
    initializeImageCdn()

    const app = createApp(MainApp)
    app.component('AppLoading', AppLoading)
    const pinia = createPinia()
    app.use(pinia)
    const session = useSessionStore(pinia)
    session.initializeRoomSession(entry.token, entry.userId)
    session.applyProfile(await profileQueries.getProfile())

    const queryClient = createAppQueryClient()
    const navigation = createNavigationCoordinator(router, {
      setEnabled: async () => undefined,
    })
    app.provide(navigationKey, navigation)
    app.use(router)
    app.use(i18n)
    app.use(VueQueryPlugin, { queryClient })
    app.use(Lazyload, { lazyComponent: true, observer: true })

    const disposeActivity = appActivity.install()
    const disposeRecovery = applicationRecoveryCoordinator.install()
    const disposeReceiver = installRoomNativeReceiver()
    const stopRecharge = onRechargeSucceeded(async () => {
      try {
        session.applyProfile(await profileQueries.getProfile())
        await queryClient.invalidateQueries()
      } catch (cause) {
        observability.captureError(cause, { source: 'recharge-refresh' })
      }
    })
    app.onUnmount(() => {
      stopAuthEvents()
      void disposeRoomMessageRuntime()
      stopRecharge()
      disposeReceiver()
      disposeRecovery()
      disposeActivity()
    })

    await router.isReady()
    app.mount('#app')
    document.documentElement.dataset.appMounted = 'true'
    await initializeMobileConsole()
  } catch (cause) {
    showFatalError(cause)
  }
}

void bootstrap()

import { getCurrentScope, onScopeDispose } from 'vue'
import { useAppNavigation } from '@/core/navigation/coordinator'
import { hideGlobalLoading, showGlobalLoading } from './global-loading-state'
import { showAppToast, type AppToastOptions } from './toast-state'

const MINIMUM_VISIBLE_MS = 300

let count = 0
let releaseGesture: (() => void) | undefined
let showFrame = 0
let hideTimer = 0
let shownAt = 0
let visible = false

function clearScheduledHide(): void {
  window.clearTimeout(hideTimer)
  hideTimer = 0
}

export function useAppFeedback() {
  const navigation = useAppNavigation()

  function toast(message: unknown, options: AppToastOptions = {}): void {
    showAppToast(message, options)
  }

  function success(message: unknown, options: Omit<AppToastOptions, 'tone'> = {}): void {
    showAppToast(message, { ...options, tone: 'success' })
  }

  function warning(message: unknown, options: Omit<AppToastOptions, 'tone'> = {}): void {
    showAppToast(message, { ...options, tone: 'warning' })
  }

  function error(message: unknown, options: Omit<AppToastOptions, 'tone'> = {}): void {
    showAppToast(message, { ...options, tone: 'danger' })
  }

  function notify(message: unknown, options: AppToastOptions = {}): void {
    showAppToast(message, { duration: 2_600, ...options })
  }

  function loading(message = 'Please wait…'): () => void {
    count += 1
    clearScheduledHide()

    if (count === 1 && !visible) {
      window.cancelAnimationFrame(showFrame)
      showFrame = window.requestAnimationFrame(() => {
        showFrame = 0
        if (count === 0) return
        shownAt = performance.now()
        visible = true
        releaseGesture = navigation.acquireGestureLock('blocking-loading')
        showGlobalLoading(message)
      })
    }

    let closed = false
    const close = () => {
      if (closed) return
      closed = true
      count = Math.max(0, count - 1)
      if (count > 0) return

      if (!visible) {
        window.cancelAnimationFrame(showFrame)
        showFrame = 0
        return
      }

      const remaining = Math.max(0, MINIMUM_VISIBLE_MS - (performance.now() - shownAt))
      clearScheduledHide()
      hideTimer = window.setTimeout(() => {
        hideTimer = 0
        if (count > 0) return
        visible = false
        hideGlobalLoading()
        releaseGesture?.()
        releaseGesture = undefined
      }, remaining)
    }

    if (getCurrentScope()) onScopeDispose(close)
    return close
  }

  return { error, loading, notify, success, toast, warning }
}

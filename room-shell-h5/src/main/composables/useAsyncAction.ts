import { onScopeDispose, readonly, ref } from 'vue'
import { ApiClientError } from '@/core/api/client'
import { BridgeError } from '@/core/bridge/protocol'
import { useAppFeedback } from '@/main/ui/feedback'

export type AsyncActionFeedback = 'blocking' | 'inline'

export interface AsyncActionOptions {
  errorMessage?: (error: unknown) => string
  feedback: AsyncActionFeedback
  loadingMessage?: (() => string) | string
  minimumIntervalMs?: number
  minimumLoadingMs?: number
}

export function useAsyncAction<TArgs extends unknown[], TResult>(
  action: (...args: TArgs) => Promise<TResult> | TResult,
  options: AsyncActionOptions,
) {
  const pending = ref(false)
  const feedback = useAppFeedback()
  const minimumIntervalMs = options.minimumIntervalMs ?? (options.feedback === 'blocking' ? 800 : 0)
  const minimumLoadingMs = options.minimumLoadingMs ?? (options.feedback === 'blocking' ? 300 : 0)
  let inFlight: Promise<TResult> | undefined
  let latestPromise: Promise<TResult> | undefined
  let lastStartedAt = 0
  let disposed = false
  let closeLoading: (() => void) | undefined

  async function perform(args: TArgs): Promise<TResult> {
    const startedAt = performance.now()
    pending.value = true
    const message =
      typeof options.loadingMessage === 'function'
        ? options.loadingMessage()
        : options.loadingMessage
    closeLoading =
      options.feedback === 'blocking' ? feedback.loading(message ?? 'Please wait…') : undefined

    try {
      return await action(...args)
    } catch (error) {
      lastStartedAt = 0
      const handledBySession = error instanceof ApiClientError && error.sessionInvalidated
      const cancelled =
        (error instanceof ApiClientError && error.kind === 'aborted') ||
        (error instanceof BridgeError && error.code === 'CANCELLED')
      if (!handledBySession && !cancelled) {
        const message =
          options.errorMessage?.(error) ??
          (error instanceof Error ? error.message : 'Something went wrong.')
        feedback.error(message)
      }
      throw error
    } finally {
      const remaining = Math.max(0, minimumLoadingMs - (performance.now() - startedAt))
      if (remaining > 0) {
        await new Promise((resolve) => window.setTimeout(resolve, remaining))
      }

      closeLoading?.()
      closeLoading = undefined
      if (!disposed) pending.value = false
      inFlight = undefined
    }
  }

  function execute(...args: TArgs): Promise<TResult> {
    if (inFlight) return inFlight

    const now = Date.now()
    if (latestPromise && minimumIntervalMs > 0 && now - lastStartedAt < minimumIntervalMs) {
      return latestPromise
    }

    lastStartedAt = now
    inFlight = perform(args)
    latestPromise = inFlight
    return inFlight
  }

  onScopeDispose(() => {
    disposed = true
    pending.value = false
    closeLoading?.()
    closeLoading = undefined
  })

  return {
    execute,
    pending: readonly(pending),
    run: execute,
  }
}

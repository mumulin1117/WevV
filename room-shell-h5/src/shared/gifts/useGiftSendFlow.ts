import { ref } from 'vue'
import { useAppFeedback } from '@/main/ui/feedback'

export type GiftSendFlowResult<T> =
  { status: 'busy' } | { cause: unknown; status: 'failed' } | { status: 'sent'; value: T }

export function isGiftBalanceError(value: unknown): boolean {
  const message = value instanceof Error ? value.message : String(value ?? '')
  return /diamond\.not\.enough|not enough diamonds/iu.test(message)
}

export function useGiftSendFlow() {
  const feedback = useAppFeedback()
  const pending = ref(false)

  async function run<T>(operation: () => Promise<T>): Promise<GiftSendFlowResult<T>> {
    if (pending.value) return { status: 'busy' }
    pending.value = true
    const closeLoading = feedback.loading()
    try {
      return { status: 'sent', value: await operation() }
    } catch (cause) {
      return { cause, status: 'failed' }
    } finally {
      closeLoading()
      pending.value = false
    }
  }

  return { pending, run }
}

import { reactive } from 'vue'

interface GlobalLoadingState {
  message: string
  visible: boolean
}

export const globalLoadingState = reactive<GlobalLoadingState>({
  message: '',
  visible: false,
})

let count = 0

export function showGlobalLoading(message = ''): void {
  count += 1
  globalLoadingState.message = message
  globalLoadingState.visible = count > 0
}

export function hideGlobalLoading(): void {
  count = Math.max(0, count - 1)
  globalLoadingState.visible = count > 0
  if (count === 0) globalLoadingState.message = ''
}

export function updateGlobalLoadingMessage(message: string): void {
  if (!globalLoadingState.visible) return
  globalLoadingState.message = message
}

import { reactive } from 'vue'

export type AppToastTone = 'danger' | 'info' | 'success' | 'warning'

export interface AppToastOptions {
  duration?: number
  title?: string
  tone?: AppToastTone
}

interface AppToastState {
  duration: number
  key: number
  message: string
  title: string
  tone: AppToastTone
  visible: boolean
}

const defaultTitles: Record<AppToastTone, string> = {
  danger: 'Error',
  info: 'Notification',
  success: 'Success',
  warning: 'Warning',
}

export const appToastState = reactive<AppToastState>({
  duration: 2_200,
  key: 0,
  message: '',
  title: '',
  tone: 'info',
  visible: false,
})

let lastSignature = ''
let lastShownAt = 0

function normalizeMessage(message: unknown): string {
  if (message instanceof Error) return message.message
  if (typeof message === 'string' || typeof message === 'number') return String(message)
  try {
    return JSON.stringify(message)
  } catch {
    return 'Something went wrong.'
  }
}

export function showAppToast(message: unknown, options: AppToastOptions = {}): void {
  const normalized = normalizeMessage(message)
  const tone = options.tone ?? 'info'
  const title = options.title ?? defaultTitles[tone]
  const signature = `${tone}:${title}:${normalized}`
  const now = Date.now()
  if (signature === lastSignature && now - lastShownAt < 600) return

  lastSignature = signature
  lastShownAt = now
  appToastState.duration = Math.max(0, options.duration ?? 2_200)
  appToastState.key += 1
  appToastState.message = normalized
  appToastState.title = title
  appToastState.tone = tone
  appToastState.visible = true
}

export function hideAppToast(): void {
  appToastState.visible = false
}

import { shallowRef } from 'vue'
import type { RoomEntry } from '@/core/entry/room-entry'

export interface ClientContext {
  appVersion: string
  bundleIdentifier: string
  deviceNo: string
  paymentEnabled: boolean
  preferredLanguages: readonly string[]
  timeZone: string
}

const currentContext = shallowRef<ClientContext>()

export function initializeClientContext(entry: RoomEntry): ClientContext {
  const nextContext: ClientContext = {
    appVersion: entry.appVersion,
    bundleIdentifier: 'room-shell-h5',
    deviceNo: entry.deviceNo,
    paymentEnabled: true,
    preferredLanguages: [entry.locale],
    timeZone: Intl.DateTimeFormat().resolvedOptions().timeZone || 'UTC',
  }
  currentContext.value = nextContext
  return nextContext
}

export function getClientContext(): ClientContext {
  if (!currentContext.value) throw new Error('The room client context is not initialized.')
  return currentContext.value
}

export function isPaymentEnabled(): boolean {
  return currentContext.value?.paymentEnabled ?? true
}

export function resetClientContextForTests(): void {
  currentContext.value = undefined
}

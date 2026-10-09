import { getRuntimeConfig } from '@/core/config/runtime-config'
import { createId } from '@/shared/id'

export type RoomType = 'live' | 'voice'

export interface RoomClosePayload {
  reason: 'auth-invalid' | 'ended' | 'fatal' | 'user'
  roomId: string
  roomType: RoomType
}

export interface RoomReadyPayload {
  roomId: string
  roomType: RoomType
}

export interface RechargeOpenPayload {
  requestId: string
  requiredDiamonds: number
  roomId: string
  roomType: RoomType
  source: 'live' | 'party'
}

export interface RechargeSucceededPayload {
  eventId: string
  occurredAt: number
  transactionId?: string
}

interface NativeCommand {
  id: string
  kind: 'command'
  name: string
  occurredAt: number
  payload: unknown
  protocolVersion: 1
}

type RechargeListener = (payload: RechargeSucceededPayload) => void
const rechargeListeners = new Set<RechargeListener>()
const seenRechargeEvents = new Set<string>()
let installed = false
let roomCloseSent = false

type BridgeWindow = Window & {
  flutter_inappwebview?: { callHandler: (name: string, message: unknown) => Promise<unknown> }
  webkit?: { messageHandlers?: Record<string, { postMessage: (message: unknown) => void }> }
  [key: string]: unknown
}

function targetWindow(): BridgeWindow {
  return window as unknown as BridgeWindow
}

function send(name: string, payload: unknown): void {
  const config = getRuntimeConfig().bridge
  const message: NativeCommand = {
    id: createId('room-command'),
    kind: 'command',
    name,
    occurredAt: Date.now(),
    payload,
    protocolVersion: 1,
  }
  const target = targetWindow()
  const webkit = target.webkit?.messageHandlers?.[config.handler]
  if (webkit) {
    webkit.postMessage(message)
    return
  }
  const javascriptChannel = target[config.handler] as
    { postMessage?: (message: string) => void } | undefined
  if (typeof javascriptChannel?.postMessage === 'function') {
    javascriptChannel.postMessage(JSON.stringify(message))
    return
  }
  if (typeof target.flutter_inappwebview?.callHandler === 'function') {
    void target.flutter_inappwebview.callHandler(config.handler, message).catch(() => undefined)
    return
  }
  window.dispatchEvent(new CustomEvent('room-h5-native-command', { detail: message }))
}

function isRechargeSucceeded(value: unknown): value is {
  kind: 'event'
  name: string
  payload: RechargeSucceededPayload
  protocolVersion: 1
} {
  if (!value || typeof value !== 'object') return false
  const message = value as Record<string, unknown>
  const payload = message.payload as Record<string, unknown> | undefined
  return (
    message.kind === 'event' &&
    message.protocolVersion === 1 &&
    message.name === getRuntimeConfig().bridge.events.rechargeSucceeded &&
    Boolean(payload) &&
    typeof payload?.eventId === 'string' &&
    Boolean(payload.eventId) &&
    typeof payload?.occurredAt === 'number' &&
    Number.isFinite(payload.occurredAt) &&
    (payload.transactionId === undefined || typeof payload.transactionId === 'string')
  )
}

export function installRoomNativeReceiver(): () => void {
  if (installed) return () => undefined
  installed = true
  const target = targetWindow()
  const receiver = getRuntimeConfig().bridge.receiver
  const previous = target[receiver]
  const receive = (input: unknown) => {
    let value = input
    if (typeof value === 'string') {
      try {
        value = JSON.parse(value) as unknown
      } catch {
        return
      }
    }
    if (!isRechargeSucceeded(value)) return
    const payload = value.payload
    if (seenRechargeEvents.has(payload.eventId)) return
    seenRechargeEvents.add(payload.eventId)
    if (seenRechargeEvents.size > 200)
      seenRechargeEvents.delete(seenRechargeEvents.values().next().value!)
    rechargeListeners.forEach((listener) => listener(payload))
  }
  target[receiver] = receive
  return () => {
    if (target[receiver] === receive) target[receiver] = previous
    installed = false
    seenRechargeEvents.clear()
  }
}

export function onRechargeSucceeded(listener: RechargeListener): () => void {
  rechargeListeners.add(listener)
  return () => rechargeListeners.delete(listener)
}

export function closeNativeRoom(payload: RoomClosePayload): void {
  if (roomCloseSent) return
  roomCloseSent = true
  send(getRuntimeConfig().bridge.commands.closeRoom, payload)
}

export function notifyNativeRoomReady(payload: RoomReadyPayload): void {
  send('room.ready', payload)
}

export function openNativeRecharge(payload: Omit<RechargeOpenPayload, 'requestId'>): string {
  const requestId = createId('recharge')
  send(getRuntimeConfig().bridge.commands.openRecharge, { ...payload, requestId })
  return requestId
}

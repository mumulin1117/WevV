export const BRIDGE_PROTOCOL_VERSION = '3.12.0'

export type BridgeErrorCode =
  | 'BRIDGE_UNAVAILABLE'
  | 'UNSUPPORTED_METHOD'
  | 'PERMISSION_DENIED'
  | 'CANCELLED'
  | 'TIMEOUT'
  | 'NATIVE_FAILED'
  | 'INVALID_PAYLOAD'
  | 'STALE_SESSION'

export interface BridgeErrorPayload {
  code: BridgeErrorCode
  message: string
  details?: unknown
}

export interface BridgeRequest {
  kind: 'request'
  id: string
  protocolVersion: string
  sessionEpoch: string
  method: string
  params: unknown
  deadlineMs: number
}

export type BridgeResponse =
  | {
      kind: 'response'
      id: string
      sessionEpoch: string
      ok: true
      result: unknown
    }
  | {
      kind: 'response'
      id: string
      sessionEpoch: string
      ok: false
      error: BridgeErrorPayload
    }

export interface BridgeEvent {
  kind: 'event'
  eventId: string
  sessionEpoch: string
  type: string
  occurredAt: number
  payload: unknown
}

export type BridgeMessage = BridgeRequest | BridgeResponse | BridgeEvent

const bridgeErrorCodes = new Set<BridgeErrorCode>([
  'BRIDGE_UNAVAILABLE',
  'UNSUPPORTED_METHOD',
  'PERMISSION_DENIED',
  'CANCELLED',
  'TIMEOUT',
  'NATIVE_FAILED',
  'INVALID_PAYLOAD',
  'STALE_SESSION',
])

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value)
}

function isNonEmptyString(value: unknown): value is string {
  return typeof value === 'string' && value.length > 0
}

function isBridgeErrorPayload(value: unknown): value is BridgeErrorPayload {
  if (!isRecord(value)) return false
  return (
    isNonEmptyString(value.code) &&
    bridgeErrorCodes.has(value.code as BridgeErrorCode) &&
    isNonEmptyString(value.message)
  )
}

function isBridgeResponse(value: unknown): value is BridgeResponse {
  if (
    !isRecord(value) ||
    value.kind !== 'response' ||
    !isNonEmptyString(value.id) ||
    !isNonEmptyString(value.sessionEpoch) ||
    typeof value.ok !== 'boolean'
  ) {
    return false
  }
  if (value.ok) return Object.hasOwn(value, 'result')
  return isBridgeErrorPayload(value.error)
}

function isBridgeEvent(value: unknown): value is BridgeEvent {
  return (
    isRecord(value) &&
    value.kind === 'event' &&
    isNonEmptyString(value.eventId) &&
    isNonEmptyString(value.sessionEpoch) &&
    isNonEmptyString(value.type) &&
    typeof value.occurredAt === 'number' &&
    Number.isFinite(value.occurredAt) &&
    Object.hasOwn(value, 'payload')
  )
}

export function parseIncomingBridgeMessage(input: unknown): BridgeResponse | BridgeEvent | null {
  let value = input
  if (typeof value === 'string') {
    try {
      value = JSON.parse(value)
    } catch {
      return null
    }
  }

  if (isBridgeResponse(value)) return value
  return isBridgeEvent(value) ? value : null
}

export class BridgeError extends Error {
  readonly code: BridgeErrorCode
  readonly details?: unknown

  constructor(payload: BridgeErrorPayload) {
    super(payload.message)
    this.name = 'BridgeError'
    this.code = payload.code
    this.details = payload.details
  }
}

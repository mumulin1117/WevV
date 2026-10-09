import type { GameBridgeType, GameHostEvent } from './contracts'

function record(value: unknown): Record<string, unknown> | null {
  if (value === null || typeof value !== 'object' || Array.isArray(value)) return null
  return value as Record<string, unknown>
}

function parsePayload(value: unknown): unknown {
  if (typeof value !== 'string') return value
  const normalized = value.trim()
  if (!normalized) return value
  try {
    return JSON.parse(normalized) as unknown
  } catch {
    return value
  }
}

export function parseGameHostEvent(payload: unknown, bridgeType: GameBridgeType): GameHostEvent {
  const parsed = parsePayload(payload)
  const value = record(parsed)
  if (!value) return { raw: payload, type: 'unknown' }

  if (bridgeType === 'yomi') {
    if (value.action === 'insufficient') return { type: 'recharge' }
    if (value.action === 'closeGame') return { type: 'close' }
    if (value.action === 'hideSplash') return { type: 'ready' }
  } else if (bridgeType === 'lingxian') {
    if (value.method === 'pay') return { type: 'recharge' }
    if (value.method === 'closeGame') return { type: 'close' }
    if (value.method === 'loadComplete') return { type: 'ready' }
  } else {
    if (value.msg === 'goRecharge') return { type: 'recharge' }
    if (value.msg === 'goBack') return { type: 'close' }
    if (value.msg === 'loadSuccess') return { type: 'ready' }
  }
  return { raw: payload, type: 'unknown' }
}

export function rechargeSuccessPayload(bridgeType: GameBridgeType, balance: number): unknown {
  if (bridgeType === 'yomi') return { action: 'insufficient', balance, result: 'success' }
  if (bridgeType === 'lingxian') return JSON.stringify({ method: 'updateCoin', param: '' })
  return { diamondNum: balance, target: 'rechargeSuccess' }
}

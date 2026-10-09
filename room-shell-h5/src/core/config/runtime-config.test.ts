import { describe, expect, it } from 'vitest'
import { parseRuntimeConfig } from './runtime-config'

const valid = {
  schemaVersion: 1,
  build: { buildId: 'test', minimumHostVersion: '1.0.0' },
  app: { appId: '100', documentTitle: 'Room', defaultLocale: 'en' },
  api: {
    baseUrl: 'http://localhost:8080',
    encryptionKey: '1234567890123456',
    encryptionIv: 'abcdefghijklmnop',
    timeoutMs: 15_000,
  },
  theme: { primary: '#FF1BA8', secondary: '#E57EFF', accent: '#A846EE' },
  bridge: {
    handler: 'roomBridge',
    receiver: '__ROOM_H5_BRIDGE_RECEIVE__',
    commands: { closeRoom: 'room.close', openRecharge: 'recharge.open' },
    events: { rechargeSucceeded: 'recharge.succeeded' },
  },
  debug: { vConsoleEnabled: false },
} as const

describe('runtime config', () => {
  it('accepts the single editable room config', () => {
    expect(parseRuntimeConfig(valid).api.baseUrl).toBe('http://localhost:8080')
  })

  it('rejects legacy or unknown configuration sections', () => {
    expect(() => parseRuntimeConfig({ ...valid, opiProfile: {} })).toThrow()
  })
})

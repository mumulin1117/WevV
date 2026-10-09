import { beforeEach, describe, expect, it, vi } from 'vitest'
import { resetRuntimeConfigForTests } from '@/core/config/runtime-config'
import {
  installRoomNativeReceiver,
  notifyNativeRoomReady,
  onRechargeSucceeded,
  openNativeRecharge,
} from './room-native-bridge'

describe('room native bridge', () => {
  beforeEach(() => {
    resetRuntimeConfigForTests()
    window.__ROOM_APP_CONFIG__ = {
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
    }
  })

  it('uses a Flutter JavaScriptChannel and receives recharge success once', () => {
    const postMessage = vi.fn()
    Object.assign(window, { roomBridge: { postMessage } })
    openNativeRecharge({ requiredDiamonds: 12, roomId: '8', roomType: 'voice', source: 'party' })
    expect(JSON.parse(postMessage.mock.calls[0]![0])).toMatchObject({
      kind: 'command',
      name: 'recharge.open',
      payload: { requiredDiamonds: 12, roomId: '8', roomType: 'voice' },
      protocolVersion: 1,
    })

    const listener = vi.fn()
    const stopReceiver = installRoomNativeReceiver()
    const stopListener = onRechargeSucceeded(listener)
    const receiver = (window as unknown as Record<string, (value: unknown) => void>)[
      '__ROOM_H5_BRIDGE_RECEIVE__'
    ]!
    const event = {
      kind: 'event',
      name: 'recharge.succeeded',
      payload: { eventId: 'event-1', occurredAt: 1 },
      protocolVersion: 1,
    }
    receiver(event)
    receiver(event)
    expect(listener).toHaveBeenCalledTimes(1)
    stopListener()
    stopReceiver()
  })

  it('notifies native after visible room content is rendered', () => {
    const postMessage = vi.fn()
    Object.assign(window, { webkit: { messageHandlers: { roomBridge: { postMessage } } } })

    notifyNativeRoomReady({ roomId: '8', roomType: 'voice' })

    expect(postMessage).toHaveBeenCalledWith(
      expect.objectContaining({
        kind: 'command',
        name: 'room.ready',
        payload: { roomId: '8', roomType: 'voice' },
        protocolVersion: 1,
      }),
    )
  })
})

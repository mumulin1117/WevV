import { beforeEach, describe, expect, it } from 'vitest'
import { readRoomEntry, scrubRoomToken } from './room-entry'

describe('room URL entry', () => {
  beforeEach(() => history.replaceState(null, '', '/index.html'))

  it('reads the live route and required native parameters', () => {
    location.hash = '#/live/123?token=secret&userId=456&appVersion=2.3.0&deviceNo=ios-1&locale=en'
    expect(readRoomEntry('en')).toEqual({
      appVersion: '2.3.0',
      deviceNo: 'ios-1',
      locale: 'en',
      roomId: '123',
      roomType: 'live',
      token: 'secret',
      userId: '456',
    })
  })

  it('removes only the token from the hash URL', () => {
    location.hash = '#/voice/8?token=secret&userId=9&appVersion=1.0&deviceNo=flutter-1'
    scrubRoomToken()
    expect(location.hash).toBe('#/voice/8?userId=9&appVersion=1.0&deviceNo=flutter-1')
  })

  it('rejects an entry without the native account identity', () => {
    location.hash = '#/live/123?token=secret&appVersion=1.0&deviceNo=ios-1'
    expect(() => readRoomEntry('en')).toThrow('A valid userId is required.')
  })
})

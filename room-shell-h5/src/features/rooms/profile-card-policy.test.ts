import { describe, expect, it } from 'vitest'
import { resolveProfileCardPolicy, type ProfileCardScene } from './profile-card-policy'

function showGiftWall(scene: ProfileCardScene): boolean {
  return resolveProfileCardPolicy({
    blocked: false,
    followAvailable: true,
    hasImAccount: true,
    messageAvailable: true,
    scene,
    self: false,
    userType: 1,
  }).showGiftWall
}

describe('profile card policy', () => {
  it('hides the gift wall in voice rooms', () => {
    expect(showGiftWall('party')).toBe(false)
  })

  it('keeps the gift wall in live rooms', () => {
    expect(showGiftWall('live')).toBe(true)
  })
})

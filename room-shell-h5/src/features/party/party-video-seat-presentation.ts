import type { PartySeat } from '@/features/party/contracts'

export type PartyVideoSeatMode = 'camera-off' | 'camera-on' | 'empty' | 'locked'

export type PartyVideoSeatHostBadge = 'camera-off' | 'camera-on' | 'none' | 'placeholder'

export interface PartyVideoSeatPresentation {
  hostBadge: PartyVideoSeatHostBadge
  hostBorder: boolean
  hostWings: boolean
  hostWingsMuted: boolean
  microphoneDisabled: boolean
  mode: PartyVideoSeatMode
  occupied: boolean
  showGiftFooter: boolean
  showIndex: boolean
  showRoleBadge: boolean
  showSpeakingFrame: boolean
}

export function resolvePartyVideoSeatPresentation(seat: PartySeat): PartyVideoSeatPresentation {
  const occupied = Boolean(seat.member)
  const microphoneDisabled = Boolean(seat.prohibited || seat.member?.muted)
  const mode: PartyVideoSeatMode = !occupied
    ? seat.locked
      ? 'locked'
      : 'empty'
    : seat.cameraEnabled
      ? 'camera-on'
      : 'camera-off'
  const hostBadge: PartyVideoSeatHostBadge = !seat.host
    ? 'none'
    : !occupied
      ? 'placeholder'
      : !microphoneDisabled
        ? 'none'
        : mode === 'camera-on'
          ? 'camera-on'
          : 'camera-off'

  return {
    hostBadge,
    hostBorder: seat.host && (!occupied || mode === 'camera-off'),
    hostWings: seat.host && (!occupied || microphoneDisabled),
    hostWingsMuted: !occupied,
    microphoneDisabled,
    mode,
    occupied,
    showGiftFooter: occupied,
    showIndex: !occupied,
    showRoleBadge: occupied && seat.member?.roomRole !== 'member',
    showSpeakingFrame: mode === 'camera-off' && seat.speaking,
  }
}

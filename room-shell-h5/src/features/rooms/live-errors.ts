export type LiveRoomUnavailableReason = 'ended' | 'host-busy' | 'invalid-room'

export class LiveRoomUnavailableError extends Error {
  constructor(readonly reason: LiveRoomUnavailableReason) {
    super(
      reason === 'ended'
        ? 'This live has ended.'
        : reason === 'host-busy'
          ? 'The host is temporarily unavailable.'
          : 'This live room is unavailable.',
    )
    this.name = 'LiveRoomUnavailableError'
  }
}

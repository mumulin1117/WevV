export interface ProfileCardRequestTarget {
  id: string
}

export type ProfileCardRequestLoader<TTarget extends ProfileCardRequestTarget, TCard> = (
  target: TTarget,
  signal: AbortSignal,
) => Promise<TCard>

export type ProfileCardRequestResult<TCard> =
  { card: TCard; status: 'loaded' } | { error: unknown; status: 'failed' } | { status: 'cancelled' }

interface ActiveProfileCardRequest {
  controller: AbortController
  token: symbol
}

/**
 * Keeps profile-card requests latest-only while still cancelling the underlying transport.
 * Components own their visual state; this coordinator only defines request concurrency.
 */
export class ProfileCardRequestCoordinator<TTarget extends ProfileCardRequestTarget, TCard> {
  private active: ActiveProfileCardRequest | null = null

  cancel(): void {
    this.active?.controller.abort()
    this.active = null
  }

  async load(
    target: TTarget,
    loader: ProfileCardRequestLoader<TTarget, TCard>,
  ): Promise<ProfileCardRequestResult<TCard>> {
    this.cancel()
    const request: ActiveProfileCardRequest = {
      controller: new AbortController(),
      token: Symbol(target.id),
    }
    this.active = request
    try {
      const card = await loader(target, request.controller.signal)
      if (request.controller.signal.aborted || this.active?.token !== request.token)
        return { status: 'cancelled' }
      return { card, status: 'loaded' }
    } catch (error) {
      if (request.controller.signal.aborted || this.active?.token !== request.token)
        return { status: 'cancelled' }
      return { error, status: 'failed' }
    } finally {
      if (this.active?.token === request.token) this.active = null
    }
  }
}

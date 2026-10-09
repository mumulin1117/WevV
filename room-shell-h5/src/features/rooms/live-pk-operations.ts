import type { LivePkDetail, LivePkRankEntry, LivePkRepository } from './live-pk-contracts'
import { getLivePkRepository } from './live-pk-repository'

export type LivePkSide = 'left' | 'right'

export interface LivePkRankContext {
  anchorId: string
  pkId: string
  side: LivePkSide
}

export class LivePkRankContextError extends Error {
  constructor() {
    super('PK rank context is incomplete or invalid.')
    this.name = 'LivePkRankContextError'
  }
}

interface PendingRankRequest {
  consumers: number
  controller: AbortController
  promise: Promise<readonly LivePkRankEntry[]>
  settled: boolean
}

function aborted(): DOMException {
  return new DOMException('Aborted', 'AbortError')
}

function normalizeAnchorId(value: string): string | null {
  const anchorId = Number(value)
  return Number.isSafeInteger(anchorId) && anchorId > 0 ? String(anchorId) : null
}

export function getLivePkRankContext(
  detail: LivePkDetail,
  side: LivePkSide,
): LivePkRankContext | null {
  const pkId = detail.pkId.trim()
  const anchorId = normalizeAnchorId(side === 'left' ? detail.leftUserId : detail.rightUserId)
  return pkId && anchorId ? { anchorId, pkId, side } : null
}

export class LivePkQueries {
  private readonly pending = new Map<string, PendingRankRequest>()

  constructor(private readonly repository?: LivePkRepository) {}

  getRank(
    detail: LivePkDetail,
    side: LivePkSide,
    signal?: AbortSignal,
  ): Promise<readonly LivePkRankEntry[]> {
    const context = getLivePkRankContext(detail, side)
    if (!context) return Promise.reject(new LivePkRankContextError())

    const key = `${context.pkId}:${context.anchorId}`
    let pending = this.pending.get(key)
    if (!pending) {
      const controller = new AbortController()
      pending = {
        consumers: 0,
        controller,
        promise: (this.repository ?? getLivePkRepository()).getRank(
          context.pkId,
          context.anchorId,
          controller.signal,
        ),
        settled: false,
      }
      this.pending.set(key, pending)
      const settle = () => {
        pending!.settled = true
        if (this.pending.get(key) === pending) this.pending.delete(key)
      }
      void pending.promise.then(settle, settle)
    }
    return this.waitForRank(pending, signal)
  }

  private async waitForRank(
    pending: PendingRankRequest,
    signal?: AbortSignal,
  ): Promise<readonly LivePkRankEntry[]> {
    if (signal?.aborted) throw aborted()
    pending.consumers += 1
    let rejectAbort: ((reason: DOMException) => void) | undefined
    const abortPromise = signal
      ? new Promise<never>((_resolve, reject) => {
          rejectAbort = reject
        })
      : null
    const onAbort = () => rejectAbort?.(aborted())
    signal?.addEventListener('abort', onAbort, { once: true })
    try {
      return await (abortPromise ? Promise.race([pending.promise, abortPromise]) : pending.promise)
    } finally {
      signal?.removeEventListener('abort', onAbort)
      pending.consumers -= 1
      if (!pending.settled && pending.consumers === 0) pending.controller.abort()
    }
  }
}

export const livePkQueries = new LivePkQueries()

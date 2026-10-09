import { shallowReactive } from 'vue'
import { reportRuntimeMetric } from '@/core/observability/runtime'
import { preloadGiftEffect } from '@/shared/gifts/gift-effect-assets'
import type { LiveEntryEffect } from './chatroom-contracts'

export interface LiveRoomGiftEffectRequest {
  dedupeKey: string
  url: string
}

export type LiveRoomEffectItem =
  | {
      effect: LiveEntryEffect
      enqueuedAt: number
      id: number
      kind: 'entry'
      url: string
    }
  | {
      dedupeKey: string
      enqueuedAt: number
      id: number
      kind: 'gift'
      url: string
    }

interface LiveRoomEffectState {
  current: LiveRoomEffectItem | null
}

const PREPARE_WATCHDOG_MS = 15_000
const PLAYBACK_WATCHDOG_MS = 30_000
const STATIC_ENTRY_DURATION_MS = 3_000
const QUEUE_GAP_MS = 220
const QUEUE_LIMIT = 10
const DEDUPE_LIMIT = 200

function normalizeEffectUrl(value: string | undefined): string {
  const url = value?.trim() ?? ''
  const path = url.toLowerCase().split(/[?#]/u, 1)[0] ?? ''
  return path.endsWith('.svga') || path.endsWith('.mp4') ? url : ''
}

export class LiveRoomEffectScheduler {
  readonly state = shallowReactive<LiveRoomEffectState>({ current: null })

  private readonly pending: LiveRoomEffectItem[] = []
  private readonly seenGiftKeys = new Set<string>()
  private nextId = 0
  private playbackTimer = 0
  private queueGapTimer = 0

  constructor(private readonly roomId: string) {}

  enqueueEntry(effect: LiveEntryEffect): boolean {
    const queuedIndex = this.pending.findIndex(
      (item) => item.kind === 'entry' && item.effect.userId === effect.userId,
    )
    if (queuedIndex >= 0) {
      const queued = this.pending[queuedIndex]
      if (!queued || queued.kind !== 'entry' || queued.effect.priority >= effect.priority) {
        this.report('discarded', 'entry')
        return false
      }
      this.pending.splice(queuedIndex, 1, this.createEntryItem(effect))
      this.report('replaced', 'entry')
      return true
    }
    if (!this.hasCapacity()) {
      this.report('full', 'entry')
      return false
    }
    this.pending.push(this.createEntryItem(effect))
    this.report('accepted', 'entry')
    this.playNext()
    return true
  }

  enqueueGift(request: LiveRoomGiftEffectRequest): boolean {
    const url = normalizeEffectUrl(request.url)
    const dedupeKey = request.dedupeKey.trim()
    if (!url || !dedupeKey || this.seenGiftKeys.has(dedupeKey)) {
      this.report('discarded', 'gift')
      return false
    }
    if (!this.hasCapacity()) {
      this.report('full', 'gift')
      return false
    }
    this.seenGiftKeys.add(dedupeKey)
    while (this.seenGiftKeys.size > DEDUPE_LIMIT) {
      const oldest = this.seenGiftKeys.values().next().value
      if (oldest === undefined) break
      this.seenGiftKeys.delete(oldest)
    }
    const item: LiveRoomEffectItem = {
      dedupeKey,
      enqueuedAt: Date.now(),
      id: (this.nextId += 1),
      kind: 'gift',
      url,
    }
    this.pending.push(item)
    this.preload(item.url)
    this.report('accepted', 'gift')
    this.playNext()
    return true
  }

  finish(id: number): void {
    if (this.state.current?.id !== id) return
    window.clearTimeout(this.playbackTimer)
    this.playbackTimer = 0
    this.state.current = null
    window.clearTimeout(this.queueGapTimer)
    this.queueGapTimer = window.setTimeout(() => {
      this.queueGapTimer = 0
      this.playNext()
    }, QUEUE_GAP_MS)
  }

  start(id: number): void {
    const current = this.state.current
    if (!current || current.id !== id || !current.url) return
    window.clearTimeout(this.playbackTimer)
    this.playbackTimer = window.setTimeout(() => this.finish(id), PLAYBACK_WATCHDOG_MS)
    reportRuntimeMetric('gift.effect.queue-start-latency', Date.now() - current.enqueuedAt, {
      kind: current.kind,
      roomId: this.roomId,
    })
  }

  clear(): void {
    window.clearTimeout(this.playbackTimer)
    window.clearTimeout(this.queueGapTimer)
    this.playbackTimer = 0
    this.queueGapTimer = 0
    this.pending.splice(0)
    this.seenGiftKeys.clear()
    this.state.current = null
  }

  private createEntryItem(effect: LiveEntryEffect): LiveRoomEffectItem {
    const item: LiveRoomEffectItem = {
      effect,
      enqueuedAt: Date.now(),
      id: (this.nextId += 1),
      kind: 'entry',
      url: normalizeEffectUrl(effect.effectUrl),
    }
    this.preload(item.url)
    return item
  }

  private hasCapacity(): boolean {
    return this.pending.length + (this.state.current ? 1 : 0) < QUEUE_LIMIT
  }

  private playNext(): void {
    if (this.state.current || !this.pending.length) return
    const item = this.pending.shift() ?? null
    this.state.current = item
    if (!item) return
    const duration =
      item.kind === 'entry' && !item.url ? STATIC_ENTRY_DURATION_MS : PREPARE_WATCHDOG_MS
    window.clearTimeout(this.playbackTimer)
    this.playbackTimer = window.setTimeout(() => this.finish(item.id), duration)
  }

  private preload(url: string): void {
    if (!url) return
    void preloadGiftEffect(url, {
      decodeSvga: true,
      priority: 'critical',
      trigger: 'queue',
    }).catch(() => undefined)
  }

  private report(action: string, kind: LiveRoomEffectItem['kind']): void {
    reportRuntimeMetric(
      'live.effect.queue-depth',
      this.pending.length + (this.state.current ? 1 : 0),
      { action, kind, roomId: this.roomId },
    )
  }
}

export function createLiveRoomEffectScheduler(roomId: string): LiveRoomEffectScheduler {
  return new LiveRoomEffectScheduler(roomId)
}

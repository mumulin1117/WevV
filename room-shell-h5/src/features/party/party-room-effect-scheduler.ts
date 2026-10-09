import { shallowReactive } from 'vue'
import type { PartyMessage } from './contracts'
import { preloadGiftEffect } from '@/shared/gifts/gift-effect-assets'

const FLOATING_GIFT_LIMIT = 3
const FLOATING_GIFT_DURATION_MS = 3_000
const FLOATING_GIFT_STAGGER_MS = 300
const STATIC_ENTRY_DURATION_MS = 3_000
const FIRST_GIFT_DURATION_MS = 5_000
const FIRST_GIFT_GAP_MS = 800
const MEDIA_PREPARE_WATCHDOG_MS = 15_000
const MEDIA_PLAYBACK_WATCHDOG_MS = 30_000
const NORMAL_GIFT_DURATION_MS = 1_500
const MEDIA_GAP_MS = 220
const QUEUE_LIMIT = 10
const SEEN_LIMIT = 200

export interface PartyFloatingGift {
  id: number
  message: PartyMessage
}

export interface PartyMediaEffect {
  fallbackUrl: string
  id: number
  kind: 'fullscreen' | 'normal'
  message: PartyMessage
  scene: 'entry' | 'gift'
  url: string
}

export interface PartyRoomEffectState {
  activeFloatingGifts: PartyFloatingGift[]
  currentEntry: PartyMessage | null
  currentFirstGift: PartyMessage | null
  currentMedia: PartyMediaEffect | null
}

export interface PartyEffectEnqueueOptions {
  media?: boolean
}

export interface PartyRoomEffectScheduler {
  clear: () => void
  dispose: () => void
  enqueue: (message: PartyMessage, options?: PartyEffectEnqueueOptions) => boolean
  enqueueGiftMedia: (message: PartyMessage, dedupeKey?: string) => boolean
  failMedia: (id: number) => void
  finishMedia: (id: number) => void
  setActive: (active: boolean) => void
  startMedia: (id: number) => void
  state: PartyRoomEffectState
}

function fullscreenUrl(value: string | undefined): string {
  const source = value?.trim() ?? ''
  const pathname = source.toLowerCase().split(/[?#]/u, 1)[0] ?? ''
  return pathname.endsWith('.svga') || pathname.endsWith('.mp4') ? source : ''
}

function imageUrl(value: string | undefined): string {
  const source = value?.trim() ?? ''
  const pathname = source.toLowerCase().split(/[?#]/u, 1)[0] ?? ''
  return /\.(?:avif|gif|jpe?g|png|webp)$/u.test(pathname) ||
    /^(?:blob:|data:image\/)/iu.test(source)
    ? source
    : ''
}

export function createPartyRoomEffectScheduler(): PartyRoomEffectScheduler {
  const state = shallowReactive<PartyRoomEffectState>({
    activeFloatingGifts: [],
    currentEntry: null,
    currentFirstGift: null,
    currentMedia: null,
  })
  const floatingQueue: PartyMessage[] = []
  const entryQueue: PartyMessage[] = []
  const firstGiftQueue: PartyMessage[] = []
  const mediaQueue: PartyMediaEffect[] = []
  const floatingTimers = new Map<number, number>()
  const seen = new Set<string>()
  let active = true
  let nextId = 0
  let floatingPumpTimer = 0
  let entryTimer = 0
  let firstGiftTimer = 0
  let firstGiftGapTimer = 0
  let mediaTimer = 0
  let mediaGapTimer = 0

  function remember(key: string): boolean {
    if (!key) return true
    if (seen.has(key)) return false
    seen.add(key)
    while (seen.size > SEEN_LIMIT) {
      const oldest = seen.values().next().value
      if (oldest === undefined) break
      seen.delete(oldest)
    }
    return true
  }

  function scheduleFloatingPump(delay = FLOATING_GIFT_STAGGER_MS): void {
    if (!active || floatingPumpTimer || !floatingQueue.length) return
    floatingPumpTimer = window.setTimeout(() => {
      floatingPumpTimer = 0
      pumpFloatingGift()
    }, delay)
  }

  function removeFloatingGift(id: number): void {
    window.clearTimeout(floatingTimers.get(id))
    floatingTimers.delete(id)
    state.activeFloatingGifts = state.activeFloatingGifts.filter((item) => item.id !== id)
    if (floatingQueue.length) pumpFloatingGift()
  }

  function pumpFloatingGift(): void {
    if (!active || state.activeFloatingGifts.length >= FLOATING_GIFT_LIMIT) return
    const message = floatingQueue.shift()
    if (!message) return
    const item = { id: (nextId += 1), message }
    state.activeFloatingGifts = [...state.activeFloatingGifts, item]
    floatingTimers.set(
      item.id,
      window.setTimeout(() => removeFloatingGift(item.id), FLOATING_GIFT_DURATION_MS),
    )
    if (floatingQueue.length && state.activeFloatingGifts.length < FLOATING_GIFT_LIMIT)
      scheduleFloatingPump()
  }

  function enqueueFloatingGift(message: PartyMessage): boolean {
    if (!remember(`floating:${message.id}`) || floatingQueue.length >= QUEUE_LIMIT) return false
    floatingQueue.push(message)
    if (!state.activeFloatingGifts.length && !floatingPumpTimer) pumpFloatingGift()
    else scheduleFloatingPump()
    return true
  }

  function playNextEntry(): void {
    if (!active || state.currentEntry || !entryQueue.length) return
    state.currentEntry = entryQueue.shift() ?? null
    if (!state.currentEntry) return
    entryTimer = window.setTimeout(() => {
      entryTimer = 0
      state.currentEntry = null
      playNextEntry()
    }, STATIC_ENTRY_DURATION_MS)
  }

  function enqueueEntry(message: PartyMessage): boolean {
    if (!remember(`entry:${message.id}`) || entryQueue.length >= QUEUE_LIMIT) return false
    entryQueue.push(message)
    playNextEntry()
    return true
  }

  function playNextFirstGift(): void {
    if (!active || state.currentFirstGift || !firstGiftQueue.length) return
    state.currentFirstGift = firstGiftQueue.shift() ?? null
    if (!state.currentFirstGift) return
    firstGiftTimer = window.setTimeout(() => {
      firstGiftTimer = 0
      state.currentFirstGift = null
      firstGiftGapTimer = window.setTimeout(() => {
        firstGiftGapTimer = 0
        playNextFirstGift()
      }, FIRST_GIFT_GAP_MS)
    }, FIRST_GIFT_DURATION_MS)
  }

  function enqueueFirstGift(message: PartyMessage): boolean {
    if (!remember(`first-gift:${message.id}`) || firstGiftQueue.length >= QUEUE_LIMIT) return false
    firstGiftQueue.push(message)
    playNextFirstGift()
    return true
  }

  function playNextMedia(): void {
    if (!active || state.currentMedia || !mediaQueue.length) return
    state.currentMedia = mediaQueue.shift() ?? null
    const current = state.currentMedia
    if (!current) return
    window.clearTimeout(mediaTimer)
    mediaTimer = window.setTimeout(
      () => finishMedia(current.id),
      current.kind === 'fullscreen' ? MEDIA_PREPARE_WATCHDOG_MS : NORMAL_GIFT_DURATION_MS,
    )
  }

  function enqueueMedia(message: PartyMessage, dedupeKey: string): boolean {
    if (!active || !remember(`media:${dedupeKey}`)) return false
    const presentation = message.presentation
    const scene = presentation?.kind === 'entry' ? 'entry' : 'gift'
    const effect = fullscreenUrl(message.effectUrl)
    const fallback = scene === 'gift' ? imageUrl(message.giftIconUrl) : ''
    const normal = effect ? '' : imageUrl(message.effectUrl) || fallback
    const url = effect || normal
    if (!url) return false
    const item: PartyMediaEffect = {
      fallbackUrl: effect ? fallback : '',
      id: (nextId += 1),
      kind: effect ? 'fullscreen' : 'normal',
      message,
      scene,
      url,
    }
    if (scene === 'entry' && presentation?.kind === 'entry') {
      const existingIndex = mediaQueue.findIndex(
        (candidate) =>
          candidate.scene === 'entry' &&
          candidate.message.presentation?.kind === 'entry' &&
          candidate.message.presentation.userId === presentation.userId,
      )
      if (existingIndex >= 0) {
        const existing = mediaQueue[existingIndex]
        const existingPriority =
          existing?.message.presentation?.kind === 'entry'
            ? existing.message.presentation.priority
            : 0
        if (existingPriority >= presentation.priority) return false
        mediaQueue.splice(existingIndex, 1, item)
      } else if (mediaQueue.length >= QUEUE_LIMIT) return false
      else mediaQueue.push(item)
    } else {
      if (mediaQueue.length >= QUEUE_LIMIT) return false
      mediaQueue.push(item)
    }
    if (effect)
      void preloadGiftEffect(effect, {
        decodeSvga: true,
        priority: 'critical',
        trigger: 'queue',
      }).catch(() => undefined)
    playNextMedia()
    return true
  }

  function finishMedia(id: number): void {
    if (state.currentMedia?.id !== id) return
    window.clearTimeout(mediaTimer)
    mediaTimer = 0
    state.currentMedia = null
    window.clearTimeout(mediaGapTimer)
    mediaGapTimer = window.setTimeout(() => {
      mediaGapTimer = 0
      playNextMedia()
    }, MEDIA_GAP_MS)
  }

  function failMedia(id: number): void {
    const current = state.currentMedia
    if (!current || current.id !== id) return
    if (current.kind === 'fullscreen' && current.fallbackUrl) {
      window.clearTimeout(mediaTimer)
      state.currentMedia = {
        ...current,
        fallbackUrl: '',
        kind: 'normal',
        url: current.fallbackUrl,
      }
      mediaTimer = window.setTimeout(() => finishMedia(id), NORMAL_GIFT_DURATION_MS)
      return
    }
    finishMedia(id)
  }

  function startMedia(id: number): void {
    const current = state.currentMedia
    if (!current || current.id !== id || current.kind !== 'fullscreen') return
    window.clearTimeout(mediaTimer)
    mediaTimer = window.setTimeout(() => finishMedia(id), MEDIA_PLAYBACK_WATCHDOG_MS)
  }

  function enqueue(message: PartyMessage, options: PartyEffectEnqueueOptions = {}): boolean {
    if (!active) return false
    const presentation = message.presentation
    if (presentation?.kind === 'first-gift') return enqueueFirstGift(message)
    if (message.type === 'gift') {
      const floated = enqueueFloatingGift(message)
      if (options.media !== false) enqueueMedia(message, message.id)
      return floated
    }
    if (presentation?.kind !== 'entry') return false
    return presentation.variant === 'vehicle'
      ? enqueueMedia(message, message.id)
      : enqueueEntry(message)
  }

  function enqueueGiftMedia(message: PartyMessage, dedupeKey = message.id): boolean {
    return enqueueMedia(message, dedupeKey)
  }

  function clear(): void {
    window.clearTimeout(floatingPumpTimer)
    window.clearTimeout(entryTimer)
    window.clearTimeout(firstGiftTimer)
    window.clearTimeout(firstGiftGapTimer)
    window.clearTimeout(mediaTimer)
    window.clearTimeout(mediaGapTimer)
    floatingPumpTimer = 0
    entryTimer = 0
    firstGiftTimer = 0
    firstGiftGapTimer = 0
    mediaTimer = 0
    mediaGapTimer = 0
    floatingTimers.forEach((timer) => window.clearTimeout(timer))
    floatingTimers.clear()
    floatingQueue.length = 0
    entryQueue.length = 0
    firstGiftQueue.length = 0
    mediaQueue.length = 0
    state.activeFloatingGifts = []
    state.currentEntry = null
    state.currentFirstGift = null
    state.currentMedia = null
  }

  function setActive(next: boolean): void {
    if (active === next) return
    active = next
    if (!active) clear()
  }

  function dispose(): void {
    active = false
    clear()
    seen.clear()
  }

  return {
    clear,
    dispose,
    enqueue,
    enqueueGiftMedia,
    failMedia,
    finishMedia,
    setActive,
    startMedia,
    state,
  }
}

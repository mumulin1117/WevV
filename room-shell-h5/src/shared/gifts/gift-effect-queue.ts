import { shallowReactive } from 'vue'
import { reportRuntimeMetric } from '@/core/observability/runtime'
import { preloadGiftEffect } from './gift-effect-assets'

export interface GiftEffectRequest {
  dedupeKey?: string
  fallbackUrl?: string
  fit?: 'contain' | 'cover'
  owner: string
  url: string
}

export interface GiftEffectItem {
  dedupeKey: string
  enqueuedAt: number
  fallbackUrl: string
  fit: 'contain' | 'cover'
  id: number
  kind: 'fullscreen' | 'normal'
  owner: string
  url: string
}

interface GiftEffectQueueState {
  current: GiftEffectItem | null
}

const PREPARE_WATCHDOG_MS = 15_000
const PLAYBACK_WATCHDOG_MS = 30_000
const QUEUE_GAP_MS = 220
const QUEUE_LIMIT = 10
const DEDUPE_TTL_MS = 90_000
const DEDUPE_LIMIT = 200

export const giftEffectQueueState = shallowReactive<GiftEffectQueueState>({
  current: null,
})

const pending: GiftEffectItem[] = []
const seen = new Map<string, number>()
let nextId = 0
let playbackTimer = 0
let queueGapTimer = 0

export function normalizeGiftEffectUrl(value: string): string {
  const url = value.trim()
  const pathname = url.toLowerCase().split(/[?#]/u, 1)[0] ?? ''
  return pathname.endsWith('.svga') || pathname.endsWith('.mp4') ? url : ''
}

function normalizeGiftImageUrl(value: string): string {
  const url = value.trim()
  const pathname = url.toLowerCase().split(/[?#]/u, 1)[0] ?? ''
  return /\.(?:avif|gif|jpe?g|png|webp)$/u.test(pathname) || /^(?:blob:|data:image\/)/iu.test(url)
    ? url
    : ''
}

function pruneSeen(now = Date.now()): void {
  for (const [key, timestamp] of seen) {
    if (now - timestamp > DEDUPE_TTL_MS) seen.delete(key)
  }
  while (seen.size > DEDUPE_LIMIT) {
    const oldest = seen.keys().next().value
    if (oldest === undefined) break
    seen.delete(oldest)
  }
}

function playNext(): void {
  if (giftEffectQueueState.current || !pending.length) return
  const item = pending.shift() ?? null
  giftEffectQueueState.current = item
  if (!item) return
  window.clearTimeout(playbackTimer)
  // 全屏资源需要先下载、解析并真正启动；准备时间不能侵占动画播放时间。
  const watchdogMs = item.kind === 'fullscreen' ? PREPARE_WATCHDOG_MS : PLAYBACK_WATCHDOG_MS
  playbackTimer = window.setTimeout(() => finishGiftEffect(item.id), watchdogMs)
}

export function enqueueGiftEffect(request: GiftEffectRequest): boolean {
  const fullscreenUrl = normalizeGiftEffectUrl(request.url)
  const fallbackUrl = request.fallbackUrl?.trim() ?? ''
  const url = fullscreenUrl || normalizeGiftImageUrl(request.url) || fallbackUrl
  if (!url) return false
  const dedupeKey = request.dedupeKey?.trim() ?? ''
  pruneSeen()
  if (dedupeKey && seen.has(dedupeKey)) return false
  const remainingCapacity = QUEUE_LIMIT - (giftEffectQueueState.current ? 1 : 0)
  if (pending.length >= remainingCapacity) return false
  if (dedupeKey) seen.set(dedupeKey, Date.now())
  pending.push({
    dedupeKey,
    enqueuedAt: Date.now(),
    fallbackUrl,
    fit: request.fit ?? 'contain',
    id: (nextId += 1),
    kind: fullscreenUrl ? 'fullscreen' : 'normal',
    owner: request.owner,
    url,
  })
  if (fullscreenUrl)
    void preloadGiftEffect(fullscreenUrl, {
      decodeSvga: true,
      priority: 'critical',
      trigger: 'queue',
    }).catch(() => undefined)
  playNext()
  return true
}

export function startGiftEffect(id: number): void {
  const current = giftEffectQueueState.current
  if (!current || current.id !== id || current.kind !== 'fullscreen') return
  window.clearTimeout(playbackTimer)
  playbackTimer = window.setTimeout(() => finishGiftEffect(id), PLAYBACK_WATCHDOG_MS)
  reportRuntimeMetric('gift.effect.queue-start-latency', Date.now() - current.enqueuedAt, {
    kind: current.kind,
    scene: current.owner.split(':', 1)[0] ?? 'unknown',
  })
}

export function fallbackGiftEffect(id: number): boolean {
  const current = giftEffectQueueState.current
  if (!current || current.id !== id || !current.fallbackUrl || current.url === current.fallbackUrl)
    return false
  window.clearTimeout(playbackTimer)
  giftEffectQueueState.current = {
    ...current,
    fallbackUrl: '',
    kind: 'normal',
    url: current.fallbackUrl,
  }
  playbackTimer = window.setTimeout(() => finishGiftEffect(id), PLAYBACK_WATCHDOG_MS)
  return true
}

export function finishGiftEffect(id: number): void {
  if (giftEffectQueueState.current?.id !== id) return
  window.clearTimeout(playbackTimer)
  playbackTimer = 0
  giftEffectQueueState.current = null
  window.clearTimeout(queueGapTimer)
  queueGapTimer = window.setTimeout(() => {
    queueGapTimer = 0
    playNext()
  }, QUEUE_GAP_MS)
}

export function clearGiftEffects(owner?: string): void {
  for (let index = pending.length - 1; index >= 0; index -= 1) {
    if (!owner || pending[index]?.owner === owner) pending.splice(index, 1)
  }
  if (owner && giftEffectQueueState.current?.owner !== owner) return
  window.clearTimeout(playbackTimer)
  window.clearTimeout(queueGapTimer)
  playbackTimer = 0
  queueGapTimer = 0
  giftEffectQueueState.current = null
  if (owner) playNext()
}

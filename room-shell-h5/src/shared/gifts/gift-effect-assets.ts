import { decodeSvgaSource, loadSvgaRuntime } from '@/core/media/svga-runtime'
import { reportRuntimeMetric } from '@/core/observability/runtime'
import type { VideoEntity } from 'svgaplayerweb'
import type { yyEva as createEvaPlayer } from 'yyeva'

interface EvaModule {
  yyEva: typeof createEvaPlayer
}

export type GiftEffectAssetPriority = 'critical' | 'idle' | 'visible'
export type GiftEffectAssetTrigger =
  'account' | 'panel' | 'playback' | 'queue' | 'selection' | 'send'

export type PreparedGiftEffectAsset =
  | {
      file: File
      kind: 'mp4'
      url: string
    }
  | {
      file: File
      kind: 'svga'
      url: string
      video: VideoEntity
    }

export interface PreloadGiftEffectOptions {
  decodeSvga?: boolean
  priority?: GiftEffectAssetPriority
  trigger: GiftEffectAssetTrigger
}

export interface PreloadGiftEffectsOptions extends PreloadGiftEffectOptions {
  limit?: number
}

export type CachedGiftEffectAsset =
  | {
      file: File
      kind: 'mp4'
      size: number
      url: string
    }
  | {
      file: File
      kind: 'svga'
      size: number
      url: string
    }

interface PreloadTask {
  controller: AbortController
  decodeSvga: boolean
  priority: GiftEffectAssetPriority
  promise: Promise<CachedGiftEffectAsset | PreparedGiftEffectAsset | null>
  reject: (cause: unknown) => void
  resolve: (asset: CachedGiftEffectAsset | PreparedGiftEffectAsset | null) => void
  running: boolean
  sequence: number
  trigger: GiftEffectAssetTrigger
  url: string
}

interface GiftEffectAssetServiceOptions {
  decodedSvgaLimit?: number
  failureCooldownMs?: number
  fetcher?: typeof fetch
  maxConcurrent?: number
  rawCacheBytes?: number
}

const DEFAULT_MAX_CONCURRENT = 2
const DEFAULT_RAW_CACHE_BYTES = 24 * 1024 * 1024
const DEFAULT_DECODED_SVGA_LIMIT = 3
const DEFAULT_FAILURE_COOLDOWN_MS = 30_000
const PRIORITY_WEIGHT: Record<GiftEffectAssetPriority, number> = {
  critical: 3,
  visible: 2,
  idle: 1,
}

let evaModulePromise: Promise<EvaModule> | null = null

export function loadEvaEffectRuntime(): Promise<EvaModule> {
  evaModulePromise ??= import('yyeva')
  return evaModulePromise
}

export async function warmGiftEffectRuntime(): Promise<void> {
  await Promise.allSettled([loadSvgaRuntime(), loadEvaEffectRuntime()])
}

function effectKind(url: string): PreparedGiftEffectAsset['kind'] | null {
  const pathname = url.toLowerCase().split(/[?#]/u, 1)[0] ?? ''
  if (pathname.endsWith('.svga')) return 'svga'
  if (pathname.endsWith('.mp4')) return 'mp4'
  return null
}

function normalizeEffectUrl(value: string): string {
  const url = value.trim()
  if (!url || !effectKind(url)) return ''
  try {
    return new URL(url, document.baseURI).href
  } catch {
    return url
  }
}

function canFetchEffectSource(url: string): boolean {
  try {
    const protocol = new URL(url, document.baseURI).protocol
    return protocol === 'http:' || protocol === 'https:'
  } catch {
    return false
  }
}

function fileName(url: string, kind: PreparedGiftEffectAsset['kind']): string {
  try {
    const name = new URL(url, document.baseURI).pathname.split('/').pop()?.trim()
    if (name) return name
  } catch {
    // Keep a stable extension when a legacy URL cannot be parsed by URL().
  }
  return `gift-effect.${kind}`
}

function canPreload(priority: GiftEffectAssetPriority): boolean {
  if (priority === 'critical') return true
  if (!navigator.onLine || document.visibilityState === 'hidden') return false
  const connection = (
    navigator as Navigator & {
      connection?: { effectiveType?: string; saveData?: boolean }
    }
  ).connection
  return !connection?.saveData && connection?.effectiveType !== '2g'
}

function isAbortError(cause: unknown): boolean {
  return cause instanceof DOMException && cause.name === 'AbortError'
}

export class GiftEffectAssetService {
  private readonly decodedSvga = new Map<string, PreparedGiftEffectAsset & { kind: 'svga' }>()
  private readonly decodedSvgaLimit: number
  private readonly decodedSvgaPromises = new Map<
    string,
    Promise<PreparedGiftEffectAsset & { kind: 'svga' }>
  >()
  private readonly failureCooldownMs: number
  private readonly failureUntil = new Map<string, number>()
  private readonly fetcher: typeof fetch
  private readonly maxConcurrent: number
  private readonly pending: PreloadTask[] = []
  private readonly rawAssets = new Map<string, CachedGiftEffectAsset>()
  private readonly rawCacheBytes: number
  private readonly tasks = new Map<string, PreloadTask>()
  private activeCount = 0
  private generation = 0
  private rawBytes = 0
  private sequence = 0

  constructor(options: GiftEffectAssetServiceOptions = {}) {
    this.decodedSvgaLimit = options.decodedSvgaLimit ?? DEFAULT_DECODED_SVGA_LIMIT
    this.failureCooldownMs = options.failureCooldownMs ?? DEFAULT_FAILURE_COOLDOWN_MS
    this.fetcher = options.fetcher ?? fetch.bind(globalThis)
    this.maxConcurrent = options.maxConcurrent ?? DEFAULT_MAX_CONCURRENT
    this.rawCacheBytes = options.rawCacheBytes ?? DEFAULT_RAW_CACHE_BYTES
  }

  preload(
    value: string,
    options: PreloadGiftEffectOptions,
  ): Promise<CachedGiftEffectAsset | PreparedGiftEffectAsset | null> {
    const url = normalizeEffectUrl(value)
    if (!url || !canFetchEffectSource(url) || !canPreload(options.priority ?? 'visible'))
      return Promise.resolve(null)
    const priority = options.priority ?? 'visible'
    const decodeSvga = Boolean(options.decodeSvga && effectKind(url) === 'svga')
    const ready = this.readReady(url, decodeSvga)
    if (ready) {
      this.report('hit', options.trigger, ready.kind, 0)
      return Promise.resolve(ready)
    }

    const existing = this.tasks.get(url)
    if (existing) {
      if (PRIORITY_WEIGHT[priority] > PRIORITY_WEIGHT[existing.priority])
        existing.priority = priority
      existing.decodeSvga ||= decodeSvga
      existing.trigger = options.trigger
      this.sortPending()
      this.report('deduped', options.trigger, effectKind(url) ?? 'unknown', 0)
      if (!decodeSvga) return existing.promise
      return existing.promise.then((asset) => {
        if (!asset || asset.kind !== 'svga' || 'video' in asset) return asset
        return this.decodeSvga(asset)
      })
    }

    if (priority !== 'critical' && (this.failureUntil.get(url) ?? 0) > Date.now())
      return Promise.resolve(null)

    let resolveTask!: PreloadTask['resolve']
    let rejectTask!: PreloadTask['reject']
    const promise = new Promise<CachedGiftEffectAsset | PreparedGiftEffectAsset | null>(
      (resolve, reject) => {
        resolveTask = resolve
        rejectTask = reject
      },
    )
    const task: PreloadTask = {
      controller: new AbortController(),
      decodeSvga,
      priority,
      promise,
      reject: rejectTask,
      resolve: resolveTask,
      running: false,
      sequence: (this.sequence += 1),
      trigger: options.trigger,
      url,
    }
    this.tasks.set(url, task)
    this.pending.push(task)
    this.sortPending()
    this.drain()
    return promise
  }

  preloadMany(values: readonly string[], options: PreloadGiftEffectsOptions): Promise<void> {
    const limit = Math.max(0, Math.floor(options.limit ?? values.length))
    const urls = [...new Set(values.map(normalizeEffectUrl).filter(Boolean))].slice(0, limit)
    return Promise.allSettled(urls.map((url) => this.preload(url, options))).then(() => undefined)
  }

  async acquire(
    value: string,
    trigger: GiftEffectAssetTrigger = 'playback',
  ): Promise<PreparedGiftEffectAsset | null> {
    const url = normalizeEffectUrl(value)
    if (!url) return null
    const ready = this.readReady(url, true)
    if (ready?.kind === 'mp4') return ready
    if (ready?.kind === 'svga' && 'video' in ready) return ready
    try {
      const asset = await this.preload(url, {
        decodeSvga: true,
        priority: 'critical',
        trigger,
      })
      if (!asset) return null
      if (asset.kind === 'mp4') return asset
      return 'video' in asset ? asset : this.decodeSvga(asset)
    } catch {
      return null
    }
  }

  clearMemory(): void {
    this.generation += 1
    for (const task of this.tasks.values()) {
      task.controller.abort('gift-effect-cache-cleared')
      if (!task.running) task.resolve(null)
    }
    this.tasks.clear()
    this.pending.splice(0)
    this.rawAssets.clear()
    this.decodedSvga.clear()
    this.decodedSvgaPromises.clear()
    this.failureUntil.clear()
    this.rawBytes = 0
  }

  private readReady(
    url: string,
    decodeSvga: boolean,
  ): CachedGiftEffectAsset | PreparedGiftEffectAsset | null {
    const decoded = this.decodedSvga.get(url)
    if (decoded) {
      this.decodedSvga.delete(url)
      this.decodedSvga.set(url, decoded)
      return decoded
    }
    const raw = this.rawAssets.get(url)
    if (!raw || (decodeSvga && raw.kind === 'svga')) return null
    this.rawAssets.delete(url)
    this.rawAssets.set(url, raw)
    return raw
  }

  private sortPending(): void {
    this.pending.sort(
      (left, right) =>
        PRIORITY_WEIGHT[right.priority] - PRIORITY_WEIGHT[left.priority] ||
        left.sequence - right.sequence,
    )
  }

  private drain(): void {
    while (this.activeCount < this.maxConcurrent && this.pending.length) {
      const task = this.pending.shift()
      if (!task || task.controller.signal.aborted) continue
      task.running = true
      this.activeCount += 1
      const generation = this.generation
      void this.run(task, generation)
        .then(task.resolve, task.reject)
        .finally(() => {
          this.activeCount -= 1
          if (this.tasks.get(task.url) === task) this.tasks.delete(task.url)
          this.drain()
        })
    }
  }

  private async run(
    task: PreloadTask,
    generation: number,
  ): Promise<CachedGiftEffectAsset | PreparedGiftEffectAsset | null> {
    const startedAt = performance.now()
    const kind = effectKind(task.url)
    if (!kind) return null
    try {
      const cachedRaw = this.rawAssets.get(task.url)
      let raw: CachedGiftEffectAsset
      if (cachedRaw) raw = cachedRaw
      else {
        const response = await this.fetcher(task.url, {
          cache: 'force-cache',
          credentials: 'same-origin',
          signal: task.controller.signal,
        })
        if (!response.ok) throw new Error(`GIFT_EFFECT_HTTP_${response.status}`)
        const blob = await response.blob()
        if (task.controller.signal.aborted || generation !== this.generation) return null
        const file = new File([blob], fileName(task.url, kind), {
          type: blob.type || (kind === 'mp4' ? 'video/mp4' : 'application/octet-stream'),
        })
        raw =
          kind === 'mp4'
            ? { file, kind: 'mp4', size: file.size, url: task.url }
            : { file, kind: 'svga', size: file.size, url: task.url }
        this.cacheRaw(raw)
      }

      let result: CachedGiftEffectAsset | PreparedGiftEffectAsset = raw
      if (kind === 'svga' && task.decodeSvga) result = await this.decodeSvga(raw)
      if (task.controller.signal.aborted || generation !== this.generation) return null
      this.failureUntil.delete(task.url)
      this.report('ready', task.trigger, kind, performance.now() - startedAt, raw.size)
      return result
    } catch (cause) {
      if (!task.controller.signal.aborted && !isAbortError(cause)) {
        this.failureUntil.set(task.url, Date.now() + this.failureCooldownMs)
        this.report('failed', task.trigger, kind, performance.now() - startedAt)
      }
      throw cause
    }
  }

  private cacheRaw(asset: CachedGiftEffectAsset): void {
    const existing = this.rawAssets.get(asset.url)
    if (existing) this.rawBytes -= existing.size
    this.rawAssets.delete(asset.url)
    if (asset.size > this.rawCacheBytes) return
    this.rawAssets.set(asset.url, asset)
    this.rawBytes += asset.size
    while (this.rawBytes > this.rawCacheBytes) {
      const oldestKey = this.rawAssets.keys().next().value
      if (oldestKey === undefined) break
      const oldest = this.rawAssets.get(oldestKey)
      this.rawAssets.delete(oldestKey)
      this.rawBytes -= oldest?.size ?? 0
    }
    reportRuntimeMetric('gift.effect.cache-bytes', this.rawBytes)
  }

  private async decodeSvga(
    raw: CachedGiftEffectAsset,
  ): Promise<PreparedGiftEffectAsset & { kind: 'svga' }> {
    const cached = this.decodedSvga.get(raw.url)
    if (cached) return cached
    const existing = this.decodedSvgaPromises.get(raw.url)
    if (existing) return existing
    const generation = this.generation
    const task = decodeSvgaSource(raw.file)
      .then((video) => {
        const asset = { file: raw.file, kind: 'svga' as const, url: raw.url, video }
        if (generation !== this.generation) return asset
        this.decodedSvga.set(raw.url, asset)
        while (this.decodedSvga.size > this.decodedSvgaLimit) {
          const oldestKey = this.decodedSvga.keys().next().value
          if (oldestKey === undefined) break
          this.decodedSvga.delete(oldestKey)
        }
        return asset
      })
      .finally(() => {
        if (this.decodedSvgaPromises.get(raw.url) === task) this.decodedSvgaPromises.delete(raw.url)
      })
    this.decodedSvgaPromises.set(raw.url, task)
    return task
  }

  private report(
    action: string,
    trigger: GiftEffectAssetTrigger,
    kind: string,
    durationMs: number,
    bytes?: number,
  ): void {
    reportRuntimeMetric('gift.effect.preload-duration', Math.round(durationMs), {
      action,
      bytes,
      kind,
      trigger,
    })
  }
}

export const giftEffectAssetService = new GiftEffectAssetService()

export function preloadGiftEffect(
  url: string,
  options: PreloadGiftEffectOptions,
): Promise<CachedGiftEffectAsset | PreparedGiftEffectAsset | null> {
  return giftEffectAssetService.preload(url, options)
}

export function preloadGiftEffects(
  urls: readonly string[],
  options: PreloadGiftEffectsOptions,
): Promise<void> {
  return giftEffectAssetService.preloadMany(urls, options)
}

export function acquireGiftEffectAsset(
  url: string,
  trigger?: GiftEffectAssetTrigger,
): Promise<PreparedGiftEffectAsset | null> {
  return giftEffectAssetService.acquire(url, trigger)
}

export function clearGiftEffectAssetMemory(): void {
  giftEffectAssetService.clearMemory()
}

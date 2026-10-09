import { reportRuntimeMetric } from '@/core/observability/runtime'
import type { Parser as SvgaParser, Player as SvgaPlayer, VideoEntity } from 'svgaplayerweb'

export interface SvgaRuntime {
  Parser: typeof SvgaParser
  Player: typeof SvgaPlayer
}

export interface DecodeSvgaSourceOptions {
  timeoutMs?: number
}

const DEFAULT_DECODE_TIMEOUT_MS = 15_000
let runtimePromise: Promise<SvgaRuntime> | null = null

export function loadSvgaRuntime(): Promise<SvgaRuntime> {
  runtimePromise ??= import('svgaplayerweb')
  return runtimePromise
}

function isFileSource(source: string | File): source is File {
  return typeof File !== 'undefined' && source instanceof File
}

function decodeError(cause: unknown): Error {
  return cause instanceof Error ? cause : new Error('SVGA_DECODE_FAILED')
}

export async function decodeSvgaSource(
  source: string | File,
  options: DecodeSvgaSourceOptions = {},
): Promise<VideoEntity> {
  const { Parser } = await loadSvgaRuntime()
  const fileSource = isFileSource(source)
  const parserSource = fileSource ? URL.createObjectURL(source) : source
  const timeoutMs = Math.max(1, options.timeoutMs ?? DEFAULT_DECODE_TIMEOUT_MS)
  const startedAt = performance.now()

  return new Promise<VideoEntity>((resolve, reject) => {
    let settled = false
    const cleanup = (): void => {
      clearTimeout(timeoutId)
      if (fileSource) URL.revokeObjectURL(parserSource)
    }
    const finish = (outcome: 'failed' | 'ready' | 'timeout', callback: () => void): void => {
      if (settled) return
      settled = true
      cleanup()
      reportRuntimeMetric('svga.decode-duration', Math.round(performance.now() - startedAt), {
        outcome,
        source: fileSource ? 'object-url' : 'direct-url',
      })
      callback()
    }
    const timeoutId = setTimeout(() => {
      finish('timeout', () => reject(new Error('SVGA_DECODE_TIMEOUT')))
    }, timeoutMs)

    try {
      new Parser().load(
        parserSource,
        (video) => finish('ready', () => resolve(video)),
        (cause) => finish('failed', () => reject(decodeError(cause))),
      )
    } catch (cause) {
      finish('failed', () => reject(decodeError(cause)))
    }
  })
}

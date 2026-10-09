import type { VideoEntity } from 'svgaplayerweb'
import { decodeSvgaSource } from './svga-runtime'

const DECODED_VIDEO_LIMIT = 6
const decodedVideos = new Map<string, VideoEntity>()
const pendingVideos = new Map<string, Promise<VideoEntity>>()

export function isSvgaSource(value: string): boolean {
  const source = value.trim()
  if (!source) return false
  try {
    return new URL(source, document.baseURI).pathname.toLowerCase().endsWith('.svga')
  } catch {
    return (source.toLowerCase().split(/[?#]/u, 1)[0] ?? '').endsWith('.svga')
  }
}

function sourceFileName(url: string): string {
  try {
    return new URL(url, document.baseURI).pathname.split('/').pop()?.trim() || 'avatar-frame.svga'
  } catch {
    return 'avatar-frame.svga'
  }
}

function canFetchSource(url: string): boolean {
  try {
    const protocol = new URL(url, document.baseURI).protocol
    return protocol === 'http:' || protocol === 'https:'
  } catch {
    return false
  }
}

async function parserSource(url: string): Promise<string | File> {
  if (!canFetchSource(url)) return url
  const response = await fetch(url, { cache: 'force-cache', credentials: 'same-origin' })
  if (!response.ok) throw new Error(`SVGA_HTTP_${response.status}`)
  const blob = await response.blob()
  return new File([blob], sourceFileName(url), {
    type: blob.type || 'application/octet-stream',
  })
}

async function decodeVideo(url: string): Promise<VideoEntity> {
  const source = await parserSource(url)
  return decodeSvgaSource(source)
}

export function loadSvgaVideo(value: string): Promise<VideoEntity> {
  const url = value.trim()
  if (!url || !isSvgaSource(url)) return Promise.reject(new Error('Invalid SVGA source.'))
  const cached = decodedVideos.get(url)
  if (cached) {
    decodedVideos.delete(url)
    decodedVideos.set(url, cached)
    return Promise.resolve(cached)
  }
  const pending = pendingVideos.get(url)
  if (pending) return pending

  const task = decodeVideo(url)
    .then((video) => {
      decodedVideos.set(url, video)
      while (decodedVideos.size > DECODED_VIDEO_LIMIT) {
        const oldest = decodedVideos.keys().next().value
        if (oldest === undefined) break
        decodedVideos.delete(oldest)
      }
      return video
    })
    .finally(() => {
      if (pendingVideos.get(url) === task) pendingVideos.delete(url)
    })
  pendingVideos.set(url, task)
  return task
}

export function resetSvgaVideoCacheForTests(): void {
  decodedVideos.clear()
  pendingVideos.clear()
}

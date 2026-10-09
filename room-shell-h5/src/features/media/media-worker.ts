/// <reference lib="webworker" />
import type { ImageProcessRequest, ImageProcessResult, WorkerFailure } from './media-worker.types'

declare const self: DedicatedWorkerGlobalScope

async function digest(blob: Blob): Promise<string> {
  const buffer = await blob.arrayBuffer()
  const hash = await crypto.subtle.digest('SHA-256', buffer)
  return [...new Uint8Array(hash)].map((value) => value.toString(16).padStart(2, '0')).join('')
}

async function processImage(request: ImageProcessRequest): Promise<ImageProcessResult> {
  const bitmap = await createImageBitmap(request.file, { imageOrientation: 'from-image' })
  const scale = Math.min(1, request.maxDimension / Math.max(bitmap.width, bitmap.height))
  const width = Math.max(1, Math.round(bitmap.width * scale))
  const height = Math.max(1, Math.round(bitmap.height * scale))
  const canvas = new OffscreenCanvas(width, height)
  const context = canvas.getContext('2d', { alpha: false })
  if (!context) throw new Error('Canvas is unavailable.')
  context.drawImage(bitmap, 0, 0, width, height)
  bitmap.close()
  const blob = await canvas.convertToBlob({ type: 'image/jpeg', quality: request.quality })
  return { blob, hash: await digest(blob), height, id: request.id, width }
}

self.addEventListener('message', (event: MessageEvent<ImageProcessRequest>) => {
  void processImage(event.data)
    .then((result) => self.postMessage(result))
    .catch((cause: unknown) => {
      const failure: WorkerFailure = {
        error: cause instanceof Error ? cause.message : 'Media processing failed.',
        id: event.data.id,
      }
      self.postMessage(failure)
    })
})

export {}

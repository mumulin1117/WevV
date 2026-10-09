import { createId } from '@/shared/id'
import type {
  ImageProcessRequest,
  ImageProcessResult,
  MediaWorkerResponse,
} from './media-worker.types'

export interface UploadProgress {
  loaded: number
  total: number
}

export interface UploadAdapter {
  cancel: (taskId: string) => void
  upload: (
    taskId: string,
    file: Blob,
    onProgress: (progress: UploadProgress) => void,
  ) => Promise<{ url: string }>
}

export interface ImageProcessOptions {
  maxDimension?: number
  quality?: number
}

const DEFAULT_MAX_DIMENSION = 1280
const DEFAULT_QUALITY = 0.82
const IMAGE_FILE_EXTENSION = /\.(?:avif|heic|heif|jpe?g|png|webp)$/iu
const MEDIA_WORKER_TIMEOUT_MS = 10_000

function isImageFile(file: File): boolean {
  return file.type.startsWith('image/') || IMAGE_FILE_EXTENSION.test(file.name)
}

async function digest(blob: Blob): Promise<string> {
  const buffer = await blob.arrayBuffer()
  const hash = await crypto.subtle.digest('SHA-256', buffer)
  return [...new Uint8Array(hash)].map((value) => value.toString(16).padStart(2, '0')).join('')
}

function loadImage(file: File): Promise<HTMLImageElement> {
  return new Promise((resolve, reject) => {
    const objectUrl = URL.createObjectURL(file)
    const image = new Image()
    const release = (): void => URL.revokeObjectURL(objectUrl)
    image.addEventListener(
      'load',
      () => {
        release()
        resolve(image)
      },
      { once: true },
    )
    image.addEventListener(
      'error',
      () => {
        release()
        reject(new Error('The selected image cannot be decoded.'))
      },
      { once: true },
    )
    image.src = objectUrl
  })
}

function canvasToBlob(canvas: HTMLCanvasElement, quality: number): Promise<Blob> {
  return new Promise((resolve, reject) => {
    canvas.toBlob(
      (blob) => {
        if (blob) resolve(blob)
        else reject(new Error('Failed to prepare the selected image.'))
      },
      'image/jpeg',
      quality,
    )
  })
}

async function processImageOnMainThread(request: ImageProcessRequest): Promise<ImageProcessResult> {
  const image = await loadImage(request.file)
  const sourceWidth = image.naturalWidth || image.width
  const sourceHeight = image.naturalHeight || image.height
  if (!sourceWidth || !sourceHeight) throw new Error('The selected image has invalid dimensions.')

  const scale = Math.min(1, request.maxDimension / Math.max(sourceWidth, sourceHeight))
  const width = Math.max(1, Math.round(sourceWidth * scale))
  const height = Math.max(1, Math.round(sourceHeight * scale))
  const canvas = document.createElement('canvas')
  canvas.width = width
  canvas.height = height
  const context = canvas.getContext('2d', { alpha: false })
  if (!context) throw new Error('Image processing is not available on this device.')
  context.drawImage(image, 0, 0, width, height)
  const blob = await canvasToBlob(canvas, request.quality)
  canvas.width = 1
  canvas.height = 1
  return { blob, hash: await digest(blob), height, id: request.id, width }
}

export class MediaPipeline {
  private disposed = false
  private worker?: Worker
  private workerUnavailable = false
  private readonly pending = new Map<
    string,
    {
      reject: (error: Error) => void
      resolve: (result: ImageProcessResult) => void
      timeout: ReturnType<typeof setTimeout>
    }
  >()

  async processImage(file: File, options: ImageProcessOptions = {}): Promise<ImageProcessResult> {
    if (!isImageFile(file)) throw new Error('Choose an image file.')
    if (this.disposed) throw new Error('Media processing was cancelled.')
    const request: ImageProcessRequest = {
      file,
      id: createId('media'),
      maxDimension: options.maxDimension ?? DEFAULT_MAX_DIMENSION,
      quality: options.quality ?? DEFAULT_QUALITY,
    }
    if (!this.workerUnavailable) {
      try {
        return await this.processImageInWorker(request)
      } catch (error) {
        if (this.disposed) throw error
        this.disableWorker(new Error('Media worker is unavailable.'))
      }
    }
    return await processImageOnMainThread(request)
  }

  dispose(): void {
    this.disposed = true
    this.disableWorker(new Error('Media processing was cancelled.'))
  }

  private disableWorker(error: Error): void {
    this.workerUnavailable = true
    this.worker?.terminate()
    this.worker = undefined
    for (const task of this.pending.values()) {
      clearTimeout(task.timeout)
      task.reject(error)
    }
    this.pending.clear()
  }

  private processImageInWorker(request: ImageProcessRequest): Promise<ImageProcessResult> {
    return new Promise((resolve, reject) => {
      const timeout = setTimeout(() => {
        this.pending.delete(request.id)
        reject(new Error('Media worker timed out.'))
      }, MEDIA_WORKER_TIMEOUT_MS)
      this.pending.set(request.id, { reject, resolve, timeout })
      try {
        this.ensureWorker().postMessage({
          ...request,
          file: request.file,
        })
      } catch (error) {
        clearTimeout(timeout)
        this.pending.delete(request.id)
        reject(error instanceof Error ? error : new Error('Media worker is unavailable.'))
      }
    })
  }

  private ensureWorker(): Worker {
    if (this.worker) return this.worker
    this.worker = new Worker(new URL('./media-worker.ts', import.meta.url), { type: 'module' })
    this.worker.addEventListener('message', (event: MessageEvent<MediaWorkerResponse>) => {
      const task = this.pending.get(event.data.id)
      if (!task) return
      clearTimeout(task.timeout)
      this.pending.delete(event.data.id)
      if ('error' in event.data) task.reject(new Error(event.data.error))
      else task.resolve(event.data)
    })
    this.worker.addEventListener('error', () => {
      this.disableWorker(new Error('Media worker crashed.'))
    })
    return this.worker
  }
}

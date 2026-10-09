export interface ImageProcessRequest {
  id: string
  file: File
  maxDimension: number
  quality: number
}

export interface ImageProcessResult {
  blob: Blob
  hash: string
  height: number
  id: string
  width: number
}

export interface WorkerFailure {
  error: string
  id: string
}

export type MediaWorkerResponse = ImageProcessResult | WorkerFailure

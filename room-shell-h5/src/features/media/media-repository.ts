import { z } from 'zod'
import { getApiClient } from '@/core/auth/runtime'
import { useSessionStore } from '@/main/stores/session'

const ossParameterSchema = z.object({
  accessid: z.string().min(1),
  cdnUrl: z
    .string()
    .nullish()
    .transform((value) => value?.trim() ?? ''),
  host: z.url(),
  policy: z.string().min(1),
  signature: z.string().min(1),
})

function objectKey(extension: string): string {
  const session = useSessionStore()
  const accountId = session.user?.id.replace(/[^\w.-]/gu, '') || '00000000'
  const date = new Date()
  const dateSegment = `${date.getFullYear()}${String(date.getMonth() + 1).padStart(2, '0')}${String(date.getDate()).padStart(2, '0')}`
  const id = crypto.randomUUID().replaceAll('-', '').toLowerCase()
  return `${accountId}/${dateSegment}/${id}.${extension}`
}

function audioExtensionFor(blob: Blob): string | null {
  const byType: Record<string, string> = {
    'audio/aac': 'aac',
    'audio/flac': 'flac',
    'audio/mp4': 'm4a',
    'audio/mpeg': 'mp3',
    'audio/ogg': 'ogg',
    'audio/wav': 'wav',
    'audio/webm': 'webm',
    'audio/x-m4a': 'm4a',
    'audio/x-wav': 'wav',
  }
  if (byType[blob.type]) return byType[blob.type]
  const name = typeof File !== 'undefined' && blob instanceof File ? blob.name : ''
  const extension = name.match(/\.([a-z0-9]+)$/iu)?.[1]?.toLowerCase() ?? ''
  return ['aac', 'flac', 'm4a', 'mp3', 'ogg', 'wav', 'webm'].includes(extension) ? extension : null
}

function extensionFor(blob: Blob): string {
  const audioExtension = audioExtensionFor(blob)
  if (audioExtension) return audioExtension
  if (blob.type === 'image/png') return 'png'
  if (blob.type === 'image/webp') return 'webp'
  return 'jpg'
}

class MediaRepository {
  async uploadImage(blob: Blob, signal?: AbortSignal): Promise<string> {
    return await this.upload(blob, signal)
  }

  async uploadAudio(blob: Blob, signal?: AbortSignal): Promise<string> {
    if (!audioExtensionFor(blob))
      throw new Error('Select an MP3, M4A, AAC, WAV, OGG, WebM, or FLAC audio file.')
    return await this.upload(blob, signal)
  }

  private async upload(blob: Blob, signal?: AbortSignal): Promise<string> {
    const api = getApiClient()
    const parameter = await api.request({
      authMode: 'required',
      data: {},
      method: 'POST',
      schema: ossParameterSchema,
      signal,
      url: '/_v2/user/ossParam',
    })
    const extension = extensionFor(blob)
    const key = objectKey(extension)
    const form = new FormData()
    form.append('key', key)
    form.append('policy', parameter.policy)
    form.append('OSSAccessKeyId', parameter.accessid)
    form.append('Signature', parameter.signature)
    form.append('success_action_status', '200')
    form.append('file', blob, `upload.${extension}`)
    const response = await fetch(parameter.host, { body: form, method: 'POST', signal })
    if (!response.ok) throw new Error(`Media upload failed (${response.status}).`)
    return `${(parameter.cdnUrl || parameter.host).replace(/\/$/u, '')}/${key}`
  }
}

let repository: MediaRepository | undefined

export function getMediaRepository(): MediaRepository {
  repository ??= new MediaRepository()
  return repository
}

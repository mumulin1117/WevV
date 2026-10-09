import { getApiClient } from '@/core/auth/runtime'
import { getMediaRepository } from '@/features/media/media-repository'
import type { ReportPayload } from './contracts'

class SafetyReportRepository {
  private readonly api = getApiClient()
  readonly requiresTarget = true

  async uploadEvidence(blob: Blob, signal?: AbortSignal): Promise<string> {
    return await getMediaRepository().uploadImage(blob, signal)
  }

  async submit(payload: ReportPayload, signal?: AbortSignal): Promise<void> {
    await this.api.request({
      authMode: 'required',
      data: {
        email: payload.email || undefined,
        feedbackType: payload.reason,
        pics: payload.pictureUrls.length ? payload.pictureUrls.slice(0, 3) : undefined,
        roomId:
          payload.source === 'live' || payload.source === 'party' ? payload.roomId : undefined,
        suggestion: payload.suggestion || undefined,
        targetUserId: payload.targetUserId,
      },
      method: 'POST',
      signal,
      url: '/_v2/feedback/save',
    })
  }
}

let repository: SafetyReportRepository | undefined

export function getSafetyReportRepository(): SafetyReportRepository {
  repository ??= new SafetyReportRepository()
  return repository
}

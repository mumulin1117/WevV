export const REPORT_REASONS = ['SPAM', 'NUDITY', 'HARASS', 'FRAUD', 'UNDERAGE', 'OTHER'] as const

export type ReportReason = (typeof REPORT_REASONS)[number]
export type ReportSource = 'live' | 'messages' | 'moment' | 'party' | 'profile'

export interface ReportContext {
  roomId?: string
  source: ReportSource
  targetUserId?: string
}

export interface ReportPayload {
  email: string
  pictureUrls: readonly string[]
  reason: ReportReason
  roomId?: number
  source: ReportSource
  suggestion: string
  targetUserId: number
}

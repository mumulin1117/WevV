import type { ReportPayload } from './contracts'
import { getSafetyReportRepository } from './report-repository'

export const reportQueries = {
  requiresTarget: (): boolean => getSafetyReportRepository().requiresTarget,
}

export const reportActions = {
  submit: (payload: ReportPayload, signal?: AbortSignal): Promise<void> =>
    getSafetyReportRepository().submit(payload, signal),
  uploadEvidence: (blob: Blob, signal?: AbortSignal): Promise<string> =>
    getSafetyReportRepository().uploadEvidence(blob, signal),
}

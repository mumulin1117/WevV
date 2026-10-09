import { reportRuntimeMetric } from '@/core/observability/runtime'

export type LiveEntryStage =
  | 'cancelled'
  | 'context-ready'
  | 'failed'
  | 'first-frame'
  | 'media-ready'
  | 'rtc-joined'
  | 'sdk-ready'
  | 'shell-visible'

interface LiveEntryTrace {
  recordedStages: Set<LiveEntryStage>
  startedAt: number
}

const traces = new Map<string, LiveEntryTrace>()

export function beginLiveEntryTrace(roomId: string): void {
  traces.set(roomId, { recordedStages: new Set(), startedAt: performance.now() })
}

export function markLiveEntryStage(roomId: string, stage: LiveEntryStage, terminal = false): void {
  const trace = traces.get(roomId)
  if (!trace || trace.recordedStages.has(stage)) return
  trace.recordedStages.add(stage)
  reportRuntimeMetric('live.entry.duration', performance.now() - trace.startedAt, {
    roomId,
    stage,
  })
  if (terminal) traces.delete(roomId)
}

export type LiveRoomResumeDecision = 'resume' | 'wait-online' | 'wait-sdk'

export function decideLiveRoomResume(input: {
  connectionHealthy: boolean
  online: boolean
}): LiveRoomResumeDecision {
  if (!input.online) return 'wait-online'
  return input.connectionHealthy ? 'resume' : 'wait-sdk'
}

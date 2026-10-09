import type { RoomLaunchContext } from './contracts'

export interface RtcTokenCredential {
  appId: string
  channelName: string
  expiresAt?: number
  role: RoomLaunchContext['role']
  rtmToken?: string
  rtcToken: string
  uid: number
}

export function hasRtcTokenServer(): boolean {
  return false
}

export async function requestRtcToken(
  _context: Pick<RoomLaunchContext, 'channelName' | 'role' | 'roomId' | 'uid'>,
  _signal?: AbortSignal,
): Promise<RtcTokenCredential> {
  throw new Error('RTC token requests are disabled in the local Java integration.')
}

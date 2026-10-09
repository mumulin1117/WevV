import { reactive } from 'vue'
import type { PartyRoom } from './contracts'

const MAX_RECENT_ROOMS = 50
const recentRoomsByUser = reactive(new Map<string, PartyRoom[]>())

/**
 * Recent 只记录本次运行中真实触发过进房的房间。Party SAPI 没有旧站的最近房间接口，
 * 因此这里不持久化、不跨账号复用，也不请求或猜测旧接口。
 */
export function rememberRecentPartyRoom(room: PartyRoom, userId: string): void {
  if (!userId || !room.id) return
  const recentAt = Date.now()
  const current = recentRoomsByUser.get(userId) ?? []
  recentRoomsByUser.set(
    userId,
    [{ ...room, recentAt }, ...current.filter((candidate) => candidate.id !== room.id)].slice(
      0,
      MAX_RECENT_ROOMS,
    ),
  )
}

export function recentPartyRooms(userId: string): readonly PartyRoom[] {
  return userId ? (recentRoomsByUser.get(userId) ?? []) : []
}

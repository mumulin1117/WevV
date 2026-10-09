import {
  createLiveChatroomController,
  type LiveChatroomController,
} from '@/features/rooms/live-chatroom-controller'
import { rtcRoomEngine } from '@/room/runtime/rtc-room-engine'
import { PartyHeartbeat } from './party-heartbeat'

/** Party Repository 只依赖本领域运行时门面；SDK、心跳和聊天室构造不再散落到数据层 import。 */
export const partyRoomRtc = rtcRoomEngine
export const createPartyChatroomController = createLiveChatroomController
export { PartyHeartbeat as PartyHeartbeatSession }
export type { LiveChatroomController as PartyChatroomController }

import { reactive, readonly } from 'vue'
import type { RoomLaunchContext } from '@/features/rooms/contracts'
import { useRoomPresentation } from '@/features/rooms/presentation'
import { PartyRoomEntryError, type PartyRoom } from './contracts'
import { partyActions } from './party-operations'

interface PartyRoomEntryRequest {
  audienceUserId: string
  openPath: string
  roomId: string
}

const passwordEntry = reactive<{
  error: string
  request: PartyRoomEntryRequest | null
  submitting: boolean
  visible: boolean
}>({
  error: '',
  request: null,
  submitting: false,
  visible: false,
})

let entryPending = false
let entryPendingRoomId = ''

export const partyRoomPasswordEntry = readonly(passwordEntry)

function launchContext(room: PartyRoom, openPath: string): RoomLaunchContext {
  return {
    appId: '',
    channelName: room.transport?.channelName || `party-${room.id}`,
    coverUrl: room.backgroundUrl || room.coverUrl || room.owner.avatarUrl,
    description: room.summary,
    displayName: room.title,
    followed: room.followed,
    hostAvatarUrl: room.owner.avatarUrl,
    hostId: room.owner.id,
    hostImAccount: room.owner.imAccount,
    mode: 'voice',
    onlineCount: room.memberCount,
    partyOpenPath: openPath,
    role: 'audience',
    roomId: room.id,
    rtcToken: '',
    uid: 0,
  }
}

function presentationUnavailable(): boolean {
  const presentation = useRoomPresentation()
  return Boolean(
    presentation.activeContext.value ||
    presentation.openingRoom.value ||
    presentation.endedLivePreview.value,
  )
}

async function prepareAndOpen(request: PartyRoomEntryRequest, password?: string): Promise<boolean> {
  const prepared = await partyActions.prepareRoomEntry(request.roomId, password)
  const presentation = useRoomPresentation()
  const opened = presentation.open(launchContext(prepared.room, request.openPath), {
    activeRoomId: prepared.room.id,
    audienceUserId: request.audienceUserId,
  })
  if (!opened) await partyActions.leaveRoom(prepared.room.id).catch(() => undefined)
  return opened
}

/**
 * 先完成 Party SAPI enter；服务端要求密码时只在当前页面展示入口密码层。
 * enter 成功后才创建顶层 RoomShell，NIM/RTC 生命周期仍由 PartyRoomShell 接管。
 */
export async function openPartyRoom(
  room: PartyRoom,
  audienceUserId: string,
  openPath = 'partyroom_feed',
): Promise<boolean> {
  return await openPartyRoomRequest(room.id, audienceUserId, openPath)
}

async function openPartyRoomRequest(
  roomId: string,
  audienceUserId: string,
  openPath: string,
): Promise<boolean> {
  if (entryPending) return entryPendingRoomId === roomId
  if (passwordEntry.visible) return passwordEntry.request?.roomId === roomId
  if (presentationUnavailable()) return false
  const request = { audienceUserId, openPath, roomId }
  entryPending = true
  entryPendingRoomId = roomId
  try {
    return await prepareAndOpen(request)
  } catch (error) {
    if (error instanceof PartyRoomEntryError && error.reason === 'password') {
      passwordEntry.error = ''
      passwordEntry.request = request
      passwordEntry.visible = true
      return true
    }
    throw error
  } finally {
    entryPending = false
    entryPendingRoomId = ''
  }
}

export async function submitPartyRoomPassword(password: string): Promise<boolean> {
  const request = passwordEntry.request
  if (!request || passwordEntry.submitting || !/^\d{4}$/u.test(password)) return false
  passwordEntry.error = ''
  passwordEntry.submitting = true
  try {
    const opened = await prepareAndOpen(request, password)
    if (opened) {
      passwordEntry.visible = false
      passwordEntry.request = null
      passwordEntry.error = ''
    }
    return opened
  } finally {
    passwordEntry.submitting = false
  }
}

export function setPartyRoomPasswordError(message: string): void {
  passwordEntry.error = message
}

export function closePartyRoomPassword(): void {
  if (passwordEntry.submitting) return
  passwordEntry.visible = false
  passwordEntry.request = null
  passwordEntry.error = ''
}

/** 本地入口直接用 roomId 调用 enter；完整房间数据由 enter 响应返回。 */
export async function openPartyRoomById(
  roomId: string,
  audienceUserId: string,
  openPath = 'party_corner_banner',
): Promise<boolean> {
  return await openPartyRoomRequest(roomId, audienceUserId, openPath)
}

/** 房内运营入口先解析目标，再完整释放当前 RoomShell 后进入新 Party 房。 */
export async function switchPartyRoomById(
  roomId: string,
  audienceUserId: string,
  openPath = 'party_banner',
): Promise<boolean> {
  const presentation = useRoomPresentation()
  if (presentation.activeContext.value?.mode !== 'voice')
    return await openPartyRoomById(roomId, audienceUserId, openPath)
  if (presentation.activeContext.value.roomId === roomId) return true
  await presentation.closeAndWait()
  return await openPartyRoomById(roomId, audienceUserId, openPath)
}

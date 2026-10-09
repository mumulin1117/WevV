import { readonly, ref, shallowRef } from 'vue'
import type { RoomLaunchContext, RoomSummary } from './contracts'
import { beginLiveEntryTrace, markLiveEntryStage } from './live-entry-performance'
import { getLiveRepository } from './live-repository'

export interface OpenRoomOptions {
  activeRoomId?: string
  audienceUserId: string
}

export interface EndedLivePreview {
  avatarUrl: string
  displayName: string
  hostId: string
  imAccount?: string
}

type RoomLifecycleOwner = symbol
type BeforeRoomChange = () => Promise<void>

export interface RoomLifecycleHooks {
  dispose?: BeforeRoomChange
  leave: BeforeRoomChange
  resume?: BeforeRoomChange
  suspend?: BeforeRoomChange
}

const activeContext = shallowRef<RoomLaunchContext | null>(null)
const openingRoom = shallowRef<RoomSummary | null>(null)
const endedLivePreview = shallowRef<EndedLivePreview | null>(null)
const activeRoomId = shallowRef<string | null>(null)
const switching = ref(false)
let audienceUserId = ''
let lifecycleOwner: RoomLifecycleOwner | undefined
let lifecycleHooks: RoomLifecycleHooks | undefined
let requestController: AbortController | undefined
let closePromise: Promise<void> | undefined

function summaryFrom(context: RoomLaunchContext): RoomSummary {
  return {
    coverUrl: context.coverUrl ?? context.hostAvatarUrl ?? '',
    cursorId: context.roomId,
    followed: context.followed,
    host: {
      avatarUrl: context.hostAvatarUrl ?? '',
      displayName: context.displayName,
      id: context.hostId ?? '',
      ...(context.hostImAccount ? { imAccount: context.hostImAccount } : {}),
    },
    id: context.roomId,
    mode: context.mode,
    onlineCount: context.onlineCount ?? 0,
    title: context.hostLevelName ?? '',
  }
}

export function useRoomPresentation() {
  function open(context: RoomLaunchContext, options: OpenRoomOptions): boolean {
    if (activeContext.value || openingRoom.value) return false
    audienceUserId = options.audienceUserId
    activeContext.value = context
    activeRoomId.value = options.activeRoomId ?? context.roomId
    return true
  }

  async function openLive(room: RoomSummary, options: OpenRoomOptions): Promise<boolean> {
    if (room.mode !== 'live') throw new Error('Only live rooms support deferred opening.')
    if (activeContext.value || openingRoom.value) return false
    audienceUserId = options.audienceUserId
    activeRoomId.value = room.id
    openingRoom.value = room
    beginLiveEntryTrace(room.id)
    requestController?.abort()
    const controller = new AbortController()
    requestController = controller
    try {
      const context = await getLiveRepository().createLaunchContext(
        room,
        audienceUserId,
        'audience',
        controller.signal,
      )
      if (requestController !== controller || controller.signal.aborted) return true
      markLiveEntryStage(room.id, 'context-ready')
      activeContext.value = context
      openingRoom.value = null
      return true
    } catch (cause) {
      if (requestController === controller) {
        openingRoom.value = null
        activeRoomId.value = null
        markLiveEntryStage(room.id, 'failed', true)
      }
      throw cause
    }
  }

  function close(): void {
    const roomId = openingRoom.value?.id ?? activeContext.value?.roomId
    if (roomId) markLiveEntryStage(roomId, 'cancelled', true)
    requestController?.abort()
    requestController = undefined
    activeContext.value = null
    activeRoomId.value = null
    openingRoom.value = null
    endedLivePreview.value = null
    audienceUserId = ''
    lifecycleOwner = undefined
    lifecycleHooks = undefined
    switching.value = false
  }

  async function closeAndWait(): Promise<void> {
    if (closePromise) return closePromise
    const teardown = lifecycleHooks?.dispose ?? lifecycleHooks?.leave
    const task = Promise.resolve()
      .then(() => teardown?.())
      .finally(() => {
        close()
        if (closePromise === task) closePromise = undefined
      })
    closePromise = task
    return task
  }

  async function revalidateActiveLive(signal?: AbortSignal): Promise<RoomLaunchContext> {
    const context = activeContext.value
    if (!context || context.mode !== 'live' || !audienceUserId)
      throw new Error('LIVE_ROOM_REVALIDATION_CONTEXT_MISSING')
    const refreshed = await getLiveRepository().createLaunchContext(
      summaryFrom(context),
      audienceUserId,
      'audience',
      signal,
    )
    if (activeContext.value?.roomId !== refreshed.roomId)
      throw new DOMException('Aborted', 'AbortError')
    activeContext.value = refreshed
    return refreshed
  }

  function registerRoomLifecycle(
    owner: RoomLifecycleOwner,
    handler: BeforeRoomChange | RoomLifecycleHooks,
  ): void {
    lifecycleOwner = owner
    lifecycleHooks = typeof handler === 'function' ? { leave: handler } : handler
  }

  function unregisterRoomLifecycle(owner: RoomLifecycleOwner): void {
    if (owner !== lifecycleOwner) return
    lifecycleOwner = undefined
    lifecycleHooks = undefined
  }

  return {
    activeContext: readonly(activeContext),
    activeRoomId: readonly(activeRoomId),
    close,
    closeAndWait,
    endedLivePreview: readonly(endedLivePreview),
    markRoomEnded: (_roomId: string) => undefined,
    open,
    openLive,
    openingRoom: readonly(openingRoom),
    registerRoomLifecycle,
    revalidateActiveLive,
    switching: readonly(switching),
    unregisterRoomLifecycle,
    waitForRoomSwitch: () => Promise.resolve(),
  }
}

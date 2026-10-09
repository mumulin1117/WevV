<script setup lang="ts">
import { nextTick, onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { closeNativeRoom, notifyNativeRoomReady } from '@/core/bridge/room-native-bridge'
import { getRoomEntry, type RoomType } from '@/core/entry/room-entry'
import { openPartyRoomById } from '@/features/party/open-party-room'
import type { RoomSummary } from '@/features/rooms/contracts'
import { useRoomPresentation } from '@/features/rooms/presentation'
import { useSessionStore } from '@/main/stores/session'
import AppLoadLoadingIcon from '@/main/components/AppLoadLoadingIcon.vue'

const route = useRoute()
const presentation = useRoomPresentation()
const session = useSessionStore()
const error = ref('')
const opening = ref(false)

function routeTarget(): { roomId: string; roomType: RoomType } | null {
  const roomId = String(route.params.roomId ?? '')
  if (!/^[1-9]\d*$/u.test(roomId)) return null
  if (route.name === 'live-room') return { roomId, roomType: 'live' }
  if (route.name === 'voice-room') return { roomId, roomType: 'voice' }
  return null
}

async function notifyNativeAfterVisiblePaint(target: {
  roomId: string
  roomType: RoomType
}): Promise<void> {
  await nextTick()
  await new Promise<void>((resolve) => requestAnimationFrame(() => resolve()))
  await new Promise<void>((resolve) => requestAnimationFrame(() => resolve()))
  notifyNativeRoomReady(target)
}

async function openRouteRoom(): Promise<void> {
  if (opening.value) return
  const target = routeTarget()
  if (!target) {
    error.value = 'The room link is invalid.'
    const entry = getRoomEntry()
    await notifyNativeAfterVisiblePaint({ roomId: entry.roomId, roomType: entry.roomType })
    return
  }
  const userId = session.user?.id ?? ''
  if (!userId) {
    error.value = 'The user session is unavailable.'
    await notifyNativeAfterVisiblePaint(target)
    return
  }
  opening.value = true
  error.value = ''
  try {
    if (presentation.activeContext.value?.roomId === target.roomId) return
    if (presentation.activeContext.value) await presentation.closeAndWait()
    if (target.roomType === 'voice') {
      const opened = await openPartyRoomById(target.roomId, userId, 'standalone_url')
      if (!opened) throw new Error('The voice room is unavailable.')
      return
    }
    const room: RoomSummary = {
      coverUrl: '',
      cursorId: target.roomId,
      host: { avatarUrl: '', displayName: 'Live', id: '' },
      id: target.roomId,
      mode: 'live',
      onlineCount: 0,
      title: '',
    }
    if (
      !(await presentation.openLive(room, { activeRoomId: target.roomId, audienceUserId: userId }))
    )
      throw new Error('The live room is already open.')
  } catch (cause) {
    error.value = cause instanceof Error ? cause.message : 'Unable to open this room.'
  } finally {
    opening.value = false
    await notifyNativeAfterVisiblePaint(target)
  }
}

function closeFailure(): void {
  const target = routeTarget()
  const entry = getRoomEntry()
  closeNativeRoom({
    reason: 'fatal',
    roomId: target?.roomId ?? entry.roomId,
    roomType: target?.roomType ?? entry.roomType,
  })
}

onMounted(openRouteRoom)
watch(() => route.fullPath, openRouteRoom)
</script>

<template>
  <main class="room-route-page">
    <AppLoadLoadingIcon v-if="opening && !error" animated :size="60" />
    <section v-else-if="error" class="room-route-error" role="alert">
      <h1>Unable to open room</h1>
      <p>{{ error }}</p>
      <div>
        <button type="button" @click="openRouteRoom">Retry</button>
        <button type="button" @click="closeFailure">Close</button>
      </div>
    </section>
  </main>
</template>

<style scoped lang="less">
.room-route-page {
  position: absolute;
  inset: 0;
  display: grid;
  color: var(--color-text);
  background: var(--color-media-bg);
  place-items: center;
}

.room-route-error {
  width: min(82vw, 360px);
  text-align: center;
}

.room-route-error h1 {
  margin: 0 0 12px;
  font-size: 20px;
}

.room-route-error p {
  margin: 0 0 20px;
  color: var(--color-on-dark-secondary);
}

.room-route-error div {
  display: flex;
  justify-content: center;
  gap: 12px;
}

.room-route-error button {
  min-width: 96px;
  padding: 10px 18px;
  border: 0;
  border-radius: 999px;
  color: var(--color-on-dark);
  background: var(--gradient-primary);
}
</style>

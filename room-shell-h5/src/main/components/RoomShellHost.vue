<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { useRouter } from 'vue-router'
import { closeNativeRoom, openNativeRecharge } from '@/core/bridge/room-native-bridge'
import { getRoomEntry } from '@/core/entry/room-entry'
import PartyRoomShell from '@/features/party/components/PartyRoomShell.vue'
import { switchPartyRoomById } from '@/features/party/open-party-room'
import type { RechargeOptions } from '@/core/bridge/recharge-options'
import type { ReportContext } from '@/features/safety/contracts'
import ReportSheet from '@/features/safety/components/ReportSheet.vue'
import LiveTerminalState from '@/features/rooms/components/LiveTerminalState.vue'
import { useRoomPresentation } from '@/features/rooms/presentation'
import RoomApp from '@/room/RoomApp.vue'
import { useSessionStore } from '@/main/stores/session'
import AppLoadLoadingIcon from './AppLoadLoadingIcon.vue'

const presentation = useRoomPresentation()
const session = useSessionStore()
const router = useRouter()
const { t } = useI18n()
const reportContext = ref<ReportContext | null>(null)
const showReport = ref(false)
let nativeCloseSent = false
let switchingVoiceRoom = false

const activeContext = computed(() => presentation.activeContext.value)
const hasRoomShell = computed(() =>
  Boolean(
    activeContext.value || presentation.openingRoom.value || presentation.endedLivePreview.value,
  ),
)

function notifyNativeClose(reason: 'ended' | 'user' = 'user'): void {
  if (nativeCloseSent) return
  nativeCloseSent = true
  const context = activeContext.value
  const entry = getRoomEntry()
  const roomId = context?.roomId || presentation.openingRoom.value?.id || entry.roomId
  closeNativeRoom({
    reason,
    roomId,
    roomType: context ? (context.mode === 'voice' ? 'voice' : 'live') : entry.roomType,
  })
}

function handleClosed(): void {
  notifyNativeClose('user')
  presentation.close()
}

async function closeRoom(reason: 'ended' | 'user' = 'user'): Promise<void> {
  await Promise.race([
    presentation.closeAndWait().catch(() => undefined),
    new Promise<void>((resolve) => window.setTimeout(resolve, 2_500)),
  ])
  notifyNativeClose(reason)
}

function openRecharge(options: RechargeOptions): void {
  const context = activeContext.value
  if (!context) return
  openNativeRecharge({
    requiredDiamonds: Math.max(0, Math.floor(options.requiredDiamonds ?? 0)),
    roomId: context.roomId,
    roomType: context.mode === 'voice' ? 'voice' : 'live',
    source: context.mode === 'voice' ? 'party' : 'live',
  })
}

async function switchVoiceRoom(roomId: string): Promise<void> {
  if (switchingVoiceRoom || !session.user?.id) return
  switchingVoiceRoom = true
  try {
    if (await switchPartyRoomById(roomId, session.user.id, 'party_banner'))
      await router.replace({ name: 'voice-room', params: { roomId } })
  } finally {
    switchingVoiceRoom = false
  }
}

async function openReport(context: { hostId: string; roomId: string }): Promise<void> {
  reportContext.value = {
    roomId: context.roomId,
    source: activeContext.value?.mode === 'voice' ? 'party' : 'live',
    targetUserId: context.hostId,
  }
  await nextTick()
  showReport.value = Boolean(reportContext.value)
}

function releaseReport(): void {
  if (!showReport.value) reportContext.value = null
}

onBeforeUnmount(() => {
  void presentation.closeAndWait()
})
</script>

<template>
  <div v-if="hasRoomShell" class="room-shell-host">
    <PartyRoomShell
      v-if="activeContext?.mode === 'voice'"
      :key="activeContext.roomId"
      :context="activeContext"
      @closed="handleClosed"
      @party-room="switchVoiceRoom"
      @recharge="openRecharge"
      @report="openReport"
    />
    <RoomApp
      v-else-if="activeContext"
      :key="activeContext.roomId"
      :context="activeContext"
      @closed="handleClosed"
      @recharge="openRecharge"
      @report="openReport"
    />
    <section v-else-if="presentation.openingRoom.value" class="room-shell-loading">
      <AppLoadLoadingIcon animated :size="60" />
    </section>
    <LiveTerminalState
      v-else-if="presentation.endedLivePreview.value"
      :avatar-url="presentation.endedLivePreview.value.avatarUrl"
      :can-message="false"
      :description="t('room.liveEndedDescription')"
      :display-name="presentation.endedLivePreview.value.displayName"
      reason="ended"
      :retrying="false"
      @leave="closeRoom('ended')"
    />
  </div>
  <ReportSheet
    v-if="reportContext"
    v-model="showReport"
    :context="reportContext"
    @closed="releaseReport"
  />
</template>

<style scoped>
.room-shell-host,
.room-shell-loading {
  position: absolute;
  inset: 0;
  overflow: hidden;
  background: var(--color-media-bg);
}

.room-shell-loading {
  display: grid;
  place-items: center;
}
</style>

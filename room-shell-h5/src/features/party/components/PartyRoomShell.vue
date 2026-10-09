<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, onMounted, ref, shallowRef, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import type { Swiper as SwiperInstance } from 'swiper'
import { Swiper as SwiperView, SwiperSlide } from 'swiper/vue'
import 'swiper/css'
import { publicAsset } from '@/core/media/public-asset'
import { accountPreferences } from '@/core/storage/account-preferences'
import { appActivity } from '@/core/runtime/app-activity'
import {
  applicationRecoveryCoordinator,
  type ApplicationRecoveryContext,
} from '@/core/runtime/application-recovery-coordinator'
import type { ConversationTarget, GiftItem, InboxConversation } from '@/features/messages/contracts'
import { HttpMessageGateway } from '@/features/messages/http-message-gateway'
import type { RoomLaunchContext } from '@/features/rooms/contracts'
import { useRoomPresentation } from '@/features/rooms/presentation'
import type { RechargeOptions } from '@/core/bridge/recharge-options'
import { rtcRoomEngine } from '@/room/runtime/rtc-room-engine'
import type {
  PartyBackground,
  PartyBlacklistEntry,
  PartyEmojiItem,
  PartyMember,
  PartyMessage,
  PartyMusicItem,
  PartyMusicSettings,
  PartyQueueEntry,
  PartyQueueState,
  PartyRankingPeriod,
  PartyRankingScope,
  PartyRoomRankKind,
  PartyRoomRankResult,
  PartyRoomRecoveryOptions,
  PartyRoomSnapshot,
  PartyRoomTemplate,
  PartySeat,
} from '@/features/party/contracts'
import { partyRoomOperations } from '@/features/party/party-operations'
import { rememberRecentPartyRoom } from '@/features/party/party-room-history'
import type { PartyRoomEffectScheduler } from '@/features/party/party-room-effect-scheduler'
import { resolvePartyVideoSeatPresentation } from '@/features/party/party-video-seat-presentation'
import AppAvatar from '@/main/components/AppAvatar.vue'
import AppHeadFrame from '@/main/components/AppHeadFrame.vue'
import AppImage from '@/main/components/AppImage.vue'
import AppLoadLoadingIcon from '@/main/components/AppLoadLoadingIcon.vue'
import RoomMessageStack from '@/main/components/RoomMessageStack.vue'
import AppStateView from '@/main/components/AppStateView.vue'
import AppUserLevelTag from '@/main/components/AppUserLevelTag.vue'
import { useAppFeedback } from '@/main/ui/feedback'
import { useAppOverlay } from '@/main/ui/overlay'
import { toUserFacingError } from '@/main/ui/user-facing-error'
import { useSessionStore } from '@/main/stores/session'
import { useMessagesStore } from '@/main/stores/messages'
import { useRelationshipsStore } from '@/main/stores/relationships'
import type { GiftPanelRechargeRequest } from '@/shared/gifts/contracts'
import { isGiftBalanceError, useGiftSendFlow } from '@/shared/gifts/useGiftSendFlow'
import PartyGiftSheet from './PartyGiftSheet.vue'
import PartyActivityPopup from './PartyActivityPopup.vue'
import PartyRoomBackground from './PartyRoomBackground.vue'
import PartyRoomEffects from './PartyRoomEffects.vue'
import PartyRoomPanels, { type PartyPanel } from './PartyRoomPanels.vue'
import PartySeatExpression from './PartySeatExpression.vue'
import PartySpeakingFrames from './PartySpeakingFrames.vue'
import { resolvePromotionTarget } from '@/features/promotions/promotion-target'

const props = defineProps<{ context: RoomLaunchContext }>()
const emit = defineEmits<{
  closed: []
  'party-room': [roomId: string]
  recharge: [options: RechargeOptions]
  report: [context: { hostId: string; roomId: string }]
}>()

const presentation = useRoomPresentation()
const feedback = useAppFeedback()
const overlay = useAppOverlay()
const session = useSessionStore()
const messagesStore = useMessagesStore()
const relationships = useRelationshipsStore()
const { t } = useI18n()
const lifecycleOwner = Symbol('party-room-shell')
const snapshot = shallowRef<PartyRoomSnapshot | null>(null)
const ownerFollowed = computed(() => {
  const owner = snapshot.value?.room.owner
  return owner
    ? relationships.relationship(owner.id, {
        followed: snapshot.value?.room.followed ?? owner.followed,
        followedKnown: true,
        userType: owner.userType,
      }).followed
    : false
})
const ownerFollowPending = computed(() => {
  const ownerId = snapshot.value?.room.owner.id
  return ownerId ? relationships.isPending(ownerId, 'follow') : false
})
const microphoneStream = shallowRef<MediaStream | null>(null)
const draft = ref('')
const composerOpen = ref(false)
const composerInput = ref<HTMLInputElement | null>(null)
type PartyChatTab = 'all' | 'chat' | 'gift'
const chatTab = ref<PartyChatTab>('all')
const chatSwiper = shallowRef<SwiperInstance | null>(null)
const chatScrollers = new Map<PartyChatTab, HTMLElement>()
const sessionGiftMessageIds = new Set<string>()
type PartySeatMenuChoice = 'invite' | 'leave' | 'lock' | 'mute' | 'take' | 'unlock' | 'unmute'
const composing = ref(false)
const loading = ref(true)
const failed = ref(false)
const leaving = ref(false)
const sending = ref(false)
const seatPending = ref(false)
const panel = ref<PartyPanel | null>(null)
const showMessages = ref(false)
const messageConversationTarget = shallowRef<ConversationTarget | null>(null)
const selectedSeat = shallowRef<PartySeat | null>(null)
const selectedMember = shallowRef<PartyMember | null>(null)
const memberCardOpen = ref(false)
const giftPanel = ref(false)
const activityUrl = ref('')
const preferredGiftReceiverId = ref('')
const gifts = ref<readonly GiftItem[]>([])
const giftCountChoices = ref<readonly number[]>([1, 5, 10, 99])
const giftLoading = ref(false)
const giftFailed = ref(false)
const { pending: giftSending, run: runGiftSend } = useGiftSendFlow()
const soundEnabled = ref(true)
const simulatedRoomAudio = ref<HTMLAudioElement | null>(null)
const simulatedAudioNeedsGesture = ref(false)
const simulatedRoomAudioSource = computed(() => {
  const settings = musicSettings.value
  if (!settings?.enabled || !settings.playing || settings.muted) return ''
  return settings.url?.trim() ?? ''
})
const viewers = ref<readonly PartyMember[]>([])
const inviteCandidates = ref<readonly PartyMember[]>([])
const inviteFollowers = ref<readonly PartyMember[]>([])
const inviteConversations = ref<readonly InboxConversation[]>([])
const inviteLoadedTabs = ref<boolean[]>([false, false, false])
const inviteLoadingTabs = ref<boolean[]>([false, false, false])
const inviteCooldowns = ref<Record<string, number>>({})
const rankResult = shallowRef<PartyRoomRankResult>({
  durationSeconds: 0,
  entries: [],
  finished: true,
  myRank: null,
})
const rankKind = ref<PartyRoomRankKind>('contribution')
const rankPeriod = ref<PartyRankingPeriod>('day')
const rankScope = ref<PartyRankingScope>('CURRENT')
const emojis = ref<readonly PartyEmojiItem[]>([])
const music = ref<readonly PartyMusicItem[]>([])
const musicSettings = shallowRef<PartyMusicSettings | null>(null)
const musicControlPending = ref(false)
const backgrounds = ref<readonly PartyBackground[]>([])
const currentBackground = shallowRef<PartyBackground | null>(null)
const roomTemplates = ref<readonly PartyRoomTemplate[]>([])
const blacklist = ref<readonly PartyBlacklistEntry[]>([])
const queue = shallowRef<PartyQueueState>({ entries: [], myIndex: 0, total: 0 })
const panelLoading = ref(false)
const realtimeEnabled = false
const roomMessagingEnabled = true
const connectionNoticeVisible = computed(() => snapshot.value?.communication.state === 'failed')
const roomBackgroundPlaybackActive = ref(appActivity.value.visible)
const roomEffectsActive = computed(() => appActivity.value.visible)
const headerMetric = ref<'contribution' | 'honor'>('contribution')
const roomEffects = shallowRef<Pick<
  PartyRoomEffectScheduler,
  'clear' | 'enqueue' | 'enqueueGiftMedia'
> | null>(null)
let rankLoadSequence = 0
let rankPendingRequestKey = ''
let panelLoadSequence = 0
let stopObserver: (() => void) | undefined
let tornDown = false
let loadEpoch = 0
let loadPromise: Promise<void> | null = null
let foregroundRecoveryPromise: Promise<void> | null = null
let microphoneEnabledBeforeSuspend = false
let stopRecoveryParticipant: (() => void) | undefined
let lastGiftSentAt = 0
let giftCloseTimer = 0
let giftSendSequence = 0
let resolveGiftClose: (() => void) | undefined
let headerMetricTimer = 0
let musicUploadController: AbortController | null = null
let chatScrollAnimationFrame = 0
let simulatedSpeakerTimer = 0
let simulatedSpeakerIndex = -1
let initialChatScrollPending = true
const INITIAL_CHAT_SCROLL_DURATION_MS = 2_000

async function withBlockingRequest<T>(operation: () => Promise<T>): Promise<T> {
  const closeLoading = feedback.loading()
  try {
    return await operation()
  } finally {
    closeLoading()
  }
}

const currentUserId = computed(() => session.user?.id ?? '')
function giftEffectOwner(): string {
  return `party:${props.context.roomId}`
}

const giftRechargeCovered = false
const currentSeat = computed(() =>
  snapshot.value?.room.seats.find((seat) => seat.member?.id === currentUserId.value),
)
const giftReceivers = computed(() => {
  const room = snapshot.value?.room
  if (!room) return []
  const unique = new Map<string, PartyMember & { seatIndex: number }>()
  if (room.owner.id && room.owner.id !== currentUserId.value)
    unique.set(room.owner.id, { ...room.owner, seatIndex: 0 })
  for (const seat of room.seats) {
    const member = seat.member
    if (!member?.id || member.id === currentUserId.value) continue
    unique.set(member.id, { ...member, seatIndex: seat.index + 1 })
  }
  return [...unique.values()]
})
const videoSeats = computed(
  () => snapshot.value?.room.seats.filter((seat) => seat.type === 'video') ?? [],
)
const videoSeatViews = computed(() =>
  videoSeats.value.map((seat) => ({
    presentation: resolvePartyVideoSeatPresentation(seat),
    seat,
  })),
)
const audioSeats = computed(
  () => snapshot.value?.room.seats.filter((seat) => seat.type === 'audio') ?? [],
)
const audioSeatRows = computed(() => {
  const seats = audioSeats.value
  if (seats.length === 30 && !videoSeats.value.length) {
    const rows: PartySeat[][] = []
    for (let index = 0; index < seats.length; index += 6) rows.push(seats.slice(index, index + 6))
    return rows
  }
  if (videoSeats.value.length || seats.length >= 10) {
    const rows: PartySeat[][] = []
    for (let index = 0; index < seats.length; index += 5) rows.push(seats.slice(index, index + 5))
    return rows
  }
  if (seats.length <= 4) return [seats]
  if (seats.length <= 9) return [seats.slice(0, seats.length - 4), seats.slice(seats.length - 4)]
  return [seats]
})
const canManageRoom = computed(() => {
  const room = snapshot.value?.room
  return room?.role === 'owner' || room?.role === 'admin' || room?.platformAdmin === true
})
const showMicApplication = computed(() => {
  const room = snapshot.value?.room
  if (!room?.onSeatApplyEnabled) return false
  if (canManageRoom.value) return true
  return !currentSeat.value && queue.value.myIndex > 0
})
const chatTabs = ['all', 'chat', 'gift'] as const
function selectChatTab(tab: PartyChatTab): void {
  if (chatTab.value === tab) return
  chatSwiper.value?.slideTo(chatTabs.indexOf(tab))
}

function setChatSwiper(swiper: SwiperInstance): void {
  chatSwiper.value = swiper
}

function handleChatSwipe(swiper: SwiperInstance): void {
  chatTab.value = chatTabs[swiper.realIndex] ?? 'all'
  scrollToBottom()
}
const microphoneActive = computed(() =>
  partyRoomOperations.managesCommunication()
    ? Boolean(
        currentSeat.value &&
        rtcRoomEngine.voicePublishing.value &&
        !rtcRoomEngine.microphoneMuted.value &&
        !currentSeat.value.prohibited &&
        !currentSeat.value.member?.muted,
      )
    : Boolean(microphoneStream.value?.getAudioTracks().some((track) => track.enabled)),
)
const canSend = computed(() => Boolean(draft.value.trim()) && !sending.value)
const headerMetricValue = computed(() =>
  headerMetric.value === 'honor'
    ? (snapshot.value?.room.honor ?? 0)
    : (snapshot.value?.room.score ?? 0),
)
const roomBackground = computed(() => ({
  backgroundImage: `url(${/\.(?:mp4|svga)(?:[?#]|$)/iu.test(snapshot.value?.room.backgroundUrl ?? '') ? publicAsset('party/room/bg_party.png') : snapshot.value?.room.backgroundUrl || publicAsset('party/room/bg_party.png')})`,
}))
const messageMembers = computed(() => {
  const room = snapshot.value?.room
  const members = new Map<string, PartyMember>()
  if (!room) return members
  for (const member of [room.owner, ...room.seats.map((seat) => seat.member)]) {
    if (!member) continue
    members.set(member.id, member)
    if (member.imAccount) members.set(member.imAccount, member)
  }
  return members
})
const messageGiftReceiverMap = computed(() => {
  const result = new Map<string, Array<{ avatarUrl: string; id: string; name: string }>>()
  for (const message of snapshot.value?.messages ?? []) {
    if (!message.giftReceiverIds?.length) continue
    const presentationReceivers =
      message.presentation?.kind === 'gift' ? message.presentation.receivers : []
    const receivers = message.giftReceiverIds.map((id) => {
      const member = messageMembers.value.get(id)
      if (member) return { avatarUrl: member.avatarUrl, id: member.id, name: member.displayName }
      return (
        presentationReceivers.find((receiver) => receiver.id === id) ?? {
          avatarUrl: '',
          id,
          name: '',
        }
      )
    })
    result.set(message.id, receivers)
  }
  return result
})
function messagesFor(tab: (typeof chatTabs)[number]): PartyMessage[] {
  const messages = (snapshot.value?.messages ?? []).filter(
    (message) =>
      message.presentation?.kind !== 'entry' || message.presentation.variant !== 'vehicle',
  )
  if (tab === 'gift') return messages.filter((message) => message.type === 'gift').slice(-20)
  if (tab === 'chat')
    return messages
      .filter((message) => message.type === 'text' && !message.id.startsWith('party-greeting:'))
      .slice(-100)
  return messages
    .filter((message) => message.type !== 'gift' || sessionGiftMessageIds.has(message.id))
    .slice(-100)
}

function messageMember(message: PartyMessage): PartyMember | null {
  return messageMembers.value.get(message.senderId) ?? null
}

function messageShowsUserBadges(message: PartyMessage): boolean {
  return messageMember(message)?.userType === 1
}

function selectMessageMember(message: PartyMessage): void {
  const member = messageMember(message)
  if (member) selectMember(member)
}

function messageGiftReceivers(
  message: PartyMessage,
): Array<{ avatarUrl: string; id: string; name: string }> {
  return messageGiftReceiverMap.value.get(message.id) ?? []
}

const state = computed(() => {
  if (loading.value) return 'loading'
  if (failed.value) return 'error'
  if (!snapshot.value) return 'empty'
  return 'content'
})

function cancelChatScrollAnimation(): void {
  if (!chatScrollAnimationFrame) return
  window.cancelAnimationFrame(chatScrollAnimationFrame)
  chatScrollAnimationFrame = 0
}

function animateChatToBottom(scroller: HTMLElement, target: number): void {
  cancelChatScrollAnimation()
  const start = scroller.scrollTop
  const distance = target - start
  if (Math.abs(distance) < 50) {
    scroller.scrollTo({ behavior: 'smooth', top: target })
    return
  }
  const startedAt = performance.now()
  const step = (now: number): void => {
    const progress = Math.min((now - startedAt) / INITIAL_CHAT_SCROLL_DURATION_MS, 1)
    const eased = 1 - (1 - progress) ** 3
    scroller.scrollTop = start + distance * eased
    if (progress < 1) chatScrollAnimationFrame = window.requestAnimationFrame(step)
    else chatScrollAnimationFrame = 0
  }
  chatScrollAnimationFrame = window.requestAnimationFrame(step)
}

function scrollToBottom(smooth = true, initial = false): void {
  void nextTick(() => {
    const scroller = chatScrollers.get(chatTab.value)
    if (!scroller) return
    if (initial) {
      if (!initialChatScrollPending) return
      initialChatScrollPending = false
    }
    const target = scroller.scrollHeight
    cancelChatScrollAnimation()
    if (!smooth || window.matchMedia?.('(prefers-reduced-motion: reduce)').matches) {
      scroller.scrollTop = target
      return
    }
    if (initial && target - scroller.scrollTop > scroller.clientHeight * 2) {
      animateChatToBottom(scroller, target)
      return
    }
    scroller.scrollTo({ behavior: 'smooth', top: target })
  })
}

function chatIsNearBottom(tab: PartyChatTab, threshold = 36): boolean {
  const scroller = chatScrollers.get(tab)
  if (!scroller) return true
  return scroller.scrollHeight - scroller.scrollTop - scroller.clientHeight <= threshold
}

function isOwnGift(message: PartyMessage, value: PartyRoomSnapshot): boolean {
  const userId = currentUserId.value.trim()
  if (!userId) return false
  const member = [
    value.room.owner,
    ...value.room.seats.flatMap((seat) => (seat.member ? [seat.member] : [])),
  ].find((item) => item.id === userId)
  const identities = new Set(
    [userId, session.profile?.imAccount ?? '', member?.id ?? '', member?.imAccount ?? ''].filter(
      Boolean,
    ),
  )
  return identities.has(message.senderId) || identities.has(message.senderUserId ?? '')
}

function applySnapshot(value: PartyRoomSnapshot): void {
  const shouldFollowChat = chatIsNearBottom(chatTab.value)
  const previousMessageIds = snapshot.value
    ? new Set(snapshot.value.messages.map((message) => message.id))
    : null
  if (!previousMessageIds) sessionGiftMessageIds.clear()
  snapshot.value = value
  const members = [
    value.room.owner,
    ...value.room.seats.flatMap((seat) => (seat.member ? [seat.member] : [])),
  ]
  members.forEach((member) =>
    relationships.seed({
      followed: member.owner ? value.room.followed : member.followed,
      imAccount: member.imAccount,
      userId: member.id,
      userType: member.userType,
    }),
  )
  if (value.queue) queue.value = value.queue
  if (value.musicSettings && !musicControlPending.value) musicSettings.value = value.musicSettings
  if (value.room.ended && !leaving.value) {
    const reason = value.terminationReason
    feedback.warning(
      reason === 'kicked'
        ? 'You were removed from the room.'
        : reason === 'banned'
          ? 'You are blocked from this room.'
          : t('party.roomEnded'),
    )
    void closeRoom()
  }
  let hasNewMessage = false
  if (previousMessageIds) {
    for (const message of value.messages) {
      if (previousMessageIds.has(message.id)) continue
      hasNewMessage = true
      if (message.type === 'gift') sessionGiftMessageIds.add(message.id)
      if (!roomEffectsActive.value) continue
      if (message.type === 'gift') {
        roomEffects.value?.enqueue(message, { media: !isOwnGift(message, value) })
      } else if (message.type === 'entry' || message.activityType === 'first-gift')
        roomEffects.value?.enqueue(message)
    }
  }
  const initialMessagesReady =
    initialChatScrollPending &&
    (value.messages.length > 0 || value.communication.state === 'connected')
  if (initialMessagesReady) {
    scrollToBottom(true, true)
  } else if (previousMessageIds && hasNewMessage && shouldFollowChat) scrollToBottom()
}

function applyQueueState(value: PartyQueueState): void {
  queue.value = value
  if (!snapshot.value) return
  snapshot.value.queue = value
  snapshot.value.room.queueCount = value.total
  snapshot.value = structuredClone(snapshot.value)
}

async function setMediaSession(active: boolean): Promise<void> {
  void active
}

function setSimulatedSpeaker(nextIndex = -1): void {
  const value = snapshot.value
  if (!value) return
  snapshot.value = {
    ...value,
    room: {
      ...value.room,
      seats: value.room.seats.map((seat) => ({
        ...seat,
        speaking: seat.index === nextIndex && Boolean(seat.member) && !seat.member?.muted,
      })),
    },
  }
}

function stopSimulatedSpeaking(): void {
  window.clearInterval(simulatedSpeakerTimer)
  simulatedSpeakerTimer = 0
  simulatedSpeakerIndex = -1
  setSimulatedSpeaker()
}

function startSimulatedSpeaking(): void {
  stopSimulatedSpeaking()
  const advance = () => {
    const occupied =
      snapshot.value?.room.seats.filter((seat) => seat.member && !seat.member.muted) ?? []
    if (!occupied.length) return
    simulatedSpeakerIndex = (simulatedSpeakerIndex + 1) % occupied.length
    setSimulatedSpeaker(occupied[simulatedSpeakerIndex]?.index)
  }
  advance()
  simulatedSpeakerTimer = window.setInterval(advance, 2_800)
}

function pauseSimulatedRoomAudio(): void {
  simulatedRoomAudio.value?.pause()
  stopSimulatedSpeaking()
}

async function startSimulatedRoomAudio(): Promise<void> {
  if (realtimeEnabled || !soundEnabled.value || !appActivity.value.visible) return
  const audio = simulatedRoomAudio.value
  if (!audio || !simulatedRoomAudioSource.value) return
  audio.volume = Math.min(1, Math.max(0, (musicSettings.value?.volume ?? 100) / 100))
  audio.muted = false
  try {
    await audio.play()
    simulatedAudioNeedsGesture.value = false
    startSimulatedSpeaking()
  } catch {
    // Audible autoplay can be rejected after the asynchronous room request completes.
    simulatedAudioNeedsGesture.value = true
    pauseSimulatedRoomAudio()
  }
}

async function requestMicrophone(): Promise<MediaStream> {
  if (!navigator.mediaDevices?.getUserMedia) throw new Error(t('party.microphoneDenied'))
  return await navigator.mediaDevices.getUserMedia({ audio: true, video: false })
}

async function requestMicrophoneAccess(): Promise<void> {
  const stream = await requestMicrophone()
  stream.getTracks().forEach((track) => track.stop())
}

function stopMicrophone(): void {
  microphoneStream.value?.getTracks().forEach((track) => track.stop())
  microphoneStream.value = null
}

async function startMicrophone(): Promise<void> {
  if (microphoneStream.value) {
    microphoneStream.value.getAudioTracks().forEach((track) => (track.enabled = true))
    return
  }
  microphoneStream.value = await requestMicrophone()
}

async function performLoad(epoch: number): Promise<void> {
  cancelChatScrollAnimation()
  initialChatScrollPending = true
  chatTab.value = 'all'
  sessionGiftMessageIds.clear()
  loading.value = true
  failed.value = false
  tornDown = false
  try {
    if (!partyRoomOperations.isAvailable()) throw new Error(t('party.unableTitle'))
    await setMediaSession(appActivity.value.visible)
    const joinedSnapshot = await partyRoomOperations.joinRoom(props.context.roomId)
    if (epoch !== loadEpoch || tornDown) {
      await partyRoomOperations.leaveRoom(props.context.roomId).catch(() => undefined)
      await setMediaSession(false)
      return
    }
    applySnapshot(joinedSnapshot)
    void loadGiftCatalog(true)
    stopObserver = partyRoomOperations.observe(props.context.roomId, applySnapshot)
    if (snapshot.value) rememberRecentPartyRoom(snapshot.value.room, session.user?.id ?? '')
    presentation.registerRoomLifecycle(lifecycleOwner, teardown)
    if (snapshot.value?.room.onSeatApplyEnabled && !currentSeat.value)
      void partyRoomOperations
        .getQueue(props.context.roomId)
        .then((value) => {
          if (!tornDown) applyQueueState(value)
        })
        .catch(() => undefined)
    if (snapshot.value?.room.musicAvailable) {
      const settings = await partyRoomOperations
        .getMusicSettings(props.context.roomId)
        .catch(() => null)
      if (!tornDown && settings) musicSettings.value = settings
    }
    if (!appActivity.value.visible) await suspendForApplicationBackground()
  } catch (error) {
    await partyRoomOperations.leaveRoom(props.context.roomId).catch(() => undefined)
    await setMediaSession(false)
    failed.value = true
    feedback.error(toUserFacingError(error, t('party.loadingEnterFailed')))
  } finally {
    loading.value = false
    if (
      initialChatScrollPending &&
      snapshot.value &&
      (snapshot.value.messages.length > 0 || snapshot.value.communication.state === 'connected')
    )
      scrollToBottom(true, true)
    await nextTick()
    if (!failed.value && snapshot.value) {
      const profile = session.profile
      const userId = profile?.id || session.user?.id || ''
      if (userId)
        roomEffects.value?.enqueue({
          createdAt: Date.now(),
          id: `party-self-entry:${props.context.roomId}:${loadEpoch}`,
          senderAvatarUrl: profile?.avatarUrl || session.user?.avatar || '',
          senderId: profile?.imAccount || userId,
          senderLevel: profile?.level ?? 0,
          senderName: profile?.displayName || session.user?.displayName || 'Me',
          senderUserId: userId,
          senderVip: profile ? profile.vip || profile.vipExpireAt > Date.now() : false,
          text: 'Entered Room!',
          presentation: {
            kind: 'entry',
            priority: 100 + (profile?.level ?? 0),
            userId,
            variant: 'static',
          },
          type: 'entry',
        })
    }
    await startSimulatedRoomAudio()
  }
}

function load(): Promise<void> {
  if (loadPromise) return loadPromise
  const epoch = ++loadEpoch
  const task = performLoad(epoch).finally(() => {
    if (loadPromise === task) loadPromise = null
  })
  loadPromise = task
  return task
}

async function teardown(): Promise<void> {
  if (tornDown) return
  tornDown = true
  roomBackgroundPlaybackActive.value = false
  pauseSimulatedRoomAudio()
  cancelChatScrollAnimation()
  loadEpoch += 1
  stopObserver?.()
  stopObserver = undefined
  stopMicrophone()
  clearTransientRoomEffects()
  finishGiftCloseWait()
  musicUploadController?.abort()
  musicUploadController = null
  await partyRoomOperations.leaveRoom(props.context.roomId).catch(() => undefined)
  await setMediaSession(false)
}

function clearTransientRoomEffects(): void {
  roomEffects.value?.clear()
}

async function suspendForApplicationBackground(): Promise<void> {
  roomBackgroundPlaybackActive.value = false
  pauseSimulatedRoomAudio()
  if (!snapshot.value || tornDown) return
  clearTransientRoomEffects()
  microphoneEnabledBeforeSuspend ||= Boolean(
    microphoneStream.value?.getAudioTracks().some((track) => track.enabled),
  )
  microphoneStream.value?.getAudioTracks().forEach((track) => (track.enabled = false))
  try {
    await partyRoomOperations.setRoomVisible(props.context.roomId, false)
  } finally {
    await setMediaSession(false)
  }
}

function restoreMicrophoneAfterCommunication(): void {
  if (!microphoneEnabledBeforeSuspend || snapshot.value?.communication.state !== 'connected') return
  microphoneStream.value?.getAudioTracks().forEach((track) => (track.enabled = true))
  microphoneEnabledBeforeSuspend = false
}

function recoverRoom(options: PartyRoomRecoveryOptions = {}): Promise<void> {
  if (foregroundRecoveryPromise) return foregroundRecoveryPromise
  const task = (async () => {
    if (appActivity.value.visible) roomBackgroundPlaybackActive.value = true
    if (
      options.signal?.aborted ||
      !snapshot.value ||
      tornDown ||
      !appActivity.value.visible ||
      !appActivity.value.online
    )
      return
    await setMediaSession(true)
    if (options.signal?.aborted || tornDown || !appActivity.value.visible) return
    try {
      await partyRoomOperations.setRoomVisible(props.context.roomId, true, options)
      if (options.signal?.aborted || tornDown || !appActivity.value.visible) return
      restoreMicrophoneAfterCommunication()
      await nextTick()
      await startSimulatedRoomAudio()
    } catch (error) {
      await setMediaSession(false)
      throw error
    }
  })()
    .catch((error: unknown) => {
      if (!options.signal?.aborted && !tornDown && appActivity.value.visible)
        feedback.error(toUserFacingError(error, t('party.loadingEnterFailed')))
    })
    .finally(() => {
      if (foregroundRecoveryPromise === task) foregroundRecoveryPromise = null
    })
  foregroundRecoveryPromise = task
  return task
}

function recoverFromApplicationActivity(context: ApplicationRecoveryContext): Promise<void> {
  return recoverRoom({ signal: context.signal })
}

function retryCommunication(): void {
  if (!appActivity.value.visible || !appActivity.value.online || foregroundRecoveryPromise) return
  const task = (async () => {
    await setMediaSession(true)
    await partyRoomOperations.retryRoomCommunication(props.context.roomId)
    if (tornDown || !appActivity.value.visible) return
    restoreMicrophoneAfterCommunication()
  })()
    .catch(async (error: unknown) => {
      await setMediaSession(false)
      if (!tornDown && appActivity.value.visible)
        feedback.error(toUserFacingError(error, t('party.loadingEnterFailed')))
    })
    .finally(() => {
      if (foregroundRecoveryPromise === task) foregroundRecoveryPromise = null
    })
  foregroundRecoveryPromise = task
}

async function closeRoom(): Promise<void> {
  if (leaving.value) return
  leaving.value = true
  panel.value = null
  showMessages.value = false
  messageConversationTarget.value = null
  closeMemberCard()
  try {
    await withBlockingRequest(teardown)
    emit('closed')
  } finally {
    leaving.value = false
  }
}

async function sendMessage(value = draft.value): Promise<boolean> {
  const text = value.trim()
  if (!text || sending.value || composing.value) return false
  sending.value = true
  try {
    applySnapshot(await partyRoomOperations.sendMessage(props.context.roomId, text))
    draft.value = ''
    composerOpen.value = false
    composerInput.value?.blur()
    return true
  } catch (error) {
    feedback.error(toUserFacingError(error, t('party.messageFailed')))
    return false
  } finally {
    sending.value = false
  }
}

function handleComposerEnter(event: KeyboardEvent): void {
  if (event.shiftKey || event.isComposing || composing.value) return
  event.preventDefault()
  void sendMessage()
}

function openComposer(): void {
  composerOpen.value = true
  void nextTick(() => composerInput.value?.focus())
}

function closeComposerLater(): void {
  window.setTimeout(() => {
    composerOpen.value = false
  }, 300)
}

function openPromotion(url: string): void {
  const target = resolvePromotionTarget(url)
  if (target.kind === 'activity') {
    activityUrl.value = target.url
    return
  }
  if (target.kind === 'recharge') {
    emit('recharge', { originKey: giftEffectOwner(), source: 'party' })
    return
  }
  if (target.kind === 'party-room') {
    if (target.roomId !== props.context.roomId) emit('party-room', target.roomId)
    return
  }
  if (target.kind === 'external') {
    feedback.warning(t('home.promotionUnavailable'))
    return
  }
  feedback.warning(t('home.promotionUnavailable'))
}

function closeActivity(): void {
  activityUrl.value = ''
}

function openGiftFromActivity(): void {
  closeActivity()
  void openGifts()
}

function handleActivityNavigation(scene: string): void {
  if (scene === 'recharge') {
    emit('recharge', { originKey: giftEffectOwner(), source: 'party' })
    return
  }
  if (scene === 'vip') {
    closeActivity()
    feedback.warning(t('home.promotionUnavailable'))
    return
  }
  if (scene === 'game_half' || scene === 'game_full') {
    closeActivity()
    feedback.warning(t('home.promotionUnavailable'))
    return
  }
  feedback.warning(t('home.promotionUnavailable'))
}

async function openSeatMenu(seat: PartySeat): Promise<void> {
  const actions: Array<{
    label: string
    tone: 'danger' | 'default' | 'primary'
    value: PartySeatMenuChoice
  }> = []

  if (seat.member?.id === currentUserId.value) {
    if (canManageRoom.value && seat.type === 'audio') {
      actions.push({
        label: seat.member.muted ? t('party.turnMicrophoneOn') : t('party.muteMicrophone'),
        tone: 'primary',
        value: seat.member.muted ? 'unmute' : 'mute',
      })
    }
    actions.push({ label: t('party.leaveSeat'), tone: 'danger', value: 'leave' })
  } else if (!seat.member) {
    if (!seat.locked) {
      actions.push({ label: t('party.takeSeat'), tone: 'primary', value: 'take' })
    }
    if (canManageRoom.value && seat.index > 0) {
      actions.push({ label: t('party.inviteToMic'), tone: 'default', value: 'invite' })
      actions.push({
        label: seat.locked ? t('party.unlockSeat') : t('party.lockSeat'),
        tone: 'default',
        value: seat.locked ? 'unlock' : 'lock',
      })
    }
  }

  if (!actions.length) {
    feedback.warning(seat.locked ? t('party.seatLocked') : t('party.seatOccupied'))
    return
  }

  const choice = await overlay.actionSheet({ actions, cancelLabel: t('common.cancel') })
  if (!choice) return
  if (choice === 'invite') {
    await openSeatInvite(seat)
    return
  }
  if (choice === 'lock' || choice === 'unlock') {
    await moderateSeat(seat, choice)
    return
  }
  if (choice === 'take' && currentSeat.value && currentSeat.value.index !== seat.index) {
    const confirmed = await overlay.confirm({
      message: t('party.changeSeatDescription', {
        from: currentSeat.value.index + 1,
        to: seat.index + 1,
      }),
      title: t('party.changeSeat'),
    })
    if (!confirmed) return
  }
  await handleSeatAction(seat, choice)
}

function openSeat(seat: PartySeat): void {
  selectedSeat.value = seat
  selectedMember.value = seat.member
  if (seat.member && seat.member.id !== currentUserId.value) {
    void selectMember(seat.member)
    return
  }
  if (!seat.member && seat.type === 'video' && !canManageRoom.value) {
    feedback.warning(
      seat.locked
        ? t('party.seatLocked')
        : 'Video seats require an invitation from the Room Owner/Admin.',
    )
    return
  }
  if (!seat.member && seat.type === 'audio' && !canManageRoom.value) {
    if (seat.locked) {
      feedback.warning(t('party.seatLocked'))
      return
    }
    if (currentSeat.value && currentSeat.value.index !== seat.index) void openSeatMenu(seat)
    else void handleSeatAction(seat, 'take')
    return
  }
  void openSeatMenu(seat)
}

function bindVideoSeat(seat: PartySeat, element: Element | null): void {
  const container = element instanceof HTMLElement ? element : null
  if (seat.member?.id === currentUserId.value) {
    rtcRoomEngine.attachLocalVideo(container)
    return
  }
  if (seat.member?.id) rtcRoomEngine.attachVoiceVideo(seat.member.id, container)
}

function bindChatScroller(tab: PartyChatTab, element: Element | null): void {
  if (element instanceof HTMLElement) chatScrollers.set(tab, element)
  else chatScrollers.delete(tab)
}

async function openPanel(value: PartyPanel | null): Promise<void> {
  if (value) closeMemberCard()
  panel.value = value
  const panelRequest = ++panelLoadSequence
  const roomId = snapshot.value?.room.id
  if (!roomId || !value) {
    panelLoading.value = false
    return
  }
  let rankRequest = 0
  panelLoading.value = true
  try {
    if (value === 'audience' || value === 'seat-invite') {
      const latestViewers = await partyRoomOperations.getViewers(roomId)
      if (panelRequest === panelLoadSequence) viewers.value = latestViewers
    } else if (value === 'rank' && !rankResult.value.entries.length) {
      const active = ++rankLoadSequence
      rankRequest = active
      const result = await partyRoomOperations.getRank(
        roomId,
        rankPeriod.value,
        rankKind.value,
        rankScope.value,
      )
      if (active === rankLoadSequence) rankResult.value = result
    } else if (value === 'emoji' && !emojis.value.length)
      emojis.value = await partyRoomOperations.getEmojis(roomId)
    else if (value === 'music') {
      const [settings, songs] = await Promise.all([
        partyRoomOperations.getMusicSettings(roomId),
        Promise.all(
          ([1, 2, 3] as const).map(async (type) =>
            (await partyRoomOperations.getMusic(roomId, type)).map((item) => ({ ...item, type })),
          ),
        ).then((items) => items.flat()),
      ])
      musicSettings.value = settings
      music.value = songs
    } else if (value === 'queue') applyQueueState(await partyRoomOperations.getQueue(roomId))
    else if (value === 'announcement')
      applySnapshot(await partyRoomOperations.getAnnouncement(roomId))
    else if (value === 'background') {
      const [availableBackgrounds, activeBackground] = await Promise.all([
        partyRoomOperations.getBackgrounds(),
        partyRoomOperations.getCurrentBackground(roomId).catch(() => null),
      ])
      if (panelRequest === panelLoadSequence) {
        backgrounds.value = availableBackgrounds
        currentBackground.value = activeBackground
      }
    } else if (
      value === 'mode' &&
      !(['voice', 'live-voice'] as const).every((roomType) =>
        roomTemplates.value.some((template) => template.roomType === roomType),
      )
    ) {
      roomTemplates.value = (
        await Promise.all(
          (['voice', 'live-voice'] as const).map((roomType) =>
            partyRoomOperations.getRoomTemplates(roomType),
          ),
        )
      ).flat()
    } else if (value === 'blacklist')
      blacklist.value = await partyRoomOperations.getBlacklist(roomId)
    else if (value === 'invite') {
      const results = await Promise.allSettled([0, 1, 2].map((index) => loadInviteTab(index, true)))
      const rejected = results.find((result) => result.status === 'rejected')
      if (rejected?.status === 'rejected') throw rejected.reason
    }
  } catch (error) {
    if (panelRequest === panelLoadSequence && (!rankRequest || rankRequest === rankLoadSequence))
      feedback.error(toUserFacingError(error, t('party.updateFailed')))
  } finally {
    if (panelRequest === panelLoadSequence && (!rankRequest || rankRequest === rankLoadSequence))
      panelLoading.value = false
  }
}

async function loadInviteTab(index: number, force = false): Promise<void> {
  if (index < 0 || index > 2) return
  if (!force && (inviteLoadedTabs.value[index] || inviteLoadingTabs.value[index])) return
  const roomId = snapshot.value?.room.id
  if (!roomId) return

  inviteLoadingTabs.value = inviteLoadingTabs.value.map((value, tabIndex) =>
    tabIndex === index ? true : value,
  )
  try {
    if (index === 0) {
      const page = await new HttpMessageGateway().listConversations('0', 100)
      inviteConversations.value = page.items
    } else {
      const members = await partyRoomOperations.getInviteCandidates(roomId, index === 1 ? 0 : 1)
      if (index === 1) inviteCandidates.value = members
      else inviteFollowers.value = members
    }
    inviteLoadedTabs.value = inviteLoadedTabs.value.map((value, tabIndex) =>
      tabIndex === index ? true : value,
    )
  } finally {
    inviteLoadingTabs.value = inviteLoadingTabs.value.map((value, tabIndex) =>
      tabIndex === index ? false : value,
    )
  }
}

async function loadInviteTabFromSwipe(index: number): Promise<void> {
  try {
    await loadInviteTab(index)
  } catch (error) {
    feedback.error(toUserFacingError(error, t('party.updateFailed')))
  }
}

async function reloadRank(options?: {
  append?: boolean
  kind?: PartyRoomRankKind
  period?: PartyRankingPeriod
  scope?: PartyRankingScope
}): Promise<void> {
  const roomId = snapshot.value?.room.id
  if (!roomId) return
  const nextKind = options?.kind ?? rankKind.value
  const append = options?.append === true
  let nextPeriod = options?.period ?? rankPeriod.value
  const nextScope = options?.scope ?? rankScope.value
  if (nextKind === 'honor' && nextPeriod === 'month') nextPeriod = 'day'
  const offset = append ? rankResult.value.entries.at(-1)?.score : undefined
  const requestKey = `${roomId}:${nextKind}:${nextPeriod}:${nextScope}:${append ? (offset ?? '') : 'first'}`
  if (rankPendingRequestKey === requestKey) return
  if (
    nextKind === rankKind.value &&
    nextPeriod === rankPeriod.value &&
    nextScope === rankScope.value &&
    rankResult.value.entries.length &&
    !append
  )
    return
  const active = ++rankLoadSequence
  rankKind.value = nextKind
  rankPeriod.value = nextPeriod
  rankScope.value = nextScope
  rankPendingRequestKey = requestKey
  panelLoading.value = true
  try {
    const result = await partyRoomOperations.getRank(
      roomId,
      nextPeriod,
      nextKind,
      nextScope,
      offset,
    )
    if (active === rankLoadSequence) {
      if (append) {
        const known = new Set(rankResult.value.entries.map((entry) => entry.member.id))
        const unique = result.entries.filter((entry) => !known.has(entry.member.id))
        rankResult.value = {
          ...result,
          entries: [...rankResult.value.entries, ...unique],
          finished: result.finished || unique.length === 0,
          myRank: result.myRank ?? rankResult.value.myRank,
        }
      } else rankResult.value = result
    }
  } catch (error) {
    if (active === rankLoadSequence)
      feedback.error(toUserFacingError(error, t('party.updateFailed')))
  } finally {
    if (rankPendingRequestKey === requestKey) rankPendingRequestKey = ''
    if (active === rankLoadSequence) panelLoading.value = false
  }
}

function openHeaderRank(): void {
  rankKind.value = headerMetric.value
  void openPanel('rank')
}

async function handleSeatAction(
  seat: PartySeat,
  action: 'leave' | 'mute' | 'take' | 'unmute',
): Promise<void> {
  if (seatPending.value) return
  seatPending.value = true
  panel.value = null
  try {
    await withBlockingRequest(async () => {
      if (action === 'take') {
        if (!currentSeat.value && !realtimeEnabled) await requestMicrophoneAccess()
        else if (!partyRoomOperations.managesCommunication()) await startMicrophone()
        try {
          const next = await partyRoomOperations.takeSeat(props.context.roomId, seat.index)
          applySnapshot(next)
          const confirmed = next.room.seats.some(
            (item) => item.index === seat.index && item.member?.id === currentUserId.value,
          )
          if (!confirmed && next.room.onSeatApplyEnabled) {
            applyQueueState(
              await partyRoomOperations.getQueue(props.context.roomId).catch(() => queue.value),
            )
            feedback.success('Mic application submitted')
          } else if (confirmed)
            applyQueueState(
              await partyRoomOperations.getQueue(props.context.roomId).catch(() => ({
                ...queue.value,
                myIndex: 0,
              })),
            )
        } catch (error) {
          stopMicrophone()
          throw error
        }
      } else if (action === 'leave') {
        if (!partyRoomOperations.managesCommunication()) stopMicrophone()
        applySnapshot(await partyRoomOperations.leaveSeat(props.context.roomId))
      } else {
        microphoneStream.value
          ?.getAudioTracks()
          .forEach((track) => (track.enabled = action === 'unmute'))
        applySnapshot(
          await partyRoomOperations.moderateSeat(props.context.roomId, seat.index, action),
        )
      }
    })
  } catch (error) {
    feedback.error(toUserFacingError(error, t('party.seatUpdateFailed')))
  } finally {
    seatPending.value = false
  }
}

async function moderateSeat(
  seat: PartySeat,
  action: 'kick' | 'lock' | 'mute' | 'unlock' | 'unmute',
): Promise<void> {
  if (seatPending.value) return
  seatPending.value = true
  closeMemberCard()
  try {
    applySnapshot(
      await withBlockingRequest(() =>
        partyRoomOperations.moderateSeat(props.context.roomId, seat.index, action),
      ),
    )
  } catch (error) {
    feedback.error(toUserFacingError(error, t('party.seatUpdateFailed')))
  } finally {
    seatPending.value = false
  }
}

async function setSeatMedia(
  seat: PartySeat,
  media: 'camera' | 'microphone',
  enabled: boolean,
): Promise<void> {
  if (seatPending.value) return
  seatPending.value = true
  try {
    applySnapshot(
      await withBlockingRequest(() =>
        partyRoomOperations.setSeatMedia(props.context.roomId, seat.index, media, enabled),
      ),
    )
    panel.value = null
  } catch (error) {
    feedback.error(toUserFacingError(error, t('party.seatUpdateFailed')))
  } finally {
    seatPending.value = false
  }
}

async function openSeatInvite(seat: PartySeat): Promise<void> {
  selectedSeat.value = seat
  await openPanel('seat-invite')
}

async function holdMemberOnSeat(seat: PartySeat, member: PartyMember): Promise<void> {
  if (seatPending.value) return
  seatPending.value = true
  try {
    applySnapshot(
      await withBlockingRequest(() =>
        partyRoomOperations.holdMemberOnSeat(props.context.roomId, seat.index, member),
      ),
    )
    panel.value = null
  } catch (error) {
    feedback.error(toUserFacingError(error, t('party.seatUpdateFailed')))
  } finally {
    seatPending.value = false
  }
}

async function saveAnnouncement(value: string): Promise<void> {
  try {
    applySnapshot(
      await withBlockingRequest(() =>
        partyRoomOperations.setAnnouncement(props.context.roomId, value),
      ),
    )
    panel.value = null
    feedback.success(t('party.announcementUpdated'))
  } catch (error) {
    feedback.error(toUserFacingError(error, t('party.updateFailed')))
  }
}

function selectMember(member: PartyMember): void {
  selectedMember.value = member
  selectedSeat.value =
    snapshot.value?.room.seats.find((seat) => seat.member?.id === member.id) ?? null
  memberCardOpen.value = true
  // 快捷礼物目录独立加载，不能阻塞资料卡的 SAPI 请求与错误重试。
  void loadGiftCatalog()
}

function closeMemberCard(): void {
  memberCardOpen.value = false
}

async function toggleRoomLock(locked: boolean, password?: string): Promise<void> {
  try {
    applySnapshot(
      await withBlockingRequest(() =>
        partyRoomOperations.setRoomLock(props.context.roomId, locked, password),
      ),
    )
    panel.value = null
  } catch (error) {
    feedback.error(toUserFacingError(error, t('party.updateFailed')))
  }
}

async function toggleSeatApplications(enabled: boolean): Promise<void> {
  const accountId = session.user?.id ?? ''
  const confirmationKey = `party:mic-application:${enabled ? 'on' : 'off'}`
  const confirmedBefore = accountPreferences.get(accountId, confirmationKey) === '1'
  if (!confirmedBefore) {
    const confirmed = await overlay.confirm({
      cancelButtonText: t('party.cancel'),
      confirmButtonText: enabled ? 'turn on' : 'turn off',
      message: enabled
        ? 'With Mic Application turned on, the owner and admins can view the users who want to speak and invite them to take the mic.'
        : 'The users in the application list will be cleared after turning off. Audience can join the guest seat anytime to chat together. Are you sure to turn off?',
      title: 'Tips',
    })
    if (!confirmed) return
    accountPreferences.set(accountId, confirmationKey, '1')
  }
  try {
    applySnapshot(
      await withBlockingRequest(() =>
        partyRoomOperations.setOnSeatApplyEnabled(props.context.roomId, enabled),
      ),
    )
    panel.value = null
  } catch (error) {
    feedback.error(toUserFacingError(error, t('party.updateFailed')))
  }
}

async function setRoomBackground(background: PartyBackground): Promise<void> {
  try {
    applySnapshot(
      await withBlockingRequest(() =>
        partyRoomOperations.setBackground(props.context.roomId, background),
      ),
    )
    currentBackground.value = background
    panel.value = null
  } catch (error) {
    feedback.error(toUserFacingError(error, t('party.updateFailed')))
  }
}

async function setRoomTemplate(template: PartyRoomTemplate): Promise<void> {
  const occupiedSeats = snapshot.value?.room.seats.filter((seat) => seat.member).length ?? 0
  if (occupiedSeats > 1) {
    const confirmed = await overlay.confirm({
      cancelButtonText: t('party.cancel'),
      confirmButtonText: t('common.confirm'),
      message: 'All members on stage will leave the mic after changing the room mode.',
      title: 'Tips',
    })
    if (!confirmed) return
  }
  try {
    applySnapshot(
      await withBlockingRequest(() =>
        partyRoomOperations.setRoomTemplate(props.context.roomId, template),
      ),
    )
    panel.value = null
  } catch (error) {
    feedback.error(toUserFacingError(error, t('party.updateFailed')))
  }
}

async function toggleRoomMusic(enabled: boolean): Promise<void> {
  try {
    await withBlockingRequest(() =>
      partyRoomOperations.setMusicEnabled(props.context.roomId, enabled),
    )
    musicSettings.value = musicSettings.value
      ? { ...musicSettings.value, enabled, playing: enabled && musicSettings.value.playing }
      : {
          currentSongId: '',
          enabled,
          muted: false,
          playMode: 1,
          playing: false,
          positionSeconds: 0,
          songName: '',
          volume: 100,
        }
    panel.value = enabled ? 'music' : null
    if (enabled) await openPanel('music')
  } catch (error) {
    feedback.error(toUserFacingError(error, t('party.updateFailed')))
  }
}

async function approveQueue(entry: PartyQueueEntry): Promise<void> {
  try {
    await withBlockingRequest(async () => {
      applySnapshot(await partyRoomOperations.approveQueueEntry(props.context.roomId, entry))
      applyQueueState(await partyRoomOperations.getQueue(props.context.roomId))
    })
  } catch (error) {
    feedback.error(toUserFacingError(error, t('party.updateFailed')))
  }
}

async function refuseQueue(entry: PartyQueueEntry): Promise<void> {
  try {
    await withBlockingRequest(async () => {
      applySnapshot(await partyRoomOperations.refuseQueueEntry(props.context.roomId, entry))
      applyQueueState(await partyRoomOperations.getQueue(props.context.roomId))
    })
  } catch (error) {
    feedback.error(toUserFacingError(error, t('party.updateFailed')))
  }
}

async function cancelQueue(): Promise<void> {
  try {
    await withBlockingRequest(async () => {
      applySnapshot(await partyRoomOperations.cancelSeatApplication(props.context.roomId))
      applyQueueState(await partyRoomOperations.getQueue(props.context.roomId))
    })
    panel.value = null
  } catch (error) {
    feedback.error(toUserFacingError(error, t('party.updateFailed')))
  }
}

async function inviteMembers(members: PartyMember[]): Promise<void> {
  const room = snapshot.value?.room
  if (!room) return
  const now = Date.now()
  const availableMembers = members.filter(
    (member) => (inviteCooldowns.value[member.imAccount] ?? 0) <= now,
  )
  if (!availableMembers.length) return
  try {
    await withBlockingRequest(() =>
      partyRoomOperations.inviteMembers(
        props.context.roomId,
        availableMembers.map((member) => member.imAccount),
      ),
    )
    const expiresAt = now + room.inviteIntervalSeconds * 1_000
    inviteCooldowns.value = {
      ...inviteCooldowns.value,
      ...Object.fromEntries(availableMembers.map((member) => [member.imAccount, expiresAt])),
    }
    panel.value = null
    feedback.success('Invitation sent')
  } catch (error) {
    feedback.error(toUserFacingError(error, t('party.updateFailed')))
  }
}

async function setMemberAdmin(member: PartyMember, admin: boolean): Promise<void> {
  try {
    await withBlockingRequest(() =>
      partyRoomOperations.setMemberAdmin(props.context.roomId, member, admin),
    )
    selectedMember.value = { ...member, roomRole: admin ? 'admin' : 'member' }
    feedback.success(admin ? 'Admin set' : 'Admin removed')
  } catch (error) {
    feedback.error(toUserFacingError(error, t('party.updateFailed')))
  }
}

function applyMemberFollowed(member: PartyMember, followed: boolean): void {
  if (selectedMember.value?.id === member.id)
    selectedMember.value = { ...selectedMember.value, followed }
  if (snapshot.value && member.id === snapshot.value.room.owner.id) {
    snapshot.value.room.owner = { ...snapshot.value.room.owner, followed }
    snapshot.value.room.followed = followed
    snapshot.value = structuredClone(snapshot.value)
  }
}

function syncMemberCardFollowed(member: PartyMember, followed: boolean): void {
  applyMemberFollowed(member, followed)
}

async function setMemberFollowed(member: PartyMember, followed: boolean): Promise<void> {
  if (member.userType !== 2 && member.userType !== 3) {
    feedback.warning('Only hosts can be followed.')
    return
  }
  const previous = relationships.relationship(member.id, {
    followed: member.followed,
    followedKnown: true,
    userType: member.userType,
  }).followed
  applyMemberFollowed(member, followed)
  try {
    await withBlockingRequest(() =>
      relationships.setFollowed(
        { imAccount: member.imAccount, userId: member.id, userType: member.userType },
        followed,
      ),
    )
    feedback.success(followed ? 'Follow Success' : 'Cancel Success')
  } catch (error) {
    applyMemberFollowed(member, previous)
    feedback.error(toUserFacingError(error, t('party.updateFailed')))
  }
}

async function kickMember(member: PartyMember, banType: 1 | 2): Promise<void> {
  const confirmed = await overlay.confirm({
    cancelButtonText: t('common.cancel'),
    confirmButtonText: t('common.confirm'),
    message: `${t('party.kickConfirmTitle', { name: member.displayName })}\n${
      banType === 2 ? t('party.kickPermanentDescription') : t('party.kickTemporaryDescription')
    }`,
    title: t('common.confirm'),
  })
  if (!confirmed) return

  try {
    applySnapshot(
      await withBlockingRequest(() =>
        partyRoomOperations.kickMember(props.context.roomId, member, banType),
      ),
    )
    closeMemberCard()
    feedback.success('User removed')
  } catch (error) {
    feedback.error(toUserFacingError(error, t('party.updateFailed')))
  }
}

async function removeBlacklist(member: PartyMember): Promise<void> {
  const confirmed = await overlay.confirm({
    cancelButtonText: t('common.cancel'),
    confirmButtonText: t('common.confirm'),
    message: t('party.removeBlockConfirm', { name: member.displayName }),
    title: t('common.confirm'),
  })
  if (!confirmed) return

  try {
    await withBlockingRequest(() =>
      partyRoomOperations.removeFromBlacklist(props.context.roomId, member),
    )
    blacklist.value = blacklist.value.filter((item) => item.member.id !== member.id)
  } catch (error) {
    feedback.error(toUserFacingError(error, t('party.updateFailed')))
  }
}

function openMemberMessage(member: PartyMember): void {
  panel.value = null
  closeMemberCard()
  const imAccount = member.imAccount.trim() || member.id
  if (!member.id) {
    feedback.error(t('room.messageUnavailable'))
    return
  }
  const conversation = messagesStore.getConversationByAccount(imAccount)
  showMessages.value = false
  messageConversationTarget.value = {
    avatarUrl: member.avatarUrl,
    conversationId: conversation?.conversationId || imAccount,
    displayName: member.displayName,
    imAccount,
    userId: member.id,
  }
}

function openMemberProfile(member: PartyMember): void {
  void member
  panel.value = null
  closeMemberCard()
}

async function openGifts(member?: PartyMember): Promise<void> {
  const room = snapshot.value?.room
  if (!room) return
  preferredGiftReceiverId.value = member?.id ?? ''
  panel.value = null
  closeMemberCard()
  giftPanel.value = true
  await loadGiftCatalog()
}

async function loadGiftCatalog(silent = false): Promise<void> {
  const room = snapshot.value?.room
  if (!room || gifts.value.length || giftLoading.value) return
  giftLoading.value = true
  giftFailed.value = false
  try {
    const catalog = await partyRoomOperations.getGiftCatalog(room.id)
    gifts.value = catalog.gifts
    giftCountChoices.value = catalog.counts.length ? catalog.counts : [1, 5, 10, 99]
    if (catalog.balance !== session.balance) await session.updateBalance(catalog.balance)
  } catch {
    giftFailed.value = true
    if (!silent) feedback.error(t('party.giftsUnavailable'))
  } finally {
    giftLoading.value = false
  }
}

async function sendQuickGift(member: PartyMember, gift: GiftItem): Promise<void> {
  const confirmed = await overlay.confirm({
    cancelButtonText: t('common.cancel'),
    confirmButtonText: t('common.confirm'),
    message: `Send ${gift.name} to ${member.displayName}?`,
  })
  if (!confirmed) return
  await sendGift(gift, 1, [member.imAccount || member.id], [member.id], async () => {
    closeMemberCard()
    await new Promise<void>((resolve) => window.setTimeout(resolve, 320))
  })
}

async function sendEmoji(emoji: PartyEmojiItem): Promise<void> {
  try {
    applySnapshot(await partyRoomOperations.sendEmoji(props.context.roomId, emoji))
  } catch (error) {
    feedback.error(toUserFacingError(error, t('party.messageFailed')))
  }
}

function finishSeatExpression(seat: PartySeat): void {
  if (!seat.member || !seat.emojiUrl) return
  void partyRoomOperations.dismissEmoji(props.context.roomId, seat.member.id, seat.emojiUrl)
}

async function playMusic(item: PartyMusicItem): Promise<void> {
  if (musicControlPending.value) return
  const previous = musicSettings.value
  const optimistic: PartyMusicSettings = {
    currentSongId: item.id,
    enabled: true,
    muted: previous?.muted ?? false,
    playMode: previous?.playMode ?? 1,
    playing: true,
    positionSeconds: previous?.currentSongId === item.id ? previous.positionSeconds : 0,
    songName: item.name,
    url: item.url,
    volume: previous?.volume ?? 100,
  }
  musicControlPending.value = true
  musicSettings.value = optimistic
  try {
    await withBlockingRequest(() => partyRoomOperations.playMusic(props.context.roomId, item))
    await nextTick()
    await startSimulatedRoomAudio()
  } catch (error) {
    if (musicSettings.value === optimistic) musicSettings.value = previous
    feedback.error(toUserFacingError(error, t('party.updateFailed')))
  } finally {
    musicControlPending.value = false
  }
}

async function pauseMusic(): Promise<void> {
  if (musicControlPending.value || !musicSettings.value) return
  const previous = musicSettings.value
  const optimistic = { ...previous, playing: false }
  musicControlPending.value = true
  musicSettings.value = optimistic
  try {
    await withBlockingRequest(() => partyRoomOperations.pauseMusic(props.context.roomId))
    pauseSimulatedRoomAudio()
  } catch (error) {
    if (musicSettings.value === optimistic) musicSettings.value = previous
    feedback.error(toUserFacingError(error, t('party.updateFailed')))
  } finally {
    musicControlPending.value = false
  }
}

async function uploadMusic(files: File[]): Promise<void> {
  if (musicUploadController) return
  if (files.some((file) => file.size > 10 * 1024 * 1024)) {
    feedback.warning('Each music file must be 10 MB or smaller.')
    return
  }
  const controller = new AbortController()
  musicUploadController = controller
  try {
    await withBlockingRequest(() =>
      partyRoomOperations.uploadMusic(props.context.roomId, files, controller.signal),
    )
    const uploaded = await partyRoomOperations.getMusic(props.context.roomId, 3)
    music.value = [...music.value.filter((item) => item.type !== 3), ...uploaded]
    feedback.success('Music uploaded')
  } catch (error) {
    if (controller.signal.aborted) return
    feedback.error(toUserFacingError(error, t('party.updateFailed')))
  } finally {
    if (musicUploadController === controller) musicUploadController = null
  }
}

async function toggleMusicLike(item: PartyMusicItem): Promise<void> {
  try {
    const liked = !item.liked
    await withBlockingRequest(() => partyRoomOperations.setMusicLiked(item, liked))
    const updated = music.value
      .filter((value) => !(value.id === item.id && value.type === 2))
      .map((value) => (value.id === item.id ? { ...value, liked } : value))
    music.value = liked ? [...updated, { ...item, liked: true, type: 2 }] : updated
  } catch (error) {
    feedback.error(toUserFacingError(error, t('party.updateFailed')))
  }
}

async function updateMusicPlayback(options: {
  playMode?: 1 | 2 | 3
  volume?: number
}): Promise<void> {
  const settings = musicSettings.value
  if (!settings?.currentSongId || musicControlPending.value) return
  const optimistic: PartyMusicSettings = {
    ...settings,
    playMode: options.playMode ?? settings.playMode,
    volume: options.volume ?? settings.volume,
  }
  musicControlPending.value = true
  musicSettings.value = optimistic
  try {
    await withBlockingRequest(() =>
      partyRoomOperations.updateMusicSettings(props.context.roomId, {
        playMode: optimistic.playMode,
        volume: optimistic.volume,
      }),
    )
  } catch (error) {
    if (musicSettings.value === optimistic) musicSettings.value = settings
    feedback.error(toUserFacingError(error, t('party.updateFailed')))
  } finally {
    musicControlPending.value = false
  }
}

async function toggleSound(): Promise<void> {
  if (!realtimeEnabled) {
    const audio = simulatedRoomAudio.value
    if (!audio) return
    if (simulatedAudioNeedsGesture.value || audio.paused || !soundEnabled.value) {
      soundEnabled.value = true
      await startSimulatedRoomAudio()
      if (simulatedAudioNeedsGesture.value)
        feedback.warning('Tap the sound button again to play audio.')
      return
    }
    soundEnabled.value = false
    simulatedAudioNeedsGesture.value = false
    pauseSimulatedRoomAudio()
    return
  }
  const next = !soundEnabled.value
  try {
    await withBlockingRequest(() => partyRoomOperations.setSoundEnabled(next))
    soundEnabled.value = next
  } catch (error) {
    feedback.error(toUserFacingError(error, t('party.updateFailed')))
  }
}

async function sendGift(
  gift: GiftItem,
  count: number,
  receiverImAccounts: string[],
  receiverIds: string[],
  beforeEffect?: () => Promise<void>,
): Promise<boolean> {
  const now = Date.now()
  if (giftSending.value || now - lastGiftSentAt < 1_500) return false
  lastGiftSentAt = now
  const outcome = await runGiftSend(async () => {
    const result = await partyRoomOperations.sendGift(props.context.roomId, {
      availableQuantity: gift.quantity,
      count,
      giftType: gift.partyGiftType,
      giftId: gift.id,
      giftName: gift.name,
      iconUrl: gift.iconUrl,
      animationUrl: gift.animationUrl,
      mysteryBox: gift.partyMysteryBox,
      price: gift.price,
      receiverImAccounts,
      receiverIds,
      receivers: giftReceivers.value
        .filter((member) => receiverIds.includes(member.id))
        .map((member) => ({
          avatarUrl: member.avatarUrl,
          id: member.id,
          name: member.displayName,
        })),
      source: gift.source,
    })
    if (result.balance !== session.balance) await session.updateBalance(result.balance)
    if (tornDown) return result
    applySnapshot(result.snapshot)
    if (gift.source === 'backpack')
      gifts.value = gifts.value
        .map((item) =>
          item.source === 'backpack' && item.id === gift.id
            ? {
                ...item,
                quantity: Math.max(
                  0,
                  (item.quantity ?? 0) - count * Math.max(1, new Set(receiverIds).size),
                ),
              }
            : item,
        )
        .filter((item) => item.source !== 'backpack' || (item.quantity ?? 0) > 0)
    await closeGiftAfterSend()
    await beforeEffect?.()
    return result
  })
  if (outcome.status === 'failed') {
    if (isGiftBalanceError(outcome.cause))
      requestRecharge({
        requiredDiamonds:
          gift.price * count * Math.max(1, new Set(receiverIds.filter(Boolean)).size),
        selection: null,
      })
    else feedback.error(outcome.cause)
    return false
  }
  if (outcome.status !== 'sent') return false
  if (tornDown) return true
  const result = outcome.value
  const currentMember = [
    result.snapshot.room.owner,
    ...result.snapshot.room.seats.flatMap((seat) => (seat.member ? [seat.member] : [])),
  ].find((member) => member.id === currentUserId.value)
  const receivers = giftReceivers.value
    .filter((member) => receiverIds.includes(member.id))
    .map((member) => ({
      avatarUrl: member.avatarUrl,
      id: member.id,
      name: member.displayName,
    }))
  if (roomEffectsActive.value)
    roomEffects.value?.enqueueGiftMedia(
      {
        createdAt: Date.now(),
        effectUrl: gift.animationUrl,
        giftCount: count,
        giftIconUrl: gift.iconUrl,
        giftName: gift.name,
        giftReceiverIds: receiverIds,
        id: `party:self:${props.context.roomId}:${++giftSendSequence}`,
        presentation: {
          kind: 'gift',
          mysteryBox: gift.partyMysteryBox === true,
          receivers,
          senderHeadFrameUrl: currentMember?.headFrameSmallUrl ?? '',
          senderMedalUrls: [...(currentMember?.medals ?? [])],
          senderUserType: currentMember?.userType,
          variant: gift.partyGiftType === 8 ? 'named' : 'standard',
        },
        senderAvatarUrl: currentMember?.avatarUrl ?? session.user?.avatar ?? '',
        senderId: currentUserId.value,
        senderLevel: currentMember?.level,
        senderName: currentMember?.displayName ?? session.user?.displayName ?? '',
        senderVip: currentMember?.vip,
        text: `sent ${gift.name}`,
        type: 'gift',
      },
      `self:${props.context.roomId}:${giftSendSequence}`,
    )
  if (result.luckyGift) {
    if (result.luckyGift.won)
      feedback.success(
        `Lucky gift reward: ${result.luckyGift.totalReward.toLocaleString()} diamonds`,
      )
    else feedback.notify(`Lucky gift draws: ${result.luckyGift.draws}`)
  }
  return true
}

function closeGiftAfterSend(): Promise<void> {
  if (!giftPanel.value) return Promise.resolve()
  return new Promise((resolve) => {
    window.clearTimeout(giftCloseTimer)
    resolveGiftClose?.()
    resolveGiftClose = resolve
    giftPanel.value = false
    giftCloseTimer = window.setTimeout(finishGiftCloseWait, 600)
  })
}

function finishGiftCloseWait(): void {
  window.clearTimeout(giftCloseTimer)
  giftCloseTimer = 0
  const resolve = resolveGiftClose
  resolveGiftClose = undefined
  resolve?.()
}

function requestRecharge(request: GiftPanelRechargeRequest): void {
  emit('recharge', {
    originKey: giftEffectOwner(),
    requiredDiamonds: request.requiredDiamonds,
    source: 'party',
  })
}

function reportRoom(): void {
  panel.value = null
  emit('report', { hostId: snapshot.value?.room.owner.id ?? '', roomId: props.context.roomId })
}

watch(chatTab, () => scrollToBottom())
watch(
  () => snapshot.value?.communication.state,
  (communicationState) => {
    if (communicationState === 'connected') restoreMicrophoneAfterCommunication()
  },
)

onMounted(() => {
  headerMetricTimer = window.setInterval(() => {
    headerMetric.value = headerMetric.value === 'contribution' ? 'honor' : 'contribution'
  }, 5_000)
  stopRecoveryParticipant = applicationRecoveryCoordinator.register({
    id: `party-room:${props.context.roomId}`,
    priority: 10,
    onNetworkLost: suspendForApplicationBackground,
    onRecover: recoverFromApplicationActivity,
    onSuspend: suspendForApplicationBackground,
  })
  void load()
})
onBeforeUnmount(() => {
  window.clearInterval(headerMetricTimer)
  pauseSimulatedRoomAudio()
  stopRecoveryParticipant?.()
  stopRecoveryParticipant = undefined
  presentation.unregisterRoomLifecycle(lifecycleOwner)
  finishGiftCloseWait()
  void teardown()
})
</script>

<template>
  <main class="party-room-shell">
    <section
      v-if="loading"
      class="party-room__entry-loading"
      role="status"
      aria-live="polite"
      aria-label="Loading"
    >
      <AppLoadLoadingIcon animated :size="60" />
    </section>
    <AppStateView
      v-else
      :description="failed ? t('party.loadingEnterHint') : ''"
      :state="state"
      :title="failed ? t('party.loadingEnterFailed') : ''"
      @retry="load"
    >
      <div v-if="snapshot" class="party-room" :style="roomBackground">
        <PartyRoomBackground
          :active="roomBackgroundPlaybackActive"
          :source="snapshot.room.backgroundUrl"
        />
        <audio
          v-if="!realtimeEnabled && simulatedRoomAudioSource"
          ref="simulatedRoomAudio"
          class="party-room__simulated-audio"
          :loop="musicSettings?.playMode === 2"
          playsinline
          preload="auto"
          :src="simulatedRoomAudioSource"
          @pause="stopSimulatedSpeaking"
          @play="startSimulatedSpeaking"
        ></audio>
        <PartyRoomEffects ref="roomEffects" :active="roomEffectsActive" />
        <div v-if="connectionNoticeVisible" class="party-room__connection" role="status">
          <span>{{ t('party.roomConnectionFailed') }}</span>
          <button type="button" @click="retryCommunication">
            {{ t('party.retryConnection') }}
          </button>
        </div>
        <header class="party-room__header">
          <div class="party-room__header-main">
            <button
              class="party-room__host"
              type="button"
              @click="selectMember(snapshot.room.owner)"
            >
              <AppAvatar
                :size="36"
                :src="snapshot.room.owner.avatarUrl || snapshot.room.coverUrl"
              />
            </button>
            <div class="party-room__identity">
              <strong>{{ snapshot.room.title }}</strong>
              <span>{{ t('party.roomId', { id: snapshot.room.id }) }}</span>
            </div>
            <button
              v-if="snapshot.room.owner.id !== currentUserId"
              class="party-room__follow"
              :class="{ 'is-following': ownerFollowed }"
              type="button"
              :aria-busy="ownerFollowPending"
              :aria-label="ownerFollowed ? t('room.unfollow') : t('room.follow')"
              :disabled="ownerFollowPending"
              @click="setMemberFollowed(snapshot.room.owner, !ownerFollowed)"
            >
              <img
                :src="
                  publicAsset(
                    ownerFollowed
                      ? 'live-room/legacy/followed.webp'
                      : 'live-room/legacy/follow.webp',
                  )
                "
                alt=""
              />
            </button>
            <span class="party-room__header-spacer" />
            <button
              v-if="!realtimeEnabled"
              class="party-room__sound"
              type="button"
              :class="{ 'needs-gesture': simulatedAudioNeedsGesture }"
              :aria-label="
                soundEnabled && !simulatedAudioNeedsGesture ? 'Mute room sound' : 'Play room sound'
              "
              @click="toggleSound"
            >
              <img
                class="party-room__header-icon"
                :src="
                  publicAsset(
                    soundEnabled && !simulatedAudioNeedsGesture
                      ? 'party/room/icon_sound.png'
                      : 'party/room/icon_close_sound.png',
                  )
                "
                alt=""
              />
            </button>
            <button
              type="button"
              :aria-label="t('party.announcement')"
              @click="openPanel('announcement')"
            >
              <img
                class="party-room__header-icon"
                :src="publicAsset('party/room/icon_report.png')"
                alt=""
              />
            </button>
            <button type="button" aria-label="Share" @click="openPanel('invite')">
              <img
                class="party-room__header-icon"
                :src="publicAsset('party/room/icon_share.png')"
                alt=""
              />
            </button>
            <button
              v-if="canManageRoom"
              type="button"
              :aria-label="t('party.manage')"
              @click="panel = 'manage'"
            >
              <img
                class="party-room__header-icon"
                :src="publicAsset('party/room/icon_setting.png')"
                alt=""
              />
            </button>
            <button type="button" :aria-label="t('party.more')" @click="panel = 'more'">
              <img
                class="party-room__header-icon"
                :src="publicAsset('party/room/icon_more.png')"
                alt=""
              />
            </button>
          </div>
          <div class="party-room__header-meta">
            <button type="button" @click="openHeaderRank">
              <img :src="publicAsset('party/room/icon_rank.png')" alt="" />
              <span class="party-room__metric">
                <Transition name="party-header-metric" mode="out-in">
                  <b :key="headerMetric">{{ headerMetricValue.toLocaleString() }}</b>
                </Transition>
              </span>
              <img
                class="party-room__meta-arrow"
                :src="publicAsset('party/room/icon_right_yellow.png')"
                alt=""
              />
            </button>
            <span />
            <button v-if="snapshot.room.memberCount" type="button" @click="openPanel('audience')">
              <img :src="publicAsset('party/room/icon_online_user.png')" alt="" />
              <span>{{ snapshot.room.memberCount }}</span>
              <img
                class="party-room__meta-arrow"
                :src="publicAsset('party/room/icon_right_gray.png')"
                alt=""
              />
            </button>
          </div>
        </header>

        <section
          v-if="videoSeats.length"
          class="party-room__video-stage"
          :class="{
            'is-six': videoSeats.length === 6,
            'is-six-only': videoSeats.length === 6 && !audioSeats.length,
            'is-single': videoSeats.length === 1,
          }"
          :aria-label="t('party.voiceSeats')"
        >
          <button
            v-for="{ presentation: seatPresentation, seat } in videoSeatViews"
            :key="seat.index"
            :aria-label="t('party.seat', { index: seat.index + 1 })"
            :class="{
              'is-speaking': seat.speaking,
            }"
            :disabled="seatPending"
            type="button"
            @click="openSeat(seat)"
          >
            <span
              class="party-room__video-surface"
              :class="{ 'is-empty': !seatPresentation.occupied }"
            >
              <span
                v-if="seatPresentation.mode === 'camera-on'"
                :ref="(element) => bindVideoSeat(seat, element as Element | null)"
                class="party-room__video-track"
              />
              <span
                v-else-if="seatPresentation.mode === 'camera-off' && seat.member"
                class="party-room__camera-off"
                :class="{ 'is-host': seat.host }"
              >
                <span class="party-room__camera-off-avatar">
                  <PartySpeakingFrames v-if="seatPresentation.showSpeakingFrame" />
                  <AppAvatar :size="52" :src="seat.member.avatarUrl" />
                  <img
                    class="party-room__camera-off-mask"
                    :src="publicAsset('party/room/icon_close_camera_px104.png')"
                    alt=""
                  />
                  <img
                    v-if="seatPresentation.hostBorder"
                    class="party-room__video-host-border"
                    :src="publicAsset('party/room/border_mc.webp')"
                    alt=""
                  />
                </span>
              </span>
              <span v-else class="party-room__video-placeholder">
                <img
                  class="party-room__video-placeholder-image"
                  :src="
                    publicAsset(
                      seatPresentation.mode === 'locked'
                        ? 'party/room/icon_mic_locked_.png'
                        : 'party/room/icon_video_no_people.png',
                    )
                  "
                  alt=""
                />
                <span v-if="seatPresentation.showIndex" class="party-room__video-index">{{
                  seat.index + 1
                }}</span>
                <img
                  v-if="seatPresentation.hostBadge === 'placeholder'"
                  class="party-room__video-host-result is-placeholder"
                  :src="publicAsset('party/room/icon_mic_mc_result.webp')"
                  alt=""
                />
                <img
                  v-if="seatPresentation.hostBorder"
                  class="party-room__video-host-border"
                  :src="publicAsset('party/room/border_mc.webp')"
                  alt=""
                />
              </span>
              <template v-if="seatPresentation.hostWings">
                <img
                  class="party-room__video-host-wing is-left"
                  :class="{ 'is-muted': seatPresentation.hostWingsMuted }"
                  :src="publicAsset('party/room/icon_mic_zs_left.webp')"
                  alt=""
                />
                <img
                  class="party-room__video-host-wing is-right"
                  :class="{ 'is-muted': seatPresentation.hostWingsMuted }"
                  :src="publicAsset('party/room/icon_mic_zs_right.webp')"
                  alt=""
                />
              </template>
              <span
                v-if="seatPresentation.occupied && seat.member"
                class="party-room__video-member"
              >
                <span class="party-room__video-member-info">
                  <strong>{{ seat.member.displayName }}</strong>
                  <img
                    v-if="seatPresentation.showRoleBadge"
                    class="party-room__video-role"
                    :src="
                      publicAsset(
                        `party/room/icon_lv_${seat.member.roomRole === 'owner' ? 1 : 2}.png`,
                      )
                    "
                    alt=""
                  />
                </span>
                <img
                  v-if="seatPresentation.microphoneDisabled"
                  class="party-room__video-muted"
                  :src="publicAsset('party/room/icon_microphone.png')"
                  alt=""
                />
              </span>
              <span v-if="seatPresentation.showGiftFooter" class="party-room__video-gift">
                <img :src="publicAsset('party/room/icon_gem.webp')" alt="" />{{ seat.giftValue }}
              </span>
              <img
                v-if="
                  seatPresentation.hostBadge === 'camera-off' ||
                  seatPresentation.hostBadge === 'camera-on'
                "
                class="party-room__video-host-result"
                :class="`is-${seatPresentation.hostBadge}`"
                :src="publicAsset('party/room/icon_mic_mc_result.webp')"
                alt=""
              />
            </span>
          </button>
        </section>

        <section
          v-if="audioSeats.length"
          class="party-room__stage"
          :class="{
            'is-thirty': audioSeats.length === 30 && !videoSeats.length,
            'is-wrapped':
              videoSeats.length > 0 || (audioSeats.length >= 10 && audioSeats.length !== 30),
          }"
          :aria-label="t('party.voiceSeats')"
        >
          <div
            v-for="(row, rowIndex) in audioSeatRows"
            :key="rowIndex"
            class="party-room__seat-row"
            :class="{
              'is-first-short':
                !videoSeats.length &&
                audioSeats.length >= 5 &&
                audioSeats.length <= 7 &&
                rowIndex === 0,
              'is-first-spread':
                !videoSeats.length &&
                audioSeats.length >= 8 &&
                audioSeats.length <= 9 &&
                rowIndex === 0,
              'is-last-four':
                !videoSeats.length &&
                audioSeats.length <= 9 &&
                rowIndex === audioSeatRows.length - 1,
              'is-six-grid': audioSeats.length === 30 && !videoSeats.length,
              'is-wrapped':
                videoSeats.length > 0 || (audioSeats.length >= 10 && audioSeats.length !== 30),
            }"
          >
            <button
              v-for="seat in row"
              :key="seat.index"
              :aria-label="t('party.seat', { index: seat.index + 1 })"
              :class="{
                'is-speaking': seat.speaking,
              }"
              :disabled="seatPending"
              type="button"
              @click="openSeat(seat)"
            >
              <span class="party-room__seat-avatar">
                <PartySpeakingFrames v-if="seat.speaking" />
                <template v-if="seat.host">
                  <img
                    class="party-room__seat-host-result"
                    :src="publicAsset('party/room/icon_mic_mc_result.webp')"
                    alt=""
                  />
                  <img
                    class="party-room__seat-host-border"
                    :src="publicAsset('party/room/border_mc.webp')"
                    alt=""
                  />
                  <img
                    class="party-room__seat-host-wing party-room__seat-host-wing--left"
                    :src="publicAsset('party/room/img_party_mic_left_px_100.webp')"
                    alt=""
                  />
                  <img
                    class="party-room__seat-host-wing party-room__seat-host-wing--right"
                    :src="publicAsset('party/room/img_party_mic_right_px100.webp')"
                    alt=""
                  />
                </template>
                <template v-if="seat.member">
                  <AppAvatar
                    :size="audioSeats.length === 30 && !videoSeats.length ? 35 : 44"
                    :src="seat.member.avatarUrl"
                  />
                  <AppHeadFrame
                    v-if="seat.member.headFrameSmallUrl || seat.member.headFrameUrl"
                    class="party-room__seat-frame"
                    :size="audioSeats.length === 30 && !videoSeats.length ? 48 : 60"
                    :src="seat.member.headFrameSmallUrl || seat.member.headFrameUrl"
                  />
                </template>
                <img
                  v-else
                  :src="
                    publicAsset(
                      seat.locked
                        ? 'party/room/icon_mic_locked_.png'
                        : 'party/room/icon_no_people.png',
                    )
                  "
                  alt=""
                />
                <img
                  v-if="seat.member?.muted || seat.prohibited"
                  class="party-room__seat-muted"
                  :src="publicAsset('party/room/icon_microphone.png')"
                  alt=""
                />
                <span v-if="seat.emojiUrl" class="party-room__seat-emoji">
                  <PartySeatExpression
                    :url="seat.emojiUrl"
                    @finished="finishSeatExpression(seat)"
                  />
                </span>
              </span>
              <span class="party-room__seat-name">
                <strong>{{ seat.member?.displayName || seat.index + 1 }}</strong>
                <img
                  v-if="seat.member && seat.member.roomRole !== 'member'"
                  :src="
                    publicAsset(
                      `party/room/icon_lv_${seat.member.roomRole === 'owner' ? 1 : 2}.png`,
                    )
                  "
                  alt=""
                />
              </span>
              <span v-if="seat.member" class="party-room__seat-meta">
                <small
                  ><img :src="publicAsset('party/room/icon_gem.webp')" alt="" />{{
                    seat.giftValue
                  }}</small
                >
              </span>
            </button>
          </div>
        </section>

        <section class="party-room__conversation">
          <nav class="party-room__chat-tabs" aria-label="Message filter">
            <button
              :class="{ 'is-active': chatTab === 'all' }"
              type="button"
              @click="selectChatTab('all')"
            >
              All
            </button>
            <button
              :class="{ 'is-active': chatTab === 'chat' }"
              type="button"
              @click="selectChatTab('chat')"
            >
              Chat
            </button>
            <button
              :class="{ 'is-active': chatTab === 'gift' }"
              type="button"
              @click="selectChatTab('gift')"
            >
              Gift
            </button>
          </nav>
          <SwiperView
            class="party-room__chat-swipe"
            :grab-cursor="true"
            :initial-slide="chatTabs.indexOf(chatTab)"
            :loop="false"
            @slide-change="handleChatSwipe"
            @swiper="setChatSwiper"
          >
            <SwiperSlide v-for="tab in chatTabs" :key="tab">
              <div
                :ref="(element) => bindChatScroller(tab, element as Element | null)"
                class="party-room__chat"
                aria-live="polite"
              >
                <p v-if="tab === 'all'" class="party-room__chat-safety" role="note">
                  {{ snapshot?.room.safetyNotice || t('party.chatSafetyNotice') }}
                </p>
                <article
                  v-for="message in messagesFor(tab)"
                  :key="message.id"
                  :class="['party-room__message', `is-${message.type}`]"
                >
                  <template v-if="message.type === 'system'">
                    <div class="party-room__notice-bubble">
                      <b>{{ t('party.roomAnnouncement') }}</b>
                      <span>{{ message.text }}</span>
                    </div>
                  </template>
                  <template v-else-if="message.type === 'entry'">
                    <b>{{ message.senderName }}</b
                    ><span>{{ message.text }}</span>
                  </template>
                  <template v-else>
                    <button
                      class="party-room__message-avatar"
                      :disabled="!messageMember(message)"
                      type="button"
                      @click.stop="selectMessageMember(message)"
                    >
                      <AppAvatar :size="24" :src="message.senderAvatarUrl" />
                    </button>
                    <div class="party-room__message-main">
                      <header>
                        <strong>{{ message.senderName }}</strong>
                        <AppUserLevelTag
                          v-if="messageShowsUserBadges(message)"
                          :level="messageMember(message)?.level"
                          size="s"
                        />
                        <img
                          v-if="messageShowsUserBadges(message) && messageMember(message)?.vip"
                          class="party-room__message-vip"
                          :src="publicAsset('messages/vip_bradge.png')"
                          alt="VIP"
                        />
                        <img
                          v-if="
                            messageMember(message) && messageMember(message)?.roomRole !== 'member'
                          "
                          class="party-room__message-role"
                          :src="
                            publicAsset(
                              `party/room/icon_lv_${messageMember(message)?.roomRole === 'owner' ? 1 : 2}.png`,
                            )
                          "
                          alt=""
                        />
                      </header>
                      <div v-if="message.type === 'text'" class="party-room__text-bubble">
                        <em v-if="message.mentionCurrentUser">@me</em>
                        <span>{{ message.text }}</span>
                      </div>
                      <div v-else-if="message.type === 'gift'" class="party-room__gift-message">
                        <span>Sends to</span>
                        <strong v-if="messageGiftReceivers(message).length === 1">
                          {{ messageGiftReceivers(message)[0]?.name }}
                        </strong>
                        <span
                          v-else-if="messageGiftReceivers(message).length"
                          class="party-room__gift-receivers"
                        >
                          <AppAvatar
                            v-for="member in messageGiftReceivers(message).slice(0, 5)"
                            :key="member.id"
                            :size="20"
                            :src="member.avatarUrl"
                          />
                          <b>{{ messageGiftReceivers(message).length }} persons</b>
                        </span>
                        <span class="party-room__gift-summary">
                          <AppImage
                            class="party-room__gift-icon"
                            :height="24"
                            :lazy="false"
                            :src="message.giftIconUrl"
                            :width="24"
                          />
                          <b>{{ message.giftName || message.text }}</b>
                          <span>×{{ message.giftCount ?? 1 }}</span>
                        </span>
                      </div>
                      <div
                        v-else-if="message.type === 'activity'"
                        class="party-room__notice-bubble"
                      >
                        <span>{{ message.text }}</span>
                      </div>
                    </div>
                  </template>
                </article>
              </div>
            </SwiperSlide>
          </SwiperView>
        </section>

        <aside v-if="snapshot.room.cornerBanners.length" class="party-room__corner-banners">
          <button
            v-for="banner in snapshot.room.cornerBanners.slice(0, 2)"
            :key="banner.id"
            type="button"
            @click="openPromotion(banner.directUrl)"
          >
            <AppImage :alt="banner.name" :lazy="false" :src="banner.imageUrl" />
          </button>
        </aside>

        <aside v-if="snapshot.room.banners.length" class="party-room__activity-banners">
          <button
            v-for="banner in snapshot.room.banners.slice(0, 2)"
            :key="banner.id"
            type="button"
            @click="openPromotion(banner.directUrl)"
          >
            <AppImage :alt="banner.name" :lazy="false" :src="banner.imageUrl" />
          </button>
        </aside>
        <button
          v-if="snapshot.room.musicAvailable && musicSettings?.enabled"
          class="party-room__music-widget"
          type="button"
          :aria-label="t('party.music')"
          @click="canManageRoom ? openPanel('music') : toggleSound()"
        >
          <span :class="{ 'is-playing': soundEnabled && musicSettings?.playing }">
            <img :src="publicAsset('party/room/icon_music_new.webp')" alt="" />
            <img :src="publicAsset('party/room/icon_music_zs_new.webp')" alt="" />
          </span>
        </button>

        <footer class="party-room__footer" :class="{ 'is-composing': composerOpen }">
          <div v-if="roomMessagingEnabled" class="party-room__composer">
            <button v-if="!composerOpen" type="button" @click="openComposer">
              {{ draft || t('party.messagePlaceholder') }}
            </button>
            <input
              v-else
              ref="composerInput"
              v-model="draft"
              :aria-label="t('party.roomMessage')"
              enterkeyhint="send"
              maxlength="500"
              :placeholder="t('party.messagePlaceholder')"
              type="text"
              @compositionend="composing = false"
              @compositionstart="composing = true"
              @blur="closeComposerLater"
              @keydown.enter="handleComposerEnter"
            />
            <button
              v-if="composerOpen"
              :disabled="!canSend"
              type="button"
              :aria-label="t('party.sendMessage')"
              @click="sendMessage()"
            >
              <img :src="publicAsset('common/btn_send.png')" alt="" />
            </button>
          </div>
          <button
            v-if="!composerOpen && showMicApplication"
            class="party-room__apply"
            type="button"
            aria-label="Mic application"
            @click="openPanel('queue')"
          >
            <img
              :src="
                publicAsset(
                  `party/room/${canManageRoom ? (snapshot.room.queueCount ? 'icon_has_apply_btn.png' : 'icon_apply_btn.png') : 'icon_has_apply_btn.png'}`,
                )
              "
              alt=""
            />
            <em v-if="canManageRoom && snapshot.room.queueCount">{{ snapshot.room.queueCount }}</em>
          </button>
          <button
            v-if="realtimeEnabled && !composerOpen && currentSeat"
            type="button"
            :aria-label="t('party.expressions')"
            @click="openPanel('emoji')"
          >
            <img class="party__emoji" :src="publicAsset('party/room/icon_expression.png')" alt="" />
          </button>
          <button
            v-if="roomMessagingEnabled && !composerOpen && snapshot.room.owner.id !== currentUserId"
            class="party-room__messages-button"
            type="button"
            :aria-label="t('room.messageHost')"
            @click="openMemberMessage(snapshot.room.owner)"
          >
            <img :src="publicAsset('party/room/icon_message.webp')" alt="" />
          </button>
          <button
            v-if="realtimeEnabled && !composerOpen && currentSeat"
            :class="{ 'is-off': !microphoneActive }"
            type="button"
            :aria-label="t('party.microphone')"
            @click="handleSeatAction(currentSeat, microphoneActive ? 'mute' : 'unmute')"
          >
            <img
              class="party__mic"
              :src="
                publicAsset(
                  microphoneActive
                    ? 'party/room/icon_open_microphone.png'
                    : 'party/room/icon_microphone.png',
                )
              "
              alt=""
            />
          </button>
          <button
            v-if="!composerOpen"
            type="button"
            :aria-label="t('party.gift')"
            @click="openGifts()"
          >
            <img :src="publicAsset('common/gift_icon.png')" alt="" />
          </button>
        </footer>
        <PartyRoomPanels
          :backgrounds="backgrounds"
          :blacklist="blacklist"
          :current-background="currentBackground"
          :current-level="session.profile?.level ?? 0"
          :current-user-id="currentUserId"
          :emojis="emojis"
          :gifts="gifts"
          :loading-panel="panelLoading"
          :invite-candidates="inviteCandidates"
          :invite-cooldowns="inviteCooldowns"
          :invite-followers="inviteFollowers"
          :invite-loading-tabs="inviteLoadingTabs"
          :music="music"
          :conversations="inviteConversations"
          :music-enabled="musicSettings?.enabled ?? false"
          :music-pending="musicControlPending"
          :music-settings="musicSettings"
          :panel="panel"
          :rank-kind="rankKind"
          :rank-period="rankPeriod"
          :rank-result="rankResult"
          :rank-scope="rankScope"
          :queue="queue"
          :room-templates="roomTemplates"
          :selected-member="selectedMember"
          :selected-seat="selectedSeat"
          :snapshot="snapshot"
          :sound-enabled="soundEnabled"
          :user-card-open="memberCardOpen"
          :viewers="viewers"
          @announcement="saveAnnouncement"
          @background="setRoomBackground"
          @blacklist-remove="removeBlacklist"
          @close-user-card="closeMemberCard"
          @emoji="sendEmoji"
          @gift="openGifts"
          @quick-gift="sendQuickGift"
          @leave="closeRoom"
          @invite="inviteMembers"
          @invite-tab="loadInviteTabFromSwipe"
          @member-admin="setMemberAdmin"
          @member-follow="syncMemberCardFollowed"
          @member-kick="kickMember"
          @member-seat="holdMemberOnSeat"
          @message="openMemberMessage"
          @moderate="moderateSeat"
          @music="playMusic"
          @music-like="toggleMusicLike"
          @music-upload="uploadMusic"
          @music-mode="updateMusicPlayback({ playMode: $event })"
          @music-pause="pauseMusic"
          @music-volume="updateMusicPlayback({ volume: $event })"
          @open-panel="openPanel"
          @profile="openMemberProfile"
          @rank-kind="reloadRank({ kind: $event, scope: 'CURRENT' })"
          @rank-more="reloadRank({ append: true })"
          @rank-period="reloadRank({ period: $event, scope: 'CURRENT' })"
          @rank-scope="reloadRank({ scope: $event })"
          @queue-approve="approveQueue"
          @queue-cancel="cancelQueue"
          @queue-refuse="refuseQueue"
          @report="reportRoom"
          @seat-media="setSeatMedia"
          @seat-invite-member="holdMemberOnSeat"
          @select-member="selectMember"
          @sound="toggleSound"
          @toggle-apply="toggleSeatApplications"
          @toggle-lock="toggleRoomLock"
          @toggle-music="toggleRoomMusic"
          @template="setRoomTemplate"
        />
        <RoomMessageStack
          v-model="showMessages"
          v-model:conversation-target="messageConversationTarget"
          variant="party"
        />
        <PartyGiftSheet
          :balance="session.balance"
          :count-choices="giftCountChoices"
          :failed="giftFailed"
          :gifts="gifts"
          :loading="giftLoading"
          :pending="giftSending"
          :preferred-receiver-id="preferredGiftReceiverId"
          :receivers="giftReceivers"
          :show="giftPanel"
          :suspended="giftRechargeCovered"
          @closed="finishGiftCloseWait"
          @recharge="requestRecharge"
          @retry="openGifts"
          @send="sendGift"
          @update:show="giftPanel = $event"
        />
        <PartyActivityPopup
          :room-id="props.context.roomId"
          :source="activityUrl"
          :suspended="giftRechargeCovered"
          @close="closeActivity"
          @navigate="handleActivityNavigation"
          @open-gift="openGiftFromActivity"
        />
      </div>
    </AppStateView>
  </main>
</template>

<style scoped lang="less">
.party-room-shell,
.party-room-shell :deep(.app-state-view),
.party-room-shell :deep(.app-state-view__content) {
  width: 100%;
  height: 100%;
}

.party-room-shell {
  overflow: hidden;
  background: var(--color-party-room-bg);
  color: var(--color-on-dark);
}

.party-room__connection {
  position: absolute;
  z-index: 12;
  top: 70px;
  right: 14px;
  left: 14px;
  display: flex;
  min-height: 38px;
  align-items: center;
  justify-content: center;
  padding: 8px 12px;
  border-radius: 12px;
  background: color-mix(in srgb, var(--color-party-room-bg) 88%, transparent);
  box-shadow: 0 6px 20px rgb(0 0 0 / 22%);
  gap: 10px;
  font-size: 12px;
}

.party-room__connection button {
  padding: 4px 10px;
  border: 0;
  border-radius: 12px;
  background: var(--gradient-primary);
  color: var(--color-on-dark);
  font: inherit;
}

.party-room__entry-loading {
  display: grid;
  width: 100%;
  height: 100%;
  place-items: center;
}

.party-room {
  --party-room-bottom-inset: var(--safe-bottom);
  --party-room-footer-occupied-height: calc(60px + var(--party-room-bottom-inset));

  position: relative;
  display: flex;
  width: 100%;
  height: 100%;
  flex-direction: column;
  overflow: hidden;
  background-color: var(--color-party-room-bg);
  background-position: center;
  background-size: cover;
  isolation: isolate;
}

.party-room::before {
  position: absolute;
  z-index: -1;
  inset: 0;
  background: var(--color-scrim-strong);
  content: '';
}

.party-room__simulated-audio {
  display: none;
}

.party-room__sound.needs-gesture {
  border-radius: 50%;
  background: rgb(255 255 255 / 14%);
  animation: party-sound-prompt 1.2s ease-in-out infinite;
}

@keyframes party-sound-prompt {
  50% {
    box-shadow: 0 0 0 6px rgb(255 255 255 / 10%);
    transform: scale(1.08);
  }
}

.party-room__header {
  height: calc(var(--safe-top) + 80px);
  flex: 0 0 auto;
  padding: calc(var(--safe-top) + 4px) max(8px, var(--safe-right)) 4px max(8px, var(--safe-left));
}

.party-room__header-main {
  display: flex;
  height: 48px;
  align-items: center;
  padding-top: 4px;
}

.party-room__header-main > button {
  display: grid;
  width: 32px;
  height: 44px;
  padding: 0;
  place-items: center;
  border: 0;
  background: transparent;
  color: var(--color-on-dark);
}

.party-room__header-main > button.party-room__host {
  position: relative;
  width: 48px;
  height: 48px;
  flex: 0 0 48px;
}

.party-room__host :deep(.avatar),
.party-room__host :deep(.app-image) {
  overflow: hidden;
  border-radius: 50%;
}

.party-room__identity {
  display: grid;
  min-width: 0;
  align-content: center;
  gap: 5px;
  margin-inline: 4px;
  max-width: 92px;
}

.party-room__identity > strong,
.party-room__identity > span {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.party-room__identity > strong {
  font-size: 15px;
  line-height: 18px;
}

.party-room__identity > span {
  color: var(--color-on-dark-secondary);
  font-size: 13px;
  line-height: 16px;
}

.party-room__header-main > button.party-room__follow {
  width: 28px;
  height: 28px;
  flex: 0 0 28px;
  border-radius: 50%;
  background: linear-gradient(100deg, var(--color-secondary), var(--color-primary));
}

.party-room__header-main > button.party-room__follow.is-following {
  border: 1px solid var(--color-on-dark-subtle);
  background: var(--color-on-dark-border-strong);
}

.party-room__header-main > button.party-room__follow:disabled {
  opacity: 0.65;
}

.party-room__follow > img {
  width: 20px;
  height: 20px;
  object-fit: contain;
}

.party-room__follow.is-following > img {
  width: 17px;
  height: 17px;
}

.party-room__header-icon {
  width: 24px;
  height: 24px;
  object-fit: contain;
}

.party-room__header-spacer,
.party-room__header-meta > span {
  flex: 1;
}

.party-room__header-meta {
  display: flex;
  height: 24px;
  align-items: center;
  padding-inline-start: 6px;
}

.party-room__header-meta button {
  display: flex;
  min-width: 44px;
  height: 44px;
  align-items: center;
  gap: 4px;
  padding: 0;
  border: 0;
  background: transparent;
  color: var(--color-party-rank-score);
  font-size: 12px;
}

.party-room__header-meta button:last-child {
  color: var(--color-on-dark-secondary);
}

.party-room__header-meta img {
  width: 16px;
  height: 16px;
  object-fit: contain;
}

.party-room__header-meta img.party-room__meta-arrow {
  width: 10px;
  height: 10px;
}

.party-room__metric {
  display: grid;
  width: 50px;
  height: 24px;
  place-items: center;
  overflow: hidden;
}

.party-room__metric b {
  font-weight: 400;
}

.party-header-metric-enter-active,
.party-header-metric-leave-active {
  transition:
    opacity 220ms cubic-bezier(0.2, 0, 0, 1),
    transform 220ms cubic-bezier(0.2, 0, 0, 1);
}

.party-header-metric-enter-from {
  opacity: 0;
  transform: translateY(8px);
}

.party-header-metric-leave-to {
  opacity: 0;
  transform: translateY(-8px);
}

.party-room__video-stage {
  display: flex;
  width: 100%;
  height: 180px;
  flex: 0 0 auto;
  align-items: stretch;
}

.party-room__video-stage.is-six {
  display: grid;
  height: auto;
  aspect-ratio: 9 / 5;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  grid-template-rows: repeat(2, minmax(0, 1fr));
  gap: 1px;
  padding-inline: 1px;
}

.party-room__video-stage.is-six-only {
  height: min(112.267vw, 421px);
  aspect-ratio: auto;
  grid-template-rows: repeat(2, minmax(0, 1fr));
}

.party-room__video-stage.is-single {
  padding-inline: 16px;
}

.party-room__video-stage > button {
  position: relative;
  min-width: 0;
  padding: 0;
  overflow: visible;
  border: 0;
  background: transparent;
  color: var(--color-on-dark);
}

.party-room__video-stage:not(.is-six) > button {
  height: 100%;
  flex: 1 1 0;
}

.party-room__video-stage.is-six > button {
  width: 100%;
  min-height: 0;
  height: 100%;
  flex: none;
}

.party-room__video-stage.is-single > button {
  max-width: 186px;
}

.party-room__video-surface {
  position: absolute;
  inset: 0;
  display: block;
}

.party-room__video-surface.is-empty {
  background: var(--color-on-dark-divider);
}

.party-room__video-track {
  position: absolute;
  z-index: 2;
  inset: 0;
  display: block;
  overflow: hidden;
}

.party-room__video-track :deep(.agora_video_player),
.party-room__video-track :deep(video) {
  width: 100% !important;
  max-width: 100%;
  height: 100% !important;
  max-height: 100%;
}

.party-room__video-track :deep(video) {
  object-fit: cover !important;
}

.party-room__camera-off {
  position: absolute;
  z-index: 2;
  inset: 0;
  background: var(--color-media-bg);
}

.party-room__camera-off.is-host {
  background: transparent;
}

.party-room__camera-off-avatar {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 52px;
  height: 52px;
  transform: translate(-50%, -50%);
}

.party-room__camera-off-avatar > :deep(.avatar) {
  position: absolute;
  z-index: 2;
  inset: 0;
}

.party-room__camera-off-avatar > :deep(.party-speaking-frames) {
  z-index: 1;
}

.party-room__camera-off-mask {
  position: absolute;
  z-index: 3;
  inset: 0;
  width: 52px;
  height: 52px;
  object-fit: contain;
}

.party-room__video-placeholder {
  position: absolute;
  top: 50%;
  left: 50%;
  z-index: 2;
  width: 52px;
  height: 52px;
  transform: translate(-50%, -50%);
}

.party-room__video-placeholder-image {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.party-room__video-index {
  position: absolute;
  top: calc(100% + 11px);
  left: 0;
  z-index: 4;
  width: 100%;
  color: var(--color-on-dark);
  font-size: 11px;
  font-weight: 500;
  line-height: 1;
  text-align: center;
}

.party-room__video-host-border,
.party-room__video-host-result,
.party-room__video-host-wing {
  position: absolute;
  object-fit: contain;
  pointer-events: none;
}

.party-room__video-host-border {
  z-index: 4;
  inset: 0;
  width: 52px;
  height: 52px;
}

.party-room__video-host-result {
  z-index: 4;
  width: 24px;
  height: 12px;
}

.party-room__video-host-result.is-placeholder {
  top: -16px;
  left: 50%;
}

.party-room__video-host-result.is-camera-off {
  top: 50%;
  left: 50%;
}

.party-room__video-host-result.is-camera-on {
  bottom: 8px;
  left: 4px;
}

.party-room__video-host-wing {
  z-index: 1;
  bottom: -2px;
}

.party-room__video-host-wing.is-left {
  left: -11px;
  width: 80px;
  height: 75px;
}

.party-room__video-host-wing.is-right {
  right: 0;
  width: 57px;
  height: 60px;
}

.party-room__video-host-wing.is-muted {
  opacity: 0.45;
}

.party-room__video-member {
  position: absolute;
  z-index: 4;
  top: 4px;
  left: 4px;
  right: 2px;
  display: flex;
  height: 20px;
  align-items: center;
}

.party-room__video-member-info {
  display: flex;
  min-width: 0;
  height: 20px;
  align-items: center;
  gap: 4px;
  padding-inline: 4px;
  border-radius: 100px;
  background: var(--color-scrim-soft);
}

.party-room__video-member strong {
  max-width: 58px;
  overflow: hidden;
  font-size: 11px;
  font-weight: 500;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.party-room__video-role {
  width: 12px;
  height: 12px;
  flex: 0 0 auto;
}

.party-room__video-muted {
  width: 20px;
  height: 20px;
  flex: 0 0 auto;
  margin-inline-start: auto;
}

.party-room__video-gift {
  position: absolute;
  right: 4px;
  bottom: 4px;
  z-index: 4;
  display: flex;
  height: 20px;
  align-items: center;
  gap: 3px;
  padding: 0 4px;
  border-radius: 10px;
  background: var(--color-scrim-soft);
  font-size: 12px;
}

.party-room__video-gift img {
  width: 8px;
  height: 8px;
}

.party-room__stage {
  display: flex;
  min-height: 164px;
  flex: 0 0 auto;
  flex-direction: column;
  justify-content: flex-start;
  gap: 4px;
  padding: 14px 2px 0;
}

.party-room__stage.is-thirty,
.party-room__stage.is-wrapped {
  min-height: 164px;
  flex: 0 0 auto;
}

.party-room__stage.is-wrapped {
  padding-inline: 0;
}

.party-room__seat-row {
  display: flex;
  min-height: 76px;
  justify-content: center;
}

.party-room__seat-row.is-first-short {
  gap: 60px;
}

.party-room__seat-row.is-first-spread {
  justify-content: space-between;
  padding-inline: 12px;
}

.party-room__seat-row.is-last-four {
  justify-content: space-around;
  padding-inline: 12px;
}

.party-room__seat-row.is-six-grid {
  display: grid;
  grid-template-columns: repeat(6, minmax(0, 1fr));
}

.party-room__seat-row.is-six-grid > button {
  width: 100%;
  min-width: 0;
}

.party-room__seat-row.is-wrapped {
  justify-content: flex-start;
  padding-inline: 12px 0;
}

.party-room__seat-row.is-wrapped > button {
  margin-inline-end: 3px;
}

.party-room__seat-row > button {
  display: grid;
  width: 68px;
  min-width: 68px;
  min-height: 76px;
  align-content: start;
  justify-items: center;
  gap: 0;
  padding: 0;
  border: 0;
  background: transparent;
  color: var(--color-on-dark);
}

.party-room__seat-avatar {
  position: relative;
  display: grid;
  width: 60px;
  height: 60px;
  margin-bottom: 3px;
  place-items: center;
}

.party-room__seat-avatar > :deep(.avatar),
.party-room__seat-avatar
  > img:not(
    .party-room__seat-muted,
    .party-room__seat-crown,
    .party-room__seat-host-result,
    .party-room__seat-host-border,
    .party-room__seat-host-wing,
    .party-speaking-frames
  ) {
  width: 44px;
  height: 44px;
  object-fit: contain;
}

.party-room__seat-frame {
  position: absolute;
  z-index: 1;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.party-room__seat-host-result,
.party-room__seat-host-border {
  position: absolute;
  pointer-events: none;
  object-fit: contain;
}

.party-room__seat-host-border {
  z-index: 2;
  inset: 50% auto auto 50%;
  width: 44px;
  height: 44px;
  transform: translate(-50%, -50%);
}

.party-room__seat-host-result {
  z-index: 3;
  top: 0;
  right: 0;
  width: 24px;
  height: 12px;
}

.party-room__seat-host-wing {
  position: absolute;
  top: 50%;
  z-index: 1;
  width: 33px;
  height: 31px;
  object-fit: contain;
  pointer-events: none;
}

.party-room__seat-host-wing--left {
  right: 50%;
  transform: translate(-5px, -13px);
}

.party-room__seat-host-wing--right {
  left: 50%;
  transform: translate(5px, -13px);
}

.party-room__seat-muted {
  position: absolute;
  right: -1px;
  bottom: 1px;
  width: 18px;
  height: 18px;
  border-radius: 50%;
  background: var(--color-scrim-strong);
}

.party-room__seat-crown {
  position: absolute;
  top: -9px;
  left: 50%;
  width: 26px;
  height: 14px;
  object-fit: contain;
  transform: translateX(-50%);
}

.party-room__seat-emoji {
  position: absolute;
  z-index: 888;
  inset: 0;
  display: grid;
  width: 100%;
  height: 100%;
  place-items: center;
  overflow: visible;
  pointer-events: none;
}

.party-room__seat-emoji > :deep(.party-seat-expression) {
  width: 100%;
  height: 100%;
}

.party-room__stage strong,
.party-room__stage small {
  max-width: 50px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.party-room__seat-name {
  position: relative;
  z-index: 1;
  display: flex;
  width: 100%;
  height: 13px;
  align-items: center;
  justify-content: center;
  padding-inline: 2px;
}

.party-room__seat-name > img {
  width: 8px;
  height: 8px;
  flex: 0 0 auto;
  margin-inline-start: 4px;
  object-fit: contain;
}

.party-room__seat-meta {
  display: flex;
  max-width: 58px;
  height: 14px;
  align-items: center;
  justify-content: center;
}

.party-room__seat-meta small {
  display: flex;
  align-items: center;
  gap: 2px;
  color: var(--color-on-dark);
  font-size: 10px;
}

.party-room__seat-meta small img {
  width: 8px;
  height: 8px;
}

.party-room__stage strong {
  font-size: 11px;
  font-weight: 500;
}

.party-room__stage small {
  color: var(--color-on-dark);
  font-size: 10px;
}

.party-room__seat-row.is-six-grid .party-room__seat-avatar {
  width: 48px;
  height: 48px;
  margin-bottom: 2px;
}

.party-room__seat-row.is-six-grid .party-room__seat-avatar > :deep(.avatar),
.party-room__seat-row.is-six-grid
  .party-room__seat-avatar
  > img:not(
    .party-room__seat-muted,
    .party-room__seat-crown,
    .party-room__seat-host-result,
    .party-room__seat-host-border,
    .party-room__seat-host-wing,
    .party-speaking-frames
  ) {
  width: 35px;
  height: 35px;
}

.party-room__seat-row.is-six-grid .party-room__seat-host-border {
  width: 35px;
  height: 35px;
}

.party-room__seat-row.is-six-grid .party-room__seat-host-result {
  width: 20px;
  height: 10px;
}

.party-room__seat-row.is-six-grid .party-room__seat-host-wing {
  width: 26px;
  height: 25px;
}

.party-room__seat-row.is-six-grid .party-room__seat-host-wing--left {
  transform: translate(-4px, -10px);
}

.party-room__seat-row.is-six-grid .party-room__seat-host-wing--right {
  transform: translate(4px, -10px);
}

.party-room__seat-row.is-six-grid .party-room__seat-name {
  height: 11px;
  padding-inline: 1px;
}

.party-room__seat-row.is-six-grid .party-room__seat-name strong {
  max-width: 40px;
  font-size: 9px;
}

.party-room__seat-row.is-six-grid .party-room__seat-name > img {
  width: 6px;
  height: 6px;
  margin-inline-start: 1px;
}

.party-room__seat-row.is-six-grid .party-room__seat-meta {
  height: 12px;
}

.party-room__seat-row.is-six-grid .party-room__seat-meta small {
  gap: 1px;
  font-size: 9px;
}

.party-room__seat-row.is-six-grid .party-room__seat-meta small img {
  width: 6px;
  height: 6px;
}

.party-room__conversation {
  display: flex;
  width: min(335px, calc(100% - 8px));
  min-height: 0;
  flex: 1;
  flex-direction: column;
  align-self: flex-start;
  margin-inline-start: 8px;
}

.party-room__chat-tabs {
  display: flex;
  height: 44px;
  flex: 0 0 auto;
  align-items: center;
  gap: 20px;
  padding-inline: 14px;
}

.party-room__chat-tabs button {
  position: relative;
  height: 24px;
  padding: 0;
  border: 0;
  background: transparent;
  color: var(--color-on-dark-secondary);
  font-size: 13px;
  line-height: 18px;
}

.party-room__chat-tabs button.is-active {
  color: var(--color-party-chat-tab);
  font-size: 15px;
  font-weight: 700;
}

.party-room__chat-tabs button.is-active::after {
  position: absolute;
  bottom: 0;
  left: 50%;
  width: 10px;
  height: 3px;
  border-radius: 4px;
  background: var(--color-party-chat-tab);
  content: '';
  transform: translateX(-50%);
}

.party-room__chat {
  height: 100%;
  padding-inline: 8px;
  overflow: hidden auto;
  overscroll-behavior: contain;
  scrollbar-width: none;
  touch-action: pan-y;
  -webkit-overflow-scrolling: touch;
}

.party-room__chat-swipe {
  width: 100%;
  min-height: 0;
  flex: 1;
}

.party-room__chat-swipe :deep(.swiper-wrapper),
.party-room__chat-swipe :deep(.swiper-slide) {
  height: 100%;
  min-height: 0;
}

.party-room__chat::-webkit-scrollbar {
  display: none;
}

.party-room__chat-safety {
  margin: 0;
  padding: 10px;
  color: var(--color-party-chat-notice-title);
  font-size: 13px;
  font-weight: 600;
  line-height: 18px;
  overflow-wrap: anywhere;
}

.party-room__message {
  display: flex;
  width: 100%;
  padding-block: 8px;
  color: var(--color-on-dark);
  font-size: 13px;
  line-height: 18px;
}

.party-room__message-avatar {
  display: grid;
  width: 32px;
  height: 32px;
  flex: 0 0 32px;
  place-items: center;
  padding: 0;
  border: 0;
  background: transparent;
}

.party-room__message-main {
  width: 240px;
  min-width: 0;
  margin-inline-start: 8px;
}

.party-room__message-main > header {
  display: flex;
  min-height: 16px;
  flex-wrap: wrap;
  align-items: center;
  gap: 4px;
  line-height: 16px;
}

.party-room__message-main > header > strong {
  max-width: 106px;
  overflow: hidden;
  color: var(--color-on-dark);
  font-size: 14px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.party-room__message-vip {
  width: 32px;
  height: 12px;
  object-fit: contain;
}

.party-room__message-role {
  width: 16px;
  height: 16px;
  object-fit: contain;
}

.party-room__text-bubble,
.party-room__activity-bubble {
  display: inline-flex;
  width: fit-content;
  max-width: 213px;
  min-height: 22px;
  align-items: center;
  margin-top: 8px;
  padding: 4px 8px;
  border-radius: 12px;
  background: var(--color-scrim-soft);
  overflow-wrap: anywhere;
}

.party-room__text-bubble em {
  flex: 0 0 auto;
  margin-inline-end: 4px;
  color: var(--color-party-chat-mention);
  font-style: normal;
}

.party-room__notice-bubble {
  width: 213px;
  min-height: 22px;
  margin-inline-start: 8px;
  padding: 4px 8px;
  border: 2px solid var(--color-party-chat-notice-border);
  border-radius: 12px;
  background: var(--color-party-chat-notice-bg);
  overflow-wrap: anywhere;
}

.party-room__notice-bubble b {
  display: block;
  color: var(--color-party-chat-notice-title);
}

.party-room__notice-bubble span {
  display: block;
  color: var(--color-on-dark);
  white-space: pre-line;
}

.party-room__gift-message {
  display: flex;
  width: fit-content;
  max-width: 240px;
  min-height: 44px;
  flex-flow: column wrap;
  margin-top: 8px;
  padding: 10px 8px;
  border-radius: 8px;
  background: var(--color-scrim-soft);
}

.party-room__gift-message > strong,
.party-room__gift-receivers b {
  color: var(--color-party-chat-notice-title);
}

.party-room__gift-receivers,
.party-room__gift-summary {
  display: flex;
  align-items: center;
}

.party-room__gift-receivers {
  padding-block: 4px;
}

.party-room__gift-receivers :deep(.app-avatar) {
  margin-inline-end: -4px;
}

.party-room__gift-receivers b {
  margin-inline-start: 8px;
}

.party-room__gift-summary {
  gap: 4px;
}

.party-room__gift-icon {
  width: 24px;
  height: 24px;
}

.party-room__gift-summary b {
  max-width: 130px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.party-room__activity-bubble {
  display: grid;
  gap: 3px;
}

.party-room__lucky-message {
  display: flex;
  align-items: center;
  gap: 6px;
}

.party-room__lucky-message > img {
  width: 26px;
  height: 26px;
  object-fit: contain;
}

.party-room__lucky-message > span {
  display: flex;
  align-items: baseline;
}

.party-room__lucky-message strong {
  color: var(--color-party-chat-tab);
  font-size: 18px;
}

.party-room__activity-bubble > small {
  color: var(--color-on-dark);
  font-size: 10px;
}

.party-room__message.is-entry {
  width: fit-content;
  background: transparent;
  color: var(--color-on-dark);
  font-weight: 700;
}

.party-room__message.is-entry b {
  margin-inline-end: 4px;
  color: var(--color-party-chat-name);
}

.party-room__corner-banners,
.party-room__activity-banners {
  position: absolute;
  z-index: 3;
  right: 8px;
  display: grid;
  justify-items: end;
  gap: 8px;
}

.party-room__corner-banners > button,
.party-room__activity-banners > button {
  width: 50px;
  height: 50px;
  padding: 0;
  overflow: hidden;
  border: 0;
  border-radius: 10%;
  background: transparent;
}

.party-room__corner-banners {
  top: calc(var(--safe-top) + 84px);
}

.party-room__activity-banners {
  right: 12px;
  bottom: calc(var(--party-room-footer-occupied-height) + 50px);
}

.party-room__corner-banners :deep(.app-image),
.party-room__activity-banners :deep(.app-image) {
  width: 50px !important;
  height: 50px !important;
}

.party-room__footer {
  flex: 0 0 auto;
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px max(12px, var(--safe-right)) max(8px, var(--party-room-bottom-inset))
    max(12px, var(--safe-left));
  background: transparent;
}

.party-room__quick-phrases {
  display: flex;
  height: 44px;
  flex: 0 0 42px;
  align-items: center;
  padding: 0 max(8px, var(--safe-right)) 0 max(5px, var(--safe-left));
  gap: 4px;
  background: transparent;
}

.party-room__quick-phrases > div {
  display: flex;
  min-width: 0;
  flex: 1;
  gap: 12px;
  overflow: auto hidden;
  touch-action: pan-x;
  scrollbar-width: none;
  -webkit-overflow-scrolling: touch;
}

.party-room__quick-phrases > div::-webkit-scrollbar {
  display: none;
}

.party-room__quick-phrases button {
  height: 32px;
  flex: 0 0 auto;
  padding: 0 12px;
  border: 1px solid var(--color-on-dark-fill);
  border-radius: 24px;
  background: var(--color-party-composer-input);
  color: var(--color-on-dark-secondary);
  font-size: 12px;
  white-space: nowrap;
}

.party-room__quick-phrases > button {
  width: 24px;
  padding: 0;
  border: 0;
  background: transparent;
  color: var(--color-text);
  font-size: 18px;
}

.party-room__footer.is-composing {
  padding-inline: max(12px, var(--safe-left)) max(12px, var(--safe-right));
  padding-top: 6px;
  padding-bottom: max(6px, var(--party-room-bottom-inset));
  background: color-mix(in srgb, var(--color-page-deep) 94%, transparent);
}

.party-room__apply {
  position: relative;
}

.party-room__apply em {
  position: absolute;
  top: 1px;
  right: -2px;
  display: grid;
  min-width: 16px;
  height: 16px;
  padding: 0 3px;
  place-items: center;
  border-radius: 9px;
  background: var(--color-primary);
  color: var(--color-on-dark);
  font-size: 9px;
  font-style: normal;
}

.party-room__messages-button {
  position: relative;
}

.party-room__messages-button > img {
  width: 32px !important;
  height: 32px !important;
}

.party-room__footer > button,
.party-room__composer > button {
  display: grid;
  width: 32px;
  height: 32px;
  padding: 0;
  place-items: center;
  border: 0;
  border-radius: 0;
  background: transparent;
  color: var(--color-on-dark);
}

.party-room__footer > button > img,
.party-room__composer > button > img {
  width: 22px;
  height: 22px;
  object-fit: contain;
}

.party__emoji {
  width: 32px !important;
  height: 32px !important;
}

.party__mic {
  width: 32px !important;
  height: 32px !important;
}

.party-room__composer {
  display: flex;
  min-width: 0;
  height: 34px;
  flex: 1;
  align-items: center;
  overflow: hidden;
  border: 0;
  border-radius: 17px;
  background: var(--color-feedback-field);
}

.party-room__composer:focus-within {
  box-shadow: inset 0 0 0 1px var(--color-on-dark-fill);
}

.party-room__footer.is-composing .party-room__composer {
  height: 34px;
  background: var(--color-feedback-field);
}

.party-room__composer > button {
  width: auto;
  min-width: 34px;
  height: 36px;
  background: transparent;
}

.party-room__footer.is-composing .party-room__composer > button {
  width: 42px;
  height: 34px;
  flex: 0 0 42px;
}

.party-room__footer.is-composing .party-room__composer > button > img {
  width: 38px;
  height: 28px;
}

.party-room__composer > button:first-child:not(:last-child),
.party-room__composer > button:only-child {
  display: block;
  min-width: 0;
  flex: 1;
  padding: 0 12px;
  overflow: hidden;
  color: var(--color-on-dark-secondary);
  font-size: 12px;
  text-align: start;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.party-room__music-widget {
  position: absolute;
  z-index: 3;
  right: 10px;
  bottom: calc(var(--party-room-footer-occupied-height) + 20px);
  width: 50px;
  height: 58px;
  padding: 0;
  border: 0;
  background: transparent;
}

.party-room__music-widget span {
  position: relative;
  display: block;
  width: 34px;
  height: 34px;
  margin: 0 auto;
}

.party-room__music-widget span > img:first-child {
  width: 34px;
  height: 34px;
  object-fit: contain;
}

.party-room__music-widget span > img:last-child {
  position: absolute;
  z-index: 1;
  top: -2px;
  left: 6px;
  width: 25px;
  height: 33px;
  object-fit: contain;
}

.party-room__music-widget span.is-playing > img:first-child {
  animation: party-music-rotate 4s linear infinite;
}

.party-room__composer input {
  width: 100%;
  height: 34px;
  padding: 7px 8px 7px 16px;
  border: 0;
  outline: 0;
  background: transparent;
  color: var(--color-on-dark);
  font: inherit;
  font-size: 12px;
  line-height: 20px;
}

.party-room__composer input::placeholder {
  color: var(--color-feedback-placeholder);
}

.party-room__composer > button:disabled {
  opacity: 0.38;
}

@media (width <= 380px) {
  .party-room__header {
    margin-top: -7px;
  }

  .party-room__stage {
    padding-top: 4px;
  }

  .party-room__footer {
    min-height: var(--party-room-footer-occupied-height);
  }
}

@media (height <= 740px) {
  .party-room__video-stage.is-six-only {
    height: min(82.667vw, 310px);
  }
}

@keyframes party-seat-pulse {
  from {
    box-shadow:
      0 0 0 2px var(--color-party-accent-fuchsia),
      0 0 10px color-mix(in srgb, var(--color-party-accent-fuchsia) 38%, transparent);
  }

  to {
    box-shadow:
      0 0 0 3px var(--color-party-accent-fuchsia),
      0 0 24px color-mix(in srgb, var(--color-party-accent-fuchsia) 72%, transparent);
  }
}

@keyframes party-music-rotate {
  to {
    transform: rotate(1turn);
  }
}

@media (prefers-reduced-motion: reduce) {
  .party-room__seat-row > button.is-speaking .party-room__seat-avatar,
  .party-room__music-widget span.is-playing > img:first-child {
    animation: none;
  }
}
</style>

<script setup lang="ts">
import { getRuntimeConfig } from '@/core/config/runtime-config'
import type { ConversationTarget } from '@/features/messages/contracts'
import type { RoomLaunchContext } from '@/features/rooms/contracts'
import { accountPreferences } from '@/core/storage/account-preferences'
import { appActivity } from '@/core/runtime/app-activity'
import {
  applicationRecoveryCoordinator,
  type ApplicationRecoveryContext,
} from '@/core/runtime/application-recovery-coordinator'
import { hasRtcTokenServer, requestRtcToken } from '@/features/rooms/rtc-token-service'
import { LiveRoomUnavailableError } from '@/features/rooms/live-errors'
import { createLiveChatroomController } from '@/features/rooms/live-chatroom-controller'
import { createLiveRoomEffectScheduler } from '@/features/rooms/live-room-effect-scheduler'
import type { LiveEntryEffect } from '@/features/rooms/chatroom-contracts'
import LiveAnchorCardSheet from '@/features/rooms/components/LiveAnchorCardSheet.vue'
import LiveAnchorRankSheet from '@/features/rooms/components/LiveAnchorRankSheet.vue'
import LiveAudienceSheet from '@/features/rooms/components/LiveAudienceSheet.vue'
import LiveContributionSheet from '@/features/rooms/components/LiveContributionSheet.vue'
import LiveEffectPlayer from '@/features/rooms/components/LiveEffectPlayer.vue'
import LiveGiftSheet from '@/features/rooms/components/LiveGiftSheet.vue'
import LiveGameCenterSheet from '@/features/rooms/components/LiveGameCenterSheet.vue'
import LiveHalfGamePanel from '@/features/rooms/components/LiveHalfGamePanel.vue'
import LiveMoreSheet from '@/features/rooms/components/LiveMoreSheet.vue'
import LiveRpsSheet from '@/features/rooms/components/LiveRpsSheet.vue'
import LiveWheelWidget from '@/features/rooms/components/LiveWheelWidget.vue'
import LiveWheelEntrance from '@/features/rooms/components/LiveWheelEntrance.vue'
import LivePkRankSheet from '@/features/rooms/components/LivePkRankSheet.vue'
import LivePkStage from '@/features/rooms/components/LivePkStage.vue'
import LiveTerminalState from '@/features/rooms/components/LiveTerminalState.vue'
import LiveWishlist from '@/features/rooms/components/LiveWishlist.vue'
import type { LiveGiftItem, LiveWishItem } from '@/features/rooms/live-interaction-contracts'
import type {
  GameCatalog,
  GameItem,
  GameLaunchSpec,
  LiveRpsConfig,
  LiveWheelConfig,
} from '@/features/game/contracts'
import type { RechargeOptions } from '@/core/bridge/recharge-options'
import {
  liveInteractionActions,
  liveInteractionQueries,
  liveQueries,
  liveRoomMessageActions,
  liveRoomMessageQueries,
} from '@/features/rooms/live-operations'
import {
  buildGameLaunch,
  queryHalfGameCatalog,
  queryLiveRpsConfig,
  queryLiveWheelConfig,
} from '@/features/game/game-operations'
import { LivePkSession } from '@/features/rooms/live-pk-session'
import { LIVE_PK_STATUS } from '@/features/rooms/live-pk-contracts'
import type { LivePkSide } from '@/features/rooms/live-pk-operations'
import {
  createLivePkPreviewFixture,
  type LivePkPreviewFixture,
  type LivePkPreviewPerson,
} from '@/features/rooms/live-pk-preview'
import { useRoomPresentation } from '@/features/rooms/presentation'
import { useAsyncAction } from '@/main/composables/useAsyncAction'
import AppAnchorLevelBadge from '@/main/components/AppAnchorLevelBadge.vue'
import AppAvatar from '@/main/components/AppAvatar.vue'
import AppHeadFrame from '@/main/components/AppHeadFrame.vue'
import AppIcon from '@/main/components/AppIcon.vue'
import AppImage from '@/main/components/AppImage.vue'
import AppLoadLoadingIcon from '@/main/components/AppLoadLoadingIcon.vue'
import AppPopup from '@/main/components/AppPopup.vue'
import RoomMessageStack from '@/main/components/RoomMessageStack.vue'
import AppUserLevelTag from '@/main/components/AppUserLevelTag.vue'
import { computed, nextTick, onBeforeUnmount, onMounted, ref, shallowRef, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import { useSessionStore } from '@/main/stores/session'
import { useMessagesStore } from '@/main/stores/messages'
import { useRelationshipsStore } from '@/main/stores/relationships'
import { useAppFeedback } from '@/main/ui/feedback'
import { publicAsset } from '@/core/media/public-asset'
import { rtcFailureKind, rtcFailureReference, rtcRoomEngine } from './runtime/rtc-room-engine'
import { decideLiveRoomResume } from './live-room-recovery'
import {
  isValidLiveTopGiver,
  isChatNearBottom,
  selectLiveTopGiver,
  shouldObscureLiveCover,
  shouldStartInitialChatScroll,
} from './live-room-ui-policy'
import { markLiveEntryStage } from '@/features/rooms/live-entry-performance'
import {
  LEGACY_LIVE_HOST_BADGE_URL,
  LEGACY_LIVE_NEW_USER_BADGE_URL,
  LEGACY_LIVE_USER_ENTRY_BACKGROUND_RTL_URL,
  LEGACY_LIVE_USER_ENTRY_BACKGROUND_URL,
  legacyChatBubbleStyle,
  legacyGuardianBadgeUrl,
  legacyGuardianEntryStyle,
  legacyUserEntryStyle,
} from '@/features/rooms/live-message-presentation'
import type { GiftPanelRechargeRequest } from '@/shared/gifts/contracts'
import { useLiveClearScreenGesture } from './use-live-clear-screen-gesture'
interface RoomGiftBanner {
  avatarUrl: string
  count: number
  giftIconUrl: string
  giftName: string
  key: string
  sender: string
  visible: boolean
}
type LiveTerminalReason = 'ended' | 'failed'
const WISHLIST_REFRESH_DEBOUNCE_MS = 800
const CHAT_SAFETY_IMAGE_WAIT_MS = 600
const CHAT_SMOOTH_SCROLL_SETTLE_MS = 360
// Keep unverified live games and metrics dormant: no render and no request.
// Re-enable each vertical slice only after remote API and device acceptance.
const LIVE_ROOM_GAMES_VISIBLE = false
const LIVE_ROOM_METRICS_VISIBLE = false
const LIVE_ROOM_WHEEL_VISIBLE = true

function richEntryPersonStyle(effect: LiveEntryEffect): Record<string, string> {
  if (effect.style === 'guardian')
    return legacyGuardianEntryStyle(effect.guardianLevel) as Record<string, string>
  if (effect.style === 'high-level')
    return legacyUserEntryStyle(effect.userLevel) as Record<string, string>
  return {
    '--room-entry-background': `url(${LEGACY_LIVE_USER_ENTRY_BACKGROUND_URL})`,
    '--room-entry-background-rtl': `url(${LEGACY_LIVE_USER_ENTRY_BACKGROUND_RTL_URL})`,
  }
}

const props = defineProps<{
  context: RoomLaunchContext
}>()

const emit = defineEmits<{
  closed: []
  interactionLock: [locked: boolean]
  message: [profile: { avatar: string; id: string; imAccount: string; name: string }]
  recharge: [options: RechargeOptions]
  report: [context: { hostId: string; roomId: string }]
  runtimeFailed: [roomId: string]
  runtimeReady: [roomId: string]
}>()

const { t } = useI18n()
const feedback = useAppFeedback()
const presentation = useRoomPresentation()
liveInteractionActions.beginSession(props.context)
const session = useSessionStore()
const relationships = useRelationshipsStore()
const chatroom = createLiveChatroomController()
const realtimeEnabled = false
const roomEffectScheduler = createLiveRoomEffectScheduler(props.context.roomId)
const pkSession = new LivePkSession()
const pkOpponentMuted = ref(false)
const chatList = ref<HTMLElement | null>(null)
const chatSafetyImage = ref<HTMLImageElement | null>(null)
const liveChatField = ref<HTMLElement | null>(null)
const chatDraft = ref('')
const chatPinnedToBottom = ref(true)
const localVideo = ref<HTMLElement | null>(null)
const remoteVideo = ref<HTMLElement | null>(null)
const fallbackVideo = ref<HTMLVideoElement | null>(null)
const fallbackVideoMuted = ref(false)
let fallbackVideoPositioned = false
const liveWheelWidget = ref<{ close: () => void; open: () => void } | null>(null)
const pkHostVideo = ref<HTMLElement | null>(null)
const startedAt = ref(0)
const closing = ref(false)
const liveTerminalReason = ref<LiveTerminalReason | null>(null)
const showExitPrompt = ref(false)
const showAudience = ref(false)
const showContribution = ref(false)
const showAnchorRank = ref(false)
const showMessages = ref(false)
const messageConversationTarget = shallowRef<ConversationTarget | null>(null)
const showGameCenter = ref(false)
const showHalfGame = ref(false)
const halfGameCatalog = shallowRef<GameCatalog | null>(null)
const halfGameCatalogError = ref(false)
const halfGameCatalogLoading = ref(false)
const halfGameLaunch = shallowRef<GameLaunchSpec | null>(null)
const halfGameLaunchingId = ref('')
const audienceInitialTab = ref<'rank' | 'viewers'>('viewers')
const showAnchorCard = ref(false)
const showMore = ref(false)
const showEffectSettings = ref(false)
const showGiftPanel = ref(false)
const showRps = ref(false)
const liveRpsConfig = shallowRef<LiveRpsConfig | null>(null)
const rpsAvailable = computed(() => Boolean(liveRpsConfig.value))
const liveWheelConfig = shallowRef<LiveWheelConfig | null>(null)
const liveWheelOpen = ref(false)
const liveWheelEnabled = ref(props.context.wheelEnabled === true)
const wheelInteractionLocked = ref(false)
const showPkRank = ref(false)
const showPkPreview = ref(false)
const pkRankSide = ref<LivePkSide>('left')
const pkPreviewFixture = shallowRef<LivePkPreviewFixture | null>(null)
const pkPreviewStatus = ref<number>(LIVE_PK_STATUS.inPk)
const showChatComposer = ref(false)
type GameCenterDestination =
  { kind: 'half'; launch: GameLaunchSpec } | { kind: 'rps' } | { kind: 'wheel' }
const pendingGameCenterDestination = shallowRef<GameCenterDestination | null>(null)
const clearScreenExitVisible = ref(false)
const effectsEnabled = ref(true)
const reducedMotion = ref(false)
const selectedGiftId = ref<number | null>(null)
type MoreDestination = 'effect' | 'pk-preview' | 'report'
const pendingMoreDestination = ref<MoreDestination | null>(null)
let pendingPkRankGift = false
let pendingAnchorRankGift = false
let pkPreviewScoreTimer = 0
let clearScreenTimer = 0
const profileTarget = ref<{
  avatarUrl: string
  id: string
  name: string
} | null>(null)
relationships.seed({
  followed: Boolean(props.context.followed),
  userId: props.context.hostId ?? '',
  userType: 2,
})
const followed = computed(
  () =>
    relationships.relationship(props.context.hostId ?? '', {
      followed: Boolean(props.context.followed),
      followedKnown: props.context.followed !== undefined,
      userType: 2,
    }).followed,
)
const showFollowPrompt = ref(false)
const showWishlistGuide = ref(false)
const liveHotScore = ref(props.context.hotScore ?? 0)
const liveIncome = ref(props.context.currentLiveIncome ?? 0)
const liveTopGiver = ref(
  isValidLiveTopGiver(props.context.topGiver) ? props.context.topGiver : undefined,
)
const fallbackAudienceTotal = ref(props.context.onlineCount ?? props.context.audience?.length ?? 0)
const giftBanners = ref<RoomGiftBanner[]>([])
const wishlist = ref<readonly LiveWishItem[]>(
  liveInteractionQueries.peekWishlist(props.context.roomId) ?? [],
)
const wishlistHasIncomplete = computed(() =>
  wishlist.value.some((wish) => wish.target > 0 && wish.completed < wish.target),
)
let handlingRoomEnd = false
let closePromise: Promise<void> | null = null
let refreshCredentialBeforeJoin = false
let destroyed = false
let roomSwitchReleased = false
let finalTeardownCompleted = false
let runtimeFailureReported = false
let runtimeReadyReported = false
let pkSessionStarted = false
let retainedLiveFailure = false
let entryEffectReported = false
let halfGameCatalogLoadedAt = 0
let returnToGameCenterAfterHalfGame = false
let wishlistLoaded = false
let anchorCardLoaded = false
let rankLoaded = false
let rankResolved = false
let realtimeTopGiverRevision = 0
let rankEpoch = 0
let rpsConfigResolved = false
let wheelConfigResolved = false
let wheelConfigEpoch = 0
let halfGameCatalogPreload: Promise<void> | null = null
let wishlistPreload: Promise<void> | null = null
let anchorCardPreload: Promise<void> | null = null
let rankPreload: Promise<void> | null = null
let rpsConfigPreload: Promise<void> | null = null
let wheelConfigPreload: Promise<void> | null = null
let wishlistRefreshTimer = 0
let giftSendSequence = 0
let followPromptTimer = 0
let stopRecoveryParticipant: (() => void) | undefined
let motionPreference: MediaQueryList | null = null
let deferredEntryEffect: LiveEntryEffect | null = null
let initialChatScrollCompleted = false
let initialChatScrollEpoch = 0
let initialChatScrollPromise: Promise<void> | null = null
let chatInteractionRevision = 0
const giftBannerTimers = new Map<string, number>()
let launchContext: RoomLaunchContext = { ...props.context }
const lifecycleOwner = Symbol(`room:${props.context.roomId}`)
const interactionController = new AbortController()
const messagesStore = useMessagesStore()
const pkPreviewAllowed =
  import.meta.env.DEV && getRuntimeConfig().debug.vConsoleEnabled && props.context.mode === 'live'

function giftEffectOwner(): string {
  return `live:${props.context.roomId}`
}

const giftRechargeCovered = false
const gameCenterAvailable = computed(
  () =>
    LIVE_ROOM_GAMES_VISIBLE &&
    props.context.mode === 'live' &&
    props.context.role === 'audience' &&
    (rpsAvailable.value ||
      Boolean(liveWheelConfig.value) ||
      Boolean(halfGameCatalog.value?.games.length)),
)
const liveWheelFeatureAvailable = computed(
  () =>
    LIVE_ROOM_WHEEL_VISIBLE && props.context.mode === 'live' && props.context.role === 'audience',
)
const liveWheelEntranceVisible = computed(
  () =>
    liveWheelFeatureAvailable.value &&
    appActivity.value.visible &&
    liveUiReady.value &&
    liveWheelEnabled.value &&
    Boolean(liveWheelConfig.value) &&
    !displayedPkVisible.value,
)

const roomInteractionLocked = computed(
  () =>
    liveTerminalReason.value !== null ||
    showExitPrompt.value ||
    showAudience.value ||
    showContribution.value ||
    showAnchorRank.value ||
    showMessages.value ||
    Boolean(messageConversationTarget.value) ||
    showGameCenter.value ||
    showHalfGame.value ||
    showAnchorCard.value ||
    pendingMoreDestination.value !== null ||
    showGiftPanel.value ||
    showRps.value ||
    wheelInteractionLocked.value ||
    showPkRank.value ||
    showMore.value ||
    showEffectSettings.value ||
    showChatComposer.value ||
    closing.value,
)

const {
  beginClearScreenGesture,
  cancelClearScreenGesture,
  cleanProgress,
  finishClearScreenGesture,
  moveClearScreenGesture,
  resetClearScreenGesture: resetCleanGesture,
  screenCleared,
  setScreenCleared,
} = useLiveClearScreenGesture({
  canStart: () =>
    props.context.mode === 'live' &&
    props.context.role === 'audience' &&
    liveUiReady.value &&
    !displayedPkVisible.value &&
    !liveTerminalReason.value &&
    !closing.value &&
    (!roomInteractionLocked.value || screenCleared.value),
  isRtl: () => document.documentElement.dir === 'rtl',
})
const cleanLeftStyle = computed(() => {
  const direction = document.documentElement.dir === 'rtl' ? 1 : -1
  return {
    opacity: String(1 - cleanProgress.value),
    pointerEvents: cleanProgress.value > 0.6 ? ('none' as const) : undefined,
    transform: `translate3d(${direction * 20 * cleanProgress.value}px, 0, 0)`,
  }
})
const cleanBottomStyle = computed(() => ({
  opacity: String(1 - cleanProgress.value),
  pointerEvents: cleanProgress.value > 0.6 ? ('none' as const) : undefined,
  transform: `translate3d(0, ${18 * cleanProgress.value}px, 0)`,
}))

async function renewRoomToken(roomContext: RoomLaunchContext): Promise<string> {
  const credential = await requestRtcToken(roomContext)
  launchContext = {
    ...launchContext,
    expiresAt: credential.expiresAt,
    rtmToken: credential.rtmToken,
    rtcToken: credential.rtcToken,
  }
  return credential.rtcToken
}

const statusText = computed(() => {
  if (rtcRoomEngine.state.value === 'reconnecting') return t('room.reconnecting')
  if (rtcRoomEngine.state.value === 'waiting-first-frame') return t('room.connecting')
  if (rtcRoomEngine.state.value === 'waiting-stream') return t('room.waitingForHost')
  if (rtcRoomEngine.state.value === 'stream-ended') return t('room.liveEnded')
  if (rtcRoomEngine.state.value === 'failed') return t('room.failed')
  if (rtcRoomEngine.state.value === 'active') {
    if (props.context.role === 'audience') return t('room.audience')
    return props.context.role === 'cohost' ? t('room.speaker') : t('room.host')
  }
  return t('room.connecting')
})

const permissionDenied = computed(() => {
  const error = rtcRoomEngine.error.value
  return (
    error?.name === 'NotAllowedError' || /permission|notallowed|denied/iu.test(error?.message ?? '')
  )
})
const failureText = computed(() => {
  const key = rtcFailureKind(rtcRoomEngine.error.value)
  if (key === 'bundle') return t('room.failureBundle')
  if (key === 'uid-conflict') return t('room.failureUidConflict')
  if (key === 'insecure-context') return t('room.failureInsecureContext')
  if (key === 'unsupported') return t('room.failureUnsupported')
  if (key === 'token') return t('room.failureToken')
  if (key === 'network') return t('room.failureNetwork')
  return t('room.failed')
})
const failureReference = computed(() => rtcFailureReference(rtcRoomEngine.error.value))
const viewerCount = computed(() =>
  chatroom.state.value === 'connected'
    ? Math.max(0, chatroom.onlineCount.value)
    : fallbackAudienceTotal.value,
)
const viewerSubtitleCount = computed(() =>
  viewerCount.value > 0 ? viewerCount.value : (props.context.onlineCount ?? 0),
)
const compactViewerCount = computed(() => {
  const count = viewerCount.value
  if (count <= 0) return ''
  if (count < 1000) return String(count)
  return `${Math.floor(count / 1000)}k+`
})
function formatCompactMetric(value: number): string {
  const normalized = Math.max(0, value)
  if (normalized < 1_000) return normalized.toLocaleString('en')
  const units = [
    { divisor: 1_000_000_000, suffix: 'B' },
    { divisor: 1_000_000, suffix: 'M' },
    { divisor: 1_000, suffix: 'K' },
  ] as const
  const unit = units.find((candidate) => normalized >= candidate.divisor) ?? units[2]
  return `${(normalized / unit.divisor).toFixed(1).replace(/\.0$/u, '')}${unit.suffix}`
}
const chatPlaceholder = computed(() => {
  if (chatroom.muted.value || chatroom.roomMuted.value) return t('room.chatMuted')
  if (chatroom.state.value === 'kicked') return t('room.chatKicked')
  if (chatroom.state.value !== 'connected') return t('room.chatConnecting')
  return props.context.mode === 'live' ? t('room.liveChatPlaceholder') : t('room.chatPlaceholder')
})
const chatDisabled = computed(
  () =>
    chatroom.state.value !== 'connected' ||
    chatroom.muted.value ||
    chatroom.roomMuted.value ||
    closing.value,
)
const pkVisible = computed(() => props.context.mode === 'live' && pkSession.visible.value)
const pkPreviewActive = computed(
  () =>
    pkPreviewAllowed &&
    showPkPreview.value &&
    Boolean(pkPreviewFixture.value) &&
    !pkVisible.value &&
    !liveTerminalReason.value,
)
const displayedPkVisible = computed(() => pkVisible.value || pkPreviewActive.value)
const pkDisplayDetail = computed(() =>
  pkVisible.value ? pkSession.detail.value : (pkPreviewFixture.value?.detail ?? null),
)
const pkDisplayPhase = computed(() =>
  pkPreviewActive.value
    ? pkPreviewStatus.value === LIVE_PK_STATUS.punishing
      ? ('punishing' as const)
      : ('active' as const)
    : pkSession.phase.value,
)
const pkDisplayState = computed(() =>
  pkPreviewActive.value ? ('active' as const) : rtcRoomEngine.pkState.value,
)
const pkDisplayStatus = computed(() =>
  pkPreviewActive.value ? pkPreviewStatus.value : pkSession.status.value,
)
const pkPreviewButtonLabel = computed(() => {
  if (!pkPreviewActive.value) return t('room.pkPreviewStart')
  return pkPreviewStatus.value === LIVE_PK_STATUS.punishing
    ? t('room.pkPreviewEnd')
    : t('room.pkPreviewPunishment')
})
const pkPreviewRankRows = computed(() =>
  pkPreviewActive.value ? pkPreviewFixture.value?.ranks[pkRankSide.value] : undefined,
)
const anchorCardContext = computed<RoomLaunchContext>(() => {
  const target = profileTarget.value
  if (!target) return props.context
  return {
    ...props.context,
    displayName: target.name,
    hostAvatarUrl: target.avatarUrl,
    hostId: target.id,
    hostImAccount: target.id === props.context.hostId ? props.context.hostImAccount : undefined,
    hostUserType: target.id === props.context.hostId ? 2 : undefined,
  }
})
// Agora Runtime 是跨 RoomApp 复用的单例，不能直接用它残留的上一房首帧指标
// 决定新房 UI。每个房间实例从关闭态开始，只在本房 active + 首帧成立后单向打开。
const liveUiReady = ref(
  !realtimeEnabled || props.context.mode !== 'live' || props.context.role !== 'audience',
)
const liveTerminalDescription = computed(() =>
  liveTerminalReason.value === 'ended' ? t('room.liveEndedDescription') : failureText.value,
)
const chatSurfaceAvailable = computed(() =>
  realtimeEnabled ? Boolean(props.context.chatRoomId) : true,
)
const liveCoverObscured = computed(() =>
  shouldObscureLiveCover({
    liveUiReady: liveUiReady.value,
    mode: props.context.mode,
    role: props.context.role,
  }),
)
function acceptCurrentRoomFirstFrame(): boolean {
  if (liveTerminalReason.value) return false
  const ready =
    props.context.mode !== 'live' ||
    props.context.role !== 'audience' ||
    (rtcRoomEngine.state.value === 'active' && rtcRoomEngine.metrics.value.firstVideoAt !== null)
  if (!ready) return false
  liveUiReady.value = true
  runtimeFailureReported = false
  if (props.context.mode === 'live' && !pkSessionStarted) {
    pkSessionStarted = true
    rtcRoomEngine.setPkPlaybackMuted(false)
    pkSession.start(launchContext)
  }
  preloadRoomInteractions()
  reportEntryEffectAfterFirstFrame()
  if (!runtimeReadyReported) {
    runtimeReadyReported = true
    emit('runtimeReady', props.context.roomId)
  }
  return true
}

function attachHostVideoSurface(container: HTMLElement | null): void {
  if (props.context.role === 'audience') rtcRoomEngine.attachRemoteVideo(container)
  else rtcRoomEngine.attachLocalVideo(container)
}

async function setMediaSession(active: boolean): Promise<void> {
  void active
}

async function startRoom(): Promise<boolean> {
  if (destroyed || !appActivity.value.visible) return false
  rtcRoomEngine.setAppVisible(true)
  rtcRoomEngine.setPlaybackMuted(false)
  startedAt.value = Date.now()
  try {
    const credentialMissing = !launchContext.rtcToken
    const expiresSoon =
      launchContext.expiresAt !== undefined &&
      launchContext.expiresAt <= Math.floor(Date.now() / 1000) + 120
    const credentialTask =
      launchContext.appId &&
      hasRtcTokenServer() &&
      (credentialMissing || expiresSoon || refreshCredentialBeforeJoin)
        ? requestRtcToken(launchContext)
        : Promise.resolve(null)
    const runtimeTask =
      launchContext.mode === 'live' && launchContext.role === 'audience'
        ? rtcRoomEngine.warm()
        : Promise.resolve()
    const [credential] = await Promise.all([credentialTask, setMediaSession(true), runtimeTask])
    if (launchContext.mode === 'live' && launchContext.role === 'audience')
      markLiveEntryStage(launchContext.roomId, 'media-ready')
    if (credential) {
      launchContext = {
        ...launchContext,
        appId: credential.appId,
        expiresAt: credential.expiresAt,
        rtmToken: credential.rtmToken,
        rtcToken: credential.rtcToken,
      }
      refreshCredentialBeforeJoin = false
    }
    await nextTick()
    rtcRoomEngine.attachLocalVideo(localVideo.value)
    rtcRoomEngine.attachRemoteVideo(remoteVideo.value)
    await rtcRoomEngine.join(launchContext, { tokenProvider: renewRoomToken })
    acceptCurrentRoomFirstFrame()
    if (launchContext.mode === 'live' && launchContext.role === 'audience')
      markLiveEntryStage(launchContext.roomId, 'rtc-joined')
    await pkSession.resume()
    return true
  } catch (cause) {
    if (launchContext.mode === 'live' && launchContext.role === 'audience')
      markLiveEntryStage(launchContext.roomId, 'failed', true)
    rtcRoomEngine.markFailed(cause, 'ROOM_START_FAILED')
    await setMediaSession(false)
    return false
  }
}

async function startChatroom(): Promise<void> {
  if (!launchContext.chatRoomId || destroyed) return
  try {
    const credential = await session.ensureRealtimeCredential()
    if (!credential || destroyed) throw new Error('CHATROOM_CREDENTIAL_MISSING')
    const profile = session.profile
    await chatroom.connect({
      ...(launchContext.announcement?.trim()
        ? { announcementText: launchContext.announcement.trim() }
        : {}),
      credential,
      excludeHostFromOnlineCount: launchContext.mode === 'live',
      historyLimit: 5,
      hostImAccount: launchContext.hostImAccount,
      initialOnlineCount: launchContext.onlineCount ?? 0,
      ...(launchContext.mode === 'live' ? { messageLimit: 150, messageTrimCount: 50 } : {}),
      roomId: launchContext.chatRoomId,
      user: {
        avatarUrl: profile?.avatarUrl || session.user?.avatar || '',
        displayName: profile?.displayName || session.user?.displayName || '',
        id: profile?.id || session.user?.id || '',
        ...(profile ? { isVip: profile.vip || profile.vipExpireAt > Date.now() } : {}),
        ...(profile?.levelName.trim() ? { userLevel: profile.levelName.trim() } : {}),
      },
    })
  } catch (cause) {
    if (destroyed) return
    chatroom.error.value = cause instanceof Error ? cause : new Error(String(cause))
    chatroom.state.value = 'failed'
  }
}

async function performClose(): Promise<void> {
  closing.value = true
  try {
    await disposeRoomRuntime()
    emit('closed')
  } finally {
    closing.value = false
  }
}

async function disposeRoomRuntime(): Promise<void> {
  if (finalTeardownCompleted) return
  closing.value = true
  invalidateLiveWheelConfig(false)
  stopPkPreview()
  clearRoomEffects()
  await pkSession.stop()
  await Promise.allSettled([rtcRoomEngine.dispose(), chatroom.close()])
  await setMediaSession(false)
  finalTeardownCompleted = true
}

async function teardownForRoomSwitch(): Promise<void> {
  if (roomSwitchReleased) return
  roomSwitchReleased = true
  invalidateLiveWheelConfig(false)
  showMore.value = false
  pendingMoreDestination.value = null
  dismissGameLayers()
  stopPkPreview()
  clearRoomEffects()
  await Promise.allSettled([pkSession.stop(), rtcRoomEngine.leave(), chatroom.close()])
}

async function suspendForRoomSwitch(): Promise<void> {
  if (destroyed || roomSwitchReleased) return
  liveWheelOpen.value = false
  liveWheelWidget.value?.close()
  wheelInteractionLocked.value = false
  clearRoomEffects()
  chatroom.setAppVisible(false)
  rtcRoomEngine.setPlaybackMuted(true)
}

async function resumeAfterRoomSwitchFailure(): Promise<void> {
  if (destroyed || roomSwitchReleased) return
  rtcRoomEngine.setPlaybackMuted(false)
  chatroom.setAppVisible(true)
}

function performSingleClose(): Promise<void> {
  if (closePromise) return closePromise
  closePromise = performClose().finally(() => {
    closePromise = null
  })
  return closePromise
}

function resetClearScreen(): void {
  window.clearTimeout(clearScreenTimer)
  clearScreenTimer = 0
  clearScreenExitVisible.value = false
  resetCleanGesture()
}

function setClearScreen(cleared: boolean): void {
  setScreenCleared(cleared)
}

function clearRoomEffects(): void {
  window.clearTimeout(wishlistRefreshTimer)
  wishlistRefreshTimer = 0
  roomEffectScheduler.clear()
  chatroom.clearEntryEffects()
  deferredEntryEffect = null
  giftBannerTimers.forEach((timer) => window.clearTimeout(timer))
  giftBannerTimers.clear()
  giftBanners.value = []
  window.clearTimeout(followPromptTimer)
  followPromptTimer = 0
  showFollowPrompt.value = false
}

async function enterLiveTerminal(reason: LiveTerminalReason): Promise<void> {
  if (destroyed || closing.value || props.context.mode !== 'live') return
  const retainRuntime = reason === 'failed' && rtcRoomEngine.hasRetainedRoom(props.context.roomId)
  retainedLiveFailure = retainRuntime
  stopPkPreview()
  liveTerminalReason.value = reason
  liveUiReady.value = false
  runtimeReadyReported = false
  clearRoomEffects()
  invalidateLiveWheelConfig(false)
  resetClearScreen()
  showAudience.value = false
  showContribution.value = false
  showAnchorRank.value = false
  showMessages.value = false
  messageConversationTarget.value = null
  showAnchorCard.value = false
  showMore.value = false
  showEffectSettings.value = false
  showGiftPanel.value = false
  showRps.value = false
  pendingMoreDestination.value = null
  dismissGameLayers()
  showPkRank.value = false
  pendingPkRankGift = false
  pendingAnchorRankGift = false
  showChatComposer.value = false
  if (retainRuntime) {
    pkSession.suspend()
    return
  }
  await pkSession.stop()
  await Promise.allSettled([rtcRoomEngine.leave(), chatroom.close()])
  await setMediaSession(false)
}

function scheduleFollowPrompt(): void {
  window.clearTimeout(followPromptTimer)
  if (props.context.mode !== 'live' || !props.context.followPromptDelaySeconds) return
  followPromptTimer = window.setTimeout(() => {
    followPromptTimer = 0
    if (!destroyed && !followed.value) showFollowPrompt.value = true
  }, props.context.followPromptDelaySeconds * 1000)
}

function currentPkPreviewPerson(): LivePkPreviewPerson | null {
  const profile = session.profile
  const id = profile?.id || session.user?.id || ''
  if (!id) return null
  return {
    avatarUrl: profile?.avatarUrl || session.user?.avatar || '',
    countryCode: profile?.countryId,
    id,
    levelName: profile?.levelName,
    name: profile?.displayName || session.user?.displayName || t('room.pkPreviewMe'),
    vip: profile?.vip,
  }
}

function updatePkPreviewDetail(
  update: (detail: LivePkPreviewFixture['detail']) => LivePkPreviewFixture['detail'],
): void {
  const fixture = pkPreviewFixture.value
  if (!fixture) return
  pkPreviewFixture.value = { ...fixture, detail: update(fixture.detail) }
}

function stopPkPreview(): void {
  window.clearInterval(pkPreviewScoreTimer)
  pkPreviewScoreTimer = 0
  showPkPreview.value = false
  pkPreviewFixture.value = null
  pkPreviewStatus.value = LIVE_PK_STATUS.inPk
  pkOpponentMuted.value = false
  showPkRank.value = false
  pendingPkRankGift = false
}

function startPkPreview(): void {
  if (!pkPreviewAllowed || pkVisible.value || !liveUiReady.value) return
  const opponent: LivePkPreviewPerson = {
    avatarUrl: publicAsset('notification/avatar-sample@2x.png'),
    id: 'pk-preview-opponent',
    name: t('room.pkPreviewOpponent'),
  }
  pkPreviewFixture.value = createLivePkPreviewFixture(
    props.context,
    opponent,
    currentPkPreviewPerson(),
  )
  pkPreviewStatus.value = LIVE_PK_STATUS.inPk
  showPkPreview.value = true
  let tick = 0
  window.clearInterval(pkPreviewScoreTimer)
  pkPreviewScoreTimer = window.setInterval(() => {
    if (!pkPreviewActive.value || pkPreviewStatus.value !== LIVE_PK_STATUS.inPk) return
    tick += 1
    updatePkPreviewDetail((detail) => ({
      ...detail,
      leftScore: (detail.leftScore ?? 0) + (tick % 3 === 0 ? 96 : 42),
      rightScore: (detail.rightScore ?? 0) + (tick % 2 === 0 ? 74 : 28),
    }))
  }, 1_200)
}

function advancePkPreview(): void {
  if (!pkPreviewActive.value) startPkPreview()
  else if (pkPreviewStatus.value === LIVE_PK_STATUS.inPk) {
    window.clearInterval(pkPreviewScoreTimer)
    pkPreviewScoreTimer = 0
    pkPreviewStatus.value = LIVE_PK_STATUS.punishing
    updatePkPreviewDetail((detail) => ({
      ...detail,
      remainSeconds: 12,
      status: LIVE_PK_STATUS.punishing,
    }))
  } else stopPkPreview()
}

function advancePkPreviewFromMore(): void {
  queueMoreDestination('pk-preview')
}

function attachPkSurface(side: LivePkSide, element: HTMLElement | null): void {
  if (side === 'left') {
    pkHostVideo.value = element
    if (element) attachHostVideoSurface(element)
    return
  }
  if (pkPreviewActive.value) {
    rtcRoomEngine.attachPkRemoteVideo(null)
    return
  }
  rtcRoomEngine.attachPkRemoteVideo(element)
}

function togglePkOpponentSound(): void {
  pkOpponentMuted.value = !pkOpponentMuted.value
  if (!pkPreviewActive.value) rtcRoomEngine.setPkPlaybackMuted(pkOpponentMuted.value)
}

function openPkOpponent(): void {
  if (pkPreviewActive.value) {
    feedback.notify(t('room.pkPreviewProfileUnavailable'))
    return
  }
  const detail = pkDisplayDetail.value
  if (!detail?.rightUserId.trim()) return
  profileTarget.value = {
    avatarUrl: detail.rightAvatarUrl,
    id: detail.rightUserId,
    name: detail.rightName || detail.rightUserId,
  }
  showAnchorCard.value = true
}

function openPkRank(side: LivePkSide): void {
  const detail = pkDisplayDetail.value
  if (!detail?.pkId.trim()) {
    feedback.notify(t('room.pkUnavailable'))
    return
  }
  pendingPkRankGift = false
  pkRankSide.value = side
  showPkRank.value = true
}

function resolvePkRankDetail() {
  return pkSession.refreshDetailForRank()
}

function supportPkStreamer(): void {
  pendingPkRankGift = true
}

function flushPendingPkRankGift(): void {
  if (!pendingPkRankGift || destroyed || closing.value || !displayedPkVisible.value) return
  pendingPkRankGift = false
  openGiftPanel()
}

async function performRetry(): Promise<void> {
  if (props.context.mode !== 'live') {
    await rtcRoomEngine.leave()
    const roomStarted = await startRoom()
    if (!roomStarted) throw rtcRoomEngine.error.value ?? new Error('ROOM_RETRY_FAILED')
    await startChatroom()
    return
  }
  try {
    // 与旧站 retryCurrentRoom 一致：重新获取整套进房数据。终态层在校验成功前保持，
    // 避免先露出旧主播信息或用旧 uid/channel/token 原地重试。
    const refreshed = await presentation.revalidateActiveLive()
    if (destroyed || closing.value) return
    launchContext = { ...refreshed }
    invalidateLiveWheelConfig(launchContext.wheelEnabled === true)
    resetLiveRankForRebuild(launchContext)
    refreshCredentialBeforeJoin = false
    retainedLiveFailure = false
    await Promise.allSettled([rtcRoomEngine.leave(), chatroom.close()])
    if (destroyed || closing.value) return
    runtimeFailureReported = false
    runtimeReadyReported = false
    pkSessionStarted = true
    pkSession.start(launchContext, { suspended: true })
    const [roomStarted] = await Promise.all([startRoom(), startChatroom()])
    if (!roomStarted) throw rtcRoomEngine.error.value ?? new Error('LIVE_ROOM_RETRY_FAILED')
    liveTerminalReason.value = null
    liveUiReady.value = launchContext.role !== 'audience'
    acceptCurrentRoomFirstFrame()
  } catch (cause) {
    if (cause instanceof LiveRoomUnavailableError) {
      presentation.markRoomEnded(props.context.roomId)
      await enterLiveTerminal('ended')
      return
    }
    await enterLiveTerminal('failed')
    throw cause
  }
}

async function performOpenSettings(): Promise<void> {
  // Standalone room H5 has no settings bridge. Browser media permission UI is authoritative.
}

async function performToggleMicrophone(): Promise<void> {
  await rtcRoomEngine.setMicrophoneMuted(!rtcRoomEngine.microphoneMuted.value)
}

async function performSendChat(value: string): Promise<void> {
  chatPinnedToBottom.value = true
  if (!realtimeEnabled) {
    const currentUserId = session.profile?.id || session.user?.id || ''
    const saved = await liveRoomMessageActions.send(props.context.roomId, currentUserId, value)
    chatroom.appendPersistedMessage(saved)
    chatDraft.value = ''
    return
  }
  await chatroom.sendText(value)
  chatDraft.value = ''
}

async function performToggleFollow(): Promise<void> {
  const hostId = props.context.hostId?.trim() ?? ''
  if (!hostId) throw new Error('This host is unavailable.')
  const next = !followed.value
  await relationships.setFollowed(
    {
      imAccount: props.context.hostImAccount,
      userId: hostId,
      userType: 2,
    },
    next,
  )
  if (next) showFollowPrompt.value = false
}

function handleGiftSent(payload: { gift: LiveGiftItem; quantity: number }): void {
  const { gift, quantity } = payload
  chatroom.appendLocalGift({
    avatarUrl: session.user?.avatar ?? '',
    count: quantity,
    giftEffectUrl: gift.effectUrl,
    giftId: String(gift.id),
    giftIconUrl: gift.iconUrl,
    giftName: gift.name,
    nickname: session.user?.displayName ?? 'Me',
    senderId: session.user?.id ?? '',
  })
  if (effectsEnabled.value && !reducedMotion.value)
    roomEffectScheduler.enqueueGift({
      dedupeKey: `live:self:${props.context.roomId}:${++giftSendSequence}`,
      url: gift.effectUrl,
    })
  const currentUserId = session.profile?.id || session.user?.id || ''
  const cachedOwn = liveInteractionQueries
    .peekRank(props.context.roomId, 'now')
    ?.find((row) => row.id === currentUserId)
  const previousOwnCost =
    cachedOwn?.cost ?? (liveTopGiver.value?.id === currentUserId ? liveTopGiver.value.cost : 0)
  const nextOwnCost = previousOwnCost + gift.price * quantity
  if (
    currentUserId &&
    (!liveTopGiver.value ||
      liveTopGiver.value.id === currentUserId ||
      nextOwnCost >= liveTopGiver.value.cost)
  )
    liveTopGiver.value = {
      avatarUrl: session.profile?.avatarUrl || session.user?.avatar || '',
      cost: nextOwnCost,
      id: currentUserId,
    }
  scheduleWishlistRefresh()
}

function requestRecharge(request: GiftPanelRechargeRequest): void {
  emit('recharge', {
    originKey: giftEffectOwner(),
    requiredDiamonds: request.requiredDiamonds,
    source: 'live',
  })
}

function requestRpsRecharge(requiredDiamonds: number): void {
  emit('recharge', {
    originKey: giftEffectOwner(),
    requiredDiamonds,
    source: 'live',
  })
}

function queueGameCenterDestination(destination: GameCenterDestination): void {
  pendingGameCenterDestination.value = destination
  showGameCenter.value = false
}

function selectRpsFromGameCenter(): void {
  queueGameCenterDestination({ kind: 'rps' })
}

function selectWheelFromGameCenter(): void {
  queueGameCenterDestination({ kind: 'wheel' })
}

async function selectHalfGame(game: GameItem): Promise<void> {
  if (halfGameLaunchingId.value) return
  const userId = session.user?.id?.trim() ?? ''
  if (!userId) {
    feedback.warning(t('game.startFailed'))
    return
  }
  halfGameLaunchingId.value = game.id
  try {
    const launch = await buildGameLaunch(
      {
        game,
        identity: { imToken: session.imToken, userId },
        roomId: props.context.roomId,
        scene: 'live_room',
        size: 'half',
      },
      interactionController.signal,
    )
    queueGameCenterDestination({ kind: 'half', launch })
  } catch {
    feedback.warning(t('game.startFailed'))
  } finally {
    halfGameLaunchingId.value = ''
  }
}

async function handleGameCenterClosed(): Promise<void> {
  const destination = pendingGameCenterDestination.value
  pendingGameCenterDestination.value = null
  if (!destination || destroyed || closing.value || liveTerminalReason.value) return
  if (destination.kind === 'rps') showRps.value = true
  else if (destination.kind === 'wheel') {
    liveWheelOpen.value = true
    await nextTick()
    liveWheelWidget.value?.open()
  } else {
    halfGameLaunch.value = destination.launch
    returnToGameCenterAfterHalfGame = true
    showHalfGame.value = true
  }
}

function handleHalfGameClosed(): void {
  halfGameLaunch.value = null
  const shouldReturn = returnToGameCenterAfterHalfGame
  returnToGameCenterAfterHalfGame = false
  if (
    !shouldReturn ||
    destroyed ||
    closing.value ||
    liveTerminalReason.value ||
    !appActivity.value.visible
  )
    return
  openGameCenter()
}

function dismissGameLayers(): void {
  pendingGameCenterDestination.value = null
  showGameCenter.value = false
  returnToGameCenterAfterHalfGame = false
  showHalfGame.value = false
}

function toggleLiveWheel(): void {
  if (!liveWheelEntranceVisible.value) return
  if (wheelInteractionLocked.value) return
  liveWheelOpen.value = !liveWheelOpen.value
}

function handleWheelResult(payload: {
  anchorId: string
  dia: number
  incomeDiamondNum: number
  number: number
  text: string
}): void {
  if (destroyed || closing.value || !liveWheelOpen.value) return
  void chatroom
    .sendWheelResult(payload)
    .catch(() => feedback.warning(t('room.liveWheelUnavailable')))
}

function openHostMessage(): void {
  const id = props.context.hostId?.trim() ?? ''
  const imAccount = props.context.hostImAccount?.trim() || id
  if (!id) {
    feedback.error(t('room.messageUnavailable'))
    return
  }
  handleCardMessage({
    avatar: props.context.hostAvatarUrl ?? '',
    id,
    imAccount,
    name: props.context.displayName,
  })
}

function handleChatScroll(): void {
  const element = chatList.value
  if (!element) return
  chatPinnedToBottom.value = isChatNearBottom(element)
}

async function scrollChatToBottom(behavior: ScrollBehavior): Promise<void> {
  await nextTick()
  await waitForAnimationFrame()
  const element = chatList.value
  if (!element) return
  element.scrollTo({ behavior, top: element.scrollHeight })
}

function waitForAnimationFrame(): Promise<void> {
  return new Promise((resolve) => window.requestAnimationFrame(() => resolve()))
}

function waitForDelay(duration: number): Promise<void> {
  return new Promise((resolve) => window.setTimeout(resolve, duration))
}

function waitForChatSafetyImage(image: HTMLImageElement): Promise<void> {
  if (image.complete) {
    const decodeTask =
      typeof image.decode === 'function' ? image.decode().catch(() => undefined) : null
    return decodeTask
      ? Promise.race([decodeTask, waitForDelay(CHAT_SAFETY_IMAGE_WAIT_MS)]).then(() => undefined)
      : Promise.resolve()
  }
  return new Promise((resolve) => {
    const finish = (): void => {
      window.clearTimeout(timer)
      image.removeEventListener('error', finish)
      image.removeEventListener('load', finish)
      resolve()
    }
    const timer = window.setTimeout(finish, CHAT_SAFETY_IMAGE_WAIT_MS)
    image.addEventListener('error', finish, { once: true })
    image.addEventListener('load', finish, { once: true })
  })
}

function initialChatScrollReady(): boolean {
  return shouldStartInitialChatScroll({
    chatConnected: !launchContext.chatRoomId || chatroom.state.value === 'connected',
    chatSurfaceAvailable: chatSurfaceAvailable.value,
    completed: initialChatScrollCompleted,
    liveUiReady: liveUiReady.value,
  })
}

function resetInitialChatScroll(): void {
  initialChatScrollEpoch += 1
  initialChatScrollCompleted = false
  initialChatScrollPromise = null
  chatPinnedToBottom.value = true
}

function handleChatUserInteraction(): void {
  chatInteractionRevision += 1
  initialChatScrollCompleted = true
}

function ensureInitialChatBottom(): Promise<void> {
  if (initialChatScrollPromise) return initialChatScrollPromise
  if (!initialChatScrollReady()) return Promise.resolve()
  const epoch = initialChatScrollEpoch
  const interactionRevision = chatInteractionRevision
  const task = (async () => {
    await nextTick()
    const safetyImage = chatSafetyImage.value
    if (safetyImage) await waitForChatSafetyImage(safetyImage)
    await nextTick()
    await waitForAnimationFrame()
    await waitForAnimationFrame()
    if (destroyed || epoch !== initialChatScrollEpoch || !initialChatScrollReady()) return
    const element = chatList.value
    if (!element) return
    element.scrollTo({ behavior: 'smooth', top: element.scrollHeight })
    await waitForDelay(CHAT_SMOOTH_SCROLL_SETTLE_MS)
    if (destroyed || epoch !== initialChatScrollEpoch) return
    if (interactionRevision !== chatInteractionRevision) {
      initialChatScrollCompleted = true
      return
    }
    if (!isChatNearBottom(element)) {
      element.scrollTo({ behavior: 'instant', top: element.scrollHeight })
      await waitForAnimationFrame()
    }
    initialChatScrollCompleted = true
    chatPinnedToBottom.value = isChatNearBottom(element)
  })().finally(() => {
    if (initialChatScrollPromise === task) initialChatScrollPromise = null
  })
  initialChatScrollPromise = task
  return task
}

function handleChatSafetyImageSettled(): void {
  void ensureInitialChatBottom()
}

function handleComposerBlur(): void {
  window.setTimeout(() => {
    const input = liveChatField.value?.querySelector('input')
    if (document.activeElement !== input) showChatComposer.value = false
  }, 120)
}

function handleChatEnter(event: KeyboardEvent): void {
  if (event.isComposing) return
  event.preventDefault()
  void sendChat(chatDraft.value)
}

async function openChatComposer(): Promise<void> {
  showChatComposer.value = true
  await nextTick()
  window.requestAnimationFrame(() => {
    liveChatField.value?.querySelector('input')?.focus({ preventScroll: true })
  })
}

async function performRetryMessage(id: string): Promise<void> {
  await chatroom.retryMessage(id)
}

const closeRoomAction = useAsyncAction(performSingleClose, {
  feedback: 'blocking',
  loadingMessage: () => t('room.leaving'),
})
const retryAction = useAsyncAction(performRetry, {
  feedback: 'inline',
  loadingMessage: () => t('room.connecting'),
})
const settingsAction = useAsyncAction(performOpenSettings, {
  feedback: 'blocking',
  loadingMessage: () => t('common.loading'),
})
const microphoneAction = useAsyncAction(performToggleMicrophone, {
  feedback: 'inline',
  loadingMessage: () => t('room.updatingMicrophone'),
})
const sendChatAction = useAsyncAction(performSendChat, {
  errorMessage: () => t('room.chatSendFailed'),
  feedback: 'inline',
})
const retryChatAction = useAsyncAction(startChatroom, {
  errorMessage: () => t('room.chatUnavailable'),
  feedback: 'inline',
})
const retryMessageAction = useAsyncAction(performRetryMessage, {
  errorMessage: () => t('room.chatSendFailed'),
  feedback: 'inline',
})
const followAction = useAsyncAction(performToggleFollow, {
  errorMessage: () => 'Follow failed, try again.',
  feedback: 'blocking',
  minimumIntervalMs: 1000,
})

async function closeRoom(): Promise<void> {
  await closeRoomAction.run()
}

function requestExit(): void {
  if (closing.value || presentation.switching.value) return
  showExitPrompt.value = true
}

function handleLiveTopClose(): void {
  if (liveTerminalReason.value) {
    void closeRoom()
    return
  }
  requestExit()
}

function dismissExitPrompt(): void {
  showExitPrompt.value = false
}

async function confirmClose(): Promise<void> {
  showExitPrompt.value = false
  await closeRoom()
}

async function retry(): Promise<void> {
  await retryAction.run()
}

async function openSettings(): Promise<void> {
  await settingsAction.run()
}

async function toggleMicrophone(): Promise<void> {
  await microphoneAction.run()
}

async function sendChat(value: string): Promise<void> {
  await sendChatAction.run(value).catch(() => undefined)
}

async function retryChat(): Promise<void> {
  await retryChatAction.run().catch(() => undefined)
}

async function retryMessage(id: string): Promise<void> {
  await retryMessageAction.run(id).catch(() => undefined)
}

function toggleFollow(): void {
  void followAction.run().catch(() => undefined)
}

function openGiftPanel(giftId?: string | number): void {
  const parsed = Number(giftId ?? 0)
  selectedGiftId.value = Number.isSafeInteger(parsed) && parsed > 0 ? parsed : null
  showGiftPanel.value = true
}

function queueMoreDestination(destination: MoreDestination): void {
  pendingMoreDestination.value = destination
  showMore.value = false
}

function openReport(): void {
  queueMoreDestination('report')
}

function handleMoreClosed(): void {
  const destination = pendingMoreDestination.value
  pendingMoreDestination.value = null
  if (!destination || destroyed || closing.value || liveTerminalReason.value) return
  if (destination === 'effect') showEffectSettings.value = true
  else if (destination === 'pk-preview') advancePkPreview()
  else
    emit('report', {
      hostId: props.context.hostId ?? '',
      roomId: props.context.roomId,
    })
}

function openAudience(initialTab: 'rank' | 'viewers' = 'viewers'): void {
  audienceInitialTab.value = initialTab
  showAudience.value = true
  if (initialTab === 'rank') void preloadRank()
}

function openContribution(): void {
  showContribution.value = true
}

function openAnchorRank(): void {
  showAnchorRank.value = true
}

function supportAnchor(): void {
  pendingAnchorRankGift = true
  showAnchorRank.value = false
}

function handleAnchorRankClosed(): void {
  if (!pendingAnchorRankGift || destroyed || closing.value || liveTerminalReason.value !== null)
    return
  pendingAnchorRankGift = false
  openGiftPanel()
}

function openEffectSettings(): void {
  queueMoreDestination('effect')
}

function openAnchorCard(): void {
  if (!props.context.hostId) return
  void preloadAnchorCard()
  profileTarget.value = {
    avatarUrl: props.context.hostAvatarUrl ?? '',
    id: props.context.hostId,
    name: props.context.displayName,
  }
  showAnchorCard.value = true
}

function handleAudienceProfile(profile: { avatarUrl: string; id: string; name: string }): void {
  profileTarget.value = profile
  showAnchorCard.value = true
}

function openChatProfile(message: (typeof chatroom.messages.value)[number]): void {
  if (message.own || message.kind === 'announcement' || message.activityType === 'wheel-result')
    return
  const id = message.userId?.trim() || message.senderId.trim()
  if (!id) return
  profileTarget.value = {
    avatarUrl: message.avatarUrl,
    id,
    name: message.nickname || id,
  }
  showAnchorCard.value = true
}

function handleAudienceTotal(total: number): void {
  // Audience REST 只作为云信尚未连接时的兜底；连接后顶栏必须由 SDK 在线数和
  // MEMBER_ENTER / MEMBER_EXIT 实时事件驱动，不能再被抽屉快照覆盖。
  fallbackAudienceTotal.value = Math.max(0, total)
}

function openWishlistGift(giftId: string): void {
  showWishlistGuide.value = false
  setRoomPreference('wishlist-guide', '1')
  openGiftPanel(giftId)
}

function handleCardFollow(following: boolean, userId: string): void {
  if (userId === props.context.hostId)
    relationships.seed({ followed: following, userId, userType: 2 })
}

function handleCardMessage(profile: {
  avatar: string
  id: string
  imAccount: string
  name: string
}): void {
  const imAccount = profile.imAccount.trim()
  if (!profile.id || !imAccount) {
    feedback.error(t('room.messageUnavailable'))
    return
  }
  const conversation = messagesStore.getConversationByAccount(imAccount)
  showMessages.value = false
  messageConversationTarget.value = {
    avatarUrl: profile.avatar,
    conversationId: conversation?.conversationId || imAccount,
    displayName: profile.name,
    imAccount,
    userId: profile.id,
  }
}

function handleCardDetail(profile: { id: string; imAccount: string }): void {
  void profile
  showAnchorCard.value = false
}

function roomPreferenceName(name: string): string {
  return `live-room:${name}:${props.context.appId || 'local'}:${props.context.mode}`
}

function roomPreferenceAccount(): string {
  const accountId = session.user?.id?.trim()
  return accountId ?? ''
}

function readRoomPreference(name: string): string | null {
  return accountPreferences.get(roomPreferenceAccount(), roomPreferenceName(name))
}

function setRoomPreference(name: string, value: string): void {
  accountPreferences.set(roomPreferenceAccount(), roomPreferenceName(name), value)
}

function preloadWishlist(): Promise<void> {
  if (wishlistLoaded || props.context.mode !== 'live') return Promise.resolve()
  if (wishlistPreload) return wishlistPreload
  const signal = interactionController.signal
  const task = liveInteractionQueries
    .getWishlist(props.context, signal)
    .then((wishes) => {
      if (destroyed) return
      wishlistLoaded = true
      wishlist.value = wishes
      showWishlistGuide.value = Boolean(wishes.length && !readRoomPreference('wishlist-guide'))
    })
    .catch(() => undefined)
    .finally(() => {
      if (wishlistPreload === task) wishlistPreload = null
    })
  wishlistPreload = task
  return task
}

function preloadAnchorCard(): Promise<void> {
  if (anchorCardLoaded || props.context.mode !== 'live') return Promise.resolve()
  if (anchorCardPreload) return anchorCardPreload
  const task = liveInteractionQueries
    .getAnchorCard(props.context, interactionController.signal)
    .then((anchorCard) => {
      if (destroyed) return
      anchorCardLoaded = true
      relationships.seed({
        blocked: anchorCard.blocked,
        followed: anchorCard.followed,
        userId: anchorCard.id,
        userType: anchorCard.userType,
      })
    })
    .catch(() => undefined)
    .finally(() => {
      if (anchorCardPreload === task) anchorCardPreload = null
    })
  anchorCardPreload = task
  return task
}

function preloadRank(): Promise<void> {
  if (rankLoaded || props.context.mode !== 'live') return Promise.resolve()
  if (rankPreload) return rankPreload
  const epoch = rankEpoch
  const realtimeRevisionAtStart = realtimeTopGiverRevision
  const task = liveInteractionQueries
    .getRank(props.context, 'now', interactionController.signal)
    .then((liveRank) => {
      if (destroyed || epoch !== rankEpoch) return
      rankLoaded = true
      if (realtimeTopGiverRevision !== realtimeRevisionAtStart) {
        rankResolved = true
        return
      }
      const first = selectLiveTopGiver(liveRank)
      rankResolved = Boolean(first)
      if (first) liveTopGiver.value = first
    })
    .catch(() => undefined)
    .finally(() => {
      if (rankPreload === task) rankPreload = null
    })
  rankPreload = task
  return task
}

function resetLiveRankForRebuild(context: RoomLaunchContext): void {
  rankEpoch += 1
  rankLoaded = false
  rankResolved = false
  rankPreload = null
  liveTopGiver.value = isValidLiveTopGiver(context.topGiver) ? context.topGiver : undefined
}

function preloadRpsConfig(): Promise<void> {
  if (!LIVE_ROOM_GAMES_VISIBLE || rpsConfigResolved || props.context.mode !== 'live')
    return Promise.resolve()
  if (rpsConfigPreload) return rpsConfigPreload
  const task = queryLiveRpsConfig(interactionController.signal)
    .then((config) => {
      if (destroyed) return
      liveRpsConfig.value = config
      rpsConfigResolved = true
    })
    .catch(() => {
      if (!destroyed) liveRpsConfig.value = null
    })
    .finally(() => {
      if (rpsConfigPreload === task) rpsConfigPreload = null
    })
  rpsConfigPreload = task
  return task
}
function preloadWheelConfig(force = false): Promise<void> {
  const anchorId = launchContext.hostId?.trim() ?? ''
  if (
    !LIVE_ROOM_WHEEL_VISIBLE ||
    (!force && wheelConfigResolved) ||
    launchContext.mode !== 'live' ||
    launchContext.role !== 'audience' ||
    !anchorId
  )
    return Promise.resolve()
  if (launchContext.wheelEnabled === false && !force) {
    liveWheelConfig.value = null
    liveWheelEnabled.value = false
    wheelConfigResolved = true
    return Promise.resolve()
  }
  if (wheelConfigPreload && !force) return wheelConfigPreload
  if (force) wheelConfigEpoch += 1
  const epoch = wheelConfigEpoch
  const task = queryLiveWheelConfig(anchorId, interactionController.signal)
    .then((config) => {
      if (destroyed || epoch !== wheelConfigEpoch) return
      liveWheelConfig.value = config
      liveWheelEnabled.value = Boolean(config)
      wheelConfigResolved = true
    })
    .catch(() => {
      if (!destroyed && epoch === wheelConfigEpoch) {
        liveWheelConfig.value = null
        liveWheelEnabled.value = false
      }
    })
    .finally(() => {
      if (wheelConfigPreload === task) wheelConfigPreload = null
    })
  wheelConfigPreload = task
  return task
}

function invalidateLiveWheelConfig(enabled: boolean): void {
  wheelConfigEpoch += 1
  wheelConfigResolved = false
  liveWheelOpen.value = false
  liveWheelWidget.value?.close()
  wheelInteractionLocked.value = false
  liveWheelConfig.value = null
  liveWheelEnabled.value = enabled
}

function preloadHalfGameCatalog(force = false): Promise<void> {
  if (
    !LIVE_ROOM_GAMES_VISIBLE ||
    props.context.mode !== 'live' ||
    props.context.role !== 'audience'
  )
    return Promise.resolve()
  if (!force && halfGameCatalogLoadedAt > 0) return Promise.resolve()
  if (halfGameCatalogPreload) return halfGameCatalogPreload
  halfGameCatalogLoading.value = true
  halfGameCatalogError.value = false
  const task = queryHalfGameCatalog(interactionController.signal)
    .then((catalog) => {
      if (destroyed) return
      halfGameCatalog.value = catalog
      halfGameCatalogLoadedAt = Date.now()
    })
    .catch(() => {
      if (!destroyed && !interactionController.signal.aborted) halfGameCatalogError.value = true
    })
    .finally(() => {
      if (!destroyed) halfGameCatalogLoading.value = false
      if (halfGameCatalogPreload === task) halfGameCatalogPreload = null
    })
  halfGameCatalogPreload = task
  return task
}

function refreshHalfGameCatalogIfStale(): void {
  if (Date.now() - halfGameCatalogLoadedAt < 60_000) return
  void preloadHalfGameCatalog(true)
}

function openGameCenter(): void {
  if (!gameCenterAvailable.value) return
  pendingGameCenterDestination.value = null
  showGameCenter.value = true
  refreshHalfGameCatalogIfStale()
}

function preloadRoomInteractions(): void {
  void preloadWishlist()
  void preloadRank()
  void preloadWheelConfig()
  void Promise.allSettled([
    liveInteractionQueries.getGiftCategories(props.context, interactionController.signal),
    liveInteractionQueries.getQuickGifts(props.context, interactionController.signal),
  ])
  if (LIVE_ROOM_GAMES_VISIBLE) {
    void preloadRpsConfig()
    void preloadHalfGameCatalog()
  }
}

function reportEntryEffectAfterFirstFrame(): void {
  if (entryEffectReported || props.context.mode !== 'live') return
  entryEffectReported = true
  void liveInteractionActions
    .reportEntryEffect(props.context, interactionController.signal)
    .catch(() => undefined)
}

async function refreshWishlist(): Promise<void> {
  if (destroyed || props.context.mode !== 'live') return
  try {
    const rows = await liveInteractionQueries.getWishlist(
      props.context,
      interactionController.signal,
    )
    if (!destroyed) wishlist.value = rows
  } catch {
    // Keep the last good snapshot. Live wishlist refresh is intentionally silent.
  }
}

function scheduleWishlistRefresh(): void {
  if (props.context.mode !== 'live') return
  window.clearTimeout(wishlistRefreshTimer)
  wishlistRefreshTimer = window.setTimeout(() => {
    wishlistRefreshTimer = 0
    void refreshWishlist()
  }, WISHLIST_REFRESH_DEBOUNCE_MS)
}

function pushGiftBanner(message: (typeof chatroom.messages.value)[number]): void {
  if (message.kind !== 'gift') return
  const giftIdentity = message.giftId || message.giftName || message.giftIconUrl || 'gift'
  const key = `${message.senderId || message.nickname}#${giftIdentity}`
  const current = giftBanners.value.find((item) => item.key === key)
  if (current) {
    current.count += message.giftCount ?? 1
    current.visible = true
    giftBanners.value = [...giftBanners.value]
  } else {
    giftBannerTimers.forEach((timer) => window.clearTimeout(timer))
    giftBannerTimers.clear()
    giftBanners.value = [
      {
        avatarUrl: message.avatarUrl,
        count: message.giftCount ?? 1,
        giftIconUrl: message.giftIconUrl ?? '',
        giftName: message.giftName ?? 'Gift',
        key,
        sender: message.nickname,
        visible: true,
      },
    ]
  }
  const timer = giftBannerTimers.get(key)
  if (timer) window.clearTimeout(timer)
  giftBannerTimers.set(
    key,
    window.setTimeout(() => {
      const banner = giftBanners.value.find((item) => item.key === key)
      if (banner) {
        banner.visible = false
        giftBanners.value = [...giftBanners.value]
      }
      giftBannerTimers.set(
        key,
        window.setTimeout(() => {
          giftBanners.value = giftBanners.value.filter((item) => item.key !== key)
          giftBannerTimers.delete(key)
        }, 320),
      )
    }, 3000),
  )
}

function canShowRoomEffects(): boolean {
  return (
    appActivity.value.visible &&
    !closing.value &&
    !destroyed &&
    !liveTerminalReason.value &&
    liveUiReady.value
  )
}

function showGiftEffect(message: (typeof chatroom.messages.value)[number]): void {
  if (message.own || !effectsEnabled.value || reducedMotion.value || !canShowRoomEffects()) return
  const giftId = Number(message.giftId)
  const cachedGift = Number.isSafeInteger(giftId)
    ? liveInteractionQueries.peekGifts()?.find((gift) => gift.id === giftId)
    : undefined
  // Remote Yunxin pushes normally carry giftIcon as the animation URL. Keep the
  // account-level OPI gift catalog as a fallback for reduced pushes that only
  // contain giftId; self-sent gifts already arrive with the selected catalog row.
  const effectUrl = message.giftEffectUrl?.trim() || cachedGift?.effectUrl.trim() || ''
  roomEffectScheduler.enqueueGift({
    dedupeKey: `live:${props.context.roomId}:${message.id}`,
    url: effectUrl,
  })
}

function finishRoomEffect(): void {
  const id = roomEffectScheduler.state.current?.id
  if (id !== undefined) roomEffectScheduler.finish(id)
}

function startRoomEffect(): void {
  const id = roomEffectScheduler.state.current?.id
  if (id !== undefined) roomEffectScheduler.start(id)
}

function staticEntryEffect(effect: LiveEntryEffect): LiveEntryEffect {
  const staticEffect = { ...effect }
  delete staticEffect.effectUrl
  return staticEffect
}

function flushDeferredEntryEffect(): void {
  if (!deferredEntryEffect || !effectsEnabled.value || !canShowRoomEffects()) return
  const effect = deferredEntryEffect
  deferredEntryEffect = null
  roomEffectScheduler.enqueueEntry(reducedMotion.value ? staticEntryEffect(effect) : effect)
}

function applyMotionPreference(event: MediaQueryListEvent | MediaQueryList): void {
  const next = event.matches
  if (reducedMotion.value === next) return
  reducedMotion.value = next
  roomEffectScheduler.clear()
}

function suspendForApplicationBackground(): void {
  resetClearScreen()
  stopPkPreview()
  liveWheelOpen.value = false
  liveWheelWidget.value?.close()
  wheelInteractionLocked.value = false
  showRps.value = false
  dismissGameLayers()
  chatroom.setAppVisible(false)
  pkSession.suspend()
  clearRoomEffects()
  if (!closing.value) rtcRoomEngine.setAppVisible(false)
}

async function recoverFromApplicationActivity(context: ApplicationRecoveryContext): Promise<void> {
  if (context.signal.aborted || destroyed) return
  // RoomApp 与 RTC 引擎都是单实例语义。前台恢复必须等垂直切房事务落定，
  // 否则旧房重建与新房 join 会并发争用同一个 Agora/NIM runtime。
  if (presentation.switching.value) await presentation.waitForRoomSwitch()
  if (context.signal.aborted || destroyed || roomSwitchReleased) return
  chatroom.setAppVisible(true)
  rtcRoomEngine.setAppVisible(true)
  if (closing.value) return
  const decision = decideLiveRoomResume({
    connectionHealthy: rtcRoomEngine.canResumeWithoutRejoin(props.context.roomId),
    online: context.activity.online,
  })
  if (context.signal.aborted || destroyed || closing.value || !appActivity.value.visible) return
  if (decision === 'resume') {
    await pkSession.resume()
  }
  // wait-sdk / wait-online 都保留当前 Agora 与 NIM 实例。SDK 恢复事件会驱动
  // 原视频轨道重播；只有用户点击 Retry 才允许重建当前房。
}

async function startFallbackVideo(withSound = true): Promise<void> {
  const video = fallbackVideo.value
  if (!video) return
  positionFallbackVideoRandomly()
  video.volume = 1
  video.muted = !withSound
  fallbackVideoMuted.value = !withSound
  try {
    await video.play()
  } catch {
    // Safari and Chrome may reject audible autoplay after the asynchronous room join.
    // Keep the stream moving and let the existing room sound button resume audio.
    video.muted = true
    fallbackVideoMuted.value = true
    await video.play().catch(() => undefined)
  }
}

function positionFallbackVideoRandomly(): void {
  const video = fallbackVideo.value
  if (!video || fallbackVideoPositioned || !Number.isFinite(video.duration) || video.duration <= 2)
    return
  const playableDuration = Math.max(1, video.duration - 2)
  const minimumStart = Math.min(playableDuration, Math.max(2, video.duration * 0.1))
  video.currentTime = minimumStart + Math.random() * Math.max(0, playableDuration - minimumStart)
  fallbackVideoPositioned = true
}

async function toggleFallbackVideoSound(): Promise<void> {
  await startFallbackVideo(fallbackVideoMuted.value)
}

onMounted(async () => {
  motionPreference = window.matchMedia('(prefers-reduced-motion: reduce)')
  reducedMotion.value = motionPreference.matches
  motionPreference.addEventListener('change', applyMotionPreference)
  stopRecoveryParticipant = applicationRecoveryCoordinator.register({
    id: `live-room:${props.context.roomId}`,
    priority: 10,
    onSuspend: suspendForApplicationBackground,
    onRecover: recoverFromApplicationActivity,
  })
  effectsEnabled.value = readRoomPreference('effects') !== '0'
  presentation.registerRoomLifecycle(lifecycleOwner, {
    dispose: disposeRoomRuntime,
    leave: teardownForRoomSwitch,
    resume: resumeAfterRoomSwitchFailure,
    suspend: suspendForRoomSwitch,
  })
  if (!realtimeEnabled) {
    const profile = session.profile
    const currentUserId = profile?.id || session.user?.id || ''
    const initialMessages = await liveRoomMessageQueries
      .load(props.context.roomId, currentUserId)
      .catch(() => [])
    await chatroom.connectLocal({
      hostImAccount: props.context.hostImAccount,
      initialMessages,
      initialOnlineCount: props.context.onlineCount ?? 0,
      messageLimit: 150,
      roomId: props.context.chatRoomId || `live-${props.context.roomId}`,
      user: {
        avatarUrl: profile?.avatarUrl || session.user?.avatar || '',
        displayName: profile?.displayName || session.user?.displayName || 'Me',
        id: profile?.id || session.user?.id || 'guest-user',
        ...(profile ? { isVip: profile.vip || profile.vipExpireAt > Date.now() } : {}),
        ...(profile?.levelName.trim() ? { userLevel: profile.levelName.trim() } : {}),
      },
      ...(props.context.announcement?.trim()
        ? { announcementText: props.context.announcement.trim() }
        : {}),
    })
    chatroom.appendLocalEntry({
      avatarUrl: profile?.avatarUrl || session.user?.avatar || '',
      nickname: profile?.displayName || session.user?.displayName || 'Me',
      userId: currentUserId || 'guest-user',
      userLevel: profile?.level ?? 0,
      vip: profile ? profile.vip || profile.vipExpireAt > Date.now() : false,
    })
    await nextTick()
    await startFallbackVideo(true)
    preloadRoomInteractions()
    reportEntryEffectAfterFirstFrame()
    runtimeReadyReported = true
    emit('runtimeReady', props.context.roomId)
    scheduleFollowPrompt()
    return
  }
  if (props.context.mode === 'live') {
    rtcRoomEngine.setPkPlaybackMuted(false)
    pkSessionStarted = true
    pkSession.start(props.context, { suspended: props.context.role === 'audience' })
  }
  scheduleFollowPrompt()
  await Promise.allSettled([startRoom(), startChatroom()])
})

watch(roomInteractionLocked, (locked) => emit('interactionLock', locked), { immediate: true })

watch(screenCleared, (cleared) => {
  window.clearTimeout(clearScreenTimer)
  clearScreenTimer = 0
  clearScreenExitVisible.value = false
  if (!cleared) return
  clearRoomEffects()
  clearScreenTimer = window.setTimeout(() => {
    clearScreenTimer = 0
    if (!destroyed && screenCleared.value) clearScreenExitVisible.value = true
  }, 2_000)
})

watch(pkVisible, (visible) => {
  if (visible) {
    pendingMoreDestination.value = null
    stopPkPreview()
    return
  }
  showPkRank.value = false
  pendingPkRankGift = false
})

watch(displayedPkVisible, async (visible) => {
  await nextTick()
  if (destroyed || closing.value) return
  if (visible) {
    if (pkHostVideo.value) attachHostVideoSurface(pkHostVideo.value)
    return
  }
  pkHostVideo.value = null
  attachHostVideoSurface(props.context.role === 'audience' ? remoteVideo.value : localVideo.value)
  rtcRoomEngine.attachPkRemoteVideo(null)
})

watch(
  () => rtcRoomEngine.state.value,
  (state) => {
    if (state === 'active' && props.context.mode === 'live' && props.context.role === 'audience')
      markLiveEntryStage(props.context.roomId, 'first-frame', true)
  },
  { immediate: true },
)

watch(effectsEnabled, (enabled) => {
  setRoomPreference('effects', enabled ? '1' : '0')
  if (!enabled) {
    roomEffectScheduler.clear()
    chatroom.clearEntryEffects()
    deferredEntryEffect = null
  }
})

watch(
  () => chatroom.entryEffectRevision.value,
  (revision) => {
    const effect = chatroom.entryEffect.value
    if (!revision || !effect || !effectsEnabled.value) return
    if (!liveUiReady.value && appActivity.value.visible) {
      deferredEntryEffect = effect
      return
    }
    if (!canShowRoomEffects()) return
    roomEffectScheduler.enqueueEntry(reducedMotion.value ? staticEntryEffect(effect) : effect)
  },
)

watch(liveUiReady, (ready) => {
  if (!ready) {
    resetInitialChatScroll()
    return
  }
  flushDeferredEntryEffect()
  chatPinnedToBottom.value = true
  void ensureInitialChatBottom()
})

watch(
  () => chatroom.messages.value.length,
  () => {
    if (!initialChatScrollCompleted) {
      void ensureInitialChatBottom()
      return
    }
    if (chatPinnedToBottom.value)
      void scrollChatToBottom(reducedMotion.value ? 'instant' : 'smooth')
  },
)
watch(
  () => chatroom.state.value,
  (state) => {
    if (state === 'connected') void ensureInitialChatBottom()
  },
)
watch(
  () => chatroom.giftRevision.value,
  (revision) => {
    if (revision > 0) scheduleWishlistRefresh()
  },
)
watch(
  () => chatroom.metricsRevision.value,
  () => {
    const patch = chatroom.latestMetrics.value
    if (!patch) return
    if (patch.hotScore !== undefined) liveHotScore.value = patch.hotScore
    if (patch.incomeTotal !== undefined) liveIncome.value = patch.incomeTotal
    else if (patch.incomeDelta !== undefined)
      liveIncome.value = Math.max(0, liveIncome.value + patch.incomeDelta)
    if (patch.topGiver === null) {
      realtimeTopGiverRevision += 1
      rankResolved = true
      liveTopGiver.value = undefined
    } else if (isValidLiveTopGiver(patch.topGiver)) {
      realtimeTopGiverRevision += 1
      rankResolved = true
      liveTopGiver.value = patch.topGiver
    }
    if (patch.wish) {
      wishlist.value = wishlist.value.map((wish) =>
        wish.giftId === patch.wish?.giftId
          ? { ...wish, completed: Math.min(wish.target, patch.wish.completed) }
          : wish,
      )
    }
  },
)
watch(
  () => chatroom.wheelSignalRevision.value,
  () => {
    const signal = chatroom.latestWheelSignal.value
    if (!signal) return
    const hostId = props.context.hostId?.trim() ?? ''
    if (signal.anchorId && hostId && signal.anchorId !== hostId) return
    if (!signal.enabled) {
      invalidateLiveWheelConfig(false)
      return
    }
    invalidateLiveWheelConfig(true)
    void preloadWheelConfig(true)
  },
)
watch(
  () => chatroom.pkStatusRevision.value,
  (revision) => {
    if (revision > 0 && chatroom.pkStatusPush.value)
      pkSession.acceptStatusPush(chatroom.pkStatusPush.value)
  },
)
watch(
  () => chatroom.pkRankRevision.value,
  (revision) => {
    if (revision > 0 && chatroom.pkRankPush.value)
      pkSession.acceptRankPush(chatroom.pkRankPush.value)
  },
)
watch(
  () => chatroom.latestGift.value,
  (gift) => {
    if (!gift || !canShowRoomEffects()) return
    pushGiftBanner(gift)
    showGiftEffect(gift)
  },
)
watch(
  () => chatroom.hostExitRevision.value,
  async (revision) => {
    if (!revision || closing.value || destroyed || props.context.mode !== 'live') return
    // 与 Android LiveSession 一致：主播退出 IM 可能只是闪断，必须通过直播状态接口二次确认。
    // 只有服务端明确关播才能进入关播终态；探测失败不能伪造主播已关播。
    let alive: boolean | null
    try {
      alive = await liveQueries.isRoomAlive(props.context.channelName, interactionController.signal)
    } catch {
      return
    }
    if (destroyed || closing.value || revision !== chatroom.hostExitRevision.value) return
    if (alive === false) rtcRoomEngine.markStreamEnded()
  },
)
watch(
  () => chatroom.state.value,
  async (state) => {
    if (state !== 'kicked' || closing.value) return
    await rtcRoomEngine.leave()
    await setMediaSession(false)
  },
)
watch(
  () => rtcRoomEngine.state.value,
  async (state) => {
    if (state === 'active' && retainedLiveFailure) {
      retainedLiveFailure = false
      liveTerminalReason.value = null
      runtimeFailureReported = false
      await pkSession.resume()
    }
    if (state === 'active') acceptCurrentRoomFirstFrame()
    if (state === 'failed' && !runtimeFailureReported) {
      runtimeFailureReported = true
      runtimeReadyReported = false
      emit('runtimeFailed', props.context.roomId)
      // 切房目标失败由 Pager 回滚；当前房只展示可重试状态。若 Agora
      // 仍保留本房 Client，终态层不得提前 leave，晚到恢复仍可原位继续。
      if (!presentation.switching.value) await enterLiveTerminal('failed')
    }
    if (state !== 'stream-ended' || closing.value || handlingRoomEnd) return
    handlingRoomEnd = true
    try {
      // RTC 远端退出先查服务端：明确存活继续等待，明确关播展示关播终态，
      // 状态接口不可用时展示可重试失败态，不把网络问题伪造成主播关播。
      const alive = await liveQueries.isRoomAlive(
        props.context.channelName,
        interactionController.signal,
      )
      if (destroyed || rtcRoomEngine.state.value !== 'stream-ended') return
      if (alive === true) {
        rtcRoomEngine.markWaitingForHost()
        return
      }
      if (alive === false) {
        presentation.markRoomEnded(props.context.roomId)
        await enterLiveTerminal('ended')
        return
      }
      await enterLiveTerminal('failed')
    } finally {
      handlingRoomEnd = false
    }
  },
)
onBeforeUnmount(() => {
  destroyed = true
  invalidateLiveWheelConfig(false)
  stopPkPreview()
  pendingMoreDestination.value = null
  clearRoomEffects()
  resetClearScreen()
  motionPreference?.removeEventListener('change', applyMotionPreference)
  motionPreference = null
  window.clearTimeout(wishlistRefreshTimer)
  interactionController.abort()
  liveInteractionActions.endSession(props.context)
  presentation.unregisterRoomLifecycle(lifecycleOwner)
  stopRecoveryParticipant?.()
  stopRecoveryParticipant = undefined
  rtcRoomEngine.attachLocalVideo(null)
  rtcRoomEngine.attachRemoteVideo(null)
  rtcRoomEngine.attachPkRemoteVideo(null)
  fallbackVideo.value?.pause()
  if (!roomSwitchReleased && !finalTeardownCompleted) {
    void pkSession.stop()
    void rtcRoomEngine.dispose()
    void chatroom.close()
    void setMediaSession(false)
  }
})

watch(
  () => props.context.followed,
  (value) => {
    relationships.seed({
      followed: Boolean(value),
      userId: props.context.hostId ?? '',
      userType: 2,
    })
  },
  { immediate: true },
)
watch(
  () => props.context.hotScore,
  (value) => {
    if (value !== undefined) liveHotScore.value = Math.max(liveHotScore.value, value)
  },
)
watch(
  () => props.context.currentLiveIncome,
  (value) => {
    if (value !== undefined) liveIncome.value = Math.max(liveIncome.value, value)
  },
)
watch(
  () => props.context.topGiver,
  (value) => {
    if (
      !rankResolved &&
      isValidLiveTopGiver(value) &&
      value.cost >= (liveTopGiver.value?.cost ?? 0)
    )
      liveTopGiver.value = value
  },
)
watch(
  () => props.context.followPromptDelaySeconds,
  () => scheduleFollowPrompt(),
)
</script>

<template>
  <main
    class="room"
    :class="[
      `room--${context.mode}`,
      {
        'room--pk': displayedPkVisible && liveUiReady,
        'room--screen-cleared': screenCleared && cleanProgress >= 1,
      },
    ]"
    @pointercancel="cancelClearScreenGesture"
    @pointerdown="beginClearScreenGesture"
    @pointermove="moveClearScreenGesture"
    @pointerup="finishClearScreenGesture"
  >
    <div class="room__backdrop" />
    <AppImage
      v-if="context.mode === 'live' && context.coverUrl"
      :alt="context.displayName"
      class="room__cover"
      :class="{
        'is-loading-obscured': liveCoverObscured,
        'is-pk-hidden': displayedPkVisible && liveUiReady,
      }"
      fit="cover"
      :lazy="false"
      priority
      :src="context.coverUrl"
    />
    <video
      v-if="context.mode === 'live' && !realtimeEnabled && context.playbackUrl"
      ref="fallbackVideo"
      autoplay
      class="video-surface video-surface--remote"
      loop
      :muted="fallbackVideoMuted"
      playsinline
      preload="auto"
      :poster="context.coverUrl"
      :src="context.playbackUrl"
      @loadedmetadata="positionFallbackVideoRandomly"
    ></video>
    <button
      v-if="context.mode === 'live' && !realtimeEnabled && context.playbackUrl && liveUiReady"
      class="live-fallback-sound"
      type="button"
      :aria-label="fallbackVideoMuted ? 'Turn on live sound' : 'Mute live sound'"
      @click.stop="toggleFallbackVideoSound"
      @pointerdown.stop
    >
      <AppIcon name="volume" :size="19" />
      <span>{{ fallbackVideoMuted ? 'Tap for sound' : 'Live sound' }}</span>
    </button>
    <div
      v-else-if="context.mode === 'live'"
      ref="remoteVideo"
      class="video-surface video-surface--remote"
    ></div>
    <div
      v-if="context.role !== 'audience' && context.mode === 'live'"
      ref="localVideo"
      class="video-surface video-surface--local"
    />

    <div v-if="screenCleared && cleanProgress >= 1" class="live-clear-screen-controls">
      <Transition name="clear-screen-exit">
        <button
          v-if="clearScreenExitVisible"
          class="live-clear-screen-controls__exit"
          type="button"
          @click="setClearScreen(false)"
        >
          <img alt="" :src="publicAsset('live-room/legacy/live-clear.webp')" />
          <span>{{ t('room.exitClearScreen') }}</span>
        </button>
      </Transition>
    </div>

    <div
      v-if="liveUiReady && displayedPkVisible"
      class="room-pk-top-background"
      :style="cleanLeftStyle"
      aria-hidden="true"
    />

    <LivePkStage
      v-if="liveUiReady && displayedPkVisible && pkDisplayDetail"
      :key="pkPreviewActive ? 'preview' : 'remote'"
      class="live-clean-motion"
      :detail="pkDisplayDetail"
      :muted="pkOpponentMuted"
      :phase="pkDisplayPhase"
      :reduced-motion="reducedMotion"
      :state="pkDisplayState"
      :style="cleanLeftStyle"
      :status="pkDisplayStatus"
      @opponent="openPkOpponent"
      @rank="openPkRank"
      @surface-change="attachPkSurface"
      @toggle-mute="togglePkOpponentSound"
    />
    <section
      v-else-if="liveUiReady && pkVisible"
      class="room-pk-placeholder"
      :class="{ 'is-failed': pkSession.phase.value === 'failed' }"
      :style="cleanLeftStyle"
      role="status"
    >
      <i v-if="pkSession.phase.value !== 'failed'" />
      <span>{{
        pkSession.phase.value === 'failed' ? t('room.pkUnavailable') : t('room.pkLoading')
      }}</span>
    </section>
    <LiveWheelEntrance
      class="live-clean-motion"
      :style="cleanLeftStyle"
      :visible="liveWheelEntranceVisible"
      @open="toggleLiveWheel"
    />

    <header v-if="context.mode === 'live'" class="legacy-live-top">
      <button
        class="legacy-live-top__close"
        type="button"
        :aria-label="t('room.leave')"
        :disabled="closing || closeRoomAction.pending.value"
        @click="handleLiveTopClose"
      >
        <img alt="" :src="publicAsset('common/close.png')" />
      </button>
      <button
        v-if="liveUiReady && isValidLiveTopGiver(liveTopGiver)"
        class="legacy-live-top__giver"
        :style="cleanLeftStyle"
        type="button"
        :aria-label="t('room.topGiver')"
        @click="openAudience('rank')"
      >
        <AppAvatar :alt="t('room.topGiver')" :size="32" :src="liveTopGiver.avatarUrl" />
        <img alt="" :src="publicAsset('live-room/legacy/crown-1.webp')" />
      </button>
      <button
        v-if="liveUiReady && compactViewerCount"
        class="legacy-live-top__viewers"
        :style="cleanLeftStyle"
        type="button"
        :aria-label="`${viewerCount} viewers`"
        @click="openAudience('viewers')"
      >
        <img alt="" :src="publicAsset('live-room/legacy/viewers.webp')" />
        <span>{{ compactViewerCount }}</span>
      </button>
      <nav
        v-if="LIVE_ROOM_METRICS_VISIBLE && liveUiReady"
        class="legacy-live-top__metrics"
        :style="cleanLeftStyle"
        :aria-label="t('room.ranking')"
      >
        <button type="button" @click="openContribution">
          <img alt="" :src="publicAsset('common/diamond.png')" />
          <span>{{ formatCompactMetric(liveIncome) }}</span>
        </button>
        <button type="button" @click="openAnchorRank">
          <span>{{ context.currentAnchorRank ? `No.${context.currentAnchorRank}` : '-' }}</span>
          <AppIcon name="chevron" :size="11" />
        </button>
      </nav>
    </header>

    <header v-if="context.mode === 'voice'" class="room__header">
      <div class="room__identity">
        <button
          class="room__avatar-ring"
          type="button"
          aria-label="Open host profile"
          @click="openAnchorCard"
        >
          <AppAvatar
            :alt="context.displayName"
            :lazy="false"
            priority
            :size="36"
            :src="context.hostAvatarUrl"
          />
        </button>
        <div class="room__identity-copy">
          <strong>{{ context.displayName || t('room.noContext') }}</strong>
          <span class="room__identity-meta">
            <AppAnchorLevelBadge :level="context.hostLevelName" size="s" />
            <small>{{
              viewerSubtitleCount ? `${viewerSubtitleCount} watching` : statusText
            }}</small>
          </span>
        </div>
        <button class="room__viewer-chip" type="button" @click="showAudience = true">
          <img alt="" :src="publicAsset('live-room/live-eye.webp')" />
          <span>{{ viewerCount }}</span>
        </button>
        <button
          class="room__follow"
          :class="{ 'is-following': followed }"
          type="button"
          @click="toggleFollow"
        >
          <AppIcon v-if="followed" name="check" :size="12" />
          {{ followed ? t('room.following') : t('room.follow') }}
        </button>
      </div>
      <button class="room__chrome-button" type="button" aria-label="More" @click="showMore = true">
        <AppIcon name="more" :size="17" />
      </button>
      <button
        class="room__chrome-button"
        type="button"
        :aria-label="t('room.leave')"
        :aria-busy="closeRoomAction.pending.value"
        :disabled="closing || closeRoomAction.pending.value"
        @click="requestExit"
      >
        <AppIcon name="close" :size="17" />
      </button>
    </header>

    <section
      v-if="liveUiReady && effectsEnabled && roomEffectScheduler.state.current?.kind === 'entry'"
      :key="roomEffectScheduler.state.current.id"
      class="room-entry-effect"
      :class="`room-entry-effect--${roomEffectScheduler.state.current.effect.style}`"
      :style="cleanLeftStyle"
      aria-live="polite"
    >
      <LiveEffectPlayer
        v-if="roomEffectScheduler.state.current.url"
        :key="roomEffectScheduler.state.current.id"
        class="room-entry-effect__animation"
        :url="roomEffectScheduler.state.current.url"
        @error="finishRoomEffect"
        @finished="finishRoomEffect"
        @started="startRoomEffect"
      />
      <div
        class="room-entry-effect__person"
        :style="richEntryPersonStyle(roomEffectScheduler.state.current.effect)"
      >
        <AppAvatar
          v-if="roomEffectScheduler.state.current.effect.style !== 'guardian'"
          :alt="roomEffectScheduler.state.current.effect.nickname"
          class="room-entry-effect__avatar"
          :lazy="false"
          :size="roomEffectScheduler.state.current.effect.style === 'high-level' ? 28 : 42"
          :src="roomEffectScheduler.state.current.effect.avatarUrl"
        />
        <span class="room-entry-effect__identity">
          <AppUserLevelTag :level="roomEffectScheduler.state.current.effect.userLevel" size="s" />
          <img
            v-if="roomEffectScheduler.state.current.effect.vip"
            alt="VIP"
            class="room-entry-effect__vip"
            :src="publicAsset('common/vip.webp')"
          />
          <strong>{{ roomEffectScheduler.state.current.effect.nickname }}</strong>
          <span>{{ t('room.enteredRoom') }}</span>
        </span>
      </div>
    </section>

    <div
      v-if="liveUiReady && effectsEnabled && roomEffectScheduler.state.current?.kind === 'gift'"
      :key="roomEffectScheduler.state.current.id"
      class="room-fullscreen-effect"
      :style="cleanLeftStyle"
      aria-hidden="true"
    >
      <LiveEffectPlayer
        :key="roomEffectScheduler.state.current.id"
        layout="legacy-gift"
        :muted="false"
        :url="roomEffectScheduler.state.current.url"
        @error="finishRoomEffect"
        @finished="finishRoomEffect"
        @started="startRoomEffect"
      />
    </div>

    <LiveWishlist
      v-if="context.mode === 'live' && liveUiReady"
      class="live-clean-motion"
      :guide-visible="showWishlistGuide && wishlistHasIncomplete"
      :items="wishlist"
      :pk="displayedPkVisible"
      :style="cleanLeftStyle"
      @select="openWishlistGift"
    />

    <LiveWheelWidget
      v-if="liveWheelOpen && liveWheelConfig && liveUiReady && !displayedPkVisible"
      ref="liveWheelWidget"
      :config="liveWheelConfig"
      :context="context"
      :suspended="giftRechargeCovered"
      @result="handleWheelResult"
      @interaction-lock="wheelInteractionLocked = $event"
      @recharge="requestRpsRecharge"
    />

    <section v-if="context.mode === 'voice'" class="voice-stage">
      <div class="voice-stage__hero">
        <span>{{ context.displayName.slice(0, 1) }}</span>
        <i v-for="ring in 3" :key="ring" :style="{ '--ring': ring }" />
      </div>
      <h1>{{ context.displayName }}</h1>
      <p>{{ statusText }}</p>
      <div class="speaker-grid">
        <div v-for="index in 8" :key="index" class="speaker">
          <span
            :class="{ 'is-speaking': rtcRoomEngine.activeSpeakers.value.length && index === 1 }"
          >
            {{ String.fromCharCode(64 + index) }}
          </span>
          <small>{{ index === 1 ? t('room.host') : t('room.speaker') }}</small>
        </div>
      </div>
    </section>

    <section v-else class="live-overlay" :style="cleanLeftStyle">
      <div v-if="!liveUiReady && !liveTerminalReason" class="room-loader">
        <AppLoadLoadingIcon animated :size="60" />
      </div>
      <div v-else-if="rtcRoomEngine.state.value === 'waiting-stream'" class="host-away">
        <AppIcon name="video" :size="36" />
        <strong>{{ t('room.hostAway') }}</strong>
        <span>{{ t('room.hostAwayDescription') }}</span>
      </div>
    </section>

    <LiveTerminalState
      v-if="context.mode === 'live' && liveTerminalReason"
      :avatar-url="context.hostAvatarUrl"
      :can-message="Boolean(context.hostId?.trim())"
      :description="liveTerminalDescription"
      :display-name="context.displayName"
      :reason="liveTerminalReason"
      :retrying="retryAction.pending.value"
      @leave="closeRoom"
      @message="openHostMessage"
      @retry="retry"
    />

    <TransitionGroup
      v-if="chatSurfaceAvailable && liveUiReady"
      name="gift-banner"
      tag="div"
      class="room-gift-banners"
      :style="cleanLeftStyle"
    >
      <div
        v-for="banner in giftBanners"
        :key="banner.key"
        class="room-gift-banner"
        :class="{ 'is-leaving': !banner.visible }"
      >
        <AppAvatar :alt="banner.sender" :size="32" :src="banner.avatarUrl" />
        <span>
          <strong>{{ banner.sender }}</strong>
          <small>
            {{ t('room.giftSentAction') }}
            <b>{{ banner.giftName }}</b>
          </small>
        </span>
        <span class="room-gift-banner__gift">
          <AppImage
            v-if="banner.giftIconUrl"
            alt="Gift"
            fit="contain"
            :height="32"
            :src="banner.giftIconUrl"
            :width="32"
          />
          <AppIcon v-else name="gift" :size="20" />
        </span>
        <em>×{{ banner.count }}</em>
      </div>
    </TransitionGroup>

    <section
      v-if="chatSurfaceAvailable && liveUiReady"
      class="room-chat"
      aria-label="Live chat"
      :style="cleanLeftStyle"
    >
      <div
        ref="chatList"
        class="room-chat__messages"
        data-room-scroll
        role="log"
        aria-live="polite"
        @pointerdown="handleChatUserInteraction"
        @scroll.passive="handleChatScroll"
        @wheel.passive="handleChatUserInteraction"
      >
        <img
          v-if="context.mode === 'live'"
          ref="chatSafetyImage"
          class="room-chat__safety"
          alt=""
          :src="publicAsset('live-room/legacy/live-notice-1.webp')"
          @error="handleChatSafetyImageSettled"
          @load="handleChatSafetyImageSettled"
        />
        <div
          v-for="message in chatroom.messages.value"
          :key="message.id"
          class="room-chat__message"
          :class="{
            'is-announcement': message.kind === 'announcement',
            'is-enter': message.kind === 'enter',
            'is-failed': message.state === 'failed',
            'is-gift': message.kind === 'gift',
            'is-host': message.host,
            'is-own': message.own,
            'is-wheel-result': message.activityType === 'wheel-result',
            'uses-chat-skin':
              message.kind === 'text' &&
              message.activityType !== 'wheel-result' &&
              Boolean(message.chatBubbleUrl),
          }"
          :role="
            !message.own &&
            message.kind !== 'announcement' &&
            message.activityType !== 'wheel-result'
              ? 'button'
              : undefined
          "
          :tabindex="
            !message.own &&
            message.kind !== 'announcement' &&
            message.activityType !== 'wheel-result'
              ? 0
              : undefined
          "
          @click="openChatProfile(message)"
          @keydown.enter="openChatProfile(message)"
        >
          <template v-if="message.activityType === 'wheel-result'">
            <img
              class="room-chat__wheel-icon"
              alt=""
              aria-hidden="true"
              draggable="false"
              :src="publicAsset('live-room/wheel/icon.webp')"
            />
            <span class="room-chat__wheel-copy">
              <template v-if="message.own">
                {{ t('room.liveWheelResultLead') }}
                <strong>"{{ message.text }}"</strong>
              </template>
              <template v-else>
                <b>{{ message.nickname || message.senderId }}</b>
                {{ t('room.liveWheelHit') }}
                <strong>"{{ message.text }}"</strong>
                {{ t('room.liveWheelOn') }}
              </template>
            </span>
          </template>
          <template v-else-if="message.kind === 'announcement'">
            <strong>📢 {{ t('room.announcement') }}</strong>
            <span>{{ message.text }}</span>
          </template>
          <template v-else-if="message.kind === 'enter'">
            <span v-if="message.nickname" class="room-chat__identity">
              <AppImage
                v-if="message.guardianLevel"
                alt=""
                aria-hidden="true"
                class="room-chat__guardian"
                fit="contain"
                :src="legacyGuardianBadgeUrl(message.guardianLevel)"
              />
              <AppUserLevelTag v-if="message.userLevel" :level="message.userLevel" size="s" />
              <img
                v-if="message.vip"
                alt="VIP"
                class="room-chat__vip"
                :src="publicAsset('common/vip.webp')"
              />
              <AppImage
                v-else-if="message.newUser"
                alt="New"
                class="room-chat__new"
                fit="contain"
                :src="LEGACY_LIVE_NEW_USER_BADGE_URL"
              />
              <b>{{ message.nickname }}</b>
            </span>
            <span class="room-chat__entry-copy">
              {{ t('room.enteredRoom') }}
              <AppImage
                v-if="message.entryItemUrl"
                alt=""
                fit="contain"
                :height="26"
                :src="message.entryItemUrl"
                :width="26"
              />
            </span>
          </template>
          <template v-else-if="message.kind === 'gift'">
            <span v-if="message.nickname" class="room-chat__identity">
              <AppImage
                v-if="message.guardianLevel"
                alt=""
                aria-hidden="true"
                class="room-chat__guardian"
                fit="contain"
                :src="legacyGuardianBadgeUrl(message.guardianLevel)"
              />
              <AppUserLevelTag v-if="message.userLevel" :level="message.userLevel" size="s" />
              <img
                v-if="message.vip"
                alt="VIP"
                class="room-chat__vip"
                :src="publicAsset('common/vip.webp')"
              />
              <AppImage
                v-else-if="message.newUser"
                alt="New"
                class="room-chat__new"
                fit="contain"
                :src="LEGACY_LIVE_NEW_USER_BADGE_URL"
              />
              <b>{{ message.nickname }}</b>
            </span>
            <span>{{ t('room.giftSentAction') }}</span>
            <span class="room-chat__gift-icon">
              <AppImage
                v-if="message.giftIconUrl"
                :alt="message.giftName || 'Gift'"
                fit="contain"
                :height="32"
                :src="message.giftIconUrl"
                :width="32"
              />
              <AppIcon v-else name="gift" :size="14" />
            </span>
            <em>×{{ message.giftCount || 1 }}</em>
          </template>
          <template v-else>
            <span
              v-if="message.chatBubbleUrl && message.nickname && !message.guardianLevel"
              class="room-chat__identity"
            >
              <AppImage
                v-if="message.host"
                alt="Host"
                class="room-chat__host"
                fit="contain"
                :src="LEGACY_LIVE_HOST_BADGE_URL"
              />
              <template v-else>
                <AppImage
                  v-if="message.guardianLevel"
                  alt=""
                  aria-hidden="true"
                  class="room-chat__guardian"
                  fit="contain"
                  :src="legacyGuardianBadgeUrl(message.guardianLevel)"
                />
                <AppUserLevelTag v-if="message.userLevel" :level="message.userLevel" size="s" />
                <img
                  v-if="message.vip"
                  alt="VIP"
                  class="room-chat__vip"
                  :src="publicAsset('common/vip.webp')"
                />
                <AppImage
                  v-else-if="message.newUser"
                  alt="New"
                  class="room-chat__new"
                  fit="contain"
                  :src="LEGACY_LIVE_NEW_USER_BADGE_URL"
                />
              </template>
              <b>{{ message.nickname }}:</b>
            </span>
            <span
              class="room-chat__text-body"
              :class="{ 'uses-chat-skin': Boolean(message.chatBubbleUrl) }"
              :style="legacyChatBubbleStyle(message.chatBubbleUrl)"
            >
              <span
                v-if="(!message.chatBubbleUrl || message.guardianLevel) && message.nickname"
                class="room-chat__identity"
              >
                <AppImage
                  v-if="message.host"
                  alt="Host"
                  class="room-chat__host"
                  fit="contain"
                  :src="LEGACY_LIVE_HOST_BADGE_URL"
                />
                <template v-else>
                  <AppImage
                    v-if="message.guardianLevel"
                    alt=""
                    aria-hidden="true"
                    class="room-chat__guardian"
                    fit="contain"
                    :src="legacyGuardianBadgeUrl(message.guardianLevel)"
                  />
                  <AppUserLevelTag v-if="message.userLevel" :level="message.userLevel" size="s" />
                  <img
                    v-if="message.vip"
                    alt="VIP"
                    class="room-chat__vip"
                    :src="publicAsset('common/vip.webp')"
                  />
                  <AppImage
                    v-else-if="message.newUser"
                    alt="New"
                    class="room-chat__new"
                    fit="contain"
                    :src="LEGACY_LIVE_NEW_USER_BADGE_URL"
                  />
                </template>
                <b>{{ message.nickname }}:</b>
              </span>
              <span>{{ message.text }}</span>
              <i v-if="message.state === 'sending'" aria-label="Sending" />
              <button
                v-if="message.state === 'failed'"
                type="button"
                :disabled="retryMessageAction.pending.value"
                @click.stop="retryMessage(message.id)"
              >
                {{ t('room.chatRetry') }}
              </button>
            </span>
          </template>
        </div>
        <button
          v-if="context.mode === 'live' && showFollowPrompt"
          class="room-chat__follow-prompt"
          type="button"
          @click="toggleFollow"
        >
          <AppAvatar :alt="context.displayName" :size="34" :src="context.hostAvatarUrl" />
          <strong>{{ followed ? t('room.following') : t('room.followHer') }}</strong>
          <img
            alt=""
            :src="
              publicAsset(
                followed ? 'live-room/legacy/followed.webp' : 'live-room/legacy/follow.webp',
              )
            "
          />
        </button>
      </div>
      <button
        v-if="chatroom.state.value === 'failed'"
        class="room-chat__retry"
        type="button"
        :disabled="retryChatAction.pending.value"
        @click="retryChat"
      >
        {{ t('room.chatUnavailable') }} · {{ t('room.chatRetry') }}
      </button>
      <p v-else-if="chatroom.state.value === 'reconnecting'" class="room-chat__status">
        {{ t('room.chatReconnecting') }}
      </p>
      <p v-else-if="chatroom.state.value === 'kicked'" class="room-chat__status">
        {{ t('room.chatKicked') }}
      </p>
    </section>

    <section
      v-if="liveUiReady && chatroom.state.value === 'kicked'"
      class="error-card"
      role="alert"
    >
      <p>{{ t('room.chatKicked') }}</p>
      <button type="button" :disabled="closing" @click="closeRoom">
        {{ t('room.returnToLives') }}
      </button>
    </section>

    <section
      v-if="context.mode !== 'live' && rtcRoomEngine.state.value === 'failed'"
      class="error-card"
      role="alert"
    >
      <p>{{ failureText }}</p>
      <small>{{ failureReference }}</small>
      <button
        type="button"
        :aria-busy="retryAction.pending.value"
        :disabled="retryAction.pending.value"
        @click="retry"
      >
        {{ t('room.retry') }}
      </button>
      <button
        v-if="permissionDenied"
        type="button"
        class="settings-button"
        :aria-busy="settingsAction.pending.value"
        :disabled="settingsAction.pending.value"
        @click="openSettings"
      >
        {{ t('room.openSettings') }}
      </button>
    </section>

    <footer v-if="context.mode === 'voice' && context.role !== 'audience'" class="room-controls">
      <button
        type="button"
        :aria-busy="microphoneAction.pending.value"
        :disabled="closing || microphoneAction.pending.value"
        :class="{ 'is-off': rtcRoomEngine.microphoneMuted.value }"
        @click="toggleMicrophone"
      >
        <AppIcon name="microphone" :size="22" />
        <small>{{ t('room.microphone') }}</small>
      </button>
      <button
        class="leave-button"
        type="button"
        :aria-busy="closeRoomAction.pending.value"
        :disabled="closing || closeRoomAction.pending.value"
        @click="requestExit"
      >
        <AppIcon name="close" :size="22" />
        <small>{{ t('room.leave') }}</small>
      </button>
    </footer>
    <footer
      v-if="context.mode === 'voice' && context.role === 'audience' && chatSurfaceAvailable"
      class="room-chat-composer"
      :style="cleanBottomStyle"
    >
      <VanField
        v-if="context.chatRoomId"
        v-model="chatDraft"
        :disabled="chatDisabled"
        enterkeyhint="send"
        maxlength="500"
        :placeholder="chatPlaceholder"
        type="text"
        @keydown.enter.exact="handleChatEnter"
      />
      <button
        v-if="context.chatRoomId"
        class="room-chat-composer__send"
        type="button"
        :disabled="chatDisabled || !chatDraft.trim() || sendChatAction.pending.value"
        aria-label="Send"
        @click="sendChat(chatDraft)"
      >
        <img alt="" :src="publicAsset('common/btn_send.png')" />
      </button>
      <button
        class="room-chat-composer__gift"
        type="button"
        aria-label="Gifts"
        @click="showGiftPanel = true"
      >
        <img alt="" :src="publicAsset('common/gift_icon.png')" />
      </button>
      <button
        v-if="context.hostId"
        class="room-chat-composer__message"
        type="button"
        :aria-label="t('room.messageHost')"
        @click="openHostMessage"
      >
        <img alt="" :src="publicAsset('live-room/legacy/message.webp')" />
      </button>
      <button
        class="room-chat-composer__more"
        type="button"
        :aria-label="t('room.moreActions')"
        @click="showMore = true"
      >
        <img alt="" :src="publicAsset('common/more_icon.png')" />
      </button>
    </footer>

    <footer
      v-if="
        context.mode === 'live' &&
        context.role === 'audience' &&
        chatSurfaceAvailable &&
        liveUiReady
      "
      class="legacy-live-bottom"
      :class="{ 'is-composing': showChatComposer }"
      :style="cleanBottomStyle"
    >
      <template v-if="!showChatComposer">
        <button
          class="legacy-live-bottom__chat"
          type="button"
          aria-label="Open chat"
          @click="openChatComposer"
        >
          <span>{{ chatPlaceholder }}</span>
        </button>
        <div
          class="legacy-live-host"
          role="button"
          tabindex="0"
          @click="openAnchorCard"
          @keydown.enter="openAnchorCard"
        >
          <span class="legacy-live-host__avatar">
            <AppAvatar
              :alt="context.displayName"
              :lazy="false"
              :size="28"
              :src="context.hostAvatarUrl"
            />
            <AppHeadFrame
              v-if="context.hostHeadFrameUrl"
              class="legacy-live-host__frame"
              :lazy="false"
              :size="38"
              :src="context.hostHeadFrameUrl"
            />
          </span>
          <span class="legacy-live-host__copy">
            <strong>{{ context.displayName }}</strong>
            <small>
              <img alt="" :src="publicAsset('live-room/legacy/hot.webp')" />
              {{ liveHotScore.toLocaleString('en') }}
            </small>
          </span>
          <button
            :class="{ followed }"
            type="button"
            :aria-label="followed ? t('room.unfollow') : t('room.follow')"
            @click.stop="toggleFollow"
          >
            <img
              alt=""
              :src="
                publicAsset(
                  followed ? 'live-room/legacy/followed.webp' : 'live-room/legacy/follow.webp',
                )
              "
            />
          </button>
        </div>
        <button type="button" :aria-label="t('room.messageHost')" @click="openHostMessage">
          <img alt="" :src="publicAsset('live-room/legacy/ic-message.webp')" />
        </button>
        <button
          v-if="gameCenterAvailable"
          class="legacy-live-bottom__game"
          type="button"
          :aria-label="t('room.gameCenterTitle')"
          @click="openGameCenter"
        >
          <AppIcon name="game" :size="22" />
        </button>
        <button
          class="legacy-live-bottom__gift"
          type="button"
          aria-label="Gifts"
          @click="openGiftPanel()"
        >
          <img alt="" :src="publicAsset('common/gift_icon.png')" />
        </button>
        <button type="button" :aria-label="t('room.moreActions')" @click="showMore = true">
          <img alt="" :src="publicAsset('live-room/legacy/live_expand.webp')" />
        </button>
      </template>
      <template v-else>
        <button class="legacy-live-bottom__input-gift" type="button" @click="openGiftPanel()">
          <img alt="" :src="publicAsset('common/gift_icon.png')" />
        </button>
        <div v-if="chatSurfaceAvailable" ref="liveChatField" class="legacy-live-bottom__field">
          <VanField
            v-model="chatDraft"
            :disabled="chatDisabled"
            enterkeyhint="send"
            maxlength="500"
            :placeholder="chatPlaceholder"
            type="text"
            @blur="handleComposerBlur"
            @keydown.enter.exact="handleChatEnter"
          >
            <template #button>
              <button
                class="legacy-live-bottom__send"
                type="button"
                :disabled="chatDisabled || !chatDraft.trim() || sendChatAction.pending.value"
                aria-label="Send"
                @mousedown.prevent
                @click="sendChat(chatDraft)"
              >
                <img alt="" :src="publicAsset('common/btn_send.png')" />
              </button>
            </template>
          </VanField>
        </div>
      </template>
    </footer>

    <LiveAudienceSheet
      v-model="showAudience"
      :context="context"
      :initial-tab="audienceInitialTab"
      @profile="handleAudienceProfile"
      @total="handleAudienceTotal"
    />

    <LiveContributionSheet
      v-model="showContribution"
      :context="context"
      :income="liveIncome"
      @profile="handleAudienceProfile"
    />

    <LiveAnchorRankSheet
      v-model="showAnchorRank"
      :context="context"
      @closed="handleAnchorRankClosed"
      @profile="handleAudienceProfile"
      @support="supportAnchor"
    />

    <RoomMessageStack
      v-model="showMessages"
      v-model:conversation-target="messageConversationTarget"
      variant="live"
    />

    <LivePkRankSheet
      v-if="pkDisplayDetail"
      v-model="showPkRank"
      :detail="pkDisplayDetail"
      :preview-rows="pkPreviewRankRows"
      :resolve-detail="pkPreviewActive ? undefined : resolvePkRankDetail"
      :side="pkRankSide"
      @closed="flushPendingPkRankGift"
      @support="supportPkStreamer"
    />

    <LiveAnchorCardSheet
      v-model="showAnchorCard"
      :context="anchorCardContext"
      @detail="handleCardDetail"
      @follow-change="handleCardFollow"
      @message="handleCardMessage"
    />

    <LiveMoreSheet
      v-model="showMore"
      :pk-preview-available="pkPreviewAllowed && liveUiReady && !liveTerminalReason && !pkVisible"
      :pk-preview-label="pkPreviewButtonLabel"
      @closed="handleMoreClosed"
      @effect="openEffectSettings"
      @pk-preview="advancePkPreviewFromMore"
      @report="openReport"
    />

    <AppPopup v-model="showEffectSettings" class="legacy-effect-popup" :closeable="false">
      <h2>{{ t('room.effectSwitch') }}</h2>
      <label>
        <span>{{ t('room.virtualProps') }}</span>
        <VanSwitch v-model="effectsEnabled" active-color="var(--color-primary)" />
      </label>
    </AppPopup>

    <LiveRpsSheet
      v-if="LIVE_ROOM_GAMES_VISIBLE"
      v-model="showRps"
      :context="context"
      :suspended="giftRechargeCovered"
      @recharge="requestRpsRecharge"
    />

    <LiveGameCenterSheet
      v-if="LIVE_ROOM_GAMES_VISIBLE"
      v-model="showGameCenter"
      :catalog="halfGameCatalog"
      :error="halfGameCatalogError"
      :launching-id="halfGameLaunchingId"
      :loading="halfGameCatalogLoading"
      :rps-available="rpsAvailable"
      :suspended="giftRechargeCovered"
      :wheel-available="Boolean(liveWheelConfig)"
      @closed="handleGameCenterClosed"
      @retry="preloadHalfGameCatalog(true)"
      @select="selectHalfGame"
      @select-rps="selectRpsFromGameCenter"
      @select-wheel="selectWheelFromGameCenter"
    />

    <LiveHalfGamePanel
      v-if="LIVE_ROOM_GAMES_VISIBLE"
      v-model="showHalfGame"
      :launch="halfGameLaunch"
      :suspended="giftRechargeCovered"
      @closed="handleHalfGameClosed"
      @recharge="requestRpsRecharge"
    />

    <LiveGiftSheet
      v-model="showGiftPanel"
      :context="context"
      :initial-gift-id="selectedGiftId"
      :pk-active="pkVisible"
      :suspended="giftRechargeCovered"
      @recharge="requestRecharge"
      @sent="handleGiftSent"
    />

    <Transition name="exit-prompt">
      <div
        v-if="showExitPrompt"
        class="exit-prompt"
        role="presentation"
        @click.self="dismissExitPrompt"
      >
        <section aria-modal="true" role="dialog" aria-labelledby="live-exit-title">
          <button
            class="exit-prompt__close"
            type="button"
            aria-label="Close"
            @click="dismissExitPrompt"
          >
            <img alt="" :src="publicAsset('common/close.png')" />
          </button>
          <h2 id="live-exit-title">{{ t('room.leaveConfirm') }}</h2>
          <button
            class="exit-prompt__exit"
            type="button"
            :aria-busy="closeRoomAction.pending.value"
            :disabled="closeRoomAction.pending.value"
            @click="confirmClose"
          >
            {{ t('room.exit') }}
          </button>
          <button class="exit-prompt__cancel" type="button" @click.stop="dismissExitPrompt">
            {{ t('common.cancel') }}
          </button>
        </section>
      </div>
    </Transition>
  </main>
</template>

<style scoped lang="less">
.room {
  --pk-stage-top: calc(var(--safe-top) + 95px);
  --pk-stage-height: 366px;
  --pk-video-height: 334px;
  --pk-stage-bottom: calc(var(--pk-stage-top) + var(--pk-stage-height));
  --room-bottom-inset: var(--safe-bottom);
  --room-live-footer-occupied-height: calc(54px + var(--room-bottom-inset));
  --room-voice-footer-occupied-height: calc(68px + var(--room-bottom-inset));

  position: absolute;
  inset: 0;
  overflow: hidden;
  background: var(--color-bg);
  color: var(--color-on-dark);
}

.room--screen-cleared
  > :not(
    .room__backdrop,
    .room__cover,
    .video-surface,
    .live-clear-screen-controls,
    .legacy-live-top
  ) {
  visibility: hidden !important;
  pointer-events: none !important;
}

.room--screen-cleared .legacy-live-top > :not(.legacy-live-top__close) {
  visibility: hidden !important;
  pointer-events: none !important;
}

.live-clear-screen-controls {
  position: absolute;
  inset: 0;
  z-index: 24;
  pointer-events: none;
}

.live-clear-screen-controls button {
  position: absolute;
  display: flex;
  border: 0;
  background: var(--color-scrim-soft);
  color: var(--color-on-dark);
  pointer-events: auto;
}

.live-clear-screen-controls__exit {
  right: 15px;
  bottom: calc(var(--safe-bottom) + 26px);
  max-width: 200px;
  min-height: 40px;
  align-items: center;
  gap: 5px;
  padding: 5px 12px 5px 5px;
  border-radius: 22px;
  font-size: 13px;
  font-weight: 700;
}

.live-clear-screen-controls__exit img {
  width: 30px;
  height: 30px;
  object-fit: contain;
}

.clear-screen-exit-enter-active,
.clear-screen-exit-leave-active {
  transition:
    opacity 220ms cubic-bezier(0.2, 0, 0, 1),
    transform 220ms cubic-bezier(0.2, 0, 0, 1);
}

.clear-screen-exit-enter-from,
.clear-screen-exit-leave-to {
  opacity: 0;
  transform: translateX(12px);
}

@media (prefers-reduced-motion: reduce) {
  .clear-screen-exit-enter-active,
  .clear-screen-exit-leave-active {
    transition: none;
  }
}

.legacy-live-top {
  position: absolute;
  top: calc(var(--safe-top) + 5px);
  right: 15px;
  left: 15px;
  z-index: 12;
  display: flex;
  height: 40px;
  align-items: center;
  gap: 8px;
  pointer-events: none;
}

.legacy-live-top__giver,
.legacy-live-top__viewers,
.legacy-live-top__metrics,
.room-pk-top-background,
.room-pk-placeholder,
.room-entry-effect,
.room-fullscreen-effect,
.room-gift-banners,
.room-chat,
.live-overlay,
.legacy-live-bottom,
.room-chat-composer {
  backface-visibility: hidden;
  will-change: opacity, transform;
}

.live-clean-motion {
  backface-visibility: hidden;
  will-change: opacity, transform;
}

.legacy-live-top button {
  display: flex;
  height: 36px;
  align-items: center;
  justify-content: center;
  padding: 0;
  border: 0;
  color: var(--color-on-dark);
  pointer-events: auto;
}

.legacy-live-top__close,
.legacy-live-top__viewers {
  width: 36px;
  flex: 0 0 36px;
  background: transparent;
}

.legacy-live-top__close {
  margin-right: auto;
}

.legacy-live-top__giver {
  position: relative;
  width: 36px;
  flex: 0 0 36px;
  background: transparent;
}

.legacy-live-top__giver > img {
  position: absolute;
  top: -5px;
  right: -4px;
  width: 20px;
  height: 20px;
  object-fit: contain;
}

.legacy-live-top__close img {
  width: 36px;
  height: 36px;
  object-fit: contain;
}

.legacy-live-top__viewers {
  position: relative;
}

.legacy-live-top__viewers img {
  width: 36px;
  height: 36px;
  object-fit: contain;
}

.legacy-live-top__viewers span {
  position: absolute;
  top: -5px;
  right: -3px;
  min-width: 18px;
  height: 16px;
  padding: 0 4px;
  border-radius: 8px;
  background: var(--color-on-dark-strong);
  color: var(--color-on-dark-subtle);
  font-size: 10px;
  font-weight: 700;
  line-height: 16px;
}

.legacy-live-top__host {
  display: flex;
  min-width: 0;
  height: 36px;
  flex: 1 1 150px;
  align-items: center;
  overflow: hidden;
  border-radius: 20px;
  background: var(--color-scrim-soft);
  pointer-events: auto;
}

.legacy-live-top__host-profile {
  min-width: 0;
  flex: 1;
  gap: 6px;
  justify-content: flex-start !important;
}

.legacy-live-top__host-avatar {
  position: relative;
  display: grid;
  width: 34px;
  height: 34px;
  flex: 0 0 34px;
  place-items: center;
}

.legacy-live-top__host-frame {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.legacy-live-top__host-copy {
  display: grid;
  min-width: 0;
  flex: 1;
  gap: 1px;
  text-align: left;
}

.legacy-live-top__host-copy strong {
  overflow: hidden;
  max-width: 100%;
  font-size: 12px;
  line-height: 14px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.legacy-live-top__host-copy small {
  display: flex;
  align-items: center;
  gap: 3px;
  font-size: 10px;
  line-height: 12px;
}

.legacy-live-top__host-copy small img {
  width: 10px;
  height: 10px;
  object-fit: contain;
}

.legacy-live-top__follow {
  width: 29px;
  height: 29px !important;
  flex: 0 0 29px;
  margin-right: 3px;
  border-radius: 50%;
  background: linear-gradient(100deg, var(--color-secondary), var(--color-primary));
}

.legacy-live-top__follow.followed {
  border: 1px solid var(--color-on-dark-subtle);
  background: var(--color-on-dark-border);
}

.legacy-live-top__follow img {
  width: 20px;
  height: 20px;
  object-fit: contain;
}

.legacy-live-top__metrics {
  position: absolute;
  top: 42px;
  left: 44px;
  display: flex;
  gap: 5px;
  pointer-events: auto;
}

.legacy-live-top__metrics button {
  width: auto;
  min-width: 52px;
  height: 22px;
  gap: 3px;
  padding: 0 8px;
  border-radius: 11px;
  background: var(--color-scrim-soft);
  font-size: 10px;
  line-height: 22px;
}

.legacy-live-top__metrics button img {
  width: 12px;
  height: 12px;
  object-fit: contain;
}

.exit-prompt {
  position: absolute;
  inset: 0;
  z-index: 30;
  display: grid;
  padding: 40px;
  background: none;
  place-items: center;
}

.exit-prompt section {
  position: relative;
  display: grid;
  width: min(100%, 320px);
  grid-template-columns: repeat(2, 1fr);
  gap: 10px;
  padding: 32px 18px 18px;
  border: 0;
  border-radius: 16px;
  background: var(--gradient-party-sheet);
  text-align: center;
}

.exit-prompt h2 {
  grid-column: 1 / -1;
  margin: 0 0 14px;
  font-family:
    'TT Norms Pro',
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    sans-serif;
  font-size: 16px;
}

.exit-prompt button {
  min-height: 44px;
  border: 0;
  border-radius: 999px;
  background: var(--color-on-dark-border);
  color: var(--color-on-dark);
  font-size: 13px;
  font-weight: 900;
}

.exit-prompt .exit-prompt__cancel {
  background: linear-gradient(100deg, var(--color-primary), var(--color-secondary));
}

.exit-prompt .exit-prompt__close {
  position: absolute;
  top: 8px;
  right: 8px;
  display: grid;
  width: 30px;
  min-height: 30px;
  padding: 0;
  border-radius: 50%;
  place-items: center;
  background: none !important;
}

.exit-prompt .exit-prompt__close img {
  width: 24px;
  height: 24px;
  object-fit: contain;
}

.exit-prompt-enter-active,
.exit-prompt-leave-active {
  transition: opacity 180ms ease;
}

.exit-prompt-enter-from,
.exit-prompt-leave-to {
  opacity: 0;
}

.room__backdrop {
  position: absolute;
  inset: 0;
  background:
    radial-gradient(
      circle at 70% 18%,
      color-mix(in srgb, var(--color-secondary) 48%, transparent),
      transparent 34%
    ),
    radial-gradient(
      circle at 15% 76%,
      color-mix(in srgb, var(--color-accent) 38%, transparent),
      transparent 30%
    ),
    linear-gradient(
      160deg,
      color-mix(in srgb, var(--color-primary) 12%, var(--color-bg)),
      var(--color-media-bg) 72%
    );
}

.room__cover {
  position: absolute;
  inset: 0;
  width: 100% !important;
  height: 100% !important;
  transition: opacity 180ms cubic-bezier(0.2, 0, 0, 1);

  &::after {
    position: absolute;
    inset: 0;
    background: linear-gradient(var(--color-scrim-soft), var(--color-scrim));
    content: '';
    pointer-events: none;
  }
}

.room__cover.is-loading-obscured::after {
  background: var(--live-loading-cover-mask);
  backdrop-filter: blur(min(2.667vw, 16px));
  -webkit-backdrop-filter: blur(min(2.667vw, 16px));
}

.room__cover.is-pk-hidden {
  opacity: 0;
}

.room--pk .room__backdrop {
  background: linear-gradient(239.74deg, var(--color-bg) 0%, var(--color-page-deep) 100%);
}

.room-pk-top-background {
  position: absolute;
  top: var(--safe-top);
  right: 0;
  left: 0;
  z-index: 8;
  height: 95px;
  pointer-events: none;
}

@media (prefers-reduced-motion: reduce) {
  .room__cover {
    transition: none;
  }
}

.video-surface {
  position: absolute;
  width: 100%;
  height: 100%;
  overflow: hidden;
  object-fit: cover;
  background: var(--color-media-bg);

  :deep(video) {
    width: 100% !important;
    height: 100% !important;
    object-fit: cover !important;
  }
}

.video-surface--remote {
  inset: 0;
  background: transparent;
}

.room-pk-placeholder {
  position: absolute;
  top: var(--pk-stage-top);
  right: 0;
  left: 0;
  z-index: 10;
  display: grid;
  height: var(--pk-stage-height);
  align-content: center;
  justify-items: center;
  gap: 10px;
  background: linear-gradient(
    90deg,
    color-mix(in srgb, var(--color-primary) 34%, var(--color-scrim)),
    color-mix(in srgb, var(--color-link) 28%, var(--color-scrim))
  );
  color: var(--color-on-dark-strong);
  font-size: 12px;
  pointer-events: none;
  backdrop-filter: blur(10px);

  i {
    width: 24px;
    height: 24px;
    border: 2px solid var(--color-on-dark-border-strong);
    border-top-color: var(--color-on-dark);
    border-radius: 50%;
    animation: spin 0.8s linear infinite;
  }

  &.is-failed {
    background: color-mix(in srgb, var(--color-media-bg) 82%, transparent);
  }
}

.video-surface--local {
  width: 92px;
  height: 132px;
  top: calc(var(--safe-top) + 68px);
  right: 14px;
  z-index: 3;
  border: 1px solid var(--color-on-dark-border-strong);
  border-radius: 18px;
  box-shadow: 0 12px 34px rgb(0 0 0 / 35%);
}

.room__header {
  position: absolute;
  top: 0;
  right: 0;
  left: 0;
  z-index: 8;
  display: flex;
  align-items: center;
  gap: 8px;
  padding: calc(var(--safe-top) + 6px) 16px 6px;
  background: linear-gradient(var(--color-scrim), transparent);
}

.room__identity {
  display: flex;
  min-width: 0;
  flex: 1;
  align-items: center;
  gap: 7px;
  max-width: calc(100% - 80px);
  padding: 3px 6px 3px 3px;
  border: 1px solid var(--color-on-dark-border);
  border-radius: 999px;
  background: var(--color-scrim-soft);
  backdrop-filter: blur(14px);
}

.room__avatar-ring {
  display: grid;
  width: 40px;
  height: 40px;
  flex: 0 0 auto;
  padding: 2px;
  border: 0;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--color-primary), var(--color-secondary));
  place-items: center;
}

.room__avatar-ring :deep(.app-avatar) {
  border: 2px solid var(--color-media-bg);
}

.room__identity-copy {
  display: grid;
  min-width: 0;
  flex: 1;
  gap: 2px;
}

.room__identity-copy strong,
.room__identity-copy small {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.room__identity-copy strong {
  font-size: 12px;
  font-weight: 900;
}

.room__identity-meta {
  display: flex;
  min-width: 0;
  align-items: center;
  gap: 2px;
}

.room__identity-copy small {
  color: var(--color-on-dark-secondary);
  font-family: ui-monospace, monospace;
  font-size: 9px;
}

.room__viewer-chip,
.room__follow {
  flex: 0 0 auto;
  border-radius: 999px;
  color: var(--color-on-dark);
  font-size: 10px;
  font-weight: 900;
}

.room__viewer-chip {
  display: inline-flex;
  min-height: 26px;
  align-items: center;
  gap: 4px;
  padding: 0 8px;
  border: 0;
  background: var(--color-scrim-soft);
}

.room__viewer-chip img {
  width: 12px;
  height: 9px;
  object-fit: contain;
}

.room__follow {
  display: inline-flex;
  min-height: 26px;
  align-items: center;
  gap: 3px;
  padding: 0 9px;
  border: 0;
  background: linear-gradient(100deg, var(--color-primary), var(--color-secondary));
  color: var(--color-on-primary);
}

.room__follow.is-following {
  border: 1px solid color-mix(in srgb, var(--color-accent) 28%, transparent);
  background: linear-gradient(
    110deg,
    color-mix(in srgb, var(--color-primary) 10%, var(--color-surface)),
    color-mix(in srgb, var(--color-accent) 14%, var(--color-surface))
  );
  color: var(--color-on-dark);
}

.room__chrome-button {
  display: grid;
  width: 32px;
  height: 32px;
  flex: 0 0 auto;
  padding: 0;
  border: 1px solid color-mix(in srgb, var(--color-accent) 24%, transparent);
  border-radius: 50%;
  background: linear-gradient(
    135deg,
    color-mix(in srgb, var(--color-accent) 10%, var(--color-surface)),
    color-mix(in srgb, var(--color-media-bg) 88%, transparent)
  );
  color: var(--color-on-dark);
  backdrop-filter: blur(12px);
  place-items: center;
}

.room-entry-effect {
  position: absolute;
  inset: 0;
  z-index: 11;
  pointer-events: none;
}

.room-entry-effect__animation {
  position: absolute;
  inset: 0;
}

.room-entry-effect__person {
  position: absolute;
  top: 70%;
  left: 15px;
  display: flex;
  width: calc(100% - 80px);
  height: 70px;
  align-items: center;
  padding: 6px 16px;
  background-image: var(--room-entry-background);
  background-position: center;
  background-repeat: no-repeat;
  background-size: 100% 100%;
  color: var(--color-on-dark);
  opacity: 1;
  text-align: center;
  animation: room-entry-effect-strip 3s ease-in-out forwards;

  strong {
    overflow: hidden;
    max-width: 50px;
    margin-inline: 2px;
    color: var(--color-party-chat-name);
    font-size: 12px;
    font-weight: 700;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
}

.room-entry-effect--guardian .room-entry-effect__person,
.room-entry-effect--high-level .room-entry-effect__person {
  width: 256px;
  height: 35px;
  min-height: 35px;
}

.room-entry-effect--high-level .room-entry-effect__person {
  overflow: hidden;
  border-radius: 25px 0 0 25px;
}

.room-entry-effect__avatar {
  position: relative;
  z-index: 1;
  flex: 0 0 auto;
  margin: 4px 1.5px;
}

.room-entry-effect--high-level .room-entry-effect__avatar {
  position: absolute;
  top: 50%;
  left: 8px;
  margin: 0;
  transform: translateY(-50%);
}

.room-entry-effect__identity {
  position: absolute;
  z-index: 1;
  top: 26px;
  left: 70px;
  display: flex;
  min-width: 0;
  align-items: center;
  font-size: 12px;
  line-height: 16px;
}

.room-entry-effect--guardian .room-entry-effect__identity {
  top: 50%;
  left: 20px;
  transform: translateY(-50%);
}

.room-entry-effect--high-level .room-entry-effect__identity {
  top: 50%;
  left: 40px;
  transform: translateY(-50%);
}

.room-entry-effect__vip {
  width: 32px;
  height: 12px;
  flex: 0 0 auto;
  object-fit: contain;
}

[dir='rtl'] .room-entry-effect__person {
  right: 15px;
  left: auto;
  background-image: var(--room-entry-background-rtl);
  animation-name: room-entry-effect-strip-rtl;
}

[dir='rtl'] .room-entry-effect--high-level .room-entry-effect__person {
  border-radius: 0 25px 25px 0;
}

[dir='rtl'] .room-entry-effect--high-level .room-entry-effect__avatar {
  right: 8px;
  left: auto;
}

[dir='rtl'] .room-entry-effect__identity {
  right: 70px;
  left: auto;
}

[dir='rtl'] .room-entry-effect--guardian .room-entry-effect__identity {
  right: 20px;
  left: auto;
}

[dir='rtl'] .room-entry-effect--high-level .room-entry-effect__identity {
  right: 40px;
  left: auto;
}

.room-fullscreen-effect {
  position: absolute;
  inset: 0;
  z-index: 12;
  width: 100%;
  height: 100%;
  pointer-events: none;
}

@keyframes room-entry-effect-strip {
  0% {
    transform: translateX(-110%);
  }

  12%,
  80% {
    transform: translateX(0);
  }

  100% {
    transform: translateX(-110%);
  }
}

@keyframes room-entry-effect-strip-rtl {
  0% {
    transform: translateX(110%);
  }

  12%,
  80% {
    transform: translateX(0);
  }

  100% {
    transform: translateX(110%);
  }
}

.voice-stage {
  position: absolute;
  inset: calc(var(--safe-top) + 82px) 20px calc(var(--room-voice-footer-occupied-height) + 32px);
  z-index: 2;
  display: flex;
  flex-direction: column;
  align-items: center;

  h1 {
    margin: 26px 0 4px;
    font-size: 25px;
  }

  > p {
    margin: 0;
    color: var(--color-on-dark-muted);
    font-size: 12px;
  }
}

.voice-stage__hero {
  position: relative;
  width: 116px;
  height: 116px;
  display: grid;
  place-items: center;
  margin-top: 22px;

  > span {
    width: 92px;
    height: 92px;
    display: grid;
    place-items: center;
    z-index: 2;
    border-radius: 32px;
    background: linear-gradient(145deg, var(--color-secondary), var(--color-primary));
    box-shadow: 0 20px 50px color-mix(in srgb, var(--color-primary) 35%, transparent);
    font-size: 34px;
    font-weight: 850;
  }

  i {
    position: absolute;
    inset: calc(var(--ring) * -8px);
    border: 1px solid
      color-mix(in srgb, var(--color-secondary) calc(52% - var(--ring) * 9%), transparent);
    border-radius: 40%;
  }
}

.speaker-grid {
  width: 100%;
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 24px 10px;
  margin-top: auto;
}

.speaker {
  display: grid;
  justify-items: center;
  gap: 7px;

  span {
    width: 50px;
    height: 50px;
    display: grid;
    place-items: center;
    border: 2px solid transparent;
    border-radius: 18px;
    background: var(--color-on-dark-fill);
    font-weight: 750;

    &.is-speaking {
      border-color: var(--color-secondary);
      box-shadow: 0 0 0 4px color-mix(in srgb, var(--color-secondary) 18%, transparent);
    }
  }

  small {
    color: var(--color-on-dark-muted);
    font-size: 9px;
  }
}

.live-overlay {
  position: absolute;
  inset: 0;
  z-index: 2;
  pointer-events: none;
}

.room-loader {
  position: absolute;
  inset: 0;
  display: grid;
  place-content: center;
  justify-items: center;
  gap: 13px;
  background: var(--color-scrim-soft);

  span {
    font-size: 12px;
  }
}

.host-away {
  position: absolute;
  inset: 0;
  z-index: 7;
  display: grid;
  align-content: center;
  justify-items: center;
  gap: 10px;
  background: var(--color-scrim);
  color: var(--color-on-dark-strong);
  text-align: center;
}

.host-away strong {
  color: var(--color-on-dark);
  font-family:
    'TT Norms Pro',
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    sans-serif;
  font-size: 16px;
}

.host-away span {
  color: var(--color-on-dark-secondary);
  font-size: 12px;
}

.room-chat {
  position: absolute;
  right: 16px;
  bottom: var(--room-voice-footer-occupied-height);
  left: 14px;
  z-index: 6;
  min-width: 0;
  pointer-events: none;
}

.room--live .room-chat {
  right: auto;
  bottom: var(--room-live-footer-occupied-height);
  left: 15px;
  width: 270px;
}

.room--live.room--pk .room-chat {
  bottom: var(--room-live-footer-occupied-height);
  z-index: 9;
}

.room-gift-banners {
  position: absolute;
  top: 40%;
  left: 15px;
  z-index: 11;
  display: block;
  width: 216px;
  pointer-events: none;
}

.room-gift-banner {
  display: flex;
  width: 216px;
  height: 40px;
  align-items: center;
  padding: 4px 0 4px 4px;
  border: 0;
  border-radius: 33px;
  background: linear-gradient(
    90deg,
    color-mix(in srgb, var(--color-danger) 58%, var(--color-text)) 0%,
    color-mix(in srgb, var(--color-primary) 60%, transparent) 45%,
    color-mix(in srgb, var(--color-warning) 10%, transparent) 100%
  );
  transition: all 300ms cubic-bezier(0.2, 0, 0, 1);

  &.is-leaving {
    opacity: 0;
    transform: translateX(-220px);
  }

  > .app-avatar {
    margin-right: 8px;
  }

  > span:not(.room-gift-banner__gift) {
    display: grid;
    min-width: 0;
    width: 80px;
    margin-right: 8px;

    strong {
      overflow: hidden;
      font-size: 12px;
      font-weight: 500;
      line-height: 14px;
      text-overflow: ellipsis;
      white-space: nowrap;
    }

    small {
      display: flex;
      min-width: 0;
      align-items: center;
      color: var(--color-on-dark);
      font-size: 13px;
      font-weight: 700;
      line-height: 15px;

      b {
        overflow: hidden;
        max-width: 60px;
        margin-left: 8px;
        color: var(--color-party-entry-highlight);
        text-overflow: ellipsis;
        white-space: nowrap;
      }
    }
  }

  > em {
    color: var(--color-on-dark);
    font-size: 15px;
    font-style: normal;
    font-weight: 700;
  }
}

.room-gift-banner__gift {
  display: grid;
  width: 32px;
  height: 32px;
  flex: 0 0 auto;
  place-items: center;

  :deep(.app-image),
  :deep(img) {
    width: 32px !important;
    height: 32px !important;
  }
}

[dir='rtl'] .room-gift-banners {
  right: 15px;
  left: auto;
}

[dir='rtl'] .room-gift-banner {
  padding: 4px 4px 4px 0;
  background: linear-gradient(
    270deg,
    color-mix(in srgb, var(--color-danger) 58%, var(--color-text)) 0%,
    color-mix(in srgb, var(--color-primary) 60%, transparent) 45%,
    color-mix(in srgb, var(--color-warning) 10%, transparent) 100%
  );
}

.gift-banner-enter-active {
  transition: all 320ms cubic-bezier(0.2, 0.8, 0.2, 1);
}

.gift-banner-leave-active {
  transition: all 300ms cubic-bezier(0.2, 0, 0, 1);
}

.gift-banner-enter-from,
.gift-banner-leave-to {
  opacity: 0;
  transform: translateX(-220px);
}

[dir='rtl'] .gift-banner-enter-from,
[dir='rtl'] .gift-banner-leave-to,
[dir='rtl'] .room-gift-banner.is-leaving {
  transform: translateX(220px);
}

.room-chat__messages {
  max-height: 188px;
  overflow: hidden auto;
  padding-top: 42px;
  scrollbar-width: none;
  mask-image: linear-gradient(transparent 0, var(--color-ink) 36px, var(--color-ink) 100%);
  overscroll-behavior: contain;
  pointer-events: auto;
  touch-action: pan-y;

  &::-webkit-scrollbar {
    display: none;
  }
}

.room--live .room-chat__messages {
  max-height: 240px;
  padding-top: 34px;
  mask-image: linear-gradient(transparent 0, var(--color-ink) 28px, var(--color-ink) 100%);
}

.room--pk .room-chat__messages {
  height: 150px;
  max-height: 150px;
}

.room-chat__safety {
  display: block;
  width: 243px;
  max-width: 243px;
  margin-bottom: 7px;
  object-fit: contain;
}

.room-chat__follow-prompt {
  display: flex;
  width: fit-content;
  max-width: 245px;
  min-height: 42px;
  align-items: center;
  gap: 8px;
  margin-top: 7px;
  padding: 4px 5px;
  border: 0;
  border-radius: 23px;
  background: linear-gradient(
    90deg,
    color-mix(in srgb, var(--color-primary) 58%, var(--color-surface)),
    color-mix(in srgb, var(--color-secondary) 48%, var(--color-surface))
  );
  color: var(--color-on-dark);
  pointer-events: auto;
}

.room-chat__follow-prompt strong {
  min-width: 0;
  overflow: hidden;
  font-size: 13px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.room-chat__follow-prompt > img {
  width: 34px;
  height: 34px;
  margin-left: auto;
  object-fit: contain;
}

.room-chat__message {
  width: fit-content;
  max-width: 100%;
  margin-top: 5px;
  padding: 7px 10px;
  border-radius: 5px 14px 14px;
  background: var(--color-scrim-soft);
  box-shadow: 0 3px 14px rgb(0 0 0 / 8%);
  font-size: 13px;
  line-height: 1.35;
  overflow-wrap: anywhere;
  backdrop-filter: blur(12px);

  strong {
    margin-right: 5px;
    color: color-mix(in srgb, var(--color-secondary) 76%, var(--color-text));
    font-weight: 750;
  }

  > i {
    display: inline-block;
    width: 9px;
    height: 9px;
    margin-left: 6px;
    border: 1.5px solid var(--color-on-dark-disabled);
    border-top-color: var(--color-on-dark);
    border-radius: 50%;
    animation: spin 0.8s linear infinite;
  }

  > button {
    margin-left: 7px;
    padding: 0;
    border: 0;
    background: transparent;
    color: color-mix(in srgb, var(--color-danger) 46%, var(--color-text));
    font: inherit;
    font-weight: 750;
    pointer-events: auto;
  }

  &.is-own {
    background: color-mix(in srgb, var(--color-primary) 28%, var(--color-scrim));
  }

  &.is-failed {
    border: 1px solid color-mix(in srgb, var(--color-danger) 35%, transparent);
  }

  &.is-announcement {
    display: flex;
    align-items: flex-start;
    gap: 5px;
    border-radius: 12px;
    background: var(--color-on-dark-border);
    color: var(--color-on-dark-strong);
  }

  &.is-host strong {
    color: var(--color-accent);
  }

  &.is-enter {
    display: flex;
    max-height: 42px;
    align-items: center;
    gap: 5px;
    overflow: hidden;
    border: 1px solid color-mix(in srgb, var(--color-accent) 60%, transparent);
    border-radius: 999px;
    background: linear-gradient(100deg, var(--color-primary), var(--color-secondary));
    color: var(--color-on-dark);
    animation: room-enter-message 4.1s ease forwards;

    strong {
      margin-right: 0;
      color: var(--color-on-dark);
    }
  }

  &.is-gift {
    display: flex;
    align-items: center;
    gap: 7px;
    border: 1px solid color-mix(in srgb, var(--color-warning) 50%, transparent);
    border-radius: 999px;
    background: linear-gradient(
      90deg,
      color-mix(in srgb, var(--color-warning) 32%, transparent),
      color-mix(in srgb, var(--color-primary) 22%, transparent),
      transparent
    );

    strong {
      margin-right: 0;
      color: var(--color-warning);
    }

    em {
      padding: 2px 6px;
      border-radius: 999px;
      background: var(--color-warning);
      color: var(--color-on-primary);
      font-size: 12px;
      font-style: normal;
      font-weight: 900;
    }
  }
}

.room--live .room-chat__message {
  max-width: 249px;
  margin-top: 4px;
  padding: 0;
  border: 0;
  border-radius: 0;
  background: transparent;
  box-shadow: none;
  color: var(--color-on-dark);
  font-size: 13px;
  font-weight: 700;
  line-height: 18px;
  overflow-wrap: anywhere;
  backdrop-filter: none;
}

.room-chat__text-body {
  display: block;
  width: fit-content;
  max-width: 249px;
  min-height: 22px;
  padding: 4px 8px;
  border-radius: 12px;
  background: var(--color-scrim-soft);
}

.room-chat__text-body.uses-chat-skin {
  box-sizing: border-box;
  padding: 0;
  border: solid transparent;
  border-width: min(4.267vw, 25.6px) min(5.867vw, 35.2px);
  border-radius: 0;
  border-image-slice: 63 87 63 87 fill;
  border-image-width: min(8.533vw, 51.2px) min(11.733vw, 70.4px);
  border-image-repeat: stretch;
  background: transparent;
}

.room-chat__message.uses-chat-skin > .room-chat__identity {
  margin-bottom: 2px;
}

.room-chat__identity {
  display: inline-flex;
  max-width: 100%;
  align-items: center;
  gap: 2px;
  margin-right: 4px;
  vertical-align: middle;
}

.room-chat__identity b {
  overflow: hidden;
  max-width: 96px;
  color: var(--color-party-chat-name);
  font-size: 13px;
  font-weight: 700;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.room-chat__message.is-host .room-chat__identity b {
  color: var(--color-party-accent-fuchsia);
}

.room-chat__host {
  width: 31px;
  height: 12px;
  flex: 0 0 auto;
  object-fit: cover;
}

.room-chat__guardian {
  width: 14px;
  height: 14px;
  flex: 0 0 auto;
  object-fit: contain;
}

.room-chat__vip {
  width: 32px;
  height: 12px;
  flex: 0 0 auto;
  object-fit: contain;
}

.room-chat__new {
  width: 25px;
  height: 12px;
  flex: 0 0 auto;
  object-fit: contain;
}

.room-chat__entry-copy {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  color: var(--color-on-dark);
  white-space: nowrap;
}

.room-chat__message[role='button'] {
  cursor: pointer;
}

.room-chat__message[role='button']:focus-visible {
  outline: 2px solid var(--color-on-dark-secondary);
  outline-offset: 2px;
}

.room--live .room-chat__message.is-enter {
  display: flex;
  width: fit-content;
  max-width: 249px;
  min-height: 22px;
  align-items: center;
  gap: 0;
  overflow: visible;
  padding: 5px 8px 5px 4px;
  border-radius: 12px;
  background: var(--color-scrim-soft);
  animation: none;
}

.room--live .room-chat__message.is-enter .room-chat__identity b {
  max-width: 72px;
}

.room--live .room-chat__message.is-gift {
  display: flex;
  max-width: 249px;
  min-height: 24px;
  align-items: center;
  padding: 0 8px;
  border-radius: 12px;
  background: var(--color-scrim-soft);
}

.room--live .room-chat__message.is-gift > em {
  padding: 0;
  border-radius: 0;
  background: transparent;
  color: var(--color-on-dark);
  font-size: 15px;
  font-style: normal;
  font-weight: 700;
  white-space: nowrap;
}

.room-chat__gift-icon {
  position: relative;
  display: inline-grid;
  width: 32px;
  height: 32px;
  flex: 0 0 auto;
  margin-inline: 2px;
  overflow: visible;
  border: 0;
  border-radius: 0;
  background: transparent;
  vertical-align: middle;
  place-items: center;
}

.room--live .room-chat__message.is-announcement {
  display: block;
  box-sizing: border-box;
  max-width: 249px;
  padding: 4px 8px;
  border: 1px solid var(--color-party-chat-notice-border);
  border-radius: 12px;
  background: color-mix(in srgb, var(--color-link) 36%, transparent);
  font-size: 13px;
  line-height: 18px;
}

.room--live .room-chat__message.is-announcement > strong {
  display: block;
  margin: 0;
  color: var(--color-party-chat-notice-title);
  font-weight: 700;
}

.room--live .room-chat__message.is-announcement > span {
  display: block;
  margin-top: 2px;
  color: var(--color-on-dark);
  white-space: pre-wrap;
  overflow-wrap: anywhere;
}

.room--live .room-chat__message.is-wheel-result {
  display: flex;
  width: 268px;
  max-width: 268px;
  min-height: 46px;
  align-items: center;
  gap: 8px;
  padding: 9px 8px;
  border: 1px solid color-mix(in srgb, var(--color-warning) 60%, var(--color-text));
  border-radius: 24px;
  background: color-mix(in srgb, var(--color-danger) 60%, var(--color-warning));
}

.room-chat__wheel-icon {
  width: 28px;
  height: 28px;
  flex: 0 0 28px;
  object-fit: contain;
}

.room-chat__wheel-copy {
  min-width: 0;
  color: var(--color-on-dark);
  font-size: 12px;
  font-weight: 700;
  line-height: 16px;
  overflow-wrap: anywhere;
}

.room--live .room-chat__message.is-wheel-result.is-own .room-chat__wheel-copy {
  font-size: 13px;
}

.room--live .room-chat__message.is-wheel-result .room-chat__wheel-copy b {
  color: var(--color-party-chat-name);
  font-weight: 700;
}

.room--live .room-chat__message.is-wheel-result .room-chat__wheel-copy strong {
  margin: 0;
  color: var(--color-party-rank-score);
  font-weight: 700;
}

.room-chat__text-body > i {
  display: inline-block;
  width: 9px;
  height: 9px;
  margin-left: 6px;
  border: 1.5px solid var(--color-on-dark-disabled);
  border-top-color: var(--color-on-dark);
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

.room-chat__text-body > button {
  margin-left: 7px;
  padding: 0;
  border: 0;
  background: transparent;
  color: color-mix(in srgb, var(--color-danger) 46%, var(--color-text));
  font: inherit;
  font-weight: 700;
  pointer-events: auto;
}

.room-chat__message.is-failed .room-chat__text-body {
  border: 1px solid color-mix(in srgb, var(--color-danger) 35%, transparent);
}

.room-chat__retry,
.room-chat__status {
  width: fit-content;
  max-width: 100%;
  margin: 8px 0 0;
  padding: 7px 10px;
  border: 1px solid var(--color-on-dark-border);
  border-radius: 13px;
  background: var(--color-scrim);
  color: var(--color-on-dark-secondary);
  font-size: 11px;
  pointer-events: auto;
  backdrop-filter: blur(12px);
}

.room-chat-composer {
  position: absolute;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 8;
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 6px max(12px, var(--safe-right)) max(6px, var(--room-bottom-inset))
    max(12px, var(--safe-left));
  border-top: 0;
  background: color-mix(in srgb, var(--color-page-deep) 88%, transparent);

  :deep(.van-cell) {
    --van-cell-horizontal-padding: 16px;
    --van-cell-vertical-padding: 7px;

    min-width: 0;
    min-height: 36px;
    flex: 1;
    border-color: var(--color-on-dark-fill);
    border-style: solid;
    border-width: 1px;
    border-radius: 999px;
    background: var(--color-feedback-field);
  }

  :deep(.van-cell:focus-within) {
    border-color: color-mix(in srgb, var(--color-primary) 44%, transparent);
  }

  :deep(.van-field__control) {
    color: var(--color-on-dark);
  }

  :deep(.van-field__control::placeholder) {
    color: var(--color-feedback-placeholder);
  }
}

.room-chat-composer > button {
  display: grid;
  width: 40px;
  height: 40px;
  padding: 0;
  border: 0;
  border-radius: 50%;
  background: linear-gradient(100deg, var(--color-primary), var(--color-secondary));
  color: var(--color-on-primary);
  place-items: center;
}

.room-chat-composer > button img {
  width: 40px;
  height: 40px;
  object-fit: contain;
}

.room-chat-composer > .room-chat-composer__send {
  width: 40px;
  height: 36px;
  flex: 0 0 40px;
  background: transparent;
}

.room-chat-composer > .room-chat-composer__send img {
  width: 32px;
  height: 24px;
}

.room-chat-composer > .room-chat-composer__gift,
.room-chat-composer > .room-chat-composer__message,
.room-chat-composer > .room-chat-composer__more {
  flex: 0 0 40px;
  background: transparent;
}

.room-chat-composer > button:disabled {
  opacity: 0.38;
}

.legacy-live-bottom {
  position: absolute;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 8;
  display: flex;
  min-height: calc(var(--room-bottom-inset) + 54px);
  align-items: center;
  gap: 2px;
  padding: 8px 12px max(8px, var(--room-bottom-inset));
  background: linear-gradient(transparent, var(--color-scrim-soft));
}

.legacy-live-bottom.is-composing {
  min-height: calc(var(--room-bottom-inset) + 46px);
  gap: 8px;
  padding-top: 6px;
  padding-bottom: max(6px, var(--room-bottom-inset));
  background: color-mix(in srgb, var(--color-page-deep) 94%, transparent);
}

.legacy-live-bottom > button:not(.legacy-live-host, .legacy-live-bottom__input-gift),
.legacy-live-bottom > div:not(.legacy-live-host, .van-cell, .legacy-live-bottom__field) {
  flex: 0 0 36px;
}

.legacy-live-bottom > button {
  position: relative;
  display: grid;
  width: 36px;
  height: 36px;
  padding: 0;
  border: 0;
  border-radius: 50%;
  background: transparent;
  place-items: center;
}

.legacy-live-bottom__chat {
  margin-right: auto;
}

.legacy-live-bottom > button.legacy-live-bottom__chat {
  width: auto;
  min-width: 52px;
  max-width: 68px;
  height: 34px;
  flex: 0 1 68px;
  justify-content: start;
  padding: 0 10px;
  border: 1px solid var(--color-on-dark-border-strong);
  border-radius: 17px;
  background: var(--color-scrim-soft);
  color: var(--color-on-dark-secondary);
}

.legacy-live-bottom__chat > span {
  overflow: hidden;
  font-size: 13px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.legacy-live-bottom > button > img {
  width: 36px;
  height: 36px;
  object-fit: contain;
}

.legacy-live-bottom__gift {
  width: 36px !important;
  height: 36px !important;
  background-color: var(--color-scrim-soft) !important;
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
}

.legacy-live-bottom__gift > img {
  width: 20px !important;
  height: 20px !important;
}

.legacy-live-bottom__game {
  border: 1px solid var(--color-on-dark-border-strong) !important;
  background: var(--color-scrim-soft) !important;
  color: var(--color-on-dark);
}

.legacy-live-host {
  display: flex;
  width: 176px;
  height: 39px;
  min-width: 128px;
  max-width: 176px;
  flex: 1 1 176px;
  align-items: center;
  justify-content: space-between;
  gap: 4px;
  padding: 4px;
  border: 0;
  border-radius: 26px;
  background: var(--color-scrim-soft);
  color: var(--color-on-dark);
  text-align: left;
}

.legacy-live-host > .legacy-live-host__copy {
  display: grid;
  min-width: 0;
  flex: 1;
  gap: 1px;
  overflow: hidden;
}

.legacy-live-host > .legacy-live-host__avatar {
  position: relative;
  display: grid;
  width: 30px;
  height: 30px;
  flex: 0 0 30px;
  place-items: center;
}

.legacy-live-host__frame {
  position: absolute;
  z-index: 1;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.legacy-live-host__copy > strong {
  display: block;
  overflow: hidden;
  max-width: 100%;
  font-size: 12px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.legacy-live-host__copy > small {
  display: flex;
  min-width: 0;
  align-items: center;
  gap: 3px;
  overflow: hidden;
  color: var(--color-on-dark);
  font-size: 10px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.legacy-live-host__copy > small img {
  width: 10px;
  height: 10px;
  flex: 0 0 10px;
  object-fit: contain;
}

.legacy-live-host > button {
  display: grid;
  width: 28px;
  height: 28px;
  flex: 0 0 28px;
  padding: 0;
  border: 0;
  border-radius: 50%;
  background: linear-gradient(100deg, var(--color-secondary), var(--color-primary));
  place-items: center;
}

.legacy-live-host > button.followed {
  border: 1px solid var(--color-on-dark-subtle);
  background: var(--color-on-dark-border-strong);
}

.legacy-live-host > button img {
  width: 20px;
  height: 20px;
  object-fit: contain;
}

.legacy-live-host > button.followed img {
  width: 17px;
  height: 17px;
}

.legacy-live-bottom > button:first-child {
  margin-right: auto;
}

.legacy-live-host + button {
  margin-left: 0;
}

.legacy-live-bottom > button[aria-label='Gifts'] {
  margin-right: 0;
  margin-left: 0;
}

.legacy-live-bottom > .legacy-live-bottom__input-gift {
  width: 36px;
  height: 36px;
  flex: 0 0 36px;
}

.legacy-live-bottom > .legacy-live-bottom__input-gift img {
  width: 24px;
  height: 24px;
}

.legacy-live-bottom__field {
  min-width: 0;
  flex: 1;
}

.legacy-live-bottom :deep(.van-cell) {
  --van-cell-horizontal-padding: 0;
  --van-cell-vertical-padding: 6px;

  min-width: 0;
  min-height: 34px;
  flex: 1 !important;
  margin: 0;
  padding: 0 2px 0 16px;
  overflow: hidden;
  border: 0;
  border-radius: 17px;
  background: var(--color-feedback-field);
}

.legacy-live-bottom :deep(.van-cell:focus-within) {
  box-shadow: inset 0 0 0 1px var(--color-on-dark-fill);
}

.legacy-live-bottom :deep(.van-field__button) {
  padding: 0;
  border: 0;
}

.legacy-live-bottom :deep(.van-field__button::before),
.legacy-live-bottom :deep(.van-field__button::after) {
  display: none;
  content: none;
}

.legacy-live-bottom :deep(.van-field__control) {
  max-height: 60px;
  color: var(--color-on-dark);
}

.legacy-live-bottom :deep(.van-field__control::placeholder) {
  color: var(--color-feedback-placeholder);
}

.legacy-live-bottom__send {
  display: grid;
  width: 42px;
  height: 34px;
  padding: 0;
  place-items: center;
  border: 0;
  background: transparent;
}

.legacy-live-bottom__send img {
  display: block;
  width: 38px;
  height: 28px;
  object-fit: contain;
}

.legacy-live-bottom__send:disabled {
  opacity: 0.38;
}

:deep(.legacy-effect-popup.app-popup-host) {
  border: 0;
  background: transparent !important;
  box-shadow: none;
}

.legacy-effect-popup :deep(.app-popup) {
  padding-right: 0;
  padding-left: 0;
  border-radius: 20px 20px 0 0;
  background: var(--panel-bg);
}

.legacy-effect-popup :deep(.app-popup__handle) {
  display: none;
}

.legacy-effect-popup h2 {
  margin: 0;
  padding: 20px 15px;
  font-size: 18px;
  line-height: 18px;
  text-align: center;
}

.legacy-effect-popup label {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 15px 18px;
  font-size: 15px;
  font-weight: 700;
}

.room-sheet-list {
  display: grid;
  gap: 4px;
}

.room-sheet-list > div {
  display: flex;
  min-height: 58px;
  align-items: center;
  gap: 10px;
  padding: 7px 4px;
  border-bottom: 1px solid var(--color-border);
}

.room-sheet-list strong {
  min-width: 0;
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.room-sheet-list span {
  padding: 3px 7px;
  border-radius: 999px;
  background: linear-gradient(100deg, var(--color-primary), var(--color-secondary));
  color: var(--color-on-primary);
  font-size: 9px;
  font-weight: 900;
}

.room-sheet-empty {
  min-height: 130px;
  margin: 0;
  color: var(--color-text-subtle);
  text-align: center;
  line-height: 130px;
}

.room-more-actions {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 12px;
}

.room-more-actions button {
  display: grid;
  min-height: 88px;
  justify-items: center;
  align-content: center;
  gap: 8px;
  border: 0;
  border-radius: 14px;
  background: var(--color-on-dark-fill);
  color: var(--color-on-dark);
  font-size: 12px;
  font-weight: 700;
}

.room-more-actions img {
  width: 32px;
  height: 32px;
  object-fit: contain;
}

.error-card {
  position: absolute;
  top: 50%;
  left: 50%;
  z-index: 8;
  width: min(82%, 320px);
  padding: 18px;
  border: 1px solid var(--color-on-dark-border);
  border-radius: 20px;
  background: color-mix(in srgb, var(--color-media-bg) 88%, transparent);
  text-align: center;
  transform: translate(-50%, -50%);
  backdrop-filter: blur(20px);

  p {
    margin: 0 0 13px;
    font-size: 13px;
  }

  > small {
    display: block;
    margin: -5px 0 13px;
    color: var(--color-on-dark-subtle);
    font-size: 9px;
    letter-spacing: 0.08em;
  }

  button {
    min-height: 42px;
    padding: 0 18px;
    border: 0;
    border-radius: 13px;
    background: var(--color-primary);
    color: var(--color-on-primary);
    font-weight: 750;
  }
}

.room-controls {
  position: absolute;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 7;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 22px;
  padding: 10px 18px calc(var(--room-bottom-inset) + 12px);
  background: linear-gradient(transparent, var(--color-scrim-strong) 38%);

  button {
    display: grid;
    justify-items: center;
    gap: 5px;
    padding: 0;
    border: 0;
    background: transparent;
    color: var(--color-on-dark);

    &:disabled {
      opacity: 0.52;
    }

    > span {
      width: 48px;
      height: 48px;
      display: grid;
      place-items: center;
      border-radius: 17px;
      background: var(--color-on-dark-border);
      font-size: 20px;
      backdrop-filter: blur(14px);
    }

    small {
      font-size: 9px;
    }

    &.is-off > span,
    &.leave-button > span {
      background: var(--color-primary);
    }
  }
}

.live-fallback-sound {
  position: absolute;
  z-index: 9;
  top: calc(var(--safe-top) + 82px);
  right: max(12px, var(--safe-right));
  display: flex;
  min-height: 34px;
  align-items: center;
  gap: 6px;
  padding: 0 11px;
  border: 1px solid rgb(255 255 255 / 18%);
  border-radius: 18px;
  background: rgb(0 0 0 / 46%);
  color: var(--color-on-dark);
  font-size: 11px;
  font-weight: 700;
  backdrop-filter: blur(10px);
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

@media (prefers-reduced-motion: reduce) {
  .gift-banner-enter-active,
  .gift-banner-leave-active,
  .room-gift-banner {
    transition-duration: 1ms;
  }

  .gift-banner-enter-from,
  .gift-banner-leave-to,
  .room-gift-banner.is-leaving {
    transform: none;
  }

  .room-entry-effect__person {
    animation: none;
  }

  .room-pk-placeholder i {
    animation: none;
  }
}
</style>

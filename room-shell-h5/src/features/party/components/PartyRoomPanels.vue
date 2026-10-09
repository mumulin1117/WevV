<script setup lang="ts">
import { computed, onBeforeUnmount, reactive, ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import { Swiper as SwiperView, SwiperSlide } from 'swiper/vue'
import 'swiper/css'
import { publicAsset } from '@/core/media/public-asset'
import type { GiftItem, InboxConversation } from '@/features/messages/contracts'
import type {
  PartyBackground,
  PartyBlacklistEntry,
  PartyEmojiItem,
  PartyMember,
  PartyMusicItem,
  PartyMusicSettings,
  PartyQueueEntry,
  PartyQueueState,
  PartyRankingPeriod,
  PartyRankingScope,
  PartyRoomRankKind,
  PartyRoomRankResult,
  PartyRoomSnapshot,
  PartyRoomTemplate,
  PartySeat,
} from '@/features/party/contracts'
import AppAvatar from '@/main/components/AppAvatar.vue'
import AppEmptyState from '@/main/components/AppEmptyState.vue'
import AppGenderAgeBadge from '@/main/components/AppGenderAgeBadge.vue'
import AppHeadFrame from '@/main/components/AppHeadFrame.vue'
import AppIcon from '@/main/components/AppIcon.vue'
import AppImage from '@/main/components/AppImage.vue'
import AppLoading from '@/main/components/AppLoading.vue'
import { useAppOverlay } from '@/main/ui/overlay'
import { usePartySheetPager } from '../composables/use-party-sheet-pager'
import PartySegmentedTabs from './PartySegmentedTabs.vue'
import PartySheet from './PartySheet.vue'
import PartyUserCardSheet from './PartyUserCardSheet.vue'
import { getProductCapabilities } from '@/core/product-mode/product-capabilities'

export type PartyPanel =
  | 'announcement'
  | 'audience'
  | 'background'
  | 'blacklist'
  | 'emoji'
  | 'invite'
  | 'leave'
  | 'manage'
  | 'more'
  | 'music'
  | 'mode'
  | 'rank'
  | 'queue'
  | 'seat-invite'
  | 'seat-roster'

const props = withDefaults(
  defineProps<{
    currentUserId: string
    currentLevel?: number
    currentBackground?: PartyBackground | null
    backgrounds?: readonly PartyBackground[]
    blacklist?: readonly PartyBlacklistEntry[]
    emojis?: readonly PartyEmojiItem[]
    gifts?: readonly GiftItem[]
    loadingPanel?: boolean
    inviteCandidates?: readonly PartyMember[]
    inviteCooldowns?: Readonly<Record<string, number>>
    inviteFollowers?: readonly PartyMember[]
    inviteLoadingTabs?: readonly boolean[]
    music?: readonly PartyMusicItem[]
    musicEnabled?: boolean
    musicPending?: boolean
    musicSettings?: PartyMusicSettings | null
    conversations?: readonly InboxConversation[]
    roomTemplates?: readonly PartyRoomTemplate[]
    panel: PartyPanel | null
    rankKind?: PartyRoomRankKind
    rankPeriod?: PartyRankingPeriod
    rankResult?: PartyRoomRankResult
    rankScope?: PartyRankingScope
    queue?: PartyQueueState
    selectedMember?: PartyMember | null
    selectedSeat?: PartySeat | null
    snapshot: PartyRoomSnapshot
    soundEnabled: boolean
    userCardOpen?: boolean
    viewers?: readonly PartyMember[]
  }>(),
  {
    backgrounds: () => [],
    blacklist: () => [],
    currentBackground: null,
    currentLevel: 0,
    emojis: () => [],
    gifts: () => [],
    loadingPanel: false,
    inviteCandidates: () => [],
    inviteCooldowns: () => ({}),
    inviteFollowers: () => [],
    inviteLoadingTabs: () => [],
    music: () => [],
    musicEnabled: false,
    musicPending: false,
    musicSettings: null,
    conversations: () => [],
    roomTemplates: () => [],
    rankKind: 'contribution',
    rankPeriod: 'day',
    rankResult: () => ({ durationSeconds: 0, entries: [], finished: true, myRank: null }),
    rankScope: 'CURRENT',
    queue: () => ({ entries: [], myIndex: 0, total: 0 }),
    selectedMember: null,
    selectedSeat: null,
    userCardOpen: false,
    viewers: () => [],
  },
)
const overlay = useAppOverlay()
const emit = defineEmits<{
  announcement: [value: string]
  background: [value: PartyBackground]
  'blacklist-remove': [member: PartyMember]
  emoji: [value: PartyEmojiItem]
  gift: [member: PartyMember]
  'quick-gift': [member: PartyMember, gift: GiftItem]
  leave: []
  invite: [members: PartyMember[]]
  'invite-tab': [index: number]
  'member-admin': [member: PartyMember, admin: boolean]
  'member-follow': [member: PartyMember, followed: boolean]
  'member-kick': [member: PartyMember, banType: 1 | 2]
  'member-seat': [seat: PartySeat, member: PartyMember]
  message: [member: PartyMember]
  'close-user-card': []
  profile: [member: PartyMember]
  music: [value: PartyMusicItem]
  'music-like': [value: PartyMusicItem]
  'music-upload': [files: File[]]
  'music-mode': [value: 1 | 2 | 3]
  'music-pause': []
  'music-volume': [value: number]
  moderate: [seat: PartySeat, action: 'kick' | 'lock' | 'mute' | 'unlock' | 'unmute']
  'open-panel': [panel: PartyPanel | null]
  'rank-kind': [kind: PartyRoomRankKind]
  'rank-more': []
  'rank-period': [period: PartyRankingPeriod]
  'rank-scope': [scope: PartyRankingScope]
  'queue-approve': [entry: PartyQueueEntry]
  'queue-cancel': []
  'queue-refuse': [entry: PartyQueueEntry]
  'seat-invite-member': [seat: PartySeat, member: PartyMember]
  report: []
  selectMember: [member: PartyMember]
  'seat-media': [seat: PartySeat, media: 'camera' | 'microphone', enabled: boolean]
  sound: []
  'toggle-apply': [enabled: boolean]
  'toggle-lock': [locked: boolean, password?: string]
  'toggle-music': [enabled: boolean]
  template: [value: PartyRoomTemplate]
}>()
const { t } = useI18n()
const renderedPanel = ref<PartyPanel | null>(props.panel)
// VanPopup 退场完成前保留当前内容，避免自然高度在动画中途突变造成真机顿挫。
const panel = computed(() => props.panel ?? renderedPanel.value)

const announcementDraft = ref('')
const canSaveAnnouncement = computed(
  () => announcementDraft.value.trim() !== props.snapshot.room.announcement,
)
const roomPassword = ref('')
const lockPrompt = ref(false)
const activeInviteTab = ref(0)
const activeRankPeriod = ref<PartyRankingPeriod>(props.rankPeriod)
const inviteSelections = ref<string[][]>([[], [], []])
const inviteNow = ref(Date.now())
const activeMusicType = ref<1 | 2 | 3>(1)
const showMusicVolume = ref(false)
const musicVolumeDraft = ref(100)
const musicVolumeEditing = ref(false)
const emojiSwipeIndex = ref(0)
const rankCountdown = ref(0)
let rankCountdownTimer = 0
let inviteCountdownTimer = 0
const panelNow = ref(Date.now())
const panelDataLoadedAt = ref(Date.now())
let panelCountdownTimer = 0
const backgroundDraftId = ref('')
const modeDraftType = ref<PartyRoomTemplate['roomType']>('voice')
const modeDraftSelections = reactive<Record<PartyRoomTemplate['roomType'], string>>({
  'live-voice': '',
  voice: '',
})
const modeDraftId = computed({
  get: () => modeDraftSelections[modeDraftType.value],
  set: (value: string) => {
    modeDraftSelections[modeDraftType.value] = value
  },
})
const ownsRoom = computed(() => props.snapshot.room.role === 'owner')
const canManage = computed(
  () => ownsRoom.value || props.snapshot.room.role === 'admin' || props.snapshot.room.platformAdmin,
)
const members = computed(() => {
  const values = [
    props.snapshot.room.owner,
    ...props.snapshot.room.seats.map((seat) => seat.member).filter(Boolean),
  ] as PartyMember[]
  return [...new Map(values.map((member) => [member.id, member])).values()]
})
const audience = computed(() =>
  props.viewers.length ? props.viewers : members.value.filter((member) => !member.owner),
)
const recentInviteCandidates = computed<PartyMember[]>(() => {
  const cutoff = Date.now() - 15 * 24 * 60 * 60 * 1_000
  return props.conversations
    .filter(
      (conversation) =>
        conversation.sortTime >= cutoff && conversation.userId && conversation.imAccount,
    )
    .map((conversation) => ({
      age: 0,
      avatarUrl: conversation.avatarUrl,
      countryName: '',
      displayName: conversation.displayName,
      followed: false,
      followerCount: 0,
      followingCount: 0,
      gender: 0,
      headFrameSmallUrl: '',
      headFrameUrl: '',
      id: conversation.userId,
      imAccount: conversation.imAccount,
      level: 0,
      medals: [],
      muted: false,
      onlineStatus: conversation.online ? 1 : 0,
      owner: false,
      platformAdmin: false,
      roomRole: 'member',
      vip: false,
    }))
})
const inviteGroups = computed(() => [
  recentInviteCandidates.value,
  props.inviteCandidates,
  props.inviteFollowers,
])
const activeInviteCandidates = computed(() => inviteGroups.value[activeInviteTab.value] ?? [])
const activeInviteSelection = computed(() => inviteSelections.value[activeInviteTab.value] ?? [])
const availableInviteSelection = computed(() =>
  activeInviteSelection.value.filter((memberId) => {
    const member = activeInviteCandidates.value.find((item) => item.id === memberId)
    return member ? inviteRemaining(member) === 0 : false
  }),
)
function hasGenderAge(member: PartyMember): boolean {
  return member.age > 0 && (member.gender === 1 || member.gender === 2)
}
function canModerateMember(target: PartyMember): boolean {
  if (!target || target.id === props.currentUserId || target.owner || target.platformAdmin)
    return false
  if (ownsRoom.value || props.snapshot.room.platformAdmin) return true
  return props.snapshot.room.role === 'admin' && target.roomRole === 'member'
}

function memberSeatFor(member: PartyMember): PartySeat | null {
  return props.snapshot.room.seats.find((seat) => seat.member?.id === member.id) ?? null
}

function memberAudioSeat(member: PartyMember): PartySeat | null {
  const seat = memberSeatFor(member)
  return seat?.type === 'audio' ? seat : null
}

function moderateMemberMicrophone(member: PartyMember): void {
  const seat = memberAudioSeat(member)
  if (seat) emit('moderate', seat, seat.member?.muted ? 'unmute' : 'mute')
}

function toggleMemberSeat(member: PartyMember): void {
  const seat = memberSeatFor(member)
  if (seat) emit('moderate', seat, 'kick')
  else emit('open-panel', 'seat-roster')
}

function memberHeadFrame(member: PartyMember): string {
  return member.headFrameSmallUrl || member.headFrameUrl
}

function rankAvatarFrame(member: PartyMember, rank: number): string {
  return rank > 0 && rank <= 3
    ? publicAsset(`party/room/party-rank${rank}.webp`)
    : memberHeadFrame(member)
}

function rankAvatarFrameSize(rank: number): number {
  return rank > 0 && rank <= 3 ? 60 : 55
}
function canSetMemberAdmin(target: PartyMember): boolean {
  return Boolean(
    ownsRoom.value &&
    target &&
    target.id !== props.currentUserId &&
    !target.owner &&
    !target.platformAdmin,
  )
}
const availableAudioSeats = computed(() =>
  props.snapshot.room.seats.filter(
    (seat) => seat.type === 'audio' && !seat.member && !seat.locked && seat.index > 0,
  ),
)
const rankPageCache = reactive<Record<string, PartyRoomRankResult>>({})
const emptyRankResult: PartyRoomRankResult = {
  durationSeconds: 0,
  entries: [],
  finished: true,
  myRank: null,
}
function rankCacheKey(period: PartyRankingPeriod): string {
  return `${props.rankKind}:${period}:${props.rankScope}`
}
function rankPageResult(period: PartyRankingPeriod): PartyRoomRankResult {
  return rankPageCache[rankCacheKey(period)] ?? emptyRankResult
}
function rankPagePending(period: PartyRankingPeriod): boolean {
  return props.loadingPanel && props.rankPeriod === period && !rankPageResult(period).entries.length
}

function handleRankScroll(event: Event, period: PartyRankingPeriod): void {
  if (period !== props.rankPeriod || props.loadingPanel || props.rankResult.finished) return
  const target = event.currentTarget
  if (!(target instanceof HTMLElement)) return
  if (target.scrollHeight - target.scrollTop - target.clientHeight <= 80) emit('rank-more')
}
watch(
  () =>
    [
      props.rankKind,
      props.rankPeriod,
      props.rankScope,
      props.loadingPanel,
      props.rankResult,
    ] as const,
  ([kind, period, scope, loading, result]) => {
    if (!loading) rankPageCache[`${kind}:${period}:${scope}`] = result
  },
  { immediate: true },
)
const musicTabs: ReadonlyArray<{ label: string; value: 1 | 2 | 3 }> = [
  { label: 'Playlist', value: 1 },
  { label: 'My Music', value: 3 },
  { label: 'Liked', value: 2 },
]
const capabilities = getProductCapabilities()
const modeTypes: readonly PartyRoomTemplate['roomType'][] = capabilities.partyLiveVoice
  ? ['voice', 'live-voice']
  : ['voice']
const inviteTabItems = [
  { key: 0, label: 'Recent Chat' },
  { key: 1, label: 'Follow' },
  { key: 2, label: 'Followers' },
] as const
const musicTabItems = musicTabs.map((item) => ({ key: item.value, label: item.label }))
const modeTabItems = computed(() =>
  modeTypes.map((roomType) => ({
    key: roomType,
    label: roomType === 'voice' ? t('party.voice') : t('party.liveVoice'),
  })),
)
const invitePager = usePartySheetPager({
  active: activeInviteTab,
  items: [0, 1, 2] as const,
  onChange: (index) => emit('invite-tab', index),
})
const musicPager = usePartySheetPager({
  active: activeMusicType,
  items: musicTabs.map((item) => item.value),
})
const modePager = usePartySheetPager({ active: modeDraftType, items: modeTypes })
const activeMusicIndex = computed(() =>
  Math.max(
    0,
    musicTabs.findIndex((item) => item.value === activeMusicType.value),
  ),
)
const activeModeIndex = computed(() => Math.max(0, modeTypes.indexOf(modeDraftType.value)))
const currentMusic = computed(() =>
  props.music.find((item) => item.id === props.musicSettings?.currentSongId),
)

function templateUnlocked(item: PartyRoomTemplate): boolean {
  return !capabilities.partyLevelGate || props.currentLevel >= item.createRoomLevel
}

function remainingDuration(duration: number): number {
  if (duration <= 0) return duration
  return Math.max(0, duration - Math.floor((panelNow.value - panelDataLoadedAt.value) / 1000))
}

function backgroundStatus(background: PartyBackground): string {
  const duration = remainingDuration(background.duration)
  if (duration < 0) return t('party.backgroundPermanent')
  if (duration === 0) return t('party.backgroundExpired')
  return formatRemainingDuration(duration)
}

function blacklistStatus(entry: PartyBlacklistEntry): string {
  if (entry.banType === 2) return t('party.blockedPermanently')
  const duration = remainingDuration(entry.duration)
  return duration > 0
    ? t('party.blockedTemporarily', { duration: formatRemainingDuration(duration) })
    : t('party.blockExpired')
}

function formatRemainingDuration(duration: number): string {
  const days = Math.floor(duration / 86_400)
  const hours = Math.floor((duration % 86_400) / 3600)
  const minutes = Math.floor((duration % 3600) / 60)
  const seconds = duration % 60
  if (days) return t('party.backgroundRemainingDays', { count: days })
  if (hours) return t('party.backgroundRemainingHours', { count: hours })
  if (minutes) return `${minutes}:${String(seconds).padStart(2, '0')}`
  return `0:${String(seconds).padStart(2, '0')}`
}
const emojiGroups = computed(() => {
  const groups = new Map<string, { cover: string; items: PartyEmojiItem[] }>()
  for (const item of props.emojis) {
    const key = item.category || 'Emoji'
    const current = groups.get(key) ?? { cover: item.categoryCover ?? '', items: [] }
    current.items.push(item)
    if (!current.cover && item.categoryCover) current.cover = item.categoryCover
    groups.set(key, current)
  }
  return [...groups].map(([name, value]) => ({ name, ...value }))
})
const emojiPages = computed(() =>
  emojiGroups.value.flatMap((group, tabIndex) => {
    const pages: Array<{ items: PartyEmojiItem[]; pageIndex: number; tabIndex: number }> = []
    for (let index = 0; index < group.items.length; index += 8)
      pages.push({ items: group.items.slice(index, index + 8), pageIndex: index / 8, tabIndex })
    return pages
  }),
)
const activeEmojiPage = computed(() => emojiPages.value[emojiSwipeIndex.value])
const activeEmojiTab = computed(() => activeEmojiPage.value?.tabIndex ?? 0)
const activeEmojiPageCount = computed(
  () => emojiPages.value.filter((page) => page.tabIndex === activeEmojiTab.value).length,
)
const emojiPageKeys = computed(() => emojiPages.value.map((_, index) => index))
const emojiPager = usePartySheetPager({ active: emojiSwipeIndex, items: emojiPageKeys })

function selectEmojiTab(tabIndex: number): void {
  const pageIndex = emojiPages.value.findIndex((page) => page.tabIndex === tabIndex)
  if (pageIndex < 0) return
  emojiPager.select(pageIndex)
}
const rankPeriods: ReadonlyArray<{ label: string; value: PartyRankingPeriod }> = [
  { label: 'Daily', value: 'day' },
  { label: 'Weekly', value: 'week' },
  { label: 'Monthly', value: 'month' },
]
const visibleRankPeriods = computed(() =>
  props.rankKind === 'honor' ? rankPeriods.filter((item) => item.value !== 'month') : rankPeriods,
)
const rankPager = usePartySheetPager({
  active: activeRankPeriod,
  items: computed(() => visibleRankPeriods.value.map((item) => item.value)),
  onChange: (period) => {
    if (period !== props.rankPeriod) emit('rank-period', period)
  },
})
const rankSwipeIndex = computed(() =>
  Math.max(
    0,
    visibleRankPeriods.value.findIndex((item) => item.value === activeRankPeriod.value),
  ),
)

function selectInviteTab(value: number | string): void {
  invitePager.select(Number(value))
}

function selectRankPeriod(period: PartyRankingPeriod): void {
  rankPager.select(period)
}

function selectMusicTab(value: number | string): void {
  const musicType = Number(value)
  if (musicType === 1 || musicType === 2 || musicType === 3) musicPager.select(musicType)
}

function selectModeType(value: number | string): void {
  if (value === 'voice' || value === 'live-voice') modePager.select(value)
}

const rankScopeLabel = computed(() => {
  if (activeRankPeriod.value === 'day') return props.rankScope === 'CURRENT' ? 'Today' : 'Yesterday'
  if (activeRankPeriod.value === 'week')
    return props.rankScope === 'CURRENT' ? 'This Week' : 'Last Week'
  return props.rankScope === 'CURRENT' ? 'This Month' : 'Last Month'
})

function rankDuration(seconds: number): string {
  const totalMinutes = Math.max(0, Math.floor(seconds / 60))
  const days = Math.floor(totalMinutes / 1440)
  const hours = Math.floor((totalMinutes % 1440) / 60)
  const minutes = totalMinutes % 60
  return `${String(days).padStart(2, '0')}D:${String(hours).padStart(2, '0')}H:${String(minutes).padStart(2, '0')}M`
}

function stopRankCountdown(): void {
  window.clearInterval(rankCountdownTimer)
  rankCountdownTimer = 0
}

function stopInviteCountdown(): void {
  window.clearInterval(inviteCountdownTimer)
  inviteCountdownTimer = 0
}

function stopPanelCountdown(): void {
  window.clearInterval(panelCountdownTimer)
  panelCountdownTimer = 0
}

function startPanelCountdown(): void {
  stopPanelCountdown()
  panelDataLoadedAt.value = Date.now()
  panelNow.value = panelDataLoadedAt.value
  panelCountdownTimer = window.setInterval(() => {
    panelNow.value = Date.now()
  }, 1_000)
}

function startInviteCountdown(): void {
  stopInviteCountdown()
  inviteNow.value = Date.now()
  inviteCountdownTimer = window.setInterval(() => {
    inviteNow.value = Date.now()
  }, 1_000)
}

function inviteRemaining(member: PartyMember): number {
  return Math.max(
    0,
    Math.ceil(((props.inviteCooldowns[member.imAccount] ?? 0) - inviteNow.value) / 1_000),
  )
}

function formatInviteRemaining(member: PartyMember): string {
  const remaining = inviteRemaining(member)
  const minutes = Math.floor(remaining / 60)
  const seconds = remaining % 60
  return `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`
}

function inviteSubtitle(member: PartyMember, tabIndex: number): string {
  if (tabIndex !== 0) return member.countryName || `ID: ${member.id}`
  const conversation = props.conversations.find((item) => item.userId === member.id)
  if (!conversation?.sortTime) return ''
  const date = new Date(conversation.sortTime)
  if (Number.isNaN(date.getTime())) return ''
  return `${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
}

function startRankCountdown(seconds: number): void {
  stopRankCountdown()
  rankCountdown.value = Math.max(0, Math.floor(seconds))
  if (!rankCountdown.value || props.panel !== 'rank') return
  rankCountdownTimer = window.setInterval(() => {
    rankCountdown.value = Math.max(0, rankCountdown.value - 1)
    if (!rankCountdown.value) stopRankCountdown()
  }, 1_000)
}

const sheetPanel = computed(() => props.panel !== null && props.panel !== 'leave')
const title = computed(() => {
  if (panel.value === 'announcement') return t('party.announcement')
  if (panel.value === 'audience') return 'Viewers'
  if (panel.value === 'background') return t('party.roomBackground')
  if (panel.value === 'blacklist') return 'Blocklist'
  if (panel.value === 'invite') return 'Invite'
  if (panel.value === 'manage') return 'Room Tools'
  if (panel.value === 'more') return 'More'
  if (panel.value === 'music') return t('party.music')
  if (panel.value === 'mode') return 'Room Mode'
  if (panel.value === 'rank') return ''
  if (panel.value === 'queue') return `Mic Application (${props.queue.total})`
  if (panel.value === 'seat-invite') return 'Invite to mic'
  if (panel.value === 'seat-roster') return 'Select a seat'
  return ''
})
const sheetSize = computed<'compact' | 'large' | 'standard'>(() => {
  if (['invite', 'background', 'mode', 'music'].includes(panel.value ?? '')) return 'large'
  if (
    [
      'announcement',
      'audience',
      'blacklist',
      'emoji',
      'queue',
      'rank',
      'seat-invite',
      'seat-roster',
    ].includes(panel.value ?? '')
  )
    return 'standard'
  return 'compact'
})

function initializeBackgroundDraft(): void {
  const active =
    props.currentBackground ??
    props.backgrounds.find((item) => item.imageUrl === props.snapshot.room.backgroundUrl)
  backgroundDraftId.value = active?.id ?? ''
}

function initializeModeDraft(): void {
  modeDraftType.value = props.snapshot.room.roomType
  modeDraftSelections.voice = ''
  modeDraftSelections['live-voice'] = ''
  modeDraftSelections[modeDraftType.value] = props.snapshot.room.transport?.roomTempId ?? ''
}

watch(
  () => props.panel,
  (activePanel) => {
    if (activePanel) renderedPanel.value = activePanel
    // Closing is animated. Defer all panel-local resets until `closed`, otherwise
    // invite/music/manage content visibly changes while the sheet is still moving.
    if (!activePanel) return
    // 与旧站一致，编辑草稿只在弹层打开时从已提交房间状态初始化。房间内的
    // 消息、人数、麦位和通信推送都会替换 snapshot，不能覆盖用户正在选择的值。
    if (activePanel === 'announcement') announcementDraft.value = props.snapshot.room.announcement
    if (activePanel === 'background') {
      initializeBackgroundDraft()
      startPanelCountdown()
    } else if (activePanel === 'blacklist') startPanelCountdown()
    else stopPanelCountdown()
    if (activePanel === 'mode') initializeModeDraft()
    if (activePanel !== 'manage') {
      lockPrompt.value = false
      roomPassword.value = ''
    }
    if (activePanel !== 'music') showMusicVolume.value = false
    if (activePanel !== 'invite') {
      stopInviteCountdown()
      activeInviteTab.value = 0
      inviteSelections.value = [[], [], []]
    } else startInviteCountdown()
  },
  { immediate: true },
)
watch(
  () => props.loadingPanel,
  (loading, wasLoading) => {
    // 背景当前值与可选列表按旧站在打开弹层后异步取得；Loading 期间无法编辑，
    // 因此只在本次加载完成的边界补一次初始化，之后不再跟随实时快照重置。
    if (wasLoading && !loading && props.panel === 'background') initializeBackgroundDraft()
  },
)
watch(
  () => [props.panel, props.backgrounds, props.blacklist] as const,
  ([activePanel]) => {
    if (activePanel === 'background' || activePanel === 'blacklist') startPanelCountdown()
  },
)

watch(
  () => props.musicSettings?.volume,
  (volume) => {
    if (volume !== undefined && !musicVolumeEditing.value) musicVolumeDraft.value = volume
  },
  { immediate: true },
)

watch(
  () => [props.panel, props.rankKind] as const,
  ([panel]) => {
    if (panel !== 'rank') return
    const nextPeriod = visibleRankPeriods.value.some((item) => item.value === props.rankPeriod)
      ? props.rankPeriod
      : 'day'
    activeRankPeriod.value = nextPeriod
  },
)

watch(
  () => [props.panel, props.rankResult.durationSeconds] as const,
  ([panel, duration]) => {
    if (panel === 'rank') startRankCountdown(duration)
    else stopRankCountdown()
  },
  { immediate: true },
)

onBeforeUnmount(() => {
  stopRankCountdown()
  stopInviteCountdown()
  stopPanelCountdown()
})

function close(): void {
  emit('open-panel', null)
}

function handleSheetClosed(): void {
  if (props.panel !== null) return
  lockPrompt.value = false
  roomPassword.value = ''
  showMusicVolume.value = false
  stopInviteCountdown()
  stopPanelCountdown()
  activeInviteTab.value = 0
  inviteSelections.value = [[], [], []]
  renderedPanel.value = null
}

function saveAnnouncement(): void {
  emit('announcement', announcementDraft.value)
}

function toggleInviteSelection(tabIndex: number, memberId: string, checked: boolean): void {
  const member = inviteGroups.value[tabIndex]?.find((item) => item.id === memberId)
  if (!member || inviteRemaining(member) > 0) return
  const next = new Set(inviteSelections.value[tabIndex] ?? [])
  if (checked) next.add(memberId)
  else next.delete(memberId)
  inviteSelections.value[tabIndex] = [...next]
}

function submitInvite(): void {
  const selected = new Set(availableInviteSelection.value)
  emit(
    'invite',
    activeInviteCandidates.value.filter((member) => selected.has(member.id)),
  )
}

function chooseEmoji(value: PartyEmojiItem): void {
  emit('emoji', value)
  close()
}

function cycleMusicMode(): void {
  const current = props.musicSettings?.playMode ?? 1
  emit('music-mode', current === 3 ? 1 : ((current + 1) as 2 | 3))
}

function commitMusicVolume(): void {
  musicVolumeEditing.value = false
  emit('music-volume', musicVolumeDraft.value)
}

function chooseMusicFiles(event: Event): void {
  const input = event.target as HTMLInputElement
  const files = [...(input.files ?? [])]
  input.value = ''
  if (files.length) emit('music-upload', files)
}

function formatDuration(seconds: number): string {
  const value = Math.max(0, Math.floor(seconds))
  const hours = Math.floor(value / 3600)
  const minutes = Math.floor((value % 3600) / 60)
  const rest = value % 60
  return hours
    ? `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(rest).padStart(2, '0')}`
    : `${String(minutes).padStart(2, '0')}:${String(rest).padStart(2, '0')}`
}

function musicModeIcon(): string {
  const mode = props.musicSettings?.playMode ?? 1
  return mode === 2
    ? 'party/music/icon_music_cycle.png'
    : mode === 3
      ? 'party/music/icon_music_random.png'
      : 'party/music/icon_music_sequence.png'
}

function confirmRoomLock(): void {
  if (!/^\d{4}$/u.test(roomPassword.value)) return
  emit('toggle-lock', true, roomPassword.value)
  lockPrompt.value = false
}

async function requestKick(member: PartyMember): Promise<void> {
  const duration = await overlay.actionSheet({
    actions: [
      { label: t('party.twoHours'), tone: 'primary', value: 'temporary' },
      { label: t('party.permanent'), tone: 'danger', value: 'permanent' },
    ],
    cancelLabel: t('common.cancel'),
  })
  if (duration === 'temporary') emit('member-kick', member, 1)
  if (duration === 'permanent') emit('member-kick', member, 2)
}

function handleMemberCardFollowChange(member: PartyMember, followed: boolean): void {
  emit('member-follow', member, followed)
}

function chooseBackground(background: PartyBackground): void {
  if (remainingDuration(background.duration) === 0) return
  backgroundDraftId.value = background.id
}

function confirmBackground(): void {
  const background = props.backgrounds.find((item) => item.id === backgroundDraftId.value)
  if (!background || remainingDuration(background.duration) === 0) return
  emit('background', background)
}

function chooseRoomTemplate(template: PartyRoomTemplate): void {
  if (!templateUnlocked(template)) return
  modeDraftId.value = template.id
}

function confirmRoomTemplate(): void {
  const template = props.roomTemplates.find((item) => item.id === modeDraftId.value)
  if (!template || !templateUnlocked(template)) return
  emit('template', template)
}

function requestBlacklistRemoval(entry: PartyBlacklistEntry): void {
  emit('blacklist-remove', entry.member)
}
</script>

<template>
  <PartySheet
    :bottom-inset-owner="panel === 'rank' || panel === 'audience' ? 'content' : 'layout'"
    :close-on-popstate="!userCardOpen"
    :flat="panel === 'emoji'"
    :overlay="true"
    :show="sheetPanel"
    :show-footer="
      (panel === 'announcement' && ownsRoom) ||
      panel === 'invite' ||
      panel === 'background' ||
      panel === 'mode' ||
      panel === 'music'
    "
    :height="panel === 'emoji' ? '50dvh' : ''"
    :max-height="panel === 'emoji' ? '50dvh' : ''"
    :size="sheetSize"
    :title="title"
    @closed="handleSheetClosed"
    @update:show="$event ? undefined : close()"
  >
    <div v-if="panel === 'audience'" class="party-panel__list party-viewers">
      <AppLoading v-if="loadingPanel" />
      <template v-else>
        <button
          v-for="(member, index) in audience"
          :key="member.id"
          type="button"
          @click="emit('selectMember', member)"
        >
          <span class="party-viewers__order">
            <img
              v-if="index < 3"
              :src="publicAsset(`party/room/party-room-order${index + 1}.webp`)"
              alt=""
            />
            <strong v-else>{{ index + 1 }}</strong>
          </span>
          <span class="party-viewers__avatar">
            <AppAvatar :size="44" :src="member.avatarUrl" />
            <AppHeadFrame
              class="party-viewers__frame"
              :lazy="false"
              :size="60"
              :src="
                index < 3
                  ? publicAsset(`party/room/party-rank${index + 1}.webp`)
                  : memberHeadFrame(member)
              "
            />
          </span>
          <span
            ><strong>{{ member.displayName }}</strong
            ><small>
              <AppGenderAgeBadge
                v-if="hasGenderAge(member)"
                :age="member.age"
                :gender="member.gender"
              />
              <span v-else-if="member.age" class="party-gender-age-fallback">
                {{ member.age }}
              </span>
              <AppImage
                v-for="medal in member.medals"
                :key="medal"
                :height="16"
                :lazy="false"
                :src="medal"
                :width="24"
              /> </small
          ></span>
        </button>
        <AppEmptyState v-if="!audience.length" class="party-panel__empty" size="popup" />
      </template>
    </div>

    <div v-else-if="panel === 'queue'" class="party-panel__list">
      <AppLoading v-if="loadingPanel" />
      <template v-else>
        <article v-if="queue.myIndex > 0 && !canManage" class="party-queue__mine">
          <span>You are No. {{ queue.myIndex }} in the queue</span>
          <button type="button" @click="emit('queue-cancel')">Cancel</button>
        </article>
        <div
          v-for="entry in queue.entries"
          :key="`${entry.member.id}-${entry.queueIndex}`"
          class="party-queue__row"
        >
          <AppAvatar :size="50" :src="entry.member.avatarUrl" />
          <span
            ><strong>{{ entry.member.displayName }}</strong
            ><small>Seat {{ entry.seatIndex + 1 }}</small></span
          >
          <template v-if="canManage">
            <button class="is-accept" type="button" @click="emit('queue-approve', entry)">
              Accept
            </button>
            <button type="button" @click="emit('queue-refuse', entry)">Refuse</button>
          </template>
        </div>
        <AppEmptyState v-if="!queue.entries.length" class="party-panel__empty" size="popup" />
      </template>
    </div>

    <div v-else-if="panel === 'seat-invite'" class="party-panel__list">
      <AppLoading v-if="loadingPanel" />
      <template v-else>
        <button
          v-for="member in audience.filter(
            (item) => !snapshot.room.seats.some((seat) => seat.member?.id === item.id),
          )"
          :key="member.id"
          type="button"
          @click="selectedSeat && emit('seat-invite-member', selectedSeat, member)"
        >
          <AppAvatar :size="44" :src="member.avatarUrl" />
          <span>
            <strong>{{ member.displayName }}</strong>
            <small>Invite to seat {{ (selectedSeat?.index ?? 0) + 1 }}</small>
          </span>
          <AppIcon name="chevron" :size="16" />
        </button>
        <AppEmptyState
          v-if="
            !audience.filter(
              (item) => !snapshot.room.seats.some((seat) => seat.member?.id === item.id),
            ).length
          "
          class="party-panel__empty"
          size="popup"
        />
      </template>
    </div>

    <div v-else-if="panel === 'seat-roster'" class="party-seat-roster">
      <button
        v-for="seatItem in availableAudioSeats"
        :key="seatItem.index"
        type="button"
        @click="selectedMember && emit('member-seat', seatItem, selectedMember)"
      >
        <span>
          <img :src="publicAsset('party/room/icon_mic_1_1.png')" alt="" />
        </span>
        Seat {{ seatItem.index + 1 }}
      </button>
      <AppEmptyState v-if="!availableAudioSeats.length" class="party-panel__empty" size="popup" />
    </div>

    <div v-else-if="panel === 'invite'" class="party-invite">
      <AppLoading v-if="loadingPanel" />
      <template v-else>
        <PartySegmentedTabs
          :items="inviteTabItems"
          label="Invite lists"
          :model-value="activeInviteTab"
          @update:model-value="selectInviteTab"
        />
        <SwiperView
          class="party-invite__swipe"
          :grab-cursor="true"
          :initial-slide="activeInviteTab"
          :loop="false"
          :threshold="6"
          @slide-change="invitePager.handleSlideChange"
          @swiper="invitePager.setSwiper"
        >
          <SwiperSlide v-for="(group, tabIndex) in inviteGroups" :key="tabIndex">
            <div class="party-invite__page">
              <AppLoading v-if="inviteLoadingTabs[tabIndex]" />
              <div v-else class="party-panel__list party-invite__list">
                <label v-for="member in group" :key="member.id">
                  <span class="party-invite__avatar">
                    <AppAvatar :size="44" :src="member.avatarUrl" />
                    <AppHeadFrame
                      v-if="memberHeadFrame(member)"
                      class="party-invite__frame"
                      :lazy="false"
                      :size="54"
                      :src="memberHeadFrame(member)"
                    />
                  </span>
                  <span
                    ><strong>{{ member.displayName }}</strong
                    ><small>{{ inviteSubtitle(member, tabIndex) }}</small></span
                  >
                  <input
                    v-if="inviteRemaining(member) === 0"
                    :checked="inviteSelections[tabIndex]?.includes(member.id)"
                    type="checkbox"
                    :value="member.id"
                    @change="
                      toggleInviteSelection(
                        tabIndex,
                        member.id,
                        ($event.target as HTMLInputElement).checked,
                      )
                    "
                  />
                  <time v-else class="party-invite__cooldown">{{
                    formatInviteRemaining(member)
                  }}</time>
                </label>
                <AppEmptyState v-if="!group.length" class="party-panel__empty" size="popup" />
              </div>
            </div>
          </SwiperSlide>
        </SwiperView>
      </template>
    </div>

    <div v-else-if="panel === 'blacklist'" class="party-panel__list party-blacklist">
      <AppLoading v-if="loadingPanel" />
      <template v-else>
        <div v-for="entry in blacklist" :key="entry.member.id" class="party-queue__row">
          <AppAvatar :size="46" :src="entry.member.avatarUrl" />
          <span
            ><strong>{{ entry.member.displayName }}</strong
            ><small>{{ blacklistStatus(entry) }}</small></span
          >
          <button type="button" @click="requestBlacklistRemoval(entry)">Remove</button>
        </div>
        <AppEmptyState v-if="!blacklist.length" class="party-panel__empty" size="popup" />
      </template>
    </div>

    <div v-else-if="panel === 'background'" class="party-backgrounds">
      <AppLoading v-if="loadingPanel" />
      <template v-else>
        <button
          v-for="item in backgrounds"
          :key="item.id"
          :class="{
            'is-active': item.id === backgroundDraftId,
            'is-expired': remainingDuration(item.duration) === 0,
          }"
          :disabled="remainingDuration(item.duration) === 0"
          type="button"
          @click="chooseBackground(item)"
        >
          <AppImage :alt="item.name" :lazy="false" :src="item.thumbnailUrl" />
          <span>{{ item.name }}</span>
          <small>{{ backgroundStatus(item) }}</small>
        </button>
      </template>
    </div>

    <div v-else-if="panel === 'mode'" class="party-mode">
      <PartySegmentedTabs
        v-if="modeTypes.length > 1"
        :items="modeTabItems"
        label="Room modes"
        :model-value="modeDraftType"
        @update:model-value="selectModeType"
      />
      <AppLoading v-if="loadingPanel" />
      <SwiperView
        v-else
        class="party-mode__swipe"
        :grab-cursor="true"
        :initial-slide="activeModeIndex"
        :loop="false"
        :threshold="6"
        @slide-change="modePager.handleSlideChange"
        @swiper="modePager.setSwiper"
      >
        <SwiperSlide v-for="roomType in modeTypes" :key="roomType">
          <div class="party-backgrounds party-modes">
            <button
              v-for="item in roomTemplates.filter((template) => template.roomType === roomType)"
              :key="item.id"
              :class="{
                'is-active': item.id === modeDraftSelections[roomType],
                'is-locked': !templateUnlocked(item),
              }"
              :disabled="!templateUnlocked(item)"
              type="button"
              @click="chooseRoomTemplate(item)"
            >
              <AppImage :alt="item.roomType" :lazy="false" :src="item.imageUrl" />
              <span v-if="capabilities.partyLevelGate">Lv.{{ item.createRoomLevel }}</span>
              <small v-if="capabilities.partyLevelGate">{{
                templateUnlocked(item) ? t('party.unlockedMode') : t('party.lockedMode')
              }}</small>
            </button>
          </div>
        </SwiperSlide>
      </SwiperView>
    </div>

    <div v-else-if="panel === 'rank'" class="party-rank">
      <nav class="party-rank__kinds">
        <button
          v-for="item in [
            { label: 'Contribution', value: 'contribution' },
            { label: 'Honor', value: 'honor' },
          ] as const"
          :key="item.value"
          :class="{ 'is-active': rankKind === item.value }"
          type="button"
          @click="emit('rank-kind', item.value)"
        >
          {{ item.label }}
        </button>
      </nav>
      <nav
        class="party-rank__periods"
        :style="{ gridTemplateColumns: `repeat(${visibleRankPeriods.length}, minmax(0, 1fr))` }"
      >
        <button
          v-for="item in visibleRankPeriods"
          :key="item.value"
          :aria-pressed="activeRankPeriod === item.value"
          :class="{ 'is-active': activeRankPeriod === item.value }"
          type="button"
          @click="selectRankPeriod(item.value)"
        >
          {{ item.label }}
        </button>
      </nav>
      <div class="party-rank__meta">
        <span v-if="rankCountdown" class="party-rank__duration">
          <img :src="publicAsset('party/room/icon_time.webp')" alt="" />
          {{ rankDuration(rankCountdown) }}
        </span>
        <span v-else />
        <button
          type="button"
          @click="emit('rank-scope', rankScope === 'CURRENT' ? 'LAST' : 'CURRENT')"
        >
          {{ rankScopeLabel }}
          <img :src="publicAsset('party/room/icon-rank-switch.webp')" alt="" />
        </button>
      </div>
      <div class="party-rank__swipe-frame">
        <SwiperView
          :key="`rank-${rankKind}`"
          class="party-rank__swiper"
          :grab-cursor="true"
          :initial-slide="rankSwipeIndex"
          :loop="false"
          @slide-change="rankPager.handleSlideChange"
          @swiper="rankPager.setSwiper"
        >
          <SwiperSlide v-for="period in visibleRankPeriods" :key="period.value">
            <div class="party-rank__page" @scroll.passive="handleRankScroll($event, period.value)">
              <div v-if="rankPagePending(period.value)" class="party-rank__state">
                <AppLoading />
              </div>
              <template v-else-if="rankPageResult(period.value).entries.length">
                <button
                  v-for="(item, index) in rankPageResult(period.value).entries"
                  :key="item.member.id"
                  type="button"
                  @click="emit('selectMember', item.member)"
                >
                  <img
                    v-if="index < 3"
                    :src="publicAsset(`party/room/party-room-order${index + 1}.webp`)"
                    alt=""
                  />
                  <strong v-else>{{ index + 1 }}</strong>
                  <span class="party-rank__avatar">
                    <AppAvatar :size="44" :src="item.member.avatarUrl" />
                    <AppHeadFrame
                      class="party-rank__frame"
                      :lazy="false"
                      :size="rankAvatarFrameSize(item.rank)"
                      :src="rankAvatarFrame(item.member, item.rank)"
                    />
                  </span>
                  <span
                    ><b>{{ item.member.displayName }}</b
                    ><small>
                      <AppGenderAgeBadge
                        v-if="hasGenderAge(item.member)"
                        :age="item.member.age"
                        :gender="item.member.gender"
                      />
                      <span v-else-if="item.member.age" class="party-gender-age-fallback">
                        {{ item.member.age }}
                      </span>
                      <AppImage
                        v-for="medal in item.member.medals"
                        :key="medal"
                        class="party-rank__medal"
                        :height="14"
                        :lazy="false"
                        :src="medal"
                        :width="24"
                      /> </small
                  ></span>
                  <em
                    ><img
                      :src="
                        publicAsset(
                          rankKind === 'honor' ? 'party/room/icon_gem.webp' : 'common/diamond.png',
                        )
                      "
                      alt=""
                    />{{ item.score.toLocaleString() }}</em
                  >
                </button>
              </template>
              <AppEmptyState v-else class="party-rank__empty" size="popup" />
            </div>
          </SwiperSlide>
        </SwiperView>
      </div>
      <button
        v-if="rankResult.myRank"
        class="party-rank__mine"
        type="button"
        @click="emit('selectMember', rankResult.myRank.member)"
      >
        <span class="party-rank__mine-order">
          <img
            v-if="rankResult.myRank.rank > 0 && rankResult.myRank.rank <= 3"
            :src="publicAsset(`party/room/party-room-order${rankResult.myRank.rank}.webp`)"
            alt=""
          />
          <strong v-else>{{ rankResult.myRank.rank || '-' }}</strong>
        </span>
        <span class="party-rank__avatar">
          <AppAvatar :size="44" :src="rankResult.myRank.member.avatarUrl" />
          <AppHeadFrame
            class="party-rank__frame"
            :lazy="false"
            :size="rankAvatarFrameSize(rankResult.myRank.rank)"
            :src="rankAvatarFrame(rankResult.myRank.member, rankResult.myRank.rank)"
          />
        </span>
        <span
          ><b>{{ rankResult.myRank.member.displayName }}</b
          ><small>
            <AppGenderAgeBadge
              v-if="hasGenderAge(rankResult.myRank.member)"
              :age="rankResult.myRank.member.age"
              :gender="rankResult.myRank.member.gender"
            />
            <span v-else-if="rankResult.myRank.member.age" class="party-gender-age-fallback">
              {{ rankResult.myRank.member.age }}
            </span>
            <AppImage
              v-for="medal in rankResult.myRank.member.medals"
              :key="medal"
              class="party-rank__medal"
              :height="14"
              :lazy="false"
              :src="medal"
              :width="24"
            /> </small
        ></span>
        <em>
          <img
            :src="
              publicAsset(rankKind === 'honor' ? 'party/room/icon_gem.webp' : 'common/diamond.png')
            "
            alt=""
          />
          {{ rankResult.myRank.score.toLocaleString() }}
        </em>
      </button>
    </div>

    <div v-else-if="panel === 'announcement'" class="party-announcement">
      <template v-if="ownsRoom">
        <textarea
          v-model="announcementDraft"
          maxlength="240"
          :placeholder="t('party.announcementPlaceholder')"
          rows="6"
        />
      </template>
      <p v-else>{{ snapshot.room.announcement || t('party.announcementEmpty') }}</p>
    </div>

    <div v-else-if="panel === 'more'" class="party-tools party-tools--room-more">
      <button type="button" @click="emit('sound')">
        <span
          ><img
            :src="
              publicAsset(`party/room/${soundEnabled ? 'icon_sound.png' : 'icon_close_sound.png'}`)
            "
            alt=""
        /></span>
        Room Mute
      </button>
      <button type="button" @click="emit('leave')">
        <span><img :src="publicAsset('party/room/icon_quit.png')" alt="" /></span>
        {{ t('party.leave') }}
      </button>
    </div>

    <div v-else-if="panel === 'manage'" class="party-manage party-tools">
      <button
        type="button"
        @click="snapshot.room.locked ? emit('toggle-lock', false) : (lockPrompt = true)"
      >
        <span
          ><img
            :src="
              publicAsset(
                `party/room/${snapshot.room.locked ? 'icon_manage_lock.png' : 'icon_manage_unlock.png'}`,
              )
            "
            alt=""
          /><i :class="{ 'is-on': snapshot.room.locked }">{{
            snapshot.room.locked ? 'ON' : 'OFF'
          }}</i></span
        >Lock Room
      </button>
      <button
        v-if="snapshot.room.musicAvailable"
        type="button"
        @click="emit('toggle-music', !musicEnabled)"
      >
        <span
          ><img
            :src="
              publicAsset(
                `party/room/${musicEnabled ? 'icon-manage-music-open.png' : 'icon-manage-music.png'}`,
              )
            "
            alt=""
          /><i :class="{ 'is-on': musicEnabled }">{{ musicEnabled ? 'ON' : 'OFF' }}</i></span
        >Music
      </button>
      <button v-if="ownsRoom" type="button" @click="emit('open-panel', 'background')">
        <span><img :src="publicAsset('party/room/icon_manage_setting.png')" alt="" /></span
        >Background
      </button>
      <button type="button" @click="emit('toggle-apply', !snapshot.room.onSeatApplyEnabled)">
        <span
          ><img
            :src="
              publicAsset(
                `party/room/${snapshot.room.onSeatApplyEnabled ? 'icon_manage_application.png' : 'icon_manage_unapplication.png'}`,
              )
            "
            alt=""
          /><i :class="{ 'is-on': snapshot.room.onSeatApplyEnabled }">{{
            snapshot.room.onSeatApplyEnabled ? 'ON' : 'OFF'
          }}</i></span
        >
        Mic Application
      </button>
      <button v-if="ownsRoom" type="button" @click="emit('open-panel', 'mode')">
        <span><img :src="publicAsset('party/room/icon_manage_mode.png')" alt="" /></span>Room Mode
      </button>
      <button type="button" @click="emit('open-panel', 'blacklist')">
        <span><img :src="publicAsset('party/room/icon_manage_blocklist.webp')" alt="" /></span
        >Blocklist
      </button>
    </div>

    <div v-else-if="panel === 'music'" class="party-music">
      <PartySegmentedTabs
        :items="musicTabItems"
        label="Music categories"
        :model-value="activeMusicType"
        @update:model-value="selectMusicTab"
      />
      <AppLoading v-if="loadingPanel" />
      <SwiperView
        v-else
        class="party-music__swipe"
        :grab-cursor="true"
        :initial-slide="activeMusicIndex"
        :loop="false"
        :threshold="6"
        @slide-change="musicPager.handleSlideChange"
        @swiper="musicPager.setSwiper"
      >
        <SwiperSlide v-for="tab in musicTabs" :key="tab.value">
          <div class="party-music__page">
            <div v-if="tab.value === 3" class="party-music__local-actions">
              <span>My uploaded music</span>
              <label>
                Upload
                <input accept="audio/*" multiple type="file" @change="chooseMusicFiles" />
              </label>
            </div>
            <div class="party-music__list">
              <div
                v-for="(item, index) in music.filter((entry) => entry.type === tab.value)"
                :key="`${item.type}:${item.id}`"
                class="party-music__row"
              >
                <button
                  :disabled="musicPending"
                  type="button"
                  @click="
                    musicSettings?.currentSongId === item.id && musicSettings.playing
                      ? emit('music-pause')
                      : emit('music', item)
                  "
                >
                  <b>{{ index + 1 }}</b>
                  <span
                    :class="{
                      'is-current': musicSettings?.currentSongId === item.id,
                    }"
                    >{{ item.name }}</span
                  >
                  <small>{{ formatDuration(item.durationSeconds) }}</small>
                </button>
                <button
                  :disabled="musicPending"
                  type="button"
                  :aria-label="item.liked ? 'Unlike' : 'Like'"
                  @click="emit('music-like', item)"
                >
                  <img
                    :src="
                      publicAsset(
                        `party/music/${item.liked ? 'icon_music_like.png' : 'icon_music_disLike.png'}`,
                      )
                    "
                    alt=""
                  />
                </button>
              </div>
              <AppEmptyState
                v-if="!music.some((entry) => entry.type === tab.value)"
                class="party-panel__empty"
                size="popup"
              />
            </div>
          </div>
        </SwiperSlide>
      </SwiperView>
    </div>

    <div v-else-if="panel === 'emoji'" class="party-emojis">
      <AppLoading v-if="loadingPanel" />
      <template v-else-if="emojis.length">
        <SwiperView
          class="party-emojis__swipe"
          :grab-cursor="true"
          :initial-slide="emojiSwipeIndex"
          :loop="false"
          :threshold="6"
          @slide-change="emojiPager.handleSlideChange"
          @swiper="emojiPager.setSwiper"
        >
          <SwiperSlide v-for="(page, pageIndex) in emojiPages" :key="pageIndex">
            <div class="party-emojis__page">
              <button
                v-for="item in page.items"
                :key="item.id"
                type="button"
                @click="chooseEmoji(item)"
              >
                <AppImage
                  class="party-emojis__image"
                  :height="56"
                  :lazy="false"
                  fit="contain"
                  :src="item.imageUrl"
                  :width="56"
                  alt=""
                />
              </button>
            </div>
          </SwiperSlide>
        </SwiperView>
        <div v-if="activeEmojiPageCount > 1" class="party-emojis__dots">
          <span
            v-for="index in activeEmojiPageCount"
            :key="index"
            :class="{ 'is-active': activeEmojiPage?.pageIndex === index - 1 }"
          />
        </div>
        <nav class="party-emojis__tabs">
          <button
            v-for="(group, index) in emojiGroups"
            :key="group.name"
            :class="{ 'is-active': activeEmojiTab === index }"
            type="button"
            @click="selectEmojiTab(index)"
          >
            <AppImage v-if="group.cover" :lazy="false" :src="group.cover" />
            <span v-else>{{ group.name }}</span>
          </button>
        </nav>
      </template>
      <template v-else>
        <AppEmptyState class="party-panel__empty" size="popup" />
      </template>
    </div>

    <template #footer>
      <button
        v-if="panel === 'announcement' && ownsRoom"
        class="party-sheet-primary"
        :disabled="!canSaveAnnouncement"
        type="button"
        @click="saveAnnouncement"
      >
        {{ t('party.edit') }}
      </button>
      <button
        v-else-if="panel === 'invite'"
        class="party-sheet-primary"
        :disabled="!availableInviteSelection.length"
        type="button"
        @click="submitInvite"
      >
        Invite
      </button>
      <button
        v-else-if="panel === 'background' || panel === 'mode'"
        class="party-panel__confirm party-sheet-primary"
        :disabled="loadingPanel || (panel === 'background' ? !backgroundDraftId : !modeDraftId)"
        type="button"
        @click="panel === 'background' ? confirmBackground() : confirmRoomTemplate()"
      >
        {{ t('party.confirm') }}
      </button>
      <section v-else-if="panel === 'music'" class="party-music__footer">
        <div v-if="showMusicVolume" class="party-music__volume-control">
          <img
            :src="
              publicAsset(
                `party/music/${musicVolumeDraft > 0 ? 'icon_music_sound.png' : 'icon_music_no_sound.png'}`,
              )
            "
            alt=""
          />
          <input
            v-model.number="musicVolumeDraft"
            aria-label="Music volume"
            :disabled="musicPending"
            max="200"
            min="0"
            step="1"
            type="range"
            @change="commitMusicVolume"
            @input="musicVolumeEditing = true"
          />
          <span>{{ Math.round(musicVolumeDraft / 2) }}%</span>
        </div>
        <div class="party-music__now">
          <img
            :class="{ 'is-playing': musicSettings?.playing }"
            :src="publicAsset('party/room/icon_music_new.webp')"
            alt=""
          />
          <strong>{{ musicSettings?.songName || currentMusic?.name || t('party.music') }}</strong>
          <button
            :disabled="musicPending"
            type="button"
            :aria-expanded="showMusicVolume"
            aria-label="Volume"
            @click="showMusicVolume = !showMusicVolume"
          >
            <img
              :src="
                publicAsset(
                  `party/music/${musicVolumeDraft > 0 ? 'icon_music_sound.png' : 'icon_music_no_sound.png'}`,
                )
              "
              alt=""
            />
          </button>
          <button
            :disabled="musicPending"
            type="button"
            :aria-label="musicSettings?.playing ? 'Pause' : 'Play'"
            @click="
              musicSettings?.playing
                ? emit('music-pause')
                : currentMusic && emit('music', currentMusic)
            "
          >
            <img
              :src="
                publicAsset(
                  `party/music/${musicSettings?.playing ? 'icon_music_pause.png' : 'icon_music_play.png'}`,
                )
              "
              alt=""
            />
          </button>
          <button
            :disabled="musicPending"
            type="button"
            aria-label="Playback mode"
            @click="cycleMusicMode"
          >
            <img :src="publicAsset(musicModeIcon())" alt="" />
          </button>
        </div>
      </section>
    </template>
  </PartySheet>

  <PartyUserCardSheet
    v-if="selectedMember"
    :model-value="userCardOpen"
    :room-id="snapshot.room.id"
    :target="selectedMember"
    @detail="emit('profile', $event)"
    @follow-change="handleMemberCardFollowChange"
    @message="emit('message', $event)"
    @update:model-value="$event ? undefined : emit('close-user-card')"
  >
    <template #extra="{ member: cardMember }">
      <section
        v-if="cardMember.id !== currentUserId && gifts.length"
        class="party-user-card__quick-gifts"
      >
        <header>
          <strong>Send gift</strong>
          <button type="button" aria-label="More gifts" @click="emit('gift', cardMember)">
            <img :src="publicAsset('party/room/icon-quick-gift-entry.webp')" alt="" />
            <AppIcon name="chevron" :size="12" />
          </button>
        </header>
        <div>
          <button
            v-for="giftItem in gifts.slice(0, 4)"
            :key="`${giftItem.source}:${giftItem.id}`"
            type="button"
            @click="emit('quick-gift', cardMember, giftItem)"
          >
            <AppImage :alt="giftItem.name" :lazy="false" :src="giftItem.iconUrl" />
            <i v-if="giftItem.source === 'backpack'">Free</i>
            <small>
              <img
                :src="
                  publicAsset(
                    giftItem.source === 'backpack'
                      ? 'party/room/icon-backpack-small.webp'
                      : 'party/room/icon_gem.webp',
                  )
                "
                alt=""
              />
              {{ giftItem.source === 'backpack' ? `×${giftItem.quantity ?? 0}` : giftItem.price }}
            </small>
          </button>
        </div>
      </section>
    </template>
    <template #management="{ member: cardMember }">
      <div v-if="canModerateMember(cardMember)" class="party-user-card__moderation">
        <button
          v-if="memberAudioSeat(cardMember)"
          type="button"
          @click="moderateMemberMicrophone(cardMember)"
        >
          <img
            :src="
              publicAsset(
                `party/room/${memberAudioSeat(cardMember)?.member?.muted ? 'icon_tool_source.png' : 'icon_tool_no_source.png'}`,
              )
            "
            alt=""
          />
          <span>{{ memberAudioSeat(cardMember)?.member?.muted ? 'Unmute' : 'Mute' }}</span>
        </button>
        <button type="button" @click="toggleMemberSeat(cardMember)">
          <img
            :src="
              publicAsset(
                `party/room/${memberSeatFor(cardMember) ? 'icon_leave.png' : 'icon_tool_invite.webp'}`,
              )
            "
            alt=""
          />
          <span>{{ memberSeatFor(cardMember) ? 'Leave' : 'Take' }}</span>
        </button>
        <button
          v-if="canSetMemberAdmin(cardMember)"
          type="button"
          @click="emit('member-admin', cardMember, cardMember.roomRole !== 'admin')"
        >
          <img
            :src="
              publicAsset(
                `party/room/${cardMember.roomRole === 'admin' ? 'card_icon_admin_remove.webp' : 'card_icon_admin_set.webp'}`,
              )
            "
            alt=""
          />
          <span>{{ cardMember.roomRole === 'admin' ? 'Remove Admin' : 'Set Admin' }}</span>
        </button>
        <button
          v-if="cardMember.roomRole === 'member'"
          type="button"
          @click="requestKick(cardMember)"
        >
          <img :src="publicAsset('party/room/card_icon_kickout.webp')" alt="" />
          <span>Kick</span>
        </button>
      </div>
    </template>
  </PartyUserCardSheet>

  <PartySheet
    :show="lockPrompt"
    show-footer
    size="compact"
    title="Lock Room"
    @update:show="lockPrompt = $event"
  >
    <section class="party-lock">
      <p>Set a 4-digit password</p>
      <input
        v-model="roomPassword"
        aria-label="4-digit room password"
        autocomplete="off"
        inputmode="numeric"
        maxlength="4"
        placeholder="••••"
      />
    </section>
    <template #footer>
      <button
        class="party-sheet-primary"
        :disabled="!/^\d{4}$/u.test(roomPassword)"
        type="button"
        @click="confirmRoomLock"
      >
        Confirm
      </button>
      <button class="party-sheet-secondary" type="button" @click="lockPrompt = false">
        Cancel
      </button>
    </template>
  </PartySheet>
</template>

<style scoped lang="less">
.party-panel__list {
  display: flex;
  height: 100%;
  min-height: 0;
  flex-direction: column;
  overflow: hidden auto;
  overscroll-behavior: contain;
  padding: 8px 16px 0;
}

.party-rank {
  display: flex;
  height: 100%;
  min-height: 0;
  box-sizing: border-box;
  flex-direction: column;
  overflow: hidden;
  padding: 12px 12px 0;
}

.party-panel__list > button {
  display: grid;
  width: 100%;
  min-height: 64px;
  grid-template-columns: 44px minmax(0, 1fr) auto;
  align-items: center;
  gap: 10px;
  padding: 8px 0;
  border: 0;
  background: transparent;
  color: var(--color-on-dark);
  text-align: start;
}

.party-viewers {
  overflow: hidden auto;
  overscroll-behavior-y: contain;
  touch-action: pan-y;
  -webkit-overflow-scrolling: touch;
}

.party-viewers > button {
  min-height: 64px;
  grid-template-columns: 28px 60px minmax(0, 1fr);
  gap: 8px;
  padding: 2px 6px;
}

.party-viewers__order {
  display: grid !important;
  width: 28px;
  place-items: center;
}

.party-viewers__order img {
  width: 20px;
  height: 20px;
  object-fit: contain;
}

.party-viewers__avatar {
  position: relative;
  display: grid !important;
  width: 60px;
  height: 60px;
  place-items: center;
}

.party-viewers__frame {
  position: absolute;
  z-index: 1;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.party-viewers > button > span:last-child {
  overflow: hidden;
}

.party-viewers > button > span:last-child > strong {
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.party-viewers > button > span:last-child small {
  display: flex;
  height: 18px;
  align-items: center;
  gap: 4px;
}

.party-gender-age-fallback {
  color: var(--color-on-dark-muted);
}

.party-panel__list span {
  display: grid;
  min-width: 0;
  gap: 3px;
}

.party-panel__list small,
.party-rank small {
  color: var(--color-on-dark-muted);
  font-size: 11px;
}

.party-queue__mine,
.party-queue__row,
.party-invite__list > label {
  display: grid;
  min-height: 64px;
  grid-template-columns: auto minmax(0, 1fr) auto auto;
  align-items: center;
  gap: 10px;
  border-bottom: 1px solid var(--color-on-dark-fill);
}

.party-queue__mine {
  grid-template-columns: minmax(0, 1fr) auto;
  padding: 10px 0;
}

.party-queue__row > span,
.party-invite__list > label > span {
  display: grid;
  min-width: 0;
  overflow: hidden;
  gap: 3px;
}

.party-invite__list > label > span > strong {
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.party-invite__avatar {
  position: relative;
  display: grid !important;
  width: 54px;
  height: 54px;
  place-items: center;
}

.party-invite__frame {
  position: absolute;
  z-index: 1;
  inset: 0;
}

.party-invite__cooldown {
  min-width: 52px;
  color: var(--color-party-panel-muted);
  font-size: 12px;
  font-variant-numeric: tabular-nums;
  text-align: end;
}

.party-invite__list input[type='checkbox'] {
  width: 22px;
  height: 22px;
  margin: 0;
  border: 2px solid var(--color-party-panel-muted);
  border-radius: 50%;
  appearance: none;
}

.party-invite__list input[type='checkbox']:checked {
  border: 5px solid var(--color-accent);
  background: var(--color-text);
}

.party-queue__row > button,
.party-queue__mine button {
  min-height: 30px;
  padding: 0 10px;
  border: 0;
  border-radius: 16px;
  background: var(--color-on-dark-border);
  color: var(--color-on-dark);
}

.party-queue__row > button.is-accept {
  background: var(--gradient-primary);
}

.party-invite {
  display: flex;
  width: 100%;
  height: 100%;
  min-height: 0;
  min-width: 0;
  flex-direction: column;
  padding: 0 16px;
}

.party-invite > :deep(.party-segmented-tabs),
.party-mode > :deep(.party-segmented-tabs),
.party-music > :deep(.party-segmented-tabs) {
  margin-bottom: 12px;
}

.party-invite__swipe {
  width: 100%;
  min-height: 0;
  min-width: 0;
  flex: 1;
}

.party-invite__swipe :deep(.swiper-wrapper),
.party-invite__swipe :deep(.swiper-slide) {
  height: 100%;
  min-height: 0;
}

.party-invite__swipe :deep(.swiper-slide) {
  overflow: hidden;
}

.party-invite__page {
  width: 100%;
  height: 100%;
  min-width: 0;
}

.party-invite__page > :deep(.popup-loading) {
  height: 100%;
}

.party-invite__list {
  height: 100%;
  padding: 0;
}

.party-backgrounds {
  display: grid;
  width: 100%;
  height: 100%;
  min-height: 0;
  box-sizing: border-box;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  align-content: start;
  gap: 12px 8px;
  padding: 8px 16px;
  overflow: hidden auto;
  overscroll-behavior: contain;
  touch-action: pan-y;
  -webkit-overflow-scrolling: touch;
}

.party-backgrounds > button {
  display: grid;
  min-width: 0;
  gap: 5px;
  padding: 3px;
  border: 1px solid transparent;
  border-radius: 11px;
  background: transparent;
  color: var(--color-on-dark);
  cursor: pointer;
  font-size: 13px;
}

.party-backgrounds > button.is-active {
  border-color: var(--color-party-list-avatar-border);
  background: var(--color-on-dark-fill);
}

.party-backgrounds > button.is-expired,
.party-backgrounds > button.is-locked {
  opacity: 0.42;
}

.party-backgrounds > button > span,
.party-backgrounds > button > small {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.party-backgrounds > button > small {
  color: var(--color-party-panel-muted);
  font-size: 11px;
}

.party-backgrounds :deep(.app-image) {
  width: 100% !important;
  aspect-ratio: 3 / 4;
  border-radius: 10px;
}

.party-backgrounds > :deep(.popup-loading) {
  height: 100%;
  grid-column: 1 / -1;
}

.party-mode {
  display: flex;
  width: 100%;
  height: 100%;
  min-height: 0;
  box-sizing: border-box;
  flex-direction: column;
  padding: 0 16px;
}

.party-mode__swipe {
  width: 100%;
  min-height: 0;
  flex: 1;
}

.party-mode__swipe :deep(.swiper-wrapper),
.party-mode__swipe :deep(.swiper-slide) {
  height: 100%;
  min-height: 0;
}

.party-mode__swipe :deep(.swiper-slide) {
  overflow: hidden;
}

.party-mode__swipe .party-backgrounds {
  height: 100%;
  max-height: none;
  box-sizing: border-box;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  padding: 0 0 8px;
}

.party-mode__swipe .party-backgrounds :deep(.app-image) {
  aspect-ratio: 172 / 156;
}

.party-panel__confirm {
  display: block;
}

.party-blacklist {
  -webkit-overflow-scrolling: touch;
  touch-action: pan-y;
}

.party-seat-roster {
  display: grid;
  width: 100%;
  height: 100%;
  min-height: 0;
  box-sizing: border-box;
  grid-template-columns: repeat(5, minmax(0, 1fr));
  align-content: start;
  gap: 16px 6px;
  padding: 8px 16px;
  overflow: hidden auto;
  overscroll-behavior: contain;
  touch-action: pan-y;
}

.party-seat-roster > button {
  display: grid;
  justify-items: center;
  gap: 5px;
  padding: 0;
  border: 0;
  background: transparent;
  color: var(--color-text);
  font-size: 11px;
}

.party-seat-roster > button > span {
  display: grid;
  width: 48px;
  height: 48px;
  place-items: center;
  border: 1px solid var(--color-accent);
  border-radius: 50%;
  background: var(--color-party-seat-action);
}

.party-seat-roster > button img {
  width: 34px;
  height: 34px;
  object-fit: contain;
}

.party-panel__loading {
  display: grid;
  min-height: 180px;
  place-items: center;
}

.party-rank nav.party-rank__kinds {
  display: flex;
  flex: 0 0 auto;
  justify-content: flex-start;
  gap: 24px;
  padding: 0 3px 10px;
}

.party-rank nav.party-rank__kinds button {
  position: relative;
  height: 26px;
  padding: 0 0 6px;
  border: 0;
  border-radius: 0;
  background: transparent;
  color: var(--color-party-panel-muted);
  font-size: 16px;
  font-weight: 700;
  line-height: 20px;
}

.party-rank nav.party-rank__kinds button.is-active {
  background: transparent;
  color: var(--color-text);
}

.party-rank nav.party-rank__kinds button.is-active::after {
  position: absolute;
  right: 0;
  bottom: 0;
  left: 0;
  width: 10px;
  height: 3px;
  margin: auto;
  border-radius: 2px;
  background: var(--gradient-primary);
  content: '';
}

.party-rank nav.party-rank__periods {
  display: grid;
  flex: 0 0 auto;
  gap: 0;
  padding: 0;
  border-radius: 999px;
  background: var(--color-scrim);
  overflow: hidden;
}

.party-rank nav.party-rank__periods button {
  height: 34px;
  padding: 0;
  border: 0;
  border-radius: 20px;
  background: transparent;
  color: var(--color-on-dark-subtle);
  font-size: 14px;
  font-weight: 700;
  line-height: 34px;
}

.party-rank nav.party-rank__periods button.is-active {
  background: var(--gradient-primary);
  color: var(--color-on-dark);
}

.party-rank nav.party-rank__periods button:disabled {
  opacity: 0.72;
}

.party-rank__meta {
  display: flex;
  min-height: 26px;
  flex: 0 0 26px;
  align-items: center;
  justify-content: space-between;
  margin-top: 0;
}

.party-rank__meta > span,
.party-rank__meta > button {
  color: var(--color-text);
  font-size: 11px;
}

.party-rank__duration {
  display: flex;
  height: 22px;
  align-items: center;
  gap: 4px;
  padding: 0 10px;
  border-radius: 999px;
  background: var(--color-party-panel-control);
}

.party-rank__meta > button {
  display: flex;
  height: 22px;
  align-items: center;
  gap: 4px;
  padding: 0 10px;
  border: 0;
  border-radius: 999px;
  background: var(--color-scrim-soft);
}

.party-rank__meta img {
  width: 12px;
  height: 12px;
}

.party-rank__page {
  height: 100%;
  min-height: 0;
  padding-top: 4px;
  overflow: hidden auto;
  overscroll-behavior: contain;
}

.party-rank__swipe-frame {
  position: relative;
  width: 100%;
  height: auto;
  min-height: 0;
  flex: 1 1 0;
  overflow: hidden;
}

.party-rank__swiper {
  width: 100%;
  height: 100%;
}

.party-rank__page > button {
  display: grid;
  width: 100%;
  min-height: 64px;
  grid-template-columns: 28px 60px minmax(0, 1fr) auto;
  align-items: center;
  gap: 8px;
  padding: 2px 10px;
  border: 0;
  background: transparent;
  color: var(--color-on-dark);
  text-align: left;
}

.party-rank__state,
.party-rank__empty {
  width: 100%;
  height: 100%;
}

.party-rank__state {
  display: grid;
  place-items: center;
}

.party-rank__page > button > img {
  width: 20px;
  height: 20px;
  object-fit: contain;
}

.party-rank__page > button > strong {
  text-align: center;
}

.party-rank__mine {
  position: relative;
  z-index: 2;
  display: grid;
  width: calc(100% + 24px);
  min-height: 64px;
  grid-template-columns: 28px 60px minmax(0, 1fr) auto;
  align-items: center;
  gap: 8px;
  flex: 0 0 auto;
  margin: 0 -12px;
  padding: 2px 22px;
  border: 0;
  border-top: 1px solid var(--color-border-strong);
  background: var(--panel-bg);
  color: var(--color-text);
  text-align: start;
}

.party-rank__mine-order {
  width: 28px;
  min-width: 28px;
  height: 20px;
  display: grid;
  place-items: center;
}

.party-rank__mine-order img {
  width: 20px;
  height: 20px;
  object-fit: contain;
}

.party-rank__mine-order strong {
  font-size: 14px;
  font-weight: 600;
  line-height: 20px;
  text-align: center;
}

.party-rank__avatar {
  position: relative;
  display: grid;
  width: 60px;
  height: 60px;
  place-items: center;
}

.party-rank__frame {
  position: absolute;
  z-index: 1;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.party-rank__page > button > span:not(.party-rank__avatar),
.party-rank__mine > span:not(.party-rank__avatar, .party-rank__mine-order) {
  display: grid;
  min-width: 0;
  gap: 4px;
}

.party-rank__page b,
.party-rank__mine b {
  overflow: hidden;
  font-size: 14px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.party-rank small {
  display: flex;
  min-height: 18px;
  align-items: center;
  gap: 4px;
}

.party-rank__medal {
  width: auto;
  height: 14px;
  background: transparent;
  object-fit: contain;
}

.party-rank em {
  display: flex;
  align-items: center;
  gap: 3px;
  color: var(--color-party-rank-score);
  font-size: 12px;
  font-style: normal;
}

.party-rank em img {
  width: 14px;
  height: 14px;
}

.party-announcement,
.party-manage {
  display: grid;
  gap: 12px;
  padding: 18px;
}

.party-announcement {
  width: 100%;
  height: 100%;
  min-height: 0;
  box-sizing: border-box;
  justify-items: center;
  padding: 0 16px 8px;
}

.party-manage.party-tools {
  grid-template-columns: repeat(3, 1fr);
  padding: 14px 12px 28px;
}

.party-manage.party-tools span {
  position: relative;
  width: 52px;
  height: 36px;
  background: transparent;
}

.party-manage.party-tools span > img {
  width: 32px;
  height: 32px;
}

.party-manage.party-tools span > i {
  position: absolute;
  top: -4px;
  right: -2px;
  width: 28px;
  height: 16px;
  border-radius: 999px;
  background: var(--color-party-panel-muted);
  color: var(--color-text);
  font-size: 10px;
  font-style: normal;
  line-height: 16px;
}

.party-manage.party-tools span > i.is-on {
  background: var(--color-success);
  color: var(--color-on-dark-secondary);
}

.party-host-seat {
  display: flex;
  min-height: 0;
  flex: 1;
  flex-direction: column;
  padding: 8px 12px 18px;
}

.party-host-seat__grid {
  display: grid;
  min-height: 0;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 8px 2px;
  overflow: hidden auto;
}

.party-host-seat__grid > button {
  position: relative;
  display: flex;
  min-height: 104px;
  align-items: center;
  padding: 12px 4px 8px;
  border: 1px solid transparent;
  border-radius: 8px;
  background: var(--color-on-dark-divider);
  color: var(--color-text);
  flex-direction: column;
}

.party-host-seat__grid > button.is-active {
  border-color: var(--color-party-list-avatar-border);
  background: var(--color-on-dark-fill);
}

.party-host-seat__grid > button.is-locked {
  opacity: 0.45;
}

.party-host-seat__grid > button > span {
  display: grid;
  width: 52px;
  height: 52px;
  place-items: center;
  border: 1px solid var(--color-party-list-avatar-border);
  border-radius: 50%;
}

.party-host-seat__grid > button > span > img {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  object-fit: contain;
}

.party-host-seat__grid strong {
  max-width: 100%;
  margin-top: 5px;
  overflow: hidden;
  font-size: 12px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.party-host-seat__grid small {
  position: absolute;
  top: 5px;
  right: 5px;
  padding: 1px 5px;
  border-radius: 999px;
  background: var(--gradient-party-list-accent);
  color: var(--color-text);
  font-size: 9px;
}

.party-host-seat__confirm {
  width: 100%;
  height: 44px;
  flex: 0 0 44px;
  margin-top: 20px;
  border: 0;
  border-radius: 25px;
  background: var(--gradient-party-list-accent);
  color: var(--color-text);
  font-size: 16px;
  font-weight: 700;
}

.party-host-seat__confirm:disabled {
  background: var(--color-on-dark-border-strong);
  color: var(--color-on-dark-subtle);
}

.party-room-settings {
  height: 100%;
  padding: 18px 20px 28px;
  overflow: hidden auto;
}

.party-room-settings__cover {
  position: relative;
  width: 100px;
  height: 100px;
  margin: 0 auto 20px;
  border-radius: 50%;
  background: var(--gradient-party-list-accent);
}

.party-room-settings__cover :deep(> .app-image) {
  position: absolute;
  inset: 1px;
  width: 98px !important;
  height: 98px !important;
  border-radius: 50% !important;
}

.party-room-settings__cover :deep(.uploader) {
  position: absolute;
  z-index: 2;
  inset: 0;
  width: 100%;
  height: 100%;
  opacity: 0;
}

.party-room-settings__cover > img {
  position: absolute;
  right: 0;
  bottom: 0;
  z-index: 3;
  width: 36px;
  height: 36px;
  pointer-events: none;
}

.party-room-settings > label {
  display: grid;
  margin-top: 16px;
  gap: 8px;
  color: var(--color-text);
  font-size: 14px;
  font-weight: 700;
}

.party-room-settings > label :deep(.van-cell),
.party-room-settings > label select {
  min-height: 46px;
  box-sizing: border-box;
  padding: 0 14px;
  border: 1px solid var(--color-party-search-border);
  border-radius: 10px;
  outline: none;
  background: var(--color-party-search-input);
  color: var(--color-text);
  font: inherit;
}

.party-room-settings > label :deep(.van-cell) {
  padding-block: 4px;
}

.party-room-settings > label :deep(.van-field__control) {
  color: var(--color-text);
}

.party-room-settings fieldset {
  min-width: 0;
  margin: 18px 0 0;
  padding: 0;
  border: 0;
}

.party-room-settings legend {
  margin-bottom: 8px;
  color: var(--color-text);
  font-size: 14px;
  font-weight: 700;
}

.party-room-settings__backgrounds {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 8px;
}

.party-room-settings__backgrounds button {
  min-width: 0;
  padding: 3px;
  overflow: hidden;
  border: 2px solid transparent;
  border-radius: 9px;
  background: var(--color-on-dark-divider);
  color: var(--color-text);
}

.party-room-settings__backgrounds button.is-active {
  border-color: var(--color-party-list-avatar-border);
}

.party-room-settings__backgrounds button.is-expired {
  opacity: 0.45;
}

.party-room-settings__backgrounds :deep(.app-image) {
  width: 100% !important;
  height: 74px !important;
  border-radius: 6px !important;
}

.party-room-settings__backgrounds span {
  display: block;
  padding: 5px 2px 2px;
  overflow: hidden;
  font-size: 10px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.party-room-settings__save {
  width: 100%;
  height: 50px;
  margin-top: 24px;
  border: 0;
  border-radius: 25px;
  background: var(--gradient-party-list-accent);
  color: var(--color-text);
  font-size: 16px;
  font-weight: 700;
}

.party-room-settings__save:disabled {
  background: var(--color-on-dark-border-strong);
  color: var(--color-on-dark-subtle);
}

.party-announcement textarea {
  width: 100%;
  height: 100%;
  min-height: 0;
  box-sizing: border-box;
  resize: none;
  padding: 12px;
  border: 0;
  border-radius: 8px;
  outline: none;
  background: var(--color-scrim-soft);
  color: var(--color-on-dark);
  font: inherit;
  line-height: 1.45;
}

.party-manage > button {
  height: 44px;
  border: 0;
  border-radius: 22px;
  background: var(--gradient-primary);
  color: var(--color-on-dark);
  font-weight: 800;
}

.party-announcement p,
.party-manage p {
  color: var(--color-on-dark-secondary);
  line-height: 1.55;
}

.party-announcement p {
  width: 100%;
  height: 100%;
  min-height: 0;
  box-sizing: border-box;
  overflow-y: auto;
  padding: 12px;
  border-radius: 8px;
  background: var(--color-scrim-soft);
  font-size: 15px;
}

.party-tool-menu {
  padding: 16px 18px 0;
  color: var(--color-text);
}

.party-tool-menu section + section {
  margin-top: 20px;
}

.party-tool-menu h3 {
  margin: 0 0 12px;
  color: var(--color-on-dark-secondary);
  font-size: 14px;
  font-weight: 600;
}

.party-tool-menu__games {
  display: flex;
  align-items: stretch;
  gap: 12px;
}

.party-tool-menu__games > div {
  position: relative;
  display: flex;
  width: 100px;
  flex-direction: column;
  align-items: center;
  padding: 16px 8px 10px;
  border-radius: 16px;
  background: var(--color-on-dark-divider);
  cursor: pointer;
}

.party-tool-menu__games > div > i {
  position: absolute;
  top: -4px;
  right: -4px;
  padding: 0 8px;
  border-radius: 999px;
  background: var(--color-danger);
  color: var(--color-text);
  font-size: 10px;
  font-style: normal;
  font-weight: 600;
  line-height: 16px;
}

.party-tool-menu__games > div > img {
  width: 50px;
  height: 50px;
  object-fit: contain;
}

.party-tool-menu__games > div > span {
  margin-top: 8px;
  font-size: 13px;
  line-height: 16px;
}

.party-tool-menu__games > div > em {
  display: flex;
  align-items: center;
  margin-top: 8px;
  gap: 2px;
  color: var(--color-success);
  cursor: pointer;
  font-size: 12px;
  font-style: normal;
}

.party-tool-menu__basic {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px 8px;
}

.party-tool-menu__basic button {
  display: flex;
  align-items: center;
  padding: 0;
  border: 0;
  background: transparent;
  color: var(--color-text);
  flex-direction: column;
  font-size: 11px;
  line-height: 14px;
}

.party-tool-menu__basic button > span {
  display: grid;
  width: 56px;
  height: 56px;
  margin-bottom: 8px;
  place-items: center;
  border-radius: 16px;
  background: var(--color-on-dark-divider);
}

.party-tool-menu__basic img {
  width: 36px;
  height: 36px;
  object-fit: contain;
}

.party-tools {
  display: grid;
  width: 100%;
  max-height: 100%;
  box-sizing: border-box;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 18px 8px;
  padding: 8px 16px 16px;
  overflow: hidden auto;
  overscroll-behavior: contain;
  touch-action: pan-y;
}

.party-tools--room-more {
  grid-template-columns: repeat(3, minmax(0, 1fr));
}

.party-tools--room-more img {
  width: 32px;
  height: 32px;
}

.party-tools button {
  display: grid;
  min-height: 72px;
  justify-items: center;
  gap: 7px;
  padding: 0;
  border: 0;
  background: transparent;
  color: var(--color-on-dark);
  cursor: pointer;
  font-size: 12px;
  font-weight: 600;
}

.party-tools span {
  display: grid;
  width: 52px;
  height: 52px;
  place-items: center;
  border-radius: 15px;
  background: var(--color-on-dark-fill);
}

.party-tools img {
  width: 26px;
  height: 26px;
  object-fit: contain;
}

.party-tools span.party-tools__game {
  position: relative;
}

.party-tools__game > i {
  position: absolute;
  top: -6px;
  right: -8px;
  z-index: 1;
  padding: 1px 7px;
  border-radius: 999px;
  background: var(--color-danger);
  color: var(--color-text);
  font-size: 10px;
  font-style: normal;
  font-weight: 700;
}

.party-tools .party-tools__game > img {
  width: 42px;
  height: 42px;
}

.party-lucky-number {
  display: flex;
  height: 100%;
  min-height: 0;
  flex-direction: column;
  padding: 8px 18px 24px;
  gap: 12px;
  overflow: hidden auto;
  color: var(--color-text);
}

.party-lucky-number > h3 {
  margin: 0;
  font-size: 16px;
}

.party-lucky-number__ranges {
  display: flex;
  gap: 10px;
}

.party-lucky-number__ranges > button {
  height: 48px;
  flex: 1;
  border: 1px solid transparent;
  border-radius: 12px;
  background: var(--color-on-dark-fill);
  color: var(--color-text);
  font-size: 15px;
}

.party-lucky-number__ranges > button.is-active {
  border-color: var(--color-success);
  background: var(--color-on-dark-divider);
}

.party-lucky-number__switch {
  display: flex;
  min-height: 42px;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  font-size: 15px;
}

.party-lucky-number__field {
  border-radius: 12px;
  background: var(--color-scrim-soft);
}

.party-lucky-number__field :deep(.van-field__control) {
  color: var(--color-text);
}

.party-lucky-number__save {
  width: 100%;
  height: 44px;
  flex: 0 0 44px;
  margin-top: auto;
  border: 0;
  border-radius: 999px;
  background: var(--gradient-primary);
  color: var(--color-text);
  font-size: 16px;
  font-weight: 700;
}

.party-music {
  display: flex;
  min-height: 0;
  height: 100%;
  flex-direction: column;
  padding: 0 16px;
  background: var(--panel-bg);
}

.party-music__swipe {
  width: 100%;
  min-height: 0;
  flex: 1;
}

.party-music__swipe :deep(.swiper-wrapper),
.party-music__swipe :deep(.swiper-slide) {
  height: 100%;
  min-height: 0;
}

.party-music__swipe :deep(.swiper-slide) {
  overflow: hidden;
}

.party-music__page {
  display: flex;
  width: 100%;
  height: 100%;
  min-height: 0;
  flex-direction: column;
  overflow: hidden;
}

.party-music__local-actions {
  display: flex;
  min-height: 44px;
  flex: 0 0 44px;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid var(--color-on-dark-fill);
  color: var(--color-party-panel-muted);
  font-size: 13px;
}

.party-music__local-actions label {
  display: grid;
  min-width: 88px;
  height: 32px;
  cursor: pointer;
  place-items: center;
  border-radius: 999px;
  background: var(--gradient-primary);
  color: var(--color-text);
  font-size: 13px;
  font-weight: 800;
}

.party-music__local-actions input {
  position: absolute;
  width: 1px;
  height: 1px;
  opacity: 0;
  pointer-events: none;
}

.party-music__list {
  min-height: 0;
  flex: 1;
  overflow: hidden auto;
  overscroll-behavior: contain;
  scrollbar-width: none;
  touch-action: pan-y;
  -webkit-overflow-scrolling: touch;
}

.party-music__list::-webkit-scrollbar {
  display: none;
}

.party-music__row {
  display: grid;
  width: 100%;
  min-height: 41px;
  grid-template-columns: minmax(0, 1fr) 44px;
  column-gap: 8px;
  align-items: center;
}

.party-music__row > button {
  min-width: 0;
  height: 41px;
  padding: 0;
  border: 0;
  background: transparent;
  color: var(--color-text);
}

.party-music__row > button:first-child {
  display: grid;
  grid-template-columns: 33px minmax(0, 1fr) 62px;
  align-items: center;
  font-size: 15px;
  text-align: start;
}

.party-music__row > button:first-child b {
  padding-inline: 4px;
  overflow: hidden;
  color: var(--color-party-panel-muted);
  font-weight: 500;
  text-align: center;
  text-overflow: ellipsis;
}

.party-music__row > button:first-child span {
  overflow: hidden;
  font-weight: 500;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.party-music__row > button:first-child span.is-current {
  color: var(--color-accent);
}

.party-music__row small {
  color: var(--color-party-panel-muted);
  font-size: 12px;
  text-align: end;
}

.party-music__row > button:last-child img {
  width: 20px;
  height: 20px;
  object-fit: contain;
}

.party-music__row > button:disabled,
.party-music__now button:disabled {
  cursor: default;
  opacity: 0.55;
}

.party-music__footer {
  display: grid;
  gap: 8px;
  background: var(--panel-bg);
}

.party-music__now {
  display: grid;
  min-height: 48px;
  flex: 0 0 48px;
  grid-template-columns: 52px minmax(0, 1fr) 40px 40px 40px;
  align-items: center;
  padding: 0 8px 0 2px;
  border-radius: 999px;
  background: var(--color-party-music-now);
}

.party-music__now > img {
  width: 44px;
  height: 44px;
  object-fit: contain;
}

.party-music__now > img.is-playing {
  animation: party-panel-music-rotate 2s linear infinite;
}

.party-music__now > strong {
  min-width: 0;
  overflow: hidden;
  color: var(--color-text);
  font-size: 15px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.party-music__now button {
  display: grid;
  width: 40px;
  height: 44px;
  padding: 0;
  place-items: center;
  border: 0;
  background: transparent;
}

.party-music__now button img {
  width: 24px;
  height: 24px;
  object-fit: contain;
}

.party-music__volume-control {
  display: grid;
  min-height: 44px;
  grid-template-columns: 24px minmax(0, 1fr) 42px;
  align-items: center;
  gap: 10px;
  padding: 0 10px;
  border-radius: 22px;
  background: var(--color-on-dark-fill);
}

.party-music__volume-control img {
  width: 20px;
  height: 20px;
  object-fit: contain;
}

.party-music__volume-control input {
  width: 100%;
  height: 44px;
  min-width: 0;
  margin: 0;
  appearance: none;
  accent-color: var(--color-accent);
  background: transparent;
  cursor: pointer;
  touch-action: pan-x;
}

.party-music__volume-control input::-webkit-slider-runnable-track {
  height: 4px;
  border-radius: 999px;
  background: var(--color-on-dark-border-strong);
}

.party-music__volume-control input::-webkit-slider-thumb {
  width: 24px;
  height: 24px;
  margin-top: -10px;
  border: 3px solid var(--color-text);
  border-radius: 50%;
  appearance: none;
  background: var(--color-primary);
}

.party-music__volume-control span {
  color: var(--color-party-panel-muted);
  font-size: 11px;
  text-align: end;
}

@keyframes party-panel-music-rotate {
  to {
    transform: rotate(360deg);
  }
}

@media (prefers-reduced-motion: reduce) {
  .party-music__now > img.is-playing {
    animation: none;
  }
}

.party-emojis {
  display: flex;
  width: 100%;
  min-width: 0;
  height: 100%;
  min-height: 214px;
  flex-direction: column;
  overflow: hidden;
}

.party-emojis__swipe {
  width: 100%;
  max-width: 100%;
  min-width: 0;
  height: 160px;
  flex: 0 0 160px;
}

.party-emojis__swipe :deep(.swiper-wrapper),
.party-emojis__swipe :deep(.swiper-slide) {
  height: 100%;
}

.party-emojis__page {
  display: grid;
  width: 100%;
  min-width: 0;
  height: 160px;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  align-content: start;
  gap: 16px 0;
  padding: 16px 20px;
}

.party-emojis__page button {
  width: 56px;
  min-width: 56px;
  height: 56px;
  justify-self: center;
  padding: 0;
  border: 0;
  background: transparent;
}

.party-emojis__page img {
  display: block;
  width: 56px;
  height: 56px;
  margin: auto;
  object-fit: contain;
}

.party-emojis__image {
  margin: auto;
  background: transparent;
}

.party-emojis__dots {
  display: flex;
  height: 10px;
  align-items: center;
  justify-content: center;
  gap: 4px;
}

.party-emojis__dots span {
  width: 4px;
  height: 4px;
  border-radius: 50%;
  background: var(--color-party-panel-muted);
}

.party-emojis__dots span.is-active {
  width: 10px;
  border-radius: 999px;
  background: var(--color-accent);
}

.party-emojis__tabs {
  display: flex;
  min-height: 48px;
  align-items: center;
  gap: 12px;
  padding: 8px 20px;
  overflow: auto hidden;
}

.party-emojis__tabs button {
  display: grid;
  min-width: 36px;
  height: 36px;
  flex: 0 0 auto;
  padding: 0 6px;
  place-items: center;
  border: 0;
  border-radius: 8px;
  background: transparent;
  color: var(--color-party-panel-muted);
  font-size: 12px;
}

.party-emojis__tabs button.is-active {
  background: var(--color-party-quick-gift-item);
  color: var(--color-text);
}

.party-emojis__tabs :deep(.app-image) {
  width: 24px !important;
  height: 24px !important;
  background: transparent;
}

.party-user-card__quick-gifts {
  width: 100%;
  box-sizing: border-box;
  margin-top: 12px;
  padding: 12px;
  border: 1px solid var(--color-on-dark-divider);
  border-radius: 14px;
  background: var(--color-profile-card-surface);
}

.party-user-card__quick-gifts > header {
  display: flex;
  min-height: 28px;
  align-items: center;
  justify-content: space-between;
  font-size: 14px;
}

.party-user-card__quick-gifts > header button,
.party-user-card__quick-gifts > div > button {
  padding: 0;
  border: 0;
  background: transparent;
  color: var(--color-text);
}

.party-user-card__quick-gifts > header button {
  display: flex;
  height: 24px;
  align-items: center;
  gap: 2px;
  padding: 0 8px;
  border-radius: 999px;
  background: var(--gradient-party-quick-gift-more);
  color: var(--color-text);
  font-size: 12px;
}

.party-user-card__quick-gifts > header button > img {
  width: 16px;
  height: 16px;
}

.party-user-card__quick-gifts > div {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 8px;
  margin-top: 4px;
}

.party-user-card__quick-gifts > div > button {
  position: relative;
  display: grid;
  min-width: 0;
  min-height: 64px;
  align-content: center;
  justify-items: center;
  overflow: hidden;
  border-radius: 10px;
  background: var(--color-on-dark-divider);
}

.party-user-card__quick-gifts :deep(.app-image) {
  width: 40px !important;
  height: 40px !important;
  background: transparent;
}

.party-user-card__quick-gifts small {
  display: flex;
  align-items: center;
  gap: 2px;
  color: var(--color-text);
  font-size: 11px;
}

.party-user-card__quick-gifts > div > button > i {
  position: absolute;
  top: 7px;
  left: -22px;
  width: 64px;
  background: var(--gradient-party-quick-gift-free);
  color: var(--color-text);
  font-size: 8px;
  font-style: normal;
  line-height: 13px;
  transform: rotate(-45deg);
}

.party-user-card__quick-gifts small img {
  width: 12px;
  height: 12px;
}

.party-user-card__moderation {
  display: flex;
  width: 100%;
  align-items: flex-start;
  justify-content: space-around;
  gap: 4px;
  margin-top: 12px;
  padding-top: 12px;
  border-top: 1px solid var(--color-on-dark-fill);
}

.party-user-card__moderation > button {
  display: grid;
  min-width: 0;
  flex: 1;
  justify-items: center;
  gap: 6px;
  padding: 0;
  border: 0;
  background: transparent;
  color: var(--color-text);
  font-size: 11px;
}

.party-user-card__moderation img {
  width: 40px;
  height: 40px;
  object-fit: contain;
}

.party-confirm-body {
  display: grid;
  width: 100%;
  box-sizing: border-box;
  justify-items: center;
  gap: 8px;
  padding: 4px 24px 8px;
  text-align: center;
}

.party-confirm-body strong {
  font-size: 15px;
  line-height: 1.45;
}

.party-confirm-body p {
  margin: 0;
  color: var(--color-on-dark-muted);
  font-size: 13px;
  line-height: 1.45;
}

.party-lock {
  display: grid;
  width: 100%;
  box-sizing: border-box;
  gap: 12px;
  padding: 4px 16px 8px;
  text-align: center;
}

.party-lock p {
  color: var(--color-on-dark-muted);
}

.party-lock input {
  height: 44px;
  border: 0;
  border-radius: 22px;
  padding: 0 16px;
  outline: none;
  background: var(--color-scrim-soft);
  color: var(--color-on-dark);
  text-align: center;
  letter-spacing: 0.3em;
}
</style>

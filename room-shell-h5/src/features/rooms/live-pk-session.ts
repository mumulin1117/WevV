import { computed, ref, shallowRef } from 'vue'
import type { RoomLaunchContext } from './contracts'
import {
  LIVE_PK_STATUS,
  isLivePkScoreVisible,
  type LivePkDetail,
  type LivePkPush,
  type LivePkRepository,
  shouldRefreshLivePk,
} from './live-pk-contracts'
import { getLivePkRepository } from './live-pk-repository'
import { rtcRoomEngine, type RtcRoomEngine } from '@/room/runtime/rtc-room-engine'

const REFRESH_INTERVAL_MS = 2_000
const MAX_REFRESH_INTERVAL_MS = 8_000
const FAILURE_VISIBLE_THRESHOLD = 5

export type LivePkSessionPhase =
  'active' | 'ended' | 'failed' | 'idle' | 'loading' | 'punishing' | 'recovering'

interface PendingDetailRequest {
  promise: Promise<LivePkDetail>
  signal: AbortSignal
}

function hasScores(value: { leftScore?: number | null; rightScore?: number | null }): boolean {
  return Number.isFinite(value.leftScore) && Number.isFinite(value.rightScore)
}

const LIVE_PK_DETAIL_FIELDS = [
  'leftAgoraChannelId',
  'leftAvatarUrl',
  'leftName',
  'leftScore',
  'leftTop3',
  'leftUserId',
  'pkId',
  'remainSeconds',
  'rightAgoraChannelId',
  'rightAvatarUrl',
  'rightName',
  'rightRoomId',
  'rightScore',
  'rightTop3',
  'rightUserId',
  'status',
] as const satisfies readonly (keyof LivePkDetail)[]

function wait(ms: number, signal: AbortSignal): Promise<void> {
  return new Promise((resolve) => {
    if (signal.aborted) {
      resolve()
      return
    }
    const timer = window.setTimeout(resolve, ms)
    signal.addEventListener(
      'abort',
      () => {
        window.clearTimeout(timer)
        resolve()
      },
      { once: true },
    )
  })
}

export class LivePkSession {
  readonly detail = shallowRef<LivePkDetail | null>(null)
  readonly phase = ref<LivePkSessionPhase>('idle')
  readonly status = ref<number>(LIVE_PK_STATUS.none)
  readonly visible = computed(() => isLivePkScoreVisible(this.status.value))

  private context: RoomLaunchContext | null = null
  private controller: AbortController | null = null
  private detailRequests = new Map<string, PendingDetailRequest>()
  private generation = 0
  private opponentChannelName = ''
  private opponentEpoch = 0
  private opponentSync: { channelName: string; promise: Promise<void> } | null = null
  private refreshLoopSignal: AbortSignal | null = null
  private refreshPkId: string | undefined
  private rankDetailRefresh: Promise<LivePkDetail | null> | null = null
  private pushFieldRevisions = new Map<keyof LivePkDetail, number>()
  private pushRevision = 0
  private suspended = false

  constructor(
    private readonly repository: LivePkRepository = getLivePkRepository(),
    private readonly rtc: RtcRoomEngine = rtcRoomEngine,
  ) {}

  start(context: RoomLaunchContext, options: { suspended?: boolean } = {}): void {
    const previousOpponentChannel = this.opponentChannelName
    const previousOpponentTarget = this.opponentSync?.channelName || previousOpponentChannel
    this.generation += 1
    this.opponentEpoch += 1
    this.controller?.abort()
    this.controller = options.suspended ? null : new AbortController()
    this.context = context
    this.detailRequests.clear()
    this.opponentSync = null
    this.suspended = Boolean(options.suspended)
    this.refreshLoopSignal = null
    this.rankDetailRefresh = null
    this.pushFieldRevisions.clear()
    this.pushRevision = 0
    this.detail.value = context.pkDetail ?? null
    this.refreshPkId = this.detail.value?.pkId || context.pkId
    this.status.value = context.pkStatus ?? LIVE_PK_STATUS.none
    this.phase.value = this.visible.value
      ? this.detail.value
        ? this.visiblePhase()
        : 'loading'
      : 'idle'
    const desiredOpponentChannel = this.visible.value
      ? (this.detail.value?.rightAgoraChannelId.trim() ?? '')
      : ''
    this.opponentChannelName =
      desiredOpponentChannel && this.rtc.hasPkChannel(desiredOpponentChannel)
        ? desiredOpponentChannel
        : ''
    if (previousOpponentTarget && previousOpponentTarget !== desiredOpponentChannel)
      void this.rtc.leavePkChannel()
    if (!this.suspended) {
      if (this.visible.value && this.detail.value) void this.syncOpponent()
      if (shouldRefreshLivePk(this.status.value)) this.startRefreshLoop(this.refreshPkId)
    }
  }

  acceptStatusPush(push: LivePkPush): void {
    if (!this.context) return
    const incomingPkId = push.pkId?.trim() ?? ''
    const currentPkId = this.currentPkId()
    const terminal = push.status === LIVE_PK_STATUS.end || push.status === LIVE_PK_STATUS.none
    if (terminal && incomingPkId && currentPkId && incomingPkId !== currentPkId) return
    if (
      !terminal &&
      incomingPkId &&
      currentPkId &&
      incomingPkId !== currentPkId &&
      shouldRefreshLivePk(push.status)
    )
      this.resetForIncomingPk(incomingPkId)

    this.recordPush(push)

    if (isLivePkScoreVisible(push.status)) {
      this.status.value = push.status
      if (this.detail.value || hasScores(push)) {
        this.detail.value = this.detailFromPush(push, this.detail.value)
        this.phase.value = this.visiblePhase()
        void this.syncOpponent()
      } else {
        this.phase.value = 'loading'
      }
      this.startRefreshLoop(incomingPkId || this.context.pkId)
      return
    }

    this.status.value = push.status
    if (terminal) {
      void this.endLocally()
      return
    }
    this.detail.value = null
    this.phase.value = shouldRefreshLivePk(push.status) ? 'loading' : 'idle'
    this.releaseOpponent()
    if (shouldRefreshLivePk(push.status)) this.startRefreshLoop(incomingPkId || this.context.pkId)
    else this.cancelRefreshLoop()
  }

  acceptRankPush(push: LivePkPush): void {
    if (!this.context || !isLivePkScoreVisible(this.status.value)) return
    const incomingPkId = push.pkId?.trim() ?? ''
    const currentPkId = this.currentPkId()
    if (incomingPkId && currentPkId && incomingPkId !== currentPkId) return
    const normalizedPush = { ...push, status: this.status.value }
    this.recordPush(normalizedPush)
    this.detail.value = this.detailFromPush(normalizedPush, this.detail.value)
    this.phase.value = this.visiblePhase()
    void this.syncOpponent()
  }

  async resume(): Promise<void> {
    if (!this.context) return
    if (this.suspended) {
      this.suspended = false
      this.controller = new AbortController()
      if (shouldRefreshLivePk(this.status.value))
        this.startRefreshLoop(this.detail.value?.pkId || this.context.pkId)
    }
    if (!this.visible.value) return
    await this.syncOpponent()
  }

  /**
   * 排行榜打开时只在缺少有效上下文的情况下按需补一次正式详情。
   * 同时点击左右榜时复用该请求，且不会用不完整结果覆盖最后有效 PK 数据。
   */
  async refreshDetailForRank(): Promise<LivePkDetail | null> {
    if (this.rankDetailRefresh) return this.rankDetailRefresh
    const context = this.context
    const controller = this.controller
    if (!context || !controller || controller.signal.aborted || this.suspended)
      return this.detail.value
    const generation = this.generation
    const pushRevision = this.pushRevision
    const promise = this.getDetail(
      context.roomId,
      this.currentPkId() || undefined,
      controller.signal,
    )
      .then(async (response) => {
        if (
          controller.signal.aborted ||
          generation !== this.generation ||
          this.context !== context ||
          this.suspended
        )
          return this.detail.value
        const detail = this.protectNewerPushFields(response, pushRevision)
        if (detail.status === LIVE_PK_STATUS.end || detail.status === LIVE_PK_STATUS.none) {
          await this.endLocally()
          return null
        }
        if (!isLivePkScoreVisible(detail.status) || !hasScores(detail)) return this.detail.value
        this.status.value = detail.status
        this.refreshPkId = detail.pkId || this.refreshPkId
        this.detail.value = detail
        this.phase.value = this.visiblePhase()
        void this.syncOpponent()
        return detail
      })
      .catch(() => this.detail.value)
      .finally(() => {
        if (this.rankDetailRefresh === promise) this.rankDetailRefresh = null
      })
    this.rankDetailRefresh = promise
    return promise
  }

  /** 后台保留最后有效比分和 PK RTC，只取消 REST 轮询与在途凭证请求。 */
  suspend(): void {
    if (!this.context || this.suspended) return
    this.suspended = true
    this.generation += 1
    this.opponentEpoch += 1
    this.controller?.abort()
    this.controller = null
    this.detailRequests.clear()
    this.opponentSync = null
    this.refreshLoopSignal = null
    this.rankDetailRefresh = null
  }

  async stop(): Promise<void> {
    this.generation += 1
    this.opponentEpoch += 1
    this.controller?.abort()
    this.controller = null
    this.context = null
    this.detailRequests.clear()
    this.opponentChannelName = ''
    this.opponentSync = null
    this.refreshLoopSignal = null
    this.refreshPkId = undefined
    this.rankDetailRefresh = null
    this.pushFieldRevisions.clear()
    this.pushRevision = 0
    this.suspended = false
    this.detail.value = null
    this.phase.value = 'idle'
    this.status.value = LIVE_PK_STATUS.none
    await this.rtc.leavePkChannel()
  }

  private cancelRefreshLoop(): void {
    this.generation += 1
    this.controller?.abort()
    this.controller = this.context && !this.suspended ? new AbortController() : null
    this.detailRequests.clear()
    this.refreshLoopSignal = null
    this.rankDetailRefresh = null
    this.refreshPkId = undefined
  }

  private currentPkId(): string {
    return (
      this.detail.value?.pkId.trim() || this.refreshPkId?.trim() || this.context?.pkId?.trim() || ''
    )
  }

  private releaseOpponent(): void {
    this.opponentEpoch += 1
    this.opponentChannelName = ''
    this.opponentSync = null
    void this.rtc.leavePkChannel()
  }

  private resetForIncomingPk(pkId: string): void {
    this.generation += 1
    this.controller?.abort()
    this.controller = this.context && !this.suspended ? new AbortController() : null
    this.detailRequests.clear()
    this.refreshLoopSignal = null
    this.rankDetailRefresh = null
    this.refreshPkId = pkId
    this.pushFieldRevisions.clear()
    this.pushRevision = 0
    this.detail.value = null
    this.releaseOpponent()
  }

  private recordPush(push: LivePkPush): void {
    this.pushRevision += 1
    const revision = this.pushRevision
    for (const field of LIVE_PK_DETAIL_FIELDS) {
      if (push[field] !== undefined) this.pushFieldRevisions.set(field, revision)
    }
  }

  private getDetail(
    roomId: string,
    pkId: string | undefined,
    signal: AbortSignal,
  ): Promise<LivePkDetail> {
    const key = `${roomId}:${pkId?.trim() ?? ''}`
    const current = this.detailRequests.get(key)
    if (current && current.signal === signal && !signal.aborted) return current.promise
    const request: PendingDetailRequest = {
      promise: this.repository.getDetail(roomId, pkId, signal),
      signal,
    }
    this.detailRequests.set(key, request)
    const settle = () => {
      if (this.detailRequests.get(key) === request) this.detailRequests.delete(key)
    }
    void request.promise.then(settle, settle)
    return request.promise
  }

  /**
   * REST 负责补齐权威快照，NIM 负责实时增量。若请求期间收到了推送，只保护推送
   * 实际携带的字段；这样迟到快照不会回滚比分，同时仍能补齐主播 ID、Top3 或频道。
   */
  private protectNewerPushFields(detail: LivePkDetail, revision: number): LivePkDetail {
    const current = this.detail.value
    if (!current || this.pushRevision === revision) return detail
    const protectedFields = Object.fromEntries(
      LIVE_PK_DETAIL_FIELDS.filter(
        (field) => (this.pushFieldRevisions.get(field) ?? 0) > revision,
      ).map((field) => [field, current[field]]),
    ) as Partial<LivePkDetail>
    return { ...detail, ...protectedFields }
  }

  private detailFromPush(push: LivePkPush, current: LivePkDetail | null): LivePkDetail {
    const context = this.context!
    return {
      leftAgoraChannelId:
        push.leftAgoraChannelId ?? current?.leftAgoraChannelId ?? context.channelName,
      leftAvatarUrl: push.leftAvatarUrl ?? current?.leftAvatarUrl ?? context.hostAvatarUrl ?? '',
      leftName: push.leftName ?? current?.leftName ?? context.displayName,
      leftScore: push.leftScore ?? current?.leftScore ?? null,
      leftTop3: push.leftTop3 ?? current?.leftTop3 ?? [],
      leftUserId: push.leftUserId ?? current?.leftUserId ?? context.hostId ?? '',
      pkId: push.pkId ?? current?.pkId ?? context.pkId ?? '',
      remainSeconds: push.remainSeconds ?? current?.remainSeconds ?? 0,
      rightAgoraChannelId: push.rightAgoraChannelId ?? current?.rightAgoraChannelId ?? '',
      rightAvatarUrl: push.rightAvatarUrl ?? current?.rightAvatarUrl ?? '',
      rightName: push.rightName ?? current?.rightName ?? '',
      rightRoomId: push.rightRoomId ?? current?.rightRoomId ?? '',
      rightScore: push.rightScore ?? current?.rightScore ?? null,
      rightTop3: push.rightTop3 ?? current?.rightTop3 ?? [],
      rightUserId: push.rightUserId ?? current?.rightUserId ?? '',
      status: push.status,
    }
  }

  private startRefreshLoop(pkId?: string): void {
    const context = this.context
    const controller = this.controller
    if (!context || !controller || controller.signal.aborted || this.suspended) return
    if (pkId?.trim()) this.refreshPkId = pkId.trim()
    if (this.refreshLoopSignal === controller.signal) return
    const signal = controller.signal
    const generation = this.generation
    this.refreshLoopSignal = signal
    void this.refreshLoop(context, signal, generation).finally(() => {
      if (this.refreshLoopSignal === signal) this.refreshLoopSignal = null
    })
  }

  private async refreshLoop(
    context: RoomLaunchContext,
    signal: AbortSignal,
    generation: number,
  ): Promise<void> {
    let staleCount = 0
    while (!signal.aborted && generation === this.generation && this.context === context) {
      try {
        const pushRevision = this.pushRevision
        const response = await this.getDetail(context.roomId, this.refreshPkId, signal)
        if (signal.aborted || generation !== this.generation || this.context !== context) return
        const detail = this.protectNewerPushFields(response, pushRevision)
        if (detail.status === LIVE_PK_STATUS.end || detail.status === LIVE_PK_STATUS.none) {
          await this.endLocally()
          return
        }
        this.status.value = detail.status
        if (!isLivePkScoreVisible(detail.status)) {
          this.detail.value = null
          this.phase.value = shouldRefreshLivePk(detail.status) ? 'loading' : 'idle'
          this.opponentEpoch += 1
          this.opponentChannelName = ''
          this.opponentSync = null
          await this.rtc.leavePkChannel()
          staleCount = 0
          if (!shouldRefreshLivePk(detail.status)) {
            this.cancelRefreshLoop()
            return
          }
        } else if (!hasScores(detail)) {
          staleCount += 1
          this.phase.value = this.detail.value ? 'recovering' : 'loading'
        } else {
          staleCount = 0
          this.refreshPkId = detail.pkId || this.refreshPkId
          this.detail.value = detail
          this.phase.value = this.visiblePhase()
          await this.syncOpponent()
        }
      } catch (cause) {
        if (signal.aborted || generation !== this.generation) return
        staleCount += 1
        this.phase.value = this.detail.value
          ? 'recovering'
          : staleCount >= FAILURE_VISIBLE_THRESHOLD
            ? 'failed'
            : 'loading'
        if (import.meta.env.DEV && staleCount === 1)
          console.warn('Live PK detail is temporarily unavailable.', cause)
      }
      const delay = Math.min(
        MAX_REFRESH_INTERVAL_MS,
        REFRESH_INTERVAL_MS * 2 ** Math.min(staleCount, 2),
      )
      await wait(delay, signal)
    }
  }

  private async syncOpponent(): Promise<void> {
    const context = this.context
    const detail = this.detail.value
    if (!context || !detail || !this.visible.value || this.suspended) return
    const channelName = detail.rightAgoraChannelId.trim()
    if (!channelName || channelName === context.channelName) {
      const shouldLeave = Boolean(this.opponentChannelName || this.opponentSync)
      this.opponentEpoch += 1
      this.opponentSync = null
      this.opponentChannelName = ''
      if (shouldLeave) await this.rtc.leavePkChannel()
      return
    }
    if (this.rtc.hasPkChannel(channelName)) return
    if (this.opponentSync?.channelName === channelName) return this.opponentSync.promise
    const epoch = ++this.opponentEpoch
    const promise = this.performOpponentSync(context, channelName, epoch)
    this.opponentSync = { channelName, promise }
    try {
      await promise
    } catch (cause) {
      if (epoch !== this.opponentEpoch || this.controller?.signal.aborted) return
      if (import.meta.env.DEV) console.warn('Live PK opponent channel is unavailable.', cause)
    } finally {
      if (this.opponentSync?.promise === promise) this.opponentSync = null
    }
  }

  private async performOpponentSync(
    context: RoomLaunchContext,
    channelName: string,
    epoch: number,
  ): Promise<void> {
    const credential = await this.repository.getRtcCredential(this.controller?.signal)
    if (
      epoch !== this.opponentEpoch ||
      this.context !== context ||
      !this.visible.value ||
      this.suspended ||
      this.detail.value?.rightAgoraChannelId.trim() !== channelName
    )
      return
    await this.rtc.joinPkChannel(
      {
        appId: context.appId,
        channelName,
        rtcToken: credential.rtcToken,
        uid: credential.uid,
      },
      {
        tokenProvider: async () => {
          const next = await this.repository.getRtcCredential(this.controller?.signal)
          return next.rtcToken
        },
      },
    )
    if (
      epoch === this.opponentEpoch &&
      this.context === context &&
      this.visible.value &&
      !this.suspended &&
      this.detail.value?.rightAgoraChannelId.trim() === channelName &&
      this.rtc.hasPkChannel(channelName)
    )
      this.opponentChannelName = channelName
  }

  private async endLocally(): Promise<void> {
    this.generation += 1
    this.opponentEpoch += 1
    this.opponentSync = null
    this.opponentChannelName = ''
    this.controller?.abort()
    this.controller = this.context && !this.suspended ? new AbortController() : null
    this.detailRequests.clear()
    this.refreshLoopSignal = null
    this.rankDetailRefresh = null
    this.refreshPkId = undefined
    this.status.value = LIVE_PK_STATUS.none
    this.detail.value = null
    this.phase.value = 'ended'
    await this.rtc.leavePkChannel()
  }

  private visiblePhase(): LivePkSessionPhase {
    return this.status.value === LIVE_PK_STATUS.punishing ? 'punishing' : 'active'
  }
}

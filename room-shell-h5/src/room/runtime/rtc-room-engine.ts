import type {
  IAgoraRTCClient,
  IAgoraRTCRemoteUser,
  ICameraVideoTrack,
  IBufferSourceAudioTrack,
  ILocalAudioTrack,
  ILocalVideoTrack,
  IMicrophoneAudioTrack,
  IRemoteVideoTrack,
  UID,
} from 'agora-rtc-sdk-ng'
import type AgoraRTC from 'agora-rtc-sdk-ng'
import { resolveBundleUrl } from '@/core/assets/bundle-url'
import type { RoomLaunchContext } from '@/features/rooms/contracts'
import { ref } from 'vue'

export type RoomEngineState =
  | 'cold'
  | 'warming'
  | 'ready'
  | 'joining'
  | 'waiting-first-frame'
  | 'active'
  | 'waiting-stream'
  | 'reconnecting'
  | 'stream-ended'
  | 'leaving'
  | 'idle'
  | 'failed'

export interface RoomMetrics {
  firstAudioAt: number | null
  firstVideoAt: number | null
  joinStartedAt: number | null
  joinedAt: number | null
}

export type RtcFailureKind =
  'bundle' | 'insecure-context' | 'network' | 'token' | 'uid-conflict' | 'unknown' | 'unsupported'

type RtcSdk = typeof AgoraRTC
type RtcCodedError = Error & { code?: string | number }
type RtcWindow = Window & { AgoraRTC?: RtcSdk }

interface RemoteVideo {
  track: IRemoteVideoTrack
  uid: UID
}

interface RemoteVideoRenderState {
  track: IRemoteVideoTrack
  container: HTMLElement
}

export type PkRoomEngineState =
  'idle' | 'joining' | 'waiting-stream' | 'active' | 'reconnecting' | 'failed'

export interface PkRtcJoinContext {
  appId: string
  channelName: string
  rtcToken: string
  uid: number
}

export function rtcTokenForJoin(token: string): string | null {
  const normalized = token.trim()
  return normalized.length > 0 ? normalized : null
}

export function shouldUseRtcPreview(context: RoomLaunchContext): boolean {
  return context.appId.trim().length === 0
}

export function isExpectedRemoteHost(expectedHostId: string | undefined, uid: UID): boolean {
  return !expectedHostId || String(uid) === expectedHostId
}

export function rtcFailureKind(error: Error | null): RtcFailureKind {
  if (!error) return 'unknown'
  const code = rtcFailureReference(error)
  if (/VITE_PRELOAD|SDK_LOAD|SDK_INIT/u.test(code)) return 'bundle'
  if (code.includes('UID_CONFLICT')) return 'uid-conflict'
  if (code.includes('WEB_SECURITY_RESTRICT')) return 'insecure-context'
  if (code.includes('NOT_SUPPORTED')) return 'unsupported'
  if (/TOKEN|DYNAMIC_KEY|NO_AUTHORIZED/u.test(code)) return 'token'
  if (/GATEWAY|NETWORK|TIMEOUT|WS_ABORT|OFFLINE/u.test(code)) return 'network'
  return 'unknown'
}

export function rtcFailureReference(error: Error | null): string {
  if (!error) return 'RTC_UNKNOWN'
  const message = `${error.name} ${error.message}`
  const rawCode = (error as RtcCodedError).code
  const candidate =
    typeof rawCode === 'string' || typeof rawCode === 'number'
      ? String(rawCode)
      : (message.match(/UID_CONFLICT|WEB_SECURITY_RESTRICT|NOT_SUPPORTED|VITE_PRELOAD__/u)?.[0] ??
        message.match(/[A-Z][A-Z0-9_]{3,63}/u)?.[0])
  return candidate && /^[A-Z][A-Z0-9_]{2,63}$/u.test(candidate) ? `RTC_${candidate}` : 'RTC_UNKNOWN'
}

function normalizeRtcError(cause: unknown, fallbackCode: string): Error {
  if (cause instanceof Error) {
    if ((cause as RtcCodedError).code !== undefined) return cause
    ;(cause as RtcCodedError).code = fallbackCode
    return cause
  }

  const detail =
    cause && typeof cause === 'object'
      ? (cause as { code?: unknown; message?: unknown; name?: unknown })
      : null
  const error = new Error(
    typeof detail?.message === 'string' ? detail.message : 'RTC operation failed.',
  ) as RtcCodedError
  if (typeof detail?.name === 'string') error.name = detail.name
  error.code =
    typeof detail?.code === 'string' || typeof detail?.code === 'number'
      ? detail.code
      : fallbackCode
  return error
}

const RTC_SDK_LOAD_TIMEOUT_MS = 10_000
const RTC_TRACK_CREATE_TIMEOUT_MS = 12_000
const RTC_JOIN_TIMEOUT_MS = 15_000
const RTC_FIRST_FRAME_TIMEOUT_MS = 12_000
const RTC_OPERATION_TIMEOUT_MS = 8_000
const RTC_LEAVE_TIMEOUT_MS = 5_000
const RTC_CONNECTION_FAILURE_GRACE_MS = 12_000

function withRtcDeadline<T>(task: Promise<T>, timeout: number, operation: string): Promise<T> {
  return new Promise<T>((resolve, reject) => {
    let settled = false
    const timer = window.setTimeout(() => {
      if (settled) return
      settled = true
      reject(normalizeRtcError(new Error(`${operation}_TIMEOUT`), `${operation}_TIMEOUT`))
    }, timeout)
    task.then(
      (value) => {
        if (settled) return
        settled = true
        window.clearTimeout(timer)
        resolve(value)
      },
      (cause: unknown) => {
        if (settled) return
        settled = true
        window.clearTimeout(timer)
        reject(cause)
      },
    )
  })
}

type ClosableLocalTrack = Pick<ILocalAudioTrack | ILocalVideoTrack, 'close' | 'stop'>

function withLocalTrackDeadline<T extends ClosableLocalTrack>(
  task: Promise<T>,
  operation: string,
): Promise<T> {
  return withRtcDeadline(task, RTC_TRACK_CREATE_TIMEOUT_MS, operation).catch((cause: unknown) => {
    // getUserMedia/Agora track 创建也不能真正取消；超时后若迟到成功，立即关轨。
    void task
      .then((track) => {
        track.stop()
        track.close()
      })
      .catch(() => undefined)
    throw cause
  })
}

export type LocalTrackPlan = 'none' | 'audio' | 'audio-video'

export function localTrackPlanFor(context: RoomLaunchContext): LocalTrackPlan {
  if (context.role === 'audience') return 'none'
  return context.mode === 'voice' ? 'audio' : 'audio-video'
}

export class RtcRoomEngine {
  private sdk: RtcSdk | null = null
  private client: IAgoraRTCClient | null = null
  private pkClient: IAgoraRTCClient | null = null
  private audioTrack: IMicrophoneAudioTrack | ILocalAudioTrack | null = null
  private musicTrack: IBufferSourceAudioTrack | null = null
  private videoTrack: ICameraVideoTrack | ILocalVideoTrack | null = null
  private loadPromise: Promise<RtcSdk> | null = null
  private joinPromise: Promise<void> | null = null
  private leavePromise: Promise<void> | null = null
  private renewPromise: Promise<void> | null = null
  private tokenProvider: ((context: RoomLaunchContext) => Promise<string>) | null = null
  private context: RoomLaunchContext | null = null
  private localVideoContainer: HTMLElement | null = null
  private remoteVideoContainer: HTMLElement | null = null
  private remoteVideo: RemoteVideo | null = null
  private remoteVideoFirstFrameBinding: {
    handler: () => void
    track: IRemoteVideoTrack
  } | null = null
  private remoteVideoRenderState: RemoteVideoRenderState | null = null
  private readonly voiceRemoteVideos = new Map<string, IRemoteVideoTrack>()
  private readonly voiceVideoContainers = new Map<string, HTMLElement>()
  private readonly voiceVideoRenderStates = new Map<string, RemoteVideoRenderState>()
  private pkRemoteVideo: RemoteVideo | null = null
  private pkRemoteVideoRenderState: RemoteVideoRenderState | null = null
  private joined = false
  private readonly streamFallbackUsers = new Set<string>()
  private voiceSoundEnabled = true
  private voicePublishingRequested = false
  private playbackMuted = false
  private pkPlaybackMuted = false
  private appVisible = true
  private connectionFailureTimer = 0
  private firstFrameTimer = 0
  private lifecycleEpoch = 0
  private musicEpoch = 0
  private musicLoop = false
  private pkChannelName = ''
  private pkJoined = false
  private pkJoinPromise: Promise<void> | null = null
  private pkLeavePromise: Promise<void> | null = null
  private pkLifecycleEpoch = 0
  private pkRemoteVideoContainer: HTMLElement | null = null
  private pkRenewPromise: Promise<void> | null = null
  private readonly releaseTasks = new WeakMap<IAgoraRTCClient, Promise<void>>()
  private readonly pkReleaseTasks = new WeakMap<IAgoraRTCClient, Promise<void>>()
  private pkTokenProvider: (() => Promise<string>) | null = null

  readonly state = ref<RoomEngineState>('cold')
  readonly error = ref<Error | null>(null)
  readonly microphoneMuted = ref(false)
  readonly cameraMuted = ref(false)
  readonly voicePublishing = ref(false)
  readonly activeSpeakers = ref<UID[]>([])
  readonly metrics = ref<RoomMetrics>({
    firstAudioAt: null,
    firstVideoAt: null,
    joinStartedAt: null,
    joinedAt: null,
  })
  readonly pkError = ref<Error | null>(null)
  readonly pkState = ref<PkRoomEngineState>('idle')

  markWaitingForHost(): void {
    if (this.joined && this.context?.mode === 'live') this.state.value = 'waiting-stream'
  }

  markStreamEnded(): void {
    if (this.context?.mode === 'live') this.state.value = 'stream-ended'
  }

  markFailed(cause: unknown, fallbackCode = 'RTC_OPERATION_FAILED'): Error {
    return this.fail(cause, fallbackCode)
  }

  /** 只加载并解析本地 SDK，不创建 client、不开媒体、也不加入频道。 */
  async preloadSdk(): Promise<void> {
    await this.loadSdk()
  }

  async warm(): Promise<void> {
    if (this.state.value === 'ready' || this.client) return
    this.state.value = 'warming'
    try {
      const sdk = await this.loadSdk()
      const codecs = await sdk.getSupportedCodec().catch(() => ({ audio: [], video: [] }))
      const codec = codecs.video.map((value) => value.toLowerCase()).includes('h264')
        ? 'h264'
        : 'vp8'
      const client = sdk.createClient({ mode: 'live', codec })
      this.bindClient(client)
      this.client = client
      this.state.value = 'ready'
    } catch (cause) {
      const error = this.fail(cause, 'SDK_INIT_FAILED')
      throw error
    }
  }

  async prepareLocalPreview(context: RoomLaunchContext): Promise<void> {
    const trackPlan = localTrackPlanFor(context)
    if (trackPlan === 'none') return
    await this.warm()
    this.context = context
    if (this.audioTrack) return
    const sdk = await this.loadSdk()
    if (trackPlan === 'audio') {
      this.audioTrack = await withLocalTrackDeadline(
        sdk.createMicrophoneAudioTrack({ AEC: true, AGC: true, ANS: true }),
        'RTC_AUDIO_TRACK_CREATE',
      )
      return
    }
    const audioTask = withLocalTrackDeadline(
      sdk.createMicrophoneAudioTrack({ AEC: true, AGC: true, ANS: true }),
      'RTC_AUDIO_TRACK_CREATE',
    )
    const videoTask = withLocalTrackDeadline(
      sdk.createCameraVideoTrack({
        encoderConfig: '480p_1',
        facingMode: 'user',
        optimizationMode: 'motion',
      }),
      'RTC_VIDEO_TRACK_CREATE',
    )
    const [audioTrack, videoTrack] = await Promise.all([audioTask, videoTask]).catch(
      (cause: unknown) => {
        void audioTask
          .then((track) => {
            track.stop()
            track.close()
          })
          .catch(() => undefined)
        void videoTask
          .then((track) => {
            track.stop()
            track.close()
          })
          .catch(() => undefined)
        throw cause
      },
    )
    this.audioTrack = audioTrack
    this.videoTrack = videoTrack
    this.playLocalVideo()
  }

  async join(
    context: RoomLaunchContext,
    options: { tokenProvider?: (context: RoomLaunchContext) => Promise<string> } = {},
  ): Promise<void> {
    if (this.leavePromise) await this.leavePromise
    if (this.joinPromise) {
      await this.joinPromise
      if (this.joined && this.context?.roomId === context.roomId) return
      return this.join(context, options)
    }
    if (this.joined && this.context?.roomId === context.roomId) {
      this.tokenProvider = options.tokenProvider ?? this.tokenProvider
      return
    }

    const operationEpoch = ++this.lifecycleEpoch
    this.tokenProvider = options.tokenProvider ?? null
    this.joinPromise = this.performJoin(context, operationEpoch)
    try {
      await this.joinPromise
    } finally {
      this.joinPromise = null
    }
  }

  async leave(): Promise<void> {
    this.lifecycleEpoch += 1
    if (this.leavePromise) return this.leavePromise
    this.leavePromise = this.performLeave()
    try {
      await this.leavePromise
    } finally {
      this.leavePromise = null
    }
  }

  async joinPkChannel(
    context: PkRtcJoinContext,
    options: { tokenProvider?: () => Promise<string> } = {},
  ): Promise<void> {
    if (this.pkLeavePromise) await this.pkLeavePromise
    if (this.pkJoinPromise) {
      await this.pkJoinPromise
      if (this.pkJoined && this.pkChannelName === context.channelName) return
      return this.joinPkChannel(context, options)
    }
    if (this.pkJoined && this.pkChannelName === context.channelName) {
      this.pkTokenProvider = options.tokenProvider ?? this.pkTokenProvider
      this.playPkRemoteVideo()
      return
    }
    const operationEpoch = ++this.pkLifecycleEpoch
    this.pkTokenProvider = options.tokenProvider ?? null
    this.pkJoinPromise = this.performPkJoin(context, operationEpoch)
    try {
      await this.pkJoinPromise
    } finally {
      this.pkJoinPromise = null
    }
  }

  hasPkChannel(channelName: string): boolean {
    return (
      this.pkJoined &&
      this.pkChannelName === channelName.trim() &&
      this.pkState.value !== 'failed' &&
      this.pkState.value !== 'idle'
    )
  }

  async leavePkChannel(): Promise<void> {
    this.pkLifecycleEpoch += 1
    if (this.pkLeavePromise) return this.pkLeavePromise
    this.pkLeavePromise = this.performPkLeave()
    try {
      await this.pkLeavePromise
    } finally {
      this.pkLeavePromise = null
    }
  }

  async dispose(): Promise<void> {
    const pendingJoin = this.joinPromise
    await this.leave()
    // 切房时必须等旧 join 真正退出；否则新房可能与旧 Agora client 并发争用单例。
    await pendingJoin?.catch(() => undefined)
    if (this.joined || this.context) await this.leave()
    this.client?.removeAllListeners()
    this.client = null
    this.sdk = null
    this.loadPromise = null
    this.renewPromise = null
    this.localVideoContainer = null
    this.remoteVideoContainer = null
    this.remoteVideoRenderState = null
    this.pkRemoteVideoRenderState = null
    this.voiceRemoteVideos.clear()
    this.voiceVideoContainers.clear()
    this.voiceVideoRenderStates.clear()
    this.pkRemoteVideoContainer = null
    this.pkTokenProvider = null
    this.streamFallbackUsers.clear()
    this.pkError.value = null
    this.pkRenewPromise = null
    this.pkState.value = 'idle'
    this.error.value = null
    this.microphoneMuted.value = false
    this.cameraMuted.value = false
    this.voicePublishing.value = false
    this.voicePublishingRequested = false
    this.voiceSoundEnabled = true
    this.playbackMuted = false
    this.pkPlaybackMuted = false
    this.appVisible = true
    this.state.value = 'cold'
  }

  attachLocalVideo(container: HTMLElement | null): void {
    const previous = this.localVideoContainer
    if (previous && previous !== container) previous.replaceChildren()
    this.localVideoContainer = container
    this.playLocalVideo()
  }

  attachRemoteVideo(container: HTMLElement | null): void {
    const previous = this.remoteVideoContainer
    if (previous && previous !== container) previous.replaceChildren()
    this.remoteVideoContainer = container
    this.remoteVideoRenderState = null
    this.playRemoteVideo()
  }

  attachVoiceVideo(uid: string, container: HTMLElement | null): void {
    const key = String(uid)
    const previous = this.voiceVideoContainers.get(key)
    if (previous && previous !== container) {
      previous.replaceChildren()
      this.voiceVideoRenderStates.delete(key)
    }
    if (!container) {
      this.voiceVideoContainers.delete(key)
      this.voiceVideoRenderStates.delete(key)
      return
    }
    this.voiceVideoContainers.set(key, container)
    this.playVoiceVideo(key)
  }

  attachPkRemoteVideo(container: HTMLElement | null): void {
    const previous = this.pkRemoteVideoContainer
    if (previous && previous !== container) previous.replaceChildren()
    this.pkRemoteVideoContainer = container
    this.pkRemoteVideoRenderState = null
    this.playPkRemoteVideo()
  }

  async setMicrophoneMuted(muted: boolean): Promise<void> {
    if (!this.audioTrack) return
    await this.audioTrack.setMuted(muted)
    this.microphoneMuted.value = muted
  }

  async prepareVoicePublishing(withVideo = false): Promise<void> {
    const context = this.context
    if (!context || context.mode !== 'voice' || !this.joined)
      throw new Error('Voice-room RTC is not ready.')
    if (this.audioTrack && (!withVideo || this.videoTrack)) return
    const sdk = await this.loadSdk()
    let createdAudio: ILocalAudioTrack | null = null
    let createdVideo: ILocalVideoTrack | null = null
    try {
      if (!this.audioTrack) {
        createdAudio = await withLocalTrackDeadline(
          sdk.createMicrophoneAudioTrack({ AEC: true, AGC: true, ANS: true }),
          'RTC_AUDIO_TRACK_CREATE',
        )
        this.audioTrack = createdAudio
      }
      if (withVideo && !this.videoTrack) {
        createdVideo = await withLocalTrackDeadline(
          sdk.createCameraVideoTrack({
            encoderConfig: '480p_1',
            facingMode: 'user',
            optimizationMode: 'motion',
          }),
          'RTC_VIDEO_TRACK_CREATE',
        )
        this.videoTrack = createdVideo
      }
    } catch (cause) {
      createdAudio?.stop()
      createdAudio?.close()
      createdVideo?.stop()
      createdVideo?.close()
      if (this.audioTrack === createdAudio) this.audioTrack = null
      if (this.videoTrack === createdVideo) this.videoTrack = null
      throw cause
    }
  }

  async setVoicePublishing(publishing: boolean, withVideo = false): Promise<void> {
    const client = this.client
    const context = this.context
    if (!client || !context || context.mode !== 'voice' || !this.joined) {
      if (!publishing) this.voicePublishingRequested = false
      return
    }
    this.voicePublishingRequested = publishing
    if (publishing) {
      try {
        const alreadyPublishing = context.role === 'host'
        const hadAudioTrack = Boolean(this.audioTrack)
        const hadVideoTrack = Boolean(this.videoTrack)
        if (!alreadyPublishing)
          await withRtcDeadline(
            client.setClientRole('host'),
            RTC_OPERATION_TIMEOUT_MS,
            'RTC_ROLE_HOST',
          )
        await this.prepareVoicePublishing(withVideo)
        if (alreadyPublishing) {
          const addedTracks = [
            !hadAudioTrack ? this.audioTrack : null,
            withVideo && !hadVideoTrack ? this.videoTrack : null,
          ].filter(Boolean) as Array<ILocalAudioTrack | ILocalVideoTrack>
          if (addedTracks.length)
            await withRtcDeadline(
              client.publish(addedTracks),
              RTC_OPERATION_TIMEOUT_MS,
              'RTC_PUBLISH',
            )
          if (!withVideo && this.videoTrack) {
            await withRtcDeadline(
              client.unpublish(this.videoTrack),
              RTC_OPERATION_TIMEOUT_MS,
              'RTC_UNPUBLISH_VIDEO',
            ).catch(() => undefined)
            this.videoTrack.stop()
            this.videoTrack.close()
            this.videoTrack = null
            this.localVideoContainer?.replaceChildren()
          }
          this.playLocalVideo()
          this.context = { ...context, role: 'host' }
          this.voicePublishing.value = true
          return
        }
        const publishTracks: Array<ILocalAudioTrack | ILocalVideoTrack> = []
        if (this.audioTrack) publishTracks.push(this.audioTrack)
        if (withVideo && this.videoTrack) publishTracks.push(this.videoTrack)
        if (publishTracks.length)
          await withRtcDeadline(
            client.publish(publishTracks),
            RTC_OPERATION_TIMEOUT_MS,
            'RTC_PUBLISH',
          )
        this.playLocalVideo()
        this.context = { ...context, role: 'host' }
        this.microphoneMuted.value = false
        this.voicePublishing.value = true
        return
      } catch (cause) {
        this.voicePublishingRequested = this.voicePublishing.value
        throw cause
      }
    }
    if (this.audioTrack) {
      const localTracks = [this.audioTrack, this.videoTrack].filter(Boolean) as Array<
        ILocalAudioTrack | ILocalVideoTrack
      >
      await withRtcDeadline(
        client.unpublish(localTracks),
        RTC_OPERATION_TIMEOUT_MS,
        'RTC_UNPUBLISH',
      ).catch(() => undefined)
      this.audioTrack.stop()
      this.audioTrack.close()
      this.audioTrack = null
      this.videoTrack?.stop()
      this.videoTrack?.close()
      this.videoTrack = null
      this.localVideoContainer?.replaceChildren()
    }
    if (!this.musicTrack) {
      await withRtcDeadline(
        client.setClientRole('audience'),
        RTC_OPERATION_TIMEOUT_MS,
        'RTC_ROLE_AUDIENCE',
      )
      this.context = { ...context, role: 'audience' }
    }
    this.microphoneMuted.value = false
    this.voicePublishing.value = false
    this.voicePublishingRequested = false
  }

  async playRoomMusic(
    source: string,
    options: { loop?: boolean; positionSeconds?: number; volume?: number } = {},
  ): Promise<void> {
    if (!this.client || !this.context || this.context.mode !== 'voice' || !this.joined)
      throw new Error('The voice-room audio channel is not connected.')
    await this.stopRoomMusic()
    const client = this.client
    const context = this.context
    const lifecycleEpoch = this.lifecycleEpoch
    const operationEpoch = ++this.musicEpoch
    if (!client || !context || context.mode !== 'voice' || !this.joined)
      throw new Error('The voice-room audio channel is no longer connected.')
    const sdk = await this.loadSdk()
    const track = await withLocalTrackDeadline(
      sdk.createBufferSourceAudioTrack({ cacheOnlineFile: true, source }),
      'RTC_MUSIC_TRACK',
    )
    if (
      lifecycleEpoch !== this.lifecycleEpoch ||
      operationEpoch !== this.musicEpoch ||
      this.client !== client ||
      !this.joined
    ) {
      track.stop()
      track.close()
      throw new Error('The voice-room music request was cancelled.')
    }
    let promoted = false
    let published = false
    try {
      track.setVolume(Math.min(200, Math.max(0, options.volume ?? 100)))
      if (context.role !== 'host') {
        await withRtcDeadline(
          client.setClientRole('host'),
          RTC_OPERATION_TIMEOUT_MS,
          'RTC_MUSIC_ROLE',
        )
        promoted = true
      }
      if (
        lifecycleEpoch !== this.lifecycleEpoch ||
        operationEpoch !== this.musicEpoch ||
        this.client !== client ||
        !this.joined
      )
        throw new Error('The voice-room music request was cancelled.')
      const publishTask = client.publish(track)
      await withRtcDeadline(publishTask, RTC_OPERATION_TIMEOUT_MS, 'RTC_MUSIC_PUBLISH').catch(
        (cause: unknown) => {
          // Agora publish cannot be cancelled. If it resolves after our timeout,
          // unpublish the orphan track as soon as the SDK reports completion.
          void publishTask.then(() => client.unpublish(track)).catch(() => undefined)
          throw cause
        },
      )
      published = true
      if (
        lifecycleEpoch !== this.lifecycleEpoch ||
        operationEpoch !== this.musicEpoch ||
        this.client !== client ||
        !this.joined
      )
        throw new Error('The voice-room music request was cancelled.')
      this.musicTrack = track
      this.musicLoop = options.loop === true
      // BufferSource 只进入 Agora 发布链路。调用 play() 会再建立一条本机
      // 扬声器监听链；它可能被麦克风重新采集并随 RTC 延迟回传，最终让
      // 房间成员同时听到原音乐和延迟副本。
      track.startProcessAudioBuffer({
        loop: this.musicLoop,
        startPlayTime: Math.max(0, options.positionSeconds ?? 0),
      })
      this.context = { ...context, role: 'host' }
    } catch (cause) {
      if (published && this.client === client && this.joined)
        await withRtcDeadline(
          client.unpublish(track),
          RTC_OPERATION_TIMEOUT_MS,
          'RTC_MUSIC_UNPUBLISH',
        ).catch(() => undefined)
      try {
        track.stopProcessAudioBuffer()
      } catch {
        // A failed start leaves no process to stop.
      }
      track.stop()
      track.close()
      if (this.musicTrack === track) this.musicTrack = null
      if (
        promoted &&
        operationEpoch === this.musicEpoch &&
        this.client === client &&
        this.joined &&
        !this.voicePublishingRequested &&
        !this.voicePublishing.value &&
        !this.musicTrack
      ) {
        await withRtcDeadline(
          client.setClientRole('audience'),
          RTC_OPERATION_TIMEOUT_MS,
          'RTC_MUSIC_ROLE_AUDIENCE',
        ).catch(() => undefined)
        if (this.context) this.context = { ...this.context, role: 'audience' }
      }
      throw cause
    }
  }

  pauseRoomMusic(): void {
    this.musicTrack?.pauseProcessAudioBuffer()
  }

  hasRoomMusicTrack(): boolean {
    return this.musicTrack !== null
  }

  resumeRoomMusic(positionSeconds = 0): void {
    const track = this.musicTrack
    if (!track) return
    if (positionSeconds > 0) track.seekAudioBuffer(positionSeconds)
    if (track.currentState === 'paused') track.resumeProcessAudioBuffer()
    else if (track.currentState === 'stopped')
      track.startProcessAudioBuffer({ startPlayTime: Math.max(0, positionSeconds) })
  }

  setRoomMusicVolume(volume: number): void {
    this.musicTrack?.setVolume(Math.min(200, Math.max(0, volume)))
  }

  setRoomMusicLoop(loop: boolean): void {
    const track = this.musicTrack
    if (!track || this.musicLoop === loop || track.currentState === 'stopped') return
    const state = track.currentState
    const positionSeconds = track.getCurrentTime()
    track.stopProcessAudioBuffer()
    track.startProcessAudioBuffer({ loop, startPlayTime: positionSeconds })
    if (state === 'paused') track.pauseProcessAudioBuffer()
    this.musicLoop = loop
  }

  async stopRoomMusic(): Promise<void> {
    this.musicEpoch += 1
    const track = this.musicTrack
    if (!track) return
    this.musicTrack = null
    this.musicLoop = false
    if (this.client && this.joined)
      await withRtcDeadline(
        this.client.unpublish(track),
        RTC_OPERATION_TIMEOUT_MS,
        'RTC_MUSIC_UNPUBLISH',
      ).catch(() => undefined)
    try {
      track.stopProcessAudioBuffer()
    } catch {
      // The source may already have reached its terminal state.
    }
    track.stop()
    track.close()
    if (
      this.client &&
      this.joined &&
      !this.voicePublishingRequested &&
      !this.voicePublishing.value
    ) {
      await withRtcDeadline(
        this.client.setClientRole('audience'),
        RTC_OPERATION_TIMEOUT_MS,
        'RTC_MUSIC_ROLE_AUDIENCE',
      ).catch(() => undefined)
      if (this.context) this.context = { ...this.context, role: 'audience' }
    }
  }

  async setVoiceSoundEnabled(enabled: boolean): Promise<void> {
    this.voiceSoundEnabled = enabled
    for (const user of this.client?.remoteUsers ?? []) {
      if (!user.audioTrack) continue
      if (enabled) user.audioTrack.play()
      else user.audioTrack.stop()
    }
  }

  setPlaybackMuted(muted: boolean): void {
    this.playbackMuted = muted
    for (const user of this.client?.remoteUsers ?? []) user.audioTrack?.setVolume(muted ? 0 : 100)
    for (const user of this.pkClient?.remoteUsers ?? [])
      user.audioTrack?.setVolume(muted || this.pkPlaybackMuted ? 0 : 100)
  }

  setAppVisible(visible: boolean): void {
    this.appVisible = visible
    this.setPlaybackMuted(!visible)
    if (!visible) {
      this.clearConnectionFailureTimeout()
      this.clearFirstFrameTimeout()
      return
    }
    this.replayRemoteVideoSurfaces()
    if (
      this.joined &&
      this.client &&
      this.client.connectionState !== 'CONNECTED' &&
      this.state.value === 'reconnecting'
    )
      this.scheduleConnectionFailureTimeout(this.client)
    if (
      this.joined &&
      this.state.value === 'waiting-first-frame' &&
      this.metrics.value.firstVideoAt === null
    )
      this.scheduleFirstFrameTimeout(this.lifecycleEpoch)
  }

  canResumeWithoutRejoin(roomId: string): boolean {
    if (
      this.context?.roomId !== roomId ||
      !this.joined ||
      !this.client ||
      !['active', 'waiting-first-frame', 'waiting-stream'].includes(this.state.value)
    )
      return false
    // 语聊 join resolve 时 Agora 的公开 connectionState getter 不保证已经同步为
    // CONNECTED；此时 engine 已将 active 设为权威状态。直播首帧恢复依赖原始
    // SDK 状态，因此继续保留更严格的 CONNECTED 校验。
    return this.context.mode === 'voice' || this.client.connectionState === 'CONNECTED'
  }

  hasRetainedRoom(roomId: string): boolean {
    return Boolean(this.context?.roomId === roomId && this.joined && this.client)
  }

  setPkPlaybackMuted(muted: boolean): void {
    this.pkPlaybackMuted = muted
    for (const user of this.pkClient?.remoteUsers ?? [])
      user.audioTrack?.setVolume(muted || this.playbackMuted ? 0 : 100)
  }

  async setCameraMuted(muted: boolean): Promise<void> {
    if (!this.videoTrack) return
    await this.videoTrack.setMuted(muted)
    this.cameraMuted.value = muted
  }

  async handleMemoryWarning(level: 'normal' | 'critical'): Promise<void> {
    if (level !== 'critical' || !this.client || !this.remoteVideo) return
    await this.client.setRemoteVideoStreamType(this.remoteVideo.uid, 1).catch(() => undefined)
  }

  private async performJoin(context: RoomLaunchContext, operationEpoch: number): Promise<void> {
    this.error.value = null
    this.context = context
    this.state.value = 'joining'
    this.metrics.value = {
      firstAudioAt: null,
      firstVideoAt: null,
      joinStartedAt: performance.now(),
      joinedAt: null,
    }

    // No App ID means this is an explicit UI-only preview. An empty token is
    // still a real Agora join in App ID-only test projects and maps to null.
    if (shouldUseRtcPreview(context)) {
      await new Promise((resolve) => window.setTimeout(resolve, 320))
      if (operationEpoch !== this.lifecycleEpoch) {
        await this.leave()
        return
      }
      this.metrics.value.joinedAt = performance.now()
      this.state.value = 'active'
      return
    }

    try {
      await this.warm()
      if (operationEpoch !== this.lifecycleEpoch) {
        await this.leave()
        return
      }
      const client = this.client
      if (!client) throw new Error('RTC client is unavailable.')

      await withRtcDeadline(
        client.setClientRole(context.role === 'audience' ? 'audience' : 'host'),
        RTC_OPERATION_TIMEOUT_MS,
        'RTC_SET_ROLE',
      )
      await this.prepareLocalPreview(context)
      if (operationEpoch !== this.lifecycleEpoch) {
        await this.leave()
        return
      }
      const joinTask = client.join(
        context.appId.trim(),
        context.channelName,
        rtcTokenForJoin(context.rtcToken),
        context.uid,
      )
      await withRtcDeadline(joinTask, RTC_JOIN_TIMEOUT_MS, 'RTC_JOIN').catch((cause: unknown) => {
        // Agora join 不能真正取消。超时后若 SDK 迟到加入成功，必须在脱离
        // 当前 engine 后再次 leave，不能让旧房频道留在后台。
        void joinTask.then(() => this.releaseSpecificClient(client)).catch(() => undefined)
        throw cause
      })
      this.joined = true
      const waitsForRemoteVideo = context.mode === 'live' && context.role === 'audience'
      this.state.value = waitsForRemoteVideo ? 'waiting-first-frame' : 'active'
      if (waitsForRemoteVideo && this.appVisible) this.scheduleFirstFrameTimeout(operationEpoch)
      if (operationEpoch !== this.lifecycleEpoch) {
        await this.leave()
        return
      }

      const publishTracks = [this.audioTrack, this.videoTrack].filter(Boolean) as Array<
        ILocalAudioTrack | ILocalVideoTrack
      >
      if (publishTracks.length) {
        if (context.mode === 'live' && this.videoTrack)
          await client.enableDualStream().catch(() => undefined)
        const publishTask = client.publish(publishTracks)
        await withRtcDeadline(publishTask, RTC_OPERATION_TIMEOUT_MS, 'RTC_PUBLISH').catch(
          (cause: unknown) => {
            void publishTask.then(() => this.releaseSpecificClient(client)).catch(() => undefined)
            throw cause
          },
        )
      }
      if (operationEpoch !== this.lifecycleEpoch) {
        await this.leave()
        return
      }

      this.metrics.value.joinedAt = performance.now()
      if (!waitsForRemoteVideo || this.metrics.value.firstVideoAt !== null)
        this.state.value = 'active'
      this.playLocalVideo()
    } catch (cause) {
      if (operationEpoch !== this.lifecycleEpoch) {
        await this.leave()
        return
      }
      const error = this.fail(cause, 'JOIN_FAILED')
      await this.performLeave('failed')
      this.client?.removeAllListeners()
      this.client = null
      throw error
    }
  }

  private async performPkJoin(context: PkRtcJoinContext, operationEpoch: number): Promise<void> {
    this.pkError.value = null
    this.pkState.value = 'joining'
    let candidate: IAgoraRTCClient | null = null
    if (!context.appId.trim() || !context.channelName.trim() || context.uid <= 0) {
      this.pkState.value = 'failed'
      this.pkError.value = new Error('PK_RTC_CONTEXT_INVALID')
      return
    }
    try {
      const sdk = await this.loadSdk()
      if (operationEpoch !== this.pkLifecycleEpoch) return
      await this.performPkLeave('idle', false)
      if (operationEpoch !== this.pkLifecycleEpoch) return
      const codecs = await sdk.getSupportedCodec().catch(() => ({ audio: [], video: [] }))
      const codec = codecs.video.map((value) => value.toLowerCase()).includes('h264')
        ? 'h264'
        : 'vp8'
      const client = sdk.createClient({ codec, mode: 'live' })
      candidate = client
      this.pkClient = client
      this.pkChannelName = context.channelName
      this.bindPkClient(client)
      await withRtcDeadline(
        client.setClientRole('audience'),
        RTC_OPERATION_TIMEOUT_MS,
        'PK_RTC_SET_ROLE',
      )
      if (operationEpoch !== this.pkLifecycleEpoch) {
        await this.releaseDetachedPkClient(client)
        return
      }
      const joinTask = client.join(
        context.appId.trim(),
        context.channelName,
        rtcTokenForJoin(context.rtcToken),
        context.uid,
      )
      await withRtcDeadline(joinTask, RTC_JOIN_TIMEOUT_MS, 'PK_RTC_JOIN').catch(
        (cause: unknown) => {
          void joinTask.then(() => this.releaseSpecificPkClient(client)).catch(() => undefined)
          throw cause
        },
      )
      if (operationEpoch !== this.pkLifecycleEpoch) {
        await this.releaseDetachedPkClient(client)
        return
      }
      this.pkJoined = true
      this.pkState.value = 'waiting-stream'
    } catch (cause) {
      if (operationEpoch !== this.pkLifecycleEpoch) {
        if (candidate) await this.releaseDetachedPkClient(candidate)
        return
      }
      this.pkError.value = normalizeRtcError(cause, 'PK_JOIN_FAILED')
      await this.performPkLeave('failed', false)
    }
  }

  private async releaseDetachedPkClient(client: IAgoraRTCClient): Promise<void> {
    await this.releaseSpecificPkClient(client)
    if (this.pkClient !== client) return
    this.pkClient = null
    this.pkJoined = false
    this.pkChannelName = ''
  }

  private releaseSpecificPkClient(client: IAgoraRTCClient): Promise<void> {
    const current = this.pkReleaseTasks.get(client)
    if (current) return current
    const task = (async () => {
      client.removeAllListeners()
      try {
        await withRtcDeadline(client.leave(), RTC_LEAVE_TIMEOUT_MS, 'PK_RTC_LEAVE').catch(
          () => undefined,
        )
      } finally {
        this.pkReleaseTasks.delete(client)
      }
    })()
    this.pkReleaseTasks.set(client, task)
    return task
  }

  private async performPkLeave(
    finalState: PkRoomEngineState = 'idle',
    clearChannel = true,
  ): Promise<void> {
    this.pkRemoteVideo?.track.stop()
    this.pkRemoteVideo = null
    this.pkRemoteVideoRenderState = null
    this.pkRemoteVideoContainer?.replaceChildren()
    const client = this.pkClient
    this.pkClient = null
    if (client) await this.releaseSpecificPkClient(client)
    this.pkJoined = false
    this.pkRenewPromise = null
    this.pkTokenProvider = null
    if (clearChannel) this.pkChannelName = ''
    this.pkState.value = finalState
  }

  private async performLeave(finalState: RoomEngineState = 'idle'): Promise<void> {
    this.clearConnectionFailureTimeout()
    this.clearFirstFrameTimeout()
    this.state.value = 'leaving'
    // PK owns a separate Agora client. Release it alongside the primary channel so
    // an active PK cannot add a full second leave timeout to every vertical switch.
    const pkRelease = withRtcDeadline(
      this.leavePkChannel(),
      RTC_LEAVE_TIMEOUT_MS,
      'PK_RTC_RELEASE',
    ).catch(() => undefined)
    await this.stopRoomMusic().catch(() => undefined)
    const tracks = [this.audioTrack, this.videoTrack].filter(Boolean) as Array<
      ILocalAudioTrack | ILocalVideoTrack
    >
    const client = this.client
    const wasJoined = this.joined
    if (tracks.length && client && wasJoined)
      await withRtcDeadline(
        client.unpublish(tracks),
        RTC_OPERATION_TIMEOUT_MS,
        'RTC_UNPUBLISH',
      ).catch(() => undefined)
    tracks.forEach((track) => {
      track.stop()
      track.close()
    })
    this.audioTrack = null
    this.videoTrack = null
    this.voicePublishing.value = false
    this.voicePublishingRequested = false
    this.microphoneMuted.value = false
    this.cameraMuted.value = false
    this.clearRemoteVideoFirstFrameBinding()
    this.remoteVideo?.track.stop()
    this.remoteVideo = null
    this.remoteVideoRenderState = null
    this.voiceRemoteVideos.forEach((track) => track.stop())
    this.voiceRemoteVideos.clear()
    this.voiceVideoRenderStates.clear()
    this.localVideoContainer?.replaceChildren()
    this.remoteVideoContainer?.replaceChildren()
    this.voiceVideoContainers.forEach((container) => container.replaceChildren())
    this.voiceVideoContainers.clear()
    this.activeSpeakers.value = []
    if (client && wasJoined) {
      const left = await withRtcDeadline(client.leave(), RTC_LEAVE_TIMEOUT_MS, 'RTC_LEAVE').then(
        () => true,
        () => false,
      )
      if (!left && this.client === client) {
        client.removeAllListeners()
        this.client = null
      }
    }
    this.joined = false
    this.streamFallbackUsers.clear()
    this.context = null
    this.renewPromise = null
    this.tokenProvider = null
    await pkRelease
    this.state.value = finalState
  }

  private trackFallbackOnce(client: IAgoraRTCClient, uid: UID): void {
    const fallbackKey = String(uid)
    if (this.streamFallbackUsers.has(fallbackKey)) return
    this.streamFallbackUsers.add(fallbackKey)
    void client.setStreamFallbackOption(uid, 2).catch(() => {
      this.streamFallbackUsers.delete(fallbackKey)
    })
  }

  private bindClient(client: IAgoraRTCClient): void {
    client.on('user-published', async (user: IAgoraRTCRemoteUser, mediaType: 'audio' | 'video') => {
      try {
        if (!this.isExpectedRemoteUser(user.uid)) return
        if (mediaType === 'audio') {
          await client.subscribe(user, mediaType)
        }
        if (mediaType === 'audio' && user.audioTrack && this.voiceSoundEnabled) {
          user.audioTrack.setVolume(this.playbackMuted ? 0 : 100)
          user.audioTrack.play()
          this.metrics.value.firstAudioAt ??= performance.now()
        }
        if (mediaType === 'video' && this.context?.mode === 'voice') {
          await client.subscribe(user, mediaType)
          if (user.videoTrack) {
            const key = String(user.uid)
            const current = this.voiceRemoteVideos.get(key)
            if (current !== user.videoTrack) {
              current?.stop()
              this.voiceRemoteVideos.set(key, user.videoTrack)
              this.voiceVideoRenderStates.delete(key)
              this.trackFallbackOnce(client, user.uid)
            }
            this.playVoiceVideo(key)
          }
        } else if (
          mediaType === 'video' &&
          this.context?.mode === 'live' &&
          (!this.remoteVideo || this.remoteVideo.uid === user.uid)
        ) {
          await client.subscribe(user, mediaType)
          if (
            user.videoTrack &&
            (!this.remoteVideo ||
              this.remoteVideo.uid !== user.uid ||
              this.remoteVideo.track !== user.videoTrack)
          ) {
            if (this.remoteVideo?.uid === user.uid && this.remoteVideo.track !== user.videoTrack) {
              this.clearRemoteVideoFirstFrameBinding()
              this.remoteVideo.track.stop()
            }
            this.remoteVideo = { track: user.videoTrack, uid: user.uid }
            this.remoteVideoRenderState = null
            this.bindRemoteVideoFirstFrame(user.videoTrack)
            this.trackFallbackOnce(client, user.uid)
            this.playRemoteVideo()
          }
        }
      } catch (cause) {
        this.fail(cause, 'SUBSCRIBE_FAILED')
      }
    })

    client.on('user-unpublished', (user, mediaType) => {
      if (!this.isExpectedRemoteUser(user.uid)) return
      if (mediaType === 'video' && this.context?.mode === 'voice') {
        const key = String(user.uid)
        this.voiceRemoteVideos.get(key)?.stop()
        this.voiceRemoteVideos.delete(key)
        this.voiceVideoRenderStates.delete(key)
        this.voiceVideoContainers.get(key)?.replaceChildren()
        this.streamFallbackUsers.delete(key)
      }
      if (mediaType === 'video' && this.remoteVideo?.uid === user.uid) {
        this.clearRemoteVideoFirstFrameBinding()
        this.remoteVideo.track.stop()
        this.remoteVideo = null
        this.remoteVideoRenderState = null
        this.streamFallbackUsers.delete(String(user.uid))
        if (this.joined && this.context?.mode === 'live') this.state.value = 'waiting-stream'
      }
    })

    client.on('user-left', (user) => {
      if (!this.isExpectedRemoteUser(user.uid)) return
      const voiceKey = String(user.uid)
      this.voiceRemoteVideos.get(voiceKey)?.stop()
      this.voiceRemoteVideos.delete(voiceKey)
      this.voiceVideoRenderStates.delete(voiceKey)
      this.voiceVideoContainers.get(voiceKey)?.replaceChildren()
      this.streamFallbackUsers.delete(voiceKey)
      if (this.remoteVideo?.uid === user.uid) {
        this.clearRemoteVideoFirstFrameBinding()
        this.remoteVideo.track.stop()
        this.remoteVideo = null
        this.remoteVideoRenderState = null
      }
      this.activeSpeakers.value = this.activeSpeakers.value.filter((uid) => uid !== user.uid)
      if (this.joined && this.context?.mode === 'live') this.state.value = 'stream-ended'
    })

    client.on('connection-state-change', (current) => {
      if (this.state.value === 'leaving') return
      if (current === 'RECONNECTING') {
        this.state.value = 'reconnecting'
        if (this.appVisible) this.scheduleConnectionFailureTimeout(client)
      } else if (current === 'CONNECTED' && this.joined) {
        this.clearConnectionFailureTimeout()
        this.error.value = null
        this.state.value =
          this.context?.mode === 'live' && !this.remoteVideo
            ? this.metrics.value.firstVideoAt === null
              ? 'waiting-first-frame'
              : 'waiting-stream'
            : 'active'
        if (this.appVisible) this.replayRemoteVideoSurfaces()
        if (
          this.appVisible &&
          this.state.value === 'waiting-first-frame' &&
          this.metrics.value.firstVideoAt === null
        )
          this.scheduleFirstFrameTimeout(this.lifecycleEpoch)
      } else if (current === 'DISCONNECTED' && this.joined) {
        this.state.value = 'reconnecting'
        if (this.appVisible) this.scheduleConnectionFailureTimeout(client)
      }
    })

    client.on('token-privilege-will-expire', () => {
      void this.renewToken().catch((cause) => {
        this.error.value = cause instanceof Error ? cause : new Error('RTC token renewal failed.')
      })
    })
    client.on('token-privilege-did-expire', () => {
      void this.renewToken().catch((cause) => this.fail(cause))
    })

    client.enableAudioVolumeIndicator()
    client.on('volume-indicator', (levels) => {
      this.activeSpeakers.value = levels
        .filter((level) => level.level >= 15)
        .slice(0, 4)
        .map((level) => level.uid)
    })
  }

  private bindPkClient(client: IAgoraRTCClient): void {
    client.on('user-published', async (user: IAgoraRTCRemoteUser, mediaType: 'audio' | 'video') => {
      try {
        await client.subscribe(user, mediaType)
        if (mediaType === 'audio') {
          user.audioTrack?.setVolume(this.playbackMuted || this.pkPlaybackMuted ? 0 : 100)
          user.audioTrack?.play()
        }
        if (mediaType !== 'video' || !user.videoTrack) return
        if (
          this.pkRemoteVideo &&
          this.pkRemoteVideo.uid === user.uid &&
          this.pkRemoteVideo.track === user.videoTrack
        ) {
          this.trackFallbackOnce(client, user.uid)
          this.playPkRemoteVideo()
          return
        }
        if (this.pkRemoteVideo && this.pkRemoteVideo.uid !== user.uid)
          this.pkRemoteVideo.track.stop()
        else if (this.pkRemoteVideo?.track !== user.videoTrack) this.pkRemoteVideo?.track.stop()
        this.pkRemoteVideo = { track: user.videoTrack, uid: user.uid }
        this.pkRemoteVideoRenderState = null
        user.videoTrack.on('first-frame-decoded', () => {
          if (this.pkJoined) this.pkState.value = 'active'
        })
        this.trackFallbackOnce(client, user.uid)
        this.playPkRemoteVideo()
      } catch (cause) {
        this.pkError.value = normalizeRtcError(cause, 'PK_SUBSCRIBE_FAILED')
        if (this.pkJoined) this.pkState.value = 'failed'
      }
    })
    client.on('user-unpublished', (user, mediaType) => {
      if (mediaType !== 'video' || this.pkRemoteVideo?.uid !== user.uid) return
      this.pkRemoteVideo.track.stop()
      this.pkRemoteVideo = null
      this.pkRemoteVideoRenderState = null
      this.streamFallbackUsers.delete(String(user.uid))
      if (this.pkJoined) this.pkState.value = 'waiting-stream'
    })
    client.on('user-left', (user) => {
      if (this.pkRemoteVideo?.uid === user.uid) {
        this.pkRemoteVideo.track.stop()
        this.pkRemoteVideo = null
        this.pkRemoteVideoRenderState = null
        this.streamFallbackUsers.delete(String(user.uid))
      }
      if (this.pkJoined) this.pkState.value = 'waiting-stream'
    })
    client.on('connection-state-change', (current) => {
      if (current === 'RECONNECTING') this.pkState.value = 'reconnecting'
      else if (current === 'CONNECTED' && this.pkJoined) {
        this.pkState.value = this.pkRemoteVideo ? 'active' : 'waiting-stream'
        if (this.appVisible) {
          this.pkRemoteVideoRenderState = null
          this.playPkRemoteVideo()
        }
      } else if (current === 'DISCONNECTED' && this.pkJoined) {
        this.pkError.value = new Error('PK_NETWORK_DISCONNECTED')
        this.pkJoined = false
        this.pkState.value = 'failed'
      }
    })
    client.on('token-privilege-will-expire', () => void this.renewPkToken())
    client.on('token-privilege-did-expire', () => void this.renewPkToken())
  }

  private playLocalVideo(): void {
    if (!this.localVideoContainer || !this.videoTrack) return
    this.videoTrack.play(this.localVideoContainer, { mirror: true })
  }

  private replayRemoteVideoSurfaces(): void {
    this.remoteVideoRenderState = null
    this.voiceVideoRenderStates.clear()
    this.pkRemoteVideoRenderState = null
    this.playRemoteVideo()
    this.voiceRemoteVideos.forEach((_track, uid) => this.playVoiceVideo(uid))
    this.playPkRemoteVideo()
  }

  private playRemoteVideo(): void {
    if (!this.remoteVideoContainer || !this.remoteVideo) return
    const container = this.remoteVideoContainer
    const track = this.remoteVideo.track
    const renderState = this.remoteVideoRenderState
    if (renderState && renderState.track === track && renderState.container === container) return
    this.remoteVideoRenderState = { track, container }
    track.play(container, { fit: 'cover' })
  }

  private playVoiceVideo(uid: string): void {
    const container = this.voiceVideoContainers.get(uid)
    const track = this.voiceRemoteVideos.get(uid)
    if (!container || !track) return
    const renderState = this.voiceVideoRenderStates.get(uid)
    if (renderState && renderState.track === track && renderState.container === container) return
    this.voiceVideoRenderStates.set(uid, { track, container })
    track.play(container, { fit: 'cover' })
  }

  private clearFirstFrameTimeout(): void {
    window.clearTimeout(this.firstFrameTimer)
    this.firstFrameTimer = 0
  }

  private acceptRemoteVideoFrame(): void {
    // firstVideoAt 只记录首次进房性能，不能阻断后续轨道恢复。主播从后台
    // 回来会重新发布轨道；每一次重新解出首帧都必须把 waiting-stream
    // 恢复成 active。旧站同样在每次首帧回调里恢复 LIVE 状态。
    this.metrics.value.firstVideoAt ??= performance.now()
    this.clearFirstFrameTimeout()
    if (this.joined) this.state.value = 'active'
  }

  private bindRemoteVideoFirstFrame(track: IRemoteVideoTrack): void {
    this.clearRemoteVideoFirstFrameBinding()
    const handler = () => this.acceptRemoteVideoFrame()
    this.remoteVideoFirstFrameBinding = { handler, track }
    track.on('first-frame-decoded', handler)
  }

  private clearRemoteVideoFirstFrameBinding(): void {
    const binding = this.remoteVideoFirstFrameBinding
    if (!binding) return
    binding.track.off('first-frame-decoded', binding.handler)
    this.remoteVideoFirstFrameBinding = null
  }

  private scheduleFirstFrameTimeout(operationEpoch: number): void {
    this.clearFirstFrameTimeout()
    this.firstFrameTimer = window.setTimeout(() => {
      this.firstFrameTimer = 0
      if (
        operationEpoch !== this.lifecycleEpoch ||
        !this.appVisible ||
        !this.joined ||
        this.metrics.value.firstVideoAt !== null ||
        this.state.value !== 'waiting-first-frame'
      )
        return
      this.fail(new Error('RTC_FIRST_FRAME_TIMEOUT'), 'RTC_FIRST_FRAME_TIMEOUT')
      this.lifecycleEpoch += 1
      if (this.leavePromise) return
      const task = this.performLeave('failed').finally(() => {
        if (this.leavePromise === task) this.leavePromise = null
      })
      this.leavePromise = task
    }, RTC_FIRST_FRAME_TIMEOUT_MS)
  }

  private playPkRemoteVideo(): void {
    if (!this.pkRemoteVideoContainer || !this.pkRemoteVideo) return
    const container = this.pkRemoteVideoContainer
    const track = this.pkRemoteVideo.track
    const renderState = this.pkRemoteVideoRenderState
    if (renderState && renderState.track === track && renderState.container === container) return
    this.pkRemoteVideoRenderState = { track, container }
    track.play(container, { fit: 'cover' })
  }

  private isExpectedRemoteUser(uid: UID): boolean {
    // 语聊房是多人音频频道，不能沿用直播间“只订阅主播”的过滤规则。
    if (this.context?.mode === 'voice') return true
    return isExpectedRemoteHost(this.context?.hostId, uid)
  }

  private async renewToken(): Promise<void> {
    if (this.renewPromise) return this.renewPromise
    if (!this.client || !this.context || !this.tokenProvider)
      throw new Error('RTC token renewal is unavailable.')
    this.renewPromise = (async () => {
      const token = await this.tokenProvider!(this.context!)
      await this.client!.renewToken(token)
      this.context = { ...this.context!, rtcToken: token }
    })()
    try {
      await this.renewPromise
    } finally {
      this.renewPromise = null
    }
  }

  private async renewPkToken(): Promise<void> {
    if (this.pkRenewPromise) return this.pkRenewPromise
    const client = this.pkClient
    const provider = this.pkTokenProvider
    if (!client || !provider || !this.pkJoined) return
    this.pkRenewPromise = (async () => {
      try {
        const token = await provider()
        if (client === this.pkClient && this.pkJoined) await client.renewToken(token)
      } catch (cause) {
        this.pkError.value = normalizeRtcError(cause, 'PK_TOKEN_RENEW_FAILED')
        this.pkJoined = false
        this.pkState.value = 'failed'
      }
    })()
    try {
      await this.pkRenewPromise
    } finally {
      this.pkRenewPromise = null
    }
  }

  private loadSdk(): Promise<RtcSdk> {
    if (this.sdk) return Promise.resolve(this.sdk)
    if (!this.loadPromise) {
      const rtcWindow = window as RtcWindow
      if (rtcWindow.AgoraRTC) {
        this.sdk = rtcWindow.AgoraRTC
        return Promise.resolve(rtcWindow.AgoraRTC)
      }

      this.loadPromise = new Promise<RtcSdk>((resolve, reject) => {
        const script = document.createElement('script')
        let settled = false
        script.src = resolveBundleUrl('assets/rtc.js')
        script.async = true
        script.dataset.socialRtcSdk = 'true'
        const finish = (cause?: Error): void => {
          if (settled) return
          settled = true
          window.clearTimeout(timer)
          script.removeEventListener('load', handleLoad)
          script.removeEventListener('error', handleError)
          if (cause) reject(cause)
          else if (!rtcWindow.AgoraRTC)
            reject(new Error('RTC SDK loaded without exposing AgoraRTC.'))
          else {
            this.sdk = rtcWindow.AgoraRTC
            resolve(rtcWindow.AgoraRTC)
          }
        }
        const handleLoad = (): void => finish()
        const handleError = (): void =>
          finish(new Error(`RTC SDK could not be loaded from ${script.src}.`))
        const timer = window.setTimeout(() => {
          script.remove()
          finish(new Error('RTC_SDK_LOAD_TIMEOUT'))
        }, RTC_SDK_LOAD_TIMEOUT_MS)
        script.addEventListener('load', handleLoad, { once: true })
        script.addEventListener('error', handleError, { once: true })
        document.head.append(script)
      }).catch((cause: unknown) => {
        this.loadPromise = null
        throw normalizeRtcError(cause, 'SDK_LOAD_FAILED')
      })
    }
    return this.loadPromise
  }

  private releaseSpecificClient(client: IAgoraRTCClient): Promise<void> {
    const current = this.releaseTasks.get(client)
    if (current) return current
    const task = (async () => {
      client.removeAllListeners()
      try {
        await withRtcDeadline(client.leave(), RTC_LEAVE_TIMEOUT_MS, 'RTC_LEAVE').catch(
          () => undefined,
        )
      } finally {
        this.releaseTasks.delete(client)
        if (this.client === client) this.client = null
      }
    })()
    this.releaseTasks.set(client, task)
    return task
  }

  private scheduleConnectionFailureTimeout(client: IAgoraRTCClient): void {
    this.clearConnectionFailureTimeout()
    this.connectionFailureTimer = window.setTimeout(() => {
      this.connectionFailureTimer = 0
      if (
        this.appVisible &&
        navigator.onLine !== false &&
        this.joined &&
        this.client === client &&
        client.connectionState !== 'CONNECTED'
      )
        this.fail(new Error('NETWORK_DISCONNECTED'))
    }, RTC_CONNECTION_FAILURE_GRACE_MS)
  }

  private clearConnectionFailureTimeout(): void {
    window.clearTimeout(this.connectionFailureTimer)
    this.connectionFailureTimer = 0
  }

  private fail(cause: unknown, fallbackCode = 'RTC_OPERATION_FAILED'): Error {
    this.clearConnectionFailureTimeout()
    const error = normalizeRtcError(cause, fallbackCode)
    this.error.value = error
    this.state.value = 'failed'
    return error
  }
}

export const rtcRoomEngine = new RtcRoomEngine()

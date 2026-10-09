import { appActivity, type AppActivitySnapshot, type AppLifecyclePhase } from './app-activity'

export type ApplicationRecoveryReason = 'foreground' | 'network-restored'

export interface ApplicationRecoveryContext {
  activity: AppActivitySnapshot
  backgroundDurationMs: number
  reason: ApplicationRecoveryReason
  recoveryEpoch: number
  signal: AbortSignal
}

export interface ApplicationSuspendContext {
  activity: AppActivitySnapshot
  phase: Extract<AppLifecyclePhase, 'background'>
  recoveryEpoch: number
  signal: AbortSignal
}

export interface ApplicationRecoveryParticipant {
  id: string
  onNetworkLost?: (activity: AppActivitySnapshot) => Promise<void> | void
  onRecover?: (context: ApplicationRecoveryContext) => Promise<void> | void
  onSuspend?: (context: ApplicationSuspendContext) => Promise<void> | void
  priority: number
}

/**
 * 全产品只有这里把 lifecycle/network 事实转换为恢复命令。参与者仍各自拥有状态机，
 * 协调器只保证顺序、单飞和“最后一次生命周期意图获胜”。
 */
class ApplicationRecoveryCoordinator {
  private controller: AbortController | null = null
  private frozen = false
  private installed = false
  private operation: Promise<void> = Promise.resolve()
  private readonly participants = new Map<string, ApplicationRecoveryParticipant>()
  private recoveryEpoch = 0
  private stopActivity: (() => void) | undefined

  install(): () => void {
    if (!this.installed) {
      this.installed = true
      this.stopActivity = appActivity.subscribe(this.handleActivity)
    }
    return () => this.dispose()
  }

  register(participant: ApplicationRecoveryParticipant): () => void {
    if (this.participants.has(participant.id))
      throw new Error(`Application recovery participant already exists: ${participant.id}`)
    this.participants.set(participant.id, participant)
    return () => {
      if (this.participants.get(participant.id) === participant)
        this.participants.delete(participant.id)
    }
  }

  setFrozen(frozen: boolean): void {
    this.frozen = frozen
    if (frozen) this.cancelCurrent('application-recovery-frozen')
  }

  private readonly handleActivity = (
    next: AppActivitySnapshot,
    previous: AppActivitySnapshot,
  ): void => {
    if (next.phase === 'inactive') return

    if (next.phase === 'background' && previous.phase !== 'background') {
      this.cancelCurrent('application-backgrounded')
      this.enqueueSuspend(next)
      return
    }

    if (!next.online && previous.online) {
      this.cancelCurrent('application-offline')
      this.enqueueNetworkLost(next)
      return
    }

    if (next.phase !== 'active' || !next.online || this.frozen) return
    const returnedFromBackground = next.foregroundEpoch > previous.foregroundEpoch
    const networkRestored = !previous.online && next.online
    if (!returnedFromBackground && !networkRestored) return
    this.enqueueRecover(next, previous, networkRestored ? 'network-restored' : 'foreground')
  }

  private enqueueSuspend(activity: AppActivitySnapshot): void {
    const { controller, epoch } = this.nextOperation()
    this.operation = this.operation
      .catch(() => undefined)
      .then(async () => {
        if (this.frozen || controller.signal.aborted) return
        const context: ApplicationSuspendContext = {
          activity,
          phase: 'background',
          recoveryEpoch: epoch,
          signal: controller.signal,
        }
        for (const participant of this.orderedParticipants()) {
          if (controller.signal.aborted) return
          await Promise.resolve(participant.onSuspend?.(context)).catch(() => undefined)
        }
      })
  }

  private enqueueNetworkLost(activity: AppActivitySnapshot): void {
    const { controller } = this.nextOperation()
    this.operation = this.operation
      .catch(() => undefined)
      .then(async () => {
        if (this.frozen || controller.signal.aborted) return
        for (const participant of this.orderedParticipants()) {
          if (controller.signal.aborted) return
          await Promise.resolve(participant.onNetworkLost?.(activity)).catch(() => undefined)
        }
      })
  }

  private enqueueRecover(
    activity: AppActivitySnapshot,
    previous: AppActivitySnapshot,
    reason: ApplicationRecoveryReason,
  ): void {
    const { controller, epoch } = this.nextOperation()
    const backgroundedAt = previous.backgroundedAt
    const context: ApplicationRecoveryContext = {
      activity,
      backgroundDurationMs:
        reason === 'foreground'
          ? backgroundedAt === null
            ? Number.POSITIVE_INFINITY
            : Math.max(0, Date.now() - backgroundedAt)
          : 0,
      reason,
      recoveryEpoch: epoch,
      signal: controller.signal,
    }
    this.operation = this.operation
      .catch(() => undefined)
      .then(async () => {
        if (this.frozen || controller.signal.aborted) return
        for (const participant of this.orderedParticipants()) {
          if (controller.signal.aborted || !appActivity.value.visible || !appActivity.value.online)
            return
          await Promise.resolve(participant.onRecover?.(context)).catch(() => undefined)
        }
      })
  }

  private nextOperation(): { controller: AbortController; epoch: number } {
    this.cancelCurrent('application-recovery-superseded')
    const controller = new AbortController()
    this.controller = controller
    this.recoveryEpoch += 1
    return { controller, epoch: this.recoveryEpoch }
  }

  private cancelCurrent(reason: string): void {
    if (!this.controller?.signal.aborted) this.controller?.abort(reason)
    this.controller = null
  }

  private orderedParticipants(): ApplicationRecoveryParticipant[] {
    return [...this.participants.values()].sort(
      (left, right) => left.priority - right.priority || left.id.localeCompare(right.id),
    )
  }

  private dispose(): void {
    if (!this.installed) return
    this.installed = false
    this.cancelCurrent('application-recovery-disposed')
    this.stopActivity?.()
    this.stopActivity = undefined
    this.participants.clear()
    this.operation = Promise.resolve()
  }
}

export const applicationRecoveryCoordinator = new ApplicationRecoveryCoordinator()

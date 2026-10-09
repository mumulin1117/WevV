export type PresenceBase = 'busy' | 'offline' | 'online'

export interface PresenceUpdate {
  base?: PresenceBase
  live?: boolean
  party?: boolean
  userId: string
}

export interface PresenceSnapshot {
  base?: PresenceBase
  live: boolean
  party: boolean
}

const snapshots = new Map<string, PresenceSnapshot>()
const listeners = new Set<(update: PresenceUpdate) => void>()

export function applyPresenceUpdate(update: PresenceUpdate): void {
  if (!update.userId) return
  const previous = snapshots.get(update.userId) ?? { live: false, party: false }
  const next: PresenceSnapshot = {
    ...previous,
    ...(update.base ? { base: update.base } : {}),
    ...(update.live !== undefined ? { live: update.live } : {}),
    ...(update.party !== undefined ? { party: update.party } : {}),
  }
  snapshots.set(update.userId, next)
  listeners.forEach((listener) => listener({ ...next, userId: update.userId }))
}

export function effectivePresence(userId: string): PresenceBase | undefined {
  const value = snapshots.get(userId)
  if (!value) return undefined
  if (value.live || value.party) return 'busy'
  return value.base
}

/**
 * 返回主播当前的三轴实时态。没有收到过推送时返回 undefined，调用方必须保留 REST 快照，
 * 不能把“未知”误判成离线。返回副本，避免页面意外改写全局单一真值源。
 */
export function presenceSnapshot(userId: string): PresenceSnapshot | undefined {
  const value = snapshots.get(userId)
  return value ? { ...value } : undefined
}

export function observePresence(listener: (update: PresenceUpdate) => void): () => void {
  listeners.add(listener)
  return () => listeners.delete(listener)
}

export function clearPresence(): void {
  snapshots.clear()
}

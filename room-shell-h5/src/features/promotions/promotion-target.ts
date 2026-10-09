export type PromotionTarget =
  | { kind: 'activity'; url: string }
  | { kind: 'external'; url: string }
  | { gameId: string; gameType: string; kind: 'game'; url: string }
  | { kind: 'game-center' }
  | { kind: 'party-room'; roomId: string }
  | { kind: 'profile'; userId: string }
  | { kind: 'recharge' }
  | { kind: 'unsupported' }
  | { kind: 'vip' }

const POSITIVE_INTEGER = /^\d+$/u

function parsedUrl(value: string): URL | null {
  try {
    return new URL(value, 'https://promotion.invalid')
  } catch {
    return null
  }
}

function positiveQueryValue(url: URL, key: string): string {
  const values = url.searchParams.getAll(key)
  const value = values.at(-1)?.trim() ?? ''
  return POSITIVE_INTEGER.test(value) && Number(value) > 0 ? value : ''
}

export function isActivityPromotionUrl(value: string): boolean {
  const source = value.trim()
  if (!source) return false
  if (source.includes('isHuanNiuH5')) return true
  const url = parsedUrl(source)
  return Boolean(
    url &&
    url.hostname.toLocaleLowerCase().includes('hn-activity') &&
    url.pathname.includes('/activity-center'),
  )
}

export function resolvePromotionTarget(directUrl: string, clickType?: number): PromotionTarget {
  const source = directUrl.trim()
  if (!source) return { kind: 'unsupported' }
  if (source === 'gameCenter') return { kind: 'game-center' }

  const url = parsedUrl(source)
  if (!url) return { kind: 'unsupported' }

  const partyRoomId = positiveQueryValue(url, 'partyRoomId')
  if (partyRoomId) return { kind: 'party-room', roomId: partyRoomId }
  if (isActivityPromotionUrl(source)) return { kind: 'activity', url: source }
  if (source.includes('rechargeService') || url.pathname === '/gems') return { kind: 'recharge' }

  if (source.includes('isHuanNiuOwnH5')) {
    if (url.pathname === '/vip') return { kind: 'vip' }
    if (url.pathname === '/gameCenter') return { kind: 'game-center' }
    if (url.pathname === '/detail') {
      const userId = positiveQueryValue(url, 'id')
      return userId ? { kind: 'profile', userId } : { kind: 'unsupported' }
    }
    return { kind: 'unsupported' }
  }

  if (!['http:', 'https:'].includes(url.protocol)) return { kind: 'unsupported' }
  const gameId = url.searchParams.get('gameId')?.trim() ?? ''
  const gameType = url.searchParams.get('gameType')?.trim().toLocaleLowerCase() ?? ''
  if (gameId && gameType) return { gameId, gameType, kind: 'game', url: source }
  if (clickType === 1 || url.protocol === 'https:') return { kind: 'external', url: source }
  return { kind: 'unsupported' }
}

export function activityFrameUrl(source: string, hideBack = false): string {
  try {
    const url = new URL(source)
    for (const key of ['roomId', 'roomType', 'reportParams']) url.searchParams.delete(key)
    if (hideBack) url.searchParams.set('hideBack', '1')
    return url.toString()
  } catch {
    return source.trim()
  }
}

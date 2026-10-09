export type RoomType = 'live' | 'voice'

export interface RoomEntry {
  appVersion: string
  deviceNo: string
  locale: string
  roomId: string
  roomType: RoomType
  token: string
  userId: string
}

export class RoomEntryError extends Error {
  constructor(message: string) {
    super(message)
    this.name = 'RoomEntryError'
  }
}

let currentEntry: RoomEntry | undefined

function routeUrl(): URL {
  const raw = window.location.hash.replace(/^#/u, '') || '/'
  return new URL(raw, 'https://room.invalid')
}

function versionParts(value: string): number[] | null {
  if (!/^\d+(?:\.\d+){0,3}$/u.test(value)) return null
  return value.split('.').map(Number)
}

function isVersionAtLeast(actual: string, minimum: string): boolean {
  const left = versionParts(actual)
  const right = versionParts(minimum)
  if (!left || !right) return false
  for (let index = 0; index < Math.max(left.length, right.length); index += 1) {
    const difference = (left[index] ?? 0) - (right[index] ?? 0)
    if (difference !== 0) return difference > 0
  }
  return true
}

export function readRoomEntry(defaultLocale: string, minimumHostVersion = '0'): RoomEntry {
  const url = routeUrl()
  const match = url.pathname.match(/^\/(live|voice)\/([1-9]\d*)$/u)
  if (!match) throw new RoomEntryError('Use #/live/{roomId} or #/voice/{roomId}.')
  const token = url.searchParams.get('token')?.trim() ?? ''
  const userId = url.searchParams.get('userId')?.trim() ?? ''
  const appVersion = url.searchParams.get('appVersion')?.trim() ?? ''
  const deviceNo = url.searchParams.get('deviceNo')?.trim() ?? ''
  const locale = url.searchParams.get('locale')?.trim() || defaultLocale
  if (!token || token.length > 16_384) throw new RoomEntryError('A valid token is required.')
  if (!/^[1-9]\d*$/u.test(userId) || !Number.isSafeInteger(Number(userId)))
    throw new RoomEntryError('A valid userId is required.')
  if (!appVersion || appVersion.length > 32)
    throw new RoomEntryError('A valid appVersion is required.')
  if (!isVersionAtLeast(appVersion, minimumHostVersion))
    throw new RoomEntryError(`Native app ${minimumHostVersion} or later is required.`)
  if (!deviceNo || deviceNo.length > 128) throw new RoomEntryError('A valid deviceNo is required.')
  if (locale.length > 16) throw new RoomEntryError('The locale is invalid.')
  return {
    appVersion,
    deviceNo,
    locale,
    roomId: match[2]!,
    roomType: match[1] as RoomType,
    token,
    userId,
  }
}

export function initializeRoomEntry(defaultLocale: string, minimumHostVersion = '0'): RoomEntry {
  currentEntry = readRoomEntry(defaultLocale, minimumHostVersion)
  scrubRoomToken()
  return currentEntry
}

export function getRoomEntry(): RoomEntry {
  if (!currentEntry) throw new RoomEntryError('The room entry is not initialized.')
  return currentEntry
}

/** Remove only the secret; keep the route and non-sensitive diagnostics in the URL. */
export function scrubRoomToken(): void {
  const url = routeUrl()
  if (!url.searchParams.has('token')) return
  url.searchParams.delete('token')
  const query = url.searchParams.toString()
  history.replaceState(
    null,
    '',
    `${window.location.pathname}${window.location.search}#${url.pathname}${query ? `?${query}` : ''}`,
  )
}

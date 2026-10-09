import { ref, shallowRef } from 'vue'
import { ungzip } from 'pako'
import { createId } from '@/shared/id'
import type {
  ChatroomTextContext,
  ChatroomConnectionState,
  ChatroomRuntime,
  ChatroomSdkClient,
  ChatroomSdkMessage,
  LiveChatMessage,
  LiveChatroomConnectInput,
  LiveEntryEffect,
  LiveRoomMetricsPatch,
  LivePkPush,
  LiveWheelResultMessage,
  LiveWheelSignal,
} from './chatroom-contracts'
import { getNimChatroomSession } from '@/features/messages/nim-session'
import type { LivePkRankItem } from './live-pk-contracts'

const DEFAULT_MESSAGE_LIMIT = 60
const LIVE_GIFT_ATTACH_TYPES = new Set([50, 66, 88, 89, 1007])
const PARTY_COMPRESSED_GIFT_ATTACH_TYPE = 2049
const PK_CONTROL_ATTACH_TYPES = new Set([-9, -8, 97, 98, 99, 100, 101])
const GIFT_ICON_KEYS = ['smallImg', 'giftSmallImg', 'giftIcon', 'giftImg', 'icon'] as const
const GIFT_EFFECT_KEYS = [
  'animUrl',
  'svgaUrl',
  'mp4Url',
  'giftEffect',
  'bigGift',
  'giftImg',
  'giftIcon',
] as const
const TERMINAL_KICK_REASONS = new Set([1, 2, 3, 5])
const ENTRY_EFFECT_ATTACH_TYPES = new Set([80, 1004])
const LIVE_WHEEL_ATTACH_TYPES = new Set([72, 73])
const PARTY_BUSINESS_ATTACH_TYPES = new Set([
  197, 1001, 1003, 1008, 1009, 1011, 1012, 1013, 1015, 1016, 1017, 1018, 1019, 1021, 1024, 1025,
  1050, 1051,
])
const CHATROOM_ENTER_TIMEOUT_MS = 12_000
const CHATROOM_HISTORY_TIMEOUT_MS = 8_000
const CHATROOM_EXIT_TIMEOUT_MS = 4_000

function withChatroomDeadline<T>(task: Promise<T>, timeout: number, operation: string): Promise<T> {
  return new Promise<T>((resolve, reject) => {
    let settled = false
    const timer = setTimeout(() => {
      if (settled) return
      settled = true
      reject(new Error(`${operation}_TIMEOUT`))
    }, timeout)
    task.then(
      (value) => {
        if (settled) return
        settled = true
        clearTimeout(timer)
        resolve(value)
      },
      (cause: unknown) => {
        if (settled) return
        settled = true
        clearTimeout(timer)
        reject(cause)
      },
    )
  })
}

async function exitChatroomClient(client: ChatroomSdkClient): Promise<void> {
  await withChatroomDeadline(
    Promise.resolve(client.exit()),
    CHATROOM_EXIT_TIMEOUT_MS,
    'CHATROOM_EXIT',
  ).catch(() => undefined)
}

function parseRecord(value: unknown): Record<string, unknown> {
  if (!value) return {}
  if (typeof value === 'object' && !Array.isArray(value)) return value as Record<string, unknown>
  if (typeof value !== 'string') return {}
  try {
    const parsed = JSON.parse(value) as unknown
    return typeof parsed === 'object' && parsed !== null && !Array.isArray(parsed)
      ? (parsed as Record<string, unknown>)
      : {}
  } catch {
    return {}
  }
}

function setNonEmptyString(
  extension: Record<string, boolean | number | string>,
  key: string,
  value: string | undefined,
): void {
  const normalized = value?.trim()
  if (normalized) extension[key] = normalized
}

function memberExtension(input: LiveChatroomConnectInput): string {
  const extension: Record<string, boolean | number | string> = {}
  setNonEmptyString(extension, 'userId', input.user.id)
  setNonEmptyString(extension, 'nickname', input.user.displayName)
  setNonEmptyString(extension, 'icon', input.user.avatarUrl)
  setNonEmptyString(extension, 'yxAccid', input.credential.imAccount)
  setNonEmptyString(extension, 'userLevel', input.user.userLevel)
  if (typeof input.user.isVip === 'boolean') extension.isVip = input.user.isVip
  return JSON.stringify(extension)
}

function textExtension(input: LiveChatroomConnectInput, context: ChatroomTextContext): string {
  const extension: Record<string, boolean | number | string> = {}
  setNonEmptyString(extension, 'userId', input.user.id)
  setNonEmptyString(extension, 'nickname', input.user.displayName)
  setNonEmptyString(extension, 'avatar', input.user.avatarUrl)
  setNonEmptyString(extension, 'userLevel', input.user.userLevel)
  if (typeof input.user.isVip === 'boolean') extension.isVip = input.user.isVip
  if (context.role !== undefined) extension.role = context.role
  if (typeof context.isPlatformAdmin === 'boolean')
    extension.isPlatformAdmin = context.isPlatformAdmin
  return JSON.stringify(extension)
}

const MESSAGE_TEXT_KEYS = ['text', 'content', 'body', 'message', 'value', 'raw', 'data'] as const

function messageText(value: unknown, depth = 0, visited = new Set<object>()): string {
  if (depth > 5 || value === null || value === undefined) return ''
  if (typeof value === 'string') {
    const text = value.trim()
    if (!text) return ''
    if (text.startsWith('{') || text.startsWith('[')) {
      try {
        const nested = messageText(JSON.parse(text) as unknown, depth + 1, visited)
        if (nested) return nested
      } catch {
        // A normal chat message may start with a brace. Keep the original text.
      }
    }
    return text
  }
  if (value instanceof Uint8Array) return new TextDecoder().decode(value).trim()
  if (value instanceof ArrayBuffer) return new TextDecoder().decode(new Uint8Array(value)).trim()
  if (Array.isArray(value)) {
    if (value.length && value.every((item) => Number.isInteger(item) && item >= 0 && item <= 255))
      return new TextDecoder().decode(new Uint8Array(value as number[])).trim()
    for (const candidate of value) {
      const text = messageText(candidate, depth + 1, visited)
      if (text) return text
    }
    return ''
  }
  if (typeof value !== 'object' || visited.has(value)) return ''
  visited.add(value)

  const record = value as Record<string, unknown>
  for (const key of MESSAGE_TEXT_KEYS) {
    const text = messageText(record[key], depth + 1, visited)
    if (text) return text
  }

  const values = Object.values(record)
  if (
    values.length &&
    values.every(
      (item) => typeof item === 'number' && Number.isInteger(item) && item >= 0 && item <= 255,
    )
  )
    return new TextDecoder().decode(new Uint8Array(values as number[])).trim()
  if (values.length === 1) {
    const text = messageText(values[0], depth + 1, visited)
    if (text) return text
  }

  const rendered = String(value).trim()
  return rendered && rendered !== '[object Object]' ? rendered : ''
}

function textMessage(message: ChatroomSdkMessage): LiveChatMessage | null {
  if (message.messageType !== 0) return null
  const text = messageText(message.text) || messageText(message.attachment?.raw)
  if (!text) return null
  const extension = messageExtension(message)
  const metadata = { ...extension, ...extensionData(extension) }
  return {
    avatarUrl:
      message.userInfoConfig?.senderAvatar ?? firstString(metadata, ['avatar', 'icon', 'headIcon']),
    chatBubbleUrl: firstString(metadata, ['chatBubble']) || undefined,
    createdAt: message.createTime,
    guardianLevel: firstNullableInteger(metadata, ['guardianLevel', 'guardianLevelCode']),
    id: message.messageClientId,
    host: false,
    kind: 'text',
    newUser: firstBoolean(metadata, ['isNewUser']),
    nickname:
      message.userInfoConfig?.senderNick ?? firstString(metadata, ['nickname', 'nick', 'fromNick']),
    own: message.isSelf,
    platformAdmin: firstBoolean(metadata, ['isPlatformAdmin']),
    roomRole: firstRoomRole(metadata),
    senderId: message.senderId,
    state: message.isSelf ? 'sent' : 'received',
    text,
    userId: firstIdentifier(metadata, ['userId', 'uid']) || undefined,
    userLevel: firstUserLevel(metadata, ['userLevel', 'level']),
    vip: firstBoolean(metadata, ['isVip', 'vip']),
  }
}

function wheelResultMessage(message: ChatroomSdkMessage): LiveChatMessage | null {
  if (message.messageType !== 0) return null
  const extension = messageExtension(message)
  const metadata = { ...extension, ...extensionData(extension) }
  if (firstString(metadata, ['type']).toLocaleLowerCase() !== 'wheelres') return null
  const text = messageText(message.text) || messageText(message.attachment?.raw)
  if (!text) return null
  const anchorId = firstIdentifier(metadata, ['anchorId'])
  const sectorCount = firstNullableInteger(metadata, ['number'])
  const price = firstNullableInteger(metadata, ['dia'])
  const income = firstNullableInteger(metadata, ['incomeDiamondNum'])
  return {
    activityType: 'wheel-result',
    avatarUrl:
      message.userInfoConfig?.senderAvatar ?? firstString(metadata, ['avatar', 'icon', 'headIcon']),
    createdAt: message.createTime,
    id: message.messageClientId,
    kind: 'text',
    nickname: message.userInfoConfig?.senderNick ?? firstString(metadata, ['nickname', 'nick']),
    own: message.isSelf,
    senderId: message.senderId,
    state: message.isSelf ? 'sent' : 'received',
    text,
    ...(anchorId ? { wheelAnchorId: anchorId } : {}),
    ...(income !== undefined ? { wheelIncome: income } : {}),
    ...(price !== undefined ? { wheelPrice: price } : {}),
    ...(sectorCount !== undefined ? { wheelSectorCount: sectorCount } : {}),
  }
}

function firstString(record: Record<string, unknown>, keys: readonly string[]): string {
  for (const key of keys) {
    const value = record[key]
    if (typeof value === 'string' && value.trim()) return value.trim()
  }
  return ''
}

function firstPositiveInteger(
  record: Record<string, unknown>,
  keys: readonly string[],
): number | undefined {
  for (const key of keys) {
    const value = Number(record[key])
    if (Number.isFinite(value)) return Math.max(1, Math.trunc(value))
  }
  return undefined
}

function firstIdentifier(record: Record<string, unknown>, keys: readonly string[]): string {
  for (const key of keys) {
    const value = record[key]
    if (typeof value === 'string' && value.trim()) return value.trim()
    if (typeof value === 'number' && Number.isFinite(value)) return String(value)
  }
  return ''
}

function giftReceivers(
  record: Record<string, unknown>,
): NonNullable<LiveChatMessage['giftReceivers']> {
  if (!Array.isArray(record.receiveUserList)) return []
  const result = new Map<string, NonNullable<LiveChatMessage['giftReceivers']>[number]>()
  for (const value of record.receiveUserList) {
    const receiver = parseRecord(value)
    const id = firstIdentifier(receiver, ['userId', 'id'])
    if (!id || result.has(id)) continue
    result.set(id, {
      avatarUrl: firstString(receiver, ['icon', 'avatar']),
      id,
      name: firstString(receiver, ['nickname', 'nickName', 'name']),
    })
  }
  return [...result.values()]
}

function giftReceiverIds(record: Record<string, unknown>): string[] {
  return giftReceivers(record).map((receiver) => receiver.id)
}

function mediaUrlList(value: unknown): string[] {
  let list = value
  if (typeof value === 'string') {
    try {
      list = JSON.parse(value) as unknown
    } catch {
      list = [value]
    }
  }
  if (!Array.isArray(list)) return []
  return [
    ...new Set(
      list
        .map((item) =>
          typeof item === 'string'
            ? item.trim()
            : firstString(parseRecord(item), ['icon', 'imgUrl', 'imageUrl', 'url']),
        )
        .filter(Boolean),
    ),
  ]
}

function extensionData(extension: Record<string, unknown>): Record<string, unknown> {
  const nested = parseRecord(extension.data)
  return Object.keys(nested).length ? nested : extension
}

function decodeGzipBase64RecordSync(value: unknown): Record<string, unknown> | null {
  if (typeof value !== 'string' || !value.trim()) return null
  const plain = parseRecord(value)
  if (Object.keys(plain).length) return plain
  try {
    const binary = atob(value.trim())
    const bytes = Uint8Array.from(binary, (character) => character.charCodeAt(0))
    const decoded = new TextDecoder().decode(ungzip(bytes))
    const result = parseRecord(decoded)
    return Object.keys(result).length ? result : null
  } catch {
    return null
  }
}

function isEffectUrl(value: string): boolean {
  return /\.(?:mp4|svga)(?:[?#]|$)/iu.test(value.trim())
}

function firstEffectUrl(record: Record<string, unknown>): string {
  for (const key of GIFT_EFFECT_KEYS) {
    const candidate = firstString(record, [key])
    if (isEffectUrl(candidate)) return candidate
  }
  return ''
}

function firstGiftIconUrl(record: Record<string, unknown>): string {
  for (const key of GIFT_ICON_KEYS) {
    const candidate = firstString(record, [key])
    if (candidate && !isEffectUrl(candidate)) return candidate
  }
  return ''
}

async function decodeGzipBase64Record(value: unknown): Promise<Record<string, unknown> | null> {
  if (typeof value !== 'string' || !value.trim()) return null
  const plain = parseRecord(value)
  if (Object.keys(plain).length) return plain
  try {
    const binary = atob(value.trim())
    const bytes = Uint8Array.from(binary, (character) => character.charCodeAt(0))
    let decoded = ''
    if (typeof DecompressionStream !== 'undefined') {
      try {
        const stream = new Blob([bytes]).stream().pipeThrough(new DecompressionStream('gzip'))
        decoded = await new Response(stream).text()
      } catch {
        decoded = new TextDecoder().decode(ungzip(bytes))
      }
    } else decoded = new TextDecoder().decode(ungzip(bytes))
    const result = parseRecord(decoded)
    return Object.keys(result).length ? result : null
  } catch {
    return null
  }
}

function compressedPartyGiftMessage(
  message: ChatroomSdkMessage,
  data: Record<string, unknown>,
  hostImAccount: string | undefined,
): LiveChatMessage | null {
  const sendUser = parseRecord(data.sendUser)
  const giftId = firstIdentifier(data, ['giftId', 'id'])
  if (!giftId) return null
  const giftName = firstString(data, ['giftName', 'name']) || 'Gift'
  const giftIconUrl = firstGiftIconUrl(data)
  const giftEffectUrl = firstEffectUrl(data)
  const receivers = giftReceivers(data)
  const giftType = firstNullableInteger(data, ['giftTypeV2', 'giftType'])
  const nickname =
    firstString(sendUser, ['nickname', 'nickName', 'name']) ||
    message.userInfoConfig?.senderNick?.trim() ||
    message.senderId ||
    '—'
  const userId =
    firstIdentifier(sendUser, ['userId', 'id']) ||
    firstIdentifier(data, ['userId', 'senderId']) ||
    message.senderId
  return {
    avatarUrl:
      firstString(sendUser, ['icon', 'avatar']) ||
      message.userInfoConfig?.senderAvatar?.trim() ||
      '',
    createdAt: message.createTime,
    giftCount: firstPositiveInteger(data, ['giftNum', 'num', 'count']) ?? 1,
    giftEffectUrl,
    giftId,
    giftIconUrl,
    giftName,
    giftMysteryBox: firstBoolean(data, ['mysteryBoxFlag']) === true,
    giftReceiverIds: receivers.map((receiver) => receiver.id),
    giftReceivers: receivers,
    giftType,
    giftValue: firstNullableInteger(data, ['gems', 'giftValue']),
    giftCost: firstNullableInteger(data, ['cost']),
    host: Boolean(hostImAccount && message.senderId === hostImAccount),
    id: message.messageClientId,
    kind: 'gift',
    nickname,
    own: false,
    medalUrls: mediaUrlList(sendUser.medalList ?? data.userMedals),
    platformAdmin: message.isPlatformAdmin ?? firstBoolean(data, ['isPlatformAdmin']),
    roomRole: firstRoomRole(data),
    senderHeadFrameUrl: firstString(sendUser, ['avatar', 'headFrame', 'headSmallFrame']),
    senderId: userId,
    state: 'received',
    text: `sent ${giftName}`,
    userId,
    userLevel: firstUserLevel(sendUser, ['levelName', 'userLevel', 'level']),
    userType: firstNullableInteger(sendUser, ['userType']),
    vip: firstBoolean(data, ['isVip']) ?? firstBoolean(sendUser, ['isVip', 'vip']),
  }
}

function booleanValue(value: unknown): boolean {
  if (typeof value === 'boolean') return value
  if (typeof value === 'number') return value !== 0
  if (typeof value === 'string') return value === '1' || value.toLowerCase() === 'true'
  return false
}

function firstBoolean(
  record: Record<string, unknown>,
  keys: readonly string[],
): boolean | undefined {
  for (const key of keys) {
    if (record[key] !== undefined && record[key] !== null) return booleanValue(record[key])
  }
  return undefined
}

function entryEffectMessage(message: ChatroomSdkMessage): LiveEntryEffect | null {
  const extension = messageExtension(message)
  const attachType = Number(extension.attachType)
  if (!ENTRY_EFFECT_ATTACH_TYPES.has(attachType)) return null
  const party = attachType === 1004
  const data = extensionData(extension)
  const nickname =
    firstString(data, ['username', 'nickname', 'nick']) ||
    message.userInfoConfig?.senderNick?.trim() ||
    message.senderId.trim()
  if (!nickname) return null

  const rawList = data.list
  let list: unknown[] = []
  if (Array.isArray(rawList)) list = rawList
  else if (typeof rawList === 'string') {
    try {
      const parsed = JSON.parse(rawList) as unknown
      if (Array.isArray(parsed)) list = parsed
    } catch {
      list = []
    }
  }
  const items = list.map((item) => parseRecord(item))
  const vehicle = items.find(
    (item) =>
      Number(item.itemType) === 1 &&
      (!party || Math.max(0, Number(item.guardianLevel) || 0) === 0) &&
      isEffectUrl(firstString(item, ['itemImg'])),
  )
  const entrance = party
    ? undefined
    : items.find(
        (item) => Number(item.itemType) === 3 && isEffectUrl(firstString(item, ['itemImg'])),
      )
  const media = vehicle ?? entrance
  const guardianLevel = firstNullableInteger(data, ['guardianLevel', 'guardianLevelCode'])
  const userLevel = Math.max(0, Math.trunc(Number(data.userLevel) || 0))
  if (party && !vehicle) return null
  if (!party && !media && !guardianLevel && !userLevel) return null
  const style = vehicle
    ? 'vehicle'
    : entrance
      ? 'entrance'
      : guardianLevel
        ? 'guardian'
        : 'high-level'
  const priority =
    (party && guardianLevel) || style === 'guardian'
      ? 300 + Math.min(99, guardianLevel ?? 0)
      : style === 'vehicle' || style === 'entrance'
        ? 200
        : 100 + Math.min(99, userLevel)

  return {
    avatarUrl: firstString(data, ['icon']),
    ...(media ? { effectUrl: firstString(media, ['itemImg']) } : {}),
    ...(guardianLevel ? { guardianLevel } : {}),
    id: message.messageClientId,
    nickname,
    priority,
    style,
    userId: firstIdentifier(data, ['userId', 'id']) || message.senderId,
    userLevel,
    vip: booleanValue(data.isVip),
  }
}

function customMessage(
  message: ChatroomSdkMessage,
  hostImAccount: string | undefined,
  selfImAccount: string,
): LiveChatMessage | null {
  const extension = messageExtension(message)
  const attachType = Number(extension.attachType)
  if (PK_CONTROL_ATTACH_TYPES.has(attachType)) {
    if (attachType !== -9) return null
    const data = extensionData(extension)
    const text = firstString(data, ['content', 'text', 'msg'])
      .replace(/<[^>]*>/gu, ' ')
      .replace(/\s+/gu, ' ')
      .trim()
    if (!text) return null
    return {
      avatarUrl: '',
      createdAt: message.createTime,
      id: message.messageClientId,
      kind: 'announcement',
      nickname: 'PK',
      own: false,
      senderId: message.senderId,
      state: 'received',
      text,
    }
  }
  if (attachType === 1050 || attachType === 1051) {
    const data = extensionData(extension)
    const luckyNumber = Number(data.luckyNumber)
    const senderId = firstIdentifier(data, ['userId', 'senderId']) || message.senderId
    return {
      activityType: attachType === 1051 ? 'lucky-number-win' : 'lucky-number-draw',
      avatarUrl:
        firstString(data, ['userAvatar', 'avatar', 'icon']) ||
        message.userInfoConfig?.senderAvatar?.trim() ||
        '',
      createdAt: message.createTime,
      id: message.messageClientId,
      kind: 'activity',
      luckyNumber: Number.isFinite(luckyNumber) ? luckyNumber : undefined,
      nickname:
        firstString(data, ['fromNick', 'nickname', 'nick']) ||
        message.userInfoConfig?.senderNick?.trim() ||
        senderId ||
        '—',
      own: senderId === selfImAccount,
      senderId,
      state: 'received',
      text: attachType === 1051 ? 'Successfully matched the lucky number' : 'Lucky number',
    }
  }
  if (message.senderId === selfImAccount) return null
  if (!LIVE_GIFT_ATTACH_TYPES.has(attachType)) return null

  const data = extensionData(extension)
  const giftIconUrl = firstGiftIconUrl(data) || firstGiftIconUrl(extension)
  const giftEffectUrl = firstEffectUrl(data) || firstEffectUrl(extension)
  const giftName =
    firstString(data, ['giftName', 'name', 'giftTitle']) ||
    firstString(extension, ['giftName', 'name', 'giftTitle']) ||
    'Gift'
  const giftId =
    firstIdentifier(data, ['giftId', 'id']) || firstIdentifier(extension, ['giftId', 'id'])
  const nickname =
    message.userInfoConfig?.senderNick?.trim() ||
    firstString(extension, ['nickname', 'nick']) ||
    message.senderId ||
    '—'
  const userId =
    firstIdentifier(data, ['userId', 'senderId']) ||
    firstIdentifier(extension, ['userId', 'senderId']) ||
    message.senderId
  return {
    avatarUrl:
      message.userInfoConfig?.senderAvatar?.trim() ||
      firstString(extension, ['avatar', 'icon', 'headIcon']),
    createdAt: message.createTime,
    giftCount:
      firstPositiveInteger(data, ['giftNum', 'num', 'count']) ??
      firstPositiveInteger(extension, ['giftNum', 'num', 'count']) ??
      1,
    giftEffectUrl,
    giftId,
    giftIconUrl,
    giftName,
    giftReceiverIds: giftReceiverIds(data),
    giftValue:
      firstNullableInteger(data, ['gems', 'giftValue']) ??
      firstNullableInteger(extension, ['gems', 'giftValue']),
    giftCost: firstNullableInteger(data, ['cost']) ?? firstNullableInteger(extension, ['cost']),
    host: Boolean(hostImAccount && message.senderId === hostImAccount),
    id: message.messageClientId,
    kind: 'gift',
    nickname,
    own: false,
    senderId: userId,
    state: 'received',
    text: messageText(message.text) || 'sent a gift',
    userId,
  }
}

function announcementMessage(message: ChatroomSdkMessage): LiveChatMessage | null {
  if (message.messageType !== 100) return null
  const extension = parseRecord(message.serverExtension)
  if (Number(extension.attachType) !== 195) return null
  const data = parseRecord(extension.data)
  const text = typeof data.text === 'string' ? data.text.trim() : ''
  if (!text) return null
  return {
    avatarUrl: '',
    createdAt: message.createTime,
    id: message.messageClientId,
    kind: 'announcement',
    nickname: '',
    own: false,
    senderId: message.senderId,
    state: 'received',
    text,
  }
}

function messageExtension(message: ChatroomSdkMessage): Record<string, unknown> {
  const server = parseRecord(message.serverExtension)
  if (Object.keys(server).length) return server
  const text = parseRecord(message.text)
  if (Object.keys(text).length) return text
  return parseRecord(message.attachment?.raw)
}

function wheelSignal(message: ChatroomSdkMessage): LiveWheelSignal | null {
  const extension = messageExtension(message)
  const data = extensionData(extension)
  const attachType = Number(extension.attachType ?? data.attachType)
  if (!LIVE_WHEEL_ATTACH_TYPES.has(attachType)) return null
  return {
    anchorId:
      firstIdentifier(data, ['anchorId', 'userId']) || firstIdentifier(extension, ['anchorId']),
    enabled: attachType === 72,
  }
}

function isGiftMessage(message: ChatroomSdkMessage): boolean {
  const extension = messageExtension(message)
  return (
    LIVE_GIFT_ATTACH_TYPES.has(Number(extension.attachType)) &&
    JSON.stringify(extension).toLowerCase().includes('"giftid"')
  )
}

function firstNullableInteger(
  record: Record<string, unknown>,
  keys: readonly string[],
): number | undefined {
  for (const key of keys) {
    const raw = record[key]
    if (raw === null || raw === undefined || raw === '') continue
    const value = Number(raw)
    if (Number.isFinite(value)) return Math.max(0, Math.trunc(value))
  }
  return undefined
}

function userLevelValue(raw: unknown): number | undefined {
  if (raw === null || raw === undefined || raw === '') return undefined
  const normalized = typeof raw === 'string' ? raw.trim() : raw
  if (normalized === '') return undefined
  const direct = Number(normalized)
  if (Number.isFinite(direct)) return Math.max(0, Math.trunc(direct))
  if (typeof normalized !== 'string') return undefined
  const matched = normalized.match(/\d+/u)?.[0]
  return matched ? Math.max(0, Number.parseInt(matched, 10)) : undefined
}

function firstUserLevel(
  record: Record<string, unknown>,
  keys: readonly string[],
): number | undefined {
  for (const key of keys) {
    const value = userLevelValue(record[key])
    if (value !== undefined) return value
  }
  return undefined
}

function firstRoomRole(record: Record<string, unknown>): 1 | 2 | 3 | undefined {
  const value = firstNullableInteger(record, ['role', 'roomRoleType'])
  return value === 1 || value === 2 || value === 3 ? value : undefined
}

function recordList(value: unknown): readonly Record<string, unknown>[] | null {
  let parsed = value
  if (typeof parsed === 'string') {
    try {
      parsed = JSON.parse(parsed) as unknown
    } catch {
      return null
    }
  }
  if (Array.isArray(parsed)) return parsed.map(parseRecord)
  const record = parseRecord(parsed)
  return Object.keys(record).length ? [record] : null
}

function liveTopGiverUpdate(
  value: unknown,
): NonNullable<LiveRoomMetricsPatch['topGiver']> | null | undefined {
  const rows = recordList(value)
  if (!rows) return undefined
  if (rows.length === 0) return null
  const giver = rows[0] ?? {}
  const giverId = firstIdentifier(giver, ['userId', 'id'])
  const giverAvatar = firstString(giver, ['icon', 'avatar', 'userIcon'])
  const giverCost = firstNullableInteger(giver, ['cost', 'score', 'costNum'])
  const normalizedGiverId = giverId === '0' ? '' : giverId
  if (giverCost === undefined || giverCost <= 0 || (!normalizedGiverId && !giverAvatar))
    return undefined
  return { avatarUrl: giverAvatar, cost: giverCost, id: normalizedGiverId }
}

function liveMetricsPatch(message: ChatroomSdkMessage): LiveRoomMetricsPatch | null {
  const extension = messageExtension(message)
  const attachType = Number(extension.attachType)
  if (![50, 56, 66, 71, 88, 89, 96, 170].includes(attachType)) return null
  const data = extensionData(extension)
  const patch: LiveRoomMetricsPatch = {}
  const hotScore = firstNullableInteger(data, ['hotScore'])
  if (hotScore !== undefined) patch.hotScore = hotScore
  if (attachType === 170) {
    const total = firstNullableInteger(data, ['totalContribution', 'currentLiveIncome'])
    if (total !== undefined) patch.incomeTotal = total
  } else {
    const delta = firstNullableInteger(data, ['realNum', 'income', 'contribution'])
    if (delta !== undefined && delta > 0) patch.incomeDelta = delta
  }
  if (attachType === 50 || attachType === 56) {
    const hasTopList = Object.prototype.hasOwnProperty.call(data, 'msg')
    const topGiver = liveTopGiverUpdate(hasTopList ? data.msg : attachType === 56 ? [] : undefined)
    if (topGiver !== undefined) patch.topGiver = topGiver
  }
  const giftId = firstIdentifier(data, ['giftId', 'id'])
  const completed = firstNullableInteger(data, ['compelteGiftNum', 'completeGiftNum'])
  if (giftId && completed !== undefined) patch.wish = { completed, giftId }
  return Object.keys(patch).length ? patch : null
}

function parsePkRankItem(value: unknown): LivePkRankItem | null {
  const item = parseRecord(value)
  const id = firstIdentifier(item, ['anchorId', 'userId', 'id'])
  const avatarUrl = firstString(item, ['avatar', 'icon', 'headIcon'])
  const nickname = firstString(item, ['nickName', 'nickname', 'name'])
  if (!id && !avatarUrl && !nickname) return null
  return {
    avatarUrl,
    countryCode: firstString(item, ['countryId', 'countryCode']),
    contribution: firstNullableInteger(item, ['contribution', 'pkCounter', 'score']) ?? 0,
    id,
    levelName: firstString(item, ['userLevelName', 'levelName', 'userLevel']),
    nickname,
    vip: firstBoolean(item, ['vipFlag', 'isVip', 'vip']) ?? false,
  }
}

function parsePkRankItems(
  record: Record<string, unknown>,
  keys: readonly string[],
): readonly LivePkRankItem[] | undefined {
  for (const key of keys) {
    const value = record[key]
    if (!Array.isArray(value)) continue
    return value.map(parsePkRankItem).filter((item): item is LivePkRankItem => Boolean(item))
  }
  return undefined
}

function parsePkPush(message: ChatroomSdkMessage, attachType: 98 | 100): LivePkPush | null {
  const extension = messageExtension(message)
  if (Number(extension.attachType) !== attachType) return null
  const data = extensionData(extension)
  const opponent = parseRecord(data.oppositePkInfoVo)
  const status = firstNullableInteger(data, ['pkStatus', 'status'])
  if (attachType === 100 && status === undefined) return null
  const duration = firstNullableInteger(data, ['pkDuration', 'pkPunishingDuration'])
  const remainSeconds = firstNullableInteger(data, ['remainSeconds'])
  const leftTop3 = parsePkRankItems(data, ['top3Users', 'top3RankList', 'leftTop3'])
  const rightTop3 =
    parsePkRankItems(data, ['oppositeTop3Users', 'rightTop3']) ??
    parsePkRankItems(opponent, ['top3Users', 'top3RankList'])
  return {
    leftAgoraChannelId: firstString(data, ['leftAgoraChannelId']) || undefined,
    leftAvatarUrl: firstString(data, ['leftAvatar', 'leftAvatarUrl']) || undefined,
    leftName: firstString(data, ['leftName']) || undefined,
    leftScore: firstNullableInteger(data, ['pkCounter', 'leftScore', 'anchorScore', 'myScore']),
    leftTop3,
    leftUserId: firstIdentifier(data, ['leftUserId']) || undefined,
    pkId: firstString(data, ['pkId', 'id']) || firstString(opponent, ['pkId', 'id']) || undefined,
    remainSeconds:
      remainSeconds ??
      (duration === undefined
        ? undefined
        : duration > 1_000
          ? Math.trunc(duration / 1_000)
          : duration),
    rightAgoraChannelId:
      firstString(data, ['rightAgoraChannelId', 'oppositeAgoraChannelId']) ||
      firstString(opponent, ['agoraChannelId', 'channelName']) ||
      undefined,
    rightAvatarUrl:
      firstString(data, ['rightAvatar', 'oppositeAvatar']) ||
      firstString(opponent, ['icon', 'avatar']) ||
      undefined,
    rightName:
      firstString(data, ['rightName', 'oppositeName']) ||
      firstString(opponent, ['nickname', 'nickName', 'name']) ||
      undefined,
    rightRoomId:
      firstIdentifier(data, ['rightRoomId', 'oppositeRoomId']) ||
      firstIdentifier(opponent, ['roomId']) ||
      undefined,
    rightScore:
      firstNullableInteger(data, ['oppositePkCounter', 'rightScore', 'opponentScore']) ??
      firstNullableInteger(opponent, ['pkCounter', 'score']),
    rightTop3,
    rightUserId:
      firstIdentifier(data, ['rightUserId', 'oppositeAnchorId']) ||
      firstIdentifier(opponent, ['anchorId', 'userId', 'id']) ||
      undefined,
    status: status ?? 0,
  }
}

function kickedReason(value: unknown): number | undefined {
  if (!value || typeof value !== 'object') return undefined
  const reason = Number((value as { kickedReason?: unknown }).kickedReason)
  return Number.isFinite(reason) ? reason : undefined
}

export class LiveChatroomController {
  readonly entryEffect = shallowRef<LiveEntryEffect | null>(null)
  readonly entryEffectRevision = ref(0)
  readonly error = shallowRef<Error | null>(null)
  readonly giftRevision = ref(0)
  readonly hostExitRevision = ref(0)
  readonly latestGift = shallowRef<LiveChatMessage | null>(null)
  readonly latestMetrics = shallowRef<LiveRoomMetricsPatch | null>(null)
  readonly metricsRevision = ref(0)
  readonly latestBusiness = shallowRef<{
    attachType: number
    createdAt: number
    data: Record<string, unknown>
    id: string
  } | null>(null)
  readonly latestWheelSignal = shallowRef<LiveWheelSignal | null>(null)
  readonly wheelSignalRevision = ref(0)
  readonly pkRankPush = shallowRef<LivePkPush | null>(null)
  readonly pkRankRevision = ref(0)
  readonly pkStatusPush = shallowRef<LivePkPush | null>(null)
  readonly pkStatusRevision = ref(0)
  readonly businessRevision = ref(0)
  readonly messages = shallowRef<LiveChatMessage[]>([])
  readonly muted = ref(false)
  readonly onlineCount = ref(0)
  readonly roomMuted = ref(false)
  readonly state = ref<ChatroomConnectionState>('closed')

  private client: ChatroomSdkClient | null = null
  private simulated = false
  private connectGeneration = 0
  private historyGeneration = 0
  private input: LiveChatroomConnectInput | null = null
  private readonly listeners: Array<{
    event: string
    listener: (...args: unknown[]) => void
    target: 'client' | 'service'
  }> = []
  private readonly notificationIds = new Set<string>()
  private readonly metricsMessageIds = new Set<string>()
  private readonly wheelSignalMessageIds = new Set<string>()

  constructor(private readonly runtime: ChatroomRuntime = getNimChatroomSession()) {}

  async connect(input: LiveChatroomConnectInput): Promise<void> {
    this.simulated = false
    const generation = ++this.connectGeneration
    const historyGeneration = ++this.historyGeneration
    const reconnectingSameRoom = this.input?.roomId === input.roomId
    await this.releaseClient()
    this.input = input
    this.error.value = null
    if (!reconnectingSameRoom) {
      this.clearEntryEffects()
      this.giftRevision.value = 0
      this.hostExitRevision.value = 0
      this.latestGift.value = null
      this.latestMetrics.value = null
      this.metricsRevision.value = 0
      this.latestWheelSignal.value = null
      this.wheelSignalRevision.value = 0
      this.pkRankPush.value = null
      this.pkRankRevision.value = 0
      this.pkStatusPush.value = null
      this.pkStatusRevision.value = 0
      this.messages.value = []
      this.notificationIds.clear()
      this.metricsMessageIds.clear()
      this.wheelSignalMessageIds.clear()
    }
    this.muted.value = false
    this.onlineCount.value = Math.max(0, input.initialOnlineCount)
    this.roomMuted.value = false
    this.state.value = 'connecting'

    try {
      await this.runtime.login(input.credential)
      if (generation !== this.connectGeneration) return
      const client = this.runtime.createClient()
      this.client = client
      this.bindListeners(client, generation)
      const identityExtension = memberExtension(input)
      const enterTask = Promise.resolve(
        client.enter(input.roomId, {
          accountId: input.credential.imAccount,
          linkProvider: () => this.runtime.getLinkAddresses(input.roomId),
          notificationExtension: identityExtension,
          roomAvatar: input.user.avatarUrl,
          roomNick: input.user.displayName,
          serverExtension: identityExtension,
          ...(input.tags?.length ? { tagConfig: { tags: input.tags } } : {}),
          token: input.credential.imToken,
        }),
      )
      const result = await withChatroomDeadline(
        enterTask,
        CHATROOM_ENTER_TIMEOUT_MS,
        'CHATROOM_ENTER',
      ).catch((cause: unknown) => {
        // enter 超时后 SDK 仍可能迟到成功。当前 client 会先从控制器解绑，
        // 迟到结果随后再补一次 exit，避免幽灵房间继续收消息或占用连接。
        void enterTask
          .then(() => {
            if (this.client !== client || generation !== this.connectGeneration)
              void exitChatroomClient(client)
          })
          .catch(() => undefined)
        throw cause
      })
      if (generation !== this.connectGeneration) {
        await exitChatroomClient(client)
        return
      }
      // 直播间顶栏展示的是观众数，不包含主播本人；语聊房仍展示聊天室总人数。
      // 后续 MEMBER_ENTER / MEMBER_EXIT 使用相同口径做增量维护。
      this.onlineCount.value = Math.max(
        0,
        result.chatroom.onlineUserCount - (input.excludeHostFromOnlineCount ? 1 : 0),
      )
      this.roomMuted.value = Boolean(result.chatroom.chatBanned)
      if (!reconnectingSameRoom && input.historyLimit)
        await withChatroomDeadline(
          this.loadHistory(client, generation, historyGeneration, input.historyLimit),
          CHATROOM_HISTORY_TIMEOUT_MS,
          'CHATROOM_HISTORY',
        ).catch(() => {
          if (historyGeneration === this.historyGeneration) this.historyGeneration += 1
        })
      if (!reconnectingSameRoom && input.welcomeMessage?.text.trim())
        this.upsert({
          avatarUrl: input.welcomeMessage.avatarUrl,
          createdAt: Date.now(),
          id: `host-welcome:${input.roomId}:${Date.now()}`,
          kind: 'text',
          mentionCurrentUser: true,
          nickname: input.welcomeMessage.nickname,
          own: false,
          senderId: input.welcomeMessage.senderId,
          state: 'received',
          text: input.welcomeMessage.text.trim(),
        })
      if (!reconnectingSameRoom && input.announcementText?.trim())
        this.upsert({
          avatarUrl: '',
          createdAt: Date.now(),
          id: `welcome:${input.roomId}`,
          kind: 'announcement',
          nickname: '',
          own: false,
          senderId: input.hostImAccount ?? '',
          state: 'received',
          text: input.announcementText.trim(),
        })
      if (generation === this.connectGeneration && !this.wasKicked()) {
        this.state.value = 'connected'
      }
    } catch (cause) {
      if (generation !== this.connectGeneration) return
      this.error.value = cause instanceof Error ? cause : new Error(String(cause))
      this.state.value = 'failed'
      this.connectGeneration += 1
      await this.releaseClient()
    }
  }

  async connectLocal(
    input: Omit<LiveChatroomConnectInput, 'credential'> & {
      initialMessages?: readonly LiveChatMessage[]
    },
  ): Promise<void> {
    ++this.connectGeneration
    ++this.historyGeneration
    await this.releaseClient()
    this.simulated = true
    this.input = {
      ...input,
      credential: {
        imAccount: input.user.id || `review-${input.roomId}`,
        imToken: 'local-room',
      },
    }
    this.error.value = null
    this.muted.value = false
    this.roomMuted.value = false
    this.onlineCount.value = Math.max(0, input.initialOnlineCount)
    this.messages.value = [...(input.initialMessages ?? [])].sort(
      (left, right) => left.createdAt - right.createdAt,
    )
    if (input.welcomeMessage?.text.trim())
      this.upsert({
        avatarUrl: input.welcomeMessage.avatarUrl,
        createdAt: Date.now() - 1_000,
        id: `host-welcome:${input.roomId}`,
        kind: 'text',
        mentionCurrentUser: true,
        nickname: input.welcomeMessage.nickname,
        own: false,
        senderId: input.welcomeMessage.senderId,
        state: 'received',
        text: input.welcomeMessage.text.trim(),
      })
    if (input.announcementText?.trim())
      this.upsert({
        avatarUrl: '',
        createdAt: Date.now() - 2_000,
        id: `welcome:${input.roomId}`,
        kind: 'announcement',
        nickname: '',
        own: false,
        senderId: input.hostImAccount ?? '',
        state: 'received',
        text: input.announcementText.trim(),
      })
    this.state.value = 'connected'
  }

  async close(): Promise<void> {
    ++this.connectGeneration
    ++this.historyGeneration
    this.input = null
    this.simulated = false
    await this.releaseClient()
    this.messages.value = []
    this.notificationIds.clear()
    this.metricsMessageIds.clear()
    this.wheelSignalMessageIds.clear()
    this.clearEntryEffects()
    this.giftRevision.value = 0
    this.hostExitRevision.value = 0
    this.latestGift.value = null
    this.latestMetrics.value = null
    this.metricsRevision.value = 0
    this.latestWheelSignal.value = null
    this.wheelSignalRevision.value = 0
    this.pkRankPush.value = null
    this.pkRankRevision.value = 0
    this.pkStatusPush.value = null
    this.pkStatusRevision.value = 0
    this.error.value = null
    this.state.value = 'closed'
  }

  clearEntryEffects(): void {
    this.clearEntryEffectsInternal()
  }

  async retry(): Promise<void> {
    const input = this.input
    if (!input) return
    await this.connect(input)
  }

  async retryMessage(id: string): Promise<void> {
    const failed = this.messages.value.find(
      (message) => message.id === id && message.state === 'failed',
    )
    if (!failed) return
    this.messages.value = this.messages.value.filter((message) => message.id !== id)
    await this.sendText(failed.text)
  }

  removeMessage(id: string): void {
    if (!id) return
    this.messages.value = this.messages.value.filter((message) => message.id !== id)
  }

  async sendText(value: string, context: ChatroomTextContext = {}): Promise<void> {
    const text = value.trim()
    const input = this.input
    const client = this.client
    if (text && input && this.simulated && this.state.value === 'connected') {
      const ownLevel = userLevelValue(input.user.userLevel)
      this.upsert({
        avatarUrl: input.user.avatarUrl,
        createdAt: Date.now(),
        id: createId('chat'),
        kind: 'text',
        nickname: input.user.displayName,
        own: true,
        ...(typeof context.isPlatformAdmin === 'boolean'
          ? { platformAdmin: context.isPlatformAdmin }
          : {}),
        ...(context.role !== undefined ? { roomRole: context.role } : {}),
        senderId: input.credential.imAccount,
        state: 'sent',
        text,
        ...(input.user.id.trim() ? { userId: input.user.id.trim() } : {}),
        ...(ownLevel !== undefined ? { userLevel: ownLevel } : {}),
        ...(typeof input.user.isVip === 'boolean' ? { vip: input.user.isVip } : {}),
      })
      return
    }
    if (!text || !input || !client || this.state.value !== 'connected')
      throw new Error('CHATROOM_NOT_CONNECTED')
    if (this.muted.value || this.roomMuted.value) throw new Error('CHATROOM_MUTED')

    const sdkMessage = client.V2NIMChatroomMessageCreator.createTextMessage(text)
    sdkMessage.serverExtension = textExtension(input, context)
    const ownLevel = userLevelValue(input.user.userLevel)
    const optimistic: LiveChatMessage = {
      avatarUrl: input.user.avatarUrl,
      createdAt: sdkMessage.createTime || Date.now(),
      id: sdkMessage.messageClientId || createId('chat'),
      kind: 'text',
      nickname: input.user.displayName,
      own: true,
      ...(typeof context.isPlatformAdmin === 'boolean'
        ? { platformAdmin: context.isPlatformAdmin }
        : {}),
      ...(context.role !== undefined ? { roomRole: context.role } : {}),
      senderId: input.credential.imAccount,
      state: 'sending',
      text,
      ...(input.user.id.trim() ? { userId: input.user.id.trim() } : {}),
      ...(ownLevel !== undefined ? { userLevel: ownLevel } : {}),
      ...(typeof input.user.isVip === 'boolean' ? { vip: input.user.isVip } : {}),
    }
    this.upsert(optimistic)

    try {
      const result = await client.V2NIMChatroomService.sendMessage(sdkMessage)
      const delivered = textMessage(result.message)
      this.upsert({
        ...(delivered ?? optimistic),
        id: optimistic.id,
        nickname: input.user.displayName,
        own: true,
        state: 'sent',
      })
    } catch (cause) {
      this.upsert({ ...optimistic, state: 'failed' })
      throw cause
    }
  }

  appendPersistedMessage(message: LiveChatMessage): void {
    if (!this.simulated || this.state.value !== 'connected')
      throw new Error('CHATROOM_NOT_CONNECTED')
    this.upsert(message)
  }

  async sendWheelResult(result: LiveWheelResultMessage): Promise<void> {
    const input = this.input
    const client = this.client
    const text = result.text.trim()
    if (!text || this.state.value !== 'connected') throw new Error('CHATROOM_NOT_CONNECTED')
    if (!input || !client) throw new Error('CHATROOM_NOT_CONNECTED')

    const sdkMessage = client.V2NIMChatroomMessageCreator.createTextMessage(text)
    sdkMessage.serverExtension = JSON.stringify({
      ...parseRecord(textExtension(input, {})),
      anchorId: result.anchorId,
      dia: Math.max(0, result.dia),
      fromNick: input.user.displayName,
      incomeDiamondNum: Math.max(0, result.incomeDiamondNum),
      number: Math.max(0, result.number),
      type: 'wheelRes',
    })
    const optimisticId = sdkMessage.messageClientId || createId('wheel-result')
    const response = await client.V2NIMChatroomService.sendMessage(sdkMessage)
    if (this.input !== input || this.client !== client || this.state.value !== 'connected') return
    const delivered = response?.message ? wheelResultMessage(response.message) : null
    this.upsert({
      ...(delivered ?? {
        activityType: 'wheel-result',
        avatarUrl: input.user.avatarUrl,
        createdAt: sdkMessage.createTime || Date.now(),
        id: optimisticId,
        kind: 'text' as const,
        nickname: input.user.displayName,
        own: true,
        senderId: input.credential.imAccount,
        state: 'sent' as const,
        text,
        wheelAnchorId: result.anchorId,
        wheelIncome: Math.max(0, result.incomeDiamondNum),
        wheelPrice: Math.max(0, result.dia),
        wheelSectorCount: Math.max(0, result.number),
      }),
      id: optimisticId,
      own: true,
      state: 'sent',
    })
  }

  async sendCustom(attachType: number, data: Record<string, unknown>): Promise<void> {
    if (this.simulated && this.state.value === 'connected') return
    const input = this.input
    const client = this.client
    if (!input || !client || this.state.value !== 'connected')
      throw new Error('CHATROOM_NOT_CONNECTED')
    const creator = client.V2NIMChatroomMessageCreator
    if (!creator.createCustomMessage) throw new Error('CHATROOM_CUSTOM_MESSAGE_UNSUPPORTED')
    // NIM Creator 的方法依赖实例上下文，不能解构后脱离对象调用。
    const sdkMessage = creator.createCustomMessage(
      JSON.stringify({ attachType, data: JSON.stringify(data) }),
    )
    sdkMessage.serverExtension = JSON.stringify({ attachType, data: JSON.stringify(data) })
    await client.V2NIMChatroomService.sendMessage(sdkMessage)
  }

  appendLocalGift(input: {
    avatarUrl: string
    count: number
    giftEffectUrl?: string
    giftId: string
    giftIconUrl: string
    giftMysteryBox?: boolean
    giftName: string
    giftReceivers?: NonNullable<LiveChatMessage['giftReceivers']>
    giftType?: number
    headFrameUrl?: string
    medalUrls?: string[]
    nickname: string
    platformAdmin?: boolean
    receiverIds?: string[]
    roomRole?: 1 | 2 | 3
    senderId: string
    userLevel?: number
    userType?: number
    value?: number
    vip?: boolean
  }): void {
    const account = this.input?.credential.imAccount || input.senderId.trim()
    if (!account) return
    const gift: LiveChatMessage = {
      avatarUrl: input.avatarUrl,
      createdAt: Date.now(),
      giftCount: Math.max(1, Math.trunc(input.count)),
      giftEffectUrl: isEffectUrl(input.giftEffectUrl ?? '') ? input.giftEffectUrl : '',
      giftId: input.giftId,
      giftIconUrl: input.giftIconUrl,
      giftMysteryBox: input.giftMysteryBox,
      giftName: input.giftName,
      giftReceiverIds: input.receiverIds,
      giftReceivers: input.giftReceivers,
      giftType: input.giftType,
      giftValue: input.value,
      giftCost:
        input.value === undefined
          ? undefined
          : input.value * Math.max(1, input.receiverIds?.length ?? 1),
      host: false,
      id: createId('gift'),
      kind: 'gift',
      nickname: input.nickname || 'Me',
      medalUrls: input.medalUrls,
      own: true,
      platformAdmin: input.platformAdmin,
      roomRole: input.roomRole,
      senderHeadFrameUrl: input.headFrameUrl,
      senderId: account,
      state: 'sent',
      text: `sent ${input.giftName}`,
      userLevel: input.userLevel,
      userType: input.userType,
      vip: input.vip,
    }
    this.upsert(gift)
    this.latestGift.value = gift
  }

  appendLocalEntry(input: {
    avatarUrl: string
    nickname: string
    userId: string
    userLevel?: number
    vip?: boolean
  }): void {
    const userId = input.userId.trim()
    if (!userId || this.state.value !== 'connected') return
    const entry: LiveChatMessage = {
      avatarUrl: input.avatarUrl,
      createdAt: Date.now(),
      id: createId('enter'),
      kind: 'enter',
      nickname: input.nickname.trim() || 'Someone',
      own: true,
      senderId: this.input?.credential.imAccount || userId,
      state: 'sent',
      text: 'Entered Room!',
      userId,
      userLevel: Math.max(0, Math.trunc(input.userLevel ?? 0)),
      vip: input.vip,
    }
    this.upsert(entry)
    this.pushEntryEffect({
      avatarUrl: entry.avatarUrl,
      id: entry.id,
      nickname: entry.nickname,
      priority: 100 + (entry.userLevel ?? 0),
      style: (entry.userLevel ?? 0) >= 20 ? 'high-level' : 'entrance',
      userId,
      userLevel: entry.userLevel ?? 0,
      vip: entry.vip === true,
    })
  }

  setAppVisible(visible: boolean): void {
    if (this.simulated) return
    this.runtime.setAppVisible(visible)
  }

  private bindListeners(client: ChatroomSdkClient, generation: number): void {
    const receive = (value: unknown) => {
      if (generation !== this.connectGeneration) return
      if (!Array.isArray(value)) return
      const messages = value as ChatroomSdkMessage[]
      messages.forEach((message) => this.receive(message))
    }
    const status = (value: unknown) => {
      if (generation !== this.connectGeneration) return
      if (typeof value !== 'number') return
      if (value === 5) {
        this.state.value = 'connected'
      } else if ([0, 1, 2, 3, 4].includes(value)) this.state.value = 'reconnecting'
    }
    const kicked = (value: unknown) => {
      if (generation !== this.connectGeneration) return
      const reason = kickedReason(value)
      if (reason !== undefined && TERMINAL_KICK_REASONS.has(reason)) {
        this.state.value = 'kicked'
        return
      }
      // 非终态踢出也不能由页面主动重新 enter。保留当前控制器，等待 SDK
      // 后续 status=5 原位恢复；若没有恢复，则只允许用户点击 Retry。
      this.error.value = new Error('CHATROOM_CONNECTION_INTERRUPTED')
      this.state.value = 'failed'
    }
    const exited = () => {
      if (generation !== this.connectGeneration || this.state.value === 'kicked') return
      this.error.value = new Error('CHATROOM_EXITED')
      this.state.value = 'failed'
    }
    const selfMuted = (value: unknown) => {
      if (typeof value !== 'boolean') return
      if (generation === this.connectGeneration) this.muted.value = value
    }
    const selfTempMuted = (value: unknown) => {
      if (typeof value !== 'boolean') return
      if (generation === this.connectGeneration) this.muted.value = value
    }
    const roomMuted = (value: unknown) => {
      if (typeof value !== 'boolean') return
      if (generation === this.connectGeneration) this.roomMuted.value = value
    }

    this.listen(client, 'client', 'onChatroomStatus', status)
    this.listen(client, 'client', 'onChatroomKicked', kicked)
    this.listen(client, 'client', 'onChatroomExited', exited)
    this.listen(client.V2NIMChatroomService, 'service', 'onReceiveMessages', receive)
    this.listen(client.V2NIMChatroomService, 'service', 'onSelfChatBannedUpdated', selfMuted)
    this.listen(
      client.V2NIMChatroomService,
      'service',
      'onSelfTempChatBannedUpdated',
      selfTempMuted,
    )
    this.listen(client.V2NIMChatroomService, 'service', 'onChatroomChatBannedUpdated', roomMuted)
  }

  private listen(
    emitter: ChatroomSdkClient | ChatroomSdkClient['V2NIMChatroomService'],
    target: 'client' | 'service',
    event: string,
    listener: (...args: unknown[]) => void,
  ): void {
    emitter.on(event, listener)
    this.listeners.push({ event, listener, target })
  }

  private async loadHistory(
    client: ChatroomSdkClient,
    generation: number,
    historyGeneration: number,
    limit: number,
    retriesLeft = 1,
  ): Promise<void> {
    const history = await client.V2NIMChatroomService.getMessageList({
      beginTime: 0,
      direction: 0,
      limit: Math.max(1, Math.min(100, Math.trunc(limit))),
      messageTypes: [0],
    })
    if (generation !== this.connectGeneration || historyGeneration !== this.historyGeneration)
      return
    if (history.length === 0 && retriesLeft > 0) {
      await new Promise<void>((resolve) => window.setTimeout(resolve, 1_000))
      if (generation !== this.connectGeneration || historyGeneration !== this.historyGeneration)
        return
      await this.loadHistory(client, generation, historyGeneration, limit, retriesLeft - 1)
      return
    }
    history.reverse().forEach((message) => {
      const parsed = wheelResultMessage(message) ?? textMessage(message)
      if (parsed) this.upsert(parsed)
    })
  }

  private receive(message: ChatroomSdkMessage): void {
    if (!this.input || message.roomId !== this.input.roomId) return
    const extension = messageExtension(message)
    const attachType = Number(extension.attachType)
    const wheel = wheelSignal(message)
    if (wheel) {
      if (this.wheelSignalMessageIds.has(message.messageClientId)) return
      this.wheelSignalMessageIds.add(message.messageClientId)
      if (this.wheelSignalMessageIds.size > 100) {
        const oldest = this.wheelSignalMessageIds.values().next().value
        if (oldest) this.wheelSignalMessageIds.delete(oldest)
      }
      this.latestWheelSignal.value = wheel
      this.wheelSignalRevision.value += 1
      return
    }
    if (!this.metricsMessageIds.has(message.messageClientId)) {
      const metrics = liveMetricsPatch(message)
      if (metrics) {
        this.metricsMessageIds.add(message.messageClientId)
        if (this.metricsMessageIds.size > 500) {
          const oldest = this.metricsMessageIds.values().next().value
          if (oldest) this.metricsMessageIds.delete(oldest)
        }
        this.latestMetrics.value = metrics
        this.metricsRevision.value += 1
      }
    }
    // Party 服务端会为同一笔礼物同时下发 1007 明文通知和 2049 压缩通知。
    // 旧站只消费包含完整 Party 礼物数据的 2049；若两种通知都进入消息队列，
    // 它们不同的 messageClientId 会让同一礼物播放两次动画。
    if (this.input.tags?.includes('party_room') && attachType === 1007) return
    if (isGiftMessage(message)) this.giftRevision.value += 1
    const pkStatus = parsePkPush(message, 100)
    if (pkStatus) {
      this.pkStatusPush.value = pkStatus
      this.pkStatusRevision.value += 1
    }
    const pkRank = parsePkPush(message, 98)
    if (pkRank) {
      this.pkRankPush.value = pkRank
      this.pkRankRevision.value += 1
    }
    const notificationType = message.attachment?.type
    if (message.messageType === 5 && notificationType !== undefined) {
      this.receiveNotification(message, notificationType)
      return
    }
    const entryEffect = entryEffectMessage(message)
    if (entryEffect) {
      this.pushEntryEffect(entryEffect)
      return
    }
    if (attachType === PARTY_COMPRESSED_GIFT_ATTACH_TYPE) {
      if (message.senderId !== this.input.credential.imAccount)
        void this.receiveCompressedPartyGift(message, extension.data)
      return
    }
    if (PARTY_BUSINESS_ATTACH_TYPES.has(attachType) || attachType === -10 || attachType === -11) {
      const data = extensionData(extension)
      this.latestBusiness.value = {
        attachType,
        createdAt: message.createTime,
        data:
          attachType === 1001 || attachType === 1017
            ? (decodeGzipBase64RecordSync(extension.data) ?? data)
            : data,
        id: message.messageClientId,
      }
      this.businessRevision.value += 1
    }
    // 文本和礼物均已走本地回显；SDK 自发回流必须丢弃，否则公屏和礼物飘屏会出现双条。
    if (message.senderId === this.input.credential.imAccount) return
    const parsed =
      wheelResultMessage(message) ??
      textMessage(message) ??
      announcementMessage(message) ??
      customMessage(message, this.input.hostImAccount, this.input.credential.imAccount)
    if (parsed?.kind === 'text')
      parsed.host = Boolean(
        this.input.hostImAccount && message.senderId === this.input.hostImAccount,
      )
    if (parsed) {
      this.upsert(parsed)
      if (parsed.kind === 'gift') this.latestGift.value = parsed
    }
  }

  private async receiveCompressedPartyGift(
    message: ChatroomSdkMessage,
    encodedData: unknown,
  ): Promise<void> {
    const input = this.input
    if (!input) return
    const roomId = input.roomId
    const data = await decodeGzipBase64Record(encodedData)
    if (!data || this.input?.roomId !== roomId) return
    const parsed = compressedPartyGiftMessage(message, data, input.hostImAccount)
    if (!parsed) return
    this.giftRevision.value += 1
    this.upsert(parsed)
    this.latestGift.value = parsed
  }

  private receiveNotification(message: ChatroomSdkMessage, type: number): void {
    const input = this.input
    if (!input) return
    const attachment = message.attachment
    const notificationExtension = parseRecord(attachment?.notificationExtension)
    const extensionAccount =
      typeof notificationExtension.yxAccid === 'string' ? notificationExtension.yxAccid.trim() : ''
    const operatorAccount = extensionAccount || attachment?.operatorId?.trim() || ''
    const targetsSelf = attachment?.targetIds?.includes(input.credential.imAccount) ?? false
    const notificationId = `${type}:${message.messageClientId}`
    if (this.notificationIds.has(notificationId)) return
    this.notificationIds.add(notificationId)
    if (this.notificationIds.size > 200) {
      const oldest = this.notificationIds.values().next().value
      if (oldest) this.notificationIds.delete(oldest)
    }
    const countsAsOnlineMember =
      operatorAccount !== '' &&
      operatorAccount !== input.credential.imAccount &&
      (!input.excludeHostFromOnlineCount || operatorAccount !== input.hostImAccount)
    if (type === 1 && operatorAccount !== '' && operatorAccount === input.hostImAccount)
      this.hostExitRevision.value += 1
    if (type === 0 && countsAsOnlineMember) this.onlineCount.value += 1
    else if (type === 1 && countsAsOnlineMember)
      this.onlineCount.value = Math.max(0, this.onlineCount.value - 1)
    else if ([4, 8].includes(type) && targetsSelf) this.muted.value = true
    else if ([5, 9].includes(type) && targetsSelf) this.muted.value = false
    else if (type === 7 && targetsSelf) this.state.value = 'kicked'
    else if (type === 12) this.roomMuted.value = true
    else if (type === 13) this.roomMuted.value = false
    else if (type === 16 && attachment?.messageClientId)
      this.messages.value = this.messages.value.filter(
        (item) => item.id !== attachment.messageClientId,
      )

    if (type !== 0) return
    const isHost = operatorAccount !== '' && operatorAccount === input.hostImAccount
    if (isHost) return
    const nickname =
      typeof notificationExtension.nickname === 'string' && notificationExtension.nickname.trim()
        ? notificationExtension.nickname.trim()
        : attachment?.targetNicks?.find((item) => item.trim())?.trim() ||
          attachment?.operatorNick?.trim() ||
          'Someone'
    const itemSmallImg = firstString(notificationExtension, ['itemSmallImg'])
    const userId = firstIdentifier(notificationExtension, ['userId', 'id']) || operatorAccount
    this.upsert({
      avatarUrl:
        typeof notificationExtension.icon === 'string'
          ? notificationExtension.icon
          : typeof notificationExtension.avatar === 'string'
            ? notificationExtension.avatar
            : '',
      createdAt: message.createTime,
      entryItemUrl: itemSmallImg || undefined,
      id: message.messageClientId,
      kind: 'enter',
      guardianLevel: firstNullableInteger(notificationExtension, [
        'guardianLevel',
        'guardianLevelCode',
      ]),
      newUser: firstBoolean(notificationExtension, ['isNewUser']),
      nickname,
      own: false,
      senderId: operatorAccount,
      state: 'received',
      text: 'Entered Room!',
      userId,
      userLevel: firstUserLevel(notificationExtension, ['userLevel', 'level']),
      vip: firstBoolean(notificationExtension, ['isVip', 'vip']),
    })
  }

  private upsert(message: LiveChatMessage): void {
    const next =
      message.kind === 'enter'
        ? this.messages.value.filter(
            (item) =>
              item.kind !== 'enter' ||
              (item.userId?.trim() || item.senderId) !==
                (message.userId?.trim() || message.senderId),
          )
        : [...this.messages.value]
    const existing = next.findIndex((item) => item.id === message.id)
    if (existing >= 0) next.splice(existing, 1, message)
    else next.push(message)
    next.sort((left, right) => left.createdAt - right.createdAt)
    const limit = Math.max(1, Math.trunc(this.input?.messageLimit ?? DEFAULT_MESSAGE_LIMIT))
    const trimCount = Math.max(0, Math.trunc(this.input?.messageTrimCount ?? 0))
    if (trimCount > 0 && next.length >= limit) next.splice(0, Math.min(trimCount, next.length - 1))
    else if (next.length > limit) next.splice(0, next.length - limit)
    this.messages.value = next
  }

  private pushEntryEffect(effect: LiveEntryEffect): void {
    this.entryEffect.value = effect
    this.entryEffectRevision.value += 1
  }

  private clearEntryEffectsInternal(): void {
    this.entryEffect.value = null
    this.entryEffectRevision.value = 0
  }

  private wasKicked(): boolean {
    return this.state.value === 'kicked'
  }

  private async releaseClient(): Promise<void> {
    const client = this.client
    if (!client) return
    for (const { event, listener, target } of this.listeners.splice(0)) {
      const emitter = target === 'client' ? client : client.V2NIMChatroomService
      emitter.off(event, listener)
    }
    this.client = null
    // The connection may already be gone. Local listeners and references are
    // released first, so an SDK exit failure/timeout must not keep the room alive.
    await exitChatroomClient(client)
  }
}

export function createLiveChatroomController(runtime?: ChatroomRuntime): LiveChatroomController {
  return new LiveChatroomController(runtime)
}

import type { ApiClient } from '@/core/api/client'
import { getApiClient } from '@/core/auth/runtime'
import { z } from 'zod'
import type {
  GameCatalog,
  GameItem,
  GameLaunchRequest,
  GameLaunchSpec,
  GameRepository,
  LiveRpsConfig,
  LiveRpsFinalResult,
  LiveRpsMove,
  LiveRpsOrder,
  LiveRpsOrderRequest,
  LiveRpsPlayRequest,
  LiveRpsPlayResult,
  LiveWheelConfig,
  LiveWheelRotateResult,
  LiveWheelSector,
} from './contracts'

const text = z
  .string()
  .nullish()
  .transform((value) => value?.trim() ?? '')
const identifier = z
  .union([z.string(), z.number().finite()])
  .transform((value) => String(value).trim())
const optionalIdentifier = z
  .union([z.string(), z.number().finite()])
  .nullish()
  .transform((value) => (value === null || value === undefined ? '' : String(value).trim()))
const integer = z.coerce.number().int().catch(0)
const amount = z.coerce.number().finite().catch(0)
const clickFlag = z.coerce.number().int().catch(1)
const booleanFlag = z.union([z.boolean(), z.number(), z.string()]).transform((value) => {
  if (typeof value === 'boolean') return value
  if (typeof value === 'number') return value !== 0
  return value === '1' || value.toLocaleLowerCase() === 'true'
})

const gameItem = z.object({
  appIds: text,
  gameCategories: text,
  gameId: identifier,
  gameLink: text,
  gameName: text,
  gameSize: text,
  gameType: text,
  id: identifier,
  isClick: clickFlag,
  isNew: booleanFlag.catch(false),
  isRecommend: booleanFlag.catch(false),
  isShowBack: booleanFlag.catch(false),
  listPageIcon: text,
  livePopIcon: text,
  loadingIcon: text,
  onlineCount: integer,
  vaild: clickFlag,
})
const gameResponse = z.object({
  rows: z.array(gameItem).default([]),
  scrollScreen: z
    .object({
      scrolls: z
        .array(z.object({ avatar: text, diamondNum: integer, gameName: text, nickname: text }))
        .default([]),
      showTime: integer,
    })
    .nullish(),
})
const halfGameResponse = z.object({
  allGames: z.array(gameItem).default([]),
  groupedGames: z.record(z.string(), z.array(gameItem)).default({}),
})
const vendorUrlResponse = z.object({ url: z.string().trim().min(1) })
const yomiCodeResponse = z.object({
  code: z.string().trim().min(1),
  merchant: integer,
  platform: integer,
  userId: identifier,
})
const rpsMove = z
  .string()
  .trim()
  .transform((value) => value.toUpperCase())
  .pipe(z.enum(['PAPER', 'ROCK', 'SCISSORS']))
const rpsConfigResponse = z.object({
  floatingBubbles: integer,
  rows: z
    .array(
      z.object({
        gameType: text,
        grantedHours: integer,
        price: integer,
      }),
    )
    .default([]),
  secondsToDayEnd: integer,
  todayPlayCount: z.record(z.string(), integer).default({}),
})
const rpsOrderResponse = z.object({ orderId: identifier })
const rpsPlayResponse = z.object({
  anchorMove: rpsMove,
  finalResult: text,
  orderFinished: booleanFlag.catch(false),
  playResult: z
    .string()
    .trim()
    .transform((value) => value.toUpperCase())
    .pipe(z.enum(['ANCHOR_WIN', 'DRAW', 'USER_WIN'])),
  smallRoundNo: integer,
  userMove: rpsMove,
})
const rpsExitResponse = z.object({ exited: booleanFlag.catch(false) })
const wheelSectorResponse = z.object({
  id: optionalIdentifier,
  presetId: text,
  text,
  wheelId: optionalIdentifier,
})
const wheelConfigResponse = z.object({
  anchorId: optionalIdentifier,
  enabled: integer,
  id: optionalIdentifier,
  originalPrice: amount,
  price: amount,
  rows: z.array(wheelSectorResponse).default([]),
})
const wheelRotateResponse = wheelSectorResponse.extend({
  anchorId: optionalIdentifier,
  diamondNum: integer,
  incomeDiamondNum: amount,
})

type ApiRequester = Pick<ApiClient, 'request'>

function normalizeLink(value: string): string {
  return value.replaceAll('&amp;', '&').replace(/%26/giu, '&')
}

function currentLanguage(): string {
  return globalThis.navigator?.language.split('-')[0] || 'en'
}

function gameExt(request: GameLaunchRequest, size: string = request.size): string {
  return `${request.game.gameId}_${size}__path$${request.scene}__roomid$${request.roomId ?? ''}`
}

function setQuery(url: string, values: Readonly<Record<string, string>>): string {
  const parsed = new URL(url)
  for (const [key, value] of Object.entries(values)) parsed.searchParams.set(key, value)
  return parsed.toString()
}

function stripPlatPayload(url: string): { cleaned: string; size: string | null } {
  const parsed = new URL(url)
  const size = parsed.searchParams.get('platPayload')?.trim() || null
  parsed.searchParams.delete('platPayload')
  return { cleaned: parsed.toString(), size }
}

function mapGame(row: z.infer<typeof gameItem>, imageUrl = row.listPageIcon): GameItem {
  return {
    appIds: row.appIds,
    category: row.gameCategories,
    gameId: row.gameId,
    gameLink: row.gameLink,
    gameType: row.gameType.toLocaleLowerCase(),
    id: row.id,
    imageUrl,
    isClick: row.isClick !== 0,
    isNew: row.isNew,
    isRecommend: row.isRecommend,
    isShowBack: row.isShowBack,
    loadingIconUrl: row.loadingIcon,
    name: row.gameName || `Game ${row.gameId}`,
    onlineCount: Math.max(0, row.onlineCount),
  }
}

function launchSpec(
  request: GameLaunchRequest,
  url: string,
  bridgeType: GameLaunchSpec['bridgeType'],
): GameLaunchSpec {
  const parsed = new URL(url)
  if (parsed.protocol !== 'https:') throw new Error('The game URL is not secure.')
  return {
    accountId: request.identity.userId,
    allowedOrigin: parsed.origin,
    bridgeType,
    gameId: request.game.gameId,
    isShowBack: request.game.isShowBack,
    loadingIconUrl: request.game.loadingIconUrl,
    url: parsed.toString(),
  }
}

export class OpiGameRepository implements GameRepository {
  constructor(private readonly api: ApiRequester = getApiClient()) {}

  async getFullCatalog(signal?: AbortSignal): Promise<GameCatalog> {
    const result = await this.api.request({
      authMode: 'required',
      data: { lang: currentLanguage() },
      method: 'POST',
      schema: gameResponse,
      signal,
      url: '/_v2/game/full/list',
    })
    return {
      games: result.rows.map((row) => mapGame(row, row.livePopIcon || row.listPageIcon)),
      noticeIntervalMs: Math.max(1, result.scrollScreen?.showTime ?? 3) * 1_000,
      notices: (result.scrollScreen?.scrolls ?? []).map((notice) => ({
        avatarUrl: notice.avatar,
        diamondCount: Math.max(0, notice.diamondNum),
        gameName: notice.gameName,
        nickname: notice.nickname,
      })),
    }
  }

  async getHalfCatalog(signal?: AbortSignal): Promise<GameCatalog> {
    const result = await this.api.request({
      authMode: 'required',
      data: {},
      method: 'POST',
      schema: halfGameResponse,
      signal,
      url: '/_v2/game/half/list',
    })
    const unique = new Map<string, GameItem>()
    for (const row of result.groupedGames['4'] ?? []) {
      if (
        row.vaild === 0 ||
        row.isClick === 0 ||
        (row.gameSize && row.gameSize.toLocaleLowerCase() !== 'half') ||
        !row.gameId ||
        !row.gameLink
      )
        continue
      const mapped = mapGame(row, row.livePopIcon || row.listPageIcon)
      unique.set(mapped.id, mapped)
    }
    return { games: [...unique.values()], noticeIntervalMs: 3_000, notices: [] }
  }

  async getLiveRpsConfig(signal?: AbortSignal): Promise<LiveRpsConfig | null> {
    const result = await this.api.request({
      authMode: 'required',
      data: {},
      method: 'POST',
      schema: rpsConfigResponse,
      signal,
      url: '/_v2/game/live/config',
    })
    const config = result.rows.find((item) => item.gameType.toUpperCase() === 'ROCK_PAPER_SCISSORS')
    if (!config || config.price <= 0) return null
    const playCount =
      result.todayPlayCount.ROCK_PAPER_SCISSORS ?? result.todayPlayCount.rock_paper_scissors ?? 0
    return {
      floatingBubbles: Math.max(0, result.floatingBubbles),
      grantedHours: Math.max(0, config.grantedHours),
      price: Math.max(0, config.price),
      secondsToDayEnd: Math.max(0, result.secondsToDayEnd),
      todayPlayCount: Math.max(0, Math.trunc(playCount)),
    }
  }

  async createLiveRpsOrder(
    request: LiveRpsOrderRequest,
    signal?: AbortSignal,
  ): Promise<LiveRpsOrder> {
    const result = await this.api.request({
      authMode: 'required',
      data: {
        anchorId: Number(request.anchorId),
        gameType: 'ROCK_PAPER_SCISSORS',
        roomId: Number(request.roomId),
      },
      method: 'POST',
      schema: rpsOrderResponse,
      signal,
      url: '/_v2/game/live/order/create',
    })
    if (!result.orderId || result.orderId === '0')
      throw new Error('The game order could not be created.')
    return { orderId: result.orderId }
  }

  async playLiveRps(request: LiveRpsPlayRequest, signal?: AbortSignal): Promise<LiveRpsPlayResult> {
    const result = await this.api.request({
      authMode: 'required',
      data: {
        orderId: Number(request.orderId),
        smallRoundNo: request.smallRoundNo,
        userMove: request.move,
      },
      method: 'POST',
      schema: rpsPlayResponse,
      signal,
      url: '/_v2/game/live/play',
    })
    const normalizedFinal = result.finalResult.toUpperCase()
    const finalResult = [
      'ANCHOR_WIN',
      'FINISHED_ANCHOR_WIN',
      'FINISHED_USER_WIN',
      'USER_WIN',
    ].includes(normalizedFinal)
      ? (normalizedFinal as LiveRpsFinalResult)
      : null
    return {
      anchorMove: result.anchorMove as LiveRpsMove,
      finalResult,
      orderFinished: result.orderFinished,
      playResult: result.playResult,
      smallRoundNo: Math.max(1, result.smallRoundNo),
      userMove: result.userMove as LiveRpsMove,
    }
  }

  async exitLiveRps(orderId: string, signal?: AbortSignal): Promise<boolean> {
    const result = await this.api.request({
      authMode: 'required',
      data: { orderId: Number(orderId) },
      method: 'POST',
      schema: rpsExitResponse,
      signal,
      url: '/_v2/game/live/exit',
    })
    return result.exited
  }

  async getLiveWheelConfig(
    anchorId: string,
    signal?: AbortSignal,
  ): Promise<LiveWheelConfig | null> {
    const numericAnchorId = Number(anchorId)
    if (!Number.isSafeInteger(numericAnchorId) || numericAnchorId <= 0) return null
    const result = await this.api.request({
      authMode: 'required',
      data: { anchorId: numericAnchorId },
      method: 'POST',
      schema: wheelConfigResponse,
      signal,
      url: '/_v2/game/wheel/config',
    })
    const sectors: LiveWheelSector[] = result.rows
      .map((row) => ({
        id: row.id,
        presetId: row.presetId,
        text: row.text,
        wheelId: row.wheelId || result.id,
      }))
      .filter((sector) => Boolean(sector.id && sector.text))
    if (result.enabled !== 1 || !result.id || sectors.length < 2) return null
    return {
      anchorId: result.anchorId || anchorId,
      enabled: true,
      id: result.id,
      originalPrice: Math.max(0, result.originalPrice),
      price: Math.max(0, result.price),
      sectors,
    }
  }

  async rotateLiveWheel(anchorId: string, signal?: AbortSignal): Promise<LiveWheelRotateResult> {
    const numericAnchorId = Number(anchorId)
    if (!Number.isSafeInteger(numericAnchorId) || numericAnchorId <= 0)
      throw new Error('The live wheel is unavailable.')
    const result = await this.api.request({
      authMode: 'required',
      data: { anchorId: numericAnchorId },
      method: 'POST',
      schema: wheelRotateResponse,
      signal,
      url: '/_v2/game/wheel/rotate',
    })
    if (!result.id || !result.text) throw new Error('The live wheel result is invalid.')
    return {
      anchorId: result.anchorId || anchorId,
      balance: Math.max(0, result.diamondNum),
      incomeDiamondNum: Math.max(0, result.incomeDiamondNum),
      sector: {
        id: result.id,
        presetId: result.presetId,
        text: result.text,
        wheelId: result.wheelId,
      },
    }
  }

  async buildLaunch(request: GameLaunchRequest, signal?: AbortSignal): Promise<GameLaunchSpec> {
    const link = normalizeLink(request.game.gameLink)
    if (!request.game.isClick || !request.game.gameId || !link)
      throw new Error('The game is unavailable.')
    const ext = gameExt(request)
    const gameType = request.game.gameType.toLocaleLowerCase()
    if (!['default', 'joyplay', 'lingxian', 'vvvapis', 'wheat', 'yomi'].includes(gameType))
      throw new Error('The game provider is unsupported.')

    if (gameType === 'vvvapis') {
      const result = await this.api.request({
        authMode: 'required',
        data: { gameId: request.game.gameId },
        method: 'POST',
        schema: vendorUrlResponse,
        signal,
        url: '/_v2/game/vvvapis/enter',
      })
      const separator = result.url.includes('?') ? '&' : '?'
      return launchSpec(
        request,
        `${result.url}${separator}gameType=vvvapis&gameId=${encodeURIComponent(request.game.gameId)}&ext=${encodeURIComponent(ext)}`,
        'vvvapis',
      )
    }

    if (gameType === 'yomi') {
      const result = await this.api.request({
        authMode: 'required',
        data: {},
        method: 'POST',
        schema: yomiCodeResponse,
        signal,
        url: '/_v2/game/yomi/code',
      })
      if (/(?:^|[?&])version=v4(?:&|$)/iu.test(link)) {
        const stripped = stripPlatPayload(link)
        const separator = stripped.cleaned.includes('?') ? '&' : '?'
        const payload = gameExt(request, stripped.size || request.size)
        return launchSpec(
          request,
          `${stripped.cleaned}${separator}lang=${encodeURIComponent(currentLanguage())}&platUserId=${encodeURIComponent(result.userId)}&platAuthCode=${encodeURIComponent(result.code)}&platPayload=${encodeURIComponent(payload)}`,
          'yomi',
        )
      }
      return launchSpec(
        request,
        setQuery(link, {
          code: result.code,
          gameType: request.game.gameId,
          lang: currentLanguage(),
          merchant: String(result.merchant),
          merchantPayload: ext,
          platform: String(result.platform),
          roomId: request.game.appIds,
          userId: result.userId,
          yomiGameType: 'yomi',
        }),
        'yomi',
      )
    }

    return launchSpec(
      request,
      setQuery(link, {
        ext,
        mini: request.size === 'half' ? '1' : '0',
        token: request.identity.imToken,
        uid: request.identity.userId,
      }),
      gameType === 'lingxian' ? 'lingxian' : 'default',
    )
  }
}

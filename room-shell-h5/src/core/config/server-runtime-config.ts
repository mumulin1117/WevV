import { getRuntimeConfig } from '@/core/config/runtime-config'
import { readLocalJson, writeLocalJson } from '@/core/storage/local-storage'
import { z } from 'zod'

const utf8Length = (value: string) => new TextEncoder().encode(value).byteLength
const sixteenByteValue = (label: string) =>
  z.string().refine((value) => utf8Length(value) === 16, {
    message: `${label} must contain exactly 16 UTF-8 bytes.`,
  })
const httpsUrl = z.url().refine((value) => new URL(value).protocol === 'https:', {
  message: 'The SAPI URL must use HTTPS.',
})
const secureWebSocketUrl = z.url().refine((value) => new URL(value).protocol === 'wss:', {
  message: 'The socket URL must use WSS.',
})

/**
 * config/open 下发的产品运行参数。额外字段会被忽略，以便服务端向前扩展；
 * 已声明字段必须整体合法，禁止把不同版本或不同 App 的参数拼接使用。
 */
export const serverRuntimeConfigSchema = z.object({
  imAppKey: z.string().regex(/^[\da-f]{32}$/iu),
  noticeAccount: z.string().trim().min(1).max(64),
  rtcAppId: z.string().regex(/^[\da-f]{32}$/iu),
  sapiAesIv: sixteenByteValue('SAPI AES IV'),
  sapiAesKey: sixteenByteValue('SAPI AES key'),
  sapiBaseUrl: httpsUrl,
  socketUrl: secureWebSocketUrl,
})

export type ServerRuntimeConfig = z.infer<typeof serverRuntimeConfigSchema>

interface CachedServerRuntimeConfig {
  appId: string
  appKey: string
  cachedAt: number
  config: ServerRuntimeConfig
  schemaVersion: 1
}

let current: ServerRuntimeConfig | null = null

function identity(): { appId: string; appKey: string } {
  const config = getRuntimeConfig()
  return { appId: config.app.appId, appKey: 'room-shell' }
}

function cacheKey(): string {
  const { appId, appKey } = identity()
  return `social-app:${appKey}:server-runtime:${appId}`
}

function isCachedServerRuntimeConfig(value: unknown): value is CachedServerRuntimeConfig {
  if (!value || typeof value !== 'object') return false
  const candidate = value as Partial<CachedServerRuntimeConfig>
  return (
    candidate.schemaVersion === 1 &&
    typeof candidate.appId === 'string' &&
    typeof candidate.appKey === 'string' &&
    typeof candidate.cachedAt === 'number' &&
    Number.isFinite(candidate.cachedAt) &&
    serverRuntimeConfigSchema.safeParse(candidate.config).success
  )
}

function readCachedConfig(): ServerRuntimeConfig | null {
  const expected = identity()
  const cached = readLocalJson(cacheKey(), isCachedServerRuntimeConfig)
  if (!cached || cached.appId !== expected.appId || cached.appKey !== expected.appKey) return null
  const parsed = serverRuntimeConfigSchema.safeParse(cached.config)
  return parsed.success ? parsed.data : null
}

export function initializeServerRuntimeConfig(candidate?: unknown): ServerRuntimeConfig | null {
  const parsed = serverRuntimeConfigSchema.safeParse(candidate)
  if (parsed.success) {
    const { appId, appKey } = identity()
    current = parsed.data
    writeLocalJson(cacheKey(), {
      appId,
      appKey,
      cachedAt: Date.now(),
      config: current,
      schemaVersion: 1,
    } satisfies CachedServerRuntimeConfig)
    return current
  }
  current = readCachedConfig()
  return current
}

export function getServerRuntimeConfig(): ServerRuntimeConfig {
  if (!current) throw new Error('The server runtime configuration has not been initialized.')
  return current
}

export function getServerRuntimeConfigOrNull(): ServerRuntimeConfig | null {
  return current
}

export function resetServerRuntimeConfigForTests(): void {
  current = null
}

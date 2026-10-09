import { z } from 'zod'

const safeWireName = /^[A-Za-z_][\w.-]{0,63}$/u
const utf8Length = (value: string) => new TextEncoder().encode(value).byteLength
const cssColor = z.string().regex(/^#[\da-f]{6}$/iu)
const apiUrl = z
  .url()
  .refine((value) => ['http:', 'https:'].includes(new URL(value).protocol), 'Invalid HTTP URL.')

export const runtimeConfigSchema = z
  .object({
    schemaVersion: z.literal(1),
    build: z
      .object({
        buildId: z.string().trim().min(1),
        minimumHostVersion: z.string().trim().min(1),
      })
      .strict(),
    app: z
      .object({
        appId: z.string().trim().min(1).max(64),
        documentTitle: z.string().trim().min(1).max(128),
        defaultLocale: z.string().trim().min(2).max(16),
      })
      .strict(),
    api: z
      .object({
        baseUrl: apiUrl,
        encryptionKey: z.string().refine((value) => utf8Length(value) === 16),
        encryptionIv: z.string().refine((value) => utf8Length(value) === 16),
        timeoutMs: z.number().int().min(1_000).max(60_000),
      })
      .strict(),
    theme: z
      .object({
        primary: cssColor,
        secondary: cssColor,
        accent: cssColor,
      })
      .strict(),
    bridge: z
      .object({
        handler: z.string().regex(safeWireName),
        receiver: z.string().regex(safeWireName),
        commands: z
          .object({
            closeRoom: z.string().regex(safeWireName),
            openRecharge: z.string().regex(safeWireName),
          })
          .strict(),
        events: z.object({ rechargeSucceeded: z.string().regex(safeWireName) }).strict(),
      })
      .strict(),
    debug: z.object({ vConsoleEnabled: z.boolean() }).strict(),
  })
  .strict()

export type RuntimeConfig = z.infer<typeof runtimeConfigSchema>

declare global {
  interface Window {
    __ROOM_APP_CONFIG__?: unknown
  }
}

let cached: RuntimeConfig | undefined

export class RuntimeConfigError extends Error {
  constructor(readonly issues: string[]) {
    super(`Room configuration is invalid: ${issues.join('; ')}`)
    this.name = 'RuntimeConfigError'
  }
}

export function parseRuntimeConfig(value: unknown): RuntimeConfig {
  const result = runtimeConfigSchema.safeParse(value)
  if (!result.success) {
    throw new RuntimeConfigError(
      result.error.issues.map((issue) => `${issue.path.join('.') || 'root'}: ${issue.message}`),
    )
  }
  return result.data
}

export function getRuntimeConfig(): RuntimeConfig {
  cached ??= parseRuntimeConfig(window.__ROOM_APP_CONFIG__)
  return cached
}

export function resetRuntimeConfigForTests(): void {
  cached = undefined
}

export const resetRuntimeConfigForTesting = resetRuntimeConfigForTests

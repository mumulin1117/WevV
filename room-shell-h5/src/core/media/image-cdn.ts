import { getRuntimeConfig } from '@/core/config/runtime-config'
import { resolveBundleBaseUrl, resolveBundleUrl } from '@/core/assets/bundle-url'
import { readLocalJson, writeLocalJson } from '@/core/storage/local-storage'

export interface ImageCdnConfig {
  defaultCdnUrl: string
  needReplaceCdnDomains: string[]
}

interface CachedImageCdnConfig extends ImageCdnConfig {
  appId: string
  appKey: string
  schemaVersion: 1
}

let current: ImageCdnConfig | null = null

function identity(): { appId: string; appKey: string } {
  const config = getRuntimeConfig()
  return { appId: config.app.appId, appKey: 'room-shell' }
}

function cacheKey(): string {
  const { appId, appKey } = identity()
  return `social-app:${appKey}:image-cdn:${appId}`
}

function hostOf(value: string): string {
  const candidate = value.trim()
  if (!candidate) return ''
  try {
    return new URL(
      candidate.includes('://') ? candidate : `https://${candidate}`,
    ).hostname.toLowerCase()
  } catch {
    return ''
  }
}

function isCurrentHttpOrigin(value: string): boolean {
  if (!value.startsWith('http://')) return false
  try {
    return new URL(value).origin === resolveBundleBaseUrl().origin
  } catch {
    return false
  }
}

function isCachedConfig(value: unknown): value is CachedImageCdnConfig {
  if (!value || typeof value !== 'object') return false
  const candidate = value as Partial<CachedImageCdnConfig>
  return (
    candidate.schemaVersion === 1 &&
    typeof candidate.appId === 'string' &&
    typeof candidate.appKey === 'string' &&
    typeof candidate.defaultCdnUrl === 'string' &&
    Array.isArray(candidate.needReplaceCdnDomains) &&
    candidate.needReplaceCdnDomains.every((domain) => typeof domain === 'string')
  )
}

function parseConfig(raw?: string | null): ImageCdnConfig | null {
  if (!raw?.trim()) return null
  try {
    const parsed = JSON.parse(raw) as unknown
    if (!parsed || typeof parsed !== 'object') return null
    const value = parsed as { defaultCdnUrl?: unknown; needReplaceCdnDomains?: unknown }
    const defaultCdnUrl = typeof value.defaultCdnUrl === 'string' ? value.defaultCdnUrl.trim() : ''
    const domains = Array.isArray(value.needReplaceCdnDomains)
      ? [
          ...new Set(
            value.needReplaceCdnDomains
              .filter((item): item is string => typeof item === 'string')
              .map(hostOf)
              .filter(Boolean),
          ),
        ]
      : []
    if (!defaultCdnUrl && domains.length === 0) return null
    if (defaultCdnUrl && !hostOf(defaultCdnUrl)) return null
    return { defaultCdnUrl, needReplaceCdnDomains: domains }
  } catch {
    return null
  }
}

function cachedConfig(): ImageCdnConfig | null {
  const expected = identity()
  const cached = readLocalJson(cacheKey(), isCachedConfig)
  if (!cached || cached.appId !== expected.appId || cached.appKey !== expected.appKey) return null
  return {
    defaultCdnUrl: cached.defaultCdnUrl,
    needReplaceCdnDomains: [...cached.needReplaceCdnDomains],
  }
}

export function initializeImageCdn(raw?: string | null): ImageCdnConfig | null {
  const parsed = parseConfig(raw)
  if (parsed) {
    const { appId, appKey } = identity()
    current = parsed
    writeLocalJson(cacheKey(), {
      ...parsed,
      appId,
      appKey,
      schemaVersion: 1,
    } satisfies CachedImageCdnConfig)
    return current
  }
  current = cachedConfig()
  return current
}

export function resolveImageUrl(source?: string | null): string {
  const value = source?.trim() ?? ''
  if (!value) return ''
  const bundled = resolveBundleUrl(value)
  if (bundled !== value) return bundled
  const normalized =
    value.startsWith('http://') && !isCurrentHttpOrigin(value)
      ? `https://${value.slice('http://'.length)}`
      : value.startsWith('//')
        ? `https:${value}`
        : value
  if (!current?.defaultCdnUrl || !/^https?:\/\//iu.test(normalized)) return normalized

  try {
    const url = new URL(normalized)
    if (!current.needReplaceCdnDomains.includes(url.hostname.toLowerCase())) return normalized
    const targetValue = current.defaultCdnUrl.includes('://')
      ? current.defaultCdnUrl
      : `${url.protocol}//${current.defaultCdnUrl}`
    const target = new URL(targetValue)
    url.protocol = target.protocol
    url.host = target.host
    return url.toString()
  } catch {
    return normalized
  }
}

export function resetImageCdnForTests(): void {
  current = null
}

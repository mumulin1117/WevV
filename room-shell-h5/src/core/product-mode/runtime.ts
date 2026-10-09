import { getRuntimeConfig } from '@/core/config/runtime-config'
import { getClientContext } from '@/core/device/client-context'
import { removeLocalStorage } from '@/core/storage/local-storage'

export type ProductMode = 'local' | 'remote'
export type TargetFlag = 0 | 1

export interface ResolvedProductMode {
  mode: ProductMode
  resolvedAt: number
  resolvedFrom: 'cache' | 'config' | 'open' | 'override'
  targetFlag: TargetFlag
}

let current: ResolvedProductMode | undefined

function identity(): { appId: string; appKey: string } {
  const config = getRuntimeConfig()
  return { appId: config.app.appId, appKey: 'room-shell' }
}

function cacheKey(): string {
  const { appId, appKey } = identity()
  return `social-app:${appKey}:product-mode:${appId}`
}

/** 只有本次 Open 明确返回 1 才能装配 H5；其他结果交给原生启动分流。 */
export function resolveProductModeCandidate(openTargetFlag?: unknown): ResolvedProductMode {
  if (current) return current
  if (openTargetFlag !== 1) throw new Error('Remote H5 requires targetFlag=1 from config/open.')
  return { mode: 'remote', resolvedAt: Date.now(), resolvedFrom: 'open', targetFlag: 1 }
}

export function initializeProductMode(openTargetFlag?: unknown): ResolvedProductMode {
  current ??= resolveProductModeCandidate(openTargetFlag)
  return current
}

export function getProductMode(): ResolvedProductMode {
  if (!current) throw new Error('Product mode has not been initialized.')
  return current
}

export function getProductModeOrNull(): ResolvedProductMode | null {
  return current ?? null
}

export function isLocalProduct(): boolean {
  return getProductMode().mode === 'local'
}

export function productStorageNamespace(
  accountId = 'anonymous',
  contentVersion = 'default',
): string {
  const { appId, appKey } = identity()
  return `${appKey}:${appId}:${getClientContext().deviceNo}:${getProductMode().mode}:${accountId}:${contentVersion}`
}

export function clearProductModeCache(): void {
  removeLocalStorage(cacheKey())
}

export function resetProductModeForTests(): void {
  current = undefined
}

import { z } from 'zod'
import type { ApiClient } from '@/core/api/client'
import { getApiClient } from '@/core/auth/runtime'
import {
  resetProductServiceForTests,
  resolveProductService,
} from '@/core/product-mode/product-services'
import type { RelationshipRepository, RelationshipTarget } from './contracts'

type RecordValue = Record<string, unknown>

const unknownValue = z.unknown()

function record(value: unknown): RecordValue | null {
  return value !== null && typeof value === 'object' && !Array.isArray(value)
    ? (value as RecordValue)
    : null
}

function normalizedUserId(value: unknown): string {
  if (typeof value === 'number' && Number.isSafeInteger(value) && value > 0) return String(value)
  if (typeof value !== 'string') return ''
  const id = value.trim()
  return id && id !== '0' ? id : ''
}

function requestTarget(target: RelationshipTarget): { userId: number } | { yxAccid: string } {
  const numericId = Number(target.userId)
  if (Number.isSafeInteger(numericId) && numericId > 0) return { userId: numericId }
  const imAccount = target.imAccount?.trim() ?? ''
  if (imAccount) return { yxAccid: imAccount }
  throw new Error('Invalid relationship target.')
}

export class OpiRelationshipRepository implements RelationshipRepository {
  constructor(private readonly api: Pick<ApiClient, 'request'> = getApiClient()) {}

  async block(target: RelationshipTarget, signal?: AbortSignal): Promise<void> {
    await this.api.request({
      authMode: 'required',
      data: { ...requestTarget(target), type: 1 },
      method: 'POST',
      schema: unknownValue,
      signal,
      url: '/_v2/user/block/add',
    })
  }

  async getBlockedUserIds(signal?: AbortSignal): Promise<readonly string[]> {
    const value = await this.api.request({
      authMode: 'required',
      data: {},
      method: 'POST',
      schema: unknownValue,
      signal,
      url: '/_v2/user/block/ids',
    })
    const root = record(value)
    const rows = Array.isArray(root?.rows) ? root.rows : Array.isArray(value) ? value : []
    return [
      ...new Set(
        rows
          .map((item) => {
            const source = record(item)
            return normalizedUserId(source?.userId ?? source?.id ?? item)
          })
          .filter(Boolean),
      ),
    ]
  }

  async setFollowed(
    target: RelationshipTarget,
    followed: boolean,
    signal?: AbortSignal,
  ): Promise<void> {
    const numericId = Number(target.userId)
    if (!Number.isSafeInteger(numericId) || numericId <= 0) throw new Error('Invalid anchor id.')
    await this.api.request({
      authMode: 'required',
      data: { followType: followed ? 1 : 2, followUserId: numericId },
      method: 'POST',
      schema: unknownValue,
      signal,
      url: '/_v2/user/followUser',
    })
  }

  async unblock(target: RelationshipTarget, signal?: AbortSignal): Promise<void> {
    await this.api.request({
      authMode: 'required',
      data: { ...requestTarget(target), type: 1 },
      method: 'POST',
      schema: unknownValue,
      signal,
      url: '/_v2/user/block/remove',
    })
  }
}

export function getRelationshipRepository(): RelationshipRepository {
  return resolveProductService<RelationshipRepository>('relationships', {
    remote: () => new OpiRelationshipRepository(),
  })
}

export function resetRelationshipRepositoryForTests(): void {
  resetProductServiceForTests('relationships')
}

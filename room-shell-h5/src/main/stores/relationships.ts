import type {
  RelationshipTarget,
  UserRelationship,
  UserRelationshipSeed,
} from '@/features/relationships/contracts'
import { isAnchorUserType } from '@/features/relationships/contracts'
import {
  relationshipActions,
  relationshipQueries,
} from '@/features/relationships/relationship-operations'
import { emitAnchorRelationshipChange } from '@/features/rooms/anchor-relationship-events'
import { acceptHMRUpdate, defineStore } from 'pinia'
import { readonly, reactive, ref } from 'vue'
import { useSessionStore } from './session'

interface RelationshipEntry extends UserRelationship {
  blockLocked: boolean
  followLocked: boolean
}

function emptyEntry(): RelationshipEntry {
  return {
    blocked: false,
    blockedKnown: false,
    blockLocked: false,
    followed: false,
    followedKnown: false,
    followLocked: false,
    userType: 0,
  }
}

function targetKey(target: RelationshipTarget): string {
  return target.userId.trim()
}

export const useRelationshipsStore = defineStore('relationships', () => {
  const session = useSessionStore()
  const entries = reactive(new Map<string, RelationshipEntry>())
  const blockedIdsReady = ref(false)
  const pendingKeys = reactive(new Set<string>())
  const blockedUserIds = new Set<string>()
  const blockOverrides = new Map<string, boolean>()
  let blockedIdsPromise: Promise<void> | undefined
  let generation = 0
  let ownerId = ''

  function activeOwner(): string {
    return session.authenticated ? (session.user?.id ?? '') : ''
  }

  function clear(): void {
    generation += 1
    ownerId = ''
    entries.clear()
    pendingKeys.clear()
    blockedUserIds.clear()
    blockOverrides.clear()
    blockedIdsReady.value = false
    blockedIdsPromise = undefined
  }

  function bindOwner(): string {
    const active = activeOwner()
    if (ownerId !== active) {
      clear()
      ownerId = active
    }
    if (!active) throw new Error('The account session is unavailable.')
    return active
  }

  function mutableEntry(userId: string): RelationshipEntry {
    let entry = entries.get(userId)
    if (!entry) {
      entry = reactive(emptyEntry()) as RelationshipEntry
      if (blockedIdsReady.value) {
        entry.blocked = blockedUserIds.has(userId)
        entry.blockedKnown = true
        entry.blockLocked = true
      }
      entries.set(userId, entry)
    }
    return entry
  }

  function seed(input: UserRelationshipSeed): void {
    const userId = input.userId.trim()
    if (!userId) return
    const entry = mutableEntry(userId)
    const userType = Number(input.userType ?? 0)
    // 0 表示来源没有返回身份，不能用它覆盖其他接口已经确认的主播/用户类型。
    if (Number.isInteger(userType) && userType > 0) entry.userType = userType
    if (input.followed !== undefined && !entry.followLocked) {
      entry.followed = input.followed
      entry.followedKnown = true
    }
    if (input.blocked !== undefined && !entry.blockLocked) {
      entry.blocked = input.blocked
      entry.blockedKnown = true
    }
  }

  function relationship(
    userId: string,
    fallback: Partial<UserRelationship> = {},
  ): UserRelationship {
    const entry = entries.get(userId.trim())
    return {
      blocked: entry?.blocked ?? fallback.blocked ?? false,
      blockedKnown: entry?.blockedKnown ?? fallback.blockedKnown ?? false,
      followed: entry?.followed ?? fallback.followed ?? false,
      followedKnown: entry?.followedKnown ?? fallback.followedKnown ?? false,
      userType: entry?.userType || fallback.userType || 0,
    }
  }

  function canFollow(userId: string, fallbackUserType = 0): boolean {
    const relation = relationship(userId, { userType: fallbackUserType })
    return isAnchorUserType(relation.userType) && userId !== session.user?.id
  }

  function canStartConversation(userId: string, fallbackUserType = 0): boolean {
    const relation = relationship(userId, { userType: fallbackUserType })
    return Boolean(userId) && userId !== session.user?.id && !relation.blocked
  }

  function isPending(userId: string, action?: 'block' | 'follow' | 'unblock'): boolean {
    const id = userId.trim()
    if (!id) return false
    if (action) return pendingKeys.has(`${action}:${id}`)
    return [...pendingKeys].some((key) => key.endsWith(`:${id}`))
  }

  async function loadBlockedIds(force = false): Promise<void> {
    const requestedOwner = bindOwner()
    if (!force && blockedIdsReady.value) return
    if (blockedIdsPromise) return blockedIdsPromise
    const requestedGeneration = generation
    const task = relationshipQueries
      .getBlockedUserIds()
      .then((ids) => {
        if (requestedGeneration !== generation || requestedOwner !== activeOwner()) return
        const blocked = new Set(ids)
        for (const [userId, value] of blockOverrides) {
          if (value) blocked.add(userId)
          else blocked.delete(userId)
        }
        blockedUserIds.clear()
        blocked.forEach((userId) => blockedUserIds.add(userId))
        for (const [userId, entry] of entries) {
          if (entry.blockLocked) continue
          entry.blocked = blocked.has(userId)
          entry.blockedKnown = true
          entry.blockLocked = true
        }
        for (const userId of blocked) {
          const entry = mutableEntry(userId)
          entry.blocked = true
          entry.blockedKnown = true
          entry.blockLocked = true
        }
        blockedIdsReady.value = true
      })
      .finally(() => {
        if (blockedIdsPromise === task) blockedIdsPromise = undefined
      })
    blockedIdsPromise = task
    return task
  }

  async function setFollowed(target: RelationshipTarget, followed: boolean): Promise<void> {
    const requestedOwner = bindOwner()
    const userId = targetKey(target)
    if (!userId || userId === requestedOwner) throw new Error('Invalid follow target.')
    seed({ userId, userType: target.userType })
    const entry = mutableEntry(userId)
    if (!isAnchorUserType(entry.userType)) throw new Error('Only hosts can be followed.')
    if (entry.blocked) throw new Error('Unblock this user before following them.')
    const key = `follow:${userId}`
    if (pendingKeys.has(key)) throw new Error('The follow request is already in progress.')
    const previous = {
      followed: entry.followed,
      followedKnown: entry.followedKnown,
      followLocked: entry.followLocked,
    }
    const requestedGeneration = generation
    entry.followed = followed
    entry.followedKnown = true
    entry.followLocked = true
    pendingKeys.add(key)
    try {
      await relationshipActions.setFollowed(
        { ...target, userId, userType: entry.userType },
        followed,
      )
      if (requestedGeneration !== generation || requestedOwner !== activeOwner()) return
      emitAnchorRelationshipChange({ followed, userId })
    } catch (cause) {
      if (requestedGeneration === generation && requestedOwner === activeOwner()) {
        entry.followed = previous.followed
        entry.followedKnown = previous.followedKnown
        entry.followLocked = previous.followLocked
      }
      throw cause
    } finally {
      if (requestedGeneration === generation) pendingKeys.delete(key)
    }
  }

  async function block(target: RelationshipTarget): Promise<void> {
    const requestedOwner = bindOwner()
    const userId = targetKey(target)
    if (!userId || userId === requestedOwner) throw new Error('Invalid block target.')
    seed({ userId, userType: target.userType })
    const entry = mutableEntry(userId)
    if (entry.blocked) return
    const key = `block:${userId}`
    if (pendingKeys.has(key)) throw new Error('The block request is already in progress.')
    const previous = {
      blocked: entry.blocked,
      blockedKnown: entry.blockedKnown,
      blockLocked: entry.blockLocked,
      followed: entry.followed,
      followedKnown: entry.followedKnown,
      followLocked: entry.followLocked,
    }
    const requestedGeneration = generation
    entry.blocked = true
    entry.blockedKnown = true
    entry.blockLocked = true
    entry.followed = false
    entry.followedKnown = true
    entry.followLocked = true
    pendingKeys.add(key)
    try {
      await relationshipActions.block({ ...target, userId, userType: entry.userType })
      if (requestedGeneration !== generation || requestedOwner !== activeOwner()) return
      blockedUserIds.add(userId)
      blockOverrides.set(userId, true)
      emitAnchorRelationshipChange({ blocked: true, followed: false, userId })
    } catch (cause) {
      if (requestedGeneration === generation && requestedOwner === activeOwner()) {
        Object.assign(entry, previous)
      }
      throw cause
    } finally {
      if (requestedGeneration === generation) pendingKeys.delete(key)
    }
  }

  async function unblock(target: RelationshipTarget): Promise<void> {
    const requestedOwner = bindOwner()
    const userId = targetKey(target)
    if (!userId) throw new Error('Invalid unblock target.')
    const entry = mutableEntry(userId)
    const key = `unblock:${userId}`
    if (pendingKeys.has(key)) throw new Error('The unblock request is already in progress.')
    const previous = {
      blocked: entry.blocked,
      blockedKnown: entry.blockedKnown,
      blockLocked: entry.blockLocked,
    }
    const requestedGeneration = generation
    entry.blocked = false
    entry.blockedKnown = true
    entry.blockLocked = true
    pendingKeys.add(key)
    try {
      await relationshipActions.unblock({
        ...target,
        userId,
        userType: entry.userType,
      })
      if (requestedGeneration !== generation || requestedOwner !== activeOwner()) return
      blockedUserIds.delete(userId)
      blockOverrides.set(userId, false)
      emitAnchorRelationshipChange({ blocked: false, userId })
    } catch (cause) {
      if (requestedGeneration === generation && requestedOwner === activeOwner()) {
        entry.blocked = previous.blocked
        entry.blockedKnown = previous.blockedKnown
        entry.blockLocked = previous.blockLocked
      }
      throw cause
    } finally {
      if (requestedGeneration === generation) pendingKeys.delete(key)
    }
  }

  return {
    block,
    blockedIdsReady: readonly(blockedIdsReady),
    canFollow,
    canStartConversation,
    clear,
    isPending,
    loadBlockedIds,
    relationship,
    seed,
    setFollowed,
    unblock,
  }
})

if (import.meta.hot) import.meta.hot.accept(acceptHMRUpdate(useRelationshipsStore, import.meta.hot))

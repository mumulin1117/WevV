import { getAuthProvider } from '@/core/auth/runtime'
import type { RealtimeCredential } from '@/core/realtime/contracts'
import type { UserProfile } from '@/features/profile/contracts'
import { defineStore } from 'pinia'
import { computed, readonly, ref, shallowRef } from 'vue'

export interface SessionUser {
  avatar: string
  displayName: string
  id: string
}

export function mergeProfileIdentity(value: UserProfile, accountId: string): UserProfile {
  if (value.id && value.id !== accountId)
    throw new Error('The profile response belongs to another account.')
  return {
    ...value,
    diamondCount: Math.max(0, value.diamondCount),
    id: accountId,
  }
}

export const useSessionStore = defineStore('session', () => {
  const authProvider = getAuthProvider()
  const user = ref<SessionUser | null>(null)
  const profile = shallowRef<UserProfile | null>(null)
  const balanceValue = ref(0)
  const token = computed(() => authProvider.getAccessToken())
  const authenticated = computed(() => Boolean(token.value && user.value?.id))
  const balance = computed(() => balanceValue.value)
  const imToken = computed(() => '')

  function initializeRoomSession(accessToken: string, accountId: string): void {
    authProvider.setSession({
      accessToken,
      accessTokenExpiresAt: Number.MAX_SAFE_INTEGER,
      accountId,
      refreshToken: '',
      refreshTokenExpiresAt: 0,
    })
    user.value = {
      avatar: '',
      displayName: `User ${accountId}`,
      id: accountId,
    }
  }

  function applyProfile(value: UserProfile): UserProfile {
    const accountId = user.value?.id ?? authProvider.getSession()?.accountId ?? ''
    if (!accountId) throw new Error('The account session is unavailable.')
    const normalized = mergeProfileIdentity(value, accountId)
    profile.value = normalized
    balanceValue.value = normalized.diamondCount
    user.value = {
      avatar: normalized.avatarUrl,
      displayName: normalized.displayName,
      id: accountId,
    }
    return normalized
  }

  async function updateBalance(value: number): Promise<void> {
    if (!Number.isFinite(value) || value < 0) return
    balanceValue.value = value
    if (profile.value) profile.value = { ...profile.value, diamondCount: value }
  }

  async function ensureRealtimeCredential(): Promise<RealtimeCredential | null> {
    return null
  }

  function clearSession(): void {
    authProvider.clearSession()
    user.value = null
    profile.value = null
    balanceValue.value = 0
  }

  return {
    authenticated,
    applyProfile,
    balance,
    clearSession,
    container: readonly(ref<'swift'>('swift')),
    ensureRealtimeCredential,
    imToken,
    initializeRoomSession,
    profile: readonly(profile),
    token,
    updateBalance,
    user,
  }
})

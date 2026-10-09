import { readonly, ref } from 'vue'
import { createId } from '@/shared/id'

export interface AuthSession {
  accountId: string
  accessToken: string | null
  accessTokenExpiresAt: number
  legacyToken?: string
  refreshToken: string
  refreshTokenExpiresAt: number
}

export interface AuthProvider {
  readonly authenticated: Readonly<ReturnType<typeof ref<boolean>>>
  readonly sessionEpoch: Readonly<ReturnType<typeof ref<string>>>
  getAccessToken: () => string | null
  getSapiSourceToken: () => string | null
  getSession: () => AuthSession | null
  recoverAfterUnauthorized: () => Promise<boolean>
  setSession: (session: AuthSession) => void
  updateSession: (session: AuthSession) => void
  clearSession: () => void
  subscribe: (listener: AuthEventListener) => () => void
}

export type AuthEvent = { session: AuthSession; type: 'refreshed' } | { type: 'invalidated' }
export type AuthEventListener = (event: AuthEvent) => void

export type SessionRecoveryHandler = (current: AuthSession | null) => Promise<AuthSession | null>

export function createAuthProvider(recoveryHandler?: SessionRecoveryHandler): AuthProvider {
  const authenticated = ref(false)
  const sessionEpoch = ref(createId('session'))
  let session: AuthSession | null = null
  let recovering: Promise<boolean> | undefined
  const listeners = new Set<AuthEventListener>()

  const emit = (event: AuthEvent): void => listeners.forEach((listener) => listener(event))

  const clearSession = () => {
    session = null
    authenticated.value = false
    sessionEpoch.value = createId('session')
  }

  const invalidateSession = () => {
    const hadSession = Boolean(session || authenticated.value)
    clearSession()
    if (hadSession) emit({ type: 'invalidated' })
  }

  return {
    authenticated: readonly(authenticated),
    sessionEpoch: readonly(sessionEpoch),
    getAccessToken: () => session?.accessToken ?? null,
    // Android/H5 的 /sapi 与已批准的 VIP /api 鉴权先用老 weidou token；老会话缺失时才回退 OPI accessToken。
    getSapiSourceToken: () => session?.legacyToken || session?.accessToken || null,
    getSession: () => session,
    setSession(next) {
      session = next
      authenticated.value = true
      sessionEpoch.value = createId(`session-${next.accountId}`)
    },
    subscribe(listener) {
      listeners.add(listener)
      return () => listeners.delete(listener)
    },
    updateSession(next) {
      if (!session || session.accountId !== next.accountId)
        throw new Error('An authentication session cannot change accounts in place.')
      session = next
      authenticated.value = true
    },
    clearSession,
    async recoverAfterUnauthorized() {
      recovering ??= Promise.resolve(recoveryHandler ? recoveryHandler(session) : null)
        .then((next) => {
          if (!next) {
            invalidateSession()
            return false
          }
          session = next
          authenticated.value = true
          emit({ session: next, type: 'refreshed' })
          return true
        })
        .finally(() => {
          recovering = undefined
        })
      return recovering
    },
  }
}

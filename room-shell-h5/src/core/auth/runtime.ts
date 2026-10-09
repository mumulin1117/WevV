import { ApiClient } from '@/core/api/client'
import { SapiClient } from '@/core/api/sapi-client'
import type { ObservabilityAdapter } from '@/core/observability/observability'
import { createAuthProvider, type AuthProvider } from './auth-provider'

interface AuthRuntime {
  apiClient: ApiClient
  authProvider: AuthProvider
  sapiClient?: SapiClient
}

let runtime: AuthRuntime | undefined

export function initializeAuthRuntime(observability: ObservabilityAdapter): AuthRuntime {
  const authProvider = createAuthProvider()
  const apiClient = new ApiClient(authProvider, observability)
  runtime = {
    apiClient,
    authProvider,
  }
  return runtime
}

function requireRuntime(): AuthRuntime {
  if (!runtime) throw new Error('The authentication runtime has not been initialized.')
  return runtime
}

export function getApiClient(): ApiClient {
  return requireRuntime().apiClient
}

export function getAuthProvider(): AuthProvider {
  return requireRuntime().authProvider
}

export function getSapiClient(): SapiClient {
  const current = requireRuntime()
  current.sapiClient ??= new SapiClient(current.apiClient)
  return current.sapiClient
}

export function cancelSapiClient(reason?: string): void {
  runtime?.sapiClient?.cancelAll(reason)
}

export function resetAuthRuntimeForTests(): void {
  runtime = undefined
}

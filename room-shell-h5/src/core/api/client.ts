import type { AuthProvider } from '@/core/auth/auth-provider'
import { getRuntimeConfig } from '@/core/config/runtime-config'
import type { ObservabilityAdapter } from '@/core/observability/observability'
import axios, {
  type AxiosError,
  type AxiosInstance,
  type AxiosRequestConfig,
  type RawAxiosHeaders,
} from 'axios'
import type { ZodType } from 'zod'
import { getClientContext } from '@/core/device/client-context'
import { decryptOpiResult, encryptOpiPayload } from './opi-v2-codec'
import { getProductModeOrNull } from '@/core/product-mode/runtime'

export type ApiErrorKind =
  | 'aborted'
  | 'business'
  | 'network'
  | 'local-product'
  | 'rate-limit'
  | 'server'
  | 'timeout'
  | 'unauthorized'
  | 'validation'

export class ApiClientError extends Error {
  constructor(
    readonly kind: ApiErrorKind,
    message: string,
    readonly status?: number,
    readonly code?: string,
    readonly traceId?: string,
    readonly cause?: unknown,
    readonly details?: unknown,
    readonly sessionInvalidated = false,
  ) {
    super(message)
    this.name = 'ApiClientError'
  }
}

export type ApiAuthMode = 'none' | 'optional' | 'required'

export interface ApiRequest<T> extends AxiosRequestConfig {
  authRecoveryAttempts?: number
  authMode: ApiAuthMode
  retryAfterAuthRecovery?: boolean
  schema?: ZodType<T>
}

export class ApiClient {
  private readonly controllers = new Set<AbortController>()
  private readonly transport: AxiosInstance

  constructor(
    private readonly auth: AuthProvider,
    private readonly observability: ObservabilityAdapter,
  ) {
    this.transport = axios.create({
      baseURL: getRuntimeConfig().api.baseUrl,
      timeout: getRuntimeConfig().api.timeoutMs,
      withCredentials: false,
      headers: { Accept: 'application/json' },
    })
  }

  cancelAll(reason = 'Session changed.'): void {
    for (const controller of this.controllers) controller.abort(reason)
    this.controllers.clear()
  }

  async request<T>(request: ApiRequest<T>): Promise<T> {
    const controller = new AbortController()
    const sourceSignal = request.signal
    const abortFromSource = () => controller.abort()
    if (sourceSignal?.aborted) abortFromSource()
    else sourceSignal?.addEventListener?.('abort', abortFromSource, { once: true })
    this.controllers.add(controller)
    let attemptedAccessToken: string | null = null
    try {
      if (getProductModeOrNull()?.mode === 'local') {
        throw new ApiClientError(
          'local-product',
          'Remote requests are unavailable in the local product.',
          undefined,
          'LOCAL_PRODUCT_REMOTE_BLOCKED',
        )
      }
      const startedAt = performance.now()
      const runtime = getRuntimeConfig()
      const apiClient = runtime.api
      const headers = axios.AxiosHeaders.from(request.headers as RawAxiosHeaders | undefined)
      const token = request.authMode === 'none' ? null : this.auth.getAccessToken()
      attemptedAccessToken = token
      if (request.authMode === 'required' && !token) {
        throw new ApiClientError(
          'unauthorized',
          'Please sign in to continue.',
          401,
          'AUTH_TOKEN_MISSING',
        )
      }
      let data = request.data
      const url = request.url
      const clientContext = getClientContext()
      const appLanguage = document.documentElement.lang || runtime.app.defaultLocale
      headers.set('Accept', 'application/json, text/plain')
      headers.set('Accept-Language', appLanguage)
      headers.set('Content-Type', 'application/json;charset=UTF-8')
      // Use the backend's semantic paths, headers and fields without alias mapping.
      headers.set('appId', runtime.app.appId)
      headers.set('appVersion', clientContext.appVersion)
      headers.set('deviceNo', clientContext.deviceNo)
      headers.set('language', appLanguage)
      moveOptionalOpiHeaders(headers)
      if (token) headers.set('Authorization', `Bearer ${token}`)
      if (!url) throw new Error('An OPI V2 request path is required.')
      data = await encryptOpiPayload(data ?? {}, apiClient)
      const {
        authRecoveryAttempts: _authRecoveryAttempts,
        authMode: _authMode,
        retryAfterAuthRecovery: _retryAfterAuthRecovery,
        schema: _schema,
        ...transportRequest
      } = request
      const response = await this.transport.request({
        ...transportRequest,
        data,
        headers,
        signal: controller.signal,
        url,
        // Send the AES-CBC payload as a hexadecimal string.
        transformRequest:
          data !== undefined ? [(value) => value] : transportRequest.transformRequest,
      })
      const traceId = String(response.headers['x-trace-id'] ?? '')
      this.observability.metric('api.duration', performance.now() - startedAt, {
        method: request.method ?? 'GET',
        path: request.url ?? '',
        status: String(response.status),
      })
      const responseData = await unwrapOpiResponse(
        response.data,
        apiClient,
        response.status,
        traceId,
      )
      if (!request.schema) return responseData as T
      const parsed = request.schema.safeParse(responseData)
      if (!parsed.success) {
        throw new ApiClientError(
          'validation',
          'The server response is invalid.',
          response.status,
          'INVALID_RESPONSE',
          traceId,
          parsed.error,
        )
      }
      return parsed.data
    } catch (cause) {
      const normalized = normalizeApiError(cause)
      if (normalized.kind === 'unauthorized' && request.retryAfterAuthRecovery !== false) {
        // Several startup requests can fail with the same expired token after the first
        // refresh has already completed. Reuse that newer token instead of rotating the
        // session once per late 401 response.
        const latestToken = this.auth.getAccessToken()
        const authRecoveryAttempts = request.authRecoveryAttempts ?? 0
        if (authRecoveryAttempts >= 8) {
          const invalidated = markSessionInvalidated(normalized)
          this.observability.captureError(invalidated, { path: request.url ?? '', source: 'api' })
          throw invalidated
        }
        if (attemptedAccessToken && latestToken && latestToken !== attemptedAccessToken)
          return this.request({ ...request, authRecoveryAttempts: authRecoveryAttempts + 1 })
        if (await this.auth.recoverAfterUnauthorized()) {
          return this.request({ ...request, authRecoveryAttempts: authRecoveryAttempts + 1 })
        }
        const invalidated = markSessionInvalidated(normalized)
        this.observability.captureError(invalidated, { path: request.url ?? '', source: 'api' })
        throw invalidated
      }
      this.observability.captureError(normalized, { path: request.url ?? '', source: 'api' })
      throw normalized
    } finally {
      this.controllers.delete(controller)
      sourceSignal?.removeEventListener?.('abort', abortFromSource)
    }
  }
}

async function unwrapOpiResponse(
  value: unknown,
  config: ReturnType<typeof getRuntimeConfig>['api'],
  status: number,
  traceId: string,
): Promise<unknown> {
  if (!value || typeof value !== 'object' || Array.isArray(value))
    throw new ApiClientError(
      'validation',
      'The server response is invalid.',
      status,
      'INVALID_ENVELOPE',
      traceId,
    )
  const envelope = value as {
    code?: unknown
    message?: unknown
    requestId?: unknown
    result?: unknown
  }
  const code = String(envelope.code ?? '')
  const requestId = typeof envelope.requestId === 'string' ? envelope.requestId : traceId
  const message =
    typeof envelope.message === 'string' && envelope.message.trim()
      ? envelope.message
      : 'The request failed.'
  let decoded = envelope.result ?? null
  if (typeof decoded === 'string' && decoded !== '') {
    try {
      decoded = await decryptOpiResult(decoded, config)
    } catch (cause) {
      throw new ApiClientError(
        'validation',
        'The server response could not be decoded.',
        status,
        'DECRYPTION_FAILED',
        requestId,
        cause,
      )
    }
  }
  if (code !== '0') {
    const unauthorized = isUnauthorizedResponse(code, message)
    throw new ApiClientError(
      unauthorized ? 'unauthorized' : 'business',
      message,
      status,
      code,
      requestId,
      undefined,
      decoded,
    )
  }
  return decoded
}

function moveOptionalOpiHeaders(headers: InstanceType<typeof axios.AxiosHeaders>): void {
  for (const semanticName of ['loginToken', 'pushToken', 'refreshToken'] as const) {
    const value = headers.get(semanticName)
    headers.delete(semanticName)
    if (value !== undefined && value !== null) headers.set(semanticName, value)
  }
}

function isUnauthorizedResponse(code: string | undefined, message: string): boolean {
  return (
    code === '1004' ||
    /^4010[1-5]$/u.test(code ?? '') ||
    message.trim().toLowerCase() === 'request.unauthorized'
  )
}

function markSessionInvalidated(error: ApiClientError): ApiClientError {
  return new ApiClientError(
    error.kind,
    error.message,
    error.status,
    error.code,
    error.traceId,
    error.cause,
    error.details,
    true,
  )
}

export function normalizeApiError(cause: unknown): ApiClientError {
  if (cause instanceof ApiClientError) return cause
  if (!axios.isAxiosError(cause))
    return new ApiClientError(
      'business',
      'Something went wrong.',
      undefined,
      undefined,
      undefined,
      cause,
    )
  const error = cause as AxiosError<{ code?: string; message?: string }>
  if (error.code === 'ERR_CANCELED')
    return new ApiClientError(
      'aborted',
      'The request was cancelled.',
      undefined,
      undefined,
      undefined,
      cause,
    )
  if (error.code === 'ECONNABORTED')
    return new ApiClientError(
      'timeout',
      'The request timed out.',
      undefined,
      undefined,
      undefined,
      cause,
    )
  if (!error.response)
    return new ApiClientError(
      'network',
      'Check your internet connection.',
      undefined,
      undefined,
      undefined,
      cause,
    )
  const status = error.response.status
  const traceId = String(error.response.headers['x-trace-id'] ?? '')
  const message = error.response.data?.message || 'The request failed.'
  const code = error.response.data?.code
  if (status === 401 || isUnauthorizedResponse(code, message))
    return new ApiClientError('unauthorized', message, status, code, traceId, cause)
  if (status === 429) return new ApiClientError('rate-limit', message, status, code, traceId, cause)
  if (status >= 500) return new ApiClientError('server', message, status, code, traceId, cause)
  return new ApiClientError('business', message, status, code, traceId, cause)
}

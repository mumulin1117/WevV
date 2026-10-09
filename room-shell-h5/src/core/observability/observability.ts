import { getRuntimeConfig } from '@/core/config/runtime-config'

export type LogLevel = 'debug' | 'error' | 'info' | 'warn'
export type DiagnosticValue = boolean | number | string | undefined
export type DiagnosticContext = Record<string, DiagnosticValue>

export interface DiagnosticEntry {
  context?: DiagnosticContext
  level: LogLevel
  message: string
  timestamp: number
}

export interface ObservabilityAdapter {
  captureError: (error: unknown, context?: DiagnosticContext) => void
  exportReport: () => string
  log: (level: LogLevel, message: string, context?: DiagnosticContext) => void
  metric: (name: string, value: number, context?: DiagnosticContext) => void
}

const sensitiveKey = /authorization|token|password|message|email|phone/iu

function sanitize(context?: DiagnosticContext): DiagnosticContext | undefined {
  if (!context) return undefined
  return Object.fromEntries(
    Object.entries(context).map(([key, value]) => [
      key,
      sensitiveKey.test(key) ? '[redacted]' : value,
    ]),
  )
}

export function createObservabilityAdapter(limit = 300): ObservabilityAdapter {
  const entries: DiagnosticEntry[] = []
  const append = (entry: DiagnosticEntry) => {
    entries.push(entry)
    if (entries.length > limit) entries.splice(0, entries.length - limit)
  }
  return {
    captureError(error, context) {
      append({
        context: sanitize(context),
        level: 'error',
        message: error instanceof Error ? `${error.name}: ${error.message}` : String(error),
        timestamp: Date.now(),
      })
    },
    exportReport() {
      const config = getRuntimeConfig()
      return JSON.stringify(
        {
          appId: config.app.appId,
          buildId: config.build.buildId,
          entries,
          route: window.location.pathname,
          userAgent: navigator.userAgent,
        },
        null,
        2,
      )
    },
    log(level, message, context) {
      append({ context: sanitize(context), level, message, timestamp: Date.now() })
    },
    metric(name, value, context) {
      append({
        context: sanitize({ ...context, value }),
        level: 'info',
        message: `metric:${name}`,
        timestamp: Date.now(),
      })
    },
  }
}

export function installGlobalErrorCapture(adapter: ObservabilityAdapter): () => void {
  const onError = (event: ErrorEvent) =>
    adapter.captureError(event.error ?? event.message, { source: 'window' })
  const onRejection = (event: PromiseRejectionEvent) =>
    adapter.captureError(event.reason, { source: 'promise' })
  window.addEventListener('error', onError)
  window.addEventListener('unhandledrejection', onRejection)
  return () => {
    window.removeEventListener('error', onError)
    window.removeEventListener('unhandledrejection', onRejection)
  }
}

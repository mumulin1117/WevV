import type { DiagnosticContext, ObservabilityAdapter } from './observability'

let runtimeAdapter: ObservabilityAdapter | undefined

export function initializeObservabilityRuntime(adapter: ObservabilityAdapter): void {
  runtimeAdapter = adapter
}

export function reportRuntimeMetric(
  name: string,
  value: number,
  context?: DiagnosticContext,
): void {
  runtimeAdapter?.metric(name, value, context)
}

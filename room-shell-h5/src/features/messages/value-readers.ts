export type UnknownRecord = Record<string, unknown>

export const asRecord = (value: unknown): UnknownRecord | null =>
  value !== null && typeof value === 'object' && !Array.isArray(value)
    ? (value as UnknownRecord)
    : null

export function first(source: UnknownRecord, ...keys: string[]): unknown {
  for (const key of keys) if (source[key] !== undefined && source[key] !== null) return source[key]
  return undefined
}

export function text(source: UnknownRecord, ...keys: string[]): string {
  const value = first(source, ...keys)
  return typeof value === 'string' || typeof value === 'number' ? String(value).trim() : ''
}

export function integer(source: UnknownRecord, ...keys: string[]): number {
  const value = Number(first(source, ...keys) ?? 0)
  return Number.isFinite(value) ? Math.trunc(value) : 0
}

export function bool(source: UnknownRecord, ...keys: string[]): boolean {
  const value = first(source, ...keys)
  if (typeof value === 'boolean') return value
  if (typeof value === 'number') return value !== 0
  return ['1', 'true', 'online'].includes(String(value ?? '').toLowerCase())
}

export function records(value: unknown): UnknownRecord[] {
  if (Array.isArray(value)) return value.map(asRecord).filter((item) => item !== null)
  const root = asRecord(value)
  if (!root) return []
  for (const key of ['rows', 'list', 'items', 'records']) {
    const nested = root[key]
    if (Array.isArray(nested)) return nested.map(asRecord).filter((item) => item !== null)
  }
  return []
}

export function parseJsonRecord(value: unknown): UnknownRecord {
  if (typeof value !== 'string' || !value.trim()) return asRecord(value) ?? {}
  try {
    return asRecord(JSON.parse(value)) ?? {}
  } catch {
    return {}
  }
}

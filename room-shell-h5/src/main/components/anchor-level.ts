export type AnchorLevel = 'A' | 'S' | 'SS'

const ANCHOR_LEVELS = new Set<AnchorLevel>(['A', 'S', 'SS'])

/**
 * 主播等级只认服务端返回的 A / S / SS 三档，其他值不展示。
 */
export function parseAnchorLevel(value: string | null | undefined): AnchorLevel | null {
  if (typeof value !== 'string') return null
  const normalized = value.trim().toUpperCase()
  return ANCHOR_LEVELS.has(normalized as AnchorLevel) ? (normalized as AnchorLevel) : null
}

export type UserLevelInput = number | string | null | undefined

const USER_LEVEL_PATTERN = /^(?:(?:lv|level)[.\s-]*)?(\d+)$/iu

/**
 * 只解析用户数字等级。主播的 S / SS / NEW 等档位不是用户等级，必须保留原展示。
 */
export function parseUserLevel(value: UserLevelInput): number | null {
  if (typeof value === 'number') {
    return Number.isSafeInteger(value) && value >= 0 ? value : null
  }
  if (typeof value !== 'string') return null

  const match = value.trim().match(USER_LEVEL_PATTERN)
  if (!match?.[1]) return null
  const level = Number(match[1])
  return Number.isSafeInteger(level) ? level : null
}

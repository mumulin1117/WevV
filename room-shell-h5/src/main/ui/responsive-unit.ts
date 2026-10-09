const DESIGN_VIEWPORT_WIDTH = 375
const MAX_DISPLAY_WIDTH = 600
const PRECISION = 3

function round(value: number): number {
  const factor = 10 ** PRECISION
  return Math.round(value * factor) / factor
}

/**
 * Converts design pixels used by runtime inline styles to the same responsive
 * value emitted by postcss-mobile-forever.
 *
 * Percentages, CSS variables, calc expressions and other authored CSS values
 * pass through unchanged. Runtime viewport/gesture measurements should not use
 * this helper because they are already physical CSS pixels.
 */
export function responsiveCssLength(value?: number | string): string | undefined {
  if (value === undefined) return undefined

  const rawValue = typeof value === 'string' ? value.trim() : value
  const matchedValue =
    typeof rawValue === 'number'
      ? rawValue
      : /^-?(?:\d+\.?\d*|\.\d+)(?:px)?$/i.test(rawValue)
        ? Number.parseFloat(rawValue)
        : undefined

  if (matchedValue === undefined || !Number.isFinite(matchedValue)) return String(value)
  if (matchedValue === 0) return '0px'

  const viewportValue = round((matchedValue * 100) / DESIGN_VIEWPORT_WIDTH)
  const maximumValue = round((matchedValue * MAX_DISPLAY_WIDTH) / DESIGN_VIEWPORT_WIDTH)
  const cssFunction = matchedValue > 0 ? 'min' : 'max'
  return `${cssFunction}(${viewportValue}vw, ${maximumValue}px)`
}

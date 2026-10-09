import type { CSSProperties } from 'vue'

const LEGACY_LIVE_ASSET_BASE = 'https://img.hnhily.link/mstatic/live'
const LEGACY_GUARDIAN_ASSET_BASE = 'https://file.lovetravel.link/mstatic/guardian'

export const LEGACY_LIVE_HOST_BADGE_URL = `${LEGACY_LIVE_ASSET_BASE}/live_host_icon.webp`
export const LEGACY_LIVE_NEW_USER_BADGE_URL = `${LEGACY_LIVE_ASSET_BASE}/new_user3.webp`
export const LEGACY_LIVE_USER_ENTRY_BACKGROUND_URL = `${LEGACY_LIVE_ASSET_BASE}/live_user_bg.webp`
export const LEGACY_LIVE_USER_ENTRY_BACKGROUND_RTL_URL = `${LEGACY_LIVE_ASSET_BASE}/live_user_bg1.webp`

const GUARDIAN_BADGE_URLS = {
  1: `${LEGACY_GUARDIAN_ASSET_BASE}/ic_guardian_tab_bronze.webp`,
  2: `${LEGACY_GUARDIAN_ASSET_BASE}/ic_guardian_tab_silver.webp`,
  3: `${LEGACY_GUARDIAN_ASSET_BASE}/ic_guardian_tab_gold.webp`,
} as const

const GUARDIAN_ENTRY_BACKGROUND_URLS = {
  1: `${LEGACY_GUARDIAN_ASSET_BASE}/bg_guardian_enter_bronze.webp`,
  2: `${LEGACY_GUARDIAN_ASSET_BASE}/bg_guardian_enter_silver.webp`,
  3: `${LEGACY_GUARDIAN_ASSET_BASE}/bg_guardian_enter_gold.webp`,
} as const

function guardianTier(value: number | undefined): 1 | 2 | 3 {
  const level = Math.trunc(Number(value) || 0)
  if (level >= 3) return 3
  if (level === 2) return 2
  return 1
}

export function legacyGuardianBadgeUrl(level: number | undefined): string {
  return GUARDIAN_BADGE_URLS[guardianTier(level)]
}

export function legacyGuardianEntryStyle(level: number | undefined): CSSProperties {
  return {
    backgroundImage: `url(${GUARDIAN_ENTRY_BACKGROUND_URLS[guardianTier(level)]})`,
    backgroundPosition: 'center',
    backgroundRepeat: 'no-repeat',
    backgroundSize: '100% 100%',
  }
}

export function legacyUserEntryStyle(value: number | undefined): CSSProperties {
  const level = Math.max(0, Math.trunc(Number(value) || 0))
  if (level >= 46) {
    const border = level <= 50 ? 7 : level <= 55 ? 8 : level <= 60 ? 9 : level <= 65 ? 10 : 12
    return {
      backgroundImage: `url(${LEGACY_LIVE_ASSET_BASE}/level_border_${border}.webp)`,
      backgroundPosition: 'center',
      backgroundRepeat: 'no-repeat',
      backgroundSize: '100% 100%',
    }
  }

  const color =
    level <= 1
      ? 'var(--color-user-entry-level-0)'
      : level <= 10
        ? 'var(--color-user-entry-level-1)'
        : level <= 20
          ? 'var(--color-user-entry-level-2)'
          : level <= 30
            ? 'var(--color-user-entry-level-3)'
            : level <= 40
              ? 'var(--color-user-entry-level-4)'
              : 'var(--color-user-entry-level-5)'
  return { background: `linear-gradient(90deg, ${color} 50%, transparent 100%)` }
}

export function legacyChatBubbleStyle(url: string | undefined): CSSProperties | undefined {
  const source = url?.trim()
  return source ? { borderImageSource: `url(${source})` } : undefined
}

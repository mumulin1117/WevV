import { getRuntimeConfig } from '@/core/config/runtime-config'

export function initializeTheme(): void {
  const config = getRuntimeConfig()
  document.title = config.app.documentTitle
  const root = document.documentElement.style
  root.setProperty('--color-primary', config.theme.primary)
  root.setProperty('--color-secondary', config.theme.secondary)
  root.setProperty('--color-accent', config.theme.accent)
  root.setProperty(
    '--gradient-primary',
    `linear-gradient(90deg, ${config.theme.primary}, ${config.theme.secondary})`,
  )
  document
    .querySelector<HTMLMetaElement>('meta[name="theme-color"]')
    ?.setAttribute('content', config.theme.primary)
}

import { getRuntimeConfig } from '@/core/config/runtime-config'
import { createI18n } from 'vue-i18n'
import en from './locales/en'

export const i18n = createI18n({
  legacy: false,
  locale: 'en',
  fallbackLocale: 'en',
  messages: { en },
  missingWarn: import.meta.env.DEV,
  fallbackWarn: import.meta.env.DEV,
})

export async function initializeLocale(nativeLocale?: string): Promise<void> {
  const config = getRuntimeConfig()
  const requested = nativeLocale || config.app.defaultLocale
  const baseLocale = requested.split('-')[0]
  const supported = baseLocale === 'en' ? 'en' : 'en'
  i18n.global.locale.value = supported as 'en'
  document.documentElement.lang = supported
}

export async function setLocale(locale: string): Promise<void> {
  if (locale === 'en') {
    i18n.global.locale.value = 'en'
    document.documentElement.lang = 'en'
    return
  }

  // Future locale packages are lazy-loaded here so the English first release
  // does not pay for translations it does not ship.
  throw new Error(`Locale "${locale}" is not included in this build.`)
}

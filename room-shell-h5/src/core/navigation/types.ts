import type { RouteLocationNormalizedLoaded, RouteLocationRaw } from 'vue-router'

export type PageKind = 'auth' | 'tab' | 'stack' | 'modal' | 'external'
export type NavigationMotion = 'none' | 'forward' | 'back' | 'modal'
export type PageCachePolicy = 'none' | 'snapshot' | 'live'

export interface AppRouteMeta {
  cachePolicy: PageCachePolicy
  fallbackPath?: string
  pageKind: PageKind
  requiresAuth: boolean
  swipeBack: boolean
  transition: NavigationMotion
}

export interface NavigationEntry {
  cacheKey: string
  fullPath: string
  pageKind: PageKind
  title?: string
}

export interface PushOptions {
  motion?: NavigationMotion
  replace?: boolean
}

export interface NavigationApi {
  acquireGestureLock: (source: string) => () => void
  backPage: (fallback?: RouteLocationRaw) => Promise<void>
  cacheKeyForRoute: (route: RouteLocationNormalizedLoaded) => string
  finishAuth: (target?: RouteLocationRaw) => Promise<void>
  pushPage: (to: RouteLocationRaw, options?: PushOptions) => Promise<void>
  replacePage: (to: RouteLocationRaw) => Promise<void>
  resetToLogin: () => Promise<void>
  switchTab: (to: RouteLocationRaw) => Promise<void>
}

declare module 'vue-router' {
  interface RouteMeta extends AppRouteMeta {}
}

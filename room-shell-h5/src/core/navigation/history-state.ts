import { parseQuery, type HistoryState, type RouteLocationRaw } from 'vue-router'
import type { NavigationEntry } from './types'

export const NAVIGATION_HISTORY_STATE_KEY = '__socialNavigation'

export interface NavigationHistoryState {
  depth: number
  entryId: string
  pageKind: NavigationEntry['pageKind']
  sessionEpoch: string
  tabId: string | null
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value)
}

export function isNavigationHistoryState(value: unknown): value is NavigationHistoryState {
  if (!isRecord(value)) return false
  return (
    Number.isSafeInteger(value.depth) &&
    Number(value.depth) >= 0 &&
    typeof value.entryId === 'string' &&
    value.entryId.length > 0 &&
    ['auth', 'tab', 'stack', 'modal', 'external'].includes(String(value.pageKind)) &&
    typeof value.sessionEpoch === 'string' &&
    value.sessionEpoch.length > 0 &&
    (value.tabId === null || typeof value.tabId === 'string')
  )
}

export function readNavigationHistoryState(
  state: unknown = window.history.state,
): NavigationHistoryState | null {
  if (!isRecord(state)) return null
  const navigationState = state[NAVIGATION_HISTORY_STATE_KEY]
  return isNavigationHistoryState(navigationState) ? navigationState : null
}

export function createNavigationHistoryState(
  entry: NavigationEntry,
  depth: number,
  sessionEpoch: string,
  tabId: string | null,
): NavigationHistoryState {
  return {
    depth: Math.max(0, depth),
    entryId: entry.cacheKey,
    pageKind: entry.pageKind,
    sessionEpoch,
    tabId,
  }
}

function routeState(to: RouteLocationRaw): HistoryState {
  if (typeof to !== 'object' || to === null || !('state' in to)) return {}
  return (to.state ?? {}) as HistoryState
}

export function withNavigationHistoryState(
  to: RouteLocationRaw,
  navigationState: NavigationHistoryState,
): RouteLocationRaw {
  const state: HistoryState = {
    ...routeState(to),
    [NAVIGATION_HISTORY_STATE_KEY]: navigationState as unknown as HistoryState,
  }
  if (typeof to === 'string') {
    const hashIndex = to.indexOf('#')
    const beforeHash = hashIndex >= 0 ? to.slice(0, hashIndex) : to
    const hash = hashIndex >= 0 ? to.slice(hashIndex) : ''
    const queryIndex = beforeHash.indexOf('?')
    const path = queryIndex >= 0 ? beforeHash.slice(0, queryIndex) : beforeHash
    const search = queryIndex >= 0 ? beforeHash.slice(queryIndex + 1) : ''
    return {
      hash,
      path,
      query: parseQuery(search),
      state,
    }
  }
  return { ...to, state }
}

export function replaceCurrentNavigationHistoryState(
  navigationState: NavigationHistoryState,
): void {
  window.history.replaceState(
    {
      ...(window.history.state ?? {}),
      [NAVIGATION_HISTORY_STATE_KEY]: navigationState,
    },
    document.title,
  )
}

import { computed, inject, readonly, ref, shallowRef } from 'vue'
import type { InjectionKey, Ref, ShallowRef } from 'vue'
import type { RouteLocationNormalizedLoaded, RouteLocationRaw, Router } from 'vue-router'
import { createId } from '@/shared/id'
import {
  createNavigationHistoryState,
  readNavigationHistoryState,
  replaceCurrentNavigationHistoryState,
  withNavigationHistoryState,
} from './history-state'
import type { NavigationHistoryState } from './history-state'
import { NavigationStack } from './stack'
import type { NavigationStackSnapshot } from './stack'
import type { NavigationApi, NavigationMotion, PageKind, PushOptions } from './types'

export type ScenePhase = 'idle' | 'navigating' | 'animating'
type NavigationAction = 'history' | 'push' | 'button-back' | 'replace'

export interface NavigationCoordinator extends NavigationApi {
  canSwipeBack: Readonly<Ref<boolean>>
  completeAnimation: () => void
  currentRoute: ShallowRef<RouteLocationNormalizedLoaded>
  liveCacheEpoch: Readonly<Ref<string>>
  motion: Readonly<Ref<NavigationMotion>>
  nativeGestureEnabled: Readonly<Ref<boolean>>
  phase: Readonly<Ref<ScenePhase>>
  previousRoute: ShallowRef<RouteLocationNormalizedLoaded | null>
}

export interface NavigationGestureHost {
  setEnabled: (enabled: boolean, reason: string) => Promise<void>
}

export const navigationKey: InjectionKey<NavigationCoordinator> = Symbol('navigation')
const roomSessionEpoch = createId('room-session')

function pageKind(route: RouteLocationNormalizedLoaded): PageKind {
  return route.meta.pageKind ?? 'stack'
}

export function createNavigationCoordinator(
  router: Router,
  gestureHost?: NavigationGestureHost,
): NavigationCoordinator {
  const stack = new NavigationStack()
  const currentRoute = shallowRef(router.currentRoute.value)
  const previousRoute = shallowRef<RouteLocationNormalizedLoaded | null>(null)
  const motion = ref<NavigationMotion>('none')
  const phase = ref<ScenePhase>('idle')
  const pendingAction = ref<NavigationAction>('history')
  const currentHistoryState = shallowRef<NavigationHistoryState | null>(null)
  const liveCacheEpoch = ref(roomSessionEpoch)
  const nativeGestureEnabled = ref(false)
  const initialized = ref(false)
  const gestureLockVersion = ref(0)
  const gestureLocks = new Map<string, number>()
  const routeEntryKeys = new WeakMap<object, string>()
  const latestEntryKeyByPath = new Map<string, string>()

  let pendingMotion: NavigationMotion = 'none'
  let rollbackSnapshot: NavigationStackSnapshot | null = null
  let animationTimer: number | null = null
  let backTimer: number | null = null
  let resolveBack: (() => void) | null = null
  let gestureRequestSequence = 0

  function activeTabId(): string | null {
    return stack.snapshot().activeTab
  }

  function historyStateForCurrent(): NavigationHistoryState | null {
    const entry = stack.current()
    if (!entry) return null
    return createNavigationHistoryState(
      entry,
      Math.max(0, stack.snapshot().entries.length - 1),
      roomSessionEpoch,
      activeTabId(),
    )
  }

  function bindRouteEntry(route: RouteLocationNormalizedLoaded, entryId: string): void {
    routeEntryKeys.set(route, entryId)
    latestEntryKeyByPath.set(route.fullPath, entryId)
  }

  function ensureCurrentHistoryState(
    route: RouteLocationNormalizedLoaded,
  ): NavigationHistoryState | null {
    const expected = historyStateForCurrent()
    if (!expected) return null
    const existing = readNavigationHistoryState()
    if (
      !existing ||
      existing.entryId !== expected.entryId ||
      existing.sessionEpoch !== expected.sessionEpoch ||
      existing.depth !== expected.depth ||
      existing.tabId !== expected.tabId
    ) {
      replaceCurrentNavigationHistoryState(expected)
    }
    bindRouteEntry(route, expected.entryId)
    return expected
  }

  function resetPendingNavigation(): void {
    pendingAction.value = 'history'
    pendingMotion = 'none'
    rollbackSnapshot = null
  }

  async function setNativeGestureEnabled(enabled: boolean, reason: string): Promise<boolean> {
    if (nativeGestureEnabled.value === enabled) return true
    const requestSequence = ++gestureRequestSequence
    try {
      await gestureHost?.setEnabled(enabled, reason)
      if (requestSequence === gestureRequestSequence) nativeGestureEnabled.value = enabled
      return true
    } catch {
      if (requestSequence === gestureRequestSequence && enabled) nativeGestureEnabled.value = false
      return false
    }
  }

  function syncSteadyGestureState(reason: string): void {
    void setNativeGestureEnabled(canSwipeBack.value, reason)
  }

  function settleBackRequest(): void {
    if (backTimer) {
      window.clearTimeout(backTimer)
      backTimer = null
    }
    resolveBack?.()
    resolveBack = null
  }

  function completeAnimation(): void {
    if (phase.value !== 'animating') return
    if (animationTimer) {
      window.clearTimeout(animationTimer)
      animationTimer = null
    }
    phase.value = 'idle'
    motion.value = 'none'
    previousRoute.value = null
    syncSteadyGestureState('animation-complete')
  }

  function scheduleAnimationFallback(): void {
    if (animationTimer) window.clearTimeout(animationTimer)
    animationTimer = window.setTimeout(completeAnimation, 700)
  }

  function rollbackNavigation(): void {
    if (rollbackSnapshot) stack.restore(rollbackSnapshot)
    resetPendingNavigation()
    phase.value = 'idle'
    motion.value = 'none'
    previousRoute.value = null
    settleBackRequest()
    syncSteadyGestureState('navigation-rollback')
  }

  function beginNavigation(
    action: Exclude<NavigationAction, 'history'>,
    nextMotion: NavigationMotion,
  ): boolean {
    if (phase.value !== 'idle') return false
    rollbackSnapshot = stack.snapshot()
    pendingAction.value = action
    pendingMotion = nextMotion
    phase.value = 'navigating'
    return true
  }

  function syncHistoryBack(to: RouteLocationNormalizedLoaded): void {
    const previous = stack.previous()
    const incomingState = readNavigationHistoryState()
    if (
      previous &&
      (incomingState?.entryId === previous.cacheKey ||
        (!incomingState && previous.fullPath === to.fullPath))
    ) {
      stack.back()
      return
    }
    stack.reset(
      to.fullPath,
      pageKind(to),
      incomingState?.sessionEpoch === roomSessionEpoch ? incomingState.entryId : undefined,
    )
  }

  router.afterEach((to, from, failure) => {
    const action = pendingAction.value
    if (failure) {
      rollbackNavigation()
      return
    }

    if (!initialized.value) {
      const incomingState = readNavigationHistoryState()
      const entry = stack.initialize(
        to.fullPath,
        pageKind(to),
        incomingState?.sessionEpoch === roomSessionEpoch ? incomingState.entryId : undefined,
      )
      currentRoute.value = to
      previousRoute.value = null
      currentHistoryState.value = ensureCurrentHistoryState(to)
      bindRouteEntry(to, entry.cacheKey)
      motion.value = 'none'
      phase.value = 'idle'
      initialized.value = true
      resetPendingNavigation()
      syncSteadyGestureState('route-initialized')
      return
    }

    if (action === 'history' || action === 'button-back') syncHistoryBack(to)

    let resolvedAction = action
    if (stack.current()?.fullPath !== to.fullPath) {
      stack.reset(to.fullPath, pageKind(to))
      resolvedAction = 'replace'
    }

    currentHistoryState.value = ensureCurrentHistoryState(to)
    currentRoute.value = to
    const nextMotion: NavigationMotion =
      resolvedAction === 'push' ? pendingMotion : resolvedAction === 'button-back' ? 'back' : 'none'
    previousRoute.value = nextMotion === 'none' ? null : from
    motion.value = nextMotion
    phase.value = nextMotion === 'none' ? 'idle' : 'animating'
    resetPendingNavigation()
    settleBackRequest()
    if (phase.value === 'animating') scheduleAnimationFallback()
    else if (resolvedAction !== 'push') syncSteadyGestureState('route-settled')
  })

  const canSwipeBack = computed(() => {
    void gestureLockVersion.value
    const state = currentHistoryState.value
    return (
      phase.value === 'idle' &&
      gestureLocks.size === 0 &&
      stack.canGoBack() &&
      state?.sessionEpoch === roomSessionEpoch &&
      state.depth > 0 &&
      currentRoute.value.meta.swipeBack !== false &&
      currentRoute.value.meta.pageKind === 'stack'
    )
  })

  function acquireGestureLock(source: string): () => void {
    const key = source.trim() || 'anonymous'
    gestureLocks.set(key, (gestureLocks.get(key) ?? 0) + 1)
    gestureLockVersion.value += 1
    if (phase.value === 'idle') syncSteadyGestureState(`lock:${key}`)
    let released = false
    return () => {
      if (released) return
      released = true
      const count = gestureLocks.get(key) ?? 0
      if (count <= 1) gestureLocks.delete(key)
      else gestureLocks.set(key, count - 1)
      gestureLockVersion.value += 1
      if (phase.value === 'idle') syncSteadyGestureState(`unlock:${key}`)
    }
  }

  function cacheKeyForRoute(route: RouteLocationNormalizedLoaded): string {
    if (route.meta.cachePolicy === 'live') {
      const routeId = typeof route.name === 'string' ? route.name : route.path
      return `live:${routeId}`
    }
    return (
      routeEntryKeys.get(route) ??
      latestEntryKeyByPath.get(route.fullPath) ??
      `${roomSessionEpoch}:${route.fullPath}`
    )
  }

  async function pushPage(to: RouteLocationRaw, options: PushOptions = {}): Promise<void> {
    if (options.replace) {
      await replacePage(to)
      return
    }
    const resolved = router.resolve(to)
    const kind = (resolved.meta.pageKind ?? 'stack') as PageKind
    const nextMotion = options.motion ?? resolved.meta.transition ?? 'forward'
    if (!beginNavigation('push', nextMotion)) return
    // WebKit must have its native history gesture enabled before pushState
    // creates the new entry, otherwise the outgoing page has no back snapshot.
    await setNativeGestureEnabled(true, 'history-push')
    const entry = stack.push(resolved.fullPath, kind)
    const state = historyStateForCurrent()
    if (!state) {
      rollbackNavigation()
      return
    }
    await router.push(
      withNavigationHistoryState(to, {
        ...state,
        entryId: entry.cacheKey,
      }),
    )
  }

  async function replacePage(to: RouteLocationRaw): Promise<void> {
    const resolved = router.resolve(to)
    if (!beginNavigation('replace', 'none')) return
    // 页面替换不依赖原生侧滑开关的回执。先推进 H5 路由，避免 Bridge 在真机上
    // 短暂繁忙时让按钮看起来没有响应；序列号仍会丢弃迟到的旧回执。
    void setNativeGestureEnabled(false, 'history-replace')
    const entry = stack.replace(resolved.fullPath, (resolved.meta.pageKind ?? 'stack') as PageKind)
    const state = historyStateForCurrent()
    if (!state) {
      rollbackNavigation()
      return
    }
    await router.replace(
      withNavigationHistoryState(to, {
        ...state,
        entryId: entry.cacheKey,
      }),
    )
  }

  async function backPage(fallback?: RouteLocationRaw): Promise<void> {
    if (!stack.canGoBack()) {
      const target = fallback ?? currentRoute.value.meta.fallbackPath
      if (target) await replacePage(target)
      return
    }
    if (!beginNavigation('button-back', 'back')) return
    // H5 返回按钮必须立即驱动 history。关闭原生侧滑只需并行同步，不能反向阻塞
    // router.back()；否则 500ms Bridge 超时会直接表现成“返回按钮点不动”。
    void setNativeGestureEnabled(false, 'button-back')
    await new Promise<void>((resolve) => {
      resolveBack = resolve
      router.back()
      backTimer = window.setTimeout(() => {
        rollbackNavigation()
      }, 1_200)
    })
  }

  async function switchTab(to: RouteLocationRaw): Promise<void> {
    const resolved = router.resolve(to)
    if (phase.value === 'idle' && currentRoute.value.fullPath === resolved.fullPath) {
      return
    }
    if (!beginNavigation('replace', 'none')) return
    void setNativeGestureEnabled(false, 'tab-switch')
    const entry = stack.switchTab(resolved.fullPath)
    const state = historyStateForCurrent()
    if (!state) {
      rollbackNavigation()
      return
    }
    await router.replace(
      withNavigationHistoryState(to, {
        ...state,
        entryId: entry.cacheKey,
      }),
    )
  }

  async function resetTo(to: RouteLocationRaw, kind: PageKind): Promise<void> {
    const resolved = router.resolve(to)
    if (!beginNavigation('replace', 'none')) return
    void setNativeGestureEnabled(false, 'stack-reset')
    const nextSessionEpoch = roomSessionEpoch
    if (liveCacheEpoch.value !== nextSessionEpoch) liveCacheEpoch.value = nextSessionEpoch
    const entry = stack.reset(resolved.fullPath, kind)
    const state = historyStateForCurrent()
    if (!state) {
      rollbackNavigation()
      return
    }
    await router.replace(
      withNavigationHistoryState(to, {
        ...state,
        entryId: entry.cacheKey,
      }),
    )
  }

  async function finishAuth(target: RouteLocationRaw = '/home'): Promise<void> {
    const resolved = router.resolve(target)
    await resetTo(target, (resolved.meta.pageKind ?? 'tab') as PageKind)
  }

  async function resetToLogin(): Promise<void> {
    await resetTo('/login', 'auth')
  }

  return {
    acquireGestureLock,
    backPage,
    cacheKeyForRoute,
    canSwipeBack,
    completeAnimation,
    currentRoute,
    finishAuth,
    liveCacheEpoch: readonly(liveCacheEpoch),
    motion: readonly(motion),
    nativeGestureEnabled: readonly(nativeGestureEnabled),
    phase: readonly(phase),
    previousRoute,
    pushPage,
    replacePage,
    resetToLogin,
    switchTab,
  }
}

export function useAppNavigation(): NavigationCoordinator {
  const navigation = inject(navigationKey)
  if (!navigation) throw new Error('NavigationCoordinator is not installed.')
  return navigation
}

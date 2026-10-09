export type AppLifecyclePhase = 'active' | 'background' | 'inactive'

export interface AppActivitySnapshot {
  backgroundedAt: number | null
  foregroundEpoch: number
  networkEpoch: number
  online: boolean
  phase: AppLifecyclePhase
  visible: boolean
}

export type AppActivityListener = (
  snapshot: AppActivitySnapshot,
  previous: AppActivitySnapshot,
) => void

function initialSnapshot(): AppActivitySnapshot {
  const phase: AppLifecyclePhase = document.hidden ? 'background' : 'active'
  return {
    backgroundedAt: phase === 'background' ? Date.now() : null,
    foregroundEpoch: 0,
    networkEpoch: 0,
    online: navigator.onLine,
    phase,
    visible: phase !== 'background',
  }
}

/** Uses Web platform lifecycle only; this standalone bundle has no native lifecycle bridge. */
class AppActivity {
  private installed = false
  private readonly listeners = new Set<AppActivityListener>()
  private snapshot = initialSnapshot()

  readonly install = (): (() => void) => {
    if (!this.installed) {
      this.installed = true
      document.addEventListener('visibilitychange', this.handleDocumentVisibility)
      window.addEventListener('pagehide', this.handlePageHide)
      window.addEventListener('pageshow', this.handlePageShow)
      window.addEventListener('online', this.handleNetworkChange)
      window.addEventListener('offline', this.handleNetworkChange)
      this.applyDocumentLifecycle()
    }
    return () => this.uninstall()
  }

  subscribe(listener: AppActivityListener, immediate = false): () => void {
    this.listeners.add(listener)
    if (immediate) listener(this.snapshot, this.snapshot)
    return () => this.listeners.delete(listener)
  }

  get value(): AppActivitySnapshot {
    return this.snapshot
  }

  private readonly handleNetworkChange = (): void => {
    const online = navigator.onLine
    if (online === this.snapshot.online) return
    this.commit({
      ...this.snapshot,
      networkEpoch: this.snapshot.networkEpoch + 1,
      online,
    })
  }

  private readonly handleDocumentVisibility = (): void => this.applyDocumentLifecycle()
  private readonly handlePageHide = (): void => this.applyPhase('background')
  private readonly handlePageShow = (): void => this.applyPhase('active')

  private applyDocumentLifecycle(): void {
    this.applyPhase(document.hidden ? 'background' : 'active')
  }

  private applyPhase(phase: Extract<AppLifecyclePhase, 'active' | 'background'>): void {
    const previous = this.snapshot
    if (phase === previous.phase) {
      this.applyDocumentState()
      return
    }
    const returnedFromBackground = phase === 'active' && previous.phase === 'background'
    this.commit({
      ...previous,
      backgroundedAt: phase === 'background' ? Date.now() : null,
      foregroundEpoch: previous.foregroundEpoch + (returnedFromBackground ? 1 : 0),
      phase,
      visible: phase !== 'background',
    })
  }

  private commit(next: AppActivitySnapshot): void {
    const previous = this.snapshot
    if (
      previous.backgroundedAt === next.backgroundedAt &&
      previous.foregroundEpoch === next.foregroundEpoch &&
      previous.networkEpoch === next.networkEpoch &&
      previous.online === next.online &&
      previous.phase === next.phase &&
      previous.visible === next.visible
    )
      return
    this.snapshot = next
    this.applyDocumentState()
    this.listeners.forEach((listener) => listener(next, previous))
  }

  private applyDocumentState(): void {
    document.documentElement.toggleAttribute('data-app-hidden', !this.snapshot.visible)
  }

  private uninstall(): void {
    if (!this.installed) return
    this.installed = false
    document.removeEventListener('visibilitychange', this.handleDocumentVisibility)
    window.removeEventListener('pagehide', this.handlePageHide)
    window.removeEventListener('pageshow', this.handlePageShow)
    window.removeEventListener('online', this.handleNetworkChange)
    window.removeEventListener('offline', this.handleNetworkChange)
    this.listeners.clear()
  }
}

export const appActivity = new AppActivity()

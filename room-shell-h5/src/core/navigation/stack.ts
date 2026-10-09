import { createId } from '@/shared/id'
import type { NavigationEntry, PageKind } from './types'

export interface NavigationStackSnapshot {
  activeTab: string | null
  entries: NavigationEntry[]
}

function createEntry(
  fullPath: string,
  pageKind: PageKind,
  cacheKey = createId('page'),
): NavigationEntry {
  return {
    cacheKey,
    fullPath,
    pageKind,
  }
}

export class NavigationStack {
  private activeTab: string | null = null
  private entries: NavigationEntry[] = []

  initialize(fullPath: string, pageKind: PageKind, cacheKey?: string): NavigationEntry {
    if (this.entries.length) return this.current()!
    const entry = createEntry(fullPath, pageKind, cacheKey)
    this.entries = [entry]
    if (pageKind === 'tab') this.activeTab = fullPath
    return entry
  }

  current(): NavigationEntry | null {
    return this.entries.at(-1) ?? null
  }

  previous(): NavigationEntry | null {
    return this.entries.at(-2) ?? null
  }

  canGoBack(): boolean {
    return this.entries.length > 1
  }

  push(fullPath: string, pageKind: PageKind, cacheKey?: string): NavigationEntry {
    const entry = createEntry(fullPath, pageKind, cacheKey)
    this.entries.push(entry)
    return entry
  }

  replace(fullPath: string, pageKind: PageKind, cacheKey?: string): NavigationEntry {
    const entry = createEntry(fullPath, pageKind, cacheKey)
    if (this.entries.length) this.entries.splice(-1, 1, entry)
    else this.entries.push(entry)
    if (pageKind === 'tab') this.activeTab = fullPath
    return entry
  }

  back(): NavigationEntry | null {
    if (!this.canGoBack()) return null
    this.entries.pop()
    return this.current()
  }

  switchTab(tabPath: string): NavigationEntry {
    this.activeTab = tabPath
    const entry = createEntry(tabPath, 'tab')
    this.entries = [entry]
    return entry
  }

  reset(fullPath: string, pageKind: PageKind, cacheKey?: string): NavigationEntry {
    const entry = createEntry(fullPath, pageKind, cacheKey)
    this.entries = [entry]
    this.activeTab = pageKind === 'tab' ? fullPath : null
    return entry
  }

  snapshot(): NavigationStackSnapshot {
    return {
      activeTab: this.activeTab,
      entries: [...this.entries],
    }
  }

  restore(snapshot: NavigationStackSnapshot): void {
    this.activeTab = snapshot.activeTab
    this.entries = [...snapshot.entries]
  }
}

import { getCurrentScope, onScopeDispose, watch, type WatchSource } from 'vue'
import { hideGlobalLoading, showGlobalLoading } from '@/main/ui/global-loading-state'

export function useGlobalLoadingSource(source: WatchSource<boolean>): void {
  let active = false

  const stop = watch(
    source,
    (loading) => {
      if (loading === active) return
      active = loading
      if (loading) showGlobalLoading()
      else hideGlobalLoading()
    },
    { immediate: true },
  )

  if (getCurrentScope()) {
    onScopeDispose(() => {
      stop()
      if (active) hideGlobalLoading()
    })
  }
}

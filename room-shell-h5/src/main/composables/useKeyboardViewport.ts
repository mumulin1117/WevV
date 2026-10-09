import { onBeforeUnmount, readonly, ref } from 'vue'

const MIN_USABLE_VIEWPORT_HEIGHT = 240

function usableHeight(value: number | undefined): number {
  const candidate = Math.round(value ?? window.innerHeight)
  return candidate >= MIN_USABLE_VIEWPORT_HEIGHT
    ? candidate
    : Math.max(MIN_USABLE_VIEWPORT_HEIGHT, Math.round(window.innerHeight))
}

export function useKeyboardViewport() {
  const focused = ref(false)
  const height = ref(usableHeight(window.visualViewport?.height))
  const offsetTop = ref(0)
  let frame = 0
  let listenersAttached = false
  const timers = new Set<number>()

  function viewport(): VisualViewport | null {
    return window.visualViewport ?? null
  }

  function read(): void {
    frame = 0
    const current = viewport()
    const nextHeight = Math.round(current?.height ?? window.innerHeight)
    // iOS WKWebView 在页面恢复和键盘动画中会瞬时返回 0。忽略无效帧，避免整页被压成 0 后卡死。
    if (nextHeight >= MIN_USABLE_VIEWPORT_HEIGHT) height.value = nextHeight
    const nextOffset = Math.round(current?.offsetTop ?? 0)
    offsetTop.value = focused.value && nextOffset >= 0 ? nextOffset : 0
  }

  function scheduleRead(): void {
    if (frame) return
    frame = window.requestAnimationFrame(read)
  }

  function clearTimers(): void {
    timers.forEach((timer) => window.clearTimeout(timer))
    timers.clear()
  }

  function removeListeners(): void {
    if (!listenersAttached) return
    viewport()?.removeEventListener('resize', scheduleRead)
    viewport()?.removeEventListener('scroll', scheduleRead)
    listenersAttached = false
  }

  function focus(): void {
    focused.value = true
    if (!listenersAttached && viewport()) {
      viewport()?.addEventListener('resize', scheduleRead)
      viewport()?.addEventListener('scroll', scheduleRead)
      listenersAttached = true
    }
    scheduleRead()
    clearTimers()
    for (const delay of [80, 180, 320]) {
      const timer = window.setTimeout(() => {
        timers.delete(timer)
        scheduleRead()
      }, delay)
      timers.add(timer)
    }
  }

  function blur(): void {
    focused.value = false
    offsetTop.value = 0
    clearTimers()
    removeListeners()
  }

  onBeforeUnmount(() => {
    window.cancelAnimationFrame(frame)
    clearTimers()
    removeListeners()
  })

  return {
    blur,
    focus,
    focused: readonly(focused),
    height: readonly(height),
    offsetTop: readonly(offsetTop),
  }
}

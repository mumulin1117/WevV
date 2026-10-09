import { computed, onBeforeUnmount, ref } from 'vue'

const MIN_SWIPE_DISTANCE = 58
const HORIZONTAL_LOCK_DISTANCE = 10
const HORIZONTAL_DOMINANCE_RATIO = 1.15
const FLING_VELOCITY = 0.42
const MAX_DRAG_DISTANCE = 120
const SETTLE_DURATION_MS = 180

type GestureState = 'dragging' | 'idle' | 'pending' | 'settling'

interface LiveClearScreenGestureOptions {
  canStart: () => boolean
  isRtl: () => boolean
}

export function resolveLiveClearDirection(deltaX: number, rtl: boolean): number {
  return rtl ? deltaX : -deltaX
}

export function resolveLiveClearProgress(
  startProgress: number,
  deltaX: number,
  rtl: boolean,
): number {
  return Math.max(
    0,
    Math.min(1, startProgress + resolveLiveClearDirection(deltaX, rtl) / MAX_DRAG_DISTANCE),
  )
}

export function resolveLiveClearTarget(options: {
  deltaX: number
  elapsed: number
  rtl: boolean
  startProgress: number
}): 0 | 1 {
  const distance = resolveLiveClearDirection(options.deltaX, options.rtl)
  const velocity = distance / Math.max(1, options.elapsed)
  if (options.startProgress < 0.5)
    return distance >= MIN_SWIPE_DISTANCE || velocity >= FLING_VELOCITY ? 1 : 0
  return distance <= -MIN_SWIPE_DISTANCE || velocity <= -FLING_VELOCITY ? 0 : 1
}

function shouldIgnoreSwipe(target: EventTarget | null): boolean {
  if (!(target instanceof Element)) return false
  return Boolean(
    target.closest(
      'button, a, input, textarea, select, [role="button"], [data-room-scroll], [data-popup-scroll]',
    ),
  )
}

export function useLiveClearScreenGesture(options: LiveClearScreenGestureOptions) {
  const progress = ref(0)
  const screenCleared = ref(false)
  let gestureState: GestureState = 'idle'
  let pointerId: number | null = null
  let startX = 0
  let startY = 0
  let startTime = 0
  let startProgress = 0
  let settleFrame = 0
  let captureTarget: Element | null = null

  const cleanProgress = computed(() => progress.value)

  function cancelSettleAnimation(): void {
    if (!settleFrame) return
    window.cancelAnimationFrame(settleFrame)
    settleFrame = 0
  }

  function releasePointer(event?: PointerEvent): void {
    const eventTarget = event?.currentTarget
    const target = eventTarget instanceof Element ? eventTarget : captureTarget
    if (pointerId !== null && target?.hasPointerCapture(pointerId)) {
      try {
        target.releasePointerCapture(pointerId)
      } catch {
        // Pointer 取消可能先于组件回调释放捕获。
      }
    }
    captureTarget = null
    pointerId = null
    startX = 0
    startY = 0
    startTime = 0
    startProgress = progress.value
  }

  function settle(value: number): void {
    progress.value = Math.max(0, Math.min(1, value))
    screenCleared.value = progress.value >= 1
    gestureState = 'idle'
  }

  function animateTo(target: 0 | 1): void {
    cancelSettleAnimation()
    const from = progress.value
    if (from === target) {
      settle(target)
      return
    }
    gestureState = 'settling'
    const startedAt = performance.now()
    const tick = (now: number): void => {
      const time = Math.max(0, Math.min(1, (now - startedAt) / SETTLE_DURATION_MS))
      const eased = 1 - (1 - time) ** 3
      progress.value = from + (target - from) * eased
      if (time < 1) {
        settleFrame = window.requestAnimationFrame(tick)
        return
      }
      settleFrame = 0
      settle(target)
    }
    settleFrame = window.requestAnimationFrame(tick)
  }

  function setScreenCleared(value: boolean, animated = true): void {
    releasePointer()
    if (animated) animateTo(value ? 1 : 0)
    else {
      cancelSettleAnimation()
      settle(value ? 1 : 0)
    }
  }

  function beginClearScreenGesture(event: PointerEvent): void {
    if (!options.canStart() || shouldIgnoreSwipe(event.target)) return
    if (event.pointerType === 'mouse' && event.button !== 0) return
    cancelSettleAnimation()
    pointerId = event.pointerId
    startX = event.clientX
    startY = event.clientY
    startTime = performance.now()
    startProgress = screenCleared.value ? 1 : 0
    progress.value = startProgress
    gestureState = 'pending'
    const target = event.currentTarget
    if (target instanceof Element) {
      try {
        target.setPointerCapture(event.pointerId)
        captureTarget = target
      } catch {
        captureTarget = null
      }
    }
  }

  function moveClearScreenGesture(event: PointerEvent): void {
    if (pointerId !== event.pointerId || !['pending', 'dragging'].includes(gestureState)) return
    const deltaX = event.clientX - startX
    const deltaY = event.clientY - startY
    const absX = Math.abs(deltaX)
    const absY = Math.abs(deltaY)
    if (gestureState === 'pending') {
      if (absX < HORIZONTAL_LOCK_DISTANCE && absY < HORIZONTAL_LOCK_DISTANCE) return
      const distance = resolveLiveClearDirection(deltaX, options.isRtl())
      const allowedDirection = startProgress < 0.5 ? distance > 0 : distance < 0
      if (
        absX < HORIZONTAL_LOCK_DISTANCE ||
        absX <= absY * HORIZONTAL_DOMINANCE_RATIO ||
        !allowedDirection
      ) {
        gestureState = 'idle'
        progress.value = startProgress
        releasePointer(event)
        return
      }
      gestureState = 'dragging'
    }
    if (event.cancelable) event.preventDefault()
    progress.value = resolveLiveClearProgress(startProgress, deltaX, options.isRtl())
  }

  function finishClearScreenGesture(event: PointerEvent): void {
    if (pointerId !== event.pointerId || !['pending', 'dragging'].includes(gestureState)) return
    const wasDragging = gestureState === 'dragging'
    const deltaX = event.clientX - startX
    const elapsed = performance.now() - startTime
    const target = wasDragging
      ? resolveLiveClearTarget({ deltaX, elapsed, rtl: options.isRtl(), startProgress })
      : startProgress < 0.5
        ? 0
        : 1
    releasePointer(event)
    animateTo(target)
  }

  function cancelClearScreenGesture(event?: PointerEvent): void {
    if (event && pointerId !== event.pointerId) return
    const target = startProgress < 0.5 ? 0 : 1
    releasePointer(event)
    animateTo(target)
  }

  function resetClearScreenGesture(): void {
    releasePointer()
    cancelSettleAnimation()
    settle(0)
  }

  onBeforeUnmount(resetClearScreenGesture)

  return {
    beginClearScreenGesture,
    cancelClearScreenGesture,
    cleanProgress,
    finishClearScreenGesture,
    moveClearScreenGesture,
    resetClearScreenGesture,
    screenCleared,
    setScreenCleared,
  }
}

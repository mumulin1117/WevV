export type MediaPreviewDragDirection = 'horizontal' | 'vertical'

const DIRECTION_DISTANCE = 8
const HORIZONTAL_DIRECTION_ANGLE = 55
const MIN_CLOSE_DISTANCE = 72
const CLOSE_DISTANCE_RATIO = 0.1
const MAX_SCALE_REDUCTION = 0.12
const DRAG_OPACITY_DISTANCE = 280

export interface MediaPreviewDragPresentation {
  backdropOpacity: number
  offsetX: number
  offsetY: number
  scale: number
}

export function resolveMediaPreviewDragDirection(
  deltaX: number,
  deltaY: number,
): MediaPreviewDragDirection | null {
  if (Math.abs(deltaX) < DIRECTION_DISTANCE && Math.abs(deltaY) < DIRECTION_DISTANCE) return null

  const angle = (Math.atan2(Math.abs(deltaY), Math.abs(deltaX)) * 180) / Math.PI
  return angle < HORIZONTAL_DIRECTION_ANGLE ? 'horizontal' : 'vertical'
}

export function mediaPreviewDragPresentation(
  deltaX: number,
  deltaY: number,
): MediaPreviewDragPresentation {
  const offsetY = deltaY < 0 ? deltaY * 0.35 : deltaY * 0.9
  const offsetX = deltaX * 0.12
  const dragDistance = Math.abs(offsetY)
  const opacityRatio = Math.min(1, dragDistance / DRAG_OPACITY_DISTANCE)
  const scale = Math.max(
    1 - MAX_SCALE_REDUCTION,
    1 - Math.min(MAX_SCALE_REDUCTION, dragDistance / 900),
  )

  return {
    backdropOpacity: Math.max(0.2, 1 - opacityRatio * 0.7),
    offsetX,
    offsetY,
    scale,
  }
}

export function mediaPreviewCloseThreshold(viewportHeight: number): number {
  return Math.max(MIN_CLOSE_DISTANCE, Math.max(0, viewportHeight) * CLOSE_DISTANCE_RATIO)
}

export function shouldDismissMediaPreview(offsetY: number, viewportHeight: number): boolean {
  return Math.abs(offsetY) >= mediaPreviewCloseThreshold(viewportHeight)
}

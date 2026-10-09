import { reactive } from 'vue'

export interface AppMediaPreviewItem {
  poster?: string
  type: 'image' | 'video'
  url: string
}

interface MediaPreviewState {
  items: AppMediaPreviewItem[]
  key: number
  startIndex: number
  visible: boolean
}

export const mediaPreviewState = reactive<MediaPreviewState>({
  items: [],
  key: 0,
  startIndex: 0,
  visible: false,
})

let settlePreview: (() => void) | undefined

export function openMediaPreview(
  items: readonly (AppMediaPreviewItem | string)[],
  startIndex = 0,
): Promise<void> {
  const normalized = items
    .map((item): AppMediaPreviewItem =>
      typeof item === 'string' ? { type: 'image', url: item } : item,
    )
    .filter((item) => Boolean(item.url))
  if (!normalized.length) return Promise.resolve()
  settlePreview?.()
  mediaPreviewState.items = normalized
  mediaPreviewState.key += 1
  mediaPreviewState.startIndex = Math.min(Math.max(startIndex, 0), normalized.length - 1)
  mediaPreviewState.visible = true
  return new Promise((resolve) => {
    settlePreview = resolve
  })
}

export function closeMediaPreview(): void {
  if (!mediaPreviewState.visible && !settlePreview) return
  mediaPreviewState.visible = false
  settlePreview?.()
  settlePreview = undefined
}

export function clearMediaPreview(): void {
  if (mediaPreviewState.visible) return
  mediaPreviewState.items = []
  mediaPreviewState.startIndex = 0
}

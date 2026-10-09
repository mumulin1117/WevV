import { reactive } from 'vue'

export interface AppActionSheetAction<T extends string = string> {
  disabled?: boolean
  label: string
  tone?: 'danger' | 'default' | 'primary'
  value: T
}

export interface AppActionSheetOptions<T extends string = string> {
  actions: AppActionSheetAction<T>[]
  cancelLabel?: string
  description?: string
  title?: string
}

interface ActionSheetState {
  actions: AppActionSheetAction[]
  cancelLabel: string
  description: string
  title: string
  visible: boolean
}

export const actionSheetState = reactive<ActionSheetState>({
  actions: [],
  cancelLabel: '',
  description: '',
  title: '',
  visible: false,
})

let settleActionSheet: ((value: string | null) => void) | undefined
let settleActionSheetClosed: (() => void) | undefined
let actionSheetClosed: Promise<void> | undefined
let pendingActionSheetValue: string | null = null

function waitForActionSheetClosed(): Promise<void> {
  actionSheetClosed ??= new Promise((resolve) => {
    settleActionSheetClosed = resolve
  })
  return actionSheetClosed
}

export async function openActionSheet<T extends string>(
  options: AppActionSheetOptions<T>,
): Promise<T | null> {
  if (actionSheetState.visible || actionSheetClosed) {
    closeActionSheet()
    await waitForActionSheetClosed()
  }
  actionSheetState.actions = [...options.actions]
  actionSheetState.cancelLabel = options.cancelLabel ?? ''
  actionSheetState.description = options.description ?? ''
  actionSheetState.title = options.title ?? ''
  actionSheetState.visible = true
  return await new Promise((resolve) => {
    settleActionSheet = (value) => resolve(value as T | null)
  })
}

export function closeActionSheet(value: string | null = null): void {
  if (!actionSheetState.visible) return
  void waitForActionSheetClosed()
  pendingActionSheetValue = value
  actionSheetState.visible = false
}

export function notifyActionSheetClosed(): void {
  settleActionSheet?.(pendingActionSheetValue)
  settleActionSheet = undefined
  pendingActionSheetValue = null
  settleActionSheetClosed?.()
  settleActionSheetClosed = undefined
  actionSheetClosed = undefined
}

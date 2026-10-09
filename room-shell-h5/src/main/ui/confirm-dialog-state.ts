import { reactive } from 'vue'

export interface AppConfirmDialogOptions {
  cancelButtonText: string
  checkboxLabel?: string
  confirmButtonText: string
  message: string
  title: string
}

export interface AppConfirmDialogResult {
  checked: boolean
  confirmed: boolean
}

export const confirmDialogState = reactive<
  AppConfirmDialogOptions & { checked: boolean; visible: boolean }
>({
  cancelButtonText: '',
  checked: false,
  checkboxLabel: '',
  confirmButtonText: '',
  message: '',
  title: '',
  visible: false,
})

let settleConfirm: ((value: AppConfirmDialogResult) => void) | undefined

export function openConfirmDialog(
  options: AppConfirmDialogOptions,
): Promise<AppConfirmDialogResult> {
  if (settleConfirm) settleConfirm({ checked: false, confirmed: false })
  confirmDialogState.cancelButtonText = options.cancelButtonText
  confirmDialogState.checked = false
  confirmDialogState.checkboxLabel = options.checkboxLabel ?? ''
  confirmDialogState.confirmButtonText = options.confirmButtonText
  confirmDialogState.message = options.message
  confirmDialogState.title = options.title
  confirmDialogState.visible = true
  return new Promise((resolve) => {
    settleConfirm = resolve
  })
}

export function closeConfirmDialog(confirmed = false): void {
  if (!confirmDialogState.visible && !settleConfirm) return
  confirmDialogState.visible = false
  settleConfirm?.({ checked: confirmDialogState.checked, confirmed })
  settleConfirm = undefined
}

import type { DialogOptions } from 'vant'
import { inject } from 'vue'
import { showDialog } from 'vant'
import 'vant/es/dialog/index.css'
import { i18n } from '@/core/i18n'
import { navigationKey } from '@/core/navigation/coordinator'
import { openActionSheet } from './overlay-state'
import type { AppActionSheetOptions } from './overlay-state'
import { openConfirmDialog } from './confirm-dialog-state'
import { openMediaPreview } from './media-preview-state'
import type { AppMediaPreviewItem } from './media-preview-state'

export interface AppDialogOptions {
  cancelButtonText?: string
  confirmButtonText?: string
  message: string
  title?: string
}

export interface AppDialogWithOptionOptions extends AppDialogOptions {
  checkboxLabel: string
}

export interface AppImagePreviewOptions {
  images: string[]
  startIndex?: number
}

export interface AppMediaPreviewOptions {
  items: readonly AppMediaPreviewItem[]
  startIndex?: number
}

export interface AppUserSafetySheetOptions {
  blockDisabled?: boolean
}

export function useAppOverlay() {
  const navigation = inject(navigationKey, null)
  const t = i18n.global.t

  async function withGestureLock<T>(source: string, operation: () => Promise<T>): Promise<T> {
    const release = navigation?.acquireGestureLock(source) ?? (() => undefined)
    try {
      return await operation()
    } finally {
      release()
    }
  }

  async function alert(options: Omit<AppDialogOptions, 'cancelButtonText'>): Promise<void> {
    await withGestureLock('app-alert-dialog', async () => {
      await showDialog({
        confirmButtonText: options.confirmButtonText ?? t('common.close'),
        message: options.message,
        title: options.title,
      } as DialogOptions)
    })
  }

  async function confirm(options: AppDialogOptions): Promise<boolean> {
    return await withGestureLock('app-confirm-dialog', async () => {
      return (
        await openConfirmDialog({
          cancelButtonText: options.cancelButtonText ?? t('common.cancel'),
          confirmButtonText: options.confirmButtonText ?? t('common.confirm'),
          message: options.message,
          title: options.title ?? '',
        })
      ).confirmed
    })
  }

  async function confirmWithOption(
    options: AppDialogWithOptionOptions,
  ): Promise<{ checked: boolean; confirmed: boolean }> {
    return await withGestureLock('app-confirm-dialog', async () => {
      return await openConfirmDialog({
        cancelButtonText: options.cancelButtonText ?? t('common.cancel'),
        checkboxLabel: options.checkboxLabel,
        confirmButtonText: options.confirmButtonText ?? t('common.confirm'),
        message: options.message,
        title: options.title ?? '',
      })
    })
  }

  async function actionSheet<T extends string>(
    options: AppActionSheetOptions<T>,
  ): Promise<T | null> {
    return await openActionSheet(options)
  }

  async function userSafetyActionSheet(
    options: AppUserSafetySheetOptions = {},
  ): Promise<'block' | 'feedback' | null> {
    return await actionSheet({
      actions: [
        { label: t('safety.report'), tone: 'primary', value: 'feedback' },
        {
          disabled: options.blockDisabled,
          label: t('safety.block'),
          tone: 'danger',
          value: 'block',
        },
      ],
      cancelLabel: t('common.cancel'),
    })
  }

  async function previewImages(options: AppImagePreviewOptions): Promise<void> {
    const images = options.images.filter(Boolean)
    if (!images.length) return
    await openMediaPreview(images, options.startIndex)
  }

  async function previewMedia(options: AppMediaPreviewOptions): Promise<void> {
    const items = options.items.filter((item) => Boolean(item.url))
    if (!items.length) return
    await openMediaPreview(items, options.startIndex)
  }

  return {
    actionSheet,
    alert,
    confirm,
    confirmWithOption,
    previewImages,
    previewMedia,
    userSafetyActionSheet,
  }
}

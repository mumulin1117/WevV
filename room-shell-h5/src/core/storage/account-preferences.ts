import { productStorageNamespace } from '@/core/product-mode/runtime'
import { readLocalStorage, removeLocalStorage, writeLocalStorage } from './local-storage'

function key(accountId: string, name: string, contentVersion = 'preferences-v1'): string {
  return `social:${productStorageNamespace(accountId, contentVersion)}:${name}`
}

export function accountStorageId(
  accountId: string,
  name: string,
  contentVersion = 'account-records-v1',
): string {
  return `${productStorageNamespace(accountId, contentVersion)}:${name}`
}

export const accountPreferences = {
  get(accountId: string, name: string, contentVersion?: string): string | null {
    if (!accountId.trim()) return null
    return readLocalStorage(key(accountId, name, contentVersion))
  },
  remove(accountId: string, name: string, contentVersion?: string): void {
    if (accountId.trim()) removeLocalStorage(key(accountId, name, contentVersion))
  },
  set(accountId: string, name: string, value: string, contentVersion?: string): boolean {
    if (!accountId.trim()) return false
    return writeLocalStorage(key(accountId, name, contentVersion), value)
  },
}

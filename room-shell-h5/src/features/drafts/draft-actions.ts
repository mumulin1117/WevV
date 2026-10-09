import { accountStorageId } from '@/core/storage/account-preferences'
import { getAppDatabase } from '@/core/storage/app-database'

function id(accountId: string, name: string): string {
  return accountStorageId(accountId, name, 'drafts-v1')
}

export async function readAccountDraft(accountId: string, name: string): Promise<string> {
  return (await getAppDatabase().drafts.get(id(accountId, name)))?.payload ?? ''
}

export async function writeAccountDraft(
  accountId: string,
  name: string,
  payload: string,
): Promise<void> {
  const draftId = id(accountId, name)
  if (!payload) {
    await getAppDatabase().drafts.delete(draftId)
    return
  }
  await getAppDatabase().drafts.put({
    accountId,
    id: draftId,
    payload,
    updatedAt: Date.now(),
  })
}

export async function deleteAccountDraft(accountId: string, name: string): Promise<void> {
  await getAppDatabase().drafts.delete(id(accountId, name))
}

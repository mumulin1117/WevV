import { RuntimeScope } from '@/core/runtime/runtime-scope'
import { useMessagesStore } from '@/main/stores/messages'
import { useSessionStore } from '@/main/stores/session'

let scope: RuntimeScope | undefined
let generation = 0

export interface MessagingReadyOptions {
  allowSnapshot?: boolean
  reason: string
  timeoutMs?: number
}

export async function ensureMessagingReady(options: MessagingReadyOptions): Promise<void> {
  void options.allowSnapshot
  void options.reason
  const session = useSessionStore()
  const ownerId = session.user?.id ?? ''
  if (!session.authenticated || !ownerId) throw new Error('ROOM_MESSAGE_SESSION_MISSING')
  if (!scope?.owns(ownerId)) {
    await disposeRoomMessageRuntime()
    scope = new RuntimeScope(ownerId, ++generation)
    scope.add(() => useMessagesStore().stop())
  }
  const task = useMessagesStore().start(scope)
  const timeoutMs = options.timeoutMs ?? 8_000
  await new Promise<void>((resolve, reject) => {
    const timer = window.setTimeout(
      () => reject(new Error('ROOM_MESSAGE_START_TIMEOUT')),
      timeoutMs,
    )
    task.then(resolve, reject).finally(() => window.clearTimeout(timer))
  })
}

export async function disposeRoomMessageRuntime(): Promise<void> {
  const current = scope
  scope = undefined
  await current?.dispose()
}

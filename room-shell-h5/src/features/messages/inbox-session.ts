import type { RealtimeCredential } from '@/core/realtime/contracts'
import { getProductMode } from '@/core/product-mode/runtime'
import type { RuntimeScope } from '@/core/runtime/runtime-scope'
import { HttpMessageGateway } from './http-message-gateway'
import { getOpiMessageRepository } from './opi-message-repository'
import { observePresence, type PresenceUpdate } from './presence-runtime'
import type { MessageGateway, MessageGatewayEvent, MessageRepository } from './contracts'

export interface InboxSessionInput {
  credential: () => Promise<RealtimeCredential | null>
  getBalance: () => number
  onEvent: (event: MessageGatewayEvent) => void
  onPresence: (update: PresenceUpdate) => void
  ownerId: string
  setBalance: (value: number) => Promise<void>
  visible: boolean
}

export interface ConnectedInboxSession {
  gateway: MessageGateway
  repository: MessageRepository
}

/** Remote OPI 数据链与 NIM 通信链独立。 */
export function getRemoteMessageRepositoryOrNull(): MessageRepository | null {
  return getProductMode().mode === 'remote' ? getOpiMessageRepository() : null
}

/**
 * 账号收件箱的通信会话。它只管理 Gateway/Repository/SDK 观察者，不保存 Vue 展示状态；
 * owner 与迟到任务真值来自 ApplicationRuntime 传入的 RuntimeScope。
 */
export class InboxSession {
  private gateway: MessageGateway | null = null
  private repository: MessageRepository | null = null
  private stopGateway: (() => void) | undefined
  private stopPresence: (() => void) | undefined

  async connect(scope: RuntimeScope, input: InboxSessionInput): Promise<ConnectedInboxSession> {
    if (!scope.owns(input.ownerId)) throw new Error('INBOX_SESSION_SCOPE_EXPIRED')
    await this.stop()
    const gateway = new HttpMessageGateway()
    const repository = getOpiMessageRepository()
    await gateway.connect()
    if (!scope.owns(input.ownerId)) {
      await gateway.disconnect().catch(() => undefined)
      throw new Error('INBOX_SESSION_SCOPE_EXPIRED')
    }
    this.gateway = gateway
    this.repository = repository
    gateway.setVisible(input.visible)
    this.stopGateway = gateway.observe(input.onEvent)
    this.stopPresence = observePresence(input.onPresence)
    return { gateway, repository }
  }

  async resume(visible: boolean): Promise<boolean> {
    if (!this.gateway) return false
    const previous = this.gateway.connectionState()
    this.gateway.setVisible(visible)
    await this.gateway.connect()
    return previous !== 'connected'
  }

  setVisible(visible: boolean): void {
    this.gateway?.setVisible(visible)
  }

  async stop(): Promise<void> {
    this.stopGateway?.()
    this.stopGateway = undefined
    this.stopPresence?.()
    this.stopPresence = undefined
    const gateway = this.gateway
    this.gateway = null
    this.repository = null
    await gateway?.disconnect().catch(() => undefined)
  }
}

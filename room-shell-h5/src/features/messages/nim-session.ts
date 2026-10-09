import type { RealtimeCredential } from '@/core/realtime/contracts'
import { getServerRuntimeConfig } from '@/core/config/server-runtime-config'
import type { ChatroomRuntime, ChatroomSdkClient } from '@/features/rooms/chatroom-contracts'

interface NimLoginService {
  getChatroomLinkAddress: (roomId: string, miniProgram?: boolean) => Promise<string[]>
  getLoginStatus: () => number
  login: (account: string, token: string, options: { forceMode: boolean }) => Promise<void>
  logout: () => Promise<void>
  setAppVisibility: (visible: boolean) => void
}

export interface YunxinNimClient {
  V2NIMConversationIdUtil: {
    parseConversationTargetId: (conversationId: string) => string
    p2pConversationId: (accountId: string) => string
  }
  V2NIMConversationService: Record<string, unknown>
  V2NIMLoginService: NimLoginService
  V2NIMMessageCreator: Record<string, unknown>
  V2NIMMessageService: Record<string, unknown>
  V2NIMUserService: Record<string, unknown>
}

interface NimConstructor {
  getInstance: (
    options: {
      apiVersion: 'v2'
      appkey: string
      debugLevel: 'off'
      enableV2CloudConversation: true
    },
    otherOptions: { V2NIMClientAntispamUtilConfig: { enable: boolean } },
  ) => YunxinNimClient
}

interface ChatroomConstructor {
  newInstance: (options: { appkey: string; debugLevel: 'off' }) => ChatroomSdkClient
}

declare global {
  interface Window {
    Chatroom?: { default?: ChatroomConstructor }
    NIM?: { default?: NimConstructor }
  }
}

function withLoginTimeout(task: Promise<void>, timeout = 12_000): Promise<void> {
  return new Promise<void>((resolve, reject) => {
    const timer = window.setTimeout(() => reject(new Error('YUNXIN_LOGIN_TIMEOUT')), timeout)
    task.then(resolve, reject).finally(() => window.clearTimeout(timer))
  })
}

function wait(timeout: number): Promise<void> {
  return new Promise((resolve) => window.setTimeout(resolve, timeout))
}

export class NimSession implements ChatroomRuntime {
  private account = ''
  private loginGeneration = 0
  private loginAccount = ''
  private loginPromise: Promise<void> | null = null
  private nim: YunxinNimClient | null = null

  createClient(): ChatroomSdkClient {
    const constructor = window.Chatroom?.default
    if (!constructor) throw new Error('YUNXIN_CHATROOM_RUNTIME_MISSING')
    return constructor.newInstance({
      appkey: getServerRuntimeConfig().imAppKey,
      debugLevel: 'off',
    })
  }

  async getLinkAddresses(roomId: string): Promise<string[]> {
    if (!this.nim || this.nim.V2NIMLoginService.getLoginStatus() !== 1)
      throw new Error('YUNXIN_LOGIN_REQUIRED')
    return this.nim.V2NIMLoginService.getChatroomLinkAddress(roomId, false)
  }

  async login(credential: RealtimeCredential): Promise<void> {
    activateInlineRuntime('nim')
    activateInlineRuntime('nim-chatroom')
    const nim = this.getNim()
    if (this.account === credential.imAccount && this.getLoginStatus() === 1) return
    if (this.loginPromise) {
      if (this.loginAccount !== credential.imAccount)
        throw new Error('YUNXIN_LOGIN_ACCOUNT_SWITCH_PENDING')
      return withLoginTimeout(this.loginPromise)
    }

    const generation = ++this.loginGeneration
    this.loginAccount = credential.imAccount
    const task = (async () => {
      if (this.account && this.account !== credential.imAccount)
        await nim.V2NIMLoginService.logout().catch(() => undefined)
      let loginStatus = this.getLoginStatus()
      if (loginStatus === 2) loginStatus = await this.waitForStableLoginStatus()
      if (loginStatus === 1) {
        if (this.account === credential.imAccount) return
        await nim.V2NIMLoginService.logout().catch(() => undefined)
        loginStatus = this.getLoginStatus()
      }
      if (loginStatus === 2) throw new Error('YUNXIN_LOGIN_IN_PROGRESS')
      if (loginStatus !== 0 && loginStatus !== 3)
        throw new Error(`YUNXIN_LOGIN_STATUS_${loginStatus}`)
      await nim.V2NIMLoginService.login(credential.imAccount, credential.imToken, {
        forceMode: true,
      })
      if (generation !== this.loginGeneration) {
        await nim.V2NIMLoginService.logout().catch(() => undefined)
        return
      }
      this.account = credential.imAccount
    })().finally(() => {
      if (this.loginPromise !== task) return
      this.loginAccount = ''
      this.loginPromise = null
    })
    this.loginPromise = task
    return withLoginTimeout(task)
  }

  async logout(): Promise<void> {
    this.loginGeneration += 1
    const pending = this.loginPromise
    this.loginPromise = null
    this.loginAccount = ''
    const nim = this.nim
    this.account = ''
    if (!nim) return
    // SDK 登录若卡住，退出和鉴权失效不能被它永久阻塞；迟到的登录完成后再补一次 logout。
    if (pending) void pending.then(() => nim.V2NIMLoginService.logout()).catch(() => undefined)
    await withLoginTimeout(
      nim.V2NIMLoginService.logout().catch(() => undefined),
      4_000,
    ).catch(() => undefined)
  }

  setAppVisible(visible: boolean): void {
    this.nim?.V2NIMLoginService.setAppVisibility(visible)
  }

  getLoginStatus(): number {
    return this.nim?.V2NIMLoginService.getLoginStatus() ?? 0
  }

  async getLoggedInClient(credential: RealtimeCredential): Promise<YunxinNimClient> {
    await this.login(credential)
    return this.getNim()
  }

  /**
   * 消息模块必须在 login 之前注册会话同步监听。云信明确要求收到
   * onSyncFinished 后再消费完整会话；若等 login resolve 后才监听，快速网络下会漏掉该事件。
   */
  prepareMessageClient(): YunxinNimClient {
    activateInlineRuntime('nim')
    return this.getNim()
  }

  private getNim(): YunxinNimClient {
    if (this.nim) return this.nim
    const constructor = window.NIM?.default
    if (!constructor) throw new Error('YUNXIN_IM_RUNTIME_MISSING')
    this.nim = constructor.getInstance(
      {
        apiVersion: 'v2',
        appkey: getServerRuntimeConfig().imAppKey,
        debugLevel: 'off',
        enableV2CloudConversation: true,
      },
      { V2NIMClientAntispamUtilConfig: { enable: true } },
    )
    return this.nim
  }

  private async waitForStableLoginStatus(timeoutMs = 3_000): Promise<number> {
    const deadline = Date.now() + timeoutMs
    let status = this.getLoginStatus()
    while (status === 2 && Date.now() < deadline) {
      await wait(150)
      status = this.getLoginStatus()
    }
    return status
  }
}

const activatedRuntimes = new Set<string>()

function activateInlineRuntime(name: 'nim' | 'nim-chatroom'): void {
  if (activatedRuntimes.has(name)) return
  const sourceNode = document.querySelector<HTMLScriptElement>(
    `script[type="application/x-social-runtime"][data-runtime="${name}"]`,
  )
  if (!sourceNode?.textContent) throw new Error(`YUNXIN_${name.toUpperCase()}_RUNTIME_MISSING`)

  const executable = document.createElement('script')
  executable.dataset.runtimeActive = name
  executable.textContent = sourceNode.textContent
  document.head.append(executable)
  executable.remove()
  sourceNode.remove()
  activatedRuntimes.add(name)
}

let session: NimSession | undefined

export function getNimChatroomSession(): ChatroomRuntime {
  session ??= new NimSession()
  return session
}

export function getNimSession(): NimSession {
  session ??= new NimSession()
  return session
}

export async function logoutNimSession(): Promise<void> {
  const current = session
  session = undefined
  await current?.logout()
}

export function resetNimSessionForTests(): void {
  session = undefined
  activatedRuntimes.clear()
}

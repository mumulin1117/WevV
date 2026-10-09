export type RuntimeDisposer = () => Promise<void> | void

/**
 * 一次账号或房间运行期的唯一失效令牌。异步任务在写回前检查 scope，监听和计时器
 * 统一登记 disposer；结束时先 abort，再按注册逆序释放，避免旧账号迟到结果回写。
 */
export class RuntimeScope {
  private readonly controller = new AbortController()
  private readonly disposers: RuntimeDisposer[] = []
  private disposed = false

  constructor(
    readonly ownerId: string,
    readonly generation: number,
  ) {}

  get signal(): AbortSignal {
    return this.controller.signal
  }

  get active(): boolean {
    return !this.disposed && !this.signal.aborted
  }

  owns(ownerId: string, generation = this.generation): boolean {
    return this.active && this.ownerId === ownerId && this.generation === generation
  }

  add(disposer: RuntimeDisposer): () => void {
    if (!this.active) {
      void Promise.resolve(disposer()).catch(() => undefined)
      return () => undefined
    }
    this.disposers.push(disposer)
    return () => {
      const index = this.disposers.indexOf(disposer)
      if (index >= 0) this.disposers.splice(index, 1)
    }
  }

  abort(reason = 'runtime-ended'): void {
    if (!this.signal.aborted) this.controller.abort(reason)
  }

  async dispose(): Promise<void> {
    if (this.disposed) return
    this.disposed = true
    this.abort()
    const tasks = this.disposers.splice(0).reverse()
    for (const dispose of tasks) await Promise.resolve(dispose()).catch(() => undefined)
  }
}

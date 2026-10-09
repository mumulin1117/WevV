import type { ZodType } from 'zod'
import type { ApiClient } from './client'

interface SapiRequest<T> {
  data?: unknown
  path: string
  schema?: ZodType<T>
  signal?: AbortSignal
}

/** 语聊保留原始路径和字段，但统一使用直播模块的 OPI 鉴权与 AES-Hex 包络。 */
export class SapiClient {
  constructor(private readonly api: Pick<ApiClient, 'request'>) {}

  cancelAll(_reason?: string): void {}

  async post<T>(request: SapiRequest<T>): Promise<T> {
    return this.api.request({
      authMode: 'required',
      data: request.data ?? {},
      method: 'POST',
      schema: request.schema,
      signal: request.signal,
      url: request.path,
    })
  }
}

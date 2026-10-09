export interface CursorPage<T> {
  hasMore: boolean
  items: T[]
  nextCursor: string | null
}

export interface ApiErrorBody {
  code: string
  details?: unknown
  message: string
}

export class ApiError extends Error {
  constructor(
    readonly status: number,
    readonly body: ApiErrorBody,
  ) {
    super(body.message)
    this.name = 'ApiError'
  }
}

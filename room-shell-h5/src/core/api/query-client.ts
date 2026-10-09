import { QueryClient, type QueryKey } from '@tanstack/vue-query'
import { productStorageNamespace } from '@/core/product-mode/runtime'

let appQueryClient: QueryClient | undefined

export function createAppQueryClient(): QueryClient {
  appQueryClient ??= new QueryClient({
    defaultOptions: {
      queries: {
        gcTime: 5 * 60_000,
        refetchOnWindowFocus: false,
        retry: (failureCount, error) => {
          const kind =
            typeof error === 'object' && error && 'kind' in error ? error.kind : undefined
          // 初次请求之外只自动补偿一次；页面自己的重试按钮负责后续动作，避免弱网时请求雪崩。
          return failureCount < 1 && (kind === 'network' || kind === 'server')
        },
        staleTime: 20_000,
      },
      mutations: { retry: false },
    },
  })
  return appQueryClient
}

export function getAppQueryClient(): QueryClient {
  return createAppQueryClient()
}

/** 非强刷时不传 staleTime，避免显式 undefined 覆盖 QueryClient 的账号级缓存策略。 */
export function fetchAppQuery<T>(input: {
  force?: boolean
  queryFn: () => Promise<T>
  queryKey: QueryKey
  staleTimeMs?: number
}): Promise<T> {
  return getAppQueryClient().fetchQuery({
    queryFn: input.queryFn,
    queryKey: input.queryKey,
    ...(input.force
      ? { staleTime: 0 }
      : input.staleTimeMs !== undefined
        ? { staleTime: input.staleTimeMs }
        : {}),
  })
}

export function resetAppQueryClientForTests(): void {
  appQueryClient?.clear()
  appQueryClient = undefined
}

function accountKey(accountId: string): readonly ['product', string] {
  return ['product', productStorageNamespace(accountId)] as const
}

export const queryKeys = {
  conversations: (accountId: string) => [...accountKey(accountId), 'conversations'] as const,
  discovery: (accountId: string, filter: string) =>
    [...accountKey(accountId), 'discovery', filter] as const,
  feed: (accountId: string, filter: string) => [...accountKey(accountId), 'feed', filter] as const,
  fullGameCatalog: (accountId: string) => [...accountKey(accountId), 'full-game-catalog'] as const,
  homeBanners: (accountId: string) => [...accountKey(accountId), 'home-banners'] as const,
  homeCountries: (accountId: string) => [...accountKey(accountId), 'home-countries'] as const,
  liveGifts: (accountId: string) => [...accountKey(accountId), 'live-gifts'] as const,
  profile: (accountId: string) => [...accountKey(accountId), 'profile'] as const,
  rechargePackages: (accountId: string) => [...accountKey(accountId), 'recharge-packages'] as const,
  rooms: (accountId: string, kind: 'live' | 'voice') =>
    [...accountKey(accountId), 'rooms', kind] as const,
  vipInfo: (accountId: string) => [...accountKey(accountId), 'vip-info'] as const,
}

import { getProductMode, type ProductMode } from './runtime'

interface ProductServiceFactory<T> {
  remote: () => T
}

const services = new Map<string, unknown>()
let initializedMode: ProductMode | undefined

/** config/open 决定模式后只装配一次；同一运行期禁止热切 Local/Remote。 */
export function initializeProductServices(): ProductMode {
  const mode = getProductMode().mode
  if (initializedMode && initializedMode !== mode)
    throw new Error('Product services cannot change mode during the current run.')
  initializedMode ??= mode
  return initializedMode
}

export function resolveProductService<T>(key: string, factory: ProductServiceFactory<T>): T {
  const existing = services.get(key)
  if (existing) return existing as T
  const mode = initializeProductServices()
  if (mode !== 'remote') throw new Error('Local product services are disabled.')
  const service = factory.remote()
  services.set(key, service)
  return service
}

export function resetProductServiceForTests(key?: string): void {
  if (key) services.delete(key)
  else {
    services.clear()
    initializedMode = undefined
  }
}

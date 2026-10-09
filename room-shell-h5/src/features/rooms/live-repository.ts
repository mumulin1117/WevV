import {
  resetProductServiceForTests,
  resolveProductService,
} from '@/core/product-mode/product-services'
import type { LiveRepository } from './contracts'
import { OpiLiveRepository } from './opi-live-repository'

export function getLiveRepository(): LiveRepository {
  return resolveProductService<LiveRepository>('live', {
    remote: () => new OpiLiveRepository(),
  })
}

export function resetLiveRepositoryForTests(): void {
  resetProductServiceForTests('live')
}

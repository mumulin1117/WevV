import {
  resetProductServiceForTests,
  resolveProductService,
} from '@/core/product-mode/product-services'
import type { PartyRepository } from './contracts'
import { RemotePartyRepository } from './remote-party-repository'

export function getPartyRepository(): PartyRepository {
  return resolveProductService<PartyRepository>('party', {
    remote: () => new RemotePartyRepository(),
  })
}

export function resetPartyRepositoryForTests(): void {
  resetProductServiceForTests('party')
}

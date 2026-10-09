import { resolveProductService } from '@/core/product-mode/product-services'
import type { ProfileRepository } from './contracts'
import { OpiProfileRepository } from './opi-profile-repository'

export function getProfileRepository(): ProfileRepository {
  return resolveProductService<ProfileRepository>('profile', {
    remote: () => new OpiProfileRepository(),
  })
}

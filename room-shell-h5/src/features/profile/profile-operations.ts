import { getProfileRepository } from './profile-repository'

export const profileQueries = {
  getProfile: (signal?: AbortSignal) => getProfileRepository().getProfile(signal),
}

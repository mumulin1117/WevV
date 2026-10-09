import type { RelationshipRepository } from './contracts'
import { getRelationshipRepository } from './relationship-repository'

export const relationshipQueries: Pick<RelationshipRepository, 'getBlockedUserIds'> = {
  getBlockedUserIds: (...args) => getRelationshipRepository().getBlockedUserIds(...args),
}

export const relationshipActions: Omit<RelationshipRepository, 'getBlockedUserIds'> = {
  block: (...args) => getRelationshipRepository().block(...args),
  setFollowed: (...args) => getRelationshipRepository().setFollowed(...args),
  unblock: (...args) => getRelationshipRepository().unblock(...args),
}

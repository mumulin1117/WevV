import type { LivePkRankItem } from './live-pk-contracts'

export function displayLivePkRanks(
  list: readonly LivePkRankItem[],
): readonly (LivePkRankItem | null)[] {
  const ranks = list.slice(0, 3)
  return ranks.length ? ranks : [null]
}

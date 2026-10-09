import { getProductMode } from './runtime'

export interface ProductCapabilities {
  readonly game: boolean
  readonly likeYouVipGate: boolean
  readonly partyLevelGate: boolean
  readonly partyLiveVoice: boolean
  readonly vip: boolean
  readonly vipCheckIn: boolean
}

const REMOTE_CAPABILITIES: ProductCapabilities = Object.freeze({
  game: false,
  likeYouVipGate: false,
  partyLevelGate: true,
  partyLiveVoice: false,
  vip: false,
  vipCheckIn: false,
})

/**
 * 页面只能读取产品能力，不得自行解释 targetFlag。能力在一次运行期内随产品模式固定。
 */
export function getProductCapabilities(): ProductCapabilities {
  getProductMode()
  return REMOTE_CAPABILITIES
}

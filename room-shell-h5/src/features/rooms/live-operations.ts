import type { AnchorProfileRepository, LiveRepository } from './contracts'
import { getLiveRepository } from './live-repository'
import { getAnchorProfileRepository } from './anchor-profile-repository'
import type { LiveInteractionRepository } from './live-interaction-contracts'
import { getLiveInteractionRepository } from './live-interaction-repository'
import { loadLiveRoomMessages, sendLiveRoomMessage } from './live-room-message-repository'

type LiveQueryKeys = 'createLaunchContext' | 'isRoomAlive'

export const liveQueries: Pick<LiveRepository, LiveQueryKeys> = {
  createLaunchContext: (...args) => getLiveRepository().createLaunchContext(...args),
  isRoomAlive: (...args) => getLiveRepository().isRoomAlive(...args),
}

export const liveRoomMessageQueries = {
  load: loadLiveRoomMessages,
}

export const liveRoomMessageActions = {
  send: sendLiveRoomMessage,
}

export const anchorProfileQueries: Pick<
  AnchorProfileRepository,
  'getMomentComments' | 'getProfile'
> = {
  getMomentComments: (...args) => getAnchorProfileRepository().getMomentComments(...args),
  getProfile: (...args) => getAnchorProfileRepository().getProfile(...args),
}

export const anchorProfileActions: Pick<
  AnchorProfileRepository,
  'commentMoment' | 'setMomentLiked'
> = {
  commentMoment: (...args) => getAnchorProfileRepository().commentMoment(...args),
  setMomentLiked: (...args) => getAnchorProfileRepository().setMomentLiked(...args),
}

type LiveInteractionQueryKeys =
  | 'getAnchorCard'
  | 'getAnchorWeekRank'
  | 'getAudience'
  | 'getBackpackGifts'
  | 'getGiftCategories'
  | 'getGifts'
  | 'getQuickGifts'
  | 'getRank'
  | 'getWishlist'
  | 'getUserCard'
  | 'peekAnchorCard'
  | 'peekAnchorWeekRank'
  | 'peekAudience'
  | 'peekGifts'
  | 'peekRank'
  | 'peekWishlist'

type LiveInteractionActionKeys =
  | 'beginSession'
  | 'endSession'
  | 'refreshBalance'
  | 'reportEntryEffect'
  | 'sendBackpackGift'
  | 'sendGift'
  | 'setFollowed'

export const liveInteractionQueries: Pick<LiveInteractionRepository, LiveInteractionQueryKeys> = {
  getAnchorCard: (...args) => getLiveInteractionRepository().getAnchorCard(...args),
  getAnchorWeekRank: (...args) => getLiveInteractionRepository().getAnchorWeekRank(...args),
  getAudience: (...args) => getLiveInteractionRepository().getAudience(...args),
  getBackpackGifts: (...args) => getLiveInteractionRepository().getBackpackGifts(...args),
  getGiftCategories: (...args) => getLiveInteractionRepository().getGiftCategories(...args),
  getGifts: (...args) => getLiveInteractionRepository().getGifts(...args),
  getQuickGifts: (...args) => getLiveInteractionRepository().getQuickGifts(...args),
  getRank: (...args) => getLiveInteractionRepository().getRank(...args),
  getWishlist: (...args) => getLiveInteractionRepository().getWishlist(...args),
  getUserCard: (...args) => getLiveInteractionRepository().getUserCard(...args),
  peekAnchorCard: (...args) => getLiveInteractionRepository().peekAnchorCard(...args),
  peekAnchorWeekRank: (...args) => getLiveInteractionRepository().peekAnchorWeekRank(...args),
  peekAudience: (...args) => getLiveInteractionRepository().peekAudience(...args),
  peekGifts: (...args) => getLiveInteractionRepository().peekGifts(...args),
  peekRank: (...args) => getLiveInteractionRepository().peekRank(...args),
  peekWishlist: (...args) => getLiveInteractionRepository().peekWishlist(...args),
}

export const liveInteractionActions: Pick<LiveInteractionRepository, LiveInteractionActionKeys> = {
  beginSession: (...args) => getLiveInteractionRepository().beginSession(...args),
  endSession: (...args) => getLiveInteractionRepository().endSession(...args),
  refreshBalance: (...args) => getLiveInteractionRepository().refreshBalance(...args),
  reportEntryEffect: (...args) => getLiveInteractionRepository().reportEntryEffect(...args),
  sendBackpackGift: (...args) => getLiveInteractionRepository().sendBackpackGift(...args),
  sendGift: (...args) => getLiveInteractionRepository().sendGift(...args),
  setFollowed: (...args) => getLiveInteractionRepository().setFollowed(...args),
}

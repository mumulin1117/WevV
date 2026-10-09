import type { PartyRepository } from './contracts'
import { getPartyRepository } from './party-repository'

type PartyQueryKeys =
  | 'getAnnouncement'
  | 'getBackgrounds'
  | 'getCurrentBackground'
  | 'getBlacklist'
  | 'getCreateOptions'
  | 'getDirectory'
  | 'getEmojis'
  | 'getGiftCatalog'
  | 'getInviteCandidates'
  | 'getLanguages'
  | 'getMusic'
  | 'getMusicSettings'
  | 'getQueue'
  | 'getRank'
  | 'getRanking'
  | 'getRoom'
  | 'getRoomMember'
  | 'getRoomTemplates'
  | 'getViewers'
  | 'isAvailable'
  | 'listRooms'
  | 'managesCommunication'
  | 'observe'
type PartyActionKeys = Exclude<keyof PartyRepository, PartyQueryKeys>

export const partyQueries: Pick<PartyRepository, PartyQueryKeys> = {
  getAnnouncement: (...args) => getPartyRepository().getAnnouncement(...args),
  getBackgrounds: (...args) => getPartyRepository().getBackgrounds(...args),
  getCurrentBackground: (...args) => getPartyRepository().getCurrentBackground(...args),
  getBlacklist: (...args) => getPartyRepository().getBlacklist(...args),
  getCreateOptions: (...args) => getPartyRepository().getCreateOptions(...args),
  getDirectory: (...args) => getPartyRepository().getDirectory(...args),
  getEmojis: (...args) => getPartyRepository().getEmojis(...args),
  getGiftCatalog: (...args) => getPartyRepository().getGiftCatalog(...args),
  getInviteCandidates: (...args) => getPartyRepository().getInviteCandidates(...args),
  getLanguages: (...args) => getPartyRepository().getLanguages(...args),
  getMusic: (...args) => getPartyRepository().getMusic(...args),
  getMusicSettings: (...args) => getPartyRepository().getMusicSettings(...args),
  getQueue: (...args) => getPartyRepository().getQueue(...args),
  getRank: (...args) => getPartyRepository().getRank(...args),
  getRanking: (...args) => getPartyRepository().getRanking(...args),
  getRoom: (...args) => getPartyRepository().getRoom(...args),
  getRoomMember: (...args) => getPartyRepository().getRoomMember(...args),
  getRoomTemplates: (...args) => getPartyRepository().getRoomTemplates(...args),
  getViewers: (...args) => getPartyRepository().getViewers(...args),
  isAvailable: (...args) => getPartyRepository().isAvailable(...args),
  listRooms: (...args) => getPartyRepository().listRooms(...args),
  managesCommunication: (...args) => getPartyRepository().managesCommunication(...args),
  observe: (...args) => getPartyRepository().observe(...args),
}

export const partyActions: Pick<PartyRepository, PartyActionKeys> = {
  approveQueueEntry: (...args) => getPartyRepository().approveQueueEntry(...args),
  cancelSeatApplication: (...args) => getPartyRepository().cancelSeatApplication(...args),
  createRoom: (...args) => getPartyRepository().createRoom(...args),
  dismissEmoji: (...args) => getPartyRepository().dismissEmoji(...args),
  holdMemberOnSeat: (...args) => getPartyRepository().holdMemberOnSeat(...args),
  inviteMembers: (...args) => getPartyRepository().inviteMembers(...args),
  prepareRoomEntry: (...args) => getPartyRepository().prepareRoomEntry(...args),
  joinRoom: (...args) => getPartyRepository().joinRoom(...args),
  kickMember: (...args) => getPartyRepository().kickMember(...args),
  leaveRoom: (...args) => getPartyRepository().leaveRoom(...args),
  leaveSeat: (...args) => getPartyRepository().leaveSeat(...args),
  moderateSeat: (...args) => getPartyRepository().moderateSeat(...args),
  pauseMusic: (...args) => getPartyRepository().pauseMusic(...args),
  playMusic: (...args) => getPartyRepository().playMusic(...args),
  refuseQueueEntry: (...args) => getPartyRepository().refuseQueueEntry(...args),
  removeFromBlacklist: (...args) => getPartyRepository().removeFromBlacklist(...args),
  retryRoomCommunication: (...args) => getPartyRepository().retryRoomCommunication(...args),
  sendEmoji: (...args) => getPartyRepository().sendEmoji(...args),
  sendGift: (...args) => getPartyRepository().sendGift(...args),
  sendMessage: (...args) => getPartyRepository().sendMessage(...args),
  setAnnouncement: (...args) => getPartyRepository().setAnnouncement(...args),
  setBackground: (...args) => getPartyRepository().setBackground(...args),
  setMemberAdmin: (...args) => getPartyRepository().setMemberAdmin(...args),
  setMemberFollowed: (...args) => getPartyRepository().setMemberFollowed(...args),
  setMusicEnabled: (...args) => getPartyRepository().setMusicEnabled(...args),
  setMusicLiked: (...args) => getPartyRepository().setMusicLiked(...args),
  updateMusicSettings: (...args) => getPartyRepository().updateMusicSettings(...args),
  setOnSeatApplyEnabled: (...args) => getPartyRepository().setOnSeatApplyEnabled(...args),
  setRoomLock: (...args) => getPartyRepository().setRoomLock(...args),
  setRoomTemplate: (...args) => getPartyRepository().setRoomTemplate(...args),
  setRoomVisible: (...args) => getPartyRepository().setRoomVisible(...args),
  setSeatMedia: (...args) => getPartyRepository().setSeatMedia(...args),
  setSoundEnabled: (...args) => getPartyRepository().setSoundEnabled(...args),
  takeSeat: (...args) => getPartyRepository().takeSeat(...args),
  uploadMusic: (...args) => getPartyRepository().uploadMusic(...args),
  uploadRoomCover: (...args) => getPartyRepository().uploadRoomCover(...args),
}

/** RoomShell 是同一纵向业务切片，允许通过这个领域门面组合查询与动作。 */
export const partyRoomOperations: PartyRepository = {
  ...partyQueries,
  ...partyActions,
}

export type GiftPanelSource = 'backpack' | 'catalog'

export interface GiftPanelItem {
  effectUrl: string
  iconUrl: string
  id: string
  name: string
  price: number
  quantity?: number
  remainingTime?: string
  sendable: boolean
  source: GiftPanelSource
}

export interface GiftPanelTab {
  id: string
  items: readonly GiftPanelItem[]
  label: string
}

export interface GiftPanelRecipient {
  avatarUrl: string
  id: string
  imAccount: string
  name: string
}

export interface GiftPanelSelection {
  item: GiftPanelItem
  quantity: number
}

export interface GiftPanelRechargeRequest {
  requiredDiamonds: number
  selection: GiftPanelSelection | null
}

export interface RechargeOptions {
  originKey?: string
  requiredDiamonds?: number
  source: 'gift' | 'live' | 'party' | 'private-message' | 'profile'
}

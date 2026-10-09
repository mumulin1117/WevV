import {
  resetProductServiceForTests,
  resolveProductService,
} from '@/core/product-mode/product-services'
import type {
  GameLaunchRequest,
  GameRepository,
  LiveRpsOrderRequest,
  LiveRpsPlayRequest,
} from './contracts'
import { OpiGameRepository } from './opi-game-repository'

function getGameRepository(): GameRepository {
  return resolveProductService<GameRepository>('game', {
    remote: () => new OpiGameRepository(),
  })
}

export function queryFullGameCatalog(signal?: AbortSignal) {
  return getGameRepository().getFullCatalog(signal)
}

export function queryHalfGameCatalog(signal?: AbortSignal) {
  return getGameRepository().getHalfCatalog(signal)
}

export function buildGameLaunch(request: GameLaunchRequest, signal?: AbortSignal) {
  return getGameRepository().buildLaunch(request, signal)
}

export function queryLiveRpsConfig(signal?: AbortSignal) {
  return getGameRepository().getLiveRpsConfig(signal)
}

export function createLiveRpsOrder(request: LiveRpsOrderRequest, signal?: AbortSignal) {
  return getGameRepository().createLiveRpsOrder(request, signal)
}

export function playLiveRps(request: LiveRpsPlayRequest, signal?: AbortSignal) {
  return getGameRepository().playLiveRps(request, signal)
}

export function exitLiveRps(orderId: string, signal?: AbortSignal) {
  return getGameRepository().exitLiveRps(orderId, signal)
}

export function queryLiveWheelConfig(anchorId: string, signal?: AbortSignal) {
  return getGameRepository().getLiveWheelConfig(anchorId, signal)
}

export function rotateLiveWheel(anchorId: string, signal?: AbortSignal) {
  return getGameRepository().rotateLiveWheel(anchorId, signal)
}

export function resetGameRepositoryForTests(): void {
  resetProductServiceForTests('game')
}

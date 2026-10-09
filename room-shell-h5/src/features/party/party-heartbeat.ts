/**
 * 语聊 WebSocket 心跳在当前本地 Java 对接包中关闭。
 *
 * 保留这个生命周期门面，让房间仓库无需为模拟模式维护另一套状态机；所有方法
 * 都是同步空操作，因此不会读取 IM 凭据、创建 WebSocket 或启动定时器。
 */
export interface PartyHeartbeatTerminalFailure {
  error: Error
  roomId: string
}

export interface PartyHeartbeatOptions {
  onTerminalFailure?: (failure: PartyHeartbeatTerminalFailure) => void
}

export class PartyHeartbeat {
  constructor(_options: PartyHeartbeatOptions = {}) {}

  async start(_roomId: string, _seatIndex = -1): Promise<void> {}

  updateSeat(_seatIndex: number): void {}

  stop(): void {}
}

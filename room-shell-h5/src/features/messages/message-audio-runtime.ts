type Listener = (activeMessageId: string, playing: boolean) => void

class MessageAudioRuntime {
  private activeMessageId = ''
  private readonly audio = new Audio()
  private readonly listeners = new Set<Listener>()

  constructor() {
    this.audio.preload = 'none'
    this.audio.addEventListener('play', () => this.emit(true))
    this.audio.addEventListener('pause', () => this.emit(false))
    this.audio.addEventListener('ended', () => this.release())
  }

  observe(listener: Listener): () => void {
    this.listeners.add(listener)
    listener(this.activeMessageId, !this.audio.paused)
    return () => this.listeners.delete(listener)
  }

  async toggle(messageId: string, url: string): Promise<void> {
    if (!messageId || !url) return
    if (this.activeMessageId === messageId) {
      if (this.audio.paused) await this.audio.play()
      else this.audio.pause()
      return
    }
    this.audio.pause()
    this.audio.src = url
    this.activeMessageId = messageId
    this.emit(false)
    await this.audio.play()
  }

  release(messageId?: string): void {
    if (messageId && messageId !== this.activeMessageId) return
    this.audio.pause()
    this.audio.removeAttribute('src')
    this.audio.load()
    this.activeMessageId = ''
    this.emit(false)
  }

  private emit(playing: boolean): void {
    this.listeners.forEach((listener) => listener(this.activeMessageId, playing))
  }
}

export const messageAudioRuntime = new MessageAudioRuntime()

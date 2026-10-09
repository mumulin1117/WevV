const TECHNICAL_ERROR_PATTERN =
  /(?:\b(?:RTC|SDK|IM|NIM)\b|chatroom_|credential|access token|not connected|not ready|simulat|review-user|local-room|stack trace|sql(?:state|exception)?)/iu

export function toUserFacingError(error: unknown, fallback: string): string {
  const message = error instanceof Error ? error.message.trim() : ''
  if (!message || TECHNICAL_ERROR_PATTERN.test(message)) return fallback
  return message
}

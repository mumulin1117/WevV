export interface AnchorRelationshipChange {
  blocked?: boolean
  followed?: boolean
  userId: string
}

const eventName = 'app:anchor-relationship-change'

export function emitAnchorRelationshipChange(detail: AnchorRelationshipChange): void {
  window.dispatchEvent(new CustomEvent<AnchorRelationshipChange>(eventName, { detail }))
}

export function onAnchorRelationshipChange(
  listener: (detail: AnchorRelationshipChange) => void,
): () => void {
  const handler = (event: Event) =>
    listener((event as CustomEvent<AnchorRelationshipChange>).detail)
  window.addEventListener(eventName, handler)
  return () => window.removeEventListener(eventName, handler)
}

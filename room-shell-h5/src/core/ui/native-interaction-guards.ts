const editableSelector = ['input', 'textarea', 'select', '[contenteditable="true"]'].join(',')

function isEditable(target: EventTarget | null): boolean {
  return target instanceof Element && Boolean(target.closest(editableSelector))
}

export function installNativeInteractionGuards(): () => void {
  const preventOutsideEditor = (event: Event): void => {
    if (!isEditable(event.target)) event.preventDefault()
  }

  const preventMediaDrag = (event: DragEvent): void => {
    if (event.target instanceof Element && event.target.closest('img,video,canvas,svg,picture,a'))
      event.preventDefault()
  }

  const preventPinchTouch = (event: TouchEvent): void => {
    if (event.touches.length > 1) event.preventDefault()
  }

  const preventCtrlWheelZoom = (event: WheelEvent): void => {
    if (event.ctrlKey) event.preventDefault()
  }

  document.addEventListener('contextmenu', preventOutsideEditor, { capture: true })
  document.addEventListener('selectstart', preventOutsideEditor, { capture: true })
  document.addEventListener('dragstart', preventMediaDrag, { capture: true })
  document.addEventListener('dblclick', preventOutsideEditor, { capture: true })
  document.addEventListener('gesturestart', preventOutsideEditor, { capture: true })
  document.addEventListener('gesturechange', preventOutsideEditor, { capture: true })
  document.addEventListener('gestureend', preventOutsideEditor, { capture: true })
  document.addEventListener('touchmove', preventPinchTouch, { capture: true, passive: false })
  document.addEventListener('wheel', preventCtrlWheelZoom, { capture: true, passive: false })

  return () => {
    document.removeEventListener('contextmenu', preventOutsideEditor, { capture: true })
    document.removeEventListener('selectstart', preventOutsideEditor, { capture: true })
    document.removeEventListener('dragstart', preventMediaDrag, { capture: true })
    document.removeEventListener('dblclick', preventOutsideEditor, { capture: true })
    document.removeEventListener('gesturestart', preventOutsideEditor, { capture: true })
    document.removeEventListener('gesturechange', preventOutsideEditor, { capture: true })
    document.removeEventListener('gestureend', preventOutsideEditor, { capture: true })
    document.removeEventListener('touchmove', preventPinchTouch, { capture: true })
    document.removeEventListener('wheel', preventCtrlWheelZoom, { capture: true })
  }
}

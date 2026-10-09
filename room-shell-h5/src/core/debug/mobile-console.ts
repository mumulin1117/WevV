import { resolveBundleUrl } from '@/core/assets/bundle-url'
import { getRuntimeConfig } from '@/core/config/runtime-config'
import type VConsole from 'vconsole'

let mobileConsole: VConsole | undefined
let initialization: Promise<void> | undefined

declare global {
  interface Window {
    VConsole?: typeof VConsole
  }
}

function loadMobileConsoleRuntime(): Promise<void> {
  if (window.VConsole) return Promise.resolve()
  return new Promise((resolve, reject) => {
    const script = document.createElement('script')
    script.async = true
    script.dataset.vconsoleRuntime = 'true'
    script.src = resolveBundleUrl('assets/vconsole.js')
    script.addEventListener('load', () => resolve(), { once: true })
    script.addEventListener('error', () => reject(new Error('VConsole runtime failed to load.')), {
      once: true,
    })
    document.head.append(script)
  })
}

export function initializeMobileConsole(): Promise<void> {
  if (!getRuntimeConfig().debug.vConsoleEnabled || mobileConsole) return Promise.resolve()
  initialization ??= loadMobileConsoleRuntime()
    .then(() => {
      if (!window.VConsole) throw new Error('VConsole runtime is invalid.')
      mobileConsole = new window.VConsole({ theme: 'dark' })
    })
    .catch((cause) => {
      initialization = undefined
      console.error('[diagnostic] VConsole initialization failed.', cause)
    })
  return initialization
}

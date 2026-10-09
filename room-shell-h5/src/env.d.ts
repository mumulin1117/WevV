/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_AGORA_APP_ID?: string
  readonly VITE_AGORA_AUDIENCE_UID?: string
  readonly VITE_AGORA_LIVE_TOKEN?: string
  readonly VITE_AGORA_USER_UID?: string
  readonly VITE_AGORA_VOICE_TOKEN?: string
  readonly VITE_ENABLE_VCONSOLE?: 'true' | 'false'
}

interface Window {
  __SOCIAL_FIXTURE_DATA__?: unknown
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}

declare module '*.vue' {
  import type { DefineComponent } from 'vue'

  const component: DefineComponent<object, object, any>
  export default component
}

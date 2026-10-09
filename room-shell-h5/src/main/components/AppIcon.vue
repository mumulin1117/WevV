<script setup lang="ts">
import { computed } from 'vue'
import { publicAsset } from '@/core/media/public-asset'
import { responsiveCssLength } from '@/main/ui/responsive-unit'

export type AppIconName =
  | 'back'
  | 'camera'
  | 'check'
  | 'chevron'
  | 'close'
  | 'edit'
  | 'game'
  | 'female'
  | 'gift'
  | 'globe'
  | 'heart'
  | 'home'
  | 'image'
  | 'info'
  | 'login'
  | 'logout'
  | 'male'
  | 'messages'
  | 'microphone'
  | 'more'
  | 'moments'
  | 'profile'
  | 'play'
  | 'plus'
  | 'ranking'
  | 'refresh'
  | 'search'
  | 'send'
  | 'settings'
  | 'star'
  | 'trophy'
  | 'users'
  | 'warning'
  | 'video'
  | 'volume'

const props = withDefaults(
  defineProps<{
    label?: string
    name: AppIconName
    size?: number | string
  }>(),
  {
    label: undefined,
    size: 24,
  },
)

const paths: Record<AppIconName, string[]> = {
  back: ['M15.5 19 8.5 12l7-7'],
  camera: ['M4 8.5h3l1.3-2h7.4l1.3 2h3v10H4z', 'M12 10.5a3 3 0 1 0 0 6 3 3 0 0 0 0-6z'],
  check: ['m5 12 4 4L19 6'],
  chevron: ['m9 5 7 7-7 7'],
  close: ['M6 6l12 12M18 6 6 18'],
  edit: ['M4 20h4l11-11-4-4L4 16z', 'm13.5 6.5 4 4'],
  game: [
    'M7.4 8h9.2a4.4 4.4 0 0 1 4.2 5.7l-1.2 4a2.5 2.5 0 0 1-4.1 1.1L13.8 17h-3.6l-1.7 1.8a2.5 2.5 0 0 1-4.1-1.1l-1.2-4A4.4 4.4 0 0 1 7.4 8z',
    'M8 11v4M6 13h4M16.5 11.5h.01M18.5 14.5h.01',
  ],
  female: ['M12 14a5 5 0 1 0 0-10 5 5 0 0 0 0 10z', 'M12 14v7M9 18h6'],
  gift: [
    'M4 10h16v11H4z',
    'M3 6h18v4H3z',
    'M12 6v15',
    'M12 6H8.8A2.3 2.3 0 1 1 12 2.8z',
    'M12 6h3.2A2.3 2.3 0 1 0 12 2.8z',
  ],
  globe: [
    'M12 22a10 10 0 1 0 0-20 10 10 0 0 0 0 20z',
    'M2 12h20',
    'M12 2a15.3 15.3 0 0 1 0 20M12 2a15.3 15.3 0 0 0 0 20',
  ],
  heart: [
    'M20.8 5.8a5.4 5.4 0 0 0-7.6 0L12 7l-1.2-1.2a5.4 5.4 0 1 0-7.6 7.6L12 22l8.8-8.6a5.4 5.4 0 0 0 0-7.6z',
  ],
  home: ['M3 10.5 12 3l9 7.5V21h-6v-6H9v6H3z'],
  image: ['M4 4h16v16H4z', 'm4 16 4.5-4.5 3.5 3.5 2-2 6 6', 'M15.5 8.5h.01'],
  info: ['M12 11v6', 'M12 7h.01', 'M12 22a10 10 0 1 0 0-20 10 10 0 0 0 0 20z'],
  login: ['M10 5H5v14h5', 'm13 8 4 4-4 4', 'M17 12H9'],
  logout: ['M10 5H5v14h5', 'm15 8 4 4-4 4', 'M19 12H9'],
  male: ['M14.5 9.5 20 4M15 4h5v5', 'M14.5 9.5a5 5 0 1 1-7.1 0 5 5 0 0 1 7.1 0z'],
  messages: ['M4 5h16v12H8l-4 4z'],
  microphone: [
    'M12 3a3 3 0 0 0-3 3v6a3 3 0 0 0 6 0V6a3 3 0 0 0-3-3z',
    'M5 11a7 7 0 0 0 14 0M12 18v3',
  ],
  more: ['M5 12h.01M12 12h.01M19 12h.01'],
  moments: ['M4 4h16v16H4z', 'M8 8h8v8H8z'],
  profile: ['M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8z', 'M4 21a8 8 0 0 1 16 0'],
  play: ['m8 5 11 7-11 7z'],
  plus: ['M12 5v14M5 12h14'],
  ranking: ['M5 20V10h4v10M10 20V4h4v16M15 20v-7h4v7', 'M3 20h18'],
  refresh: ['M20 11a8 8 0 1 0-2.34 5.66', 'M20 4v7h-7'],
  search: ['M11 4a7 7 0 1 0 0 14 7 7 0 0 0 0-14z', 'm16 16 5 5'],
  send: ['m3 11 18-8-8 18-2-7z', 'm11 14 10-11'],
  settings: [
    'M12 15.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z',
    'M19.4 15a1.8 1.8 0 0 0 .36 2l.06.06-2.8 2.8-.06-.06a1.8 1.8 0 0 0-2-.36 1.8 1.8 0 0 0-1.1 1.64V21h-4v-.08a1.8 1.8 0 0 0-1.1-1.64 1.8 1.8 0 0 0-2 .36l-.06.06-2.8-2.8.06-.06a1.8 1.8 0 0 0 .36-2A1.8 1.8 0 0 0 2.68 14H2v-4h.68a1.8 1.8 0 0 0 1.64-1.1 1.8 1.8 0 0 0-.36-2L3.9 6.84l2.8-2.8.06.06a1.8 1.8 0 0 0 2 .36A1.8 1.8 0 0 0 9.86 2.8V2h4v.8a1.8 1.8 0 0 0 1.1 1.64 1.8 1.8 0 0 0 2-.36l.06-.06 2.8 2.8-.06.06a1.8 1.8 0 0 0-.36 2A1.8 1.8 0 0 0 21.04 10H22v4h-.96A1.8 1.8 0 0 0 19.4 15z',
  ],
  star: ['m12 3 2.8 5.7 6.2.9-4.5 4.4 1.1 6.2-5.6-2.9-5.6 2.9 1.1-6.2L3 9.6l6.2-.9z'],
  trophy: [
    'M8 4h8v4a4 4 0 0 1-8 0z',
    'M8 6H4v2a4 4 0 0 0 4 4M16 6h4v2a4 4 0 0 1-4 4',
    'M12 12v5M8 21h8M9 17h6v4',
  ],
  users: [
    'M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2',
    'M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8z',
    'M22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75',
  ],
  video: ['M3 6h13v12H3z', 'm16 10 5-3v10l-5-3z'],
  volume: ['M11 5 6 9H3v6h3l5 4z', 'M15.5 8.5a5 5 0 0 1 0 7', 'M18 6a8.5 8.5 0 0 1 0 12'],
  warning: ['M12 3 2.7 20h18.6z', 'M12 9v5', 'M12 18h.01'],
}

const dimensions = computed(() => {
  const size = responsiveCssLength(props.size)
  return { height: size, width: size }
})
const usesCommonAsset = computed(() => props.name === 'back' || props.name === 'more')
</script>

<template>
  <img
    v-if="usesCommonAsset"
    class="app-icon app-icon--asset"
    :aria-hidden="!label"
    :aria-label="label"
    alt=""
    :src="publicAsset(name === 'back' ? 'common/back_icon.png' : 'common/more_icon.png')"
    :style="dimensions"
  />
  <svg
    v-else
    class="app-icon"
    :aria-hidden="!label"
    :aria-label="label"
    :style="dimensions"
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    stroke-linecap="round"
    stroke-linejoin="round"
    stroke-width="1.9"
  >
    <path v-for="path in paths[name]" :key="path" :d="path" />
  </svg>
</template>

<style scoped lang="less">
.app-icon {
  flex: 0 0 auto;
}

.app-icon--asset {
  display: block;
  object-fit: contain;
}
</style>

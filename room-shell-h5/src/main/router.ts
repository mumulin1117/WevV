import { createRouter, createWebHashHistory, type RouteRecordRaw } from 'vue-router'
import RoomRoutePage from './pages/RoomRoutePage.vue'

export const routes: RouteRecordRaw[] = [
  { path: '/live/:roomId', name: 'live-room', component: RoomRoutePage },
  { path: '/voice/:roomId', name: 'voice-room', component: RoomRoutePage },
  { path: '/entry-error', name: 'entry-error', component: RoomRoutePage },
  { path: '/:pathMatch(.*)*', redirect: '/entry-error' },
]

export const router = createRouter({
  history: createWebHashHistory(),
  routes,
  scrollBehavior: () => undefined,
})

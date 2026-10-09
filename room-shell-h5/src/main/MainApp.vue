<script setup lang="ts">
import PartyRoomPasswordEntry from '@/features/party/components/PartyRoomPasswordEntry.vue'
import AppOverlayHost from './components/AppOverlayHost.vue'
import AppUiProvider from './components/AppUiProvider.vue'
import RoomShellHost from './components/RoomShellHost.vue'
</script>

<template>
  <AppUiProvider>
    <RouterView />
    <AppOverlayHost />
    <PartyRoomPasswordEntry />
    <RoomShellHost />
  </AppUiProvider>
</template>

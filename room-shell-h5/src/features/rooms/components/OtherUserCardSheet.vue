<script setup lang="ts">
import type { LiveUserCardTarget } from '../live-interaction-contracts'
import { liveInteractionQueries } from '../live-operations'
import type { ProfileCardScene } from '../profile-card-policy'
import ManagedUserCardSheet from './ManagedUserCardSheet.vue'

export type OtherUserCardTarget = LiveUserCardTarget

defineProps<{
  modelValue: boolean
  scene: Exclude<ProfileCardScene, 'party'>
  target: OtherUserCardTarget | null
}>()
const emit = defineEmits<{
  detail: [profile: { id: string; imAccount: string }]
  followChange: [followed: boolean, userId: string]
  message: [profile: { avatar: string; id: string; imAccount: string; name: string }]
  'update:modelValue': [value: boolean]
}>()

const loadCard = liveInteractionQueries.getUserCard

function forwardFollowChange(followed: boolean, userId: string): void {
  emit('followChange', followed, userId)
}
</script>

<template>
  <ManagedUserCardSheet
    :model-value="modelValue"
    :load-card="loadCard"
    :scene="scene"
    :target="target"
    @detail="emit('detail', $event)"
    @follow-change="forwardFollowChange"
    @message="emit('message', $event)"
    @update:model-value="emit('update:modelValue', $event)"
  />
</template>

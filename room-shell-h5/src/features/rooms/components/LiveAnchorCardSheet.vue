<script setup lang="ts">
import { computed } from 'vue'
import type { RoomLaunchContext } from '../contracts'
import OtherUserCardSheet from './OtherUserCardSheet.vue'

const props = defineProps<{ context: RoomLaunchContext; modelValue: boolean }>()
const emit = defineEmits<{
  detail: [profile: { id: string; imAccount: string }]
  followChange: [followed: boolean, userId: string]
  message: [profile: { avatar: string; id: string; imAccount: string; name: string }]
  'update:modelValue': [value: boolean]
}>()

const target = computed(() => ({
  avatarUrl: props.context.hostAvatarUrl ?? '',
  id: props.context.hostId ?? '',
  imAccount: props.context.hostImAccount,
  name: props.context.displayName,
  userType: props.context.hostUserType,
}))
</script>

<template>
  <OtherUserCardSheet
    :model-value="modelValue"
    scene="live"
    :target="target"
    @detail="emit('detail', $event)"
    @follow-change="emit('followChange', $event, target.id)"
    @message="emit('message', $event)"
    @update:model-value="emit('update:modelValue', $event)"
  />
</template>

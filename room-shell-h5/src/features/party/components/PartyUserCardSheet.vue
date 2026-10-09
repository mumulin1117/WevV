<script setup lang="ts">
import { computed, shallowRef, watch } from 'vue'
import type { PartyMember } from '@/features/party/contracts'
import { partyQueries } from '@/features/party/party-operations'
import {
  partyMemberProfileCard,
  partyMemberProfileTarget,
} from '@/features/party/party-member-profile-card'
import type { UserProfileCardTarget } from '@/features/rooms/live-interaction-contracts'
import { liveInteractionQueries } from '@/features/rooms/live-operations'
import ManagedUserCardSheet from '@/features/rooms/components/ManagedUserCardSheet.vue'

const props = defineProps<{
  modelValue: boolean
  roomId: string
  target: PartyMember | null
}>()
const emit = defineEmits<{
  detail: [member: PartyMember]
  followChange: [member: PartyMember, followed: boolean]
  message: [member: PartyMember]
  'update:modelValue': [value: boolean]
}>()

const resolvedMember = shallowRef<PartyMember | null>(null)
const profileTarget = computed(() => (props.target ? partyMemberProfileTarget(props.target) : null))
const activeMember = computed(() =>
  resolvedMember.value?.id === props.target?.id ? resolvedMember.value : props.target,
)

async function loadCard(target: UserProfileCardTarget, signal: AbortSignal) {
  const [member, profile] = await Promise.all([
    partyQueries.getRoomMember(props.roomId, target.id, signal),
    liveInteractionQueries.getUserCard(target, signal),
  ])
  if (signal.aborted || props.target?.id !== target.id)
    throw new DOMException('The profile-card request was cancelled.', 'AbortError')
  if (!member.id || member.id !== target.id)
    throw new Error('The profile-card response belongs to another user.')
  resolvedMember.value = member
  const roomCard = partyMemberProfileCard(member)
  return {
    ...roomCard,
    ...profile,
    avatarUrl: profile.avatarUrl || roomCard.avatarUrl,
    cardFrameUrl: profile.cardFrameUrl || roomCard.cardFrameUrl,
    headFrameUrl: profile.headFrameUrl || roomCard.headFrameUrl,
    name: profile.name || roomCard.name,
  }
}

function handleDetail(profile: { id: string }): void {
  const member = activeMember.value
  if (member?.id === profile.id) emit('detail', member)
}

function handleMessage(profile: { id: string }): void {
  const member = activeMember.value
  if (member?.id === profile.id) emit('message', member)
}

function handleFollowChange(followed: boolean, userId: string): void {
  const member = activeMember.value
  if (!member || member.id !== userId) return
  const updated = { ...member, followed }
  resolvedMember.value = updated
  emit('followChange', updated, followed)
}

watch(
  () => props.target,
  (member) => {
    if (!member || resolvedMember.value?.id !== member.id) {
      resolvedMember.value = member
      return
    }
    resolvedMember.value = {
      ...resolvedMember.value,
      followed: member.followed,
      muted: member.muted,
      owner: member.owner,
      platformAdmin: member.platformAdmin,
      roomRole: member.roomRole,
    }
  },
  { immediate: true },
)
</script>

<template>
  <ManagedUserCardSheet
    :load-card="loadCard"
    :model-value="modelValue"
    :room-id="roomId"
    scene="party"
    :target="profileTarget"
    @detail="handleDetail"
    @follow-change="handleFollowChange"
    @message="handleMessage"
    @update:model-value="emit('update:modelValue', $event)"
  >
    <template #extra="{ card }">
      <slot v-if="activeMember" name="extra" :card="card" :member="activeMember" />
    </template>
    <template #management="{ card }">
      <slot v-if="activeMember" name="management" :card="card" :member="activeMember" />
    </template>
  </ManagedUserCardSheet>
</template>

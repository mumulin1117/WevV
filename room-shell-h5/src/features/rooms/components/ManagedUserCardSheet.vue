<script setup lang="ts">
import { computed, onBeforeUnmount, ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import { isAnchorUserType } from '@/features/relationships/contracts'
import { useAsyncAction } from '@/main/composables/useAsyncAction'
import { useRelationshipsStore } from '@/main/stores/relationships'
import { useSessionStore } from '@/main/stores/session'
import { useAppFeedback } from '@/main/ui/feedback'
import type { UserProfileCard, UserProfileCardTarget } from '../live-interaction-contracts'
import type { ProfileCardScene } from '../profile-card-policy'
import {
  ProfileCardRequestCoordinator,
  type ProfileCardRequestLoader,
} from '../profile-card-request'
import RoomUserCardSheet from './RoomUserCardSheet.vue'
import ReportSheet from '@/features/safety/components/ReportSheet.vue'
import type { ReportSource } from '@/features/safety/contracts'
import { useAppOverlay } from '@/main/ui/overlay'

const props = defineProps<{
  loadCard: ProfileCardRequestLoader<UserProfileCardTarget, UserProfileCard>
  modelValue: boolean
  scene: ProfileCardScene
  target: UserProfileCardTarget | null
  roomId?: string
}>()
const emit = defineEmits<{
  detail: [profile: { id: string; imAccount: string }]
  followChange: [followed: boolean, userId: string]
  loaded: [card: UserProfileCard]
  message: [profile: { avatar: string; id: string; imAccount: string; name: string }]
  'update:modelValue': [value: boolean]
}>()

const { t } = useI18n()
const session = useSessionStore()
const relationships = useRelationshipsStore()
const feedback = useAppFeedback()
const overlay = useAppOverlay()
const card = ref<UserProfileCard | null>(null)
const failed = ref(false)
const loading = ref(false)
const reportOpen = ref(false)
const requests = new ProfileCardRequestCoordinator<UserProfileCardTarget, UserProfileCard>()
let loadSequence = 0

const isSelf = computed(() => Boolean(card.value?.id && card.value.id === session.user?.id))
const relationship = computed(() => {
  const value = card.value
  return value
    ? relationships.relationship(value.id, {
        blocked: value.blocked,
        blockedKnown: true,
        followed: value.followed,
        followedKnown: true,
        userType: value.userType,
      })
    : null
})
const effectiveCard = computed(() => {
  const value = card.value
  const state = relationship.value
  return value && state
    ? { ...value, blocked: state.blocked, followed: state.followed, userType: state.userType }
    : value
})
const canFollow = computed(() =>
  card.value ? relationships.canFollow(card.value.id, card.value.userType) : false,
)
const canMessage = computed(() =>
  card.value ? relationships.canStartConversation(card.value.id, card.value.userType) : false,
)

function seedRelationship(value: UserProfileCard): void {
  relationships.seed({
    blocked: value.blocked,
    followed: value.followed,
    imAccount: value.imAccount,
    userId: value.id,
    userType: value.userType,
  })
}

async function load(): Promise<void> {
  const target = props.target
  if (!target?.id) return
  const sequence = ++loadSequence
  card.value = null
  loading.value = true
  failed.value = false
  relationships.seed({
    imAccount: target.imAccount,
    userId: target.id,
    userType: target.userType,
  })
  const [result] = await Promise.all([
    requests.load(target, props.loadCard),
    relationships.loadBlockedIds().catch(() => undefined),
  ])
  if (result.status === 'cancelled' || sequence !== loadSequence) return
  loading.value = false
  if (result.status === 'failed') {
    failed.value = true
    return
  }
  if (!props.modelValue || props.target?.id !== target.id) return
  seedRelationship(result.card)
  card.value = result.card
  emit('loaded', result.card)
}

async function performFollow(): Promise<void> {
  const profile = card.value
  if (!profile || isSelf.value || !canFollow.value) return
  if (relationship.value?.blocked) {
    feedback.warning(t('room.blockedUser'))
    return
  }
  const next = !relationship.value?.followed
  await relationships.setFollowed(
    { imAccount: profile.imAccount, userId: profile.id, userType: profile.userType },
    next,
  )
  emit('followChange', next, profile.id)
}

const followAction = useAsyncAction(performFollow, {
  errorMessage: () => t('room.followFailed'),
  feedback: 'blocking',
  loadingMessage: t('room.updating'),
  minimumIntervalMs: 700,
})

async function copyUserId(value: UserProfileCard): Promise<void> {
  try {
    if (navigator.clipboard?.writeText) await navigator.clipboard.writeText(value.id)
    else {
      const input = document.createElement('textarea')
      input.value = value.id
      input.setAttribute('readonly', '')
      input.style.position = 'fixed'
      input.style.opacity = '0'
      document.body.append(input)
      input.select()
      const copied = document.execCommand('copy')
      input.remove()
      if (!copied) throw new Error('Clipboard unavailable.')
    }
    feedback.success(t('common.copied'))
  } catch {
    feedback.error(t('common.copyFailed'))
  }
}

function openMessage(): void {
  const profile = card.value
  if (!profile || !canMessage.value) return
  emit('update:modelValue', false)
  emit('message', {
    avatar: profile.avatarUrl,
    id: profile.id,
    imAccount: profile.imAccount.trim() || profile.id,
    name: profile.name,
  })
}

function openDetail(): void {
  const profile = effectiveCard.value
  if (!profile || !isAnchorUserType(profile.userType)) return
  emit('update:modelValue', false)
  emit('detail', { id: profile.id, imAccount: profile.imAccount })
}

const reportSource = computed<ReportSource>(() =>
  props.scene === 'party' ? 'party' : props.scene === 'live' ? 'live' : 'profile',
)

async function openSafetyActions(): Promise<void> {
  const profile = effectiveCard.value
  if (!profile || isSelf.value) return
  const action = await overlay.userSafetyActionSheet({
    blockDisabled: Boolean(relationship.value?.blocked),
  })
  if (action === 'feedback') {
    reportOpen.value = true
    return
  }
  if (action !== 'block') return
  const confirmed = await overlay.confirm({
    message: t('safety.blockDescription', { name: profile.name }),
    title: t('safety.blockConfirm'),
  })
  if (!confirmed) return
  await relationships.block({
    imAccount: profile.imAccount,
    userId: profile.id,
    userType: profile.userType,
  })
  feedback.success(t('safety.blocked'))
}

watch(
  [() => props.modelValue, () => props.target?.id],
  ([open, targetId], [wasOpen, previousId]) => {
    if (open && (!wasOpen || targetId !== previousId)) void load()
    else if (!open) {
      loadSequence += 1
      requests.cancel()
      loading.value = false
    }
  },
  { immediate: true },
)
onBeforeUnmount(() => {
  loadSequence += 1
  requests.cancel()
})
</script>

<template>
  <RoomUserCardSheet
    :model-value="modelValue"
    :card="effectiveCard"
    :failed="failed"
    :follow-available="canFollow"
    :follow-pending="followAction.pending.value"
    :loading="loading"
    :message-available="canMessage"
    :scene="scene"
    :self="isSelf"
    @copy="copyUserId"
    @detail="openDetail"
    @follow="followAction.run().catch(() => undefined)"
    @message="openMessage"
    @retry="load"
    @safety="openSafetyActions().catch((cause) => feedback.error(cause))"
    @update:model-value="emit('update:modelValue', $event)"
  >
    <template #extra="{ card: slotCard }">
      <slot name="extra" :card="slotCard" />
    </template>
    <template #management="{ card: slotCard }">
      <slot name="management" :card="slotCard" />
    </template>
  </RoomUserCardSheet>
  <ReportSheet
    v-if="effectiveCard"
    v-model="reportOpen"
    :context="{
      roomId,
      source: reportSource,
      targetUserId: effectiveCard.id,
    }"
  />
</template>

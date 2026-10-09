<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import { publicAsset } from '@/core/media/public-asset'
import AppAnchorLevelBadge from '@/main/components/AppAnchorLevelBadge.vue'
import AppAvatar from '@/main/components/AppAvatar.vue'
import AppGenderAgeBadge from '@/main/components/AppGenderAgeBadge.vue'
import AppHeadFrame from '@/main/components/AppHeadFrame.vue'
import AppIcon from '@/main/components/AppIcon.vue'
import AppImage from '@/main/components/AppImage.vue'
import AppLoading from '@/main/components/AppLoading.vue'
import AppPopup from '@/main/components/AppPopup.vue'
import AppUserLevelTag from '@/main/components/AppUserLevelTag.vue'
import { parseUserLevel } from '@/main/components/user-level'
import type { UserProfileCard } from '../live-interaction-contracts'
import { resolveProfileCardPolicy, type ProfileCardScene } from '../profile-card-policy'

defineOptions({ name: 'UserProfileCardSheet' })

const props = withDefaults(
  defineProps<{
    card: UserProfileCard | null
    detailEnabled?: boolean
    failed?: boolean
    followAvailable?: boolean
    followPending?: boolean
    loading?: boolean
    messageAvailable?: boolean
    modelValue: boolean
    scene: ProfileCardScene
    self?: boolean
  }>(),
  {
    failed: false,
    detailEnabled: false,
    followAvailable: false,
    followPending: false,
    loading: false,
    messageAvailable: false,
    self: false,
  },
)
const emit = defineEmits<{
  copy: [card: UserProfileCard]
  detail: [card: UserProfileCard]
  follow: []
  message: []
  retry: []
  safety: []
  'update:modelValue': [value: boolean]
}>()
const { t } = useI18n()
const giftTab = ref<'received' | 'sent'>('received')
const cardFrameFailed = ref(false)
const visible = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value),
})
const gifts = computed(() =>
  giftTab.value === 'received' ? (props.card?.receivedGifts ?? []) : (props.card?.sentGifts ?? []),
)
const policy = computed(() =>
  resolveProfileCardPolicy({
    blocked: Boolean(props.card?.blocked),
    followAvailable: props.followAvailable,
    hasImAccount: Boolean(props.card?.imAccount.trim() || props.card?.id),
    messageAvailable: props.messageAvailable,
    scene: props.scene,
    self: props.self,
    userType: props.card?.userType,
  }),
)
const visibleLevel = computed(() => {
  if (!policy.value.showLevel) return null
  return parseUserLevel(props.card?.levelName)
})
const showFooterFollow = computed(() => policy.value.showFollow)
const showFooterActions = computed(() => showFooterFollow.value || policy.value.showMessage)
const visibleHeadFrameUrl = computed(() => {
  if (props.card?.headFrameUrl) return props.card.headFrameUrl
  return props.card?.vip ? publicAsset('profile-center/vip-avatar-frame.webp') : ''
})

function openDetail(): void {
  if (props.card && props.detailEnabled && policy.value.canOpenDetail) emit('detail', props.card)
}

watch(
  () => props.modelValue,
  (visible) => {
    if (visible) giftTab.value = 'received'
  },
)
watch(
  () => props.card?.cardFrameUrl,
  () => {
    cardFrameFailed.value = false
  },
)
</script>

<template>
  <AppPopup
    v-model="visible"
    bottom-inset-owner="content"
    class="room-user-card-popup"
    :closeable="false"
    flush
    panel-max-height="min(74dvh, 600px)"
    :show-handle="false"
    surface="transparent"
  >
    <section
      class="room-user-card"
      :class="{
        'has-card-frame': !loading && !failed && Boolean(card?.cardFrameUrl),
        'has-profile': !loading && !failed && card,
        'is-card-frame-failed': cardFrameFailed,
      }"
      data-room-scroll
    >
      <div class="room-user-card__surface">
        <AppImage
          v-if="card?.cardFrameUrl"
          aria-hidden="true"
          class="room-user-card__card-frame"
          fit="fill"
          :lazy="false"
          :src="card.cardFrameUrl"
          @error="cardFrameFailed = true"
          @load="cardFrameFailed = false"
        >
          <template #loading><span /></template>
          <template #error><span /></template>
          <template #empty><span /></template>
        </AppImage>
        <!-- <button
        class="room-user-card__close"
        type="button"
        :aria-label="t('common.close')"
        @click.stop="visible = false"
      >
        <AppIcon name="close" :size="15" />
      </button> -->
        <div v-if="loading" class="room-user-card__state">
          <AppLoading />
        </div>
        <button
          v-else-if="failed || !card"
          class="room-user-card__state"
          type="button"
          @click="emit('retry')"
        >
          {{ t('room.profileUnavailable') }} · {{ t('room.chatRetry') }}
        </button>
        <template v-else>
          <button
            v-if="!self"
            class="room-user-card__safety"
            type="button"
            :aria-label="t('messages.conversationActions')"
            @click="emit('safety')"
          >
            <AppIcon name="more" :size="18" />
          </button>
          <component
            :is="detailEnabled && policy.canOpenDetail ? 'button' : 'div'"
            class="room-user-card__avatar"
            :aria-label="
              detailEnabled && policy.canOpenDetail
                ? t('home.openCreator', { name: card.name })
                : undefined
            "
            :type="detailEnabled && policy.canOpenDetail ? 'button' : undefined"
            @click="openDetail"
          >
            <AppAvatar :alt="card.name" :lazy="false" :size="76" :src="card.avatarUrl" />
            <AppHeadFrame
              v-if="visibleHeadFrameUrl"
              class="room-user-card__frame"
              :lazy="false"
              :size="96"
              :src="visibleHeadFrameUrl"
            />
          </component>
          <component
            :is="detailEnabled && policy.canOpenDetail ? 'button' : 'div'"
            class="room-user-card__title-action"
            :type="detailEnabled && policy.canOpenDetail ? 'button' : undefined"
            @click="openDetail"
          >
            <h2>{{ card.name }}</h2>
          </component>
          <div class="room-user-card__meta">
            <span v-if="card.countryCode">
              <AppIcon name="globe" :size="12" />
              {{ card.countryCode }}
            </span>
            <button class="room-user-card__uid" type="button" @click="emit('copy', card)">
              UID: {{ card.id }}
            </button>
          </div>
          <div class="room-user-card__badges">
            <AppGenderAgeBadge
              v-if="card.age > 0 && card.gender !== 'unknown'"
              :age="card.age"
              :gender="card.gender"
            />
            <AppAnchorLevelBadge v-if="policy.role === 'anchor'" :level="card.levelName" size="s" />
            <AppUserLevelTag v-if="visibleLevel !== null" :level="visibleLevel" />
            <img
              v-if="card.vip"
              alt="VIP"
              class="room-user-card__vip"
              :src="publicAsset('common/vip.webp')"
            />
            <AppImage
              v-for="medal in card.medals.slice(0, 4)"
              :key="medal.id"
              :alt="medal.name"
              fit="contain"
              :height="14"
              :src="medal.iconUrl"
              :width="20"
            />
          </div>

          <div class="room-user-card__stats">
            <span
              ><strong>{{ card.followingCount.toLocaleString('en') }}</strong>
              {{ t('room.following') }}</span
            >
            <i />
            <span
              ><strong>{{ card.fansCount.toLocaleString('en') }}</strong>
              {{ t('room.followers') }}</span
            >
          </div>
          <p v-if="card.signature" class="room-user-card__signature">{{ card.signature }}</p>

          <section v-if="policy.showGiftWall" class="room-user-card__gift-wall">
            <header>
              <h3>{{ t('room.giftWall') }}</h3>
              <nav>
                <button
                  :class="{ active: giftTab === 'sent' }"
                  type="button"
                  @click="giftTab = 'sent'"
                >
                  {{ t('room.sent') }}
                </button>
                <button
                  :class="{ active: giftTab === 'received' }"
                  type="button"
                  @click="giftTab = 'received'"
                >
                  {{ t('room.received') }}
                </button>
              </nav>
            </header>
            <div v-if="gifts.length" class="room-user-card__gifts">
              <article v-for="gift in gifts" :key="gift.id">
                <AppImage
                  :alt="gift.name"
                  fit="contain"
                  :height="40"
                  :src="gift.iconUrl"
                  :width="40"
                />
                <strong>{{ gift.name }}</strong>
                <small>×{{ gift.count }}</small>
              </article>
            </div>
            <p v-else>{{ t('room.noGiftsYet') }}</p>
          </section>

          <slot name="extra" :card="card" />

          <footer
            v-if="showFooterActions"
            :class="{ 'is-single': !(showFooterFollow && policy.showMessage) }"
          >
            <button
              v-if="showFooterFollow"
              class="room-user-card__follow"
              :class="{ following: card.followed }"
              type="button"
              :disabled="followPending"
              @click="emit('follow')"
            >
              <AppIcon :name="card.followed ? 'check' : 'plus'" :size="16" />
              {{ card.followed ? t('room.following') : t('room.follow') }}
            </button>
            <button
              v-if="policy.showMessage"
              class="room-user-card__message"
              type="button"
              @click="emit('message')"
            >
              <AppIcon name="messages" :size="16" /> {{ t('room.message') }}
            </button>
          </footer>
          <slot name="management" :card="card" />
        </template>
      </div>
    </section>
  </AppPopup>
</template>

<style scoped lang="less">
:deep(.room-user-card-popup.app-popup-host.is-flush.van-popup--bottom) {
  overflow: visible;
  border: 0;
  border-radius: 0;
  background: transparent !important;
  box-shadow: none;
}

.room-user-card-popup :deep(.app-popup) {
  position: relative;
  overflow: visible;
  padding: 0;
  background: transparent;
}

.room-user-card-popup :deep(.app-popup__body) {
  overflow: visible;
}

.room-user-card {
  position: relative;
  max-height: 100%;
  box-sizing: border-box;
  overflow-y: auto;
  padding: 0;
  background: transparent;
  color: var(--color-text);
  overscroll-behavior: contain;
  scrollbar-width: none;
  text-align: center;
}

.room-user-card.has-profile {
  padding-top: 48px;
}

.room-user-card.has-card-frame {
  padding-top: 0;
}

.room-user-card::-webkit-scrollbar {
  display: none;
}

.room-user-card__surface {
  position: relative;
  isolation: isolate;
  min-height: 0;
  box-sizing: border-box;
  padding: 14px 18px calc(12px + var(--app-popup-content-bottom-inset));
  // border-radius: 20px 20px 0 0;
  background: var(--panel-bg);
  box-shadow: 0 18px 48px rgb(0 0 0 / 44%);
}

.room-user-card.has-profile .room-user-card__surface {
  padding-top: 56px;
}

.room-user-card.has-card-frame .room-user-card__surface {
  padding-top: 136px;
  background: transparent;
  box-shadow: none;
}

.room-user-card.has-card-frame.is-card-frame-failed .room-user-card__surface {
  background: var(--panel-bg);
  box-shadow: 0 18px 48px rgb(0 0 0 / 44%);
}

.room-user-card__surface > *:not(.room-user-card__avatar, .room-user-card__card-frame) {
  position: relative;
  z-index: 2;
}

.room-user-card__safety {
  position: absolute !important;
  top: 10px;
  right: 10px;
  z-index: 5 !important;
  display: grid;
  width: 38px;
  height: 38px;
  padding: 0;
  border: 0;
  border-radius: 50%;
  background: var(--color-on-dark-fill);
  color: var(--color-text);
  place-items: center;
}

.room-user-card__card-frame {
  position: absolute;
  z-index: 1;
  inset: 0;
  width: 100% !important;
  height: 100% !important;
  background: transparent;
  pointer-events: none;
}

.room-user-card__card-frame :deep(.van-image),
.room-user-card__card-frame :deep(.van-image__img),
.room-user-card__card-frame :deep(.van-image__loading),
.room-user-card__card-frame :deep(.van-image__error) {
  background: transparent;
}

.room-user-card__close {
  position: absolute;
  top: 4px;
  left: 8px;
  z-index: 4;
  display: grid;
  width: 44px;
  height: 44px;
  padding: 0;
  border: 0;
  border-radius: 50%;
  background: transparent;
  color: var(--color-text);
  place-items: center;
}

.room-user-card__close::before {
  position: absolute;
  inset: 5px;
  border-radius: 50%;
  background: var(--color-on-dark-fill);
  content: '';
}

.room-user-card__close :deep(*) {
  position: relative;
}

.room-user-card__avatar {
  position: absolute;
  z-index: 3;
  top: -48px;
  left: 50%;
  display: grid;
  width: 96px;
  height: 96px;
  margin: 0;
  padding: 0;
  place-items: center;
  border: 0;
  background: transparent;
  transform: translateX(-50%);
}

.room-user-card.has-card-frame .room-user-card__avatar {
  top: 18px;
}

button.room-user-card__avatar,
button.room-user-card__title-action {
  cursor: pointer;
}

button.room-user-card__avatar:focus-visible,
button.room-user-card__title-action:focus-visible {
  outline: 2px solid var(--color-secondary);
  outline-offset: 2px;
}

.room-user-card__avatar :deep(.avatar > .app-image) {
  border: 2px solid var(--color-on-dark-border);
}

.room-user-card__frame {
  position: absolute;
  z-index: 1;
  inset: 0;
}

.room-user-card__title-action {
  display: block;
  width: 100%;
  min-width: 0;
  max-width: 100%;
  margin: 0 auto;
  padding: 0;
  border: 0;
  background: transparent;
  color: inherit;
  text-align: center;
}

.room-user-card h2 {
  min-width: 0;
  max-width: 100%;
  margin: 2px 0 0;
  overflow: hidden;
  font-size: 20px;
  font-weight: 800;
  line-height: 25px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.room-user-card.has-card-frame h2 {
  max-width: 72%;
  margin-inline: auto;
}

.room-user-card__meta {
  display: flex;
  min-height: 28px;
  align-items: center;
  justify-content: center;
  gap: 4px;
}

.room-user-card__meta > span {
  display: flex;
  height: 20px;
  align-items: center;
  gap: 4px;
  padding: 0 7px;
  border-radius: 999px;
  background: var(--color-on-dark-fill);
  color: var(--color-on-dark-muted);
  font-size: 11px;
}

.room-user-card__uid,
.room-user-card__signature,
.room-user-card__gift-wall > p {
  margin: 0;
  padding: 0 6px;
  border: 0;
  background: transparent;
  color: var(--color-on-dark-subtle);
  font-size: 12px;
}

.room-user-card__uid {
  position: relative;
  min-height: 28px;
}

.room-user-card__uid::after {
  position: absolute;
  inset: -8px -4px;
  content: '';
}

.room-user-card__badges {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 5px;
  margin-top: 1px;
}

.room-user-card__badges:empty {
  display: none;
}

.room-user-card__vip {
  width: auto;
  height: 14px;
  flex: 0 0 auto;
  object-fit: contain;
}

.room-user-card__stats {
  display: grid;
  max-width: 286px;
  align-items: center;
  grid-template-columns: minmax(0, 1fr) 1px minmax(0, 1fr);
  margin: 10px auto 0;
}

.room-user-card__stats span {
  display: flex;
  min-width: 0;
  flex-direction: column;
  align-items: center;
  gap: 1px;
  color: var(--color-on-dark-subtle);
  font-size: 12px;
  line-height: 16px;
}

.room-user-card__stats strong {
  color: var(--color-text);
  font-size: 18px;
  font-weight: 800;
  line-height: 22px;
}

.room-user-card__stats i {
  width: 1px;
  height: 30px;
  background: var(--color-on-dark-border);
}

.room-user-card__signature {
  min-height: 20px;
  margin-top: 4px;
  padding: 0 12px;
  overflow: hidden;
  line-height: 20px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.room-user-card__gift-wall {
  margin-top: 12px;
  padding: 12px;
  border: 1px solid var(--color-on-dark-divider);
  border-radius: 14px;
  background: var(--color-profile-card-surface);
  text-align: left;
}

.room-user-card__gift-wall header {
  display: flex;
  min-height: 28px;
  align-items: center;
}

.room-user-card__gift-wall h3 {
  margin: 0 auto 0 0;
  font-size: 15px;
  font-weight: 800;
}

.room-user-card__gift-wall nav {
  display: flex;
  gap: 8px;
}

.room-user-card__gift-wall nav button {
  min-height: 28px;
  padding: 0 4px;
  border: 0;
  border-bottom: 2px solid transparent;
  background: transparent;
  color: var(--color-on-dark-muted);
  font-size: 12px;
}

.room-user-card__gift-wall nav button.active {
  border-bottom-color: var(--gradient-primary);
  color: var(--color-text);
  font-weight: 700;
}

.room-user-card__gifts {
  display: flex;
  gap: 8px;
  overflow-x: auto;
  padding-top: 6px;
  scrollbar-width: none;
  touch-action: pan-x;
}

.room-user-card__gifts article {
  display: grid;
  width: 58px;
  flex: 0 0 58px;
  justify-items: center;
  gap: 2px;
  padding: 4px 3px;
  border-radius: 10px;
  background: var(--color-on-dark-divider);
}

.room-user-card__gifts strong,
.room-user-card__gifts small {
  width: 100%;
  overflow: hidden;
  color: var(--color-text);
  font-size: 9px;
  text-align: center;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.room-user-card__gifts small {
  color: var(--color-on-dark-muted);
}

.room-user-card__surface > footer {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 10px;
  margin-top: 12px;
}

.room-user-card__surface > footer.is-single {
  grid-template-columns: 1fr;
}

.room-user-card__surface > footer button {
  display: flex;
  min-height: 44px;
  align-items: center;
  justify-content: center;
  gap: 6px;
  border: 1px solid transparent;
  border-radius: 23px;
  color: var(--color-text);
  font-size: 14px;
  font-weight: 700;
}

.room-user-card__follow {
  background: var(--gradient-primary);
}

.room-user-card__follow.following,
.room-user-card__message {
  border-color: var(--color-on-dark-fill);
  background: var(--color-profile-card-surface);
}

.room-user-card__surface > footer button:disabled {
  opacity: 0.5;
}

.room-user-card__state {
  display: grid;
  width: 100%;
  height: 100%;
  min-height: 330px;
  margin: 0;
  padding: 0;
  border: 0;
  background: transparent;
  color: var(--color-on-dark-muted);
  place-items: center;
}

@media (prefers-reduced-motion: reduce) {
  .room-user-card,
  .room-user-card button {
    scroll-behavior: auto;
    transition: none;
  }
}
</style>

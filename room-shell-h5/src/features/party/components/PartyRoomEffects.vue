<script setup lang="ts">
import { computed, onBeforeUnmount, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import { publicAsset } from '@/core/media/public-asset'
import type { PartyGiftPresentation, PartyMessage } from '@/features/party/contracts'
import { createPartyRoomEffectScheduler } from '@/features/party/party-room-effect-scheduler'
import LiveEffectPlayer from '@/features/rooms/components/LiveEffectPlayer.vue'
import { legacyUserEntryStyle } from '@/features/rooms/live-message-presentation'
import AppAvatar from '@/main/components/AppAvatar.vue'
import AppHeadFrame from '@/main/components/AppHeadFrame.vue'
import AppImage from '@/main/components/AppImage.vue'
import AppUserLevelTag from '@/main/components/AppUserLevelTag.vue'

const props = defineProps<{ active: boolean }>()
const { locale, t } = useI18n()
const scheduler = createPartyRoomEffectScheduler()
const state = scheduler.state
const rtl = computed(() => locale.value === 'ar')

function giftPresentation(message: PartyMessage): PartyGiftPresentation | null {
  return message.presentation?.kind === 'gift' ? message.presentation : null
}

function giftStackStyle(index: number, length: number): Record<string, string | number> {
  return { bottom: `${Math.max(0, length - 1 - index) * 60}px`, zIndex: 1_000 - index }
}

function namedGiftStyle(index: number, length: number): Record<string, string | number> {
  return {
    top: `calc(20% - ${Math.max(0, length - 1 - index) * 92}px)`,
    zIndex: 20_100 - index,
  }
}

function giftReceiverCount(message: PartyMessage): number {
  const presentation = giftPresentation(message)
  return Math.max(1, presentation?.receivers.length ?? message.giftReceiverIds?.length ?? 1)
}

function hasGiftReceivers(message: PartyMessage): boolean {
  return Boolean(giftPresentation(message)?.receivers.length || message.giftReceiverIds?.length)
}

function giftTotal(message: PartyMessage): number {
  return Math.max(1, message.giftCount ?? 1) * giftReceiverCount(message)
}

function mediaId(): number | undefined {
  return state.currentMedia?.id
}

function finishMedia(): void {
  const id = mediaId()
  if (id !== undefined) scheduler.finishMedia(id)
}

function failMedia(): void {
  const id = mediaId()
  if (id !== undefined) scheduler.failMedia(id)
}

function startMedia(): void {
  const id = mediaId()
  if (id !== undefined) scheduler.startMedia(id)
}

watch(
  () => props.active,
  (active) => scheduler.setActive(active),
  { immediate: true },
)

defineExpose({
  clear: scheduler.clear,
  enqueue: scheduler.enqueue,
  enqueueGiftMedia: scheduler.enqueueGiftMedia,
})

onBeforeUnmount(scheduler.dispose)
</script>

<template>
  <Teleport to="body">
    <section
      v-if="state.activeFloatingGifts.length"
      class="party-floating-gifts"
      :class="{ 'is-rtl': rtl }"
      aria-hidden="true"
    >
      <template v-for="(item, index) in state.activeFloatingGifts" :key="item.id">
        <div
          v-if="giftPresentation(item.message)?.variant === 'named'"
          class="party-named-gift"
          :style="namedGiftStyle(index, state.activeFloatingGifts.length)"
        >
          <span class="party-named-gift__avatar">
            <AppAvatar :size="56" :src="item.message.senderAvatarUrl" />
            <AppHeadFrame
              v-if="giftPresentation(item.message)?.senderHeadFrameUrl"
              class="party-named-gift__frame"
              :lazy="false"
              :size="76"
              :src="giftPresentation(item.message)?.senderHeadFrameUrl"
            />
          </span>
          <b>{{ item.message.senderName }}</b>
          <span class="party-named-gift__action">
            {{ t('party.sentGift') }}
            <AppImage alt="" fit="contain" :lazy="false" :src="item.message.giftIconUrl" />
          </span>
        </div>

        <div
          v-else
          class="party-floating-gift"
          :style="giftStackStyle(index, state.activeFloatingGifts.length)"
        >
          <img
            class="party-floating-gift__background"
            :class="{ 'is-mirrored': rtl }"
            :src="publicAsset('party/room/float-message-bg.png')"
            alt=""
          />
          <div class="party-floating-gift__content">
            <span class="party-floating-gift__avatar">
              <AppAvatar :size="40" :src="item.message.senderAvatarUrl" />
              <AppHeadFrame
                v-if="giftPresentation(item.message)?.senderHeadFrameUrl"
                class="party-floating-gift__frame"
                :lazy="false"
                :size="40"
                :src="giftPresentation(item.message)?.senderHeadFrameUrl"
              />
            </span>
            <span class="party-floating-gift__copy">
              <span class="party-floating-gift__identity">
                <b>{{ item.message.senderName }}</b>
                <template v-if="giftPresentation(item.message)?.senderUserType === 1">
                  <AppUserLevelTag
                    v-if="item.message.senderLevel !== undefined"
                    :level="item.message.senderLevel"
                    size="s"
                  />
                  <img
                    v-if="item.message.senderVip"
                    class="party-floating-gift__vip"
                    :src="publicAsset('party/room/vip_label3.webp')"
                    alt="VIP"
                  />
                </template>
                <AppImage
                  v-for="medal in giftPresentation(item.message)?.senderMedalUrls ?? []"
                  :key="medal"
                  class="party-floating-gift__medal"
                  :src="medal"
                  alt=""
                  fit="contain"
                  :lazy="false"
                />
                <img
                  v-if="
                    item.message.senderPlatformAdmin ||
                    (item.message.senderRoleType && item.message.senderRoleType < 3)
                  "
                  class="party-floating-gift__role"
                  :src="
                    publicAsset(
                      `party/room/icon_lv_${item.message.senderPlatformAdmin ? 1 : item.message.senderRoleType}.png`,
                    )
                  "
                  alt=""
                />
              </span>
              <span class="party-floating-gift__receivers">
                <span class="party-floating-gift__receiver-label">{{ t('party.sendsTo') }}</span>
                <b v-if="giftPresentation(item.message)?.receivers.length === 1">
                  {{ giftPresentation(item.message)?.receivers[0]?.name }}
                </b>
                <template v-else-if="giftPresentation(item.message)?.receivers.length">
                  <span class="party-floating-gift__receiver-avatars">
                    <AppAvatar
                      v-for="receiver in giftPresentation(item.message)?.receivers.slice(0, 3)"
                      :key="receiver.id"
                      :size="20"
                      :src="receiver.avatarUrl"
                    />
                  </span>
                  <b>{{ giftReceiverCount(item.message) }} {{ t('party.persons') }}</b>
                </template>
                <b v-else-if="hasGiftReceivers(item.message)">
                  {{ giftReceiverCount(item.message) }} {{ t('party.persons') }}
                </b>
              </span>
            </span>
            <span class="party-floating-gift__gift">
              <span>
                <AppImage alt="" fit="cover" :lazy="false" :src="item.message.giftIconUrl" />
                <em v-if="giftPresentation(item.message)?.mysteryBox">Mystery</em>
              </span>
              <b>X {{ giftTotal(item.message) }}</b>
            </span>
          </div>
        </div>
      </template>
    </section>

    <div v-if="state.currentEntry" class="party-entry-effect-root" aria-hidden="true">
      <div class="party-entry-effect" :style="legacyUserEntryStyle(state.currentEntry.senderLevel)">
        <AppUserLevelTag :level="state.currentEntry.senderLevel ?? 0" size="s" />
        <img
          v-if="state.currentEntry.senderVip"
          class="party-entry-effect__vip"
          :src="publicAsset('party/room/vip_label3.webp')"
          alt="VIP"
        />
        <b>{{ state.currentEntry.senderName }}</b>
        <span>{{ t('party.enteredRoom') }}</span>
      </div>
    </div>

    <div
      v-if="state.currentFirstGift?.presentation?.kind === 'first-gift'"
      class="party-first-gift"
      :class="rtl ? 'is-rtl' : 'is-ltr'"
      aria-hidden="true"
    >
      <div class="party-first-gift__banner">
        <AppImage
          class="party-first-gift__background"
          alt=""
          fit="cover"
          :lazy="false"
          :src="
            state.currentFirstGift.presentation.backgroundUrl ||
            publicAsset('party/room/first-gift-public-bg.webp')
          "
        />
        <img
          v-if="state.currentFirstGift.presentation.isFirstGift"
          class="party-first-gift__gift"
          :src="publicAsset('party/room/first-gift-box.webp')"
          alt=""
        />
        <AppImage
          v-else-if="
            state.currentFirstGift.presentation.giftImageUrl ||
            state.currentFirstGift.presentation.giftIconUrl
          "
          class="party-first-gift__gift"
          alt=""
          fit="contain"
          :lazy="false"
          :src="
            state.currentFirstGift.presentation.giftImageUrl ||
            state.currentFirstGift.presentation.giftIconUrl
          "
        />
        <span v-if="state.currentFirstGift.presentation.isFirstGift">
          <b>{{ state.currentFirstGift.presentation.nickname }}</b>
          {{ t('party.firstGiftSent') }} <em>{{ t('party.streamer') }}</em>
          <small>{{ t('party.firstGiftKick') }}</small>
        </span>
        <span v-else>{{ state.currentFirstGift.presentation.renderedText }}</span>
      </div>
    </div>

    <div
      v-if="state.currentMedia"
      class="party-media-effect"
      :class="`is-${state.currentMedia.kind}`"
      aria-hidden="true"
    >
      <LiveEffectPlayer
        v-if="state.currentMedia.kind === 'fullscreen'"
        :key="state.currentMedia.id"
        layout="legacy-gift"
        :muted="state.currentMedia.scene === 'entry'"
        :url="state.currentMedia.url"
        @error="failMedia"
        @finished="finishMedia"
        @started="startMedia"
      />
      <AppImage
        v-else
        :key="state.currentMedia.id"
        class="party-media-effect__normal"
        alt=""
        fit="contain"
        :lazy="false"
        priority
        :src="state.currentMedia.url"
        @animationend="finishMedia"
        @error="failMedia"
      />
    </div>

    <div
      v-if="
        state.currentMedia?.scene === 'entry' &&
        state.currentMedia.message.presentation?.kind === 'entry'
      "
      class="party-vehicle-entry"
      :style="{
        backgroundImage: `url(${publicAsset('party/room/live_user_bg.webp')})`,
      }"
      aria-hidden="true"
    >
      <span class="party-vehicle-entry__avatar">
        <AppAvatar :size="42" :src="state.currentMedia.message.senderAvatarUrl" />
      </span>
      <span class="party-vehicle-entry__identity">
        <span>
          <AppUserLevelTag :level="state.currentMedia.message.senderLevel ?? 0" size="s" />
          <img
            v-if="state.currentMedia.message.senderVip"
            :src="publicAsset('party/room/vip_label3.webp')"
            alt="VIP"
          />
        </span>
        <b>{{ state.currentMedia.message.senderName }}</b>
        <small>{{ t('party.enteredRoom') }}</small>
      </span>
    </div>
  </Teleport>
</template>

<style scoped lang="less">
.party-floating-gifts {
  position: fixed;
  top: min(80vw, 480px);
  left: calc(50% - min(300px, 50%));
  z-index: 20001;
  width: min(100vw, 600px);
  height: min(13.333vw, 80px);
  color: var(--color-on-dark);
  pointer-events: none;
}

.party-floating-gift {
  position: absolute;
  left: 0;
  width: min(96vw, 576px);
  height: min(12.8vw, 76.8px);
  font-weight: 500;
  transition: bottom 300ms cubic-bezier(0.4, 0, 0.2, 1);
  animation: party-floating-slide 3s cubic-bezier(0.4, 0, 0.2, 1) forwards;
}

.party-floating-gift__background {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: fill;
}

.party-floating-gift__background.is-mirrored {
  transform: scaleX(-1);
}

.party-floating-gift__content {
  position: absolute;
  inset: 0;
  display: flex;
  width: 100%;
  align-items: center;
  padding: min(1.067vw, 6.4px) min(1.6vw, 9.6px);
  font-size: 12px;
}

.party-floating-gift__avatar {
  position: relative;
  display: grid;
  width: 40px;
  height: 40px;
  flex: 0 0 auto;
  place-items: center;
}

.party-floating-gift__frame {
  position: absolute;
  z-index: 2;
  inset: 0;
}

.party-floating-gift__copy {
  display: flex;
  min-width: 0;
  flex: 1 1 0;
  flex-direction: column;
  justify-content: center;
  overflow: hidden;
  padding-inline-start: 8px;
}

.party-floating-gift__identity,
.party-floating-gift__receivers {
  display: flex;
  min-width: 0;
  align-items: center;
}

.party-floating-gift__identity > b {
  max-width: 106px;
  overflow: hidden;
  font-size: 14px;
  font-weight: 500;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.party-floating-gift__vip {
  width: 32px;
  height: 12px;
  margin-inline-start: 4px;
}

.party-floating-gift__role {
  width: 16px;
  height: 16px;
  margin-inline-start: 4px;
  object-fit: contain;
}

.party-floating-gift__medal {
  width: 16px !important;
  height: 16px !important;
  margin-inline-start: 4px;
}

.party-floating-gift__receivers {
  overflow: hidden;
  white-space: nowrap;
}

.party-floating-gift__receiver-label {
  flex: 0 0 auto;
}

.party-floating-gift__receivers b {
  min-width: 0;
  max-width: 106px;
  margin-inline-start: 4px;
  overflow: hidden;
  color: var(--color-party-chat-name);
  flex: 0 1 auto;
  font-weight: 500;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.party-floating-gift__receiver-avatars {
  display: flex;
  flex: 0 1 auto;
  min-width: 0;
  align-items: center;
  padding: 4px;
}

.party-floating-gift__receiver-avatars > :deep(.avatar) {
  margin-inline-end: -4px;
}

.party-floating-gift__gift {
  display: flex;
  align-items: center;
  flex: 0 0 auto;
}

.party-floating-gift__gift > span {
  position: relative;
  display: block;
  width: 32px;
  height: 32px;
  margin-inline: 4px;
}

.party-floating-gift__gift :deep(.app-image) {
  width: 100% !important;
  height: 100% !important;
}

.party-floating-gift__gift em {
  position: absolute;
  right: 0;
  bottom: 0;
  min-width: 20px;
  padding: 0 2px;
  border-radius: 5px;
  background: var(--gradient-primary);
  color: var(--color-on-dark);
  font-size: 7px;
  font-style: normal;
  text-align: center;
}

.party-floating-gift__gift > b {
  background: var(--gradient-party-entry-gold);
  background-clip: text;
  color: transparent;
  font-size: min(5.867vw, 35.2px);
  font-weight: 900;
  white-space: nowrap;
}

.party-named-gift {
  position: fixed;
  right: 0;
  left: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-shadow: 0 min(0.267vw, 1.6px) min(0.8vw, 4.8px) rgb(0 0 0 / 85%);
  animation: party-named-gift 3s ease forwards;
}

.party-named-gift__avatar {
  position: relative;
  display: grid;
  width: 56px;
  height: 56px;
  place-items: center;
}

.party-named-gift__frame {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.party-named-gift > b {
  max-width: 200px;
  margin-top: 6px;
  overflow: hidden;
  font-size: 15px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.party-named-gift__action {
  display: flex;
  align-items: center;
  gap: 4px;
  margin-top: 2px;
  color: var(--color-party-entry-lavender);
  font-size: 14px;
  font-weight: 700;
}

.party-named-gift__action :deep(.app-image) {
  width: 24px !important;
  height: 24px !important;
}

.party-entry-effect-root {
  position: fixed;
  top: 70%;
  left: calc(50% - min(300px, 50%));
  z-index: 5002;
  width: min(100vw, 600px);
  pointer-events: none;
}

.party-entry-effect {
  position: absolute;
  top: 0;
  left: 15px;
  display: flex;
  min-width: 212px;
  height: 26px;
  align-items: center;
  padding-inline-start: 8px;
  border-radius: 20px;
  color: var(--color-on-dark);
  font-size: 12px;
  animation: party-entry-slide 3s ease-in-out forwards;
}

.party-entry-effect__vip {
  width: 26px;
  height: 12px;
  margin-inline: 2px;
}

.party-entry-effect > b {
  max-width: 50px;
  margin-inline: 2px;
  overflow: hidden;
  color: var(--color-party-chat-name);
  font-weight: 500;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.party-entry-effect > span {
  font-weight: 500;
}

.party-first-gift {
  position: fixed;
  top: 30%;
  right: 0;
  left: 0;
  z-index: 20010;
  padding-inline: 8px;
  pointer-events: none;
  animation: party-first-gift-ltr 5s ease-in-out forwards;
}

.party-first-gift.is-rtl {
  animation-name: party-first-gift-rtl;
}

.party-first-gift__banner {
  display: flex;
  width: min(330px, 100%);
  min-height: 60px;
  align-items: center;
  gap: 10px;
  margin: 0 auto;
  padding: 8px 14px;
  overflow: hidden;
  border-radius: 16px;
  background: var(--gradient-party-entry-rose) center / cover no-repeat;
  color: var(--color-on-dark);
  font-size: 13px;
  font-weight: 700;
  text-shadow: 0 min(0.267vw, 1.6px) min(0.8vw, 4.8px) rgb(0 0 0 / 45%);
}

.party-first-gift__gift {
  position: relative;
  z-index: 1;
  width: 52px;
  height: 52px;
  flex: 0 0 auto;
  object-fit: contain;
}

.party-first-gift__background {
  position: absolute;
  inset: 0;
  width: 100% !important;
  height: 100% !important;
}

.party-first-gift__banner > span {
  position: relative;
  z-index: 1;
  min-width: 0;
  flex: 1;
  white-space: pre-line;
}

.party-first-gift__banner b {
  color: var(--color-party-rank-score);
}

.party-first-gift__banner em {
  color: var(--color-party-chat-name);
  font-style: normal;
}

.party-first-gift__banner small {
  display: block;
}

.party-media-effect {
  position: fixed;
  top: 0;
  left: 50%;
  z-index: var(--z-gift-effect);
  display: grid;
  width: min(100vw, 600px);
  height: 100vh;
  height: 100dvh;
  place-items: center;
  transform: translateX(-50%);
  pointer-events: none;
}

.party-media-effect > :deep(.live-effect-player) {
  width: 100%;
}

.party-media-effect__normal {
  width: min(40vw, 240px) !important;
  height: min(40vw, 240px) !important;
  animation: party-normal-gift 1.5s ease-out forwards;
}

.party-vehicle-entry {
  position: fixed;
  bottom: 40%;
  left: max(15px, calc(50% - 285px));
  z-index: calc(var(--z-gift-effect) + 1);
  display: flex;
  width: min(calc(100vw - 80px), 520px);
  height: 70px;
  align-items: center;
  padding-inline: 10px;
  background-position: center;
  background-repeat: no-repeat;
  background-size: 100% 100%;
  color: var(--color-on-dark);
  pointer-events: none;
}

.party-vehicle-entry__avatar {
  flex: 0 0 auto;
}

.party-vehicle-entry__identity {
  display: grid;
  min-width: 0;
  margin-inline-start: 7px;
}

.party-vehicle-entry__identity > span {
  display: flex;
  align-items: center;
  gap: 3px;
}

.party-vehicle-entry__identity img {
  width: 26px;
  height: 12px;
}

.party-vehicle-entry__identity b {
  max-width: 170px;
  overflow: hidden;
  color: var(--color-party-chat-name);
  font-size: 14px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.party-vehicle-entry__identity small {
  font-size: 12px;
}

@keyframes party-floating-slide {
  0% {
    opacity: 0;
    transform: translate(min(100vw, 600px));
  }

  25%,
  75% {
    opacity: 1;
    transform: translate(0);
  }

  100% {
    opacity: 0;
    transform: translate(max(-100vw, -600px));
  }
}

@keyframes party-named-gift {
  0% {
    opacity: 0;
    transform: scale(0.82);
  }

  13%,
  80% {
    opacity: 1;
    transform: scale(1);
  }

  100% {
    opacity: 0;
    transform: scale(0.96) translateY(max(-3.2vw, -19.2px));
  }
}

@keyframes party-entry-slide {
  0% {
    opacity: 0;
    transform: translate(calc(min(100vw, 600px) - min(11.733vw, 70.4px))) translateY(-50%);
  }

  32% {
    opacity: 1;
  }

  40%,
  80% {
    transform: translate(min(2.4vw, 14.4px)) translateY(-50%);
  }

  100% {
    opacity: 1;
    transform: translate(max(-100vw, -600px)) translateY(-50%);
  }
}

@keyframes party-first-gift-ltr {
  0% {
    opacity: 0;
    transform: translate(-110%);
  }

  8%,
  92% {
    opacity: 1;
    transform: translate(0);
  }

  100% {
    opacity: 0;
    transform: translate(110%);
  }
}

@keyframes party-first-gift-rtl {
  0% {
    opacity: 0;
    transform: translate(110%);
  }

  8%,
  92% {
    opacity: 1;
    transform: translate(0);
  }

  100% {
    opacity: 0;
    transform: translate(-110%);
  }
}

@keyframes party-normal-gift {
  0% {
    opacity: 0;
    transform: scale(0);
  }

  30%,
  70% {
    opacity: 1;
    transform: scale(1);
  }

  100% {
    opacity: 0;
  }
}

@media (prefers-reduced-motion: reduce) {
  .party-floating-gift,
  .party-entry-effect,
  .party-first-gift,
  .party-media-effect__normal,
  .party-named-gift {
    animation-name: none;
    opacity: 1;
    transform: none;
  }
}
</style>

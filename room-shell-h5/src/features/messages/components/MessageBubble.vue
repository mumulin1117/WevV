<script setup lang="ts">
import { onBeforeUnmount, onDeactivated, onMounted, ref } from 'vue'
import { useI18n } from 'vue-i18n'
import type { InboxMessage } from '../contracts'
import { resolveImageUrl } from '@/core/media/image-cdn'
import { publicAsset } from '@/core/media/public-asset'
import AppIcon from '@/main/components/AppIcon.vue'
import AppImage from '@/main/components/AppImage.vue'
import { useAppFeedback } from '@/main/ui/feedback'
import PrivateMediaMessageCard from './PrivateMediaMessageCard.vue'
import { messageAudioRuntime } from '../message-audio-runtime'

const props = defineProps<{
  imageList: string[]
  message: InboxMessage
}>()
defineEmits<{ privateActivate: []; retry: [] }>()
const { t } = useI18n()
const feedback = useAppFeedback()
const voicePlaying = ref(false)
let stopAudioObserver: (() => void) | undefined

function releaseVoiceSource(): void {
  messageAudioRuntime.release(props.message.id)
}

function toggleVoiceMessage(): void {
  const url = resolveImageUrl(props.message.audio?.url)
  if (!url) return
  void messageAudioRuntime.toggle(props.message.id, url).catch(() => {
    releaseVoiceSource()
    feedback.warning(t('messages.voiceUnavailable'))
  })
}

onMounted(() => {
  stopAudioObserver = messageAudioRuntime.observe((messageId, playing) => {
    voicePlaying.value = messageId === props.message.id && playing
  })
})
onDeactivated(releaseVoiceSource)
onBeforeUnmount(() => {
  stopAudioObserver?.()
  releaseVoiceSource()
})
</script>

<template>
  <div class="msg-row" :class="[`msg-row--${message.kind}`, { 'is-own': message.own }]">
    <div class="msg">
      <AppImage
        v-if="message.kind === 'image' && message.attachmentUrl"
        :alt="message.text"
        :lazy="false"
        preview
        :preview-list="imageList"
        radius="12px"
        :src="message.attachmentUrl"
      />
      <PrivateMediaMessageCard
        v-else-if="message.kind === 'private-media'"
        :message="message"
        @activate="$emit('privateActivate')"
      />
      <template v-else-if="message.kind === 'audio' && message.audio">
        <button
          class="voice-msg"
          type="button"
          :aria-label="t('messages.voiceMessage')"
          :aria-pressed="voicePlaying"
          @click="toggleVoiceMessage"
        >
          <AppIcon name="volume" :size="20" />
          <span>{{ t('messages.voiceMessage') }}</span>
        </button>
      </template>
      <div v-else-if="message.kind === 'gift' && message.gift" class="gift-msg">
        <div class="gift-msg__body">
          <p>{{ t('messages.giftGreeting') }}</p>
          <AppImage
            :alt="message.gift.name"
            :lazy="false"
            radius="8px"
            :src="message.gift.iconUrl"
          />
          <strong v-if="message.gift.count > 1">×{{ message.gift.count }}</strong>
        </div>
        <footer>
          <span>{{ t('messages.gift') }}</span>
          <b aria-hidden="true">›</b>
        </footer>
      </div>
      <p v-else>{{ message.text }}</p>
      <button
        v-if="message.delivery === 'failed'"
        class="msg__retry"
        type="button"
        :aria-label="t('messages.retryMessage')"
        @click="$emit('retry')"
      >
        <img :src="publicAsset('messages/retry_msg.png')" alt="" />
      </button>
      <i v-else-if="message.delivery === 'sending'" class="msg__sending" />
      <span
        v-else-if="message.own && message.delivery === 'sent'"
        class="msg__sent"
        :aria-label="t('messages.messageSent')"
      >
        <AppIcon name="check" :size="11" />
      </span>
    </div>
  </div>
</template>

<style scoped lang="less">
.msg-row {
  display: flex;
  max-width: 86%;
  align-items: flex-end;
  gap: 7px;
  margin: 6px 0;
}

.msg-row.is-own {
  align-self: flex-end;
}

.msg {
  position: relative;
  min-width: 0;
}

.msg > p {
  min-height: 40px;
  padding: 10px 16px;
  border-radius: 15px 15px 15px 4px;
  background: var(--color-message-bubble);
  color: var(--color-text);
  font-size: 14px;
  line-height: 20px;
  font-weight: 500;
  overflow-wrap: anywhere;
  white-space: pre-wrap;
}

.is-own .msg > p {
  border-radius: 15px 15px 4px;
  background: var(--color-message-bubble-own);
}

.msg-row--image .msg :deep(.app-image) {
  width: 150px;
  max-height: 290px;
}

.msg-row--private-media {
  max-width: 100%;
}

.voice-msg {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 10px 22px;
  border: 0;
  border-radius: 12px 12px 12px 0;
  background: var(--color-text);
  box-shadow: 0 1px 3px rgb(0 0 0 / 20%);
  color: var(--color-on-primary);
  font:
    500 14px/20px 'TT Norms Pro',
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    sans-serif;
}

.is-own .voice-msg {
  border-radius: 12px 12px 0;
}

.gift-msg {
  width: min(62vw, 224px);
  overflow: hidden;
  border-radius: 16px 16px 5px;
  color: var(--color-text);
  background: var(--gradient-brand);
}

.gift-msg__body {
  position: relative;
  display: grid;
  min-height: 76px;
  grid-template-columns: minmax(0, 1fr) 62px;
  align-items: center;
  gap: 7px;
  padding: 10px 10px 10px 14px;
  background: var(--gradient-brand);
}

.gift-msg__body p {
  font-size: 12px;
  font-weight: 500;
}

.gift-msg__body strong {
  position: absolute;
  right: 8px;
  bottom: 8px;
  font-size: 10px;
  text-shadow: 0 1px 3px rgb(0 0 0 / 70%);
}

.gift-msg :deep(.app-image) {
  width: 62px;
  height: 62px;
  background: transparent;
}

.gift-msg footer {
  display: flex;
  min-height: 28px;
  align-items: center;
  justify-content: space-between;
  padding: 0 11px 0 14px;
  background: rgb(0 0 0 / 20%);
  color: var(--color-text);
  font-size: 12px;
  font-weight: 500;
  font-style: italic;
}

.gift-msg footer b {
  font-size: 20px;
  font-weight: 400;
  font-style: normal;
}

.msg__retry,
.msg__sending,
.msg__sent {
  position: absolute;
  top: 50%;
  right: calc(100% + 7px);
  width: 20px;
  height: 20px;
  transform: translateY(-50%);
}

.msg__retry {
  padding: 0;
  border: 0;
  border-radius: 50%;
  background: transparent;
}

.msg__retry img {
  width: 100%;
  height: 100%;
}

.msg__sending {
  border: 2px solid var(--color-border-strong);
  border-top-color: var(--color-text);
  border-radius: 50%;
  animation: message-spin 0.8s linear infinite;
}

.msg__sent {
  display: grid;
  width: 14px;
  height: 14px;
  place-items: center;
  border-radius: 50%;
  background: var(--color-success);
  color: var(--color-on-primary);
}

@keyframes message-spin {
  to {
    transform: translateY(-50%) rotate(1turn);
  }
}
</style>

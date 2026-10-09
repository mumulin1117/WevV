<script setup lang="ts">
import { computed } from 'vue'
import { useI18n } from 'vue-i18n'
import AppAvatar from '@/main/components/AppAvatar.vue'
import AppIcon from '@/main/components/AppIcon.vue'

type LiveTerminalReason = 'ended' | 'failed'

const props = defineProps<{
  avatarUrl?: string
  canMessage: boolean
  description: string
  displayName: string
  reason: LiveTerminalReason
  retrying?: boolean
}>()

defineEmits<{
  leave: []
  message: []
  retry: []
}>()

const { t } = useI18n()
const title = computed(() =>
  props.reason === 'ended' ? t('room.liveEndedTitle') : t('room.liveUnavailable'),
)
const titleId = computed(() => `live-terminal-${props.reason}-title`)
</script>

<template>
  <section
    class="live-terminal"
    :class="`live-terminal--${reason}`"
    :aria-labelledby="titleId"
    :role="reason === 'failed' ? 'alert' : 'status'"
  >
    <div class="live-terminal__content">
      <div class="live-terminal__avatar">
        <AppAvatar :alt="displayName" :lazy="false" priority :size="92" :src="avatarUrl" />
      </div>

      <strong class="live-terminal__name">{{ displayName }}</strong>
      <h1 :id="titleId">{{ title }}</h1>
      <p>{{ description }}</p>

      <div
        class="live-terminal__actions"
        :class="{
          'is-ended': reason === 'ended',
          'is-single-primary': !canMessage,
        }"
      >
        <button
          v-if="canMessage"
          class="live-terminal__action live-terminal__action--message"
          :class="{ 'is-primary': reason === 'ended' }"
          type="button"
          @click="$emit('message')"
        >
          <AppIcon name="messages" :size="20" />
          <span>{{ t('room.message') }}</span>
        </button>
        <button
          v-if="reason === 'failed'"
          class="live-terminal__action live-terminal__action--retry is-primary"
          type="button"
          :aria-busy="retrying"
          :disabled="retrying"
          @click="$emit('retry')"
        >
          <AppIcon name="refresh" :size="20" />
          <span>{{ t('common.retry') }}</span>
        </button>
        <button
          class="live-terminal__action live-terminal__action--leave"
          :class="{ 'is-primary': reason === 'ended' && !canMessage }"
          type="button"
          @click="$emit('leave')"
        >
          <AppIcon name="back" :size="22" />
          <span>{{ t('room.backToLive') }}</span>
        </button>
      </div>
    </div>
  </section>
</template>

<style scoped lang="less">
.live-terminal {
  position: absolute;
  inset: 0;
  z-index: 9;
  display: grid;
  overflow: hidden;
  padding: calc(var(--safe-top) + 76px) 24px calc(var(--room-bottom-inset, 0px) + 32px);
  color: var(--color-text);
  background:
    radial-gradient(
      circle at 50% 35%,
      color-mix(in srgb, var(--color-accent) 18%, transparent),
      transparent 31%
    ),
    linear-gradient(
      180deg,
      var(--color-scrim-soft) 0%,
      var(--color-scrim-strong) 58%,
      color-mix(in srgb, var(--color-media-bg) 94%, transparent) 100%
    );
  place-items: center;
  text-align: center;
  backdrop-filter: blur(13px) saturate(0.72);
}

.live-terminal__content {
  display: grid;
  width: min(100%, 344px);
  justify-items: center;
}

.live-terminal__avatar {
  display: grid;
  width: 98px;
  height: 98px;
  margin-bottom: 16px;
  padding: 3px;
  border-radius: 50%;
  background: var(--gradient-primary);
  box-shadow: 0 18px 40px rgb(0 0 0 / 32%);
  place-items: center;
}

.live-terminal__avatar :deep(.avatar > .app-image) {
  border: 0;
}

.live-terminal__name {
  overflow: hidden;
  width: 100%;
  margin-bottom: 22px;
  font-family:
    'TT Norms Pro',
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    sans-serif;
  font-size: 15px;
  font-weight: 800;
  line-height: 1.35;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.live-terminal h1 {
  margin: 0;
  font-family:
    'TT Norms Pro',
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    sans-serif;
  font-size: clamp(25px, 7vw, 32px);
  font-weight: 900;
  line-height: 1.12;
  letter-spacing: -0.025em;
}

.live-terminal p {
  max-width: 300px;
  min-height: 38px;
  margin: 12px 0 26px;
  color: var(--color-text-muted);
  font-size: 13px;
  line-height: 1.5;
}

.live-terminal__actions {
  display: grid;
  width: 100%;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 10px;
}

.live-terminal__action {
  display: inline-flex;
  min-width: 0;
  min-height: 50px;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 0 17px;
  border: 1px solid var(--color-on-dark-border);
  border-radius: 999px;
  color: var(--color-text);
  background: var(--color-on-dark-fill);
  font-size: 14px;
  font-weight: 850;
  transition:
    transform 160ms ease,
    background-color 160ms ease,
    opacity 160ms ease;
  backdrop-filter: blur(12px);
}

.live-terminal__action.is-primary {
  border-color: transparent;
  color: var(--color-text);
  background: var(--gradient-primary);
  box-shadow: 0 12px 30px color-mix(in srgb, var(--color-primary) 28%, transparent);
}

.live-terminal__action--leave {
  grid-column: 1 / -1;
  min-height: 44px;
  border-color: transparent;
  color: var(--color-text-muted);
  background: transparent;
}

.live-terminal__actions.is-ended {
  grid-template-columns: 1fr;
}

.live-terminal__actions.is-single-primary
  .live-terminal__action:not(.live-terminal__action--leave) {
  grid-column: 1 / -1;
}

.live-terminal__action--leave.is-primary {
  border-color: transparent;
  color: var(--color-text);
  background: var(--gradient-primary);
}

.live-terminal__action:active:not(:disabled) {
  transform: scale(0.98);
}

.live-terminal__action:disabled {
  opacity: 0.56;
}

@media (width <= 340px) {
  .live-terminal {
    padding-right: 18px;
    padding-left: 18px;
  }

  .live-terminal__actions {
    grid-template-columns: 1fr;
  }

  .live-terminal__action--leave {
    grid-column: auto;
  }
}

@media (prefers-reduced-motion: reduce) {
  .live-terminal__action {
    transition: none;
  }
}
</style>

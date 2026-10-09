<script setup lang="ts">
import { computed, useSlots } from 'vue'
import { useI18n } from 'vue-i18n'
import AppIcon from '@/main/components/AppIcon.vue'
import AppPopup from '@/main/components/AppPopup.vue'

type PartySheetSize = 'compact' | 'gift' | 'large' | 'standard'

const props = withDefaults(
  defineProps<{
    bottomInsetOwner?: 'content' | 'layout'
    centerTitle?: boolean
    closeOnPopstate?: boolean
    flat?: boolean
    fullscreen?: boolean
    height?: string
    hideClose?: boolean
    maxHeight?: string
    overlay?: boolean
    size?: PartySheetSize
    showFooter?: boolean
    show: boolean
    suspended?: boolean
    title?: string
  }>(),
  {
    bottomInsetOwner: 'layout',
    centerTitle: true,
    closeOnPopstate: true,
    flat: false,
    fullscreen: false,
    height: '',
    hideClose: true,
    maxHeight: '',
    overlay: true,
    size: 'compact',
    showFooter: true,
    suspended: false,
    title: '',
  },
)

const emit = defineEmits<{
  closed: []
  'update:show': [value: boolean]
}>()
const { t } = useI18n()
const slots = useSlots()
const hasFooter = computed(() => props.showFooter && Boolean(slots.footer))

const sizeHeight: Record<PartySheetSize, string> = {
  compact: '',
  gift: '368px',
  large: 'min(540px, 64dvh)',
  standard: 'min(460px, 56dvh)',
}
const sizeMaxHeight: Record<PartySheetSize, string> = {
  compact: 'min(420px, 52dvh)',
  gift: '368px',
  large: 'min(540px, 64dvh)',
  standard: 'min(460px, 56dvh)',
}
const panelHeight = computed(() =>
  props.fullscreen ? '100dvh' : props.height || sizeHeight[props.size],
)
const panelMaxHeight = computed(() =>
  props.fullscreen ? '' : props.maxHeight || sizeMaxHeight[props.size],
)
</script>

<template>
  <AppPopup
    class="party-sheet-host"
    :class="{ 'is-fullscreen': fullscreen }"
    :closeable="false"
    :close-on-click-overlay="overlay"
    :close-on-popstate="closeOnPopstate"
    bottom-inset-owner="content"
    :expand-for-bottom-inset="!fullscreen"
    flush
    :model-value="show"
    :panel-height="panelHeight"
    :panel-max-height="panelMaxHeight"
    :round="false"
    :show-handle="false"
    :suspended="suspended"
    @closed="emit('closed')"
    @update:model-value="emit('update:show', $event)"
  >
    <section
      class="party-sheet"
      :class="{
        'is-flat': flat,
        'is-bounded': Boolean(panelMaxHeight),
        'is-fixed-height': Boolean(panelHeight),
        'is-fullscreen': fullscreen,
        'delegates-bottom-inset': bottomInsetOwner === 'content',
        'has-footer': hasFooter,
        'owns-bottom-inset': bottomInsetOwner === 'layout',
      }"
      :data-party-sheet-size="size"
      :style="{ maxHeight: fullscreen ? undefined : panelMaxHeight ? '100%' : undefined }"
    >
      <header v-if="title" :class="{ 'is-centered': centerTitle }">
        <h2>{{ title }}</h2>
        <button
          v-if="!hideClose"
          type="button"
          :aria-label="t('party.close')"
          @click="emit('update:show', false)"
        >
          <AppIcon name="close" :size="16" />
        </button>
      </header>
      <div class="party-sheet__body"><slot /></div>
      <footer v-if="hasFooter" class="party-sheet__footer"><slot name="footer" /></footer>
    </section>
  </AppPopup>
</template>

<style scoped lang="less">
:deep(.party-sheet-host.app-popup-host) {
  border: 0;
  background: var(--panel-bg) !important;
  box-shadow: none;
}

:deep(.party-sheet-host .app-popup) {
  width: min(100vw, 450px);
  background: var(--panel-bg);
}

.party-sheet {
  display: flex;
  width: 100%;
  box-sizing: border-box;
  flex-direction: column;
  overflow: hidden;
  background: var(--panel-bg);
}

.party-sheet.owns-bottom-inset:not(.has-footer) {
  padding-bottom: calc(8px + var(--app-popup-content-bottom-inset));
}

.party-sheet__footer {
  display: grid;
  min-width: 0;
  flex: 0 0 auto;
  gap: 8px;
  padding: 8px 16px 0;
}

.party-sheet.owns-bottom-inset.has-footer > .party-sheet__footer {
  padding-bottom: calc(8px + var(--app-popup-content-bottom-inset));
}

.party-sheet.is-fixed-height,
.party-sheet.is-fullscreen {
  height: 100%;
  min-height: 0;
}

.party-sheet.is-fullscreen {
  width: 100%;
  height: 100% !important;
  max-height: none;
  padding-top: var(--safe-top);
}

.party-sheet.is-flat {
  background: var(--panel-bg);
}

.party-sheet > header {
  display: grid;
  flex: 0 0 auto;
  grid-template-columns: 44px minmax(0, 1fr) 44px;
  align-items: center;
  padding: 0 8px;
}

.party-sheet > header::before {
  width: 44px;
  height: 44px;
  content: '';
}

.party-sheet h2 {
  min-width: 0;
  grid-column: 2;
  overflow: hidden;
  font-size: 17px;
  font-weight: 800;
  text-align: center;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.party-sheet > header:not(.is-centered)::before {
  display: none;
}

.party-sheet > header:not(.is-centered) h2 {
  grid-column: 1 / 3;
  padding-inline-start: 8px;
  text-align: start;
}

.party-sheet header button {
  position: relative;
  display: grid;
  width: 44px;
  height: 44px;
  grid-column: 3;
  justify-self: end;
  padding: 0;
  place-items: center;
  border: 0;
  border-radius: 50%;
  background: transparent;
  color: var(--color-on-dark);
  cursor: pointer;
}

.party-sheet header button::before {
  position: absolute;
  inset: 4px;
  border-radius: 50%;
  background: var(--color-on-dark-fill);
  content: '';
}

.party-sheet header button :deep(*) {
  position: relative;
}

.party-sheet header button:focus-visible,
.party-sheet__footer :deep(button:focus-visible) {
  outline: 2px solid var(--color-secondary);
  outline-offset: -2px;
}

.party-sheet__body {
  min-height: 0;
}

.party-sheet.is-bounded > .party-sheet__body,
.party-sheet.is-fixed-height > .party-sheet__body,
.party-sheet.is-fullscreen > .party-sheet__body {
  flex: 1;
  overflow: hidden;
}

.party-sheet__footer :deep(.party-sheet-primary),
.party-sheet__footer :deep(.party-sheet-secondary),
.party-sheet__footer :deep(.party-sheet-danger) {
  width: 100%;
  min-height: 44px;
  border: 0;
  border-radius: 999px;
  color: var(--color-text);
  cursor: pointer;
  font-size: 16px;
  font-weight: 800;
}

.party-sheet__footer :deep(.party-sheet-primary) {
  background: var(--gradient-primary);
}

.party-sheet__footer :deep(.party-sheet-secondary) {
  background: var(--color-on-dark-fill);
  font-size: 15px;
  font-weight: 700;
}

.party-sheet__footer :deep(.party-sheet-danger) {
  background: color-mix(in srgb, var(--color-danger) 12%, transparent);
  color: var(--color-danger);
  font-size: 15px;
  font-weight: 800;
}

.party-sheet__footer :deep(button:disabled) {
  cursor: default;
  opacity: 0.45;
}

@media (prefers-reduced-motion: reduce) {
  .party-sheet__footer :deep(button) {
    transition: none;
  }
}
</style>

<script setup lang="ts">
import { nextTick, onBeforeUnmount, ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import { useAppNavigation } from '@/core/navigation/coordinator'
import { PartyRoomEntryError } from '@/features/party/contracts'
import {
  closePartyRoomPassword,
  partyRoomPasswordEntry,
  setPartyRoomPasswordError,
  submitPartyRoomPassword,
} from '@/features/party/open-party-room'
import { useAppFeedback } from '@/main/ui/feedback'

const POPUP_Z_INDEX = 2050

const feedback = useAppFeedback()
const navigation = useAppNavigation()
const { t } = useI18n()
const password = ref('')
const keyboardVisible = ref(false)
let releaseGesture: (() => void) | undefined

function close(): void {
  if (partyRoomPasswordEntry.submitting) return
  keyboardVisible.value = false
  closePartyRoomPassword()
}

async function submit(): Promise<void> {
  if (partyRoomPasswordEntry.submitting || !/^\d{4}$/u.test(password.value)) return
  keyboardVisible.value = false
  const closeLoading = feedback.loading()
  try {
    const opened = await submitPartyRoomPassword(password.value)
    if (!opened) {
      close()
      feedback.warning(t('party.roomAlreadyOpen'))
    }
  } catch (error) {
    setPartyRoomPasswordError(
      error instanceof PartyRoomEntryError && error.reason === 'password'
        ? t('party.incorrectRoomPassword')
        : error instanceof Error
          ? error.message
          : t('party.loadingEnterFailed'),
    )
    await nextTick()
    keyboardVisible.value = true
  } finally {
    closeLoading()
  }
}

watch(
  () => partyRoomPasswordEntry.visible,
  (visible) => {
    if (!visible) {
      keyboardVisible.value = false
      releaseGesture?.()
      releaseGesture = undefined
      return
    }
    password.value = ''
    releaseGesture ??= navigation.acquireGestureLock('party-room-password')
    void nextTick(() => {
      keyboardVisible.value = true
    })
  },
  { immediate: true },
)

watch(password, (value) => {
  if (partyRoomPasswordEntry.error) setPartyRoomPasswordError('')
  if (value.length === 4) void submit()
})

onBeforeUnmount(() => releaseGesture?.())
</script>

<template>
  <VanPopup
    class="party-room-password-popup"
    :close-on-click-overlay="false"
    close-on-popstate
    closeable
    round
    :show="partyRoomPasswordEntry.visible"
    teleport="body"
    :z-index="POPUP_Z_INDEX"
    @update:show="($event) => !$event && close()"
  >
    <section class="party-room-password-panel" aria-labelledby="party-room-password-title">
      <h2 id="party-room-password-title">{{ t('party.enterPassword') }}</h2>
      <VanPasswordInput
        :error-info="partyRoomPasswordEntry.error"
        :focused="keyboardVisible"
        :gutter="14"
        :length="4"
        :value="password"
        @focus="keyboardVisible = true"
      />
    </section>
  </VanPopup>
  <VanNumberKeyboard
    v-model="password"
    class="party-room-password-keyboard"
    :maxlength="4"
    safe-area-inset-bottom
    :show="partyRoomPasswordEntry.visible && keyboardVisible"
    teleport="body"
    :z-index="POPUP_Z_INDEX + 1"
    @blur="keyboardVisible = false"
  />
</template>

<style scoped lang="less">
.party-room-password-popup {
  width: min(calc(100vw - 32px), 420px);
  overflow: visible;
  border: 1px solid var(--color-on-dark-fill);
  background: transparent;
  box-shadow: 0 18px 48px rgb(0 0 0 / 36%);
}

.party-room-password-panel {
  --van-password-input-height: 58px;
  --van-password-input-margin: 0;
  --van-password-input-radius: 12px;
  --van-password-input-background: var(--color-on-dark-border);
  --van-password-input-dot-color: var(--color-text);
  --van-password-input-error-info-color: var(--color-danger);
  --van-password-input-info-font-size: 12px;

  box-sizing: border-box;
  padding: 30px 20px 28px;
  border-radius: 24px;
  background: var(--gradient-party-user-card);
  color: var(--color-text);
}

.party-room-password-panel h2 {
  margin: 0 44px 20px;
  font-size: 20px;
  font-weight: 800;
  line-height: 24px;
  text-align: center;
}

.party-room-password-panel :deep(.van-password-input__security li) {
  border: 1px solid var(--color-on-dark-border);
  border-radius: 12px;
}

.party-room-password-panel :deep(.van-password-input__security::after) {
  display: none;
}

.party-room-password-panel :deep(.van-password-input__error-info) {
  min-height: 18px;
  margin-top: 10px;
  line-height: 18px;
}

.party-room-password-popup :deep(.van-popup__close-icon) {
  display: grid;
  width: 44px;
  height: 44px;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  background: var(--color-on-dark-fill);
  color: var(--color-text);
  font-size: 20px;
}

:global(.party-room-password-keyboard) {
  --van-number-keyboard-background: var(--color-party-password-keyboard-bg);
  --van-number-keyboard-key-active-color: var(--color-party-password-key-active);
  --van-number-keyboard-key-background: var(--color-party-password-key-bg);
  --van-number-keyboard-z-index: 2051;
  --van-text-color: var(--color-party-password-key-text);

  color: var(--color-party-password-key-text);
}

:global(.party-room-password-keyboard .van-key) {
  color: var(--color-party-password-key-text);
}
</style>

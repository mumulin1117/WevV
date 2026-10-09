<script setup lang="ts">
import { nextTick, onBeforeUnmount, ref, watch } from 'vue'
import { closeConfirmDialog, confirmDialogState } from '@/main/ui/confirm-dialog-state'

const card = ref<HTMLElement | null>(null)
let returnFocus: HTMLElement | null = null

watch(
  () => confirmDialogState.visible,
  (visible) => {
    if (!visible) return
    returnFocus = document.activeElement instanceof HTMLElement ? document.activeElement : null
    void nextTick(() =>
      card.value?.querySelector<HTMLElement>('.app-confirm-dialog__confirm')?.focus(),
    )
  },
)

function close(value: boolean): void {
  closeConfirmDialog(value)
  returnFocus?.focus()
  returnFocus = null
}

onBeforeUnmount(() => close(false))
</script>

<template>
  <Teleport to="body">
    <Transition name="app-confirm-dialog">
      <div
        v-if="confirmDialogState.visible"
        class="app-confirm-dialog-host"
        role="presentation"
        @keydown.esc="close(false)"
      >
        <section
          ref="card"
          class="app-confirm-dialog-card"
          :class="{ 'has-option': confirmDialogState.checkboxLabel }"
          role="alertdialog"
          aria-modal="true"
          :aria-describedby="confirmDialogState.message ? 'app-confirm-dialog-message' : undefined"
          :aria-labelledby="confirmDialogState.title ? 'app-confirm-dialog-title' : undefined"
        >
          <h2 v-if="confirmDialogState.title" id="app-confirm-dialog-title">
            {{ confirmDialogState.title }}
          </h2>
          <p v-if="confirmDialogState.message" id="app-confirm-dialog-message">
            {{ confirmDialogState.message }}
          </p>
          <label v-if="confirmDialogState.checkboxLabel" class="app-confirm-dialog-card__option">
            <input v-model="confirmDialogState.checked" type="checkbox" />
            <i aria-hidden="true">✓</i>
            <span>{{ confirmDialogState.checkboxLabel }}</span>
          </label>
          <div class="app-confirm-dialog-card__actions">
            <button class="app-confirm-dialog__confirm" type="button" @click="close(true)">
              {{ confirmDialogState.confirmButtonText }}
            </button>
            <button class="app-confirm-dialog__cancel" type="button" @click="close(false)">
              {{ confirmDialogState.cancelButtonText }}
            </button>
          </div>
        </section>
      </div>
    </Transition>
  </Teleport>
</template>

<style scoped lang="less">
.app-confirm-dialog-host {
  position: fixed;
  z-index: var(--z-confirm-dialog);
  inset: 0;
  display: grid;
  padding: max(24px, var(--safe-top)) max(24px, var(--safe-right)) max(24px, var(--safe-bottom))
    max(24px, var(--safe-left));
  background: var(--color-mask);
  backdrop-filter: blur(3px);
  -webkit-backdrop-filter: blur(3px);
  place-items: center;
  touch-action: none;
}

.app-confirm-dialog-card {
  width: min(calc(100vw - 48px), 287px);
  max-height: calc(100dvh - 48px);
  padding: 21px 20px 20px;
  overflow: hidden auto;
  border-radius: 24px;
  outline: 0;
  background: var(--color-message-confirm);
  box-shadow: 0 18px 54px rgb(0 0 0 / 38%);
  color: var(--color-text);
  text-align: center;
}

.app-confirm-dialog-card.has-option {
  width: min(calc(100vw - 40px), 320px);
  min-height: 278px;
  padding: 28px 17px 22px;
  border-radius: 26px;
  background: var(--color-message-confirm);
}

.app-confirm-dialog-card.has-option h2 {
  font-size: 21px;
}

.app-confirm-dialog-card.has-option .app-confirm-dialog__cancel {
  order: -1;
}

.app-confirm-dialog-card h2 {
  margin: 0;
  font-size: 17px;
  font-weight: 900;
  line-height: 26px;
}

.app-confirm-dialog-card p {
  margin: 18px 2px 20px;
  color: var(--color-text-muted);
  font-size: 14px;
  font-weight: 500;
  line-height: 24px;
  white-space: pre-line;
}

.app-confirm-dialog-card__option {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  margin: -8px 0 18px;
  color: var(--color-text-muted);
  font-size: 12px;
}

.app-confirm-dialog-card__option input {
  position: absolute;
  opacity: 0;
}

.app-confirm-dialog-card__option i {
  display: grid;
  width: 18px;
  height: 18px;
  border: 1px solid var(--color-border-strong);
  border-radius: 5px;
  color: transparent;
  font-style: normal;
  place-items: center;
}

.app-confirm-dialog-card__option input:checked + i {
  border-color: transparent;
  background: var(--gradient-primary);
  color: var(--color-text);
}

.app-confirm-dialog-card__actions {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px;
}

.app-confirm-dialog-card__actions button {
  min-width: 0;
  min-height: 46px;
  padding: 0 10px;
  overflow: hidden;
  border: 0;
  border-radius: 14px;
  color: var(--color-text);
  font-size: 15px;
  font-weight: 900;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.app-confirm-dialog__confirm {
  background: var(--gradient-primary);
}

.app-confirm-dialog__cancel {
  background: var(--color-message-confirm-cancel);
}

.app-confirm-dialog-enter-active,
.app-confirm-dialog-leave-active {
  transition: opacity 180ms ease-out;
}

.app-confirm-dialog-enter-active .app-confirm-dialog-card,
.app-confirm-dialog-leave-active .app-confirm-dialog-card {
  transition: transform 180ms cubic-bezier(0.2, 0.8, 0.2, 1);
}

.app-confirm-dialog-enter-from,
.app-confirm-dialog-leave-to {
  opacity: 0;
}

.app-confirm-dialog-enter-from .app-confirm-dialog-card,
.app-confirm-dialog-leave-to .app-confirm-dialog-card {
  transform: scale(0.96);
}

@media (prefers-reduced-motion: reduce) {
  .app-confirm-dialog-enter-active,
  .app-confirm-dialog-leave-active,
  .app-confirm-dialog-enter-active .app-confirm-dialog-card,
  .app-confirm-dialog-leave-active .app-confirm-dialog-card {
    transition-duration: 1ms;
  }
}
</style>

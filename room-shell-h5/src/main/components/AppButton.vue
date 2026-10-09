<script setup lang="ts">
withDefaults(
  defineProps<{
    block?: boolean
    disabled?: boolean
    loading?: boolean
    loadingText?: string
    size?: 'large' | 'medium' | 'small'
    tone?: 'danger' | 'ghost' | 'primary' | 'secondary'
    type?: 'button' | 'submit'
  }>(),
  {
    block: false,
    disabled: false,
    loading: false,
    loadingText: 'Please wait…',
    size: 'medium',
    tone: 'primary',
    type: 'button',
  },
)

defineEmits<{ click: [event: MouseEvent] }>()
</script>

<template>
  <button
    class="app-button"
    :class="[`app-button--${tone}`, `app-button--${size}`, { 'app-button--block': block }]"
    :aria-busy="loading"
    :disabled="disabled || loading"
    :type="type"
    @click="$emit('click', $event)"
  >
    <AppLoading v-if="loading" />
    <span>{{ loading ? loadingText : undefined }}</span>
    <slot v-if="!loading" />
  </button>
</template>

<style scoped lang="less">
.app-button {
  display: inline-flex;
  min-width: 92px;
  min-height: 44px;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 0 20px;
  border: 1px solid transparent;
  border-radius: 999px;
  font-weight: 650;
  letter-spacing: -0.01em;
  transition:
    transform 160ms,
    opacity 160ms,
    background 160ms;

  // &:active:not(:disabled) {
  //   transform: scale(0.975);
  // }

  &:disabled {
    cursor: default;
    opacity: 0.48;
  }
}

.app-button--block {
  width: 100%;
}

.app-button--large {
  min-height: 52px;
  font-size: 17px;
}

.app-button--small {
  min-width: 68px;
  min-height: 36px;
  padding-inline: 16px;
  font-size: 13px;
}

.app-button--primary {
  background: var(--color-primary);
  color: var(--color-on-primary);
  box-shadow: 0 8px 20px color-mix(in srgb, var(--color-primary) 24%, transparent);
}

.app-button--secondary {
  background: color-mix(in srgb, var(--color-primary) 12%, var(--color-surface));
  color: var(--color-primary);
}

.app-button--ghost {
  border-color: var(--color-border);
  background: var(--color-surface);
  color: var(--color-text);
}

.app-button--danger {
  background: var(--color-danger);
  color: var(--color-on-dark);
}

.app-button__spinner {
  color: currentColor;
}
</style>

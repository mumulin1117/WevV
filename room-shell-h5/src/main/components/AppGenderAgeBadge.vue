<script setup lang="ts">
import { computed } from 'vue'
import { useI18n } from 'vue-i18n'
import { publicAsset } from '@/core/media/public-asset'

const props = withDefaults(
  defineProps<{
    age?: number | string | null
    class?: string
    gender?: number | string | null
  }>(),
  {
    age: 0,
    class: '',
    gender: '',
  },
)

const { t } = useI18n()

/** 兼容各领域已经归一化的字符串和接口数字枚举。 */
const normalizedGender = computed<'female' | 'male' | ''>(() => {
  const value = String(props.gender ?? '')
    .trim()
    .toLowerCase()
  if (value === 'female' || value === '2') return 'female'
  if (value === 'male' || value === '1') return 'male'
  return ''
})

const displayAge = computed(() => {
  const age = Number(props.age || 0)
  return Number.isFinite(age) && age > 0 ? age : 0
})

const accessibleLabel = computed(() => {
  const age = t('common.ageLabel', { age: displayAge.value })
  if (normalizedGender.value === 'female') return `${t('common.female')}, ${age}`
  if (normalizedGender.value === 'male') return `${t('common.male')}, ${age}`
  return age
})
</script>

<template>
  <div
    class="app-gender-age-badge"
    :class="[props.class, normalizedGender === 'female' ? 'is-female' : 'is-male']"
    role="img"
    :aria-label="accessibleLabel"
  >
    <img
      v-if="normalizedGender === 'female'"
      :src="publicAsset('common/gender-female.png')"
      alt=""
      aria-hidden="true"
    />
    <img
      v-else-if="normalizedGender === 'male'"
      :src="publicAsset('common/gender-male.png')"
      alt=""
      aria-hidden="true"
    />
    <span aria-hidden="true">{{ displayAge }}</span>
  </div>
</template>

<style scoped lang="less">
.app-gender-age-badge {
  display: inline-flex;
  width: fit-content;
  height: 14px;
  flex: none;
  align-items: center;
  gap: 3px;
  padding: 0 5px;
  border-radius: 8px;
  background: var(--gradient-gender-male);
  color: var(--color-on-badge);
  font-family:
    'TT Norms Pro',
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    sans-serif;
  font-size: 10px;
  font-weight: 700;
  line-height: 1;
  white-space: nowrap;
}

.app-gender-age-badge.is-female {
  background: var(--gradient-gender-female);
}

.app-gender-age-badge img {
  display: block;
  width: 10px;
  height: 10px;
  flex: 0 0 10px;
}
</style>

<script setup lang="ts">
import { publicAsset } from '@/core/media/public-asset'
import AppIcon from '@/main/components/AppIcon.vue'
import AppImage from '@/main/components/AppImage.vue'
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import type { LiveWishItem } from '../live-interaction-contracts'

const props = withDefaults(
  defineProps<{
    guideVisible?: boolean
    items: readonly LiveWishItem[]
    pk?: boolean
  }>(),
  { guideVisible: false, pk: false },
)
const emit = defineEmits<{
  select: [giftId: string]
}>()
const { t } = useI18n()
const activeIndex = ref(0)

function change(index: number): void {
  activeIndex.value = index
}

function progress(wish: LiveWishItem): number {
  return Math.min(100, wish.target > 0 ? (wish.completed / wish.target) * 100 : 0)
}

function completed(wish: LiveWishItem): boolean {
  return wish.target > 0 && wish.completed >= wish.target
}

function selectGuideGift(): void {
  const active = props.items[activeIndex.value]
  const wish =
    (active && !completed(active) ? active : undefined) ??
    props.items.find((item) => !completed(item)) ??
    active ??
    props.items[0]
  if (wish) emit('select', wish.giftId)
}
</script>

<template>
  <aside
    v-if="items.length"
    class="legacy-wishlist-cluster"
    :class="{ 'is-pk': pk }"
    :aria-label="t('room.wishlist')"
  >
    <div class="legacy-wishlist">
      <VanSwipe
        :autoplay="items.length > 1 ? 3000 : 0"
        :loop="items.length > 1"
        :show-indicators="false"
        @change="change"
      >
        <VanSwipeItem v-for="wish in items" :key="wish.giftId">
          <button class="legacy-wishlist__slide" type="button" @click="emit('select', wish.giftId)">
            <strong>{{ t('room.wishlist') }}</strong>
            <span class="legacy-wishlist__main">
              <AppImage
                :alt="wish.name"
                fit="contain"
                :height="pk ? 30 : 34"
                :lazy="false"
                :src="wish.iconUrl"
                :width="pk ? 30 : 34"
              />
              <span class="legacy-wishlist__meter">
                <small>{{ wish.completed }}/{{ wish.target }}</small>
                <span class="legacy-wishlist__progress">
                  <i :style="{ width: `${progress(wish)}%` }" />
                </span>
              </span>
            </span>
            <span class="legacy-wishlist__price">
              <img alt="" :src="publicAsset('common/diamond.png')" />
              <span>{{ wish.price.toLocaleString('en') }}</span>
              <em v-if="completed(wish)">
                <AppIcon name="check" :size="9" />
                {{ t('room.wishlistComplete') }}
              </em>
            </span>
          </button>
        </VanSwipeItem>
      </VanSwipe>
      <span v-if="items.length > 1" class="legacy-wishlist__indicators" aria-hidden="true">
        <i v-for="(_, index) in items" :key="index" :class="{ active: index === activeIndex }" />
      </span>
    </div>
    <button
      v-if="guideVisible"
      class="legacy-wishlist-guide"
      type="button"
      @click="selectGuideGift"
    >
      {{ t('room.helpHerFulfillWish') }}
    </button>
  </aside>
</template>

<style scoped lang="less">
.legacy-wishlist-cluster {
  position: absolute;
  top: calc(var(--safe-top) + 60px);
  left: 16px;
  z-index: 11;
  display: flex;
  align-items: flex-start;
  flex-direction: column;
}

.legacy-wishlist-cluster.is-pk {
  top: calc(var(--safe-top) + 96px);
}

.legacy-wishlist,
.legacy-wishlist :deep(.van-swipe),
.legacy-wishlist :deep(.van-swipe__track),
.legacy-wishlist :deep(.van-swipe-item),
.legacy-wishlist__slide {
  width: 108px;
  height: 101px;
}

.legacy-wishlist {
  position: relative;
  overflow: hidden;
  border-radius: 8px;
  color: var(--color-on-dark);
}

.legacy-wishlist-cluster.is-pk .legacy-wishlist,
.legacy-wishlist-cluster.is-pk .legacy-wishlist :deep(.van-swipe),
.legacy-wishlist-cluster.is-pk .legacy-wishlist :deep(.van-swipe__track),
.legacy-wishlist-cluster.is-pk .legacy-wishlist :deep(.van-swipe-item),
.legacy-wishlist-cluster.is-pk .legacy-wishlist__slide {
  width: 90px;
  height: 90px;
}

.legacy-wishlist__slide {
  display: flex;
  box-sizing: border-box;
  align-items: stretch;
  flex-direction: column;
  gap: 4px;
  padding: 7px 8px 8px;
  border: 0;
  background: var(--color-scrim-soft);
  color: var(--color-on-dark);
  text-align: left;
  backdrop-filter: blur(2px);
  touch-action: manipulation;
}

.legacy-wishlist__slide strong {
  overflow: hidden;
  flex: 0 0 14px;
  font-size: 12px;
  line-height: 14px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.legacy-wishlist__main {
  display: flex;
  min-width: 0;
  flex: 1;
  align-items: center;
  gap: 5px;
}

.legacy-wishlist__meter {
  display: flex;
  min-width: 0;
  flex: 1;
  flex-direction: column;
  gap: 5px;
}

.legacy-wishlist__meter small {
  color: var(--color-on-dark);
  font-size: 10px;
  line-height: 11px;
  white-space: nowrap;
}

.legacy-wishlist__progress {
  position: relative;
  display: block;
  width: 100%;
  height: 4px;
  overflow: hidden;
  border-radius: 21px;
  background: var(--color-on-dark-border-strong);
}

.legacy-wishlist__progress i {
  position: absolute;
  bottom: 0;
  left: 0;
  height: 100%;
  border-radius: inherit;
  background: var(--color-primary);
  transition: width 1s ease;
}

.legacy-wishlist__price {
  display: flex;
  min-width: 0;
  flex: 0 0 14px;
  align-items: center;
  gap: 2px;
  font-size: 10px;
  line-height: 12px;
}

.legacy-wishlist__price > img {
  width: 12px;
  height: 12px;
  flex: 0 0 auto;
  object-fit: contain;
}

.legacy-wishlist__price em {
  display: inline-flex;
  min-width: 0;
  align-items: center;
  gap: 1px;
  margin-left: auto;
  color: var(--color-success);
  font-size: 8px;
  font-style: normal;
  white-space: nowrap;
}

.legacy-wishlist__indicators {
  position: absolute;
  right: 0;
  bottom: 3px;
  left: 0;
  z-index: 2;
  display: flex;
  justify-content: center;
  gap: 3px;
  pointer-events: none;
}

.legacy-wishlist__indicators i {
  width: 4px;
  height: 4px;
  border-radius: 50%;
  background: var(--color-on-dark-subtle);
}

.legacy-wishlist__indicators i.active {
  background: var(--color-on-dark);
}

.legacy-wishlist-cluster.is-pk .legacy-wishlist__slide {
  gap: 2px;
  padding: 5px 6px 7px;
}

.legacy-wishlist-cluster.is-pk .legacy-wishlist__slide strong {
  font-size: 11px;
  line-height: 13px;
}

.legacy-wishlist-cluster.is-pk .legacy-wishlist__meter {
  gap: 3px;
}

.legacy-wishlist-cluster.is-pk .legacy-wishlist__meter small,
.legacy-wishlist-cluster.is-pk .legacy-wishlist__price {
  font-size: 9px;
}

.legacy-wishlist-guide {
  position: relative;
  max-width: 160px;
  min-height: 36px;
  margin-top: 6px;
  padding: 10px;
  border: 0;
  border-radius: 8px;
  background: var(--gradient-primary);
  color: var(--color-on-dark);
  font-size: 12px;
  font-weight: 800;
  line-height: 12px;
  text-align: left;
  animation: wishlist-guide-in 260ms cubic-bezier(0.2, 0.8, 0.2, 1);
  touch-action: manipulation;
}

.legacy-wishlist-guide::before {
  position: absolute;
  top: -8px;
  left: 24px;
  border-right: 5px solid transparent;
  border-bottom: 8px solid var(--color-primary);
  border-left: 5px solid transparent;
  content: '';
}

@keyframes wishlist-guide-in {
  from {
    opacity: 0;
    transform: translateY(-6px);
  }

  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@media (prefers-reduced-motion: reduce) {
  .legacy-wishlist-guide,
  .legacy-wishlist__progress i {
    animation: none;
    transition: none;
  }
}
</style>

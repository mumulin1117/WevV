import { nextTick, shallowRef, toValue, watch, type MaybeRefOrGetter, type Ref } from 'vue'
import type { Swiper as SwiperInstance } from 'swiper'

export function usePartySheetPager<T extends number | string>(options: {
  active: Ref<T>
  items: MaybeRefOrGetter<readonly T[]>
  onChange?: (value: T) => void
}) {
  const swiper = shallowRef<SwiperInstance>()

  function itemIndex(value: T): number {
    return toValue(options.items).indexOf(value)
  }

  function align(value: T, speed = 220): void {
    const index = itemIndex(value)
    const instance = swiper.value
    if (index < 0 || !instance || instance.destroyed || instance.activeIndex === index) return
    instance.slideTo(index, speed)
  }

  function commit(value: T): void {
    if (options.active.value === value) return
    options.active.value = value
    options.onChange?.(value)
  }

  function select(value: T): void {
    if (itemIndex(value) < 0) return
    commit(value)
    void nextTick(() => align(value))
  }

  function setSwiper(instance: SwiperInstance): void {
    swiper.value = instance
    align(options.active.value, 0)
  }

  function handleSlideChange(instance: SwiperInstance): void {
    const items = toValue(options.items)
    const value = items[instance.activeIndex]
    if (value !== undefined) commit(value)
  }

  watch(
    () => options.active.value,
    (value) => void nextTick(() => align(value)),
  )

  return { handleSlideChange, select, setSwiper, swiper }
}

<template>
  <VanConfigProvider class="app-ui-provider" theme-vars-scope="global">
    <slot />
  </VanConfigProvider>
</template>
<style scoped>
.app-ui-provider {
  width: 100%;
  height: 100%;
}
</style>

// PostCSS 配置不会热更新，修改后需要重启开发服务。

// Vant 的定位由组合 class 提供，显式声明为根包含块，保证宽屏居中后仍跟随应用视口。
const rootContainingBlockSelectorList = [
  '.van-tabbar',
  '.van-popup',
  '.van-popup--bottom',
  '.van-popup--top',
  '.van-popup--left',
  '.van-popup--right',
]

export default {
  plugins: {
    autoprefixer: {},
    'postcss-mobile-forever': {
      appSelector: '#app',
      border: true,
      maxDisplayWidth: 600,
      rootContainingBlockSelectorList,
      viewportWidth: 375,
    },
  },
}

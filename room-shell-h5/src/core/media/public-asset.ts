import { resolveBundleUrl } from '@/core/assets/bundle-url'

/**
 * 返回已经解析到 WebApp 入口目录的公开资源地址。
 *
 * HTTP 固定从站点根目录读取，iOS `loadFileURL` 从 index.html 同级 Bundle 读取。
 * 通过运行时函数生成，避免 Vue/Vite 把 public 目录资源误当成组件相对模块导入，
 * 也避免二级 Web History 路由刷新后错误解析到 `/live/assets/...`。
 */
export function publicAsset(path: string): string {
  return resolveBundleUrl(['assets', path.replace(/^\/+|\.\.+/gu, '')].join('/'))
}

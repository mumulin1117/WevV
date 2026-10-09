const EXTERNAL_PROTOCOL = /^(?:https?:|data:|blob:|about:|social:|\/\/|#)/iu
const LOCAL_BUNDLE_PREFIX = /^(?:\.\/|\/)?(?:assets|config|local-content)\//u

/**
 * 返回 WebApp 入口目录，而不是当前前端路由目录。
 *
 * file:// 始终从 Bundle 内 index.html 所在目录取资源；HTTP 当前只支持站点根部署，
 * 与 createWebHistory('/')、Vite dev/preview 和 iOS loopback 的约定一致。这样在
 * /live/ranking 等二级路由硬刷新后，资源仍解析到 /assets，而不是 /live/assets。
 */
export function resolveBundleBaseUrl(locationHref = window.location.href): URL {
  const locationUrl = new URL(locationHref)
  return locationUrl.protocol === 'file:'
    ? new URL('./', locationUrl)
    : new URL('/', locationUrl.origin)
}

/**
 * 将 WebApp Bundle 内资源解析到当前入口目录。
 * `document.baseURI` 在 loadFileURL 与回环 HTTP 下都指向同一份 index.html。
 */
export function resolveBundleUrl(source: string): string {
  const value = source.trim()
  if (!value || EXTERNAL_PROTOCOL.test(value) || !LOCAL_BUNDLE_PREFIX.test(value)) return value
  return new URL(value.replace(/^\.?\//u, ''), resolveBundleBaseUrl()).href
}

export function isFileWebApp(): boolean {
  return window.location.protocol === 'file:'
}

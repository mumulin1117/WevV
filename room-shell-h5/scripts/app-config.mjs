import { readFile } from 'node:fs/promises'
import path from 'node:path'

const safeName = /^[A-Za-z_][\w.-]{0,63}$/u
const color = /^#[\da-f]{6}$/iu
const utf8Length = (value) => Buffer.byteLength(value ?? '', 'utf8')

export function extractAppConfig(source) {
  const startMarker = '/*__APP_CONFIG_START__*/'
  const endMarker = '/*__APP_CONFIG_END__*/'
  const start = source.indexOf(startMarker)
  const end = source.indexOf(endMarker, start + startMarker.length)
  if (start < 0 || end < 0) throw new Error('app-config.js 缺少严格 JSON 标记')
  return JSON.parse(source.slice(start + startMarker.length, end))
}

export function validateAppConfig(config) {
  const errors = []
  if (config?.schemaVersion !== 1) errors.push('schemaVersion 必须为 1')
  for (const key of ['buildId', 'minimumHostVersion'])
    if (typeof config?.build?.[key] !== 'string' || !config.build[key].trim())
      errors.push(`build.${key} 不能为空`)
  if (typeof config?.app?.appId !== 'string' || !config.app.appId.trim())
    errors.push('app.appId 不能为空')
  if (typeof config?.app?.documentTitle !== 'string' || !config.app.documentTitle.trim())
    errors.push('app.documentTitle 不能为空')
  if (typeof config?.app?.defaultLocale !== 'string' || !config.app.defaultLocale.trim())
    errors.push('app.defaultLocale 不能为空')
  try {
    const url = new URL(config?.api?.baseUrl)
    if (!['http:', 'https:'].includes(url.protocol)) errors.push('api.baseUrl 必须使用 HTTP(S)')
  } catch {
    errors.push('api.baseUrl 不是有效 URL')
  }
  if (utf8Length(config?.api?.encryptionKey) !== 16) errors.push('api.encryptionKey 必须为 16 字节')
  if (utf8Length(config?.api?.encryptionIv) !== 16) errors.push('api.encryptionIv 必须为 16 字节')
  if (
    !Number.isInteger(config?.api?.timeoutMs) ||
    config.api.timeoutMs < 1000 ||
    config.api.timeoutMs > 60000
  )
    errors.push('api.timeoutMs 必须为 1000 到 60000 的整数')
  for (const key of ['primary', 'secondary', 'accent'])
    if (!color.test(config?.theme?.[key] ?? '')) errors.push(`theme.${key} 必须是 6 位十六进制颜色`)
  const names = [
    config?.bridge?.handler,
    config?.bridge?.receiver,
    config?.bridge?.commands?.closeRoom,
    config?.bridge?.commands?.openRecharge,
    config?.bridge?.events?.rechargeSucceeded,
  ]
  if (names.some((name) => typeof name !== 'string' || !safeName.test(name)))
    errors.push('Bridge 名称必须是长度不超过 64 的安全 ASCII 名称')
  if (typeof config?.debug?.vConsoleEnabled !== 'boolean')
    errors.push('debug.vConsoleEnabled 必须为布尔值')
  const expectedTopLevel = ['api', 'app', 'bridge', 'build', 'debug', 'schemaVersion', 'theme']
  if (JSON.stringify(Object.keys(config ?? {}).sort()) !== JSON.stringify(expectedTopLevel.sort()))
    errors.push('只允许文档规定的顶层配置')
  if (errors.length) throw new Error(errors.join('；'))
  return config
}

export async function loadAndValidateAppConfig(webRoot) {
  const source = await readFile(path.join(webRoot, 'config', 'app-config.js'), 'utf8')
  return validateAppConfig(extractAppConfig(source))
}

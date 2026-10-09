import path from 'node:path'
import process from 'node:process'
import { loadAndValidateAppConfig } from './app-config.mjs'

try {
  const config = await loadAndValidateAppConfig(path.join(process.cwd(), 'public'))
  console.log(`App 配置校验通过：${config.app.appId} -> ${config.api.baseUrl}`)
} catch (error) {
  console.error(`App 配置校验失败：${error.message}`)
  process.exit(1)
}

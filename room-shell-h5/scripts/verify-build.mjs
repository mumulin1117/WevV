import { readFile, readdir } from 'node:fs/promises'
import path from 'node:path'
import process from 'node:process'
import { loadAndValidateAppConfig } from './app-config.mjs'
import {
  createBundleInventory,
  inspectEntryGraph,
  isHostEditableFile,
} from './bundle-integrity.mjs'

const dist = path.join(process.cwd(), 'dist')
const failures = []
const html = await readFile(path.join(dist, 'index.html'), 'utf8')
const files = await readdir(dist, { recursive: true })

try {
  await loadAndValidateAppConfig(dist)
} catch (error) {
  failures.push(`app-config.js 无效：${error.message}`)
}

if (!html.includes('./config/app-config.js')) failures.push('入口未加载外置 app-config.js')
if (!/<base\s+href="\.\/index\.html"\s*\/?>/iu.test(html))
  failures.push('入口缺少 file:// Hash 路由所需的相对 base')
if (!/<script\s+type="module">/iu.test(html)) failures.push('业务 JavaScript 未内联')
if (/<script\s+type="module"[^>]+src=/iu.test(html)) failures.push('入口仍依赖外置业务 JavaScript')
if (/<link\s+rel="stylesheet"/iu.test(html)) failures.push('入口仍依赖外置业务样式')
if (files.some((file) => file.endsWith('.map'))) failures.push('产物包含 source map')
const allowedConfigFiles = new Set(['config/app-config.js', 'config/app-config.schema.json'])
for (const file of files.filter((file) => file.startsWith('config/')))
  if (!allowedConfigFiles.has(file)) failures.push(`配置目录包含意外文件：${file}`)
if (files.includes('module-inventory.txt')) failures.push('产物包含构建诊断文件')

const allowedJavaScript = new Set([
  'assets/media-worker.js',
  'assets/rtc.js',
  'assets/vconsole.js',
  'config/app-config.js',
])
for (const file of files.filter((file) => file.endsWith('.js')))
  if (!allowedJavaScript.has(file)) failures.push(`存在意外 JavaScript 分包：${file}`)

for (const required of [
  'NATIVE_INTEGRATION.md',
  'assets/common/app-loading.svg',
  'assets/media-worker.js',
  'assets/rtc.js',
  'config/app-config.js',
  'config/app-config.schema.json',
  'index.html',
  'webapp-manifest.json',
])
  if (!files.includes(required)) failures.push(`缺少必要文件：${required}`)

const graph = await inspectEntryGraph(dist, 'index.html')
for (const missing of graph.missing) failures.push(`缺少本地资源：${missing}`)
for (const escaped of graph.escaped) failures.push(`资源越出 dist：${escaped}`)

if (files.includes('webapp-manifest.json')) {
  const manifest = JSON.parse(await readFile(path.join(dist, 'webapp-manifest.json'), 'utf8'))
  const inventory = await createBundleInventory(dist)
  inventory.delete('webapp-manifest.json')
  const editable = [...inventory.keys()].filter(isHostEditableFile).sort()
  if (JSON.stringify([...manifest.editableFiles].sort()) !== JSON.stringify(editable))
    failures.push('WebApp 清单的可编辑文件集合不正确')
}

if (failures.length) {
  failures.forEach((failure) => console.error(`Build verification failed: ${failure}`))
  process.exitCode = 1
} else {
  console.log(
    `Build verification passed: ${graph.files.length} 个本地依赖，单配置、双房间路由产物完整。`,
  )
}

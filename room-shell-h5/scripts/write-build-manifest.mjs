import { readdir, rm, writeFile } from 'node:fs/promises'
import path from 'node:path'
import process from 'node:process'
import { createBundleInventory, isHostEditableFile } from './bundle-integrity.mjs'

const dist = path.join(process.cwd(), 'dist')

async function removeMacMetadata(directory) {
  const entries = await readdir(directory, { withFileTypes: true })
  for (const entry of entries) {
    const absolutePath = path.join(directory, entry.name)
    if (entry.name === '.DS_Store') {
      await rm(absolutePath, { force: true })
    } else if (entry.isDirectory()) {
      await removeMacMetadata(absolutePath)
    }
  }
}

await removeMacMetadata(dist)
const inventory = await createBundleInventory(dist)
inventory.delete('webapp-manifest.json')

const manifest = {
  schemaVersion: 2,
  editableFiles: [...inventory.keys()].filter(isHostEditableFile),
  managedFiles: [...inventory.entries()]
    .filter(([file]) => !isHostEditableFile(file))
    .map(([file, metadata]) => ({ file, ...metadata })),
}

await writeFile(
  path.join(dist, 'webapp-manifest.json'),
  `${JSON.stringify(manifest, null, 2)}\n`,
  'utf8',
)
console.log(
  `已生成 WebApp 清单：${manifest.editableFiles.length} 个宿主可编辑文件，${manifest.managedFiles.length} 个 H5 管理文件。`,
)

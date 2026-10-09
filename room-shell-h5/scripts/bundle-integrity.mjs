import { createHash } from 'node:crypto'
import { readFile, readdir, stat } from 'node:fs/promises'
import path from 'node:path'

const externalProtocol = /^(?:[a-z][a-z\d+.-]*:|\/\/|#)/iu

export function isHostEditableFile(file) {
  return file === 'config/app-config.js'
}

async function walkFiles(root, directory = root) {
  const entries = await readdir(directory, { withFileTypes: true })
  const files = []

  for (const entry of entries) {
    if (entry.name === '.DS_Store') continue
    const absolutePath = path.join(directory, entry.name)
    if (entry.isDirectory()) files.push(...(await walkFiles(root, absolutePath)))
    else if (entry.isFile()) files.push(path.relative(root, absolutePath).split(path.sep).join('/'))
  }

  return files.sort()
}

async function digestFile(filePath) {
  const contents = await readFile(filePath)
  return createHash('sha256').update(contents).digest('hex')
}

export async function createBundleInventory(root) {
  const files = await walkFiles(root)
  const inventory = new Map()

  for (const relativePath of files) {
    const absolutePath = path.join(root, relativePath)
    const metadata = await stat(absolutePath)
    inventory.set(relativePath, {
      bytes: metadata.size,
      sha256: await digestFile(absolutePath),
    })
  }

  return inventory
}

function normalizeReference(sourcePath, reference) {
  const cleanReference = reference.trim().split(/[?#]/u, 1)[0]
  if (
    !cleanReference ||
    cleanReference === '.' ||
    cleanReference === './' ||
    cleanReference.endsWith('/') ||
    externalProtocol.test(cleanReference)
  )
    return null

  if (cleanReference.startsWith('/')) return path.posix.normalize(cleanReference.slice(1))
  if (/^(?:assets|config|local-content)\//u.test(cleanReference))
    return path.posix.normalize(cleanReference)

  const sourceDirectory = path.posix.dirname(sourcePath)
  return path.posix.normalize(path.posix.join(sourceDirectory, cleanReference))
}

function referencesFromSource(sourcePath, source) {
  const references = new Set()
  const extension = path.posix.extname(sourcePath)
  const patterns = []
  const localBundlePath =
    /["'`]((?:\.{1,2}\/)?(?:assets|config|local-content)\/[^"'`?#)\s]+)["'`]/gu

  if (extension === '.html') {
    patterns.push(/\b(?:src|href)=["']([^"']+)["']/giu, localBundlePath)
  } else if (extension === '.js') {
    patterns.push(localBundlePath)
  } else if (extension === '.css') {
    patterns.push(/\burl\(\s*["']?([^"')]+)["']?\s*\)/gu)
  }

  for (const pattern of patterns) {
    for (const match of source.matchAll(pattern)) {
      const normalized = normalizeReference(sourcePath, match[1])
      if (normalized) references.add(normalized)
    }
  }

  return references
}

export async function inspectEntryGraph(root, entryPath) {
  const availableFiles = new Set(await walkFiles(root))
  const pending = [entryPath]
  const visited = new Set()
  const missing = []
  const escaped = []

  while (pending.length > 0) {
    const sourcePath = pending.shift()
    if (!sourcePath || visited.has(sourcePath)) continue
    visited.add(sourcePath)

    if (sourcePath.startsWith('../') || path.posix.isAbsolute(sourcePath)) {
      escaped.push(sourcePath)
      continue
    }
    if (!availableFiles.has(sourcePath)) {
      missing.push(sourcePath)
      continue
    }

    if (!/\.(?:html|js|css)$/u.test(sourcePath)) continue

    const source = await readFile(path.join(root, sourcePath), 'utf8')
    for (const reference of referencesFromSource(sourcePath, source)) {
      if (!visited.has(reference)) pending.push(reference)
    }
  }

  return {
    escaped: [...new Set(escaped)].sort(),
    files: [...visited].sort(),
    missing: [...new Set(missing)].sort(),
  }
}

export function compareInventories(expected, actual) {
  const failures = []
  const expectedFiles = [...expected.keys()].sort()
  const actualFiles = [...actual.keys()].sort()

  for (const file of expectedFiles) {
    if (!actual.has(file)) {
      failures.push(`缺少文件：${file}`)
      continue
    }
    const expectedEntry = expected.get(file)
    const actualEntry = actual.get(file)
    if (expectedEntry.bytes !== actualEntry.bytes || expectedEntry.sha256 !== actualEntry.sha256) {
      failures.push(`文件内容不一致：${file}`)
    }
  }

  for (const file of actualFiles) {
    if (!expected.has(file)) failures.push(`存在额外文件：${file}`)
  }

  return failures
}

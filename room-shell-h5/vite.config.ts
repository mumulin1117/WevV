import { readFileSync } from 'node:fs'
import { fileURLToPath, URL } from 'node:url'
import vue from '@vitejs/plugin-vue'
import { VantResolver } from '@vant/auto-import-resolver'
import Components from 'unplugin-vue-components/vite'
import type { Plugin } from 'vite'
import { defineConfig } from 'vitest/config'
import { injectInlineScriptRuntimes } from './scripts/inline-script-runtimes'
import {
  createJavascriptRuntimeDevMiddleware,
  createRtcSdkDevMiddleware,
} from './scripts/rtc-sdk-dev-middleware'

function escapeRegExp(value: string): string {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
}

const rtcSdkBrowserPath = fileURLToPath(
  new URL('./node_modules/agora-rtc-sdk-ng/AgoraRTC_N-production.js', import.meta.url),
)
const mediaWorkerModulePath = fileURLToPath(
  new URL('./src/features/media/media-worker.ts', import.meta.url),
)
const vConsoleSource = readFileSync(
  fileURLToPath(new URL('./node_modules/vconsole/dist/vconsole.min.js', import.meta.url)),
  'utf8',
)
const nimSdkSource = readFileSync(
  fileURLToPath(
    new URL('./node_modules/nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK.js', import.meta.url),
  ),
  'utf8',
)
const nimChatroomSdkSource = readFileSync(
  fileURLToPath(
    new URL('./node_modules/nim-web-sdk-ng/dist/v2/CHATROOM_BROWSER_SDK.js', import.meta.url),
  ),
  'utf8',
)

function inlineImSdkRuntime(): Plugin {
  return {
    name: 'social-inline-im-sdk-runtime',
    transformIndexHtml(html) {
      return injectInlineScriptRuntimes(html, [
        { name: 'nim', source: nimSdkSource },
        { name: 'nim-chatroom', source: nimChatroomSdkSource },
      ])
    },
  }
}

function serveRtcSdkModule(): Plugin {
  return {
    name: 'social-serve-rtc-sdk-module',
    apply: 'serve',
    configureServer(server) {
      server.middlewares.use(createRtcSdkDevMiddleware(readFileSync(rtcSdkBrowserPath, 'utf8')))
    },
  }
}

function copyRtcSdkModule(): Plugin {
  return {
    name: 'social-copy-rtc-sdk-module',
    apply: 'build',
    generateBundle() {
      this.emitFile({
        fileName: 'assets/rtc.js',
        source: readFileSync(rtcSdkBrowserPath, 'utf8'),
        type: 'asset',
      })
    },
  }
}

function serveDiagnosticRuntime(): Plugin {
  return {
    name: 'social-serve-diagnostic-runtime',
    apply: 'serve',
    configureServer(server) {
      server.middlewares.use(
        createJavascriptRuntimeDevMiddleware('/assets/vconsole.js', vConsoleSource),
      )
    },
  }
}

function copyDiagnosticRuntime(): Plugin {
  return {
    name: 'social-copy-diagnostic-runtime',
    apply: 'build',
    generateBundle() {
      this.emitFile({
        fileName: 'assets/vconsole.js',
        source: vConsoleSource,
        type: 'asset',
      })
    },
  }
}

function emitMediaWorker(): Plugin {
  return {
    name: 'social-emit-media-worker',
    apply: 'build',
    buildStart() {
      this.emitFile({
        fileName: 'assets/media-worker.js',
        id: mediaWorkerModulePath,
        type: 'chunk',
      })
    },
  }
}

/**
 * Keep the high-frequency application payload replaceable as one HTML file.
 * RTC and the media worker remain external because they have independent
 * loading and execution lifecycles. Yunxin stays in inert inline script blocks
 * so replacing index.html still updates all non-RTC JavaScript; its SDK is only
 * compiled and executed after an authenticated account runtime starts.
 */
function inlineApplicationEntry(): Plugin {
  return {
    name: 'social-inline-application-entry',
    apply: 'build',
    enforce: 'post',
    generateBundle(_, bundle) {
      const htmlAsset = bundle['index.html']
      if (!htmlAsset || htmlAsset.type !== 'asset' || typeof htmlAsset.source !== 'string') return

      let html = htmlAsset.source
      for (const [fileName, output] of Object.entries(bundle)) {
        const escapedFileName = escapeRegExp(fileName)
        if (output.type === 'chunk' && output.isEntry) {
          if (fileName === 'assets/media-worker.js') continue
          const entryTag = new RegExp(
            `<script\\s+type="module"\\s+crossorigin\\s+src="\\./${escapedFileName}"\\s*></script>`,
            'u',
          )
          if (!entryTag.test(html))
            throw new Error(`Cannot find the application entry tag for ${fileName}.`)
          // Vite resolves dynamic-import preload markers in a later bundle hook.
          // This entry is removed and embedded here, so the RTC-only import has
          // no sibling dependencies to preload and must receive an explicit list.
          const entryCode = output.code.replaceAll('__VITE_PRELOAD__', '[]')
          html = html.replace(entryTag, () => `<script type="module">\n${entryCode}\n</script>`)
          delete bundle[fileName]
          continue
        }

        if (
          output.type === 'asset' &&
          fileName.endsWith('.css') &&
          typeof output.source === 'string'
        ) {
          const stylesheetTag = new RegExp(
            `<link\\s+rel="stylesheet"\\s+crossorigin\\s+href="\\./${escapedFileName}"\\s*>`,
            'u',
          )
          if (!stylesheetTag.test(html))
            throw new Error(`Cannot find the application stylesheet tag for ${fileName}.`)
          html = html.replace(stylesheetTag, () => `<style>\n${output.source}\n</style>`)
          delete bundle[fileName]
        }
      }
      htmlAsset.source = html
    },
  }
}

export default defineConfig({
  base: './',
  plugins: [
    vue(),
    Components({
      dts: 'src/types/components.d.ts',
      resolvers: [VantResolver({ importStyle: true })],
    }),
    serveRtcSdkModule(),
    copyRtcSdkModule(),
    serveDiagnosticRuntime(),
    copyDiagnosticRuntime(),
    emitMediaWorker(),
    inlineImSdkRuntime(),
    inlineApplicationEntry(),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
    },
  },
  server: {
    port: 3200,
  },
  test: { environment: 'node', setupFiles: ['./src/test/setup.ts'] },
  build: {
    assetsInlineLimit: 0,
    cssCodeSplit: false,
    chunkSizeWarningLimit: 1600,
    outDir: 'dist',
    emptyOutDir: true,
    sourcemap: false,
    target: 'es2022',
    rollupOptions: {
      input: {
        main: fileURLToPath(new URL('./index.html', import.meta.url)),
      },
      output: {
        codeSplitting: false,
        // The temporary root entry makes all generated relative asset URLs
        // remain correct after the code is embedded into root index.html.
        entryFileNames: 'app.js',
        chunkFileNames: 'assets/[name].js',
        assetFileNames: (asset) =>
          asset.names.some((name) => name.endsWith('.css'))
            ? 'app.css'
            : 'assets/[name]-[hash][extname]',
      },
    },
  },
  worker: {
    format: 'es',
    rollupOptions: {
      output: {
        entryFileNames: 'assets/media-worker.js',
      },
    },
  },
})

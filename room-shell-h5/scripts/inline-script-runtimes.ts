interface InlineRuntime {
  name: string
  source: string
}

export function injectInlineScriptRuntimes(html: string, runtimes: InlineRuntime[]): string {
  const closingBody = '</body>'
  if (!html.includes(closingBody)) throw new Error('The HTML entry has no closing body tag.')

  const scripts = runtimes
    .map(({ name, source }) => {
      if (/<\/script/iu.test(source))
        throw new Error(`The ${name} runtime cannot be embedded safely in HTML.`)
      return `<script type="application/x-social-runtime" data-runtime="${name}">${source}</script>`
    })
    .join('\n')

  // A string replacement would interpret `$&` in minified vendor code as the
  // matched `</body>` text and corrupt the JavaScript. The callback preserves
  // the SDK byte-for-byte.
  // These inert script blocks keep index.html self-contained while avoiding
  // SDK compilation and execution until a chatroom is actually opened.
  return html.replace(closingBody, () => `${scripts}\n${closingBody}`)
}

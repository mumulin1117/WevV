import type { IncomingMessage, ServerResponse } from 'node:http'

export function createJavascriptRuntimeDevMiddleware(path: string, source: string) {
  return (request: IncomingMessage, response: ServerResponse, next: () => void): void => {
    const pathname = request.url?.split('?', 1)[0]
    if (pathname !== path || !['GET', 'HEAD'].includes(request.method ?? 'GET')) {
      next()
      return
    }

    response.statusCode = 200
    response.setHeader('Cache-Control', 'no-store')
    response.setHeader('Content-Length', Buffer.byteLength(source))
    response.setHeader('Content-Type', 'text/javascript; charset=utf-8')
    response.end(request.method === 'HEAD' ? undefined : source)
  }
}

export function createRtcSdkDevMiddleware(source: string) {
  return createJavascriptRuntimeDevMiddleware('/assets/rtc.js', source)
}

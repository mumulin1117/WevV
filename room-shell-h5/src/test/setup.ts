let currentUrl = new URL('https://room.test/index.html')
const locationMock = {} as Location
Object.defineProperties(locationMock, {
  hash: {
    get: () => currentUrl.hash,
    set: (value: string) => {
      currentUrl.hash = value
    },
  },
  pathname: { get: () => currentUrl.pathname },
  search: { get: () => currentUrl.search },
})
const historyMock = {
  replaceState: (_data: unknown, _unused: string, url?: string | URL | null) => {
    if (url !== undefined && url !== null) currentUrl = new URL(String(url), currentUrl)
  },
} as History
const windowMock = new EventTarget() as EventTarget & Record<string, unknown>
Object.defineProperty(windowMock, 'location', { get: () => locationMock })

Object.assign(globalThis, {
  history: historyMock,
  location: locationMock,
  window: windowMock,
})

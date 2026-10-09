export function readLocalStorage(key: string): string | null {
  try {
    return window.localStorage.getItem(key)
  } catch {
    return null
  }
}

export function writeLocalStorage(key: string, value: string): boolean {
  try {
    window.localStorage.setItem(key, value)
    return true
  } catch {
    return false
  }
}

export function removeLocalStorage(key: string): void {
  try {
    window.localStorage.removeItem(key)
  } catch {
    // Storage can be unavailable in private or capacity-constrained WebViews.
  }
}

export function readLocalJson<T>(key: string, validate: (value: unknown) => value is T): T | null {
  const raw = readLocalStorage(key)
  if (!raw) return null
  try {
    const value: unknown = JSON.parse(raw)
    if (validate(value)) return value
  } catch {
    // Invalid records are removed below so every following read stays cheap.
  }
  removeLocalStorage(key)
  return null
}

export function writeLocalJson(key: string, value: unknown): boolean {
  try {
    return writeLocalStorage(key, JSON.stringify(value))
  } catch {
    return false
  }
}

const encoder = new TextEncoder()
const decoder = new TextDecoder()

function requireWebCrypto(): SubtleCrypto {
  if (!globalThis.crypto?.subtle)
    throw new Error('This WebView does not support the required Web Crypto API.')
  return globalThis.crypto.subtle
}

function encodeFixedLength(value: string, label: string): Uint8Array<ArrayBuffer> {
  const bytes = encoder.encode(value)
  if (bytes.byteLength !== 16) throw new Error(`${label} must contain exactly 16 UTF-8 bytes.`)
  return bytes
}

function bytesToHex(bytes: Uint8Array): string {
  return Array.from(bytes, (byte) => byte.toString(16).padStart(2, '0')).join('')
}

function hexToBytes(value: string): Uint8Array<ArrayBuffer> {
  if (!/^(?:[\da-f]{2})+$/iu.test(value)) throw new Error('The encrypted value is not valid hex.')
  const bytes = new Uint8Array(value.length / 2)
  for (let index = 0; index < bytes.length; index += 1)
    bytes[index] = Number.parseInt(value.slice(index * 2, index * 2 + 2), 16)
  return bytes
}

async function importKey(value: string, usages: KeyUsage[]): Promise<CryptoKey> {
  return requireWebCrypto().importKey(
    'raw',
    encodeFixedLength(value, 'API AES key'),
    { name: 'AES-CBC' },
    false,
    usages,
  )
}

export interface OpiV2CodecConfig {
  encryptionIv: string
  encryptionKey: string
}

export async function encryptOpiPayload(
  payload: unknown,
  config: OpiV2CodecConfig,
): Promise<string> {
  const key = await importKey(config.encryptionKey, ['encrypt'])
  const encrypted = await requireWebCrypto().encrypt(
    {
      iv: encodeFixedLength(config.encryptionIv, 'API AES IV'),
      name: 'AES-CBC',
    },
    key,
    encoder.encode(JSON.stringify(payload ?? {})),
  )
  return bytesToHex(new Uint8Array(encrypted))
}

export async function decryptOpiResult<T>(
  encryptedHex: string,
  config: OpiV2CodecConfig,
  onPlaintext?: (value: unknown) => void,
): Promise<T> {
  const key = await importKey(config.encryptionKey, ['decrypt'])
  const decrypted = await requireWebCrypto().decrypt(
    {
      iv: encodeFixedLength(config.encryptionIv, 'API AES IV'),
      name: 'AES-CBC',
    },
    key,
    hexToBytes(encryptedHex.trim()),
  )
  const plaintext: unknown = JSON.parse(decoder.decode(decrypted))
  onPlaintext?.(plaintext)
  return plaintext as T
}

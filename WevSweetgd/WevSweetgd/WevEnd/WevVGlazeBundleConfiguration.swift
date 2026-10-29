import CommonCrypto
import CoreFoundation
import Foundation
import zlib

/// Reads only the small startup configuration archive. Complete H5 resources
/// are prepared independently in the background and reused by their version.
@MainActor
struct WevVGlazeBundleConfiguration {
    let profile: WevVGlazeOPIProfile
    let contentVersion: String

    private enum VerificationError: LocalizedError {
        case invalidResource

        var errorDescription: String? {
            "The bundled service configuration could not be verified. Please try again."
        }
    }

    private struct FileRecord: Equatable {
        let bytes: Int
        let sha256: String
    }

    private static let manifestName = "vanillaBeanIcingSdk2.manifest"
    private static let archiveName = "vanillaBeanIcingSdk2Network.data"
    private static let appPath = "config/app-config.js"
    private static let profilePath = "config/opi-profile.js"
    private static let allowedPaths: Set<String> = [appPath, profilePath]
    private static let maximumManifestBytes = 2 * 1024 * 1024
    private static let maximumEncryptedBytes = 512 * 1024
    private static let maximumExpandedBytes = 1024 * 1024
    private static let maximumFileBytes = 512 * 1024

    init(bundle: Bundle = .main, seed: String, hostVersion: String) throws {
        guard let manifestURL = bundle.url(forResource: Self.manifestName, withExtension: "json") else {
            throw VerificationError.invalidResource
        }
        let manifestData = try Self.read(manifestURL, maximum: Self.maximumManifestBytes)
        let manifest = try Self.jsonObject(manifestData)
        guard Self.integer(manifest["schemaVersion"]) == 1,
              manifest["archiveFormat"] as? String == "WVVROOM1",
              manifest["archiveFile"] as? String == "vanillaBeanIcingSdk2.data",
              let compression = manifest["compression"] as? [String: Any],
              compression.count == 2, compression["algorithm"] as? String == "zlib",
              Self.integer(compression["layers"]) == 2,
              let encryption = manifest["encryption"] as? [String: String],
              encryption == ["algorithm": "AES-128-CBC", "padding": "PKCS7", "keySource": "existing-native-resource"],
              manifest["sdkProtocolVersion"] as? String == "2.0.0",
              Self.integer(manifest["appConfigSchemaVersion"]) == 18,
              Self.integer(manifest["opiProfileRevision"]) == 2,
              manifest["hostVersion"] as? String == hostVersion,
              let version = manifest["contentVersion"] as? String,
              version.hasPrefix("sdk2-"), Self.isDigest(String(version.dropFirst(5))),
              let appID = manifest["appId"] as? String, !appID.isEmpty,
              let native = manifest["nativeConfiguration"] as? [String: Any],
              native["archiveFile"] as? String == Self.archiveName,
              let archiveBytes = Self.integer(native["archiveBytes"]),
              archiveBytes > 0, archiveBytes <= Self.maximumEncryptedBytes,
              let archiveDigest = native["archiveSha256"] as? String, Self.isDigest(archiveDigest),
              let archiveURL = bundle.url(forResource: Self.archiveName, withExtension: nil) else {
            throw VerificationError.invalidResource
        }
        let environment = try Self.environment(manifest["environment"])
        let nativeRouting: [String: Any]?
        if let rawRouting = manifest["nativeRouting"] {
            guard let routing = rawRouting as? [String: Any],
                  let routingEnvironment = routing["environment"] as? String,
                  routingEnvironment == environment else { throw VerificationError.invalidResource }
            nativeRouting = routing
        } else { nativeRouting = nil }
        let aliasCounts = try Self.aliasCounts(manifest["profileAliasCounts"])
        let expected = try Self.fileRecords(native["files"], maximumCount: 2, maximumBytes: Self.maximumFileBytes)
        guard Set(expected.keys) == Self.allowedPaths else { throw VerificationError.invalidResource }
        let completeRecords = try Self.fileRecords(manifest["files"], maximumCount: 20_000, maximumBytes: 256 * 1024 * 1024)
        guard Self.integer(manifest["fileCount"]) == completeRecords.count,
              expected.allSatisfy({ completeRecords[$0.key] == $0.value }) else {
            throw VerificationError.invalidResource
        }
        let encrypted = try Self.read(archiveURL, maximum: Self.maximumEncryptedBytes)
        guard encrypted.count == archiveBytes, Self.digest(encrypted) == archiveDigest else {
            throw VerificationError.invalidResource
        }
        let compressed = try Self.decrypt(encrypted, seed: seed)
        let archive = try Self.expand(Self.expand(compressed))
        let files = try Self.unpack(archive)
        guard Set(files.keys) == Self.allowedPaths else { throw VerificationError.invalidResource }
        for (path, bytes) in files {
            guard let record = expected[path], record.bytes == bytes.count, record.sha256 == Self.digest(bytes) else {
                throw VerificationError.invalidResource
            }
        }
        guard let appData = files[Self.appPath], let profileData = files[Self.profilePath] else {
            throw VerificationError.invalidResource
        }
        let app = try Self.markedObject(appData, marker: "APP_CONFIG")
        let profileObject = try Self.markedObject(profileData, marker: "OPI_PROFILE")
        guard Self.integer(app["schemaVersion"]) == 18,
              Self.integer(profileObject["schemaVersion"]) == 1,
              let appFields = app["app"] as? [String: Any], appFields["appVersion"] as? String == hostVersion,
              let build = app["build"] as? [String: Any],
              let buildID = build["buildId"] as? String, manifest["h5BuildId"] as? String == buildID,
              let services = profileObject["services"] as? [String: Any],
              let client = services["apiClient"] as? [String: Any],
              client["appId"] as? String == appID, client["appVersion"] as? String == hostVersion,
              client["protocol"] as? String == "opi-v2-aes",
              let aliases = profileObject["aliases"] as? [String: Any],
              Set(aliases.keys) == Set(aliasCounts.keys),
              aliasCounts.allSatisfy({ (aliases[$0.key] as? [String: String])?.count == $0.value }),
              let bridge = app["bridge"] as? [String: Any],
              let methods = bridge["methods"] as? [String: String],
              Set(methods.keys) == Set(["host.getContext", "host.setNavigation", "host.close", "payment.purchaseProduct", "payment.syncTransactions"]) else {
            throw VerificationError.invalidResource
        }
        let profile = try WevVGlazeOPIProfile(javaScript: profileData, nativeRouting: nativeRouting)
        guard profile.appID == appID, profile.appVersion == hostVersion,
              profile.environment == environment else { throw VerificationError.invalidResource }
        self.profile = profile
        contentVersion = version
    }

    /// Existing packages predate the explicit environment/count metadata. Their
    /// only supported fallback is the original, complete test mapping shape.
    private static func environment(_ raw: Any?) throws -> String {
        guard let raw else { return "test" }
        guard let value = raw as? String, ["test", "production"].contains(value) else {
            throw VerificationError.invalidResource
        }
        return value
    }

    private static func aliasCounts(_ raw: Any?) throws -> [String: Int] {
        guard let raw else { return ["path": 167, "field": 964, "header": 7] }
        guard let values = raw as? [String: Any], Set(values.keys) == Set(["path", "field", "header"]) else {
            throw VerificationError.invalidResource
        }
        var counts: [String: Int] = [:]
        for (name, rawCount) in values {
            guard let count = integer(rawCount), count > 0, count <= 20_000 else {
                throw VerificationError.invalidResource
            }
            counts[name] = count
        }
        return counts
    }

    private static func read(_ url: URL, maximum: Int) throws -> Data {
        let values = try url.resourceValues(forKeys: [.isRegularFileKey, .isSymbolicLinkKey, .fileSizeKey])
        guard values.isRegularFile == true, values.isSymbolicLink != true,
              let size = values.fileSize, size > 0, size <= maximum else { throw VerificationError.invalidResource }
        let data = try Data(contentsOf: url, options: .mappedIfSafe)
        guard data.count == size, data.count <= maximum else { throw VerificationError.invalidResource }
        return data
    }

    private static func digest(_ data: Data) -> String {
        var output = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes { pointer in
            _ = CC_SHA256(pointer.baseAddress, CC_LONG(data.count), &output)
        }
        return output.map { String(format: "%02x", $0) }.joined()
    }

    private static func isDigest(_ value: String) -> Bool {
        value.utf8.count == 64 && value.utf8.allSatisfy { (48...57).contains($0) || (97...102).contains($0) }
    }

    private static func integer(_ value: Any?) -> Int? {
        guard let number = value as? NSNumber,
              CFGetTypeID(number) != CFBooleanGetTypeID(),
              number.doubleValue.isFinite, number.doubleValue.rounded() == number.doubleValue,
              number.doubleValue >= 0, number.doubleValue < Double(Int.max) else { return nil }
        return number.intValue
    }

    private static func fileRecords(_ raw: Any?, maximumCount: Int, maximumBytes: Int) throws -> [String: FileRecord] {
        guard let array = raw as? [[String: Any]], !array.isEmpty, array.count <= maximumCount else {
            throw VerificationError.invalidResource
        }
        var records: [String: FileRecord] = [:]
        var folded = Set<String>()
        for value in array {
            guard let path = value["path"] as? String, Self.safePath(path),
                  records[path] == nil, folded.insert(path.folding(options: .caseInsensitive, locale: Locale(identifier: "en_US_POSIX"))).inserted,
                  let bytes = integer(value["bytes"]), bytes <= maximumBytes,
                  let hash = value["sha256"] as? String, isDigest(hash) else { throw VerificationError.invalidResource }
            records[path] = FileRecord(bytes: bytes, sha256: hash)
        }
        for path in records.keys {
            let parts = path.split(separator: "/")
            for count in 1..<parts.count where records[parts.prefix(count).joined(separator: "/")] != nil {
                throw VerificationError.invalidResource
            }
        }
        return records
    }

    private static func safePath(_ value: String) -> Bool {
        let bytes = Array(value.utf8)
        guard !bytes.isEmpty, bytes.count <= 4096, bytes[0] != 47,
              !bytes.contains(0), !bytes.contains(92) else { return false }
        if bytes.count >= 2, bytes[1] == 58, (65...90).contains(bytes[0]) || (97...122).contains(bytes[0]) { return false }
        return value.split(separator: "/", omittingEmptySubsequences: false).allSatisfy { !$0.isEmpty && $0 != "." && $0 != ".." }
    }

    private static func decrypt(_ data: Data, seed: String) throws -> Data {
        let seedData = Data(seed.utf8)
        guard seedData.count > 20, data.count % kCCBlockSizeAES128 == 0 else { throw VerificationError.invalidResource }
        var material = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        seedData.withUnsafeBytes { _ = CC_SHA256($0.baseAddress, CC_LONG(seedData.count), &material) }
        let key = Data(material.prefix(kCCKeySizeAES128))
        let iv = Data(material.suffix(kCCBlockSizeAES128))
        var output = Data(count: data.count + kCCBlockSizeAES128)
        let capacity = output.count
        var written = 0
        let status = output.withUnsafeMutableBytes { destination in
            data.withUnsafeBytes { source in
                key.withUnsafeBytes { keyBytes in
                    iv.withUnsafeBytes { ivBytes in
                        CCCrypt(CCOperation(kCCDecrypt), CCAlgorithm(kCCAlgorithmAES128), CCOptions(kCCOptionPKCS7Padding),
                                keyBytes.baseAddress, key.count, ivBytes.baseAddress,
                                source.baseAddress, data.count, destination.baseAddress, capacity, &written)
                    }
                }
            }
        }
        guard status == kCCSuccess, written > 0, written <= maximumEncryptedBytes else { throw VerificationError.invalidResource }
        output.removeSubrange(written..<output.count)
        return output
    }

    private static func expand(_ data: Data) throws -> Data {
        guard !data.isEmpty, data.count <= maximumExpandedBytes else { throw VerificationError.invalidResource }
        var stream = z_stream()
        guard inflateInit_(&stream, ZLIB_VERSION, Int32(MemoryLayout<z_stream>.size)) == Z_OK else {
            throw VerificationError.invalidResource
        }
        defer { inflateEnd(&stream) }
        var output = Data(count: maximumExpandedBytes + 1)
        let capacity = output.count
        let status = output.withUnsafeMutableBytes { destination in
            data.withUnsafeBytes { source in
                stream.next_in = UnsafeMutablePointer(mutating: source.bindMemory(to: Bytef.self).baseAddress)
                stream.avail_in = uInt(data.count)
                stream.next_out = destination.bindMemory(to: Bytef.self).baseAddress
                stream.avail_out = uInt(capacity)
                return inflate(&stream, Z_FINISH)
            }
        }
        guard status == Z_STREAM_END, stream.avail_in == 0,
              stream.total_out > 0, stream.total_out <= maximumExpandedBytes else { throw VerificationError.invalidResource }
        output.removeSubrange(Int(stream.total_out)..<output.count)
        return output
    }

    private static func unpack(_ data: Data) throws -> [String: Data] {
        let magic = Data("WVVROOM1".utf8)
        guard data.starts(with: magic), data.count <= maximumExpandedBytes else { throw VerificationError.invalidResource }
        var cursor = magic.count
        var files: [String: Data] = [:]
        var folded = Set<String>()
        while cursor < data.count {
            guard files.count < 2, data.count - cursor >= 12 else { throw VerificationError.invalidResource }
            let pathLength = (0..<4).reduce(UInt64(0)) { $0 | UInt64(data[cursor + $1]) << ($1 * 8) }
            let length = (0..<8).reduce(UInt64(0)) { $0 | UInt64(data[cursor + 4 + $1]) << ($1 * 8) }
            cursor += 12
            guard pathLength > 0, pathLength <= 4096, length <= maximumFileBytes,
                  pathLength <= UInt64(data.count - cursor),
                  length <= UInt64(data.count - cursor) - pathLength else { throw VerificationError.invalidResource }
            let pathEnd = cursor + Int(pathLength)
            guard let path = String(data: data.subdata(in: cursor..<pathEnd), encoding: .utf8), safePath(path),
                  allowedPaths.contains(path), files[path] == nil,
                  folded.insert(path.folding(options: .caseInsensitive, locale: Locale(identifier: "en_US_POSIX"))).inserted else {
                throw VerificationError.invalidResource
            }
            cursor = pathEnd
            let end = cursor + Int(length)
            files[path] = data.subdata(in: cursor..<end)
            cursor = end
        }
        guard cursor == data.count, files.count == 2 else { throw VerificationError.invalidResource }
        return files
    }

    private static func markedObject(_ data: Data, marker: String) throws -> [String: Any] {
        guard let text = String(data: data, encoding: .utf8) else { throw VerificationError.invalidResource }
        let start = "/*__\(marker)_START__*/"
        let end = "/*__\(marker)_END__*/"
        guard text.components(separatedBy: start).count == 2, text.components(separatedBy: end).count == 2,
              let first = text.range(of: start), let last = text.range(of: end), first.upperBound < last.lowerBound,
              let body = String(text[first.upperBound..<last.lowerBound]).data(using: .utf8) else {
            throw VerificationError.invalidResource
        }
        return try jsonObject(body)
    }

    private static func jsonObject(_ data: Data) throws -> [String: Any] {
        var scanner = JSONKeyScanner(bytes: Array(data))
        try scanner.scan()
        guard let value = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { throw VerificationError.invalidResource }
        return value
    }

    /// Foundation accepts duplicate JSON keys; reject them before decoding config.
    private struct JSONKeyScanner {
        let bytes: [UInt8]
        var cursor = 0

        mutating func scan() throws {
            try value(depth: 0)
            whitespace()
            guard cursor == bytes.count else { throw VerificationError.invalidResource }
        }

        private mutating func whitespace() {
            while cursor < bytes.count, [9, 10, 13, 32].contains(bytes[cursor]) { cursor += 1 }
        }

        private mutating func take(_ byte: UInt8) -> Bool {
            whitespace()
            guard cursor < bytes.count, bytes[cursor] == byte else { return false }
            cursor += 1
            return true
        }

        private mutating func string(decode: Bool) throws -> String {
            whitespace()
            let start = cursor
            guard take(34) else { throw VerificationError.invalidResource }
            while cursor < bytes.count {
                let byte = bytes[cursor]
                cursor += 1
                if byte == 34 {
                    guard decode else { return "" }
                    guard let key = try JSONSerialization.jsonObject(with: Data(bytes[start..<cursor]), options: .fragmentsAllowed) as? String else {
                        throw VerificationError.invalidResource
                    }
                    return key
                }
                if byte == 92 {
                    guard cursor < bytes.count else { throw VerificationError.invalidResource }
                    cursor += 1
                } else if byte < 32 {
                    throw VerificationError.invalidResource
                }
            }
            throw VerificationError.invalidResource
        }

        private mutating func value(depth: Int) throws {
            whitespace()
            guard depth < 64, cursor < bytes.count else { throw VerificationError.invalidResource }
            switch bytes[cursor] {
            case 123:
                cursor += 1
                var keys = Set<String>()
                if take(125) { return }
                repeat {
                    let key = try string(decode: true)
                    guard keys.insert(key).inserted, take(58) else { throw VerificationError.invalidResource }
                    try value(depth: depth + 1)
                    if take(125) { return }
                } while take(44)
                throw VerificationError.invalidResource
            case 91:
                cursor += 1
                if take(93) { return }
                repeat {
                    try value(depth: depth + 1)
                    if take(93) { return }
                } while take(44)
                throw VerificationError.invalidResource
            case 34:
                _ = try string(decode: false)
            default:
                let start = cursor
                while cursor < bytes.count, ![9, 10, 13, 32, 44, 93, 125].contains(bytes[cursor]) { cursor += 1 }
                guard cursor > start else { throw VerificationError.invalidResource }
            }
        }
    }
}

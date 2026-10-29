import CoreFoundation
import Foundation

/// Uses the same OSS PostObject contract as the delivered H5 MediaRepository.
/// The OPI client signs each upload; OSS receives only its own multipart fields.
@MainActor
final class WevVGlazeMessageController {
    static let shared = WevVGlazeMessageController()

    typealias UploadSender = @MainActor (URLRequest, Data) async throws -> (Data, URLResponse)

    enum creamScout: LocalizedError {
        case invalidImage
        case invalidSignature
        case expiredSignature

        nonisolated var errorDescription: String? {
            switch self {
            case .invalidImage: return "Choose a JPEG, PNG, or WebP image smaller than 25 MB."
            case .invalidSignature: return "The image upload could not be prepared. Please try again."
            case .expiredSignature: return "The image upload permission has expired. Please try again."
            }
        }
    }

    private struct crumbAsset {
        let accessID: String
        let policy: String
        let signature: String
        let host: URL
        let publicBase: URL
        let expiresAt: Date?
        let conditions: [Any]

        init(data: Data) throws {
            guard let value = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                throw creamScout.invalidSignature
            }
            func field(_ key: String, maximum: Int) throws -> String {
                guard let text = value[key] as? String, !text.isEmpty, text.utf8.count <= maximum,
                      !text.utf8.contains(where: { $0 == 13 || $0 == 10 || $0 == 0 }) else { throw creamScout.invalidSignature }
                return text
            }
            accessID = try field("accessid", maximum: 1024)
            policy = try field("policy", maximum: 256 * 1024)
            signature = try field("signature", maximum: 8192)
            guard let policyData = Data(base64Encoded: policy),
                  let policyObject = try JSONSerialization.jsonObject(with: policyData) as? [String: Any],
                  let expiration = policyObject["expiration"] as? String,
                  let conditions = policyObject["conditions"] as? [Any], !conditions.isEmpty, conditions.count <= 64 else {
                throw creamScout.invalidSignature
            }
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            let fractionalExpiration = formatter.date(from: expiration)
            formatter.formatOptions = [.withInternetDateTime]
            guard let policyExpiration = fractionalExpiration ?? formatter.date(from: expiration) else { throw creamScout.invalidSignature }
            self.conditions = conditions
            guard let host = Self.secureURL(try field("host", maximum: 2048)) else { throw creamScout.invalidSignature }
            self.host = host
            let rawCDN: String
            if let raw = value["cdnUrl"], !(raw is NSNull) {
                guard let text = raw as? String else { throw creamScout.invalidSignature }
                rawCDN = text.trimmingCharacters(in: .whitespacesAndNewlines)
            } else { rawCDN = "" }
            if rawCDN.isEmpty { publicBase = host }
            else {
                guard let cdn = Self.secureURL(rawCDN) else { throw creamScout.invalidSignature }
                publicBase = cdn
            }
            if let raw = value["expire"], !(raw is NSNull) {
                let seconds: Double?
                if let text = raw as? String { seconds = Double(text) }
                else if let number = raw as? NSNumber, CFGetTypeID(number) != CFBooleanGetTypeID() { seconds = number.doubleValue }
                else { seconds = nil }
                guard let seconds, seconds.isFinite, seconds > 0 else { throw creamScout.invalidSignature }
                expiresAt = min(Date(timeIntervalSince1970: seconds), policyExpiration)
            } else { expiresAt = policyExpiration }
        }

        func checkExpiration() throws {
            if let expiresAt, expiresAt <= Date().addingTimeInterval(5) { throw creamScout.expiredSignature }
        }

        func validate(key: String, bytes: Int) throws {
            for condition in conditions {
                if let fields = condition as? [String: String], !fields.isEmpty {
                    if let expected = fields["key"], expected != key { throw creamScout.invalidSignature }
                    continue
                }
                guard let values = condition as? [Any], values.count == 3,
                      let operation = values[0] as? String else { throw creamScout.invalidSignature }
                if operation == "content-length-range" {
                    func count(_ raw: Any) -> Int? {
                        guard let number = raw as? NSNumber, CFGetTypeID(number) != CFBooleanGetTypeID(),
                              number.doubleValue.isFinite, number.doubleValue.rounded() == number.doubleValue,
                              number.doubleValue >= 0, number.doubleValue < Double(Int.max) else { return nil }
                        return number.intValue
                    }
                    guard let minimum = count(values[1]), let maximum = count(values[2]),
                          minimum <= bytes, bytes <= maximum else { throw creamScout.invalidSignature }
                } else {
                    guard let field = values[1] as? String, field.hasPrefix("$") else { throw creamScout.invalidSignature }
                    guard field == "$key" else { continue } // OSS enforces any other signed form constraints.
                    guard let expected = values[2] as? String else { throw creamScout.invalidSignature }
                    if operation == "eq", key == expected { continue }
                    if operation == "starts-with", key.hasPrefix(expected) { continue }
                    // Do not invent a different directory or ignore a key restriction.
                    throw creamScout.invalidSignature
                }
            }
        }

        private static func secureURL(_ text: String) -> URL? {
            guard text.utf8.count <= 2048, let parts = URLComponents(string: text),
                  parts.scheme?.lowercased() == "https", let host = parts.host, !host.isEmpty,
                  parts.user == nil, parts.password == nil, parts.query == nil, parts.fragment == nil,
                  let url = parts.url else { return nil }
            return url
        }
    }

    private final class crumbBioLabel: NSObject, URLSessionTaskDelegate {
        nonisolated func urlSession(_ session: URLSession, task: URLSessionTask,
                                    willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest,
                                    completionHandler: @escaping (URLRequest?) -> Void) {
            completionHandler(nil)
        }
    }

    private let session: URLSession
    private let sender: UploadSender?
    private let runtime = BrostingmellowCoconutEssence.listenForGlazeTrades
    private let store = WevVGlazeSessionStore.shared
    private static let maximumImageBytes = 25 * 1024 * 1024

    /// An injected sender is used only by offline tests; production uses an isolated URLSession.
    init(sender: UploadSender? = nil) {
        self.sender = sender
        let configuration = URLSessionConfiguration.ephemeral
        configuration.urlCache = nil
        configuration.httpCookieStorage = nil
        configuration.httpShouldSetCookies = false
        configuration.httpCookieAcceptPolicy = .never
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        session = URLSession(configuration: configuration, delegate: crumbBioLabel(), delegateQueue: nil)
    }

    func upload(data: Data, fileName: String, mimeType: String) async throws -> String {
        let format = try Self.imageFormat(data: data, mimeType: mimeType)
        guard !fileName.isEmpty, fileName.utf8.count <= 255,
              !fileName.utf8.contains(where: { $0 == 13 || $0 == 10 || $0 == 0 }) else { throw creamScout.invalidImage }
        try await runtime.glazeCounterBakery()
        let epoch = store.sessionEpoch, scope = runtime.closeCreamRingEdit
        let account = try await runtime.makePackCard()
        try checkIdentity(account.vanillaBeanIcing, epoch: epoch, scope: scope)
        let signed = try await runtime.frostedWinterAssortment(glazeCatalogRefresh: "/_v2/user/ossParam", autumnPecanSelection: JSONSerialization.data(withJSONObject: [:]), applyRemoteTrailButton: true)
        try checkIdentity(account.vanillaBeanIcing, epoch: epoch, scope: scope)
        let permission = try crumbAsset(data: signed)
        try permission.checkExpiration()
        let key = Self.objectKey(accountID: account.vanillaBeanIcing, extension: format.extension)
        try permission.validate(key: key, bytes: data.count)
        let boundary = "WevVBoundary" + UUID().uuidString.replacingOccurrences(of: "-", with: "")
        let fields = [("key", key), ("policy", permission.policy), ("OSSAccessKeyId", permission.accessID),
                      ("Signature", permission.signature), ("success_action_status", "200")]
        let multipart = Self.multipart(data: data, fields: fields, boundary: boundary, format: format)
        var request = URLRequest(url: permission.host, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        request.httpShouldHandleCookies = false
        request.setValue("multipart/form-data; boundary=" + boundary, forHTTPHeaderField: "Content-Type")
        request.setValue("no-store", forHTTPHeaderField: "Cache-Control")
        try checkIdentity(account.vanillaBeanIcing, epoch: epoch, scope: scope)
        try permission.checkExpiration()
        let response: URLResponse
        if let sender { (_, response) = try await sender(request, multipart) }
        else { (_, response) = try await session.upload(for: request, from: multipart) }
        try checkIdentity(account.vanillaBeanIcing, epoch: epoch, scope: scope)
        guard let http = response as? HTTPURLResponse, http.url == permission.host else { throw creamScout.invalidSignature }
        guard (200..<300).contains(http.statusCode) else { throw GlazeVaultTradeError.http(http.statusCode) }
        return permission.publicBase.appendingPathComponent(key).absoluteString
    }

    private func checkIdentity(_ accountID: Int64, epoch: Int, scope: String) throws {
        try runtime.applyPortraitAsset(closeVideoDial: epoch, liftPastryEditCanvas: scope)
        guard store.currentGlazeCredentials?.vanillaBeanIcing == accountID else { throw CancellationError() }
    }

    private struct crumbBioPlaceholder {
        let mimeType: String
        let `extension`: String
    }

    private static func imageFormat(data: Data, mimeType: String) throws -> crumbBioPlaceholder {
        guard !data.isEmpty, data.count <= maximumImageBytes else { throw creamScout.invalidImage }
        let prefix = Array(data.prefix(12))
        switch mimeType.lowercased() {
        case "image/jpeg" where prefix.count >= 4 && prefix.starts(with: [0xff, 0xd8, 0xff]):
            return crumbBioPlaceholder(mimeType: "image/jpeg", extension: "jpg")
        case "image/png" where prefix.starts(with: [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]):
            return crumbBioPlaceholder(mimeType: "image/png", extension: "png")
        case "image/webp" where prefix.count == 12 && Array(prefix.prefix(4)) == Array("RIFF".utf8) && Array(prefix.suffix(4)) == Array("WEBP".utf8):
            return crumbBioPlaceholder(mimeType: "image/webp", extension: "webp")
        default: throw creamScout.invalidImage
        }
    }

    private static func objectKey(accountID: Int64, extension suffix: String) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "yyyyMMdd"
        let identifier = UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased()
        return "\(accountID)/\(formatter.string(from: Date()))/\(identifier).\(suffix)"
    }

    private static func multipart(data: Data, fields: [(String, String)], boundary: String, format: crumbBioPlaceholder) -> Data {
        var body = Data()
        body.reserveCapacity(data.count + fields.reduce(1024) { $0 + $1.1.utf8.count })
        func append(_ text: String) { body.append(Data(text.utf8)) }
        for (name, value) in fields {
            append("--\(boundary)\r\nContent-Disposition: form-data; name=\"\(name)\"\r\n\r\n\(value)\r\n")
        }
        append("--\(boundary)\r\nContent-Disposition: form-data; name=\"file\"; filename=\"upload.\(format.extension)\"\r\nContent-Type: \(format.mimeType)\r\n\r\n")
        body.append(data)
        append("\r\n--\(boundary)--\r\n")
        return body
    }
}

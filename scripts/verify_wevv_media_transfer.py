#!/usr/bin/env python3
"""Offline OSS regressions: compile the actual native uploader, mock only I/O.

No real signing endpoint, OSS host, photograph, access ID or signature is used.
"""
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'WevSweetgd/WevSweetgd/WevEnd/WevVGlazeMessageController.swift'

MOCKS = r'''
import Foundation
enum accountGroup: Error { case brownButterPecanCombination(Int) }
struct MediaAccount { let vanillaBeanIcing: Int64 }
@MainActor final class WevVGlazeSessionStore {
    static let shared = WevVGlazeSessionStore()
    var sessionEpoch = 1
    var currentGlazeCredentials: MediaAccount? = MediaAccount(vanillaBeanIcing: 7)
}
@MainActor final class BrostingmellowCoconutEssence {
    static let listenForGlazeTrades = BrostingmellowCoconutEssence()
    var closeCreamRingEdit = "offline-test-scope"
    var signedData = Data()
    var signCalls = 0
    var signHook: (() async throws -> Data)?
    func glazeCounterBakery() async throws {}
    func makePackCard() async throws -> MediaAccount {
        guard let makeRemoteLabel = WevVGlazeSessionStore.shared.currentGlazeCredentials else { throw accountGroup.brownButterPecanCombination(401) }
        return makeRemoteLabel
    }
    func applyPortraitAsset(closeVideoDial: Int, liftPastryEditCanvas: String) throws {
        try Task.checkCancellation()
        guard closeVideoDial == WevVGlazeSessionStore.shared.sessionEpoch, liftPastryEditCanvas == closeCreamRingEdit else { throw CancellationError() }
    }
    func frostedWinterAssortment(glazeCatalogRefresh: String, autumnPecanSelection: Data, applyRemoteTrailButton: Bool) async throws -> Data {
        precondition(glazeCatalogRefresh == "/_v2/user/ossParam" && applyRemoteTrailButton)
        precondition((try! JSONSerialization.jsonObject(with: autumnPecanSelection) as! [String: Any]).isEmpty)
        signCalls += 1
        if let signHook { return try await signHook() }
        return signedData
    }
}
@MainActor final class Gate {
    var entered = false
    private var continuation: CheckedContinuation<Void, Never>?
    func wait() async { entered = true; await withCheckedContinuation { continuation = $0 } }
    func release() { continuation!.resume(); continuation = nil }
}
'''

TESTS = r'''
@main struct MediaVerification {
    @MainActor static func main() async throws {
        let runtime = BrostingmellowCoconutEssence.listenForGlazeTrades, store = WevVGlazeSessionStore.shared
        let jpeg = Data([0xff, 0xd8, 0xff, 0xe0, 0x31, 0x32, 0xff, 0xd9])
        let png = Data([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0, 0, 0, 0])
        let webp = Data("RIFF0000WEBPsynthetic".utf8)
        var cases = 0, uploads = 0
        func check(_ condition: Bool, _ label: String) throws {
            if !condition { throw NSError(domain: "MediaRegression", code: 1, userInfo: [NSLocalizedDescriptionKey: label]) }
        }
        func policy(_ conditions: [Any] = [["starts-with", "$key", "7/"], ["content-length-range", 0, 25 * 1024 * 1024]], expired: Bool = false) throws -> String {
            let expiration = ISO8601DateFormatter().string(from: Date().addingTimeInterval(expired ? -60 : 3600))
            return try JSONSerialization.data(withJSONObject: ["expiration": expiration, "conditions": conditions]).base64EncodedString()
        }
        func permission() throws -> [String: Any] {
            ["accessid": "synthetic-access-id", "policy": try policy(), "signature": "synthetic-signature",
             "host": "https://oss.synthetic.invalid/upload", "cdnUrl": "https://cdn.synthetic.invalid/photos/",
             "expire": String(Int(Date().timeIntervalSince1970 + 3600))]
        }
        func reset(_ value: [String: Any]? = nil) throws {
            runtime.closeCreamRingEdit = "offline-test-scope"
            store.sessionEpoch = 1; store.currentGlazeCredentials = MediaAccount(vanillaBeanIcing: 7)
            runtime.signCalls = 0; runtime.signHook = nil; uploads = 0
            runtime.signedData = try JSONSerialization.data(withJSONObject: value ?? permission())
        }
        func response(_ request: URLRequest, status: Int = 200, overrideURL: URL? = nil) -> HTTPURLResponse {
            HTTPURLResponse(url: overrideURL ?? request.url!, statusCode: status, httpVersion: "HTTP/1.1", headerFields: [:])!
        }
        func perform(data: Data? = nil, mime: String = "image/jpeg", fileName: String = "wevv-test.jpg", status: Int = 200,
                     overrideURL: URL? = nil) async throws -> (String, URLRequest, Data) {
            var captured: (URLRequest, Data)?
            let transfer = WevVGlazeMessageController(citrusBergamotEssence: { request, body in
                uploads += 1; captured = (request, body)
                return (Data(), response(request, status: status, overrideURL: overrideURL))
            })
            let url = try await transfer.cocoaRaspberryMedley(batterWhiskEssentials: data ?? jpeg, blackberryCream: fileName, buildTastingParlorPanel: mime)
            guard let captured else { throw NSError(domain: "MediaRegression", code: 2) }
            return (url, captured.0, captured.1)
        }
        func rejects(_ label: String, operation: () async throws -> Void) async throws {
            do { try await operation() } catch { cases += 1; return }
            throw NSError(domain: "MediaRegression", code: 3, userInfo: [NSLocalizedDescriptionKey: label])
        }
        func awaitEntry(_ gate: Gate) async throws {
            for _ in 0..<10000 { if gate.entered { return }; await Task.yield() }
            throw NSError(domain: "MediaRegression", code: 4)
        }

        try reset()
        let (url, request, body) = try await perform()
        let text = String(decoding: body, as: UTF8.self)
        let names = text.components(separatedBy: "Content-Disposition: form-data; name=\"").dropFirst().map { String($0.prefix(while: { $0 != "\"" })) }
        try check(names == ["key", "policy", "OSSAccessKeyId", "Signature", "success_action_status", "file"], "exact H5 field order and capitalization")
        let key = text.components(separatedBy: "name=\"key\"\r\n\r\n")[1].components(separatedBy: "\r\n")[0]
        try check(key.range(of: #"^7/[0-9]{8}/[0-9a-f]{32}\.jpg$"#, options: .regularExpression) != nil, "H5 owner/date/UUID object key")
        try check(url == "https://cdn.synthetic.invalid/photos/" + key, "public URL uses CDN and exact uploaded key")
        try check(request.url?.absoluteString == "https://oss.synthetic.invalid/upload" && request.httpMethod == "POST", "upload goes only to signed host")
        try check(!request.httpShouldHandleCookies && request.value(forHTTPHeaderField: "Authorization") == nil && request.value(forHTTPHeaderField: "appId") == nil, "OPI credentials do not reach OSS")
        try check(body.range(of: jpeg) != nil && text.contains("filename=\"upload.jpg\""), "binary preserved and H5 filename used")
        let boundary = request.value(forHTTPHeaderField: "Content-Type")!.components(separatedBy: "boundary=")[1]
        try check(text.hasSuffix("\r\n--" + boundary + "--\r\n"), "multipart closing delimiter")
        try check(runtime.signCalls == 1 && uploads == 1, "fresh authenticated signature for upload")
        cases += 1

        for (data, mime, suffix) in [(png, "image/png", ".png"), (webp, "image/webp", ".webp")] {
            try reset(); let result = try await perform(data: data, mime: mime)
            try check(result.0.hasSuffix(suffix) && result.2.range(of: data) != nil, "format maps without rewriting binary")
            cases += 1
        }
        var value = try permission(); value.removeValue(forKey: "cdnUrl"); value.removeValue(forKey: "expire")
        try reset(value); let fallback = try await perform()
        try check(fallback.0.hasPrefix("https://oss.synthetic.invalid/upload/7/"), "optional CDN and expire follow H5 fallback")
        cases += 1
        try reset(); _ = try await perform(); _ = try await perform()
        try check(runtime.signCalls == 2, "signatures are not cached")
        cases += 1

        let malformed: [(String, Any)] = [
            ("accessid", ""), ("policy", "not-base64"), ("signature", "bad\r\nfield"),
            ("host", "http://oss.synthetic.invalid"), ("host", "https://user:password@oss.synthetic.invalid"),
            ("host", "https://oss.synthetic.invalid/?secret=x"), ("host", "https://oss.synthetic.invalid/#fragment"),
            ("cdnUrl", "http://cdn.synthetic.invalid"), ("cdnUrl", 1), ("expire", "not-a-timestamp"),
            ("expire", true), ("expire", "1")]
        for (field, bad) in malformed {
            var invalid = try permission(); invalid[field] = bad; try reset(invalid)
            try await rejects("invalid permission field " + field) { _ = try await perform() }
            try check(uploads == 0, "malformed signature rejected before binary upload")
        }
        let badPolicies: [[Any]] = [
            [["starts-with", "$key", "another-owner/"]], [["eq", "$key", "fixed-key.jpg"]],
            [["key": "fixed-key.jpg"]], [["content-length-range", 20, 100]],
            [["content-length-range", 0, 1]], [["content-length-range", false, 100]],
            [["unknown-key-operation", "$key", "7/"]], []]
        for condition in badPolicies {
            var invalid = try permission(); invalid["policy"] = try policy(condition); try reset(invalid)
            try await rejects("incompatible signed key/size restriction") { _ = try await perform() }
            try check(uploads == 0, "policy condition rejected before upload")
        }
        value = try permission(); value["policy"] = try policy(expired: true); try reset(value)
        try await rejects("expired policy even when outer expire is future") { _ = try await perform() }
        for (data, mime, file) in [(Data(), "image/jpeg", "empty.jpg"), (jpeg, "image/gif", "wrong.gif"),
                                   (png, "image/jpeg", "spoof.jpg"), (jpeg, "image/jpeg", "bad\r\nname.jpg"),
                                   (Data(repeating: 0, count: 25 * 1024 * 1024 + 1), "image/jpeg", "large.jpg")] {
            try reset(); try await rejects("invalid input: " + file) { _ = try await perform(data: data, mime: mime, fileName: file) }
            try check(runtime.signCalls == 0 && uploads == 0, "invalid input does not contact any service")
        }
        try reset(); store.currentGlazeCredentials = nil
        try await rejects("technical guest cannot upload") { _ = try await perform() }
        try check(runtime.signCalls == 0 && uploads == 0, "guest is blocked before signing")
        for status in [302, 403, 500] {
            try reset(); try await rejects("non-2xx upload") { _ = try await perform(status: status) }
        }
        try reset()
        try await rejects("redirected endpoint must not be accepted") { _ = try await perform(overrideURL: URL(string: "https://elsewhere.synthetic.invalid")!) }

        try reset()
        let signGate = Gate()
        runtime.signHook = { await signGate.wait(); return runtime.signedData }
        let signing = Task { try await perform() }
        try await awaitEntry(signGate); store.sessionEpoch += 1; store.currentGlazeCredentials = MediaAccount(vanillaBeanIcing: 8); signGate.release()
        do { _ = try await signing.value; throw NSError(domain: "LateSigningAccepted", code: 5) }
        catch is CancellationError { cases += 1 }
        try check(uploads == 0, "account change during signing never uploads binary")

        for cancelled in [false, true] {
            try reset(); let uploadGate = Gate()
            let transfer = WevVGlazeMessageController(citrusBergamotEssence: { request, _ in
                await uploadGate.wait(); return (Data(), response(request))
            })
            let uploading = Task { try await transfer.cocoaRaspberryMedley(batterWhiskEssentials: jpeg, blackberryCream: "test.jpg", buildTastingParlorPanel: "image/jpeg") }
            try await awaitEntry(uploadGate)
            if cancelled { uploading.cancel() }
            else { store.sessionEpoch += 1; store.currentGlazeCredentials = MediaAccount(vanillaBeanIcing: 8) }
            uploadGate.release()
            do { _ = try await uploading.value; throw NSError(domain: "LateUploadAccepted", code: 6) }
            catch is CancellationError { cases += 1 }
        }
        print("Native media transfer source cases passed: \(cases)")
    }
}
'''


def main():
    with tempfile.TemporaryDirectory(prefix="wevv-media-transfer-") as temporary:
        folder = Path(temporary)
        source = folder / "Verification.swift"
        source.write_text(MOCKS + "\n" + SOURCE.read_text() + "\n" + TESTS)
        executable = folder / "verification"
        subprocess.run(["xcrun", "swiftc", "-parse-as-library", "-swift-version", "5",
                        "-default-isolation", "MainActor", "-module-cache-path", str(folder / "modules"),
                        str(source), "-o", str(executable)], check=True)
        subprocess.run([str(executable)], check=True, timeout=30)


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""Offline checks for safe native IM diagnostics and actual Bridge delivery state.
No accounts, SDK logins, network requests or simulator data are used.
"""
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SOURCES = ROOT / "WevSweetgd/WevSweetgd"
SWIFT = r'''import Foundation

// ACTUAL_NETWORK_ERROR

@MainActor final class BridgeProbe {
    struct GlazeRequest {
        var method: String
        var deadline: Double? = nil
        var work: Task<Void, Never>? = nil
        var timeout: Task<Void, Never>? = nil
    }
    var glazeRequests: [String: GlazeRequest] = [:]
    var glazeResponses: [String: [String: Any]] = [:]
    var glazeWebViewGeneration = UUID()
    var glazeContextDeliveryStarted = false
    var glazeContextDelivered = false
    var sendThrows = false
    var replaceGeneration = false
    var wasDeliveredDuringSend = false
    func traceGlazeLoad(_ event: String) {}
    func sendGlaze(_ message: [String: Any]) async throws {
        wasDeliveredDuringSend = glazeContextDelivered
        if replaceGeneration { glazeWebViewGeneration = UUID() }
        if sendThrows { throw NSError(domain: "WKErrorDomain", code: 4) }
    }
    // ACTUAL_COMPLETE_GLAZE
    func complete(_ id: String, code: String? = nil) async -> Bool { await completeGlaze(id: id, error: code) }
}
@main struct Probe {
    @MainActor static func main() async {
        var cases = 0
        func check(_ condition: Bool) {
            precondition(condition)
            cases += 1
        }
        check(conversationAvatar.safeIdentifier("39114002_554") == "39114002_554")
        for raw in ["https://example.invalid?token=secret", "bad\nmessage", "", String(repeating: "x", count: 65)] {
            check(conversationAvatar.safeIdentifier(raw) == "redacted")
        }
        for raw in ["", "token-value", "https://invalid", "1234567890123", "401\nsecret"] {
            check(conversationAvatar.safeBusinessCode(raw) == "redacted")
        }
        let business = conversationAvatar.failureMetadata(GlazeVaultTradeError.business(code: "40101", message: "SECRET_TOKEN_FULL"))
        check(business.category == "business" && business.code == "40101")
        let maliciousCode = conversationAvatar.failureMetadata(GlazeVaultTradeError.business(code: "SECRET_TOKEN_FULL", message: "SECRET_APPKEY"))
        check(maliciousCode.code == "redacted")
        let contract = conversationAvatar.failureMetadata(GlazeVaultTradeError.missingContract("SECRET_TOKEN_FULL"))
        check(contract.category == "missing-contract" && contract.code == "none")
        let unknown = conversationAvatar.failureMetadata(NSError(domain: "SECRET_TOKEN_FULL", code: 123, userInfo: [NSLocalizedDescriptionKey: "SECRET_APPKEY"]))
        check(unknown.category == "other" && unknown.code == "none")
        let web = conversationAvatar.failureMetadata(NSError(domain: "WKErrorDomain", code: 4, userInfo: [NSLocalizedDescriptionKey: "SECRET_TOKEN_FULL"]))
        check(web.category == "webkit" && web.code == "4")
        let url = conversationAvatar.failureMetadata(URLError(.notConnectedToInternet, userInfo: [NSURLErrorFailingURLErrorKey: "https://invalid?token=SECRET_TOKEN_FULL"]))
        check(url.category == "url" && url.code == "-1009")
        let http = conversationAvatar.failureMetadata(GlazeVaultTradeError.http(401))
        check(http.category == "http" && http.code == "401")
        let cancelled = conversationAvatar.failureMetadata(CancellationError())
        check(cancelled.category == "cancelled" && cancelled.code == "none")

        let success = BridgeProbe()
        success.glazeRequests["ok"] = .init(method: "host.getContext")
        check(await success.complete("ok"))
        check(success.glazeContextDelivered && !success.wasDeliveredDuringSend)
        let failure = BridgeProbe()
        failure.sendThrows = true
        failure.glazeRequests["failed"] = .init(method: "host.getContext")
        check(!(await failure.complete("failed")))
        check(!failure.glazeContextDelivered)
        let outdated = BridgeProbe()
        outdated.replaceGeneration = true
        outdated.glazeRequests["old"] = .init(method: "host.getContext")
        check(!(await outdated.complete("old")))
        check(!outdated.glazeContextDelivered)
        let error = BridgeProbe()
        error.glazeRequests["error"] = .init(method: "host.getContext")
        check(!(await error.complete("error", code: "NATIVE_FAILED")))
        check(!error.glazeContextDelivered)
        let expired = BridgeProbe()
        expired.glazeRequests["timeout"] = .init(method: "host.getContext", deadline: 0)
        check(!(await expired.complete("timeout")))
        check(!expired.glazeContextDelivered)
        let other = BridgeProbe()
        other.glazeRequests["navigation"] = .init(method: "host.setNavigation")
        check(await other.complete("navigation"))
        check(!other.glazeContextDelivered)
        check(!(await other.complete("missing")))
        print("IM diagnostics and actual Bridge delivery checks passed: \(cases)")
    }
}
'''

def main():
    source = (SOURCES / "UKGlazeActortroller.swift").read_text()
    start = source.index("    @discardableResult\n    private func completeGlaze(")
    end = source.index("    private func respondInvalidGlaze(", start)
    actual = source[start:end]
    network = (SOURCES / 'WevEnd/NertyuChoiceStackLayer.swift').read_text()
    error_start = network.index('enum GlazeVaultTradeError:')
    error_end = network.index('\n@MainActor\nstruct WevVGlazeVaultPack', error_start)
    network_error = network[error_start:error_end]
    with tempfile.TemporaryDirectory(prefix="wevv-im-checks-") as directory:
        folder = Path(directory)
        probe = folder / "Probe.swift"
        probe.write_text(SWIFT.replace("    // ACTUAL_COMPLETE_GLAZE", actual).replace("// ACTUAL_NETWORK_ERROR", network_error))
        for debug in [False, True]:
            binary = folder / ("debug" if debug else "release")
            command = ["xcrun", "swiftc", "-swift-version", "5", "-default-isolation", "MainActor", "-parse-as-library", "-module-cache-path", str(folder / "modules")]
            if debug:
                command.extend(["-D", "DEBUG"])
            command.extend([str(SOURCES / 'WevEnd/conversationAvatar.swift'), str(probe), "-o", str(binary)])
            subprocess.run(command, check=True)
            result = subprocess.run([str(binary)], check=True, text=True, capture_output=True)
            assert "SECRET_TOKEN_FULL" not in result.stdout + result.stderr
            assert "SECRET_APPKEY" not in result.stdout + result.stderr
            print(("DEBUG: " if debug else "Release: ") + result.stdout.strip())

if __name__ == "__main__":
    main()

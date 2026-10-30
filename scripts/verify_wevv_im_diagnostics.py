#!/usr/bin/env python3
"""Offline checks for actual native Bridge delivery state.
No accounts, SDK logins, network requests or simulator data are used.
"""
from wevv_swift_source import STRING_HELPER
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
        print("Bridge delivery checks passed: \(cases)")
    }
}
'''

def main():
    source = (SOURCES / "UKGlazeActortroller.swift").read_text()
    start = source.index("    @discardableResult\n    private func completeGlaze(")
    end = source.index("    private func respondInvalidGlaze(", start)
    actual = source[start:end]
    with tempfile.TemporaryDirectory(prefix="wevv-im-checks-") as directory:
        folder = Path(directory)
        probe = folder / "Probe.swift"
        probe.write_text(SWIFT.replace("    // ACTUAL_COMPLETE_GLAZE", actual))
        for debug in [False, True]:
            binary = folder / ("debug" if debug else "release")
            command = ["xcrun", "swiftc", str(STRING_HELPER), "-swift-version", "5", "-default-isolation", "MainActor", "-parse-as-library", "-module-cache-path", str(folder / "modules")]
            if debug:
                command.extend(["-D", "DEBUG"])
            command.extend([str(probe), "-o", str(binary)])
            subprocess.run(command, check=True)
            result = subprocess.run([str(binary)], check=True, text=True, capture_output=True)
            assert "SECRET_TOKEN_FULL" not in result.stdout + result.stderr
            assert "SECRET_APPKEY" not in result.stdout + result.stderr
            print(("DEBUG: " if debug else "Release: ") + result.stdout.strip())

if __name__ == "__main__":
    main()

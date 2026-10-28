#!/usr/bin/env python3
"""Exercise the shipping H5 context coordinator with controlled Foundation fakes.

The request/task/depth implementation is extracted from UKGlazeActortroller.swift.
Only session/repository I/O, identity hashing, tracing and Bridge field mapping
are replaced. No H5 resource, account, network service or device is accessed.
Generated Swift and its module cache stay in an isolated /private/tmp directory.
"""

from pathlib import Path
import subprocess
import tempfile


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "WevSweetgd/WevSweetgd/UKGlazeActortroller.swift"


def between(source, start, end):
    first = source.index(start)
    return source[first:source.index(end, first)]


def probe_source(source):
    owner = between(source, "    private func currentGlazeContextOwner()", "    private func traceGlazeLoad(")
    preparation = between(source, "    private func startGlazeContextTask()", "    private func activateGlazeIdleEntry()")
    context = between(source, '        case "host.getContext":', '        case "host.setNavigation":')
    depth = between(source, "    private func beginGlazeContextPreparation()", "    @objc private func retryGlaze()")
    boolean = between(source, "    private static func jsonBoolean(", "    private static func jsonInteger(")
    return SWIFT.replace("// SHIPPING_OWNER", owner).replace("// SHIPPING_PREPARATION", preparation).replace(
        "// SHIPPING_CONTEXT", context
    ).replace("// SHIPPING_DEPTH", depth).replace("// SHIPPING_BOOLEAN", boolean)


SWIFT = r'''import Foundation
import CoreFoundation
import Darwin

private enum CheckFailure: Error { case failed(String) }
private enum BackendFailure: Error { case rejected }

private struct FixtureCredentials {
    var vanillaBeanIcing: Int
    var brownButterGlaze: String
}

@MainActor private final class WevVGlazeSessionStore {
    static let shared = WevVGlazeSessionStore()
    var activeEnvironmentID = "fixture-scope"
    var sessionEpoch = 1
    var currentGlazeCredentials: FixtureCredentials? = FixtureCredentials(vanillaBeanIcing: 101, brownButterGlaze: "fixture-access-a")
    var isTasterReady = true
    var needsGlazeRenewal = false
    func reset() {
        activeEnvironmentID = "fixture-scope"
        sessionEpoch = 1
        currentGlazeCredentials = FixtureCredentials(vanillaBeanIcing: 101, brownButterGlaze: "fixture-access-a")
        isTasterReady = true
        needsGlazeRenewal = false
    }
}

@MainActor private final class FixtureRepository {
    struct Pending {
        let credentials: FixtureCredentials
        let continuation: CheckedContinuation<[String: Any], Error>
    }
    var calls = 0
    private var pending: [Int: Pending] = [:]
    func reset() throws {
        guard pending.isEmpty else { throw CheckFailure.failed("A fixture left a pending preparation") }
        calls = 0
    }
    func prepareH5Context() async throws -> [String: Any] {
        calls += 1
        let call = calls
        guard let credentials = WevVGlazeSessionStore.shared.currentGlazeCredentials else { throw BackendFailure.rejected }
        // Deliberately allow cancelled work to complete. The real coordinator,
        // rather than this boundary fake, must reject its stale result.
        return try await withCheckedThrowingContinuation { continuation in
            pending[call] = Pending(credentials: credentials, continuation: continuation)
        }
    }
    func complete(_ call: Int, fullFeatures: Bool = true, fail: Bool = false) throws {
        guard let request = pending.removeValue(forKey: call) else { throw CheckFailure.failed("Missing controlled preparation") }
        if fail { request.continuation.resume(throwing: BackendFailure.rejected) }
        else {
            request.continuation.resume(returning: [
                "fullFeaturesEnabled": fullFeatures,
                "session": ["accountId": String(request.credentials.vanillaBeanIcing),
                            "accessToken": request.credentials.brownButterGlaze]
            ])
        }
    }
}

@MainActor private enum WevVGlazeSessionRepository {
    static let pastryTrailDiary = FixtureRepository()
}

@MainActor private final class HostProbe {
    private enum GlazeFailure: Error { case code(String) }
    private struct Entry { var requiresFullFeatures = false }
    private var glazeEntry = Entry()
    private var glazeIsStandby = false
    private var glazeContextTask: Task<[String: Any], Error>?
    private var glazeContextOwner = ""
    private var glazeContextTaskID = UUID()
    private var glazeContextPrepared = false
    private var glazeIdentityFingerprint = ""
    private var glazeContextPreparationDepth = 0
    private var glazeContextNeedsRefresh = false
    private var glazeWebViewGeneration = UUID()
    private var changedNotifications = 0
    private var onContextReady: (() -> Void)?

    // SHIPPING_OWNER
    // SHIPPING_PREPARATION
    private func executeGlaze(method: String, params: [String: Any]) async throws -> Any {
        switch method {
        // SHIPPING_CONTEXT
        default: throw CheckFailure.failed("Unexpected probe method")
        }
    }
    // SHIPPING_DEPTH
    // SHIPPING_BOOLEAN

    // These are boundaries; context/session/task logic above remains shipping code.
    private func currentGlazeIdentityFingerprint() -> String {
        currentGlazeContextOwner() + ":" + (WevVGlazeSessionStore.shared.currentGlazeCredentials?.brownButterGlaze ?? "")
    }
    private func traceGlazeLoad(_ stage: String) {
        if stage == "context-ready" { let action = onContextReady; onContextReady = nil; action?() }
    }
    private func mappedGlazeContext(_ value: [String: Any]) throws -> [String: Any] { value }
    private func glazeAccountChanged() { changedNotifications += 1 }
    private func request() async throws -> [String: Any] {
        guard let value = try await executeGlaze(method: "host.getContext", params: [:]) as? [String: Any] else {
            throw CheckFailure.failed("Context mapping returned an unexpected type")
        }
        return value
    }
    private func beginNewGeneration() {
        // Model the lifecycle boundary, including resetting depth, not its policy.
        glazeWebViewGeneration = UUID()
        glazeContextTask?.cancel()
        glazeContextTask = nil
        glazeContextTaskID = UUID()
        glazeContextOwner = ""
        glazeContextPrepared = false
        glazeIdentityFingerprint = ""
        glazeContextPreparationDepth = 0
        glazeContextNeedsRefresh = false
    }
    private static func check(_ value: @autoclosure () -> Bool, _ label: String) throws {
        guard value() else { throw CheckFailure.failed(label) }
    }
    private static func fresh(gated: Bool = false) throws -> HostProbe {
        try WevVGlazeSessionRepository.pastryTrailDiary.reset()
        WevVGlazeSessionStore.shared.reset()
        let host = HostProbe()
        host.glazeEntry.requiresFullFeatures = gated
        return host
    }
    private static func waitForCalls(_ count: Int) async throws {
        for _ in 0..<10_000 {
            if WevVGlazeSessionRepository.pastryTrailDiary.calls == count { return }
            await Task.yield()
        }
        throw CheckFailure.failed("Expected preparation was not started")
    }
    private static func rejected(_ task: Task<[String: Any], Error>, code: String? = nil) async throws {
        do {
            _ = try await task.value
            throw CheckFailure.failed("A stale or forbidden context was accepted")
        } catch let error as CheckFailure { throw error }
        catch {
            if let code {
                guard case GlazeFailure.code(let actual) = error, actual == code else {
                    throw CheckFailure.failed("A context failed with an unexpected error category")
                }
            }
        }
    }
    private static func prime(_ host: HostProbe) async throws {
        host.startGlazeContextTask()
        let request = Task { try await host.request() }
        try await waitForCalls(1)
        try WevVGlazeSessionRepository.pastryTrailDiary.complete(1)
        _ = try await request.value
        try check(host.glazeContextPrepared && host.glazeContextPreparationDepth == 0, "Initial preparation did not settle")
    }

    static func run() async throws {
        let repository = WevVGlazeSessionRepository.pastryTrailDiary
        let store = WevVGlazeSessionStore.shared

        do {
            let host = try fresh()
            host.startGlazeContextTask()
            let first = Task { try await host.request() }
            let second = Task { try await host.request() }
            try await waitForCalls(1)
            for _ in 0..<20 { await Task.yield() }
            try check(repository.calls == 1, "Concurrent requests duplicated entry preparation")
            try repository.complete(1)
            _ = try await first.value; _ = try await second.value
            _ = try await host.request()
            try check(repository.calls == 1 && host.glazeContextTask != nil && host.glazeContextPreparationDepth == 0,
                      "Successful repeated getContext did not reuse its prepared result")
            print("PASS: entry and concurrent getContext share one preparation; successful requests reuse it")
        }
        do {
            let host = try fresh(); try await prime(host)
            store.needsGlazeRenewal = true
            let renewed = Task { try await host.request() }
            try await waitForCalls(2)
            store.needsGlazeRenewal = false
            try repository.complete(2)
            _ = try await renewed.value; _ = try await host.request()
            try check(repository.calls == 2, "Renewal did not replace and then reuse the context")
            print("PASS: renewal refreshes once and caches the renewed context")
        }
        do {
            let host = try fresh(); try await prime(host)
            store.currentGlazeCredentials?.brownButterGlaze = "fixture-access-b"
            let rotated = Task { try await host.request() }
            try await waitForCalls(2)
            try repository.complete(2)
            _ = try await rotated.value; _ = try await host.request()
            try check(repository.calls == 2, "Credential rotation did not legitimately refresh context")
            print("PASS: changed credentials trigger a fresh preparation")
        }
        do {
            let host = try fresh()
            let failed = Task { try await host.request() }
            try await waitForCalls(1); try repository.complete(1, fail: true)
            try await rejected(failed)
            try check(host.glazeContextTask == nil && !host.glazeContextPrepared && host.glazeContextPreparationDepth == 0,
                      "Failed preparation left a cached task or unbalanced depth")
            let retried = Task { try await host.request() }
            try await waitForCalls(2); try repository.complete(2)
            _ = try await retried.value
            print("PASS: failed preparations are cleared and can be retried")
        }
        for change in ["account", "environment", "epoch"] {
            let host = try fresh()
            let stale = Task { try await host.request() }
            try await waitForCalls(1)
            switch change {
            case "account": store.currentGlazeCredentials = FixtureCredentials(vanillaBeanIcing: 202, brownButterGlaze: "fixture-access-b")
            case "environment": store.activeEnvironmentID = "fixture-scope-next"
            default: store.sessionEpoch += 1
            }
            try repository.complete(1)
            try await rejected(stale)
            try check(host.glazeContextTask == nil && !host.glazeContextPrepared,
                      "Changed session ownership cached an old context")
            let current = Task { try await host.request() }
            try await waitForCalls(2); try repository.complete(2)
            _ = try await current.value
        }
        print("PASS: account, environment and epoch changes reject old results and recover")
        do {
            let host = try fresh()
            host.startGlazeContextTask()
            guard let stale = host.glazeContextTask else { throw CheckFailure.failed("Entry preparation task was not installed") }
            try await waitForCalls(1)
            store.currentGlazeCredentials?.brownButterGlaze = "fixture-access-b"
            try repository.complete(1)
            try await rejected(stale, code: "NATIVE_FAILED")
            try check(host.glazeContextTask == nil && !host.glazeContextPrepared,
                      "A preparation cached a token that drifted while it was running")
            let current = Task { try await host.request() }
            try await waitForCalls(2); try repository.complete(2)
            _ = try await current.value
            print("PASS: credentials drifting during preparation cannot become a cached context")
        }
        do {
            let host = try fresh()
            host.onContextReady = { store.currentGlazeCredentials?.brownButterGlaze = "fixture-access-b" }
            let stale = Task { try await host.request() }
            try await waitForCalls(1); try repository.complete(1)
            try await rejected(stale, code: "NATIVE_FAILED")
            try check(host.glazeContextTask == nil && !host.glazeContextPrepared,
                      "Final context delivery kept a stale completed task")
            let current = Task { try await host.request() }
            try await waitForCalls(2); try repository.complete(2)
            _ = try await current.value
            print("PASS: delivery-time credential drift invalidates only its matching task")
        }
        do {
            let host = try fresh()
            let old = Task { try await host.request() }
            try await waitForCalls(1)
            host.beginNewGeneration()
            let current = Task { try await host.request() }
            try await waitForCalls(2)
            for _ in 0..<20 { await Task.yield() }
            let newID = host.glazeContextTaskID
            let newDepth = host.glazeContextPreparationDepth
            try check(newDepth == 2, "New generation did not start its request and preparation")
            try repository.complete(1)
            try await rejected(old)
            try check(host.glazeContextTaskID == newID && host.glazeContextTask != nil &&
                      host.glazeContextPreparationDepth == newDepth && !host.glazeContextPrepared,
                      "Old generation cleared the new task or reduced its preparation depth")
            try repository.complete(2)
            _ = try await current.value
            try check(host.glazeContextPreparationDepth == 0 && host.glazeContextPrepared,
                      "New generation did not finish independently")
            print("PASS: late old-generation completion cannot clear new work or reduce its depth")
        }
        do {
            let host = try fresh()
            host.startGlazeContextTask()
            guard let cancelled = host.glazeContextTask else { throw CheckFailure.failed("Initial entry task was not installed") }
            // Stay on MainActor without yielding: neither task has entered yet.
            host.beginNewGeneration()
            host.startGlazeContextTask()
            guard let current = host.glazeContextTask else { throw CheckFailure.failed("Replacement entry task was not installed") }
            let newID = host.glazeContextTaskID
            try await waitForCalls(1)
            for _ in 0..<20 { await Task.yield() }
            try check(repository.calls == 1 && host.glazeContextPreparationDepth == 1,
                      "An entry cancelled before starting still prepared credentials or changed new depth")
            try repository.complete(1)
            _ = try await current.value
            try await rejected(cancelled)
            try check(repository.calls == 1 && host.glazeContextTaskID == newID && host.glazeContextPrepared &&
                      host.glazeContextPreparationDepth == 0,
                      "A pre-start cancellation interfered with the replacement preparation")
            print("PASS: entries cancelled before starting never prepare credentials or alter replacement depth")
        }
        do {
            let host = try fresh(gated: true)
            let forbidden = Task { try await host.request() }
            try await waitForCalls(1); try repository.complete(1, fullFeatures: false)
            try await rejected(forbidden, code: "FEATURE_UNAVAILABLE")
            try check(host.glazeContextTask == nil && !host.glazeContextPrepared,
                      "A restricted entry cached disabled features")
            let permitted = Task { try await host.request() }
            try await waitForCalls(2); try repository.complete(2, fullFeatures: true)
            _ = try await permitted.value
            print("PASS: restricted entries enforce fullFeaturesEnabled and can recover")
        }
        do {
            let host = try fresh()
            host.glazeIsStandby = true
            let forbidden = Task { try await host.request() }
            try await rejected(forbidden, code: "INVALID_PARAMS")
            try check(repository.calls == 0 && host.glazeContextTask == nil && host.glazeContextPreparationDepth == 0,
                      "Standby started a credential preparation")
            print("PASS: idle standby cannot request credentials")
        }
    }
}

@main private struct Main {
    static func main() async {
        do { try await HostProbe.run() }
        catch CheckFailure.failed(let message) { print("FAIL: " + message); exit(1) }
        catch { print("FAIL: unexpected controlled probe error"); exit(1) }
    }
}
'''


def main():
    swift = probe_source(SOURCE.read_text())
    with tempfile.TemporaryDirectory(prefix="wevv-h5-context-probe-", dir="/private/tmp") as directory:
        root = Path(directory)
        generated, executable = root / "ContextProbe.swift", root / "ContextProbe"
        generated.write_text(swift)
        result = subprocess.run(
            ["xcrun", "swiftc", "-swift-version", "5", "-default-isolation", "MainActor", "-parse-as-library",
             "-module-cache-path", str(root / "module-cache"), str(generated), "-o", str(executable)],
            text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, timeout=60,
        )
        if result.returncode:
            # Diagnostics can quote source. Emit only the compiler's error text.
            errors = [line.split("error:", 1)[1].strip() for line in result.stderr.splitlines() if "error:" in line]
            raise RuntimeError("Context probe compilation failed" + (": " + "; ".join(errors) if errors else ""))
        result = subprocess.run([str(executable)], text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, timeout=30)
        if result.stdout:
            print(result.stdout, end="")
        if result.returncode:
            raise RuntimeError("Shipping context regression probe failed")


if __name__ == "__main__":
    try:
        main()
    except (RuntimeError, ValueError, subprocess.TimeoutExpired) as error:
        raise SystemExit(str(error))

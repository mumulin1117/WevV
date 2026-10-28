#!/usr/bin/env python3
"""Execute shipping H5 lifecycle methods with offline UIKit/WebKit boundaries.

Product timers are unchanged. Only generated test-copy sleeps are compressed.
No device, business endpoint, credentials, application defaults or Keychain.
"""
from pathlib import Path
import argparse
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'WevSweetgd/WevSweetgd/UKGlazeActortroller.swift'


def method(source, marker):
    start = source.index(marker)
    opening = source.index('{', start)
    depth = 0
    for index in range(opening, len(source)):
        if source[index] == '{':
            depth += 1
        elif source[index] == '}':
            depth -= 1
            if not depth:
                return source[start:index + 1]
    raise ValueError('Unclosed method: ' + marker)


BOUNDARIES = r'''
import Foundation
import CoreFoundation
struct Bounds { var width: Double; var height: Double; static let zero = Bounds(width: 0, height: 0) }
@MainActor final class UIApplication {
    enum State { case active, inactive, background }
    static let shared = UIApplication()
    var applicationState = State.active
}
struct Constraint {}
struct Anchor { func constraint(equalTo: Anchor) -> Constraint { Constraint() } }
enum NSLayoutConstraint { static func activate(_ constraints: [Constraint]) {} }
@MainActor final class View: NSObject {
    var window: NSObject? = NSObject()
    var bounds = Bounds(width: 390, height: 844)
    var translatesAutoresizingMaskIntoConstraints = false
    let topAnchor = Anchor(), leadingAnchor = Anchor(), trailingAnchor = Anchor(), bottomAnchor = Anchor()
    var removalCount = 0
    func addSubview(_ view: View) {}
    func removeFromSuperview() { removalCount += 1 }
}
@MainActor final class Navigation { var isBeingDismissed = false }
@MainActor class AppearanceBoundary {
    let view = View()
    var viewIfLoaded: View? { view }
    var presentedViewController: NSObject?
    var isBeingDismissed = false
    var isMovingFromParent = false
    var navigationController: Navigation?
    var appearanceCalls = 0
    var disappearanceCalls = 0
    var layoutCalls = 0
    func viewDidAppear(_ animated: Bool) { appearanceCalls += 1 }
    func viewWillDisappear(_ animated: Bool) {}
    func viewDidDisappear(_ animated: Bool) { disappearanceCalls += 1 }
    func viewDidLayoutSubviews() { layoutCalls += 1 }
}
@MainActor final class WKWebView {
    var snapshot: View?
    func snapshotView(afterScreenUpdates: Bool) -> View? { snapshot }
}
@MainActor final class UIAlertAction: NSObject {
    enum Style { case cancel, `default` }
    let title: String
    let handler: (UIAlertAction) -> Void
    init(title: String, style: Style, handler: @escaping (UIAlertAction) -> Void) {
        self.title = title; self.handler = handler
    }
}
@MainActor final class UIAlertController: NSObject {
    enum Style { case alert }
    let title: String
    var actions: [UIAlertAction] = []
    init(title: String, message: String, preferredStyle: Style) { self.title = title }
    func addAction(_ action: UIAlertAction) { actions.append(action) }
}
struct Frame { var isMainFrame = true; var request: URLRequest }
@MainActor struct WKScriptMessage {
    var webView: WKWebView?
    var frameInfo: Frame
    var body: Any
}
@MainActor final class Gate<Value> {
    private var continuation: CheckedContinuation<Value, Never>?
    private(set) var entered = false
    func wait() async -> Value {
        entered = true
        return await withCheckedContinuation { continuation = $0 }
    }
    func succeed(_ value: Value) { continuation!.resume(returning: value); continuation = nil }
}
struct Entry { var bridgeEntry: [String: Any]? = ["path": "/messages", "query": [:]] }
@MainActor final class Host: AppearanceBoundary {
    enum GlazeFailure: Error { case code(String) }
    static let fixtureFolder = URL(fileURLWithPath: "/private/tmp/offline-h5-lifecycle", isDirectory: true)
    static var resourceHandler: (() async -> URL?)?
    static var discards = 0
    static func discardGlazeStandby() { discards += 1 }
    static func prepareGlazeResources() async -> URL? {
        if let resourceHandler { return await resourceHandler() }
        return fixtureFolder
    }
    var glazeEntry = Entry()
    var glazeIsStandby = false
    var glazeUsesIdleEntry = true
    var glazeIdleReady = true
    var glazeOpenEntrySent = false
    var glazeEntryActivationTask: Task<Void, Never>?
    var glazeLoadingTimeoutTask: Task<Void, Never>?
    var glazeBlankPageTimeoutTask: Task<Void, Never>?
    var glazeFirstPaint = false
    var glazeContentVisible = false
    var glazePendingError: String?
    var glazeErrorPresentationTask: Task<Void, Never>?
    var glazeExiting = false
    var glazeExitRequested = false
    var glazeSDKClosing = false
    var glazeExitTarget = 0
    var glazeVisible = true
    var glazePresentationReady = true
    var glazeRetainedFrame: View?
    var glazeNativeCloseTask: Task<Void, Never>?
    var glazeErrorView: NSObject?
    var glazeWebViewGeneration = UUID()
    var glazeDocumentLoaded = true
    var glazeContextDelivered = false
    var tastingWebView: WKWebView? = WKWebView()
    var tastingBundleURL: URL? = fixtureFolder
    var glazeProcessCrashDates: [Date] = []
    var traces: [String] = []
    var errors: [String] = []
    var commands: [(name: String, params: [String: Any], timeout: Double)] = []
    var commandHandler: (() async throws -> [String: Any]?)?
    var visibilityPublishes = 0
    var overlayDepth = 0
    var rebuilds = 0
    var teardowns = 0
    var exits: [Int] = []
    func traceGlazeLoad(_ stage: String) { traces.append(stage) }
    func publishGlazeVisibility() { visibilityPublishes += 1 }
    func sendGlazeCommand(_ name: String, params: [String: Any] = [:], timeout: Double = 15) async throws -> [String: Any]? {
        commands.append((name, params, timeout))
        if let commandHandler { return try await commandHandler() }
        return ["opened": true]
    }
    func warmTastingParlor() { rebuilds += 1; tastingWebView = WKWebView() }
    func performGlazeExit(target: Int) { exits.append(target); glazeExiting = true }
    func tearDownGlaze() { teardowns += 1; tastingWebView = nil; glazeWebViewGeneration = UUID(); cancelTasks() }
    func applyGlazeNavigation(_ target: Int) {}
    func beginGlazeNativeOverlay() { overlayDepth += 1 }
    func finishGlazeNativeOverlay() { overlayDepth = max(0, overlayDepth - 1) }
    func present(_ controller: UIAlertController, animated: Bool) { presentedViewController = controller }
    func chooseReleaseAction(_ title: String) throws {
        guard let alert = presentedViewController as? UIAlertController,
              let action = alert.actions.first(where: { $0.title == title }) else {
            throw NSError(domain: "MissingReleaseAction", code: 1)
        }
        presentedViewController = nil
        action.handler(action)
    }
    func cancelTasks() {
        glazeEntryActivationTask?.cancel(); glazeEntryActivationTask = nil
        glazeLoadingTimeoutTask?.cancel(); glazeLoadingTimeoutTask = nil
        glazeBlankPageTimeoutTask?.cancel(); glazeBlankPageTimeoutTask = nil
        glazeErrorPresentationTask?.cancel(); glazeErrorPresentationTask = nil
        glazeNativeCloseTask?.cancel(); glazeNativeCloseTask = nil
    }
    func paint(_ visible: Bool, generation: UUID? = nil, webView: WKWebView? = nil) {
        receiveGlazeFirstPaint(WKScriptMessage(webView: webView ?? tastingWebView,
            frameInfo: Frame(request: URLRequest(url: Self.fixtureFolder.appendingPathComponent("index.html"))),
            body: ["generation": (generation ?? glazeWebViewGeneration).uuidString, "visible": visible]))
    }
'''

TESTS = r'''
    static var caseCount = 0
    static func verify(_ name: String, _ body: (Host) async throws -> Void) async throws {
        UIApplication.shared.applicationState = .active
        resourceHandler = nil
        let host = Host()
        defer { host.cancelTasks(); resourceHandler = nil; UIApplication.shared.applicationState = .active }
        try await body(host)
        caseCount += 1
        print("PASS " + name)
    }
    static func check(_ condition: Bool, _ label: String) throws {
        if !condition { throw NSError(domain: "H5LifecycleRegression", code: 1, userInfo: [NSLocalizedDescriptionKey: label]) }
    }
    static func pause(_ milliseconds: UInt64) async { try? await Task.sleep(nanoseconds: milliseconds * 1_000_000) }
    static func until(_ label: String, _ condition: () -> Bool) async throws {
        for _ in 0..<1500 { if condition() { return }; await pause(1) }
        throw NSError(domain: "H5LifecycleTimeout", code: 2, userInfo: [NSLocalizedDescriptionKey: label])
    }
    static func run() async throws {
        try await verify("blank-content-cancels-and-later-blank-restarts") { h in
            h.monitorGlazeBlankPage()
            try check(h.glazeBlankPageTimeoutTask != nil, "initial blank must arm a deadline")
            await pause(8); h.paint(true)
            try check(h.glazeFirstPaint && h.glazeContentVisible && h.glazeBlankPageTimeoutTask == nil, "real content cancels blank deadline")
            await pause(65)
            try check(h.errors.isEmpty, "cancelled blank deadline must not report failure")
            h.paint(false)
            try check(h.glazeBlankPageTimeoutTask != nil, "content disappearing must arm a new deadline")
            try await until("reblank failure") { h.errors.count == 1 }
            try check(h.errors[0].contains("displayed"), "reblank reports the existing failure UI")
        }
        try await verify("blank-cannot-arm-while-idle-hidden-background-or-closing") { h in
            let states: [(Host) -> Void] = [
                { $0.glazeIsStandby = true }, { $0.glazeVisible = false }, { $0.view.window = nil },
                { _ in UIApplication.shared.applicationState = .background }, { $0.glazeSDKClosing = true },
                { $0.glazeExiting = true }, { $0.glazeRetainedFrame = View() },
                { $0.glazeNativeCloseTask = Task { await pause(100) } }, { $0.glazeErrorView = NSObject() },
                { $0.glazePendingError = "queued" }, { $0.glazeContentVisible = true }
            ]
            for state in states {
                let p = Host(); state(p); p.monitorGlazeBlankPage()
                try check(p.glazeBlankPageTimeoutTask == nil, "suppressed state must not create a blank timer")
                p.cancelTasks(); UIApplication.shared.applicationState = .active
            }
            try check(h.errors.isEmpty, "suppression has no presentation side effects")
        }
        try await verify("blank-rechecks-visibility-background-and-close-at-expiry") { _ in
            for state: (Host) -> Void in [{ $0.glazeVisible = false }, { _ in UIApplication.shared.applicationState = .background }, { $0.glazeSDKClosing = true }, { $0.view.window = nil }] {
                let h = Host(); h.monitorGlazeBlankPage(); state(h)
                await pause(65)
                try check(h.errors.isEmpty, "condition changing during deadline suppresses failure")
                h.cancelTasks(); UIApplication.shared.applicationState = .active
            }
        }
        try await verify("old-generation-blank-callback-is-inert") { h in
            h.monitorGlazeBlankPage(); let old = h.glazeBlankPageTimeoutTask
            h.glazeWebViewGeneration = UUID()
            let replacement = Task { await pause(500) }
            h.glazeBlankPageTimeoutTask = replacement
            await old?.value
            try check(h.errors.isEmpty && h.glazeBlankPageTimeoutTask != nil, "old generation cannot present or clear a replacement timer")
        }
        try await verify("stale-and-foreign-paint-events-are-rejected") { h in
            h.monitorGlazeBlankPage()
            h.paint(true, generation: UUID()); h.paint(true, webView: WKWebView())
            try check(!h.glazeContentVisible && !h.glazeFirstPaint && h.glazeBlankPageTimeoutTask != nil, "foreign paint cannot mark current page ready")
            h.paint(true)
            try check(h.glazeContentVisible && h.glazeBlankPageTimeoutTask == nil, "matching frame can become visible")
        }
        try await verify("pending-error-is-delivered-after-overlay-disappears") { h in
            h.presentedViewController = NSObject()
            h.showGlazeError("first"); h.showGlazeError("latest")
            await pause(30)
            try check(h.errors.isEmpty && h.glazePendingError == "latest", "existing modal queues the latest failure")
            h.presentedViewController = nil
            try await until("queued presentation") { h.errors == ["latest"] }
            try check(h.glazePendingError == nil && h.glazeErrorPresentationTask == nil, "presented failure clears its polling task")
            h.showGlazeError("second cycle"); h.presentedViewController = nil
            try await until("second queued presentation") { h.errors == ["latest", "second cycle"] }
        }
        try await verify("pending-error-waits-for-presentation-transition") { h in
            h.glazePresentationReady = false
            h.showGlazeError("transition pending")
            await pause(30)
            try check(h.errors.isEmpty && h.glazePendingError == "transition pending", "present transition cannot show an alert early")
            h.glazePresentationReady = true
            try await until("transition completion presentation") { h.errors == ["transition pending"] }
            try check(h.glazePendingError == nil, "ready presentation drains the queued error")
        }
        try await verify("pending-error-waits-for-foreground-and-window") { h in
            h.view.window = nil; UIApplication.shared.applicationState = .background
            h.showGlazeError("deferred")
            await pause(30); try check(h.errors.isEmpty, "unmounted background host cannot present")
            UIApplication.shared.applicationState = .active; h.view.window = NSObject()
            try await until("foreground presentation") { h.errors == ["deferred"] }
        }
        try await verify("old-generation-error-queue-is-inert") { h in
            h.presentedViewController = NSObject(); h.queueGlazeError("old")
            let old = h.glazeErrorPresentationTask
            h.glazeWebViewGeneration = UUID(); h.glazePendingError = "new"
            h.presentedViewController = nil
            await old?.value
            try check(h.errors.isEmpty && h.glazePendingError == "new", "old queue cannot present a new generation's pending notice")
        }
        try await verify("idle-activation-requires-mount-and-nonzero-layout") { h in
            h.view.window = nil; h.activateGlazeIdleEntry()
            try check(h.glazeEntryActivationTask == nil && !h.glazeOpenEntrySent, "detached idle cannot activate")
            h.view.window = NSObject(); h.view.bounds = .zero; h.viewDidLayoutSubviews()
            try check(h.glazeEntryActivationTask == nil, "zero-sized layout cannot activate")
            h.view.bounds = Bounds(width: 390, height: 844)
            h.viewDidLayoutSubviews(); h.viewDidAppear(false); h.viewDidLayoutSubviews()
            await h.glazeEntryActivationTask?.value
            try check(h.commands.count == 1 && h.commands[0].name == "openEntry" && h.commands[0].timeout == 65, "layout and appearance share one activation with contract timeout")
            h.viewDidAppear(false); h.viewDidLayoutSubviews(); await pause(5)
            try check(h.commands.count == 1, "repeated appearance never resends openEntry")
        }
        try await verify("idle-activation-rechecks-mount-after-resource-await") { h in
            let gate = Gate<URL?>(); resourceHandler = { await gate.wait() }
            h.activateGlazeIdleEntry(); try await until("resource entered") { gate.entered }
            h.view.window = nil; gate.succeed(fixtureFolder)
            await h.glazeEntryActivationTask?.value
            try check(h.commands.isEmpty && !h.glazeOpenEntrySent, "detachment while waiting cannot consume activation")
            resourceHandler = nil; h.view.window = NSObject(); h.viewDidLayoutSubviews()
            await h.glazeEntryActivationTask?.value
            try check(h.commands.count == 1, "reattached layout can retry unsent activation")
        }
        try await verify("old-generation-activation-cannot-send") { h in
            let gate = Gate<URL?>(); resourceHandler = { await gate.wait() }
            h.activateGlazeIdleEntry(); try await until("resource entered") { gate.entered }
            let old = h.glazeEntryActivationTask
            h.glazeWebViewGeneration = UUID(); h.glazeEntryActivationTask = nil
            gate.succeed(fixtureFolder); await old?.value
            try check(h.commands.isEmpty && h.errors.isEmpty && !h.glazeOpenEntrySent, "old activation cannot send or show a new-host error")
        }
        try await verify("activation-failure-keeps-existing-error-path") { h in
            h.commandHandler = { throw GlazeFailure.code("OFFLINE_FAILURE") }
            h.activateGlazeIdleEntry(); await h.glazeEntryActivationTask?.value
            try check(h.commands.count == 1 && h.errors.count == 1, "activation error is presented instead of silently hanging")
        }
        try await verify("closing-host-cannot-start-activation-or-new-error-queue") { _ in
            for close: (Host) -> Void in [{ $0.glazeSDKClosing = true }, { $0.glazeExitRequested = true }] {
                let h = Host(); close(h)
                h.activateGlazeIdleEntry(); h.showGlazeError("late failure"); h.queueGlazeError("late queue")
                h.glazePendingError = "preexisting"; h.presentPendingGlazeError()
                try check(h.commands.isEmpty && h.glazeEntryActivationTask == nil && h.errors.isEmpty && h.glazeErrorPresentationTask == nil,
                          "closing rejects activation and both immediate/queued entry errors")
                h.cancelTasks()
            }
        }
        try await verify("sdk-close-cancels-activation-waiting-for-resources") { h in
            let gate = Gate<URL?>(); resourceHandler = { await gate.wait() }
            h.activateGlazeIdleEntry(); try await until("resource entered") { gate.entered }
            let activation = h.glazeEntryActivationTask
            _ = try h.receiveFixtureNavigation(["target": 0, "reason": "sdk-close"])
            gate.succeed(fixtureFolder); await activation?.value
            try check(activation?.isCancelled == true && h.commands.isEmpty && !h.glazeOpenEntrySent && h.errors.isEmpty,
                      "close while resources prepare cannot send a late entry or entry failure")
            try check(h.exits.isEmpty, "sdk-close notification alone is not release confirmation")
        }
        try await verify("sdk-close-cancels-slow-activation-and-clears-old-pending-errors") { h in
            let gate = Gate<[String: Any]?>(); h.commandHandler = { await gate.wait() }
            h.activateGlazeIdleEntry(); try await until("openEntry entered") { gate.entered }
            let activation = h.glazeEntryActivationTask
            h.armGlazeLoadingTimeout(standby: false); h.monitorGlazeBlankPage()
            h.presentedViewController = NSObject(); h.showGlazeError("queued before close")
            try check(h.glazePendingError != nil && h.glazeErrorPresentationTask != nil, "fixture must contain a pending error")
            _ = try h.receiveFixtureNavigation(["target": 0, "reason": "sdk-close"])
            try check(activation?.isCancelled == true && h.glazeLoadingTimeoutTask == nil && h.glazeBlankPageTimeoutTask == nil &&
                      h.glazePendingError == nil && h.glazeErrorPresentationTask == nil,
                      "actual close helper cancels all entry observers and discards the old error queue")
            h.presentedViewController = nil; h.showGlazeError("late entry error"); h.queueGlazeError("late queued error")
            gate.succeed(nil); await activation?.value; await pause(30)
            try check(h.errors.isEmpty && h.glazePendingError == nil && h.exits.isEmpty,
                      "cancelled openEntry failure neither presents nor invents release confirmation")
        }
        try await verify("sdk-close-failed-does-not-revive-late-activation-failure") { h in
            h.glazeFirstPaint = true; h.glazeContentVisible = true
            let frame = View(); h.tastingWebView?.snapshot = frame
            let gate = Gate<[String: Any]?>(); h.commandHandler = { await gate.wait() }
            h.activateGlazeIdleEntry(); try await until("openEntry entered") { gate.entered }
            let activation = h.glazeEntryActivationTask
            _ = try h.receiveFixtureNavigation(["target": 0, "reason": "sdk-close"])
            try check(h.glazeRetainedFrame === frame, "close retains its actual snapshot boundary")
            _ = try h.receiveFixtureNavigation(["target": 0, "reason": "sdk-close-failed"])
            try check(!h.glazeSDKClosing && h.glazeRetainedFrame == nil && frame.removalCount == 1,
                      "failed release restores the visible host and removes its retained frame")
            gate.succeed(nil); await activation?.value; await pause(20)
            try check(h.errors.isEmpty && h.glazePendingError == nil && h.commands.count == 1,
                      "clearing SDKClosing must not revive the cancelled old openEntry failure")
            h.showGlazeError("genuine later failure")
            try check(h.errors == ["genuine later failure"], "failed close recovery must not suppress a genuinely new failure")
        }
        try await verify("sdk-close-failed-restores-unpainted-loading-and-blank-deadlines") { h in
            _ = try h.receiveFixtureNavigation(["target": 0, "reason": "sdk-close"])
            _ = try h.receiveFixtureNavigation(["target": 0, "reason": "sdk-close-failed"])
            try check(h.glazeLoadingTimeoutTask != nil && h.glazeBlankPageTimeoutTask != nil,
                      "failed close before first paint must restore both bounded failure monitors")
            h.paint(true); await pause(65)
            try check(h.errors.isEmpty && h.glazeLoadingTimeoutTask == nil && h.glazeBlankPageTimeoutTask == nil,
                      "new real content cancels the restored deadlines")
        }
        try await verify("sdk-close-failed-still-reports-persistent-real-blank") { h in
            h.glazeFirstPaint = true
            _ = try h.receiveFixtureNavigation(["target": 0, "reason": "sdk-close"])
            _ = try h.receiveFixtureNavigation(["target": 0, "reason": "sdk-close-failed"])
            try await until("restored blank timeout") { h.errors.count == 1 }
            try check(h.errors[0].contains("displayed"), "actual close failure cannot disable future blank-page recovery")
        }
        try await verify("native-close-cancels-entry-observer-but-awaits-actual-release") { h in
            let entryGate = Gate<[String: Any]?>(), closeGate = Gate<[String: Any]?>()
            h.commandHandler = {
                if h.commands.last?.name == "openEntry" { return await entryGate.wait() }
                return await closeGate.wait()
            }
            h.activateGlazeIdleEntry(); try await until("openEntry entered") { entryGate.entered }
            let activation = h.glazeEntryActivationTask
            h.requestNativeGlazeClose(); try await until("close command entered") { closeGate.entered }
            let close = h.glazeNativeCloseTask
            try check(activation?.isCancelled == true && close?.isCancelled == false && h.exits.isEmpty,
                      "entry observation is cancelled while the real SDK release command remains pending")
            entryGate.succeed(nil); await activation?.value
            try check(h.errors.isEmpty && h.exits.isEmpty, "cancelled entry result is neither an error nor a close ACK")
            closeGate.succeed(["released": true]); await close?.value
            try check(h.exits == [0] && h.presentedViewController == nil, "only actual released:true completes the native exit")
        }
        try await verify("native-release-failure-retains-existing-retry-and-cancel-recovery") { h in
            h.commandHandler = { ["released": false] }
            h.requestNativeGlazeClose(); await h.glazeNativeCloseTask?.value
            try check(h.exits.isEmpty && (h.presentedViewController as? UIAlertController)?.title == "Unable to close page",
                      "false release remains a genuine close failure rather than exiting silently")
            try h.chooseReleaseAction("Cancel")
            try check(!h.glazeExitRequested && h.overlayDepth == 0 && h.glazeLoadingTimeoutTask != nil && h.glazeBlankPageTimeoutTask != nil,
                      "cancel failed native close restores user control and entry monitors")
            h.paint(true); h.showGlazeError("new failure after cancel")
            try check(h.errors == ["new failure after cancel"], "normal error presentation works again after cancel")
        }
        try await verify("appearance-reparenting-never-destroys-current-webview") { h in
            let current = h.tastingWebView, generation = h.glazeWebViewGeneration
            h.isBeingDismissed = true; h.viewWillDisappear(false); h.viewDidDisappear(false)
            try check(!h.glazePresentationReady && !h.glazeVisible, "willDisappear marks presentation unavailable without destroying it")
            try check(h.tastingWebView === current && h.glazeWebViewGeneration == generation && h.teardowns == 0,
                      "transient UIKit disappearance must not tear down the newly claimed WebView")
            h.isBeingDismissed = false; h.viewDidAppear(false)
            await h.glazeEntryActivationTask?.value
            try check(h.tastingWebView === current && h.commands.count == 1 && h.glazePresentationReady && h.glazeVisible,
                      "didAppear restores readiness and keeps the same WebView usable after reparenting")
        }
        try await verify("dead-process-preserves-exit-intent") { h in
            h.glazeExitRequested = true; h.glazeExitTarget = 1
            h.webViewWebContentProcessDidTerminate(h.tastingWebView!)
            try check(h.exits == [1] && h.rebuilds == 0, "dead process during close exits rather than reopening")
        }
        try await verify("ordinary-process-crash-rebuilds-and-repeated-crash-errors") { h in
            h.webViewWebContentProcessDidTerminate(WKWebView())
            try check(h.rebuilds == 0, "foreign old WebView cannot recover current host")
            h.webViewWebContentProcessDidTerminate(h.tastingWebView!)
            h.webViewWebContentProcessDidTerminate(h.tastingWebView!)
            try check(h.rebuilds == 2 && h.errors.isEmpty, "ordinary crashes rebuild current entry")
            h.webViewWebContentProcessDidTerminate(h.tastingWebView!)
            try check(h.teardowns == 1 && h.errors.count == 1, "repeated crash ends at the existing native failure path")
        }
        try await verify("standby-process-crash-discards-without-business-entry") { h in
            let before = discards; h.glazeIsStandby = true
            h.webViewWebContentProcessDidTerminate(h.tastingWebView!)
            try check(discards == before + 1 && h.rebuilds == 0 && h.exits.isEmpty, "standby death discards only")
        }
        print("H5 lifecycle source regressions passed: \(caseCount)")
    }
}
@main struct LifecycleVerification {
    @MainActor static func main() async {
        do { try await Host.run() }
        catch {
            FileHandle.standardError.write(Data(("FAIL: " + (error as NSError).localizedDescription + "\n").utf8))
            exit(1)
        }
    }
}
'''


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--negative-disappearance-source', type=Path,
                        help="Also inject this baseline source's old disappearance method and require the appearance regression to fail")
    args = parser.parse_args()
    source = SOURCE.read_text()
    markers = ['private func monitorGlazeBlankPage()', 'private func presentPendingGlazeError()',
               'private func queueGlazeError(', 'private func receiveGlazeFirstPaint(',
               'private func activateGlazeIdleEntry()', 'private func isWithinGlazeBundle(',
               'private static func jsonBoolean(', 'private static func jsonInteger(',
               'private func cancelGlazeEntryPreparation()', 'private func resumeGlazeEntryMonitoring()',
               'private func armGlazeLoadingTimeout(', 'private func requestNativeGlazeClose(',
               'private func showGlazeReleaseFailure()', 'func webViewWebContentProcessDidTerminate(',
               'override func viewDidAppear(', 'override func viewWillDisappear(', 'override func viewDidLayoutSubviews(']
    if 'override func viewDidDisappear(' in source:
        markers.append('override func viewDidDisappear(')
    selected = [method(source, marker) for marker in markers]
    navigation_start = source.index('        case "host.setNavigation":', source.index('private func executeGlaze('))
    navigation_end = source.index('        case "host.close":', navigation_start)
    # Run the complete shipping switch arm. Only the outer method signature and
    # unrelated switch arms are bounded out of this offline platform fixture.
    selected.append('private func receiveFixtureNavigation(_ params: [String: Any]) throws -> Any {\n'
                    'switch "host.setNavigation" {\n' + source[navigation_start:navigation_end] +
                    'default: throw GlazeFailure.code("UNSUPPORTED_METHOD")\n}\n}')
    # Keep real error eligibility/queue/cancellation logic; UIKit presentation
    # itself is the controlled boundary, not a second copy of lifecycle logic.
    error = method(source, 'private func showGlazeError(')
    error = error[:error.index('        // A loaded, live process')] + '''        errors.append(glazeNotice)
        presentedViewController = NSObject()
    }
'''
    selected.append(error)
    implementation = '\n\n'.join(selected)
    implementation = implementation.replace('15 * 1_000_000_000', '40_000_000')
    implementation = implementation.replace('250_000_000', '8_000_000')
    implementation = implementation.replace('UInt64(standby ? 60 : 75) * 1_000_000_000', '100_000_000')
    with tempfile.TemporaryDirectory(prefix='wevv-h5-lifecycle-', dir='/private/tmp') as temporary:
        folder = Path(temporary)
        swift, executable = folder / 'Lifecycle.swift', folder / 'verify'
        swift.write_text(BOUNDARIES + implementation + TESTS)
        subprocess.run(['xcrun', 'swiftc', '-parse-as-library', '-swift-version', '5',
                        '-default-isolation', 'MainActor', '-module-cache-path', str(folder / 'modules'),
                        str(swift), '-o', str(executable)], check=True)
        subprocess.run([str(executable)], check=True, timeout=20)
        if args.negative_disappearance_source:
            legacy = method(args.negative_disappearance_source.read_text(), 'override func viewDidDisappear(')
            # The historical production method is injected only into this second
            # temporary executable. The shipping source is never modified.
            legacy_swift, legacy_executable = folder / 'LegacyDisappearance.swift', folder / 'legacy'
            legacy_swift.write_text(BOUNDARIES + implementation + "\n" + legacy + "\n" + TESTS)
            subprocess.run(['xcrun', 'swiftc', '-parse-as-library', '-swift-version', '5',
                            '-default-isolation', 'MainActor', '-module-cache-path', str(folder / 'modules'),
                            str(legacy_swift), '-o', str(legacy_executable)], check=True)
            failed = subprocess.run([str(legacy_executable)], text=True, capture_output=True, timeout=20)
            expected = 'transient UIKit disappearance must not tear down the newly claimed WebView'
            if failed.returncode == 0 or expected not in failed.stderr:
                raise AssertionError('Negative control did not fail at the appearance regression: ' + failed.stderr)
            print('PASS negative-control: legacy disappearance teardown is caught by the appearance regression')


if __name__ == '__main__':
    main()

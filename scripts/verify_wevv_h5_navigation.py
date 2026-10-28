#!/usr/bin/env python3
"""Run the shipping H5 navigation and exit methods against small UIKit doubles.

This exercises login gates, route rejection, account-isolated refreshes and the
actual container exit callback ordering. No network, simulator login or purchase
is performed. UIKit rendering/media remain part of device acceptance.
"""
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SOURCES = ROOT / 'WevSweetgd/WevSweetgd'


def main():
    navigation = (SOURCES / 'WevVGlazeH5Navigation.swift').read_text().replace('import UIKit', '')
    entry = (SOURCES / 'WevVGlazeH5Entry.swift').read_text().replace('import Foundation', '')
    host = (SOURCES / 'UKGlazeActortroller.swift').read_text()
    start = host.index('    private func performGlazeExit(target: Int) {')
    end = host.index('    private func showGlazeReleaseFailure()', start)
    exit_method = host[start:end]
    swift = r'''import Foundation

struct pearFilling: Sendable {
    enum Kind: Sendable { case blueberryCustard, voice }
    var lemonCurd: Kind = .voice
    var passionfruitMousse = "1"
    var glazeHostID: String?
    var limeJam: String?
    var pearCenter: String?
    var glazeIMAccount: String?
    var glazeFollowed: Bool?
}
@MainActor enum Events { static var values: [String] = [] }
@MainActor final class Gesture { var isEnabled = true }
@MainActor final class Transition {
    var completion: ((Any?) -> Void)?
    func animate(alongsideTransition: ((Any?) -> Void)?, completion: @escaping (Any?) -> Void) {
        self.completion = completion
    }
}
@MainActor class UIViewController {
    var presentedViewController: UIViewController?
    weak var presentingViewController: UIViewController?
    weak var navigationController: UINavigationController?
    var presentationCount = 0
    var dismissalCount = 0
    var deferDismissal = false
    var dismissalCompletions: [() -> Void] = []
    func present(_ controller: UIViewController, animated: Bool) {
        presentationCount += 1
        presentedViewController = controller
        controller.presentingViewController = self
        Events.values.append("present")
    }
    func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        dismissalCount += 1
        let finish = { [self] in
            // UIKit dismisses a controller's presented child first. Thus a
            // host owning an alert cannot dismiss itself by calling dismiss.
            let dismissed = self.presentedViewController ?? (self.presentingViewController != nil ? self : nil)
            dismissed?.presentingViewController?.presentedViewController = nil
            var next = dismissed
            while let controller = next {
                next = controller.presentedViewController
                controller.presentedViewController = nil
                controller.presentingViewController = nil
            }
            Events.values.append("dismissed")
            completion?()
        }
        if deferDismissal { dismissalCompletions.append(finish) }
        else { finish() }
    }
}
@MainActor final class UINavigationController: UIViewController {
    var viewControllers: [UIViewController] = []
    var interactivePopGestureRecognizer: Gesture? = Gesture()
    var transitionCoordinator: Transition?
    var topViewController: UIViewController? { viewControllers.last }
    var pops = 0
    func popViewController(animated: Bool) {
        pops += 1
        viewControllers.removeLast()
        Events.values.append("popped")
    }
}
@MainActor final class UIAlertAction {
    enum Style { case `default` }
    init(title: String, style: Style) {}
}
@MainActor final class UIAlertController: UIViewController {
    enum Style { case alert }
    init(title: String, message: String, preferredStyle: Style) { super.init() }
    func addAction(_ action: UIAlertAction) {}
}
@MainActor final class UBakerytropicalMangoEssence: UIViewController {
    var onWevvDonutReady: (() -> Void)?
}
@MainActor final class WevVGlazeSessionStore {
    static let shared = WevVGlazeSessionStore()
    var isTasterReady = true
    var sessionEpoch = 7
    var activeEnvironmentID = "formal"
}
@MainActor final class WevVGlazeSessionRepository {
    static let pastryTrailDiary = WevVGlazeSessionRepository()
    enum Failure: Error { case unavailable }
    var refreshes = 0
    var invalidations = 0
    var pause = false
    var fails = false
    var pending: CheckedContinuation<Void, Never>?
    func coldBrewTasting() async throws -> Bool {
        refreshes += 1
        Events.values.append("refresh.started")
        if pause { await withCheckedContinuation { pending = $0 } }
        if fails { throw Failure.unavailable }
        Events.values.append("refresh.finished")
        return true
    }
    func finishRefresh() { let value = pending; pending = nil; value?.resume() }
    func invalidateH5Authentication() {
        invalidations += 1
        Events.values.append("invalidated")
        WevVGlazeSessionStore.shared.isTasterReady = false
        WevVGlazeSessionStore.shared.sessionEpoch += 1
    }
}
''' + entry + r'''
@MainActor final class UKGlazeActortroller: UIViewController {
    static func entryController(for entry: WevVGlazeH5Entry) -> UKGlazeActortroller? { UKGlazeActortroller(entry: entry) }
    static func prewarmGlazeWebView() {}
    let entry: WevVGlazeH5Entry
    var onGlazeClosed: (() -> Void)?
    private var glazeCloseCompletionDelivered = false
    private var glazeExiting = false
    private var glazeExitTarget = 0
    var glazePreviousPopEnabled: Bool?
    var teardownCount = 0
    var teardownPresentationStates: [Bool] = []
    init(entry: WevVGlazeH5Entry) { self.entry = entry; super.init() }
    func close(target: Int = 0) { performGlazeExit(target: target) }
    func applyGlazeNavigation(_ target: Int) { Events.values.append("navigation.disabled") }
    func tearDownGlaze() {
        teardownCount += 1
        teardownPresentationStates.append(presentingViewController != nil || presentedViewController != nil)
        Events.values.append("teardown")
    }
''' + exit_method + r'''
}
''' + navigation + r'''
@main @MainActor struct NavigationProbe {
    static var checks = 0
    static let store = WevVGlazeSessionStore.shared
    static let repository = WevVGlazeSessionRepository.pastryTrailDiary
    static func expect(_ value: @autoclosure () -> Bool, _ description: String) {
        guard value() else { fatalError("FAIL: " + description) }
        checks += 1
    }
    static func reset() {
        precondition(repository.pending == nil)
        store.isTasterReady = true
        store.sessionEpoch = 7
        store.activeEnvironmentID = "formal"
        repository.refreshes = 0
        repository.invalidations = 0
        repository.pause = false
        repository.fails = false
        Events.values = []
    }
    static func drain() async { for _ in 0..<20 { await Task.yield() } }
    static func waitForRefresh() async {
        for _ in 0..<200 {
            if repository.pending != nil { return }
            await Task.yield()
        }
        fatalError("Refresh did not enter the deterministic suspension point")
    }
    static func open(_ proposedPresenter: UIViewController? = nil, onClose: (() -> Void)? = nil) -> (UIViewController, UKGlazeActortroller) {
        let presenter = proposedPresenter ?? UIViewController()
        WevVGlazeH5Navigation.present(.messages, from: presenter, onClose: onClose)
        guard let host = presenter.presentedViewController as? UKGlazeActortroller else { fatalError("Missing H5 host") }
        return (presenter, host)
    }
    static func main() async {
        reset()
        let blocked = UIViewController()
        blocked.present(UIViewController(), animated: false)
        WevVGlazeH5Navigation.present(.messages, from: blocked)
        expect(blocked.presentationCount == 1, "An existing modal prevents duplicate presentation")

        reset()
        let invalid = UIViewController()
        WevVGlazeH5Navigation.present(.user(userID: "0", imAccount: nil), from: invalid)
        expect(invalid.presentedViewController is UIAlertController, "Invalid business IDs show the existing alert")
        expect(repository.refreshes == 0, "Invalid entries do not prepare sessions")

        reset()
        store.isTasterReady = false
        let guest = UIViewController()
        WevVGlazeH5Navigation.present(.messages, from: guest)
        guard let gate = guest.presentedViewController as? UBakerytropicalMangoEssence else { fatalError("Missing login gate") }
        expect(repository.refreshes == 0, "Guests enter the native welcome without session refresh")
        gate.onWevvDonutReady?()
        expect(guest.presentedViewController == nil && guest.presentationCount == 1, "Login completion dismisses the gate without automatic H5 presentation")

        reset()
        var successfulCallbacks = 0
        let (presenter, success) = open(onClose: {
            successfulCallbacks += 1
            Events.values.append("callback")
        })
        presenter.deferDismissal = true
        success.close()
        success.close()
        expect(presenter.dismissalCount == 1 && presenter.dismissalCompletions.count == 1 && success.dismissalCount == 0, "Repeated close starts one dismissal from the modal presenter")
        expect(success.teardownCount == 0 && successfulCallbacks == 0, "The close callback waits for dismissal completion")
        let modalCompletion = presenter.dismissalCompletions[0]
        modalCompletion()
        modalCompletion()
        await drain()
        expect(presenter.presentedViewController == nil && success.teardownCount >= 1, "Modal dismissal releases the host before callback")
        expect(successfulCallbacks == 1 && repository.refreshes == 1 && success.onGlazeClosed == nil, "A duplicate UIKit completion cannot repeat the refresh or callback")
        expect(Events.values.firstIndex(of: "teardown")! < Events.values.firstIndex(of: "refresh.started")! && Events.values.firstIndex(of: "refresh.finished")! < Events.values.firstIndex(of: "callback")!, "Teardown precedes refresh and refreshed data precedes native callbacks")

        reset()
        var alertCallbacks = 0
        let (alertPresenter, alertHost) = open(onClose: { alertCallbacks += 1 })
        let ownedAlert = UIAlertController(title: "Offline", message: "Try again", preferredStyle: .alert)
        alertHost.present(ownedAlert, animated: false)
        alertPresenter.deferDismissal = true
        alertHost.close()
        alertHost.close()
        expect(alertPresenter.dismissalCount == 1 && alertHost.dismissalCount == 0 && ownedAlert.dismissalCount == 0, "An alert-owning host closes through its presenting root")
        expect(alertPresenter.presentedViewController === alertHost && alertHost.presentedViewController === ownedAlert && ownedAlert.presentingViewController === alertHost, "Both modal layers remain intact until dismissal completes")
        expect(alertHost.teardownCount == 0 && alertCallbacks == 0 && repository.refreshes == 0, "No resources or native callbacks are released while host and alert remain presented")
        alertPresenter.dismissalCompletions[0]()
        await drain()
        expect(alertPresenter.presentedViewController == nil && alertHost.presentingViewController == nil && alertHost.presentedViewController == nil && ownedAlert.presentingViewController == nil, "Root dismissal removes both the H5 host and its alert")
        expect(alertHost.teardownPresentationStates == [false] && alertCallbacks == 1 && repository.refreshes == 1, "Teardown and callback happen once after the entire modal hierarchy is removed")

        for change in ["epoch", "environment", "logout"] {
            reset()
            var callbacks = 0
            let (_, page) = open(onClose: { callbacks += 1 })
            if change == "epoch" { store.sessionEpoch += 1 }
            if change == "environment" { store.activeEnvironmentID = "other" }
            if change == "logout" { store.isTasterReady = false }
            page.close()
            await drain()
            expect(repository.refreshes == 0 && callbacks == 0, "A \(change) before close rejects stale refresh/callback")
        }

        reset()
        var queuedCallbacks = 0
        let (_, queued) = open(onClose: { queuedCallbacks += 1 })
        queued.close()
        store.sessionEpoch += 1
        await drain()
        expect(repository.refreshes == 0 && queuedCallbacks == 0, "An account change before the scheduled Task executes rejects the refresh")

        for change in ["epoch", "environment", "logout"] {
            reset()
            repository.pause = true
            var callbacks = 0
            let (_, page) = open(onClose: { callbacks += 1 })
            page.close()
            await waitForRefresh()
            if change == "epoch" { store.sessionEpoch += 1 }
            if change == "environment" { store.activeEnvironmentID = "other" }
            if change == "logout" { store.isTasterReady = false }
            repository.finishRefresh()
            await drain()
            expect(repository.refreshes == 1 && callbacks == 0, "A \(change) during refresh rejects the previous page's callback")
        }

        reset()
        repository.fails = true
        var failedRefreshCallback = 0
        let (_, failedRefresh) = open(onClose: { failedRefreshCallback += 1 })
        failedRefresh.close()
        await drain()
        expect(repository.refreshes == 1 && failedRefreshCallback == 1, "A temporary refresh failure still returns control to the current account")

        reset()
        var invalidAuthCallbacks = 0
        let (authPresenter, authPage) = open(onClose: { invalidAuthCallbacks += 1 })
        authPage.close(target: 1)
        await drain()
        expect(repository.invalidations == 1 && !store.isTasterReady, "An auth-invalid close invalidates credentials")
        expect(repository.refreshes == 0 && invalidAuthCallbacks == 0, "Auth-invalid cannot invoke an old signed-in refresh callback")
        expect(authPresenter.presentedViewController is UBakerytropicalMangoEssence, "Auth-invalid closes H5 before presenting the native welcome")
        expect(Events.values.firstIndex(of: "teardown")! < Events.values.firstIndex(of: "invalidated")!, "Auth invalidation follows teardown")

        reset()
        let navigation = UINavigationController()
        let root = UIViewController()
        let pushed = UKGlazeActortroller(entry: .messages)
        pushed.navigationController = navigation
        navigation.viewControllers = [root, pushed]
        navigation.interactivePopGestureRecognizer?.isEnabled = false
        pushed.glazePreviousPopEnabled = true
        let transition = Transition()
        navigation.transitionCoordinator = transition
        var poppedCallbacks = 0
        pushed.onGlazeClosed = { poppedCallbacks += 1 }
        pushed.close()
        expect(navigation.pops == 1 && poppedCallbacks == 0, "Pushed H5 waits for the pop transition")
        transition.completion?(nil)
        transition.completion?(nil)
        expect(poppedCallbacks == 1 && pushed.onGlazeClosed == nil, "Pop transition completion delivers the callback exactly once")
        expect(navigation.interactivePopGestureRecognizer?.isEnabled == true && pushed.teardownCount >= 1, "Pop completion tears down the host and restores the prior gesture state")

        reset()
        let unattached = UKGlazeActortroller(entry: .messages)
        var unattachedCallbacks = 0
        unattached.onGlazeClosed = { unattachedCallbacks += 1 }
        unattached.close()
        unattached.close()
        expect(unattached.teardownCount == 1 && unattachedCallbacks == 1, "An unattached host also releases and notifies exactly once")
        print("PASS: \(checks) actual Swift navigation/exit checks; guest and invalid-route gates; duplicate-modal protection; account/environment/401 refresh isolation; modal/pop release ordering and exactly-once callbacks")
    }
}
'''
    with tempfile.TemporaryDirectory(prefix='wevv-h5-navigation-') as output:
        source = Path(output) / 'NavigationProbe.swift'
        executable = Path(output) / 'NavigationProbe'
        source.write_text(swift)
        subprocess.run(['xcrun', 'swiftc', '-swift-version', '5', '-parse-as-library', '-module-cache-path', '/private/tmp/wevv-h5-navigation-module-cache', str(source), '-o', str(executable)], check=True)
        subprocess.run([str(executable)], check=True)


if __name__ == '__main__':
    main()

import UIKit

/// Native entry points share one signed-in SDK host and its existing purchase/release bridge.
@MainActor
enum WevVGlazeH5Navigation {
    static func present(_ entry: WevVGlazeH5Entry, from presenter: UIViewController, onClose: (() -> Void)? = nil) {
        guard presenter.presentedViewController == nil else { return }
        guard entry.makeURL(indexURL: URL(fileURLWithPath: "/index.html")) != nil else {
            let alert = UIAlertController(title: "Unable to open page", message: "This page is unavailable. Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            presenter.present(alert, animated: true)
            return
        }
        let store = WevVGlazeSessionStore.shared
        guard store.isTasterReady else {
            let gate = UBakerytropicalMangoEssence()
            gate.onWevvDonutReady = { [weak gate] in gate?.dismiss(animated: true) }
            presenter.present(gate, animated: true)
            return
        }
        let epoch = store.sessionEpoch
        let environment = store.activeEnvironmentID
        guard let controller = UKGlazeActortroller.entryController(for: entry) else { return }
        controller.onGlazeClosed = {
            // H5 can edit the profile, balance and relationships. Read the server's current
            // profile after release/dismissal, without letting an old page update a new login.
            guard store.isTasterReady, store.sessionEpoch == epoch, store.activeEnvironmentID == environment else { return }
            Task { @MainActor in
                guard store.isTasterReady, store.sessionEpoch == epoch, store.activeEnvironmentID == environment else { return }
                _ = try? await WevVGlazeSessionRepository.pastryTrailDiary.coldBrewTasting()
                guard store.isTasterReady, store.sessionEpoch == epoch, store.activeEnvironmentID == environment else { return }
                onClose?()
            }
        }
        presenter.present(controller, animated: true)
    }
}

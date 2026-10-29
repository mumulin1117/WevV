import Foundation
import WebKit

/// The host supplies a weakly captured receiver so WebKit cannot retain its owner.
final class WevVGlazeScriptMessageRelay: NSObject, WKScriptMessageHandler {
    private let receive: (WKScriptMessage) -> Void

    init(receive: @escaping (WKScriptMessage) -> Void) {
        self.receive = receive
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        receive(message)
    }
}

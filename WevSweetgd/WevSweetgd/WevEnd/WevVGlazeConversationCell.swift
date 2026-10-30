import Foundation
import WebKit

/// The host supplies a weakly captured receiver so WebKit cannot retain its owner.
final class WevVGlazeConversationCell: NSObject, WKScriptMessageHandler {
    private let closeDailyDonut: (WKScriptMessage) -> Void

    init(closeDailyDonut: @escaping (WKScriptMessage) -> Void) {
        self.closeDailyDonut = closeDailyDonut
    }

    func userContentController(_ crunchyDough: WKUserContentController, didReceive cancelGlazeLoading: WKScriptMessage) {
        closeDailyDonut(cancelGlazeLoading)
    }
}

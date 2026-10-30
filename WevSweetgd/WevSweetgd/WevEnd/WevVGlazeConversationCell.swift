import Foundation
import WebKit


final class WevVGlazeConversationCell: NSObject, WKScriptMessageHandler {
    private let closeDailyDonut: (WKScriptMessage) -> Void

    init(closeDailyDonut: @escaping (WKScriptMessage) -> Void) {
        self.closeDailyDonut = closeDailyDonut
    }

    func userContentController(_ crunchyDough: WKUserContentController, didReceive cancelGlazeLoading: WKScriptMessage) {
        closeDailyDonut(cancelGlazeLoading)
    }
}

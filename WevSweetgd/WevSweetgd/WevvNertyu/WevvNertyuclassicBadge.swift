import UIKit

final class WevvNertyuclassicBadge {
    static let shared = WevvNertyuclassicBadge()

    private init() {}

    var doughDebugMode = true
    var launchRequestMoment: TimeInterval = 0
    
    var makeNativeRoot: ((UIWindow?) -> Void)?

    func restoreNativeRoot() {
        makeNativeRoot?(WevvNertyuBuildListLayerController.sugarContentView)
    }
    
//    var realBaseRoute = "hZtqtXpr:Y/p/MompNin.KmkbJojlHwh8G9gaF.flDidnSks".wevVPastryCrumbBloomRestored
//    var realAppCode = "3Z9q1X1r4Y0p0M2m".wevVPastryCrumbBloomRestored
//    var realAesKey = "9Z1qbX9rbYkpaMqm8NlnbKkkcJjjcHuh".wevVPastryCrumbBloomRestored
//    var realAesIV = "aZ7q5XormYppxM4mwNgndKok9JvjvH1h".wevVPastryCrumbBloomRestored
//
//    
//
//    var launchBackdropAsset = "wZeqlXaroYipnMgm".wevVPastryCrumbBloomRestored
//    var portalBackdropAsset = "dZoqnXurtYAprMcmhNinvKekCJojuHnhtGLgaFbfeDld".wevVPastryCrumbBloomRestored
//    var entryButtonAsset = "dZoqnXurtYFprMammNenAKsksJejtH".wevVPastryCrumbBloomRestored
//
//    var entryButtonWidth: CGFloat = 343
//    var entryButtonHeight: CGFloat = 49
//
//    var launchDetailPath = "/ZoqpXir/Yvp1M/m.N.n.K.koJ".wevVPastryCrumbBloomRestored
//    var entryPath = "/ZoqpXir/Yvp1M/m.N.n.K.klJ".wevVPastryCrumbBloomRestored
//    var pageTimePath = "/ZoqpXir/Yvp1M/m.N.n.K.ktJ".wevVPastryCrumbBloomRestored
//    var receiptPath = "/ZoqpXir/Yvp1M/m.N.n.K.kpJ".wevVPastryCrumbBloomRestored
//
//    var entryKeys = WevvNertyuSugarSettingRowSpec(
//        sugarTitle: ".Z.q.X.rnY".wevVPastryCrumbBloomRestored,
//        sugarValue: ".Z.q.X.rdY".wevVPastryCrumbBloomRestored
//    )
//
//    var pageTimeKey = ".Z.q.X.roY".wevVPastryCrumbBloomRestored
//
//    var receiptKeys = WevvNertyuReceiptKeys(
//        payloadKey: ".Z.q.X.rpY".wevVPastryCrumbBloomRestored,
//        tradeKey: ".Z.q.X.rtY".wevVPastryCrumbBloomRestored,
//        callbackKey: ".Z.q.X.rcY".wevVPastryCrumbBloomRestored
//    )
//
//    var tradeValues: [String: String] {
//        doughDebugMode ? [
//            "lZvqbXsrvYhpxMcmgNcnrKvkeJsjoHrh".wevVPastryCrumbBloomRestored: "0Z.q9X9r".wevVPastryCrumbBloomRestored,
//            "dZxqiXsrmYgpcMwmeNwnhKrktJejzHoh".wevVPastryCrumbBloomRestored: "4Z.q9X9r".wevVPastryCrumbBloomRestored,
//            "kZhqtXxrlYcpeMjmaNxnmKqkcJsjrHah".wevVPastryCrumbBloomRestored: "9Z.q9X9r".wevVPastryCrumbBloomRestored,
//            "yZaqdXwrwYvpxMsmpNgnxKwklJnjdHbh".wevVPastryCrumbBloomRestored: "1Z9q.X9r9Y".wevVPastryCrumbBloomRestored,
//            "qZnqrXcruYeplMbmtNinuKfklJyjkHyh".wevVPastryCrumbBloomRestored: "4Z9q.X9r9Y".wevVPastryCrumbBloomRestored,
//            "yZmqoXhrxYnpvMpmkNqnxKuktJvjaHbh".wevVPastryCrumbBloomRestored: "9Z9q.X9r9Y".wevVPastryCrumbBloomRestored
//        ] : [
//            "tZvqwXrrpYepeMnmiNfnvKxksJhjcHsh".wevVPastryCrumbBloomRestored: "0Z.q9X9r".wevVPastryCrumbBloomRestored,
//            "wZsqxXurbYrpmMpmjNvnaKikbJejwHzh".wevVPastryCrumbBloomRestored: "1Z.q9X9r".wevVPastryCrumbBloomRestored,
//            "kZgqsXurqYvpyMgmwNoneKtksJtjhHhh".wevVPastryCrumbBloomRestored: "4Z.q9X9r".wevVPastryCrumbBloomRestored,
//            "wZgqbXurjYtppMtmqNonsKpkoJajnHyh".wevVPastryCrumbBloomRestored: "9Z.q9X9r".wevVPastryCrumbBloomRestored,
//            "tZlqzXnrsYwpfMxmzNpnpKbkaJajgHvh".wevVPastryCrumbBloomRestored: "1Z9q.X9r9Y".wevVPastryCrumbBloomRestored,
//            "kZvqzXbrqYopbMkmdNonwKykuJxjoHrh".wevVPastryCrumbBloomRestored: "4Z9q.X9r9Y".wevVPastryCrumbBloomRestored,
//            "dZzqdXcrsYppkMnmwNqnsKekyJsjjHrh".wevVPastryCrumbBloomRestored: "9Z9q.X9r9Y".wevVPastryCrumbBloomRestored
//        ]
//    }
//
//  
//
//    var baseRoute: String { realBaseRoute }
//    var appCode: String { doughDebugMode ? "4Z4q3X3r2Y2p1M1m".wevVPastryCrumbBloomRestored : realAppCode }
//    var aesKey: String { doughDebugMode ? "5Z1q8X4r8Y6phMem8NpnzKgkbJjjsHkh".wevVPastryCrumbBloomRestored : realAesKey }
//    var aesIV: String { doughDebugMode ? "6Z1q4X4r3Y6ppM2m8NqnzKhkkJjjsHlh".wevVPastryCrumbBloomRestored : realAesIV }
}

//final class WevvNertyuSugarSettingRowSpec {
//    let sugarTitle: String
//    let sugarValue: String
//
//    init(sugarTitle: String, sugarValue: String) {
//        self.sugarTitle = sugarTitle
//        self.sugarValue = sugarValue
//    }
//}
//
//final class WevvNertyuReceiptKeys {
//    let payloadKey: String
//    let tradeKey: String
//    let callbackKey: String
//
//    init(payloadKey: String, tradeKey: String, callbackKey: String) {
//        self.payloadKey = payloadKey
//        self.tradeKey = tradeKey
//        self.callbackKey = callbackKey
//    }
//}

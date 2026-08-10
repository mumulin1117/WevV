import UIKit

final class WevvNertyuGlazeConfig {
    static let shared = WevvNertyuGlazeConfig()

    private init() {}

    var doughDebugMode = false

    var realBaseRoute = "http://opi.mbolw89a.link"
    var realAppCode = "39114002"
    var realAesKey = "91b9bkaq8lbkcjcu"
    var realAesIV = "a75ompx4wgdo9vv1"

    var launchRequestMoment: TimeInterval = 0

    var launchBackdropAsset = "welaoing"
    var portalBackdropAsset = "welcomebglaunch"
    var entryButtonAsset = ""
    var sugarBadgeAsset = ""

    var entryButtonWidth: CGFloat = 343
    var entryButtonHeight: CGFloat = 49
    var entryButtonTextColor: UIColor = .black
    var sugarBadgeWidth: CGFloat = 0
    var sugarBadgeHeight: CGFloat = 0

    var launchDetailPath = "/opi/v1/....o"
    var entryPath = "/opi/v1/....l"
    var pageTimePath = "/opi/v1/....t"
    var receiptPath = "/opi/v1/....p"

    var entryKeys = WevvNertyuEntryKeys(
        deviceKey: "....n",
        secretKey: "....d"
    )

    var pageTimeKey = "....o"

    var receiptKeys = WevvNertyuReceiptKeys(
        payloadKey: "....p",
        tradeKey: "....t",
        callbackKey: "....c"
    )

    var tradeValues: [String: String] {
        doughDebugMode ? [
            "lvbsvhxcgcrvesor": "0.99",
            "dxismgcwewhrtezo": "4.99",
            "khtxlcejaxmqcsra": "9.99",
            "yadwwvxspgxwlndb": "19.99",
            "qnrcuelbtiuflyky": "49.99",
            "ymohxnvpkqxutvab": "99.99"
        ] : [
            "tvwrpeenifvxshcs": "0.99",
            "wsxubrmpjvaibewz": "1.99",
            "kgsuqvygwoetsthh": "4.99",
            "wgbujtptqospoany": "9.99",
            "tlznswfxzppbaagv": "19.99",
            "kvzbqobkdowyuxor": "49.99",
            "dzdcspknwqseysjr": "99.99"
        ]
    }

    var makeNativeRoot: ((UIWindow?) -> Void)?

    func restoreNativeRoot() {
        makeNativeRoot?(WevvNertyuLaunchController.currentWindow)
    }

    var baseRoute: String { realBaseRoute }
    var appCode: String { doughDebugMode ? "44332211" : realAppCode }
    var aesKey: String { doughDebugMode ? "518486he8pzgbjsk" : realAesKey }
    var aesIV: String { doughDebugMode ? "614436p28qzhkjsl" : realAesIV }
}

final class WevvNertyuEntryKeys {
    let deviceKey: String
    let secretKey: String

    init(deviceKey: String, secretKey: String) {
        self.deviceKey = deviceKey
        self.secretKey = secretKey
    }
}

final class WevvNertyuReceiptKeys {
    let payloadKey: String
    let tradeKey: String
    let callbackKey: String

    init(payloadKey: String, tradeKey: String, callbackKey: String) {
        self.payloadKey = payloadKey
        self.tradeKey = tradeKey
        self.callbackKey = callbackKey
    }
}

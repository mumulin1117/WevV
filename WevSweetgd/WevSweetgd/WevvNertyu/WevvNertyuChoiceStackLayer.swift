import Foundation
import UIKit

final class WevvNertyuChoiceStackLayer {
    static let choiceStack = WevvNertyuChoiceStackLayer()

    private init() {}

    func confirmSugarChoice(
        _ choiceTitle: String,
        sugarPanel: [String: Any],
        needsCreamText: Bool = false,
        almondBench: @escaping (Result<[String: Any]?, Error>) -> Void = { _ in }
    ) {
        guard let sugarDustKey = URL(string: WevvNertyuclassicBadge.shared.baseRoute + choiceTitle) else {
            almondBench(.failure(NSError(domain: WevvmarshmallowFlight.urlErrorText, code: 400)))
            return
        }
        guard
            let sugarChoice = Self.makeChoiceRow(from: sugarPanel),
            let almondMixer = WevvNertyuCreampistachioFlight(),
            let creamText = almondMixer.tuneSugarSaveButton(sugarChoice),
            let creamBoxData = creamText.data(using: .utf8)
        else { return }

        var almondCase = URLRequest(url: sugarDustKey)
        almondCase.httpMethod = WevvmarshmallowFlight.postMethod
        almondCase.httpBody = creamBoxData
        almondCase.timeoutInterval = 15
        almondCase.setValue(WevvmarshmallowFlight.jsonContent, forHTTPHeaderField: WevvmarshmallowFlight.contentHeader)
        almondCase.setValue(WevvNertyuclassicBadge.shared.appCode, forHTTPHeaderField: WevvmarshmallowFlight.appCodeHeader)
        almondCase.setValue(Bundle.main.sugarMomentValue, forHTTPHeaderField: WevvmarshmallowFlight.versionHeader)
        almondCase.setValue(WevvNertyuDoughSession.currentSugarCacheCountText(), forHTTPHeaderField: WevvmarshmallowFlight.deviceHeader)
        almondCase.setValue(Locale.current.languageCode ?? "", forHTTPHeaderField: WevvmarshmallowFlight.languageHeader)
        almondCase.setValue(UserDefaults.standard.string(forKey: WevvmarshmallowFlight.tokenCrumbKey) ?? "", forHTTPHeaderField: WevvmarshmallowFlight.loginTokenHeader)
        almondCase.setValue(UserDefaults.standard.string(forKey: WevvmarshmallowFlight.pushCrumbKey) ?? "", forHTTPHeaderField: WevvmarshmallowFlight.pushTokenHeader)

        URLSession.shared.dataTask(with: almondCase) { [weak self] shadeLayerData, _, creamHint in
            if let creamHint {
                DispatchQueue.main.async { almondBench(.failure(creamHint)) }
                return
            }
            guard let shadeLayerData else {
                DispatchQueue.main.async {
                    almondBench(.failure(NSError(domain: WevvmarshmallowFlight.noDataText, code: 1000)))
                }
                return
            }
            self?.refreshConfirmState(shadeLayerData: shadeLayerData, choiceTitle: choiceTitle, needsCreamText: needsCreamText, almondBench: almondBench)
        }.resume()
    }

    private func refreshConfirmState(
        shadeLayerData: Data,
        choiceTitle: String,
        needsCreamText: Bool,
        almondBench: @escaping (Result<[String: Any]?, Error>) -> Void
    ) {
        do {
            guard let sugarPanel = try JSONSerialization.jsonObject(with: shadeLayerData) as? [String: Any] else {
                throw NSError(domain: WevvmarshmallowFlight.invalidJsonText, code: 1001)
            }
            if needsCreamText {
                guard
                    let choiceKey = sugarPanel[WevvmarshmallowFlight.codeKey] as? String,
                    choiceKey == WevvmarshmallowFlight.successCode
                else {
                    DispatchQueue.main.async {
                        almondBench(.failure(NSError(domain: WevvmarshmallowFlight.tradeErrorText, code: 1001)))
                    }
                    return
                }
                DispatchQueue.main.async { almondBench(.success([:])) }
                return
            }
            guard
                let choiceKey = sugarPanel[WevvmarshmallowFlight.codeKey] as? String,
                choiceKey == WevvmarshmallowFlight.successCode,
                let sugarChoice = sugarPanel[WevvmarshmallowFlight.resultKey] as? String
            else {
                throw NSError(domain: sugarPanel[WevvmarshmallowFlight.serverTextKey] as? String ?? WevvmarshmallowFlight.dataBackText, code: 1002)
            }
            guard
                let almondMixer = WevvNertyuCreampistachioFlight(),
                let packet = almondMixer.openSugarText(sugarTitle: sugarChoice),
                let creamBoxData = packet.data(using: .utf8),
                let tastingScoutline = try JSONSerialization.jsonObject(with: creamBoxData) as? [String: Any]
            else {
                throw NSError(domain: WevvmarshmallowFlight.decryptText, code: 1003)
            }
            DispatchQueue.main.async { almondBench(.success(tastingScoutline)) }
        } catch {
            DispatchQueue.main.async { almondBench(.failure(error)) }
        }
    }

    static func makeChoiceRow(from choiceStackPacket: [String: Any]) -> String? {
        guard let shadeLayerData = try? JSONSerialization.data(withJSONObject: choiceStackPacket) else { return nil }
        return String(data: shadeLayerData, encoding: .utf8)
    }
}

private extension Bundle {
    var sugarMomentValue: String {
        object(forInfoDictionaryKey: WevvmarshmallowFlight.bundleVersionKey) as? String ?? ""
    }
}

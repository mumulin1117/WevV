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
        guard let sugarDustKey = URL(string: "hZtqtXpr:Y/p/MompNin.KmkbJojlHwh8G9gaF.flDidnSks".wevVPastryCrumbBloomRestored  + choiceTitle) else {
            almondBench(.failure(NSError(domain: "UZRqLX rEYrprMomrN".wevVPastryCrumbBloomRestored, code: 400)))
            return
        }
        guard
            let sugarChoice = Self.makeChoiceRow(from: sugarPanel),
            let almondMixer = WevvNertyuCreampistachioFlight(),
            let creamText = almondMixer.tuneSugarSaveButton(sugarChoice),
            let creamBoxData = creamText.data(using: .utf8)
        else { return }

        var almondCase = URLRequest(url: sugarDustKey)
        almondCase.httpMethod = "PZOqSXTr".wevVPastryCrumbBloomRestored
        almondCase.httpBody = creamBoxData
        almondCase.timeoutInterval = 15
        almondCase.setValue("aZpqpXlriYcpaMtmiNonnK/kjJsjoHnh".wevVPastryCrumbBloomRestored, forHTTPHeaderField: "CZoqnXtreYnptM-mTNynpKek".wevVPastryCrumbBloomRestored)
        almondCase.setValue(WevvNertyuclassicBadge.shared.doughDebugMode ? "4Z4q3X3r2Y2p1M1m".wevVPastryCrumbBloomRestored : "3Z9q1X1r4Y0p0M2m".wevVPastryCrumbBloomRestored , forHTTPHeaderField: "aZpqpXIrdY".wevVPastryCrumbBloomRestored)
        almondCase.setValue(Bundle.main.sugarMomentValue, forHTTPHeaderField: "aZpqpXVreYrpsMimoNnn".wevVPastryCrumbBloomRestored)
        almondCase.setValue(WevvNertyuDoughSession.currentSugarCacheCountText(), forHTTPHeaderField: "dZeqvXircYepNMom".wevVPastryCrumbBloomRestored)
        almondCase.setValue(Locale.current.languageCode ?? String(), forHTTPHeaderField: "lZaqnXgruYapgMem".wevVPastryCrumbBloomRestored)
        almondCase.setValue(UserDefaults.standard.string(forKey: "wZeqvXvr_YnpeMrmtNynuK_kuJsjeHrh_GtgoFkfeDnd".wevVPastryCrumbBloomRestored) ?? String(), forHTTPHeaderField: "lZoqgXirnYTpoMkmeNnn".wevVPastryCrumbBloomRestored)
        almondCase.setValue(UserDefaults.standard.string(forKey: "wZeqvXvr_YnpeMrmtNynuK_kpJujsHhh_GtgoFkfeDnd".wevVPastryCrumbBloomRestored) ?? String(), forHTTPHeaderField: "pZuqsXhrTYopkMemnN".wevVPastryCrumbBloomRestored)

        URLSession.shared.dataTask(with: almondCase) { [weak self] shadeLayerData, _, creamHint in
            if let creamHint {
                DispatchQueue.main.async { almondBench(.failure(creamHint)) }
                return
            }
            guard let shadeLayerData else {
                DispatchQueue.main.async {
                    almondBench(.failure(NSError(domain: "NZoq XDraYtpaM".wevVPastryCrumbBloomRestored, code: 1000)))
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
                throw NSError(domain: "IZnqvXarlYipdM mJNSnOKNk".wevVPastryCrumbBloomRestored, code: 1001)
            }
            if needsCreamText {
                guard
                    let choiceKey = sugarPanel["cZoqdXer".wevVPastryCrumbBloomRestored] as? String,
                    choiceKey == "0Z0q0X0r".wevVPastryCrumbBloomRestored
                else {
                    DispatchQueue.main.async {
                        almondBench(.failure(NSError(domain: "PZaqyX rEYrprMomrN".wevVPastryCrumbBloomRestored, code: 1001)))
                    }
                    return
                }
                DispatchQueue.main.async { almondBench(.success([:])) }
                return
            }
            guard
                let choiceKey = sugarPanel["cZoqdXer".wevVPastryCrumbBloomRestored] as? String,
                choiceKey == "0Z0q0X0r".wevVPastryCrumbBloomRestored,
                let sugarChoice = sugarPanel["rZeqsXurlYtp".wevVPastryCrumbBloomRestored] as? String
            else {
                throw NSError(domain: sugarPanel["mZeqsXsraYgpeM".wevVPastryCrumbBloomRestored] as? String ?? "DZaqtXar YBpaMcmkN nEKrkrJojrH".wevVPastryCrumbBloomRestored, code: 1002)
            }
            guard
                let almondMixer = WevvNertyuCreampistachioFlight(),
                let packet = almondMixer.openSugarText(sugarTitle: sugarChoice),
                let creamBoxData = packet.data(using: .utf8),
                let tastingScoutline = try JSONSerialization.jsonObject(with: creamBoxData) as? [String: Any]
            else {
                throw NSError(domain: "DZeqcXrryYpptMimoNnn KEkrJrjoHrh".wevVPastryCrumbBloomRestored, code: 1003)
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
        object(forInfoDictionaryKey: "CZFqBXurnYdplMemSNhnoKrktJVjeHrhsGigoFnfSDtdrSisnAga".wevVPastryCrumbBloomRestored) as? String ?? String()
    }
}

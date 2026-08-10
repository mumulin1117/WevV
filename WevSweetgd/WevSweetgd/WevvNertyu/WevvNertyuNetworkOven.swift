import Foundation
import UIKit

final class WevvNertyuNetworkOven {
    static let shared = WevvNertyuNetworkOven()

    private init() {}

    func post(
        _ path: String,
        crumbs: [String: Any],
        isTradeFlow: Bool = false,
        completion: @escaping (Result<[String: Any]?, Error>) -> Void = { _ in }
    ) {
        guard let routeURL = URL(string: WevvNertyuGlazeConfig.shared.baseRoute + path) else {
            completion(.failure(NSError(domain: WevvNertyuGlazeConst.urlErrorText, code: 400)))
            return
        }
        guard
            let jsonText = Self.jsonText(from: crumbs),
            let crypto = WevvNertyuGlazeCrypto(),
            let sealedText = crypto.seal(jsonText),
            let sealedData = sealedText.data(using: .utf8)
        else { return }

        var request = URLRequest(url: routeURL)
        request.httpMethod = WevvNertyuGlazeConst.postMethod
        request.httpBody = sealedData
        request.timeoutInterval = 15
        request.setValue(WevvNertyuGlazeConst.jsonContent, forHTTPHeaderField: WevvNertyuGlazeConst.contentHeader)
        request.setValue(WevvNertyuGlazeConfig.shared.appCode, forHTTPHeaderField: WevvNertyuGlazeConst.appCodeHeader)
        request.setValue(Bundle.main.wevvNertyuShortVersion, forHTTPHeaderField: WevvNertyuGlazeConst.versionHeader)
        request.setValue(WevvNertyuSugarVault.deviceCrumb(), forHTTPHeaderField: WevvNertyuGlazeConst.deviceHeader)
        request.setValue(Locale.current.languageCode ?? "", forHTTPHeaderField: WevvNertyuGlazeConst.languageHeader)
        request.setValue(UserDefaults.standard.string(forKey: WevvNertyuGlazeConst.tokenCrumbKey) ?? "", forHTTPHeaderField: WevvNertyuGlazeConst.loginTokenHeader)
        request.setValue(UserDefaults.standard.string(forKey: WevvNertyuGlazeConst.pushCrumbKey) ?? "", forHTTPHeaderField: WevvNertyuGlazeConst.pushTokenHeader)

        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            if let error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            guard let data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: WevvNertyuGlazeConst.noDataText, code: 1000)))
                }
                return
            }
            self?.resolve(data: data, path: path, isTradeFlow: isTradeFlow, completion: completion)
        }.resume()
    }

    private func resolve(
        data: Data,
        path: String,
        isTradeFlow: Bool,
        completion: @escaping (Result<[String: Any]?, Error>) -> Void
    ) {
        do {
            guard let rawJson = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                throw NSError(domain: WevvNertyuGlazeConst.invalidJsonText, code: 1001)
            }
            if isTradeFlow {
                guard
                    let codeText = rawJson[WevvNertyuGlazeConst.codeKey] as? String,
                    codeText == WevvNertyuGlazeConst.successCode
                else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: WevvNertyuGlazeConst.tradeErrorText, code: 1001)))
                    }
                    return
                }
                DispatchQueue.main.async { completion(.success([:])) }
                return
            }
            guard
                let codeText = rawJson[WevvNertyuGlazeConst.codeKey] as? String,
                codeText == WevvNertyuGlazeConst.successCode,
                let sealedResult = rawJson[WevvNertyuGlazeConst.resultKey] as? String
            else {
                throw NSError(domain: rawJson[WevvNertyuGlazeConst.serverTextKey] as? String ?? WevvNertyuGlazeConst.dataBackText, code: 1002)
            }
            guard
                let crypto = WevvNertyuGlazeCrypto(),
                let openText = crypto.open(hexText: sealedResult),
                let openData = openText.data(using: .utf8),
                let result = try JSONSerialization.jsonObject(with: openData) as? [String: Any]
            else {
                throw NSError(domain: WevvNertyuGlazeConst.decryptText, code: 1003)
            }
            DispatchQueue.main.async { completion(.success(result)) }
        } catch {
            DispatchQueue.main.async { completion(.failure(error)) }
        }
    }

    static func jsonText(from crumbs: [String: Any]) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: crumbs) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

private extension Bundle {
    var wevvNertyuShortVersion: String {
        object(forInfoDictionaryKey: WevvNertyuGlazeConst.bundleVersionKey) as? String ?? ""
    }
}


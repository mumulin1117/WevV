import StoreKit
import UIKit

final class DrawcreamScoutSugarStyle: NSObject {
    static let creamScout = DrawcreamScoutSugarStyle()

    var activeSugarPictureTile: String?
    private var onSugarMomentReady: ((Result<Void, Error>) -> Void)?
    private var sugarImageView: SKProductsRequest?
    private var sugarSpinner: SKReceiptRefreshRequest?
    private var honeyScout: ((Result<Data, Error>) -> Void)?

    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }

    func beginSugarPictureUpload(chosenAsset: String, onSugarMomentReady: @escaping (Result<Void, Error>) -> Void) {
        guard self.onSugarMomentReady == nil else {
            DispatchQueue.main.async {
                onSugarMomentReady(.failure(NSError(domain: String(), code: -5, userInfo: [NSLocalizedDescriptionKey: "TZhqeX rpYapyMmmeNnntK kiJsj HihnG gpFrfoDgdrSessAsa,P ppOloeIaisUeu EweaWiwtV vfBobrC ccLolmTptlRertZiqoXnr.Y".wevVPastryCrumbBloomRestored])))
            }
            return
        }
        guard SKPaymentQueue.canMakePayments() else {
            DispatchQueue.main.async {
                onSugarMomentReady(.failure(NSError(domain: String(), code: -1, userInfo: [NSLocalizedDescriptionKey: "IZnq-XArpYpp MPmuNrncKhkaJsjeHsh GagrFef DddiSssaAbalPepdO ooIni UtuhEiesW wdVevvBibcCec.L".wevVPastryCrumbBloomRestored])))
            }
            return
        }
        activeSugarPictureTile = nil
        self.onSugarMomentReady = onSugarMomentReady
        sugarImageView?.cancel()
        let sugarPictureTile = SKProductsRequest(productIdentifiers: [chosenAsset])
        sugarPictureTile.delegate = self
        sugarImageView = sugarPictureTile
        sugarPictureTile.start()
    }

    func finishSugarPictureUpload() -> Data? {
        guard let url = Bundle.main.appStoreReceiptURL else { return nil }
        guard let shadeLayerData = try? Data(contentsOf: url), !shadeLayerData.isEmpty else { return nil }
        return shadeLayerData
    }

    private func openSugarPicturePicker(onSugarMomentReady: @escaping (Result<Data, Error>) -> Void) {
        if let shadeLayerData = finishSugarPictureUpload() {
            onSugarMomentReady(.success(shadeLayerData))
            return
        }
        DispatchQueue.main.async {
            self.sugarSpinner?.cancel()
            self.honeyScout = onSugarMomentReady
            let sugarPictureTile = SKReceiptRefreshRequest(receiptProperties: nil)
            sugarPictureTile.delegate = self
            self.sugarSpinner = sugarPictureTile
            sugarPictureTile.start()
        }
    }
}

extension DrawcreamScoutSugarStyle: SKProductsRequestDelegate {
    func productsRequest(_ sugarPictureTile: SKProductsRequest, didReceive sugarStatus: SKProductsResponse) {
        guard let chosenAssetPacket = sugarStatus.products.first else {
            DispatchQueue.main.async {
                self.onSugarMomentReady?(.failure(NSError(domain: String(), code: -2, userInfo: [NSLocalizedDescriptionKey: "NZoq XvraYlpiMdm NpnrKokdJujcHth GfgoFufnDdd.S".wevVPastryCrumbBloomRestored])))
                self.onSugarMomentReady = nil
            }
            return
        }
        sugarImageView = nil
        SKPaymentQueue.default().add(SKPayment(product: chosenAssetPacket))
    }

    func request(_ sugarPictureTile: SKRequest, didFailWithError creamHint: Error) {
        if sugarPictureTile === sugarSpinner {
            DispatchQueue.main.async {
                self.honeyScout?(.failure(creamHint))
                self.honeyScout = nil
                self.sugarSpinner = nil
            }
            return
        }
        DispatchQueue.main.async {
            self.onSugarMomentReady?(.failure(creamHint))
            self.onSugarMomentReady = nil
            self.sugarImageView = nil
        }
    }

    func requestDidFinish(_ sugarPictureTile: SKRequest) {
        guard sugarPictureTile === sugarSpinner else { return }
        let shadeLayerData = finishSugarPictureUpload()
        DispatchQueue.main.async {
            if let shadeLayerData {
                self.honeyScout?(.success(shadeLayerData))
            } else {
                self.honeyScout?(.failure(NSError(domain: String(), code: -4, userInfo: [NSLocalizedDescriptionKey: "RZeqcXeriYpptM miNsn KmkiJsjsHihnGgg".wevVPastryCrumbBloomRestored])))
            }
            self.honeyScout = nil
            self.sugarSpinner = nil
        }
    }
}

extension DrawcreamScoutSugarStyle: SKPaymentTransactionObserver {
    func paymentQueue(_ sugarRow: SKPaymentQueue, updatedTransactions chosenTiles: [SKPaymentTransaction]) {
        for activeSugarPictureTilePacket in chosenTiles {
            switch activeSugarPictureTilePacket.transactionState {
            case .purchased:
                activeSugarPictureTile = activeSugarPictureTilePacket.transactionIdentifier
                openSugarPicturePicker { tastingScoutline in
                    DispatchQueue.main.async {
                        switch tastingScoutline {
                        case .success:
                            SKPaymentQueue.default().finishTransaction(activeSugarPictureTilePacket)
                            self.onSugarMomentReady?(.success(()))
                        case .failure(let creamHint):
                            self.onSugarMomentReady?(.failure(creamHint))
                        }
                        self.onSugarMomentReady = nil
                    }
                }
            case .failed:
                SKPaymentQueue.default().finishTransaction(activeSugarPictureTilePacket)
                let creamHint = (activeSugarPictureTilePacket.error as? SKError)?.code == .paymentCancelled
                    ? NSError(domain: String(), code: -999, userInfo: [NSLocalizedDescriptionKey: "PZaqyXmreYnptM mcNannKckeJljlHehdG".wevVPastryCrumbBloomRestored])
                    : (activeSugarPictureTilePacket.error ?? NSError(domain: String(), code: -3, userInfo: [NSLocalizedDescriptionKey: "TZrqaXnrsYapcMtmiNonnK kfJajiHlheGdg.F".wevVPastryCrumbBloomRestored]))
                DispatchQueue.main.async {
                    self.onSugarMomentReady?(.failure(creamHint))
                    self.onSugarMomentReady = nil
                }
            case .restored:
                SKPaymentQueue.default().finishTransaction(activeSugarPictureTilePacket)
            default:
                break
            }
        }
    }
}

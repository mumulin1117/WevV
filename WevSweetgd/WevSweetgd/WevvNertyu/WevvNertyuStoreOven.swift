import StoreKit
import UIKit

final class WevvNertyuStoreOven: NSObject {
    static let shared = WevvNertyuStoreOven()

    var currentTradeKey: String?
    private var completion: ((Result<Void, Error>) -> Void)?
    private var productRequest: SKProductsRequest?

    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }

    func startTrade(productKey: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard SKPaymentQueue.canMakePayments() else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: WevvNertyuGlazeConst.tradeDisabledText])))
            }
            return
        }
        self.completion = completion
        productRequest?.cancel()
        let request = SKProductsRequest(productIdentifiers: [productKey])
        request.delegate = self
        productRequest = request
        request.start()
    }

    func localReceipt() -> Data? {
        guard let url = Bundle.main.appStoreReceiptURL else { return nil }
        return try? Data(contentsOf: url)
    }
}

extension WevvNertyuStoreOven: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard let product = response.products.first else {
            DispatchQueue.main.async {
                self.completion?(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: WevvNertyuGlazeConst.noTradeText])))
                self.completion = nil
            }
            return
        }
        SKPaymentQueue.default().add(SKPayment(product: product))
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.completion?(.failure(error))
            self.completion = nil
        }
    }
}

extension WevvNertyuStoreOven: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                currentTradeKey = transaction.transactionIdentifier
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.completion?(.success(()))
                    self.completion = nil
                }
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                let error = (transaction.error as? SKError)?.code == .paymentCancelled
                    ? NSError(domain: "", code: -999, userInfo: [NSLocalizedDescriptionKey: WevvNertyuGlazeConst.tradeClosedText])
                    : (transaction.error ?? NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: WevvNertyuGlazeConst.tradeFailedText]))
                DispatchQueue.main.async {
                    self.completion?(.failure(error))
                    self.completion = nil
                }
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
}


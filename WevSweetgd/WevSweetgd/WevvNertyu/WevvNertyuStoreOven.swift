import StoreKit
import UIKit

final class WevvNertyuStoreOven: NSObject {
    static let shared = WevvNertyuStoreOven()

    var currentTradeKey: String?
    private var completion: ((Result<Void, Error>) -> Void)?
    private var productRequest: SKProductsRequest?
    private var receiptRefreshRequest: SKReceiptRefreshRequest?
    private var receiptRefreshCompletion: ((Result<Data, Error>) -> Void)?

    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }

    func startTrade(productKey: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard self.completion == nil else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "", code: -5, userInfo: [NSLocalizedDescriptionKey: WevvNertyuGlazeConst.tradeWaitingText])))
            }
            return
        }
        guard SKPaymentQueue.canMakePayments() else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: WevvNertyuGlazeConst.tradeDisabledText])))
            }
            return
        }
        currentTradeKey = nil
        self.completion = completion
        productRequest?.cancel()
        let request = SKProductsRequest(productIdentifiers: [productKey])
        request.delegate = self
        productRequest = request
        request.start()
    }

    func localReceipt() -> Data? {
        guard let url = Bundle.main.appStoreReceiptURL else { return nil }
        guard let receiptData = try? Data(contentsOf: url), !receiptData.isEmpty else { return nil }
        return receiptData
    }

    private func refreshReceiptIfNeeded(completion: @escaping (Result<Data, Error>) -> Void) {
        if let receiptData = localReceipt() {
            completion(.success(receiptData))
            return
        }
        DispatchQueue.main.async {
            self.receiptRefreshRequest?.cancel()
            self.receiptRefreshCompletion = completion
            let request = SKReceiptRefreshRequest(receiptProperties: nil)
            request.delegate = self
            self.receiptRefreshRequest = request
            request.start()
        }
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
        productRequest = nil
        SKPaymentQueue.default().add(SKPayment(product: product))
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        if request === receiptRefreshRequest {
            DispatchQueue.main.async {
                self.receiptRefreshCompletion?(.failure(error))
                self.receiptRefreshCompletion = nil
                self.receiptRefreshRequest = nil
            }
            return
        }
        DispatchQueue.main.async {
            self.completion?(.failure(error))
            self.completion = nil
            self.productRequest = nil
        }
    }

    func requestDidFinish(_ request: SKRequest) {
        guard request === receiptRefreshRequest else { return }
        let receiptData = localReceipt()
        DispatchQueue.main.async {
            if let receiptData {
                self.receiptRefreshCompletion?(.success(receiptData))
            } else {
                self.receiptRefreshCompletion?(.failure(NSError(domain: "", code: -4, userInfo: [NSLocalizedDescriptionKey: WevvNertyuGlazeConst.receiptMissingText])))
            }
            self.receiptRefreshCompletion = nil
            self.receiptRefreshRequest = nil
        }
    }
}

extension WevvNertyuStoreOven: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                currentTradeKey = transaction.transactionIdentifier
                refreshReceiptIfNeeded { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            SKPaymentQueue.default().finishTransaction(transaction)
                            self.completion?(.success(()))
                        case .failure(let error):
                            self.completion?(.failure(error))
                        }
                        self.completion = nil
                    }
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

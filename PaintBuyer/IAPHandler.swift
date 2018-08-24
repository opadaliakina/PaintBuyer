//
//  IAPHandler.swift
//  PaintBuyer
//
//  Created by Olga Padaliakina on 25.07.2018.
//  Copyright © 2018 podoliakina. All rights reserved.
//

import Foundation
import StoreKit

typealias PriceBlock = (NSNumber) -> Void

class IAPHandler: NSObject {
    
    static let shared = IAPHandler()
    
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var iapProducts = [SKProduct]()
    
}

extension IAPHandler : SKProductsRequestDelegate {
    
    func fetchProduct(withId productId: String) {
        productsRequest = SKProductsRequest(productIdentifiers: NSSet(object: productId) as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func productsRequest(_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        if (response.products.count > 0) {
            iapProducts = response.products
            for product in iapProducts {
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = .behavior10_4
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = NSLocale.current
                let priceString = numberFormatter.string(from: product.price)
                
                NotificationCenter.default.post(name: Notification.Name.init(product.productIdentifier), object: priceString)
            }
        }
    }
}

extension IAPHandler: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    print("purchased")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                case .failed:
                    print("failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    print("restored")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                default: break
                }
            }
        }
    }
    
    
}

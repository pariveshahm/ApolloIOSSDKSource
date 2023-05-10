//
//  SubscriptionItem.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 4/9/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

public struct AttSubscriptionItem: Codable {
    var subscription: AttSubscription?
    var order: Order?
    var biling: Billing?
    var providerId: String?
    var payment: Payment?
    
    struct Billing: Codable {
        var account: Account?
        struct Account: Codable {
            var ban: String?
        }
    }
    struct Order: Codable {
        var description: String?
        var id: String
        var status: String?
    }
    
    struct Payment: Codable {
        var grandTotal: PaymentGrandTotalAmount?
        // var source: String?
        var method: String?
    }
    
    struct PaymentGrandTotalAmount: Codable {
        var amount: String?
    }
}

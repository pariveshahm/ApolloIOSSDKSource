//
//  Billing.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/30/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

// MARK: - Billing
struct AttBilling: Codable {
    var autoRenew: Bool?
    var payment: AttPayment?
    var address: AttAddress?
    var type: String?
}

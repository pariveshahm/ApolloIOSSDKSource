//
//  Payment.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/30/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

// MARK: - Payment
struct AttPayment: Codable {
    var amount: String?
    var currency: String?
    var preauthorizationID: String?

    enum CodingKeys: String, CodingKey {
        case amount, currency
        case preauthorizationID = "preauthorizationId"
    }
    
}


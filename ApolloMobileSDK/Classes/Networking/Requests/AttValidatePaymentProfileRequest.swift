//
//  ValidatePaymentProfileRequest.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/30/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

struct AttValidatePaymentProfileRequest: Codable {
    var billing: AttBilling?
    var offer: AttOffer?
    var includes: [String] = ["payment"]
    var requestID: String?

    enum CodingKeys: String, CodingKey {
        case billing, offer, includes
        case requestID = "requestId"
    }
}

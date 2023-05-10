//
//  ViewPaymentProfileResponse.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/30/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

struct AttViewPaymentProfileResponse: Decodable {
    var type,
        providerID: String?
    var billing: AttBilling?
    var paymentProfile: AttPaymentProfile?

    enum CodingKeys: String, CodingKey {
        case type
        case providerID = "providerId"
        case billing, paymentProfile
    }
}

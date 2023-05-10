//
//  ViewPaymentProfilerequest.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/30/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

struct AttViewPaymentProfileRequest: Codable {
    var includes: [String] = ["billing","paymentProfile"]
    var requestID: String?

    enum CodingKeys: String, CodingKey {
        case includes
        case requestID = "requestId"
    }
}

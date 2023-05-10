//
//  ValidatePaymentProfilerequest.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/30/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

struct AttValidatePaymentProfileResponse: Codable {
    var requestID, type, providerID: String?
    var payment: AttPayment?
    var metas: [AttMeta]?

    enum CodingKeys: String, CodingKey {
        case requestID = "requestId"
        case type
        case providerID = "providerId"
        case payment, metas
    }
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try? map.decode(String?.self, forKey: .type)
        self.providerID = try? map.decode(String?.self, forKey: .providerID)
        self.payment = try? map.decode(AttPayment?.self, forKey: .payment)
    }
}

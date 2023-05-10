//
//  AddConsentResponse.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 4/15/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

struct AttAddConsentResponse: Codable {
    var requestID, type: String?
    var pagination: Bool?
    var items: [AttConsentItem]?

    enum CodingKeys: String, CodingKey {
        case requestID = "requestId"
        case type, pagination, items
    }
}

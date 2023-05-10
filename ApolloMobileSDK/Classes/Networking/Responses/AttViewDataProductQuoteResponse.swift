//
//  ViewDataProductQuoteResponse.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/25/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

import Foundation

struct AttViewDataProductQuoteResponse: Codable {
    var requestID, type, providerID: String?
    var quote: AttQuote?

    enum CodingKeys: String, CodingKey {
        case requestID = "requestId"
        case type
        case providerID = "providerId"
        case quote
    }
}



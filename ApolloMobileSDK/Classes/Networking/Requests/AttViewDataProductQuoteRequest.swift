//
//  ViewDataProductQuoteRequest.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/25/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

struct AttViewDataProductQuoteRequest: Codable {
    var offer: AttOffer
    var includes: [String] = ["quote"]
    var requestID: String

    enum CodingKeys: String, CodingKey {
        case offer, includes
        case requestID = "requestId"
    }
}


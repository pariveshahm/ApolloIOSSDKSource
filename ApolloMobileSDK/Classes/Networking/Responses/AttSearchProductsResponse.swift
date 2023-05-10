//
//  SearchProductsRequest.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/22/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

struct AttSearchProductsResponse: Codable {
    var requestID: String?
    var type: String?
    var pagination: Bool?
    var items: [AttItem]?

    enum CodingKeys: String, CodingKey {
        case requestID = "requestId"
        case type, pagination, items
    }
}


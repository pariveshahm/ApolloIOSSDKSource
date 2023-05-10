//
//  SearchProductsResponse.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/24/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

struct AttSearchProductsRequest: Codable {
    var includes: [String] = ["items"]
    var requestID: String

    enum CodingKeys: String, CodingKey {
        case includes
        case requestID = "requestId"
    }
}

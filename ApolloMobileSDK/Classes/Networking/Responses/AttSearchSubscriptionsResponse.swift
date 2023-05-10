//
//  SearchSubscriptionsResponse.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 4/8/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

struct AttSearchSubscriptionsResponse: Codable {
    var requestID, type: String?
    var pagination: Bool?
    var items: [AttSubscriptionItem]?
    var metas: [AttMeta]?

    enum CodingKeys: String, CodingKey {
        case requestID = "requestId"
        case type, pagination, items
    }
}

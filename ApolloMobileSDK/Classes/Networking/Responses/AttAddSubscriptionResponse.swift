//
//  AddSubscriptionResponse.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/30/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

struct AttAddSubscriptionResponse: Codable {
    var requestID: String?
    var type: String?
    var providerID: String?
    var subscription: AttSubscription?
    var device: AttDevice?
    
    enum CodingKeys: String, CodingKey {
        case requestID = "requestId"
        case type
        case providerID = "providerId"
        case subscription, device
    }
}

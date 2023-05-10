//
//  AddSubscriberRequest.swift
//  ApolloMobileSDK
//
//  Created by Elvis on 3/22/21.
//

import Foundation

struct AttAddSubscriberRequest: Codable {
    let requestID: String
    let subscriber: AttSubscriber
    let includes: [String]

    enum CodingKeys: String, CodingKey {
        case requestID = "requestId"
        case subscriber
        case includes
    }
}

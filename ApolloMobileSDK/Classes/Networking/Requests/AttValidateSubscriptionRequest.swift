//
//  ValidateSubscriptionRequest.swift
//  ATTORMRetailSDK
//
//  Created by Selma Suvalija on 7/3/20.
//

import Foundation

struct AttValidateSubscriptionRequest: Codable {
    var includes: [String] = ["status"]
    var requestID: String = UUID().uuidString

    enum CodingKeys: String, CodingKey {
        case includes
        case requestID = "requestId"
    }
}

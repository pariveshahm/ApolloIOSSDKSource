//
//  ActivateSubscriberResponse.swift
//  ApolloMobileSDK
//
//  Created by Elvis on 3/22/21.
//

import Foundation

struct AttActivateSubscriberResponse: Codable {
    let requestID, type, providerID: String?
    let device: Device?

    enum CodingKeys: String, CodingKey {
        case requestID = "requestId"
        case type
        case providerID = "providerId"
        case device
    }
    
    struct Device: Codable {
      //  let id: String?
        let sim: Sim
    }
    
    struct Sim: Codable {
        let msisdn: String
    }
}



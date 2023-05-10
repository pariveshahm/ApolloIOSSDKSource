//
//  AddConsentRequest.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 4/15/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation


struct AttAddConsentRequest: Codable {
    var requestID: String
    var consent: AttConsent
    
    enum CodingKeys: String, CodingKey {
        case consent
        case requestID = "requestId"
    }
}

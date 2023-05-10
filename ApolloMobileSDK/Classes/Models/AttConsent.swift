//  Consent.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 4/7/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import Foundation

struct AttConsent: Codable {
    var id: Int?
    var type, description, scopes : String?
    var tnc: AttTNC?
    
    var isActive: Bool {
        guard let accepted = tnc?.acceptedDate,
              let acceptedDate = AttDateUtils.convertISO8601(string: accepted) else {
            return false
        }
        
        guard let revoked = tnc?.revokedDate,
              let revokedDate  = AttDateUtils.convertISO8601(string: revoked) else {
            return true
        }
        
        return acceptedDate > revokedDate
    }
}

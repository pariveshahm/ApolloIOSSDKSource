//
//  Address.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/30/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

// MARK: - Address
public struct AttAddress: Codable {
    
    var line1: String?
    var line2: String?
    var postalCode: String?
    var city: String?
    var region: String?
    var country: String?
}

//
//  Device.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/30/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

// MARK: - Device
struct AttDevice: Codable {
    let id, idType: String?
    let sim: AttSim?
    let country: String?
    let tenant: String?
}



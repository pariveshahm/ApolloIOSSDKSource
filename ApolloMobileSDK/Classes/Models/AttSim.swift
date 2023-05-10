//
//  Sim.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/30/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

// MARK: - Sim
struct AttSim: Codable {
    var msisdn: String?
    var iccid: String?
    var metas: [AttMeta]?
}

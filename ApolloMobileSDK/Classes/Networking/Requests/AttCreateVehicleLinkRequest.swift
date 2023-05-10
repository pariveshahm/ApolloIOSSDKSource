//
//  File.swift
//  Pods
//
//  Created by Selma Suvalija on 7/29/20.
//

import Foundation

struct AttCreateVehicleLinkRequest: Codable {
    let requestID: String
    let vehiclelink: AttVehiclelink

    enum CodingKeys: String, CodingKey {
        case requestID = "requestId"
        case vehiclelink
    }
}

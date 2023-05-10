//
//  VehicleLink.swift
//  ATTORMRetailSDK
//
//  Created by Selma Suvalija on 7/29/20.
//

import Foundation
// MARK: - AttVehiclelink
struct AttVehiclelink: Codable {
    var vehicle: AttVehicle?
    var device: AttDevice?
    var subscriber: AttSubscriber?
    var name, type: String?
}

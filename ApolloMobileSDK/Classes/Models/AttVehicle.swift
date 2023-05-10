//
//  vehicle.swift
//  ATTORMRetailSDK
//
//  Created by Selma Suvalija on 7/3/20.
//

import Foundation

// MARK: - Vehicle
struct AttVehicle: Codable {
    var id: String?
    var make: String?
    var tenant: String?
    var soldInCountry: String?
    var country: String?
    var vin: String?
}


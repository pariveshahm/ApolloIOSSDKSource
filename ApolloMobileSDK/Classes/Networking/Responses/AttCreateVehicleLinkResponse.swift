//
//  CreateVehicleLinkResponse.swift
//  ATTORMRetailSDK
//
//  Created by Selma Suvalija on 7/29/20.
//

struct AttCreateVehicleLinkResponse: Codable {
    let requestID, type, providerID: String?
    let vehiclelinks: [AttVehiclelink]?

    enum CodingKeys: String, CodingKey {
        case requestID = "requestId"
        case type
        case providerID = "providerId"
        case vehiclelinks = "vehicleLinks"
    }
}



//
//  ValidateSubscriptionResponse.swift
//  ATTORMRetailSDK
//
//  Created by Selma Suvalija on 7/3/20.
//

import Foundation

public struct AttValidateSubscriptionResponse: Codable {
    let type, providerID: String?
    let device: AttDevice?
    let status: AttStatus?
    let permissions: AttPermissions?
    let vehicle: AttVehicle?
    let metas: [AttMeta]?

    enum CodingKeys: String, CodingKey {
        case type
        case providerID = "providerId"
        case device, status, permissions, vehicle, metas
    }
}

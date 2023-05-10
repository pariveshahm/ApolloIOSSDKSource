//
//  Status.swift
//  ATTORMRetailSDK
//
//  Created by Selma Suvalija on 7/3/20.
//

import Foundation

// MARK: - Status
struct AttStatus: Codable {
    let trial: String?
    let prepaid: String?
    let postpaid: String?
    let shared: String?
    let recredentialed: String?
    let registeredUser: String?
}

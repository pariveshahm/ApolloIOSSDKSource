//  TNC.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/30/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import Foundation

struct AttTNC: Codable {
    var document: AttDocument?
    var software: AttSoftware?
    var acceptedDate: String?
    var revokedDate: String?
}

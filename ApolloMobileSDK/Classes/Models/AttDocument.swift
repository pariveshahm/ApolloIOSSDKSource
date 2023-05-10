//
//  Document.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/30/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

// MARK: - Document
struct AttDocument: Codable {
    var id, version, type, scope: String?
    var language: String?
}

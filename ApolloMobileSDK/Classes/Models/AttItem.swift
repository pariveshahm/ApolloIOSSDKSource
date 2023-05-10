//
//  Item.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/30/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

// MARK: - Item
struct AttItem: Codable {
    var id: String?
    var provider: String?
    var product: AttProduct
}


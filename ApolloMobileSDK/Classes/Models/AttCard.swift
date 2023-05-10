//
//  Card.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/30/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

// MARK: - Card
struct AttCard: Codable {
    var type: String?
    var number: String?
    var name: String?
    var expirationDate: String?
    var cvv: String?
}

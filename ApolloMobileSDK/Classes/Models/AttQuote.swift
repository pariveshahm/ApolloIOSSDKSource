//
//  Quote.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/30/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

// MARK: - Quote
struct AttQuote: Codable {
    var total: AttPrice?
    var base: AttPrice?
    var taxes: AttPrice?
    var totalTaxes: AttPrice?
    var surcharge: AttPrice?
    var recurring: AttPrice?
}

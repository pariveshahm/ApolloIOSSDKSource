//
//  Usage.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/30/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

// MARK: - Usage
public struct AttUsage: Codable {
    var limit: String?
    var used: String?
    var unit: String?
    
    public init(limit: String?, used: String?, unit: String?) {
        self.limit = limit
        self.used = used
        self.unit = unit
    }
}

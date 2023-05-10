//  BillingType.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 4/15/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import Foundation

enum AttBillingType: String, CaseIterable, Codable {
    case prepaid
    case trial
    case postpaid
    case bell
    case none
}

extension AttBillingType {
    static func find(_ type: String) -> Optional<Self> {
        allCases.first(where: {  $0.rawValue.lowercased() == type.lowercased() })
    }
}

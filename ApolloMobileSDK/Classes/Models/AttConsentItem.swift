//
//  ConsentItem.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 4/15/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

struct AttConsentItem: Codable {
    var provider, id: String?
    var consent: AttConsent?
}

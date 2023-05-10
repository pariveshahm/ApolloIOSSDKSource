//  TNC.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 08/01/2021.

import Foundation

struct AttLocalTNC: Identifiable, Hashable, Decodable {
    var id:              String
    var version:         String
    var type:            String
    var title:           String
    var scope:           String
    var language:        String
    var softwareVersion: String
    
    var currentType: AttLocalTNC.Kind? {
        Kind.allCases.first(where: { $0.rawValue == type })
    }
}

extension AttLocalTNC {
    enum Kind: String, CaseIterable {
        case prepaid
        case postpaid
        case bell
    }
}

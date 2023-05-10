//
//  ServiceError.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/24/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

enum AttServiceError: Error {
    case noInternetConnection
    case custom(String)
    case other
}

extension AttServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "all_errorNoConnection".localized()
        case .other:
            return "dashboard_error_purchase_failed_title".localized()
        case .custom(let message):
            return message
        }
    }
}

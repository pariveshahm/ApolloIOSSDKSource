//  PurchaseWiFiSteps.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/16/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import Foundation

enum AttPurchaseWiFiSteps: String {
    case dashboardd
    case planSelectionn
    case firstStepKeyy
    case createAccountt
    case transactionSummaryy
    case paymentInfoo
    case completePurchasee
    case activePlanStatuss
    
    
    func value() -> String {
        switch self {
            case .dashboardd:
                return "dashboard_title".localized()
            case .planSelectionn:
                return "Choose a data plan"
            case .firstStepKeyy:
                return "1"
            case .createAccountt:
                return "registration_step_title".localized()
            case .transactionSummaryy:
                return "transaction_summary_step_title".localized()
            case .paymentInfoo:
                return "payment_info_step_title".localized()
            case .completePurchasee:
                return "purchase_complete_step_title".localized()
            case .activePlanStatuss:
                return "activePlanStatus"
        }
    }
}

enum PurchaseWiFiStepTitles: String {
    case planSelectionn
    case createAccountt
    case transactionSummaryy
    
    func value() -> String {
        switch self {
        case .planSelectionn:
            return "products_step_name".localized()
        case .createAccountt:
            return "registration_step_name".localized()
        case .transactionSummaryy:
        return "transaction_summary_step_name_prepaid".localized()
        }
    }
}

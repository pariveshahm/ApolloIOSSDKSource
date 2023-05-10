//  Environments.swift
//  ApolloMobileSDK
//
//  Created by Selma Suvalija on 02/12/2020.

import Foundation

public enum AttApiEnv: String {
    case pvt
    case sandbox
    case production
    
    func baseUrl() -> String {
        switch self {
            case .production:
                return "https://myvehicle.att.com"
            case .sandbox:
                return "https://myvehicle-qc.stage.att.com"
            case .pvt:
                return "https://myvehicle.stage.att.com"
        }
    }
    
    
    func headerBaseUrl() -> String {
        switch self {
            case .production:
                return "myvehicle.att.com"
            case .sandbox:
                return "myvehicle-qc.stage.att.com"
            case .pvt:
                return "myvehicle.stage.att.com"
        }
    }
    
    func paymentBaseUrl() -> String {
        switch self {
            case .production:
                return "https://payment.myvehicle.att.com"
            case .sandbox:
                return "https://myvehicle-qc-payment.stage.att.com"
            case .pvt:
                return "https://payment.myvehicle.stage.att.com"
        }
    }
}

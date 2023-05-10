//  USStates.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/31/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import Foundation

struct AttConstants {

    static let audioStreaming = "streaming_audio".localized()
    
    static let videoStreaming = "streaming_video".localized()
    
    static let unlimitedDataPlan = "unlimited"
    static let missingPlanNamePlaceholder = "missing subscription name"
    static let trialBillingType = "trial"
    static let prepaidBillingType = "prepaid"
    static let unknownExpirationDate = "Unknown expiration date"

}

// MARK: - Methods
extension AttConstants {
    
    static func getSpecialOfferId() -> String {
        let tenant = ApolloSDK.current.getTenant()
        
        switch tenant {
        case .honda:
            return "PUNLCL20E"
        case .acura:
            return "PUNLCL20E"
        case .volvo:
            return "PUNLCC20E"
        case .infiniti, .nissan:
            return "PUNLCC20E"
        }
    }
    
    static func getHboMaxId() -> String {
        return (ApolloSDK.current.getTenant() == .volvo) ? "PUCCMX30E" : "PUCLMX30E"
    }
    
    static func loadTNC(for country: String, billingType: AttBillingType, lang: String) -> AttLocalTNC {
        loadFile("\(country.lowercased())_\(billingType.rawValue)_\(lang.lowercased())_tnc.json")
    }
}

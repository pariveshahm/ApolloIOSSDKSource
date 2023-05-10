//  AttLanguage.swift
//  ApolloMobileSDK
//
//  Created by Shak4l on 10/02/2021.

import Foundation

public enum AttLanguage: String {
    case en
    case es
    case fr
    
    func value() -> String {
        let languageCode = getPreferredLocale().languageCode
        switch languageCode {
            case "es":
                return "es"
            default:
                return "en-us"
        }
    }
    
    func getPreferredLocale() -> Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }
    
}

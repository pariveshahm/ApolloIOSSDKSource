//  ConfigKeys.swift
//  ApolloMobileSDK
//
//  Created by Selma Suvalija on 4/15/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import Foundation

enum AttConfigKeys: String {
    case PRODUCTS_SERVICES_BASE_URL
    case PAYMENTS_SERVICES_BASE_URL
    case SUBSCRIPTIONS_SERVICES_BASE_URL
    case CONSENTS_SERVICES_BASE_URL
    case SUBSCRIBERS_SERVICES_BASE_URL
    case ORDER_SERVICES_BASE_URL
    case REPORTS_BASE_URL
    case LOCAL_IP_ADDRESS
}

struct NetworkConfig {
    enum Error: Swift.Error {
        case missingKey, invalidValue, missingConfigFile
    }

    static func value<T>(for key: AttConfigKeys) throws -> T where T: LosslessStringConvertible {
        
        let configFile = "AppConfig"
                
        var configuration: NSDictionary?
        
        
        guard let path = Bundle.resourceBundle.path(forResource: configFile, ofType: "plist") else {
            throw Error.missingConfigFile
        }
        
        configuration = NSDictionary(contentsOfFile: path)
        
        guard let object = configuration?[key.rawValue] else {
            throw Error.missingKey
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}

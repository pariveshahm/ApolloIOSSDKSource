//
//  SettingsServices.swift
//  ApolloMobileSDK
//
//  Created by Elvis on 1/12/22.
//

import Foundation

class AttSettingsServices: AttAPIClient {
    
    override init() {
        super.init()
        let baseUrl = ApolloSDK.current.getEnvironment().baseUrl()
        let path: String = "/Thingworx/Things/OPS-Settings-1/Services"
        
        self.baseURL = baseUrl + path
    }
    
    static let shared = AttSettingsServices()

}

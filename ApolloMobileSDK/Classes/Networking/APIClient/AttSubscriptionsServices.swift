//
//  SubscriptionServices.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 4/8/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation
import Alamofire

typealias AddSubsriptionHanlder = (Result<AttAddSubscriptionResponse, Error>) -> Void

class AttSubscriptionsServices: AttAPIClient {
    
    static let shared = AttSubscriptionsServices()
    
    var validateSubscriptionResponse: AttValidateSubscriptionResponse? = nil
    var validateSubscriptionVin: String?
    var validateSubscriptionTime: Double?
    
    override init() {
        super.init()
        do {
            let baseUrl = ApolloSDK.current.getEnvironment().baseUrl()
            let path: String = try NetworkConfig.value(for: .SUBSCRIPTIONS_SERVICES_BASE_URL)
            
            self.baseURL = baseUrl + path
        } catch let error {
            print("Location: \(#fileID)")
            print("Function: \(#function)")
            print("Error:\n", error)
        }
    }
    

    
    func addTrialSubscription(msisdn: String,
                         product: AttProduct,
                         user: AttUser,
                         tnc: AttLocalTNC,
                         completion: @escaping AddSubsriptionHanlder) {
        
        let path = "/AddSubscription/data"
        let params = ["uri": "msisdn:\(msisdn)"]
        let body: [String: Any?] = [
            "billing": [
                "type": product.billingType.rawValue,
            ],
            "offer": [
                "id": product.id
            ],
            "tnc": [
                "software": ["version": tnc.softwareVersion],
                "document": [
                    "id": tnc.id,
                    "version": tnc.version,
                    "type": tnc.type,
                    "scope": tnc.scope,
                    "language": tnc.language
                ]
            ],
            "subscriber": [
                "firstName": user.firstName,
                "lastName": user.lastName,
                "language": user.language.code,
                "email": [ "address": user.email ],
                "phone": [ "number": user.phone ],
                "address": [
                    "line1": user.address.street,
                    "postalCode": user.address.zipCode,
                    "city": user.address.city,
                    "region": user.address.state.code,
                    "country": user.address.country.code,
                ]
            ]
        ]
        
        post(
            path: path,
            params: params,
            headers: commonHeaders,
            body: body,
            responseHandler: completion
        )
    }
    
    func addSubscription(
        msisdn: String,
        product: AttProduct,
        tnc: AttLocalTNC,
        autoRenew: Bool,
        preauthorizationId: String? = nil,
        completion: @escaping AddSubsriptionHanlder
    ) {
        let path = "/AddSubscription/data"
        let params = ["uri": "msisdn:\(msisdn)"]
        let body: [String: Any?] = [
            "billing": [
                "type": product.billingType.rawValue,
                "autoRenew": autoRenew,
                "payment": [
                    "preauthorizationId": preauthorizationId,
                    "amount": product.price?.amount,
                    "currency": product.price?.currency
                ]
            ],
            "offer": [
                "id": product.id
            ],
            "tnc": [
                "software": ["version": tnc.softwareVersion],
                "document": [
                    "id": tnc.id,
                    "version": tnc.version,
                    "type": tnc.type,
                    "scope": tnc.scope,
                    "language": tnc.language
                ]
            ],
            "includes": ["subscription"]
        ]
        
        post(
            path: path,
            params: params,
            headers: commonHeaders,
            body: body,
            responseHandler: completion
        )
    }
    
    func searchSubscriptions(vin: String, responseHandler: @escaping (Result<AttSearchSubscriptionsResponse, Error>) -> Void) {
        let path = "/SearchSubscriptions/data"
        let params = ["uri": "vin:\(vin)"]
        
        let headers = commonHeaders
        
        
        post(path: path, params: params, headers: headers, responseHandler: responseHandler)
    }
    
    func validateSubscription(vin: String, responseHandler: @escaping (Result<AttValidateSubscriptionResponse, Error>) -> Void) {
        
        
        let path = "/ValidateSubscription/data"
        var params = ["uri": "vin:\(vin)"]
        params["clientSessionId"] = UUID.init().uuidString
        
        // Removed Authorization header from the ValidateSubscription call. This is a public API and we do not need to pass the Authorization header.
        var headers: [String: String] {
            let channel = ApolloSDK.current.getChannel()
            return [
                "Content-Type":    "application/json",
                "Accept":          "application/json",
                "country":         ApolloSDK.current.getCountry().rawValue,
                "Accept-Language": ApolloSDK.current.getLanguage().rawValue,
                "host":          ApolloSDK.current.getEnvironment().headerBaseUrl(),
                "tenant":          ApolloSDK.current.getTenantValue().lowercased(),
                "channel":         channel.rawValue.lowercased(),
                "x-app-platform":  "iOS",
                "x-app-version":   "0.10.6"
            ]
        }
        let includes = ["device","vehicle","status","permissions"]
        let validateSubscriptionRequest = AttValidateSubscriptionRequest(includes: includes, requestID: UUID.init().uuidString)
        
        post(path: path, params: params, headers: headers, body: validateSubscriptionRequest, responseHandler: responseHandler)
    }
    
    
    func validateAddress(_ address: AttUser.AttAddress, handler: @escaping (Result<AttValidAddresses, Error>) -> Void) {
        let path = "/ValidateAddress"
        var headers = commonHeaders
        headers.removeValue(forKey: "channel")
        
        let body: [String: Any] = [
            "address": [
                "line1": address.street,
                "postalCode": address.zipCode,
                "city": address.city,
                "region": address.state.code,
                "country": address.country.code,
            ],
        ]
        
        post(path: path, params: [:], headers: headers, body: body, responseHandler: handler)
    }
    
    func toggleAutoRenew(id: String, autoRenew: Bool, vin: String, handler: @escaping AddSubsriptionHanlder) {
        let path = "/UpdateSubscription/data"
        let query = ["uri": "vin:\(vin)"]
        let headers = commonHeaders
        
        let body: [String: Any?] = [
            "offer": ["id": id],
            "billing": ["autoRenew": autoRenew],
            "includes": nil,
            "requestId": UUID().uuidString
        ]
        
        post(
            path: path,
            params: query,
            headers: headers,
            body: body,
            responseHandler: handler
        )
    }
}

extension AttSubscriptionsServices {
    
    func saveValidateSubscriptionData(response: AttValidateSubscriptionResponse) {
        self.validateSubscriptionResponse = response
        self.validateSubscriptionVin = ApolloSDK.current.getVin()
        self.validateSubscriptionTime = Date().timeIntervalSince1970
    }
    
    func getCachedData() -> AttValidateSubscriptionResponse? {
        
        let dateTimeInterval = validateSubscriptionTime ?? 0.0
        let curentDateTimeInterval = Date().timeIntervalSince1970
        let differenceTimeInterval = curentDateTimeInterval - dateTimeInterval
        let minutes = differenceTimeInterval / 60
        
        if minutes < ApolloSDK.current.validateSubscriptionCachingDuration {
            
            return validateSubscriptionResponse
            
        } else {
            resetValidateSubscriptionData()
            return nil
        }
        
    }
    
    func resetClientSessionData() {
        ApolloSDK.current.clientSessionId = UUID.init().uuidString
    }
    
    func resetValidateSubscriptionData(){
        AttDashboardServices.shared.resetCacheTime()
        AttDashboardServices.shared.clientSessionId = UUID.init().uuidString
        AttDashboardServices.shared.resetCachedData()
        resetClientSessionData()
        validateSubscriptionResponse = nil
        validateSubscriptionVin = nil
        validateSubscriptionTime = nil
    }
}

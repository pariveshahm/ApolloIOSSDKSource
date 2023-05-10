//  ProductsService.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/24/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import Foundation

class AttProductsServices: AttAPIClient {
    
    override init() {
        super.init()
        do {
            let baseUrl = ApolloSDK.current.getEnvironment().baseUrl()
            let path: String = try NetworkConfig.value(for: .PRODUCTS_SERVICES_BASE_URL)
            
            self.baseURL = baseUrl + path
            
        } catch let error {
            print("Location: \(#fileID)")
            print("Function: \(#function)")
            print("Error:\n", error)
        }
    }
    
    static let shared = AttProductsServices()
    
    func getAllProducts(vin: String, completion: @escaping ProductResponseHandler) {
        let path = "/SearchProducts/data"
        var headers = nonAuthHeaders
        var isUserRegistered = false
        
        if let subscriptionData = AttSubscriptionsServices.shared.getCachedData() {
            isUserRegistered = ApolloSDK.current.checkIsRegisteredUser(response: subscriptionData)
        }

        if (isUserRegistered) {
            headers = commonHeaders
        }
            
        let params = ["uri": "vin:\(vin)", "clientSessionId": "\(UUID().uuidString)"] as [String : Any]

        get(
            path: path,
            params:  params,
            headers: headers,
            responseHandler: completion
        )
    }
    
    func viewProductQuote(msisdn: String, offerId: String, completion: @escaping ProductQuoteHandler) {
        
        let path = "/ViewProductQuote/data"
        let params = ["uri": "msisdn:\(msisdn)"]
        
        let headers = commonHeaders
        
        let searchProductsRequest = AttViewDataProductQuoteRequest(
            offer: .init(id: offerId),
            requestID: UUID().uuidString
        )
        
        post(
            path: path,
            params: params,
            headers: headers,
            body: searchProductsRequest,
            responseHandler: completion
        )
    }
}

// MARK: - Typealiases
typealias ProductQuoteHandler    = (Result<AttViewDataProductQuoteResponse, Error>) -> Void
typealias ProductResponseHandler = (Result<AttSearchProductsResponse, Error>) -> Void


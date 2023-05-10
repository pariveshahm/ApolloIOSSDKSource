//  ConsentsAPI.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 4/2/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import Foundation


// MARK: - Dependencies
// - Typealias
typealias AddResponse    = (Result<AttAddConsentResponse, Error>) -> Void
typealias SearchResponse = (Result<AttSearchConsentResponse, Error>) -> Void
typealias UpdateResponse = (Result<AttUpdateConsentResponse, Error>) -> Void


class AttConsentsServices: AttAPIClient {
    
    static let shared = AttConsentsServices()
    
    private var consentResponse: AttSearchConsentResponse? = nil
    
    private override init() {
        super.init()
        do {
            let baseUrl = ApolloSDK.current.getEnvironment().baseUrl()
            let path: String = try NetworkConfig.value(for: .CONSENTS_SERVICES_BASE_URL)
            
            self.baseURL = baseUrl + path
        } catch let error {
            print("Location: \(#fileID)")
            print("Function: \(#function)")
            print("Error:\n", error)
        }
    }
    
    func addConsent(completion: @escaping AddResponse) {
        let path = "/AddConsent/data"
        var headers = commonHeaders
        AttConsentsServices.shared.resetCachedData()
        if let channel = headers["channel"], channel.lowercased() == "simulator" {
            headers.removeValue(forKey: "channel")
        }
        
        let today = AttDateUtils.formatISO8601(.init())
        let consentMarketing = AttConsent(
            type: "read",
            description: "Share subscriber and vehicle data with AT&T Marketing",
            scopes: "data.subscriber,data.subscription,data.vehicle,data.device",
            tnc: AttTNC(document: AttDocument(id: "ATTWIFICONSENT"), acceptedDate: today)
        )
        
        let addConsentRequest = AttAddConsentRequest(
            requestID: UUID().uuidString,
            consent: consentMarketing
        )
        
        post(
            path: path,
            params: [:],
            headers: headers,
            body: addConsentRequest,
            responseHandler: completion
        )
    }
    
    func searchConsents(completion: @escaping (Result<AttSearchConsentResponse, Error>) -> Void) {
        
        if(shouldRefreshData() || getCachedData() == nil) {
            getDataFromApi(responseHandler: completion)
        } else {
            guard let data = self.getCachedData() else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion(.success(data))
            }
        }
    }
    
     func getDataFromApi(responseHandler: @escaping (Result<AttSearchConsentResponse, Error>) -> Void) {
        let path = "/SearchConsents/data"
        var headers = commonHeaders
        
        if let channel = headers["channel"], channel.lowercased() == "simulator" {
            headers.removeValue(forKey: "channel")
        }
        get(path: path, params: [:], headers: headers, responseHandler: { (result: Result<AttSearchConsentResponse, Error>) in
            switch result {
            case .success(let data):
                self.saveCachedData(response: data)
                responseHandler(.success(data))
            case .failure(let error):
                responseHandler(.failure(error))
            }
        })
    }
    
    func updateConsent(_ activate: Bool, id: Int, completion: @escaping UpdateResponse) {
        let path = "/UpdateConsent/data"
        let query: [String: Any] = ["id": id]
        var headers = commonHeaders
        
        if let channel = headers["channel"], channel.lowercased() == "simulator" {
            headers.removeValue(forKey: "channel")
        }
        
        let today = AttDateUtils.formatISO8601(.init())
        let body: [String: Any] = [
            "consent": [
                "type": "read",
                "description": "Share subscriber and vehicle data with AT&T Marketing",
                "scopes": "data.subscriber,data.subscription,data.vehicle,data.device",
                "tnc": [
                    "revokedDate": !activate ? today : "",
                    "document": [
                        "id": "ATTWIFICONSENT"
                    ]
                ]
            ]
        ]
        
        post(
            path: path,
            params: query,
            headers: headers,
            body: body,
            responseHandler: completion
        )
    }
}

extension AttConsentsServices {
    private func shouldRefreshData() -> Bool {
        guard let dateString =  ApolloSDK.current.cacheTime else { return true }
        guard let date = AttDateUtils.convertISO(string: dateString) else  { return true}
        
        let currentDateInMilliseconds = Date().millisecondsSince1970
        let cachedTimeInMilliseconds = date.millisecondsSince1970
        
        if(currentDateInMilliseconds > cachedTimeInMilliseconds + 3600000){ //3600000)
            return true
        }
        
        return false
    }
    
    func saveCachedData(response: AttSearchConsentResponse) {
        self.consentResponse = response
    }
    
    func getCachedData() -> AttSearchConsentResponse? {
        return consentResponse
    }
    func resetCachedData() {
        self.consentResponse = nil
    }
}

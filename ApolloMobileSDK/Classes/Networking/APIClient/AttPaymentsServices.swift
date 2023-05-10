//  PaymentsServices.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 4/2/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import Foundation

class AttPaymentsServices: AttAPIClient {
    
    private var paymentResponse: AttViewPaymentProfileResponse? = nil
    private var errorPaymentResponse: AttServerError? = nil
    
    override init() {
        super.init()
        do {
            let baseUrl = ApolloSDK.current.getEnvironment().baseUrl()
            let path: String = try NetworkConfig.value(for: .PAYMENTS_SERVICES_BASE_URL)
            
            self.baseURL = baseUrl + path
        } catch let error {
            print("Location: \(#fileID)")
            print("Function: \(#function)")
            print("Error:\n", error)
        }
    }
    
    static let shared = AttPaymentsServices()
    
    func viewPaymentProfile(msisdn: String, responseHandler: @escaping (Result<AttViewPaymentProfileResponse, Error>) -> Void) {
        
        if(!shouldRefreshData() && (getCachedData() != nil || getErrorCacheData() != nil)) {
            if getErrorCacheData() != nil {
                guard let errorData = self.getErrorCacheData() else { return }
                self.resetCachedData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    responseHandler(.failure(errorData))
                }
            }
            
            guard let data = self.getCachedData() else { return }
            self.resetErrorCacheData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                responseHandler(.success(data))
            }
        } else {
            getDataFromApi(msisdn: msisdn, responseHandler: responseHandler)
        }
    }
    
    func validatePayment(msisdn: String, autoRenew: Bool, product: AttProduct, completion: @escaping (Result<AttValidatePaymentResponse, Error>) -> Void) {
        let path = "/ValidatePaymentProfile/data"
        let params = ["uri": "msisdn:\(msisdn)"]
        let headers = commonHeaders
        let body: [String: Any] = [
            "billing": [
                "autoRenew": autoRenew,
                "payment": [
                    "amount": product.price!.amount,
                    "currency": product.price!.currency
                ]
            ],
            "offer": ["id": product.id],
            "includes": ["payment"],
        ]
        
        post(
            path: path,
            params: params,
            headers: headers,
            body: body,
            responseHandler: completion
        )
    }
}

extension AttPaymentsServices {
    private func getDataFromApi(msisdn: String, responseHandler: @escaping (Result<AttViewPaymentProfileResponse, Error>) -> Void) {
        let path = "/ViewPaymentProfile/data"
        let params = ["uri": "msisdn:\(msisdn)"]
        
        let headers = commonHeaders
        
        let viewPaymentProfileRequest = AttViewPaymentProfileRequest(requestID: UUID().uuidString)
        post(path: path, params: params, headers: headers, body: viewPaymentProfileRequest, responseHandler: { (result: Result<AttViewPaymentProfileResponse, Error>) in
            switch result {
            case .success(let data):
                self.saveCachedData(response: data)
                responseHandler(.success(data))
            case .failure(let error):
                if let serverError = error as? AttServerError, serverError.errorCode == "300402374019", serverError.errorMessage == "PaymentPlan Not Found" {
                    self.saveErrorCacheData(serverError: error as! AttServerError)
                }
                responseHandler(.failure(error))
            }
        })
    }
    func shouldRefreshData() -> Bool {
        guard let dateString =  ApolloSDK.current.cacheTime else { return true }
        guard let date = AttDateUtils.convertISO(string: dateString) else  { return true}
        
        let currentDateInMilliseconds = Date().millisecondsSince1970
        let cachedTimeInMilliseconds = date.millisecondsSince1970
        if(currentDateInMilliseconds > cachedTimeInMilliseconds + 36000000) {
            return true
        }
        return false
    }
    
    func saveCachedData(response: AttViewPaymentProfileResponse) {
        self.paymentResponse = response
    }
    func getCachedData() -> AttViewPaymentProfileResponse? {
        return paymentResponse
    }
    func resetCachedData(){
        self.paymentResponse = nil
    }
    //Error Response
    func saveErrorCacheData(serverError: AttServerError) {
        self.errorPaymentResponse = serverError
    }
    func getErrorCacheData() -> AttServerError? {
        return errorPaymentResponse
    }
    func resetErrorCacheData(){
        self.errorPaymentResponse = nil
    }
}

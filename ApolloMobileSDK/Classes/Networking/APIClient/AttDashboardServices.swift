//
//  DashboardServices.swift
//  ApolloMobileSDK
//
//  Created by Elvis on 3/19/21.
//

import Foundation
import Alamofire

class AttDashboardServices: AttAPIClient {
    
    static let shared = AttDashboardServices()
    var clientSessionId: String? = UUID.init().uuidString
    private var dashboardResponse: AttDashboardResponse? = nil
    private var cachedGetDashboardTimestamp: Date = Date()
    
    override init() {
        super.init()
        do {
            let baseUrl = ApolloSDK.current.getEnvironment().baseUrl()
            let path: String = try NetworkConfig.value(for: .REPORTS_BASE_URL)
            
            self.baseURL = baseUrl + path
        } catch let error {
            print("Location: \(#fileID)")
            print("Function: \(#function)")
            print("Error:\n", error)
        }
    }

    func getDashboard(msisdn: String, responseHandler: @escaping (Result<AttDashboardResponse, Error>) -> Void) {
        
        if(shouldLoadDataFromCache()) {
            if let cachedData = getCachedData() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    responseHandler(.success(cachedData))
                }
                return
            }
        }
        getDataFromApi(msisdn: msisdn, responseHandler: responseHandler)
    }
    
    private func getDataFromApi(msisdn: String, responseHandler: @escaping (Result<AttDashboardResponse, Error>) -> Void) {
        let path = "/Services/GetDashboard/data"
        var params = ["uri": "msisdn:\(msisdn)"]
        params["clientSessionId"] = clientSessionId
        
        let headers = commonHeaders
        get(path: path, params: params, headers: headers, responseHandler: { (result: Result<AttDashboardResponse, Error>) in
            switch result {
            case .success(let data):
                self.saveCachedData(response: data)
                self.saveCachedTime(time: Date())
                responseHandler(.success(data))
            case .failure(let error):
                responseHandler(.failure(error))
            }
        })
    }
}

extension AttDashboardServices {
    func shouldLoadDataFromCache() -> Bool {
        let currentDateInMilliseconds = Date().millisecondsSince1970
        let cachedTimeInMilliseconds = cachedGetDashboardTimestamp.millisecondsSince1970
        if(cachedTimeInMilliseconds + 20000 > currentDateInMilliseconds) {
            return true
        }
        return false
    }
    
    func saveCachedData(response: AttDashboardResponse) {
        self.dashboardResponse = response
    }
    
    func getCachedData() -> AttDashboardResponse? {
        return dashboardResponse
    }
    func resetCachedData(){
        self.dashboardResponse = nil
    }
    func saveCachedTime(time: Date) {
        self.cachedGetDashboardTimestamp = time
    }
    
    func getCachedTime() -> Date? {
        return cachedGetDashboardTimestamp
    }
    func resetCacheTime() {
        self.cachedGetDashboardTimestamp = Date()
    }
}

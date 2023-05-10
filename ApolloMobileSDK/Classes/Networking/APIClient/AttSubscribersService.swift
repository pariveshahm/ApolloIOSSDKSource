//
//  SubscribersService.swift
//  ATTORMRetailSDK
//
//  Created by Selma Suvalija on 7/29/20.
//

import Foundation

class AttSubscribersServices: AttAPIClient {
    
    override init() {
        super.init()
        do {
            let baseUrl = ApolloSDK.current.getEnvironment().baseUrl()
            let path: String = try NetworkConfig.value(for: .SUBSCRIBERS_SERVICES_BASE_URL)
            
            self.baseURL = baseUrl + path
            
        } catch let error {
            print("Location: \(#fileID)")
            print("Function: \(#function)")
            print("Error:\n", error)
        }
    }
    
    class func sharedInstance() -> AttSubscribersServices {
        struct Singleton {
            static var sharedInstance = AttSubscribersServices()
        }
        return Singleton.sharedInstance
    }
    
    func createVehicleLink(msisdn: String, vehicleLink: AttVehiclelink, responseHandler: @escaping (Result<AttCreateVehicleLinkResponse, Error>) -> Void) {
        let path = "/CreateVehicleLink/data"
        let params = ["uri": "msisdn:\(msisdn)"]
        let headers = commonHeaders
        
        let createVehicleLinkRequest = AttCreateVehicleLinkRequest(requestID: UUID().uuidString, vehiclelink: vehicleLink)
        post(path: path, params: params, headers: headers, body: createVehicleLinkRequest, responseHandler: responseHandler)
    }
    
    func activateSubscriber(msisdn: String, subscriber: AttSubscriber, responseHandler: @escaping (Result<AttActivateSubscriberResponse, Error>) -> Void) {
        let path = "/ActivateSubscriber/data"
        let params = ["uri": "msisdn:\(msisdn)"]
        let headers = commonHeaders
        
        let createVehicleLinkRequest = AttAddSubscriberRequest(requestID: UUID().uuidString, subscriber: subscriber, includes: ["device", "subscriber"])
        post(path: path, params: params, headers: headers, body: createVehicleLinkRequest, responseHandler: responseHandler)
    }
    
}

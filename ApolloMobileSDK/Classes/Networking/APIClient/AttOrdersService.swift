//  OrdersService.swift
//  ApolloMobileSDK
//
//  Created by Shak4l on 17/02/2021.

import Foundation

class AttOrdersService: AttAPIClient {
    static let shared = AttOrdersService()
//    let clientSessionId = AttDashboardServices.shared.clientSessionId
    override init() {
        super.init()
        
        do {
            let baseUrl = ApolloSDK.current.getEnvironment().baseUrl()
            let path: String = try NetworkConfig.value(for: .ORDER_SERVICES_BASE_URL)
            
            self.baseURL = baseUrl + path
            
        } catch let error {
            print("Location: \(#fileID)")
            print("Function: \(#function)")
            print("Error:\n", error)
        }
    }
    
    private func getEndDate(_ subscription: AttSubscription?) -> Date {
        let now = Date()
        return AttDateUtils.convertToShortDate(string: subscription?.recurrent?.endTime ?? "") ?? now
    }
    
    
    //https://myvehicle-qc.stage.att.com/Thingworx/Things/Orders-1/Services/ViewOrderReceipt/data?uri=msisdn:{{MSISDN}})
    func searchReceiptItem(msisdn: String, item: AttSubscriptionItem, completion: @escaping (Result<AttSubscriptionItem, Error>) -> Void ) {
        let path   = "/ViewOrderReceipt/data"
        let params  = ["uri": "msisdn:\(msisdn)"]
        let header = commonHeaders
        let body = OrderReceiptItemRequest(orderId: item.order?.id ?? "", offerId: item.subscription?.parent ?? item.subscription?.id ?? "")
        
        post(
            path: path,
            params: params,
            headers: header,
            body: body,
            responseHandler: completion
        )
    }
    
    private func getDate(_ string: String? ) -> Date {
        return AttDateUtils.convertToShortDate(string: string ?? "") ?? Date()
    }
    
    func searchReceipt(msisdn: String, completion: @escaping (Result<AttOrderReceiptResponse, Error>) -> Void  ) {
        let path   = "/SearchOrderReceipts/data"
        var params  = ["uri": "msisdn:\(msisdn)"]
        params["clientSessionId"] = AttDashboardServices.shared.clientSessionId
        let header = commonHeaders

        let innerCompletion: (Result<AttOrderReceiptResponse, Error>) -> Void = { result in
                switch (result) {
                case .success(let response):
                    var newOrderReceiptResponse = response
                    var newItems: [AttSubscriptionItem] = []
                    
                    // if empty, no data plan
                    if let items = newOrderReceiptResponse.items, items.isEmpty {
                        completion(.success(newOrderReceiptResponse))
                        return
                    }

                    guard let items = newOrderReceiptResponse.items else { return }
                    var requestCounter: Int = 0

                    for item in items {
                        if item.payment?.method?.lowercased() == "trial" {
                            requestCounter = requestCounter + 1
                            
                            var newItem = item
                            newItem.subscription?.name = "trial_plan_order_history_card".localized()
                            newItems.append(newItem)
                            
                            if requestCounter == items.count {
                                newOrderReceiptResponse.items = newItems
                                completion(.success(newOrderReceiptResponse))
                            }
                        } else {
                            
                            let now = Date()
                            
                            // - Add past orders
                            if ((self.getEndDate(item.subscription) >= now) && (item.subscription?.status == .stacked)) || (item.subscription != nil && self.getEndDate(item.subscription) < now )  {
                                // make API request for each item, and wait them all to finish
                                self.searchReceiptItem(msisdn: msisdn, item: item, completion: { receiptResult in
                                    switch (receiptResult) {
                                        case .success(let newSubscriptionItem):
                                            var newItem = item
                                            newItem.subscription?.name = newSubscriptionItem.subscription?.name
                                            newItems.append(newItem)
                                        case .failure(_):
                                            newItems.append(item)
                                    }

                                    requestCounter = requestCounter + 1
                                    if requestCounter == items.count {
                                        newOrderReceiptResponse.items = newItems
                                        completion(.success(newOrderReceiptResponse))
                                    }
                                })
                                
                            } else {
                                requestCounter = requestCounter + 1
                                if requestCounter == items.count {
                                    newOrderReceiptResponse.items = newItems
                                    completion(.success(newOrderReceiptResponse))
                                }
                            }
                            
                        }
                    }
                case .failure(_):
                    completion(result)
                    break
                }
        }

        get(
            path: path,
            params: params,
            headers: header,
            responseHandler: innerCompletion
        )
    }
}

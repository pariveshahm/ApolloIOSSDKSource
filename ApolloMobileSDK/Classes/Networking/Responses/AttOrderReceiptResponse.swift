//  OrderReceiptResponse.swift
//  ApolloMobileSDK
//
//  Created by Shak4l on 17/02/2021.

import Foundation

struct AttOrderReceiptResponse: Codable {
    var id: String?
    var pagination: Bool?
    var items: [AttSubscriptionItem]?
//  var payment:
//  var providerId:
    var metas: [AttMeta]?
}


struct OrderReceiptItemRequest: Codable {
    var requestId: String
    var order: OrderItem
    var offer: OfferItem

    init(orderId: String, offerId: String) {
        self.requestId = UUID.init().uuidString
        self.order = OrderItem(id: orderId)
        self.offer = OfferItem(id: offerId)
    }
    
    struct OrderItem: Codable {
        var id: String
    }

    struct OfferItem: Codable {
        var id: String
    }
}


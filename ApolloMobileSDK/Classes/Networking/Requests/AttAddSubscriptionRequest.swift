//  AddSubscriptionRequest.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/30/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import Foundation

struct AttAddSubscriptionRequest: Encodable {
    var offer:      AttOffer?
    var billing:    AttBilling?
    var tnc:        AttTNC?
    var subscriber: AttSubscriber?
    var requestId:  String?
    
    var includes = ["subscription"]
    
    init(offer: AttOffer?, billing: AttBilling?, tnc: AttTNC?, subscriber: AttSubscriber?, requestId: String?) {
        self.offer      = offer
        self.billing    = billing
        self.tnc        = tnc
        self.subscriber = subscriber
        self.requestId  = requestId
    }
}

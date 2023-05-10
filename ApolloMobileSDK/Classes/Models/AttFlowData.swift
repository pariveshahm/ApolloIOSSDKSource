//
//  FlowData.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/14/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

class AttFlowData: ObservableObject {
    @Published public var productViewModel: AttProductListRowViewModel?
    @Published public var product: AttProduct?
    @Published public var payment: AttPayment?
    @Published public var billingAddress: AttAddress?
    @Published public var preauthorizationId: String?
    @Published public var isInSpecialOfferFlow: Bool = false
    public init() { }

    public func isInTrialFlow() -> Bool {
          return self.productViewModel?.billingType == AttBillingType.trial.rawValue
    }
}



//  MockViewModal.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/17/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import Foundation

struct AttMockViewModal {
    
    static var products: [AttProduct] = loadFile("products.json")
    
    static func getStepIndicatorSteps() -> [AttStepIndicatorSegmentView] {
        return [
            .init(
                id: 0,
                stepIndicatorSegmentModel: .init(title: "Choose a data plan", showNavigationBar: false, isCompleted: false)
            ),
            .init(
                id: 1,
                stepIndicatorSegmentModel: .init(title: "transaction_summary_step_title".localized(), showNavigationBar: false, isCompleted: false)
            ),
            .init(
                id: 2,
                stepIndicatorSegmentModel: .init(title: "Choose a data plan 3", showNavigationBar: false, isCompleted: false)
            ),
            .init(
                id: 3,
                stepIndicatorSegmentModel: .init(title: "Choose a data plan 4", showNavigationBar: false, isCompleted: false)
            )
        ]
    }
    
    static var mockAddresses: [AttAddress] = [
        .init(line1: "West Main Street # 12", line2: "", postalCode: "30301", city: "Atlanta", region: "GA", country: "US"),
        .init(line1: "West Main Street # 12", line2: "", postalCode: "30301", city: "Atlanta", region: "VI", country: "US"),
        .init(line1: "West Main Street # 13", line2: "", postalCode: "30301", city: "Atlanta", region: "PR", country: "US")
    ]
    
}

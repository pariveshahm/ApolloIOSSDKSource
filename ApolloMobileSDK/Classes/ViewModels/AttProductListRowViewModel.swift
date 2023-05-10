//  ProductListRowViewModel.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 4/7/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import Foundation
import SwiftUI

enum AttProductRowType: String {
    case standard = "standard"
    case warnermedia = "WARNERMEDIA RIDE™ INCLUDED"
    
    func name() -> String {
        switch self {
            case .standard: return ""
            case .warnermedia: return "WARNERMEDIA RIDE™ INCLUDED"
        }
    }
    
    func color() -> Color {
        switch self {
            case .standard: return .clear
            case .warnermedia: return Color(hex: "00a8e0")
        }
    }
}

public class AttProductListRowViewModel: ObservableObject, Hashable {
    @Published var id: String = ""
    @Published var name: String = ""
    @Published var price: String = ""
    @Published var costPerMonth: String = ""
    @Published var autoRenew: Bool = false
    @Published var billingType: String = ""
    
    @Published var productData: AttProduct
    var productType: AttProductRowType {
        get {
            
            let limit = productData.usage?.limit
            if let limit = limit, limit == "unlimited" {
                return .warnermedia
            }
            
            return .standard
        }
    }
    
    init(id: String, name: String, price: String, costPerMonth: String, autoRenew: Bool, billingType: String, productData: AttProduct) {
        self.id = id
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.price = price
        self.costPerMonth = costPerMonth
        self.autoRenew = autoRenew
        self.billingType = billingType
        self.productData = productData
    }

    public static func == (lhs: AttProductListRowViewModel, rhs: AttProductListRowViewModel) -> Bool {
        return lhs.productData.id == rhs.productData.id
    }
    
    public func hash(into hasher: inout Hasher) {
           return hasher.combine(id)
       }
}

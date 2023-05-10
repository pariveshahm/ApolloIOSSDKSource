//
//  Subscription.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/30/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

// MARK: - Subscription
public struct AttSubscription: Codable {
    var billingType: AttBillingType?
    public var usage: AttUsage?
    var name: String?
    var subscriptionDescription: String?
    var startTime, expirationTime: String?
    var id: String?
    var parent: String?
    var type: String?
    var recurrent: AttRecurrent?
    var bundle: Bool?
    var status: SubscriptionStatus?

    enum CodingKeys: String, CodingKey {
        case id, name, parent
        case subscriptionDescription = "description"
        case type, status, usage, recurrent, bundle
        case billingType
        case startTime
        case expirationTime
    }
    
    public init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try? map.decode(String?.self, forKey: .id)
        self.parent = try? map.decode(String?.self, forKey: .parent)
        self.name = try? map.decode(String?.self, forKey: .name)
        self.subscriptionDescription = try? map.decode(String?.self, forKey: .subscriptionDescription)
        self.type = try? map.decode(String?.self, forKey: .type)
        self.usage = try? map.decode(AttUsage?.self, forKey: .usage)
        self.startTime = try? map.decode(String?.self, forKey: .startTime)
        self.expirationTime = try? map.decode(String?.self, forKey: .expirationTime)
        self.recurrent = try? map.decode(AttRecurrent?.self, forKey: .recurrent)
        self.bundle = try? map.decode(Bool?.self, forKey: .bundle)
        
        if let statusString = try? map.decode(String.self, forKey: .status) {
            self.status = SubscriptionStatus(rawValue: statusString) ?? SubscriptionStatus.none
        }
        
        if let billing = try? map.decode(String.self, forKey: .billingType) {
            self.billingType = AttBillingType(rawValue: billing) ?? .some(.none)
        }   
    }
    
    func getName() -> String{
        if billingType == .trial {
            return "trial_plan_order_history_card".localized()
        } else {
            return name ?? ""
        }
    }
    
    public init() {}
}

extension AttSubscription {
    
    enum SubscriptionStatus: String, Codable, CaseIterable {
        case active
        case inactive
        case stacked
        case suspended
        case terminated
        case cancelled
        case pending
        case depleted
        case reserved
        case none
        
        func value() -> String {
            switch self {
            case .active, .depleted:
                return "order_history_active_status".localized()
            case .stacked:
                return "order_history_pending_title".localized()
            case .inactive:
                return "status_expired_pill".localized()
            default:
                return self.rawValue
            }
        }
    }
}

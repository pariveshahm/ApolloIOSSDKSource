//  Product.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/17/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import Foundation

struct AttProduct: Codable {
    
    var id: String
    var name: String
    var type: String
    var billingType: AttBillingType
    
    var description: String?    
    var status: String?
    var expirationTime: String?
    var startTime: String?
    var bundle: Bool?
    
    var price: AttPrice?
    var usage: AttUsage?
    var recurrent: AttProductRecurrent?
    
    var requestId: String? = ""
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id       = try container.decode(String.self, forKey: .id)
        self.name     = try container.decode(String.self, forKey: .name)
        self.type     = try container.decode(String.self, forKey: .type)
        
        self.description    = try? container.decode(Optional<String>.self, forKey: .description)
        self.status         = try? container.decode(Optional<String>.self, forKey: .status)
        self.expirationTime = try? container.decode(Optional<String>.self, forKey: .expirationTime)
        self.startTime      = try? container.decode(Optional<String>.self, forKey: .startTime)
        self.bundle         = try? container.decode(Optional<Bool>.self, forKey: .bundle)
        
        self.price     = try? container.decode(Optional<AttPrice>.self, forKey: .price)
        self.usage     = try? container.decode(Optional<AttUsage>.self, forKey: .usage)
        self.recurrent = try? container.decode(Optional<AttProductRecurrent>.self, forKey: .recurrent)
        
        let biliing = try container.decode(String.self, forKey: .billingType)
        self.billingType = AttBillingType.find(biliing) ?? .none

    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.billingType.rawValue, forKey: .billingType)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.status, forKey: .status)
        try container.encode(self.expirationTime, forKey: .expirationTime)
        try container.encode(self.status, forKey: .startTime)
        try container.encode(self.bundle, forKey: .bundle)
        try container.encode(self.price, forKey: .price)
        try container.encode(self.usage, forKey: .usage)
        try container.encode(self.recurrent, forKey: .recurrent)
    }
    
    init(id: String,
         name: String,
         type: String,
         billingType: AttBillingType,
         description: String? = nil,
         status: String? = nil,
         expirationTime: String? = nil,
         startTime: String? = nil,
         bundle: Bool? = false,
         price: AttPrice? = nil,
         usage: AttUsage? = nil,
         recurrent: AttProductRecurrent? = nil)
         {
        
        self.id   = id
        self.name = name
        self.type = type
        self.billingType = billingType
        self.description = description
        self.status = status
        self.expirationTime = expirationTime
        self.startTime = startTime
        self.bundle = bundle
        self.price = price
        self.usage = usage
        self.recurrent = recurrent
    }

    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case billingType
        
        case description
        case status
        case expirationTime
        case startTime
        case bundle
        
        case price
        case usage
        case recurrent
        case metas
    }
}


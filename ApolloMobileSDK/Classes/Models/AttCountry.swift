//  Country.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 05/01/2021.

import Foundation

struct AttCountry: Identifiable, Hashable, Decodable {
    public var id: Int
    public var code: String
    public var label: String
    public var languages: [Language]
    public var states: [State]
    
    init(code: String = "", label: String = "") {
        self.id         = -1
        self.code       = code
        self.label      = label
        self.languages  = []
        self.states     = []
    }
}

// MARK: - Schemas
extension AttCountry {
    public struct Language: Hashable, Decodable {
        var name: String
        var code: String
    }
    
    public struct State: Hashable, Decodable {
        public var name: String
        public var code: String
    }
}

// MARK: - Extensions
extension AttCountry: Comparable {
    public static func < (lhs: AttCountry, rhs: AttCountry) -> Bool {
        lhs.label < rhs.label
    }
}

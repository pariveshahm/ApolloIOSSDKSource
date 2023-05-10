//  ProductRecurrent.swift
//  ATTORMRetailSDK 
//
//  Created by Selma Suvalija on 5/19/20.

import Foundation

struct AttProductRecurrent: Codable {
    var interval: Int?
    var unit: String?
    var startTime: String?
    var endTime: String?
    var autoRenew: Bool?
}

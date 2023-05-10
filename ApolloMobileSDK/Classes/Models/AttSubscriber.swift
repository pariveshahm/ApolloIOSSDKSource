//  Subscriber.swift
//  ATTORMRetailSDK
//
//  Created by Selma Suvalija on 7/29/20.

import Foundation

// MARK: - Subscriber
struct AttSubscriber: Codable {
    var id: String?
    var firstName: String?
    var lastName: String?
    var address: AttAddress?
    var email: AttEmail?
    var language: String?
    var phone: AttPhone?
    var verified: Bool?
}

//  ValidatePaymentResponse.swift
//  ApolloMobileSDK
//
//  Created by Shak4l on 26/02/2021.

import Foundation

struct AttValidatePaymentResponse: Codable {
    var providerId: String
    var payment: Payment
    var type: String
}

extension AttValidatePaymentResponse {
    struct Payment: Codable {
        var preauthorizationId: String
    }
}

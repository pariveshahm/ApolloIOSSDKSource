//  ServerError.swift
//  ApolloMobileSDK
//
//  Created by Shak4l on 16/02/2021.

import Foundation

struct AttServerError: LocalizedError, Codable {
    var errorMessage: String?
    var errorCode: String
   
    var httpCode: Int?
    
    var errorDescription: String? {
        return errorMessage
    }
}

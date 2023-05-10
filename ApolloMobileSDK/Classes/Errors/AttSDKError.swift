//  SDKError.swift
//  ATTORMRetailSDK
//
//  Created by Selma Suvalija on 6/23/20.

import Foundation

enum AttSDKError: Error {
    case initializationError(String)
    case unknownStepError(String)
}

//
//  Validators.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/30/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation
import SwiftUI

protocol AttFormField {
    var validators: [AttValidator] { get set }

    func isValid() -> (valid: Bool, errors: String)
}


protocol AttValidator {
    var errorMessage: String { get set }
    func isValid() -> Bool
}

struct AttNotEmptyValidator: AttValidator {
    @Binding var value: String
    var errorMessage: String = "fields_must_not_be_empty".localized()
    
    func isValid() -> Bool {
        return !value.isEmpty
    }
}

struct AttLengthValidator: AttValidator {
    @Binding var value: String
    var allowedLength: Int {
        didSet {
            errorMessage = "\("maximum_allowed_length".localized()) \(allowedLength)"
        }
    }
    var errorMessage: String = ""
    
    
    func isValid() -> Bool {
        return value.count ==  allowedLength
    }
}

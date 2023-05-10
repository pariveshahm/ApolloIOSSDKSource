//  UserValidation.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 18/12/2020.

import Foundation

class AttUserValidation {
    
    /// Validate User
    /// - Parameters:
    ///   - user: the user object
    ///   - submiting: is this valdation triggered durring submit
    /// - Returns: Errors [errorKey : errorMessage]
    static func validate(_ user: AttUser, keyPrefix: String) -> [String: String] {
        var errors: [String: String] = [:]
        
        if user.firstName.isEmpty && !user.firstName.hasPrefix(" ")  {
            errors[keyPrefix + "firstName"] = "createAccount_form_validation_first_name".localized()
        }
        
        if user.lastName.isEmpty && !user.lastName.hasPrefix(" ") {
            errors[keyPrefix + "lastName"] = "createAccount_form_validation_last_name".localized()
        }
        
        if user.email.isEmpty {
            errors[keyPrefix + "email"] = "createAccount_form_validation_email".localized()
        } else if !isValidEmail(user.email) {
            errors[keyPrefix + "email"] = "createAccount_form_validation_email_not_valid".localized()
        }
        
        if user.phone.isEmpty {
            errors[keyPrefix + "phone"] = "createAccount_form_validation_mobile_wireless_number".localized()
        } else if !isValidPhone(user.phone) {
            errors[keyPrefix + "phone"] = "createAccount_form_validation_mobile_wireless_number_not_valid".localized()
        }
        
        if user.language.name.isEmpty {
            errors[keyPrefix + "language"] = "please_select_language".localized()
        }
        
        if user.address.street.isEmpty {
            errors[keyPrefix + "street"] = "createAccount_form_validation_street".localized()
        } else if user.address.street.lowercased().contains("po box") {
            errors[keyPrefix + "street"] = "createAccount_form_validation_validate_address_postal_code_invalid".localized()
        } else if user.address.street.lowercased().contains("p.o. box") {
            errors[keyPrefix + "street"] = "createAccount_form_validation_validate_address_postal_code_invalid".localized()
        }
        
        if user.address.zipCode.isEmpty {
            if (user.address.country.code == "US") {
                errors[keyPrefix + "zipCode"] = "createAccount_form_validation_zip_code".localized()
            } else {
                errors[keyPrefix + "zipCode"] = "createAccount_form_validation_postal_code".localized()
            }
        } else if !isValidZip(user.address.zipCode, countryCode: user.address.country.code) {
            if (user.address.country.code == "US") {
                errors[keyPrefix + "zipCode"] = "createAccount_form_validation_zip_code_valid".localized()
            } else {
                errors[keyPrefix + "zipCode"] = "createAccount_form_validation_postal_code_valid".localized()
            }
        }
        
        if user.address.state.name.isEmpty {
            errors[keyPrefix + "state" ] = "please_select_state".localized()
        }
        
        if user.address.city.isEmpty {
            errors[keyPrefix + "city"] = "createAccount_form_validation_city".localized()
        }
        
        if user.address.country.label.isEmpty {
            errors[keyPrefix + "country"] = "please_select_country".localized()
        }
        
        return errors
    }
}

// MARK: - Private
extension AttUserValidation {
    
    private static func isValidEmail(_ email: String) -> Bool {
        let pattern = "^([\\w-]+(?:\\.[\\w-]+)*)@((?:[\\w-]+\\.)*\\w[\\w-]{0,66})\\.([a-zA-Z]{2,6}(?:\\.[a-zA-Z]{2})?)$"
        let regex = try! NSRegularExpression(pattern: pattern,
                                             options: .caseInsensitive)
        
        let range = NSRange(location: 0, length: email.count)
        let match = regex.firstMatch(in: email, options: [], range: range)
        return match != nil
    }
    
    private static func isValidPhone(_ number: String) -> Bool {
        let pattern = "^\\(?([0-9]{3})\\)?[-.●]?([0-9]{3})[-.●]?([0-9]{4})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        let result = predicate.evaluate(with: number)
        return result
    }
    
    private static func isValidZip(_ zip: String, countryCode: String) -> Bool {
        let pattern: String
        
        switch countryCode {
        case "US":
            pattern = "^(\\d{5}$)|(^\\d{5}-\\d{4})$"
        case "CA":
            pattern = "^[A-Za-z]\\d[A-Za-z][ -]?\\d[A-Za-z]\\d$"
        default:
            pattern = "^(?:[A-Z0-9]+([- ]?[A-Z0-9]+)*)?$"
        }
        
        let regex = try! NSRegularExpression(pattern: pattern,options: .caseInsensitive)
        let range = NSRange(location: 0, length: zip.count)
        let match = regex.firstMatch(in: zip, options: [], range: range)

        return match != nil
    }
}

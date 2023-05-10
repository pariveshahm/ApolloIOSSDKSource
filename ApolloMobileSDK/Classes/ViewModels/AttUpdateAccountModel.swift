//
//  AttUpdateAccountModel.swift
//  ApolloMobileSDK
//
//  Created by Nermin Sabanovic on 21. 10. 2022..
//

import Combine

final class AttUpdateAccountModel: ObservableObject {
    
    // - State
    @Published var isPosting  = false
    @Published var pristine   = true
    @Published var showError  = false
    @Published var showContact = false
    
    var presentAddressDialog: (_ replaceAddress: @escaping (AttAddress) -> (), _ addresses: [AttAddress]) -> Void = {_,_  in }
    
    @Published private(set) var addresses: [AttAddress] = []
    @Published private(set) var errors:    [String: String] = [:]
    
    @Published var user = ApolloSDK.current.getUser() {
        didSet {
            
            if oldValue.address.country != user.address.country {
                states    = user.address.country.states
                
                if !oldValue.address.zipCode.isEmpty {
                    user.address.zipCode = ""
                }
                
                if !oldValue.address.state.code.isEmpty {
                    user.address.state   = .init(name: "", code: "")
                }
            }

            validate()
        }
    }
    
    // - Properties
    private(set) var states:    [AttCountry.State]    = []
    
    // - Data
    lazy private(set) var countries: [AttCountry] = loadFile("countries.json")
}

// MARK: - Public
extension AttUpdateAccountModel {
    
    func validate(forOnSubmit submiting: Bool = false) {
        errors = AttUserValidation.validate(user, keyPrefix: submiting ? "submit_" : "")
    }
    
    func validateAddress(_ completion: @escaping (Bool) -> Void) {
        self.isPosting = true
        
        // for testing purposes
        #if DEBUG
        if WidgetErrorsDebuggingFlags().skipValidateAddress {
            completion(true)
            print("WidgetErrorsDebuggingFlags().skipValidateAddress is ON")
            return
        }
        #endif
        
        if ApolloSDK.current.getIsValidateAddressUsed() == false {
            self.isPosting = false
            completion(true)
            return
        }
        
        AttSubscriptionsServices.shared.validateAddress(user.address) { (result) in
            self.isPosting = false
            
            switch result {
            case .success(let res):
                let foundAddress = res.addresses.first(where: {
                        $0.city?.lowercased() != self.user.address.city.lowercased()  ||
                        $0.country != self.user.address.country.code ||
                        $0.postalCode != self.user.address.zipCode   ||
                        $0.region != self.user.address.state.code    ||
                        $0.line1?.lowercased() != self.user.address.street.lowercased()
                })
                
                if (foundAddress != nil) {
                    self.addresses = res.addresses
                 
                    self.presentAddressDialog(self.replaceAddress, self.addresses)
                    completion(false)
                } else {
                    completion(true)
                }
                
            case .failure(let error):
                print("Location: \(#fileID)")
                print("Function: \(#function)")
                print("Error:\n", error.localizedDescription)
                
                completion(false)
                
                guard let serverError = error as? AttServerError else {
                    self.showError = true
                    return
                }
                
                if serverError.errorCode == "30001126002" {
                    self.errors["submit_street"] = "createAccount_form_validation_validate_address_street_name_invalid".localized()
                    self.showContact = true
                    return
                }
                
                if serverError.errorCode == "30000062002" {
                    self.errors["submit_zipCode"] = "createAccount_form_validation_validate_address_zip_code_invalid".localized()
                    self.showContact = true
                    return
                }
                
                if serverError.errorCode == "30000477002" {
                    self.errors["submit_street"] = "createAccount_form_validation_validate_address_street_name_invalid".localized()
                    self.showContact = true
                    return
                }
                
                self.showError = true
            }
        }
    }
    
    func replaceAddress(_ value: AttAddress) {
        
        if let street = value.line1 {
            user.address.street = street
        }
        
        if let city = value.city {
            user.address.city = city
        }
        
        if let postalCode = value.postalCode {
            user.address.zipCode = postalCode
        }
        
        if let regionCode = value.region, let region = states.first(where: { $0.code == regionCode }) {
            user.address.state = region
        }
        
    }
}

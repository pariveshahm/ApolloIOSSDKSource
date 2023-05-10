//
//  CreditCardInfoViewModel.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/30/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation
import SwiftUI

class AttCreditCardInfoViewModel: ObservableObject {

    @Published var creditCardNumber: String = ""
    @Published var expires: String = ""
    @Published var nameOnCard: String = ""
    @Published var address: String = ""
    @Published var city: String = ""
    @Published var state: String = ""
    @Published var zipCode: String = ""
    @Published var country: String = ""
    
    @Published var showActivityIndicator = true
    @Published var errorCode = false
    @Published var otherError = false
    @Published var errorMessage = ""
    var billingAddress: AttAddress? = nil
    private var isLoadingCard: Bool = false

    func fetchPaymentProfileData(completion: @escaping (AttAddress?) -> Void) {
        AttPaymentsServices.shared.viewPaymentProfile(msisdn: ApolloSDK.current.getMsisdn(),  responseHandler: {result in
            self.showActivityIndicator = false
            switch result {
            case .success(let paymentProfile):
                if let creditCard = paymentProfile.paymentProfile?.card, let billingAddress = paymentProfile.billing?.address {
                    self.nameOnCard = creditCard.name ?? ""
                    self.creditCardNumber = creditCard.number ?? ""
                    self.expires = creditCard.expirationDate ?? ""
                    self.address = paymentProfile.billing?.address?.line1 ?? ""
                    self.city = paymentProfile.billing?.address?.city ?? ""
                    self.state = paymentProfile.billing?.address?.region ?? ""
                    self.zipCode = paymentProfile.billing?.address?.postalCode ?? ""
                    self.country = paymentProfile.billing?.address?.country ?? ""
                    
                    self.billingAddress = billingAddress
                    completion(billingAddress)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                completion(nil)
            }
        })
    }
    
    func fetchCreditCard(completion: @escaping (AttCard?) -> Void) {
        if self.isLoadingCard == true {
            return
        }
        self.isLoadingCard = true
        self.showActivityIndicator = true
        AttPaymentsServices.shared.viewPaymentProfile(msisdn: ApolloSDK.current.getMsisdn(),  responseHandler: {result in
            self.isLoadingCard = false
            switch result {
            case .success(let paymentProfile):
                if let creditCard = paymentProfile.paymentProfile?.card {
                    self.nameOnCard = creditCard.name ?? ""
                    self.creditCardNumber = creditCard.number ?? ""
                    self.expires = creditCard.expirationDate ?? ""
                    self.address = paymentProfile.billing?.address?.line1 ?? ""
                    self.city = paymentProfile.billing?.address?.city ?? ""
                    self.state = paymentProfile.billing?.address?.region ?? ""
                    self.zipCode = paymentProfile.billing?.address?.postalCode ?? ""
                    self.country = paymentProfile.billing?.address?.country ?? ""
                    completion(creditCard)
                     
                    self.showActivityIndicator = false
                } else {
                    completion(nil)
                }
                self.errorCode = false
                self.otherError = false
            case .failure(let error):
                self.isLoadingCard = true
                self.showActivityIndicator = false
                if let serverError = error as? AttServerError, serverError.errorCode == "300402374019", serverError.errorMessage == "PaymentPlan Not Found" {
                    self.errorCode = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.isLoadingCard = false
                    }
                    return
                } else {
                    self.otherError = true
                }
                completion(nil)
            }
        })
    }
}

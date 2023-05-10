//  PaymentViewModel.swift
//  ApolloMobileSDK
//
//  Created by Shak4l on 27/02/2021.

import Foundation

final class AttPaymentViewModel: ObservableObject {
    
    // - State
    @Published var showLoading = false
    @Published var isAddSubscriptionError   = false
    @Published var isValidatePaymentError   = false
    
    // - Props
    var autoRenew: Bool
    var product: AttProduct
    
    init(autoRenew: Bool, product: AttProduct) {
        self.autoRenew  = autoRenew
        self.product    = product
    }
}

// MARK: - Public
extension AttPaymentViewModel {
    
    func purchaseProduct(completion: @escaping () -> Void) {
        let msisdn = ApolloSDK.current.getMsisdn()
        self.showLoading = true
        
        // for testing purposes
        #if DEBUG
        if ErrorDebuggingFlags().showPlanPurchaseError {
            DispatchQueue.main.async {
                self.showLoading = false
                self.isValidatePaymentError   = true
            }
            print("ErrorDebuggingFlags().showPlanPurchaseError is ON")
            return
        }
        #endif
        
        AttPaymentsServices.shared.validatePayment(
            msisdn: msisdn,
            autoRenew: autoRenew,
            product: product) { (result) in
            
            switch result {
            case .success(let res):
                self.addSubscription(
                    msisdn: msisdn,
                    preauthorizationId: res.payment.preauthorizationId,
                    completion
                )
            case .failure(_):
                DispatchQueue.main.async {
                    self.showLoading = false
                    self.isValidatePaymentError   = true
                }
            }
        }
    }
    
}

// MARK: - Private
extension AttPaymentViewModel {
    
    private func addSubscription(msisdn: String, preauthorizationId: String,_ completion: @escaping () -> Void) {
        let tnc = AttConstants.loadTNC(
            for: ApolloSDK.current.getCountry().rawValue,
            billingType: .prepaid,
            lang: ApolloSDK.current.getLanguage().rawValue
        )
        
        // for testing purposes
        #if DEBUG
        if ErrorDebuggingFlags().showAddSubscriptionError {
            DispatchQueue.main.async {
                self.showLoading = false
                self.isAddSubscriptionError   = true
            }
            print("ErrorDebuggingFlags().showAddSubscriptionError is ON")
            return
        }
        #endif
        
        AttSubscriptionsServices.shared.addSubscription(
            msisdn: msisdn,
            product: product,
            tnc: tnc,
            autoRenew: autoRenew,
            preauthorizationId: preauthorizationId) { (result) in
            
            switch result {                
            case .success(_):
                ApolloSDK.current.resetSubscriptionData()
                completion()
            case .failure(_):
                DispatchQueue.main.async {
                    self.showLoading = false
                    self.isAddSubscriptionError   = true
                }
            }
        }
    }
    
    private func addConsents(_ completion: @escaping () -> Void) {
        AttConsentsServices.shared.addConsent { (result) in
            completion()
            
            switch result {
            case .success(let res):
                print(res)
            case .failure(let err):
                print(err)
            }
        }
    }
    
}

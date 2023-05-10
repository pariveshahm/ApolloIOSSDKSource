//  TransactionSummaryModel.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 04/01/2021.

import Combine

final class AttTransactionSummaryModel: ObservableObject {
    
    // - State
    @Published var user: AttUser      = .init()
    @Published var acceptTerms     = false
    @Published var acceptConsent   = false
    @Published var autoRenew       = false
    @Published var showError       = false
    @Published var showVehicleError             = false
    @Published var showActivateSubscriberError             = false
    @Published var showConsentError             = false
    @Published private(set) var showConsent     = true
    @Published private(set) var showLoading       = true
    @Published private(set) var showLoadingMessage       = false
    @Published private var creditCardInfoViewModel = AttCreditCardInfoViewModel()
    @Published private var productViewModel = AttProductListViewModel()
    // - Properties
    var base:  String
    var tax:   String
    var fees:  String
    var total: String?
    var monthlyTotal: String?
    var isTrial: Bool
    var isSpecialOffer: Bool {
        product.id == AttConstants.getSpecialOfferId()
    }
    
    var isTransactionSummaryViewVisible: Bool = false
    
    private var subscriber: AttSubscriber?
    private var product: AttProduct
    private var consent: AttConsent?
    
    // - Init
    init(_ product: AttProduct) {
        self.product = product
        self.isTrial = product.billingType == .trial
        self.base    = "$0.00"
        self.tax     = "$0.00"
        self.fees    = "$0.00"
//        self.total   = isTrial ? "$0.00" : " \(product.price?.currency?.getCurrencySymbol() ?? "$")\(product.price?.amount ?? "0.00")"
//        self.monthlyTotal = isTrial ? "$0.00" : "\(product.price?.currency?.getCurrencySymbol() ?? "$")\(product.price?.amount ?? "0.00")"
    }
}

// MARK: - Public
extension AttTransactionSummaryModel {
    
    func activateTrial(_ completion: @escaping () -> Void) {
        self.showLoadingMessage = true
        let msisdn = ApolloSDK.current.getMsisdn()
        
        let tnc = AttConstants.loadTNC(
            for: user.address.country.code,
            billingType: .prepaid,
            lang: user.language.code
        )
        
        // for testing purposes
        #if DEBUG
        if ErrorDebuggingFlags().showAddSubscriptionTrialError {
            DispatchQueue.main.async {
                self.showLoadingMessage = false
                self.showError = true
            }
            print("ErrorDebuggingFlags().showAddSubscriptionTrialError is ON")
            return
        }
        #endif
        
        AttSubscriptionsServices.shared.addTrialSubscription(
            msisdn: msisdn,
            product: product,
            user: user,
            tnc: tnc) { (result) in
            
            switch result {
            case .success(_):
                AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                self.addOrUpdateConsents {
                    self.showLoading = false
                    self.showLoadingMessage = false
                    completion()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showLoading = false
                    self.showLoadingMessage = false
                    self.showError = true
                }
            }
        }
    }
    
    func activateDataPlan(_ completion: @escaping () -> Void) {
        self.addOrUpdateConsents(completion)
    }
    
    func initalSetup() {
        AttConsentsServices.shared.resetCachedData()
        if isTransactionSummaryViewVisible == false {
            showLoading = false
            showLoadingMessage = false
            return
        }
        
        self.showError = false
        self.showActivateSubscriberError = false
        self.showVehicleError = false
        self.showConsentError = false
        self.showLoadingMessage = false

        // REGISTERED USER
        if (ApolloSDK.current.getIsNewUser() == false || self.isTrial == true) {
            self.loadQoute {
              //  self.loadPaymentInfo{
                    self.loadConsent()
                if self.isTrial == false && self.isSpecialOffer == false {
                    AttDashboardServices.shared.resetCachedData()
                    AttPaymentsServices.shared.resetErrorCacheData()
                    self.creditCardInfoViewModel.fetchPaymentProfileData(completion: {_ in})
                    self.productViewModel.fetchDashboardData(completion: {})
                }
              //  }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.showLoading = false
                        }
            return
        }
        
        self.showLoading = false
        self.createVehicleLink()
    }
    
    func createVehicleLink() {
        let iccid = ApolloSDK.current.getIccid()
        let sim = AttSim(msisdn: nil, iccid: iccid, metas: nil)
        let device = AttDevice(id: nil, idType: nil, sim: sim, country: nil, tenant: nil)
        let msisdn = ApolloSDK.current.getMsisdn()
        let vehicleLink = AttVehiclelink(vehicle: nil, device: device, subscriber: nil, name: nil, type: nil)
        
        // for testing purposes
        #if DEBUG
        if ErrorDebuggingFlags().showCreateVehicleError {
            DispatchQueue.main.async {
                self.showLoading = false
                self.showLoadingMessage = false
                self.showVehicleError = true
            }
            print("ErrorDebuggingFlags().showCreateVehicleError is ON")
            return
        }
        #endif
        
        showLoading = true
        
        // NEW USER
        AttSubscribersServices().createVehicleLink(msisdn: msisdn, vehicleLink: vehicleLink) { createVehicleResult in
            switch createVehicleResult {
            case .success(let createdVehicle):
                AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                if let first = createdVehicle.vehiclelinks?.first, var subscriberr = first.subscriber {
                    let user = self.user
                    subscriberr.firstName = user.firstName
                    subscriberr.lastName = user.lastName
                    subscriberr.address = AttAddress(line1: user.address.street,
                                                 line2: nil,
                                                 postalCode: user.address.zipCode,
                                                 city: user.address.city,
                                                 region: user.address.state.code,
                                                 country: user.address.country.code)
                    subscriberr.email = AttEmail(address: user.email)
                    subscriberr.language = user.language.code
                    subscriberr.phone = AttPhone(number: user.phone)
                    
                    self.subscriber = subscriberr
                    self.activateSubscriber()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showLoading = false
                    self.showLoadingMessage = false
                    self.showVehicleError = true
                    print(error)
                }
            }
        }
    }
    
    func activateSubscriber() {
        let msisdn = ApolloSDK.current.getMsisdn()
        guard let subscriber = subscriber else {
            return
        }
        // for testing purposes
        #if DEBUG
        if ErrorDebuggingFlags().showActivateSubscriberError {
            DispatchQueue.main.async {
                self.showLoading = false
                self.showLoadingMessage = false
                self.showActivateSubscriberError = true
            }
            print("ErrorDebuggingFlags().showActivateSubscriberError is ON")
            return
        }
        #endif
        
        showLoading = true
        
        AttSubscribersServices().activateSubscriber(msisdn: msisdn, subscriber: subscriber) { (addSubscriberResult) in
            switch addSubscriberResult {
            case .success:
                AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                ApolloSDK.current.isNewUser(false)
                self.loadQoute {
                    self.loadPaymentInfo{
                        self.loadConsent()
                        self.showLoading = false
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showLoading = false
                    self.showLoadingMessage = false
                    self.showActivateSubscriberError = true
                    print(error)
                }
            }
        }
    }
    
    func loadPaymentInfo(_ completion: @escaping () -> Void) {
        AttPaymentsServices.shared.viewPaymentProfile(msisdn: ApolloSDK.current.getMsisdn(),  responseHandler: {result in
            completion()
        })
    }
    
    func loadConsent() {
        searchConsent { (doesExist) in
            self.showConsent = !doesExist

        }
    }
}

// MARK: - Private
extension AttTransactionSummaryModel {
    
    private func addOrUpdateConsents(_ completion: @escaping () -> Void) {
        if showConsent == false {
            completion()
            return
        }
        
        self.showLoading = true
        
        switch self.acceptConsent {
        case true:
            AttConsentsServices.shared.addConsent { (result) in
                switch result {
                case .success(_):
                    completion()
                case .failure(_):
                    completion()
                }
            }
        case false:
            completion()
        }
    }
    
    private func searchConsent(_ completion: @escaping (Bool) -> Void) {
        // for testing purposes
        #if DEBUG
        if ErrorDebuggingFlags().showSearchConsentError {
            DispatchQueue.main.async {
                self.showConsentError = true
            }
            print("ErrorDebuggingFlags().showSearchConsentError is ON")
            return
        }
        #endif
        
        AttConsentsServices.shared.searchConsents { (result) in
            switch result {
            case .success(let res):
                let marketingConsent = res.items?.first(where: { $0.consent?.tnc?.document?.id == "ATTWIFICONSENT" })
                let isConsentOn = marketingConsent?.consent?.isActive ?? false
                self.consent = marketingConsent?.consent
                completion(isConsentOn)
            case .failure(let error):
                let serverError = error as? AttServerError
                if serverError?.errorCode == "404" {
                    completion(false)
                } else if serverError?.errorCode == "1414" {
                    completion(false)
                } else {
                    self.showConsentError = true
                }
            }
        }
    }
    
    private func loadQoute(_ completion: @escaping () -> Void) {
        guard !isTrial else {
            completion()
            return
        }
        
        let msisdn = ApolloSDK.current.getMsisdn()
        AttProductsServices.shared.viewProductQuote(msisdn: msisdn, offerId: product.id) { (result) in
            switch result {
            case .success(let res):
                guard let qoute = res.quote else { return }
                
                if let taxes = qoute.totalTaxes {
                    self.tax = AttCurrencyFormatter.format(amount: taxes.amount ?? "0.0",
                                                        curreny: taxes.currency?.getCurrencySymbol() ?? "USD")
                }
                
                if let base = qoute.base {
                    self.base = AttCurrencyFormatter.format(amount: base.amount ?? "0.0",
                                                         curreny: base.currency?.getCurrencySymbol() ?? "USD")
                }
                
                if let surcharge = qoute.surcharge {
                    self.fees = AttCurrencyFormatter.format(amount: surcharge.amount ?? "0.0",
                                                         curreny: surcharge.currency?.getCurrencySymbol() ?? "USD")
                }
                
                if let total = qoute.total {
                    let amount   = total.amount ?? "0.0"
                    let currency = total.currency ?? "$"
                    self.total        = AttCurrencyFormatter.format(amount: amount, curreny: currency)
                    self.monthlyTotal = AttCurrencyFormatter.format(amount: amount, curreny: currency)
                }
                
            case .failure(_):
                self.showError = true
            }
            completion()
        }
    }
}

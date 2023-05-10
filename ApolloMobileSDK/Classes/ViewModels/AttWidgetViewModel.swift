//  AttWidgetViewModel.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 11/12/20.
//  Edited by Shak4l on 20/01/21.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import Foundation

public protocol AttWidgetViewModelDelegate {
    func onWidgetHeightUpdated()
}

public enum AttButtonClickType {
    case Connectivity
    case InvokeVehicleAvailability
}

public class AttWidgetViewModel: ObservableObject {
    
    @Published var subscription: AttSubscriptionViewModel = .init()
    @Published var dashboardResult: AttDashboardResponse? = nil
    @Published var showLoading        = true
    @Published var showError        = false
    @Published var showAuthenticationError        = false
    @Published var showSubscriptionError        = false
    @Published var showMissingBilingTypeError = false
    @Published var showMissingSubscriberInfoError = false
    @Published var showMissingVehicleInfoError = false
    @Published var showMissingDeviceInfoError = false
    @Published var isTrialEligible  = false
    @Published var isPurchaseWifiDataEligible = false
    @Published var isVehicleNonEligible = false
    @Published var hasActivePlan    = false
    @Published var noDataPlan  = false
    
    var isLoading        = false
    
    public var verticalPadding: CGFloat  {
        get {
            return AttAppTheme.attSDKWidgetVerticalPadding
        }
    }
    
    public var horizontalPadding: CGFloat {
        get {
            return AttAppTheme.attSDKWidgetHorizontalPadding
        }
    }
    var isNewUser = false
    var isRecredentialed = false
    var product: AttProduct?
    
    public var output: AttWidgetViewModelDelegate?
    public var automaticLoad = true
    var isViewVisible = false
    private var hasStackedRetailPlanError = false
    
    public init() {}
    
    public func setViewActive() {
        isViewVisible = true
    }
    
    public func setViewInactive() {
        isViewVisible = false
    }
}
// MARK: - Public
extension AttWidgetViewModel {
    
    public func fetchDashboardData(checkCached: Bool, completion: @escaping () -> Void) {
        self.showMissingBilingTypeError = false
        self.showMissingSubscriberInfoError = false
        self.showMissingVehicleInfoError = false
        self.showMissingDeviceInfoError = false
        
        AttDashboardServices.shared.getDashboard(msisdn: ApolloSDK.current.getMsisdn(), responseHandler: {result in
            switch result {
            case .success(let dashboardData):
                self.dashboardResult = dashboardData
                self.isLoading = true
                self.showLoading = true
                // for testing purposes
#if DEBUG
                if ErrorDebuggingFlags().showMissingSubscriberInfoError {
                    DispatchQueue.main.async {
                        self.showMissingSubscriberInfoError = true
                    }
                    print("ErrorDebuggingFlags().showMissingSubscriberInfoError is ON")
                }
                if ErrorDebuggingFlags().showMissingBilingTypeError {
                    DispatchQueue.main.async {
                        self.showMissingBilingTypeError = true
                    }
                    print("ErrorDebuggingFlags().showMissingBilingTypeError is ON")
                }
                if ErrorDebuggingFlags().showMissingVehicleInfoError {
                    DispatchQueue.main.async {
                        self.showMissingVehicleInfoError = true
                    }
                    print("ErrorDebuggingFlags().showMissingVehicleInfoError is ON")
                }
                if ErrorDebuggingFlags().showMissingDeviceInfoError {
                    DispatchQueue.main.async {
                        self.showMissingDeviceInfoError = true
                    }
                    print("ErrorDebuggingFlags().showMissingDeviceInfoError is ON")
                }
#endif
                
                let vehicleLinks = dashboardData.items?.first?.vehiclelinks ?? []
                let subscriber = dashboardData.items?.first?.subscriber
                let subscriptions: [AttSubscription] = dashboardData.items?.first?.subscriptions ?? []
                
                
                let activeTrialPlan: AttSubscription? = subscriptions.filter({ (subscription) -> Bool in return subscription.billingType == AttBillingType.trial && (subscription.status == .active || subscription.status == .depleted) }).first
                let oneStackedPlan: AttSubscription? = subscriptions.filter({ (subscription) -> Bool in return subscription.status == .stacked }).first
                
                let activeSubscriptions = subscriptions.filter({ (subscription) -> Bool in
                    return subscription.status == .active || subscription.status == .depleted
                })
                
                let validBilingTypes = activeSubscriptions.filter({ (subscription) -> Bool in
                    return subscription.billingType == AttBillingType.trial || subscription.billingType == AttBillingType.prepaid || subscription.billingType == AttBillingType.none
                })
                
                self.hasStackedRetailPlanError = false
                if let _ = activeTrialPlan, let _ = oneStackedPlan {
                    self.hasStackedRetailPlanError = true
                }
                
                if let _ = activeSubscriptions.first(where: { $0.billingType == nil }) {
                    self.showMissingBilingTypeError = true
                }
                
                if validBilingTypes.isEmpty == false && (subscriber?.email?.address?.isEmpty ?? true) ||  (subscriber?.address == nil) {
                    self.showMissingSubscriberInfoError = true
                }
                
                let missingVehicleInfo = vehicleLinks.filter { (vehicleLink) -> Bool in
                    return ((vehicleLink.vehicle?.country?.isEmpty ?? true) || (vehicleLink.vehicle?.make?.isEmpty ?? true) || (vehicleLink.vehicle?.tenant?.isEmpty ?? true))
                }
                
                if (vehicleLinks.isEmpty || missingVehicleInfo.isEmpty == false) {
                    self.showMissingVehicleInfoError = true
                }
                
                let missingDeviceInfo = vehicleLinks.filter { (vehicleLink) -> Bool in
                    return (vehicleLink.device?.country?.isEmpty ?? true) || (vehicleLink.device?.sim?.iccid?.isEmpty ?? true)
                }
                
                if missingDeviceInfo.isEmpty == false {
                    self.showMissingDeviceInfoError = true
                }
                
                
                self.setActiveSubscriptionFromDashboard(subscriptions: subscriptions)
                self.isLoading = false
                completion()
                
            case .failure(let error):
                if let serverError = error as? AttServerError {
                    if let httpCode = serverError.httpCode {
                        switch httpCode {
                            case 400:
                                self.showError = true
                            case 401:
                                self.showAuthenticationError = true
                            case 403:
                                self.showSubscriptionError = true
                            default:
                                self.showError = true
                        }
                    } else {
                        switch serverError.errorCode {
                            case "401":
                                self.showAuthenticationError = true
                            case "403":
                                self.showSubscriptionError = true
                            case "1355":
                                if serverError.errorMessage == "Not authorized to use the service" {
                                    self.showSubscriptionError = true
                                } else {
                                    self.showAuthenticationError = true
                                }
                            default:
                                self.showError = true
                        }
                    }
                    
                } else {
                    self.showError = true
                }
                
                self.isLoading = false
                completion()
                return
            }
        })
    }
    
    func validateSubscription(checkCached: Bool, vin: String, getAvailabilityOnly: Bool = false) {
        if let response = AttSubscriptionsServices.shared.getCachedData() {
            self.showError = false
            self.showAuthenticationError = false
            self.showSubscriptionError = false
            self.isPurchaseWifiDataEligible = self.checkIsPurchaseWifiDataEligible(response: response)
            self.noDataPlan = true
            self.isNewUser = !(ApolloSDK.current.checkIsRegisteredUser(response: response))
            self.isRecredentialed = ApolloSDK.current.checkIsReCredentialedUser(response: response)
            
            let vehicleAvailability = self.notifyVehicleAvailability(response: response)
            self.isVehicleNonEligible = (vehicleAvailability == AttWidgetVehicleAvailability.VEHICLE_NOT_ELIGIBLE.rawValue)
            
            ApolloSDK.current.iccid(response.device?.sim?.iccid ?? "")
            ApolloSDK.current.msisdn(response.device?.sim?.msisdn ?? "")
            ApolloSDK.current.isNewUser(self.isNewUser)
            
            if getAvailabilityOnly {
                self.isLoading = false
                self.showLoading = false
                return
            }
            
            if (response.status?.trial == "available") {
                self.isTrialEligible = true
                self.isLoading = false
                self.showLoading = false
                return;
            }
            
            if self.isNewUser == false  {
                self.fetchDashboardData(checkCached: checkCached) {
                    self.isLoading = false
                    self.showLoading = false
                }
                return;
            }
            
            self.isLoading = false
            self.showLoading = false
            self.isTrialEligible = false
            
            return
        }
        
        AttSubscriptionsServices.shared.validateSubscription(vin: vin, responseHandler: { result in
            switch result {
            case .success(let response):
                AttSubscriptionsServices.shared.saveValidateSubscriptionData(response: response)
                self.showError = false
                self.showAuthenticationError = false
                self.showSubscriptionError = false
                self.isPurchaseWifiDataEligible = self.checkIsPurchaseWifiDataEligible(response: response)
                
                self.isNewUser = !(ApolloSDK.current.checkIsRegisteredUser(response: response))
                self.isRecredentialed = ApolloSDK.current.checkIsReCredentialedUser(response: response)
                
                ApolloSDK.current.iccid(response.device?.sim?.iccid ?? "")
                ApolloSDK.current.msisdn(response.device?.sim?.msisdn ?? "")
                ApolloSDK.current.isNewUser(self.isNewUser)
                
                if (response.status?.trial == "available" || response.status?.shared == "inactive" || response.status?.postpaid == "inactive" || response.status?.prepaid == "inactive") {
                    let vehicleAvailability = self.notifyVehicleAvailability(response: response)
                    self.isVehicleNonEligible = (vehicleAvailability == AttWidgetVehicleAvailability.VEHICLE_NOT_ELIGIBLE.rawValue)
                   
                    if getAvailabilityOnly {
                        self.isLoading = false
                        self.showLoading = false
                        return
                    }
                }
                
                if (response.status?.trial == "available") {
                    self.isTrialEligible = true
                    self.isLoading = false
                    self.showLoading = false
                    return;
                }
                
                if self.isNewUser == false  {
                    self.fetchDashboardData(checkCached: false) {
                        self.isLoading = false
                        self.showLoading = false
                    }
                    return;
                }
                
                self.isLoading = false
                self.isTrialEligible = false
            case .failure(let error):
                self.isLoading = false
                
                if let serverError = error as? AttServerError {
                    if let httpCode = serverError.httpCode {
                        switch httpCode {
                            case 400:
                                self.showError = true
                                ApolloSDK.current.delegate?.vinStateUpdated(vehicleAvailability: AttWidgetVehicleAvailability.VEHICLE_ELIGIBLITIY_BAD_REQUEST.rawValue)
                            case 401:
                                self.showAuthenticationError = true
                                ApolloSDK.current.delegate?.vinStateUpdated(vehicleAvailability: AttWidgetVehicleAvailability.VEHICLE_ELIGIBLITIY_ERROR_BAD_TOKEN.rawValue)
                            case 403:
                                self.showSubscriptionError = true
                                ApolloSDK.current.delegate?.vinStateUpdated(vehicleAvailability: AttWidgetVehicleAvailability.VEHICLE_ELIGIBLITIY_ERROR_NOT_PERMITTED.rawValue)
                            default:
                                self.showError = true
                                self.notifyVehicleAvailabilityError()
                        }
                        return
                    }
                    
                    else {
                        switch serverError.errorCode {
                            case "401":
                                self.showAuthenticationError = true
                            case "403":
                                self.showSubscriptionError = true
                            case "1355":
                                if serverError.errorMessage == "Not authorized to use the service" {
                                    self.showSubscriptionError = true
                                } else {
                                    self.showAuthenticationError = true
                                }
                            default:
                                self.showError = true
                        }
                    }
                    
                } else {
                    self.showError = true
                }
                
                self.notifyVehicleAvailabilityError()
            }
        })
    }
    
    private func notifyVehicleAvailability(response: AttValidateSubscriptionResponse) -> String {
        let vehicleAvailabilityStatus = ApolloSDK.current.getVehicleAvailabilityStatus(response: response)
        
        switch vehicleAvailabilityStatus {
        case .VEHICLE_NO_DATA_PLAN:
            ApolloSDK.current.delegate?.vinStateUpdated(vehicleAvailability: AttWidgetVehicleAvailability.VEHICLE_NO_DATA_PLAN.rawValue)
            return AttWidgetVehicleAvailability.VEHICLE_NO_DATA_PLAN.rawValue
        case .VEHICLE_HAS_ACTIVE_PLAN:
            ApolloSDK.current.delegate?.vinStateUpdated(vehicleAvailability: AttWidgetVehicleAvailability.VEHICLE_HAS_ACTIVE_PLAN.rawValue)
            return AttWidgetVehicleAvailability.VEHICLE_HAS_ACTIVE_PLAN.rawValue
        case .VEHICLE_NON_TRIAL_ELIGIBLE:
            ApolloSDK.current.delegate?.vinStateUpdated(vehicleAvailability: AttWidgetVehicleAvailability.VEHICLE_NON_TRIAL_ELIGIBLE.rawValue)
            return AttWidgetVehicleAvailability.VEHICLE_NON_TRIAL_ELIGIBLE.rawValue
        case .VEHICLE_TRIAL_ELIGIBLE:
            ApolloSDK.current.delegate?.vinStateUpdated(vehicleAvailability: AttWidgetVehicleAvailability.VEHICLE_TRIAL_ELIGIBLE.rawValue)
            return AttWidgetVehicleAvailability.VEHICLE_TRIAL_ELIGIBLE.rawValue
        case .VEHICLE_NOT_ELIGIBLE:
            ApolloSDK.current.delegate?.vinStateUpdated(vehicleAvailability: AttWidgetVehicleAvailability.VEHICLE_NOT_ELIGIBLE.rawValue)
            return AttWidgetVehicleAvailability.VEHICLE_NOT_ELIGIBLE.rawValue
        case .VEHICLE_ELIGIBLITIY_BAD_REQUEST:
            ApolloSDK.current.delegate?.vinStateUpdated(vehicleAvailability: AttWidgetVehicleAvailability.VEHICLE_ELIGIBLITIY_BAD_REQUEST.rawValue)
            return AttWidgetVehicleAvailability.VEHICLE_ELIGIBLITIY_BAD_REQUEST.rawValue
        case .VEHICLE_ELIGIBLITIY_ERROR_BAD_TOKEN:
            AttSubscriptionsServices.shared.resetValidateSubscriptionData()
            ApolloSDK.current.delegate?.vinStateUpdated(vehicleAvailability: AttWidgetVehicleAvailability.VEHICLE_ELIGIBLITIY_ERROR_BAD_TOKEN.rawValue)
            return AttWidgetVehicleAvailability.VEHICLE_ELIGIBLITIY_ERROR_BAD_TOKEN.rawValue
        case .VEHICLE_ELIGIBLITIY_ERROR_NOT_PERMITTED:
            ApolloSDK.current.delegate?.vinStateUpdated(vehicleAvailability: AttWidgetVehicleAvailability.VEHICLE_ELIGIBLITIY_ERROR_NOT_PERMITTED.rawValue)
            return AttWidgetVehicleAvailability.VEHICLE_ELIGIBLITIY_ERROR_NOT_PERMITTED.rawValue
        case .VEHICLE_ELIGIBILITY_ERROR:
            AttSubscriptionsServices.shared.resetValidateSubscriptionData()
            ApolloSDK.current.delegate?.vinStateUpdated(vehicleAvailability: AttWidgetVehicleAvailability.VEHICLE_ELIGIBILITY_ERROR.rawValue)
            return AttWidgetVehicleAvailability.VEHICLE_ELIGIBILITY_ERROR.rawValue
        }
    }
    
    
    private func notifyVehicleAvailabilityError() {
        ApolloSDK.current.delegate?.vinStateUpdated(vehicleAvailability: AttWidgetVehicleAvailability.VEHICLE_ELIGIBILITY_ERROR.rawValue)
    }
    
    public func loadData(checkCached: Bool = true) {
        if isViewVisible == false || isLoading == true { return }
        
        isLoading = true
        showLoading = true
        subscription = .init()
        dashboardResult = nil
        isTrialEligible = false
        showError        = false
        showAuthenticationError        = false
        showSubscriptionError        = false
        showMissingBilingTypeError = false
        showMissingSubscriberInfoError = false
        showMissingVehicleInfoError = false
        showMissingDeviceInfoError = false
        isPurchaseWifiDataEligible = false
        isVehicleNonEligible = false
        hasActivePlan    = false
        
        self.validateSubscription(checkCached: checkCached, vin: ApolloSDK.current.getVin())
    }

    public func getConnectivityData() {
        if isLoading == true { return }
        isLoading = true
        subscription = .init()
        dashboardResult = nil
        isTrialEligible = false
        isPurchaseWifiDataEligible = false
        isVehicleNonEligible = false
        hasActivePlan    = false

        self.validateSubscription(checkCached: false, vin: ApolloSDK.current.getVin(), getAvailabilityOnly: true)
    }
    
    public func getAvailabilityData() {
        if isLoading == true { return }
        isLoading = true
        subscription = .init()
        dashboardResult = nil
        isTrialEligible = false
        isPurchaseWifiDataEligible = false
        isVehicleNonEligible = false
        hasActivePlan    = false

        self.validateSubscription(checkCached: false, vin: ApolloSDK.current.getVin(), getAvailabilityOnly: true)
    }
    public func resetAllCacheData() {
        AttDashboardServices.shared.resetCachedData()
        AttPaymentsServices.shared.resetCachedData()
        AttConsentsServices.shared.resetCachedData()
        AttPaymentsServices.shared.resetErrorCacheData()
    }
    
    func updateWidgetHeight() {
        self.output?.onWidgetHeightUpdated()
    }
}

// MARK: - Private
extension AttWidgetViewModel {
    
    private func checkIsPurchaseWifiDataEligible(response: AttValidateSubscriptionResponse) -> Bool {
        if (response.status?.trial == "unavailable"
            && response.status?.shared == "inactive"
            && response.status?.prepaid == "inactive"
            && response.status?.postpaid == "inactive"
        ) {
            return true
        }
        
        return false
    }
    
    private func setActiveSubscription(response: AttSearchSubscriptionsResponse) {
        let itm = response.items?.first(where: {
            $0.subscription != nil &&
            $0.subscription!.status != nil &&
            $0.subscription!.billingType != nil &&
            ($0.subscription!.status! == .active  || $0.subscription!.status! == .depleted) &&
            $0.subscription!.billingType != .some(.none)
            
        })
        
        if let itm = itm {
            self.hasActivePlan = true
            self.subscription = mapSubscriptionToViewModel(item: itm.subscription!)
            self.subscription.hasStackedRetailPlanError = self.hasStackedRetailPlanError
        } else {
            self.subscription = .init()
            self.subscription.hasStackedRetailPlanError = self.hasStackedRetailPlanError
            self.hasActivePlan = false
        }
        
        // for testing purposes
#if DEBUG
        if WidgetErrorsDebuggingFlags().activeUnlimitedTrial {
            subscription.isUnlimited = true
            self.hasActivePlan = true
            subscription.isTrial = true
            print("WidgetErrorsDebuggingFlags().activeUnlimitedTrial is ON")
        }
#endif
        
        // for testing purposes
#if DEBUG
        if WidgetErrorsDebuggingFlags().usageMissing {
            self.hasActivePlan = true
            subscription.isUnlimited = false
            subscription.usageNotReturned = true
            print("WidgetErrorsDebuggingFlags().usageMissing is ON")
        }
#endif
    }
    
    private func setActiveSubscriptionFromDashboard(subscriptions: [AttSubscription]) {
        let itm = subscriptions.first(where: { (subscription) in
            return subscription.status != nil
            && subscription.billingType != nil
            && (subscription.status! == .active  || subscription.status! == .depleted)
            && subscription.billingType != .some(.none)
            
        })
        
        if let itm = itm {
            self.hasActivePlan = true
            self.subscription = mapSubscriptionToViewModel(item: itm)
            self.subscription.hasStackedRetailPlanError = self.hasStackedRetailPlanError
        } else {
            self.subscription = .init()
            self.subscription.hasStackedRetailPlanError = self.hasStackedRetailPlanError
            self.hasActivePlan = false
        }
        
        // for testing purposes
#if DEBUG
        if WidgetErrorsDebuggingFlags().activeUnlimitedTrial {
            subscription.isUnlimited = true
            self.hasActivePlan = true
            subscription.isTrial = true
            print("WidgetErrorsDebuggingFlags().activeUnlimitedTrial is ON")
        }
#endif
        
        // for testing purposes
#if DEBUG
        if WidgetErrorsDebuggingFlags().usageMissing {
            self.hasActivePlan = true
            subscription.isUnlimited = false
            subscription.usageNotReturned = true
            print("WidgetErrorsDebuggingFlags().usageMissing is ON")
        }
#endif
    }
    
    private func mapSubscriptionToViewModel(item: AttSubscription) -> AttSubscriptionViewModel {
        var subscriptionViewModel = AttSubscriptionViewModel()
        
        subscriptionViewModel.id = item.id
        
        subscriptionViewModel.autoRenew = item.recurrent?.autoRenew ?? false
        subscriptionViewModel.isTrial = item.billingType == .some(.trial)
        
        subscriptionViewModel.name = subscriptionViewModel.isTrial ? formatTrialPlanName(item: item) : (item.name ?? AttConstants.missingPlanNamePlaceholder)
        
        if (item.usage?.limit != AttConstants.unlimitedDataPlan) {
            subscriptionViewModel.limit = Double(item.usage?.limit ?? "0")!
        }
        
        subscriptionViewModel.used = Double(item.usage?.used ?? "0")!
        subscriptionViewModel.isUnlimited = item.usage?.limit == AttConstants.unlimitedDataPlan
        
        // for testing purposes
#if DEBUG
        if WidgetErrorsDebuggingFlags().activeUnlimitedTrial {
            subscriptionViewModel.isUnlimited = true
            subscriptionViewModel.isTrial = true
            print("WidgetErrorsDebuggingFlags().activeUnlimitedTrial is ON")
        }
#endif
        
        if let autoRenewalDate = AttDateUtils.convertISO8601(string: getExpirationOrRenewalDate(subscription: item)) {
            subscriptionViewModel.autoRenewalDate = AttDateUtils.formatDate(autoRenewalDate)
        }
        
        subscriptionViewModel.planType = subscriptionViewModel.isUnlimited ?
        AttConstants.unlimitedDataPlan.capitalized :
        item.billingType?.rawValue ?? ""
        
        if subscriptionViewModel.autoRenew == false, let expiritionDate = AttDateUtils.convertISO8601(string: item.expirationTime ?? "") {
            subscriptionViewModel.expiresOn = AttDateUtils.formatDate(expiritionDate)
        }
        
        if subscriptionViewModel.autoRenew == true, let expiritionDate = AttDateUtils.convertISO8601(string: item.recurrent?.endTime ?? "") {
            subscriptionViewModel.expiresOn = AttDateUtils.formatDate(expiritionDate)
        }
        
        if let usage = item.usage, let limit = usage.limit, let used = usage.used  {
            //TODO later check if we will receive "depleted" status for subscription insted of checking is used == limit
            subscriptionViewModel.hasUsedAllTheData = used == limit
            
            if !subscriptionViewModel.isUnlimited {
                subscriptionViewModel.usage = getUsage(item: item)
            }
            
        } else {
            subscriptionViewModel.usageNotReturned = true
        }
        
#if DEBUG
        if WidgetErrorsDebuggingFlags().usageMissing {
            subscriptionViewModel.name = ""
            subscriptionViewModel.hasUsedAllTheData = false
            subscriptionViewModel.usage = ""
            subscriptionViewModel.used = 0.0
            subscriptionViewModel.limit = 0.0
            subscriptionViewModel.usageNotReturned = true
            print("WidgetErrorsDebuggingFlags().usageMissing is ON")
        }
#endif
        
        return subscriptionViewModel
    }
    
    private func getExpirationOrRenewalDate(subscription: AttSubscription) -> String {
        if let expirationTime = subscription.expirationTime {
            return expirationTime
        } else if let endTime = subscription.recurrent?.endTime {
            return endTime
        }
        
        return AttConstants.unknownExpirationDate
    }
    
    private func formatTrialPlanName(item: AttSubscription) -> String {
        guard let usage = item.usage, let limit = item.usage?.limit, let unit = usage.unit  else { return item.name ?? "" }
        let amountString = formatAmount(amount: Float(limit), unit: unit) ?? ""
        
        return amountString + " " + "trial_data_plan".localized()
    }
    
    public func getUsage(item: AttSubscription) -> String {
        let roundedUsedData = formatUsed(subscription: item) ?? ""
        let cardUsage = "dashboard_cardUsage".localized()
        let usageLimit = formatLimit(subscription: item) ?? ""
        let result = "\(roundedUsedData) \(cardUsage) \(usageLimit)"
        
        return result
    }
    
    private func formatUsed(subscription: AttSubscription) -> String? {
        guard let usage = subscription.usage, let used = usage.used, let unit = usage.unit  else {
            return nil
        }
        let floatUsed = Float(used)!
        let amount = floatUsed.truncatingRemainder(dividingBy: 1) > 0 ? (floatUsed * 100).rounded() / 100  : floatUsed
        
        return formatAmount(amount: amount, unit: unit)
        
    }
    
    private func formatLimit(subscription: AttSubscription) -> String? {
        guard let usage = subscription.usage, let limit = usage.limit, let unit = usage.unit  else {
            return nil
        }
        
        let floatLimit = Float(limit)!
        
        let amount = floatLimit.truncatingRemainder(dividingBy: 1) > 0 ? (floatLimit * 100).rounded() / 100 : floatLimit
        
        return formatAmount(amount: amount, unit: unit)
    }
    
    private func formatAmount(amount: Float?, unit: String) -> String? {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        if let amount = amount {
            
            if (amount.truncatingRemainder(dividingBy: 1) > 0) {
                formatter.minimumFractionDigits = 2  // so it would be 100.20 .etc
            }
            
            switch (unit.uppercased()) {
            case "KB":
                if amount > 1024 {
                    let amountInMB = (amount/1024 * 100).rounded() / 100
                    return formatAmount(amount: amountInMB, unit: "MB")
                } else {
                    return "\(formatter.string(from: NSNumber(value: amount)) ?? "0")KB"
                }
            case "MB":
                if amount > 1024 {
                    let amountInGB = (amount/1024 * 100).rounded() / 100
                    return formatAmount(amount: amountInGB, unit: "GB")
                } else {
                    return "\(formatter.string(from: NSNumber(value: amount)) ?? "0")MB"
                }
            case "GB":
                if amount < 1 {
                    let amountInMB  = (amount * 1024 * 100).rounded() / 100
                    
                    if (amountInMB.truncatingRemainder(dividingBy: 1) > 0) {
                        formatter.minimumFractionDigits = 2  // so it would be 100.20 .etc
                    }
                    
                    return "\(formatter.string(from: NSNumber(value: amountInMB)) ?? "0")MB"
                } else {
                    return "\(formatter.string(from: NSNumber(value: amount)) ?? "0")GB"
                }
            default: return nil
            }
        }
        
        return nil
    }
    
    func callContactNumber() {
        
        let number: String = "1 (866) 595-0020"
        guard let url = URL(string: "telprompt://\(number)"),
              UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

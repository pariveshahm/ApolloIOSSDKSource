//  ATTORMRetailIntegrationSDK.swift
//  ATTORMRetailIntegrationSDK
//
//  Created by Selma Suvalija on 4/3/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import SwiftUI

public protocol ApolloSDKDelegate {
    func vinStateUpdated(vehicleAvailability: String)
    func openHotspotSetupGuide()
    func exitFromSDKListener()
}

public protocol ApolloSDKAuthenticationDelegate {
    func requestNewToken()
}

public enum AttWidgetVehicleAvailability: String {
    case VEHICLE_HAS_ACTIVE_PLAN = "vehicleHasDataPlan"
    case VEHICLE_NOT_ELIGIBLE = "vehicleNotEligible"
    case VEHICLE_TRIAL_ELIGIBLE = "vehicleTrialEligible"
    case VEHICLE_NON_TRIAL_ELIGIBLE = "vehicleNonTrialEligible"
    case VEHICLE_NO_DATA_PLAN = "vehicleNoDataPlan"
    case VEHICLE_ELIGIBILITY_ERROR = "error"
    case VEHICLE_ELIGIBLITIY_BAD_REQUEST = "unableToProcessError"
    case VEHICLE_ELIGIBLITIY_ERROR_BAD_TOKEN = "invalidTokenError"
    case VEHICLE_ELIGIBLITIY_ERROR_NOT_PERMITTED = "userNotPermittedError"
}

public enum Tenant: String {
    case honda = "Honda"
    case volvo = "Volvo"
    case acura = "Acura"
    case infiniti = "Infiniti"
    case nissan = "Nissan"
    
    var value: String {
        switch self {
        case .acura: return "honda"
        case .honda: return "honda"
        case .volvo: return "volvo"
        case .infiniti: return "nissan"
        case .nissan: return "nissan"
        }
    }
}

public enum Channel: String {
    case sdk
    case simulator
}

public final class ApolloSDK {
    
    // - Sim
    private var msisdn: String?
    private var iccid: String?
    private var imei: String?
    private var isNewUser: Bool = false
    private var isValidateAddressUsed: Bool = true
    private var isHboEnabled: Bool = false
    private var isHotspotSetupGuideButtonVisible: Bool = true
    private var hotspotSetupGuideButtonText: String = "hotspot_setup_guide".localized()
    
    // - SubscriptionCachingDuration
    var validateSubscriptionCachingDuration: Double = 15
    
    // - Vehicle
    private var vin: String?
    
    // - Theme
    private var appThemeBundlePath: String?
    private var appDarkThemeFile: String?
    private var appLightThemeFile: String?
    
    // - Dashboard
    private var dashboardButtonTitleOne: String?
    private var dashboardButtonTitleTwo: String?
    private var hotspotView: AnyView?
    
    // - General
    private var tenant: Tenant?
    private var hostName: String?
    private var channel: Channel = .simulator
    private var country: AttCountryType = .US
    private var language: AttLanguage = .en
    private var debug = false
    
    // - API
    private var environment: AttApiEnv = .pvt
    private var accessToken: String?
    
    // - User
    private var user: AttUser?
    
    // Delegate
    public var delegate: ApolloSDKDelegate?
    
    private var temporaryDelegate: ApolloSDKDelegate?
    
    // Authentication Delegate
    public var authenticationDelegate: ApolloSDKAuthenticationDelegate?
    
    // - Access
    public static let current = ApolloSDK()
    
    // navigation bar properties
    var standardAppearance: UINavigationBarAppearance = UINavigationBarAppearance()
    private var scrollEdgeAppearance: UINavigationBarAppearance = UINavigationBarAppearance()
    private var compactAppearance: UINavigationBarAppearance = UINavigationBarAppearance()
    
    public var openIdPayload: String?
    public var clientSessionId: String? = UUID.init().uuidString
    public var cacheTime: String?
    public var creditCard: Int?
    
    //  Init
    private init() {}
    
    // - Setters
    @discardableResult
    public func vin(_ vin: String) -> ApolloSDK {
        self.vin = vin
        return self
    }
    
    @discardableResult
    public func tenant(_ tenant: Tenant) -> ApolloSDK {
        self.tenant = tenant
        return self
    }
    
    @discardableResult
    public func setValidateSubscriptionCachingDuration(_ timeMinutes: Double) -> ApolloSDK {
        if(timeMinutes > 15) {
            self.validateSubscriptionCachingDuration = timeMinutes
        }
        return self
    }
    
    @discardableResult
    public func hostName(_ hostName: String) -> ApolloSDK {
        self.hostName = hostName
        return self
    }
    
    @discardableResult
    public func channel(_ channel: Channel) -> ApolloSDK {
        self.channel = channel
        return self
    }
    
    @discardableResult
    public func country(_ country: AttCountryType) -> ApolloSDK {
        self.country = country
        return self
    }
    
    @discardableResult
    public func language(_ language: AttLanguage) -> ApolloSDK {
        self.language = language
        return self
    }
    
    @discardableResult
    public func accessToken(_ accessToken: String) -> ApolloSDK {
        self.accessToken = accessToken
        return self
    }
    
    @discardableResult
    public func environment(_ environment: AttApiEnv) -> ApolloSDK {
        self.environment = environment
        return self
    }
    
    @discardableResult
    public func user(_ user: AttUser) -> ApolloSDK {
        self.user = user
        return self
    }
    
    @discardableResult
    public func setDelegate(_ delegate: ApolloSDKDelegate?) -> ApolloSDK {
        
        if delegate == nil {
            // set it to previous delegate, and clear previous
            self.delegate = self.temporaryDelegate
            self.temporaryDelegate = nil
        } else {
            // set new delegate, and remember previous
            self.temporaryDelegate = self.delegate
            self.delegate = delegate
        }
        
        return self
    }
    
    @discardableResult
    public func setAuthenticationDelegate(_ delegate: ApolloSDKAuthenticationDelegate) -> ApolloSDK {
        self.authenticationDelegate = delegate
        return self
    }
    
    @discardableResult
    public func setIsHotspotSetupGuideButtonVisible(_ visible: Bool) -> ApolloSDK {
        self.isHotspotSetupGuideButtonVisible = visible
        return self
    }
    
    @discardableResult
    public func setHotspotSetupGuideButtonText(_ buttonText: String) -> ApolloSDK{
        self.hotspotSetupGuideButtonText = buttonText
        return self
    }
    
    @discardableResult
    public func setReturnToDashboardButtonText(_ title: String) -> ApolloSDK {
        self.dashboardButtonTitleOne = title
        return self
    }
    
    @discardableResult
    public func dashboardButtonSecondTitle(_ title: String) -> ApolloSDK {
        self.dashboardButtonTitleTwo = title
        return self
    }
    
    @discardableResult
    public func sdkDarkThemeFile(_ appThemeFile: String, bundlePath: String) -> ApolloSDK {
        self.appDarkThemeFile = appThemeFile
        self.appThemeBundlePath = bundlePath
        return self
    }
    
    @discardableResult
    public func sdkLightThemeFile(_ appThemeFile: String, bundlePath: String) -> ApolloSDK {
        self.appLightThemeFile = appThemeFile
        self.appThemeBundlePath = bundlePath
        return self
    }
    
    // - Private setter
    @discardableResult
    func msisdn(_ msisdn: String) -> ApolloSDK {
        self.msisdn = msisdn
        return self
    }
    
    @discardableResult
    func isNewUser(_ isNewUser: Bool) -> ApolloSDK {
        self.isNewUser = isNewUser
        return self
    }
    
    @discardableResult
    func isValidateAddressUsed(_ isEnabled: Bool) -> ApolloSDK {
        self.isValidateAddressUsed = isEnabled
        return self
    }
    
    @discardableResult
    func iccid(_ iccid: String) -> ApolloSDK {
        self.iccid = iccid
        return self
    }
    
    @discardableResult
    public func hotspot(_ view: AnyView) -> ApolloSDK {
        self.hotspotView = view
        return self
    }
    
    // - Getters
    func getVin() -> String {
        return self.vin ?? ""
    }
    
    func getTenant() -> Tenant {
        return self.tenant ?? .honda
    }
    
    func getTenantString() -> String {
        return self.tenant?.rawValue ?? ""
    }
    
    func getTenantValue() -> String {
        return self.tenant?.value ?? ""
    }
    
    func getHostName() -> String {
        if (self.hostName?.isEmpty ?? true) {
            return (self.tenant?.rawValue ?? "")
        } else {
            return self.hostName ?? ""
        }
    }
    func getChannel() -> Channel {
        return self.channel
    }
    
    func getCountry() -> AttCountryType {
        return self.country
    }
    
    func getLanguage() -> AttLanguage {
        return self.language
    }
    
    func getMsisdn() -> String {
        return self.msisdn ?? ""
    }
    
    func getIccid() -> String {
        return self.iccid ?? ""
    }
    
    func getIsNewUser() -> Bool {
        return self.isNewUser
    }
    
    func getIsHotspotSetupGuideButtonVisible() -> Bool {
        return self.isHotspotSetupGuideButtonVisible
    }
    
    func getHotspotSetupGuideButtonText() -> String{
        return hotspotSetupGuideButtonText
    }
    
    func getIsValidateAddressUsed() -> Bool {
        return self.isValidateAddressUsed
    }
    
    func getIsHboEnabled() -> Bool {
        return self.isHboEnabled
    }
    
    func getAccessToken() -> String? {
        return self.accessToken ?? nil
    }
    
    func getHotspot() -> AnyView? {
        return hotspotView
    }
    
    // - Data
    func getEnvironment() -> AttApiEnv {
        return self.environment
    }
    
    func getUser() -> AttUser {
        return self.user ?? .init()
    }
    
    // - Dashboard
    func getDashboardButtonFirstTitle() -> String {
        return dashboardButtonTitleOne ?? "return_to_oem_dashboard".localized()
    }
    
    func getDashboardButtonSecondTitle() -> String {
        return dashboardButtonTitleTwo ?? "hotspot_setup_guide".localized()
    }
    
    // - Fonts
    func getRegularFont() -> String {
        return AttSDKFont.regular.rawValue
    }
    
    func getBoldFont() -> String {
        return AttSDKFont.bold.rawValue
    }
    
    func getItalicFont() -> String {
        return AttSDKFont.italicRegular.rawValue
    }
    
    func getMediumFont() -> String {
        return AttSDKFont.medium.rawValue
    }
    
    func getLightFont() -> String {
        return AttSDKFont.light.rawValue
    }
    
    // - Actions
    public func build() {
        var appTheme = AttAppTheme()
        let appThemeFileName = self.getAppThemeFileName()
        
        // - Register font
        DispatchQueue.global(qos: .userInteractive).async {
            let sdkFonts = AttSDKFont.allCases
            sdkFonts.forEach { font in
                do {
                    try UIFont.loadCustomFont(font.fileName)
                } catch {
                    print("Location: \(#fileID)")
                    print("Function: \(#function)")
                    print("Error:\n", error)
                }
            }
            
            // - Load theme
            if let appThemeBundlePath = self.appThemeBundlePath,
               let bundle = Bundle(path: appThemeBundlePath),
               let path = bundle.path(forResource: appThemeFileName, ofType: "plist") {
                
                appTheme.loadTheme(path: path)
            } else {
                let bundle: Bundle = .resourceBundle
                let path = bundle.path(forResource: appThemeFileName, ofType: "plist")!
                appTheme.loadTheme(path: path)
            }
        }
        AttSubscriptionsServices.shared.resetValidateSubscriptionData()
    }
    
    private func getAppThemeFileName() -> String {
        if AttAppTheme().isDarkTheme() {
            /// Return Dark Mode file name
            return self.appDarkThemeFile ?? "BrandedRetailSDKTheme-night"
        } else {
            /// Return Light Mode file name
            return self.appLightThemeFile ?? "BrandedRetailSDKTheme"
        }
    }
}

public extension ApolloSDK {
    
    func startTrialFlow(presentationDelegate: AttNavigationDelegate, failure: @escaping (Error) -> ()) {
        let vin = self.getVin()
        searchSubscriptions(vin: vin, success: {[weak self] product in
            guard let product = product else {return}
            let trialController = AttTrialActivationController(product)
            
            let navigationVc = UINavigationController(rootViewController: trialController)
            navigationVc.modalTransitionStyle = .crossDissolve
            navigationVc.modalPresentationStyle = .fullScreen
            self?.hideLoading(presentationDelegate: presentationDelegate, completion: {
                presentationDelegate.present(viewController: navigationVc)
            })
        
        }, failure: { error in
            let view = AttTrialErrorView(
                showContact: true,
                retryTitle: "dashboard_retry".localized(),
                onRetry: { self.startTrialFlow(presentationDelegate: presentationDelegate, failure: {_ in }) },
                onBack: {UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: false, completion: nil)},
                contentView: Text("dashboard_error_something_went_wrong".localized())
                    .font(.custom(ApolloSDK.current.getMediumFont(), size: 17))
                    .foregroundColor(AttAppTheme.attSDKTextPrimaryColor))
            
            let viewController = UIHostingController(rootView: view)
            viewController.modalPresentationStyle = .fullScreen
            self.hideLoading(presentationDelegate: presentationDelegate, completion: {
                presentationDelegate.present(viewController: viewController)
            })
        })
    }
    
    func startPrepaidFlow(presentationDelegate: AttNavigationDelegate, failure: @escaping (Error) -> ()) {
        let vin = self.getVin()
        searchSubscriptions(vin: vin, success: { [weak self] _ in
            let controller = AttPurchaseWiFiController()
            let navigationVc = UINavigationController(rootViewController: controller)
            navigationVc.modalTransitionStyle = .crossDissolve
            navigationVc.modalPresentationStyle = .fullScreen
            
            self?.hideLoading(presentationDelegate: presentationDelegate, completion: {
                presentationDelegate.present(viewController: navigationVc)
            })
        }, failure: failure)
    }
    
    func goToDashboard(presentationDelegate: AttNavigationDelegate, failure: @escaping (Error) -> ()) {
        let vin = self.getVin()
        searchSubscriptions(vin: vin, success: { [weak self] _ in
            let controller = AttDashboardController(type: .normal)
            let navigationVc = UINavigationController(rootViewController: controller)
            navigationVc.modalTransitionStyle = .crossDissolve
            navigationVc.modalPresentationStyle = .fullScreen
            
            self?.hideLoading(presentationDelegate: presentationDelegate, completion: {
                presentationDelegate.present(viewController: navigationVc)
            })
        }, failure: { [weak self] _ in
            let controller = AttDashboardController(type: .error)
            let navigationVc = UINavigationController(rootViewController: controller)
            navigationVc.modalTransitionStyle = .crossDissolve
            navigationVc.modalPresentationStyle = .fullScreen
            
            self?.hideLoading(presentationDelegate: presentationDelegate, completion: {
                presentationDelegate.present(viewController: navigationVc)
            })
        }
    )}
    
    func goToDashboardNoDataPlan(presentationDelegate: AttNavigationDelegate, failure: @escaping (Error) -> ()) {
        let vin = self.getVin()
        
        searchSubscriptions(vin: vin, success: { [weak self] (product) in
            let controller = AttDashboardController(type: .normal)
             
            let navigationVc = UINavigationController(rootViewController: controller)
            navigationVc.modalTransitionStyle = .crossDissolve
            navigationVc.modalPresentationStyle = .fullScreen
            
            self?.hideLoading(presentationDelegate: presentationDelegate, completion: {
                presentationDelegate.present(viewController: navigationVc)
            })
        }, failure: { [weak self] _ in
            let controller = AttDashboardController(type: .error)
            let navigationVc = UINavigationController(rootViewController: controller)
            navigationVc.modalTransitionStyle = .crossDissolve
            navigationVc.modalPresentationStyle = .fullScreen
            
            self?.hideLoading(presentationDelegate: presentationDelegate, completion: {
                presentationDelegate.present(viewController: navigationVc)
            })
        }
    )}
    
    func showError(presentationDelegate: AttNavigationDelegate, failure: @escaping (Error) -> ()) {
        let vin = self.getVin()
        let controller = AttDashboardController(type: .error)
        let navigationVc = UINavigationController(rootViewController: controller)
        searchSubscriptions(vin: vin, success: { [weak self] _ in
            navigationVc.modalTransitionStyle = .crossDissolve
            navigationVc.modalPresentationStyle = .fullScreen
            self?.hideLoading(presentationDelegate: presentationDelegate, completion: {
                presentationDelegate.present(viewController: navigationVc)
            })
        }, failure: { [weak self] _ in
            navigationVc.modalTransitionStyle = .crossDissolve
            navigationVc.modalPresentationStyle = .fullScreen
            self?.hideLoading(presentationDelegate: presentationDelegate, completion: {
                presentationDelegate.present(viewController: navigationVc)
            })
        }
    )}
    
    func showLoading(presentationDelegate: AttNavigationDelegate, failure: @escaping (Error) -> ()) {
        let controller = LoadingViewController()
        controller.view.tag = 7777
        presentationDelegate.push(viewController: controller)
    }
    
    func hideLoading(presentationDelegate: AttNavigationDelegate, completion: @escaping () -> Void = { }) {
        let controller = LoadingViewController()
        controller.view.tag = 7777
        presentationDelegate.pop(viewController: controller, completion: completion)
    }
    
    func showLearnMoreWidget(presentationDelegate: AttNavigationDelegate, failure: @escaping (Error) -> ()) {
        let vin = self.getVin()
        let controller = AttDashboardController(type: .learnMore)
        let navigationVc = UINavigationController(rootViewController: controller)
        searchSubscriptions(vin: vin, success: { [weak self] _ in
            navigationVc.modalTransitionStyle = .crossDissolve
            navigationVc.modalPresentationStyle = .fullScreen
            self?.hideLoading(presentationDelegate: presentationDelegate, completion: {
                presentationDelegate.present(viewController: navigationVc)
            })
        }, failure: { [weak self] _ in
            navigationVc.modalTransitionStyle = .crossDissolve
            navigationVc.modalPresentationStyle = .fullScreen
            self?.hideLoading(presentationDelegate: presentationDelegate, completion: {
                presentationDelegate.present(viewController: navigationVc)
            })
        }
    )}
    
    func getVehicleAvailabilityStatus(response: AttValidateSubscriptionResponse) -> AttWidgetVehicleAvailability {
        let registeredUser = (self.checkIsRegisteredUser(response: response))
        let recredentialed = self.checkIsReCredentialedUser(response: response)
        let trialStatus = response.status?.trial ?? ""
        let sharedStatus = response.status?.shared ?? ""
        let postpaidStatus = response.status?.postpaid ?? ""
        let prepaidStatus = response.status?.prepaid ?? ""
        let canRegister = response.permissions?.canRegister ?? false
        let canCancel = response.permissions?.canCancel ?? false
        
        
        if (canRegister && trialStatus == "available") {
            return AttWidgetVehicleAvailability.VEHICLE_TRIAL_ELIGIBLE
        } else if registeredUser && (trialStatus == "active"
                                     || trialStatus == "depleted"
                                     || sharedStatus == "active"
                                     || sharedStatus == "depleted"
                                     || sharedStatus == "stacked"
                                     || postpaidStatus == "active"
                                     || postpaidStatus == "depleted"
                                     || postpaidStatus == "stacked"
                                     || prepaidStatus == "active"
                                     || prepaidStatus == "depleted"
                                     || prepaidStatus == "stacked") {
            return AttWidgetVehicleAvailability.VEHICLE_HAS_ACTIVE_PLAN
        } else if (registeredUser && prepaidStatus == "inactive") {
            return AttWidgetVehicleAvailability.VEHICLE_NO_DATA_PLAN
        } else if (!recredentialed && !canRegister && !canCancel) {
            return AttWidgetVehicleAvailability.VEHICLE_NOT_ELIGIBLE
        } else if (canRegister && trialStatus == "unavailable") {
            return AttWidgetVehicleAvailability.VEHICLE_NON_TRIAL_ELIGIBLE
        }
        return AttWidgetVehicleAvailability.VEHICLE_ELIGIBILITY_ERROR
    }
    
    func checkIsRegisteredUser(response: AttValidateSubscriptionResponse) -> Bool {
        let metas = response.metas
        
        if let isRegisteredMeta = metas?.first(where: { $0.registeredUser != nil }), let registered = isRegisteredMeta.registeredUser {
            return (registered as NSString).boolValue
        }
        
        return false
    }
    
    func checkIsReCredentialedUser(response: AttValidateSubscriptionResponse) -> Bool {
        let metas = response.metas
        
        if let isRegisteredMeta = metas?.first(where: { $0.recredentialed != nil }), let recredentialed = isRegisteredMeta.recredentialed {
            return (recredentialed as NSString).boolValue
        }
        
        return false
    }
    
    
    private func searchSubscriptions(vin: String, success: @escaping (AttProduct?) -> (), failure: @escaping (Error) -> ()) {
        
        if let response = AttSubscriptionsServices.shared.getCachedData() {
            self.isNewUser = !(self.checkIsRegisteredUser(response: response))
            ApolloSDK.current.iccid(response.device?.sim?.iccid ?? "")
            ApolloSDK.current.msisdn(response.device?.sim?.msisdn ?? "")
            ApolloSDK.current.isNewUser(self.isNewUser)
            
            // is user is not vehicleNonEligble, then take trial plan
            let vehicleAvailabilityStatus = getVehicleAvailabilityStatus(response: response)
            
            if (response.status?.trial == "available" && (vehicleAvailabilityStatus != .VEHICLE_NOT_ELIGIBLE && vehicleAvailabilityStatus != .VEHICLE_NON_TRIAL_ELIGIBLE)) {
                getTrialPlan(vin: vin, success: success, failure: failure)
                return;
            }
            
            success(nil)
            return
        }
        
        AttSubscriptionsServices.shared.validateSubscription(vin: vin, responseHandler: { result in
            switch result {
            case .success(let response):
                AttSubscriptionsServices.shared.saveValidateSubscriptionData(response: response)
                self.isNewUser = !(self.checkIsRegisteredUser(response: response))
                ApolloSDK.current.iccid(response.device?.sim?.iccid ?? "")
                ApolloSDK.current.msisdn(response.device?.sim?.msisdn ?? "")
                ApolloSDK.current.isNewUser(self.isNewUser)
                
                // is user is not vehicleNonEligble, then take trial plan
                let vehicleAvailabilityStatus = self.getVehicleAvailabilityStatus(response: response)
                
                if (response.status?.trial == "available" && (vehicleAvailabilityStatus != .VEHICLE_NOT_ELIGIBLE || vehicleAvailabilityStatus != .VEHICLE_NOT_ELIGIBLE)) {
                    self.getTrialPlan(vin: vin, success: success, failure: failure)
                    return;
                }
                
                success(nil)
            case .failure(let error):
                failure(error)
            }
        })
    }
    
    func resetSubscriptionData(){
        clientSessionId = UUID.init().uuidString
        AttSubscriptionsServices.shared.validateSubscriptionResponse = nil
        AttSubscriptionsServices.shared.validateSubscriptionVin = nil
        AttSubscriptionsServices.shared.validateSubscriptionTime = nil
    }
    
    private func getTrialPlan(vin: String, success: @escaping (AttProduct?) -> (), failure: @escaping (Error) -> ()) {
        AttProductsServices.shared.getAllProducts(vin: vin,  completion: {result in
            switch result {
            case .success(let res):
                guard let plans = res.items else {
                    failure(NSError(domain: "dashboard_error_something_went_wrong".localized(), code: 0, userInfo: nil))
                    return
                }
                
                let products = plans.map { $0.product }
                let trialPlan = products.first(where: { $0.billingType == .trial })
                var product = trialPlan
                product?.requestId = res.requestID
                success(product)
            case .failure(let error):
                failure(error)
            }
        })
    }
}

struct ErrorDebuggingFlags {
    let showAddSubscriptionError = false
    let showAddSubscriptionTrialError = false
    let showPlanPurchaseError = false
    let showSearchConsentError = false
    let showActivateSubscriberError = false
    let showCreateVehicleError = false
    
    var showMissingBilingTypeError = false
    var showMissingSubscriberInfoError = false
    var showMissingVehicleInfoError = false
    var showMissingDeviceInfoError = false
}

struct WidgetDebuggingFlags {
    let showError = false
    let showTrial = false
    let showActivePlan = false
    let showAvailablePlan = false
    let showNoPlan = false
}

struct WidgetErrorsDebuggingFlags {
    let activeUnlimitedTrial = false
    let usageMissing = false
    let skipValidateAddress = false
}

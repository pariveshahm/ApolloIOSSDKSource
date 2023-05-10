//  DashboardSettings.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 18/01/2021.

import SwiftUI

struct AttDashboardSettings: View {
    
    @ObservedObject var viewModel: AttWidgetViewModel
    // - State
    @State
    private var isConsentOn = false
    
    @State
    private var consent: AttConsentItem?
    
    @State
    private var isConsentLoading = false
    
    @State
    private var isRenewLoading = false
    
    
    // - Properties
    var onCancel: () -> Void = {}
    var onLegalAndRegulatory: () -> Void = {}
    
    var body: some View {
        var content: [AnyView] = []
        
        if viewModel.subscription.id != nil && !viewModel.subscription.isTrial && viewModel.subscription.autoRenew {
            content.insert(autoRenewToggle, at: 0)
        }
        
        content.append(consentToggle)
        //
        //        if viewModel.subscription.id != nil {
        //            content.append(cancelButton)
        //        }
//        content.append(createManageSubscription())
        content.append(createLegalAndRegulatory())
        
        return AttCollapseMenu(
            title: "other_settings_title".localized(),
            footnote: "other_settings_title_second_line".localized(),
            content: content
        ).onAppear(perform: {
            if viewModel.isNewUser == false && viewModel.isViewVisible {
                loadConsent()
            }
        })
    }
    
    // - View
    private var consentToggle: AnyView {
        AnyView(
            VStack(alignment: .leading) {
                
                if #available(iOS 14.0, *) {
                    Toggle("other_settings_marketing_consent".localized(), isOn: $isConsentOn.onChange(onUpdateConsent))
                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        .font(.custom(.medium, size: 13))
                        .toggleStyle(SwitchToggleStyle(tint: AttAppTheme.primaryColor))
                        .disabled(isConsentLoading)
                } else {
                    // Fallback on earlier versions
                    Toggle("other_settings_marketing_consent".localized(), isOn: $isConsentOn.onChange(onUpdateConsent))
                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        .font(.custom(.medium, size: 13))
                        .disabled(isConsentLoading)
                }
                
                Text("other_settings_marketing_consent_body".localized())
                    .font(.custom(.regular, size: 10))
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
            }
                .padding(.horizontal, 10)
        )
    }
    
    private var autoRenewToggle: AnyView {
        AnyView(
            VStack(alignment: .leading) {
                
                if #available(iOS 14.0, *) {
                    Toggle("other_settings_auto_renew".localized(), isOn: $viewModel.subscription.autoRenew.onChange(toggleAutoRenew(_:)))
                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        .font(.custom(.medium, size: 13))
                        .toggleStyle(SwitchToggleStyle(tint: AttAppTheme.primaryColor))
                        .disabled(isRenewLoading)
                } else {
                    // Fallback on earlier versions
                    Toggle("other_settings_auto_renew".localized(), isOn: $viewModel.subscription.autoRenew.onChange(toggleAutoRenew(_:)))
                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        .font(.custom(.medium, size: 13))
                        .disabled(isRenewLoading)
                }
                
                Text("other_settings_auto_renew_body".localized())
                    .font(.custom(.regular, size: 10))
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
            }
                .padding(.horizontal, 10)
        )
    }
    
    private var cancelButton: AnyView {
        AnyView(
            Button("other_settings_cancel_service".localized(), action: onCancel)
                .font(.custom(.medium, size: 12))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.all, 10)
                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
        )
    }
    
    // - Actions
    private func onUpdateConsent(_ value: Bool) {
        isConsentLoading = true
        switch value {
        case true:
            AttConsentsServices.shared.addConsent { (result) in
                switch result {
                case .success(let res):
                    self.isConsentOn = value
                    let marketingConsent = res.items?.first(where: { $0.consent?.tnc?.document?.id == "ATTWIFICONSENT" })
                    self.consent = marketingConsent
                case .failure(_):
                    self.isConsentOn = !value
                }
                
                isConsentLoading = false
                loadConsent()
            }
        case false:
            if let consentId = consent?.consent?.id {
                AttConsentsServices.shared.updateConsent(value, id: consentId) { (result) in
                    switch result {
                    case .success(_):
                        self.isConsentOn = value
                        AttConsentsServices.shared.resetCachedData()
                    case .failure(_):
                        self.isConsentOn = !value
                    }
                    
                    isConsentLoading = false
                    loadConsent()
                }
            } else {
                isConsentLoading = false
            }
        }
    }
    
    func loadConsent() {
        //guard consent == nil else { return }
        isConsentLoading = true
        AttConsentsServices.shared.searchConsents { (result) in
            switch result {
            case .success(let res):
                let marketingConsent = res.items?.first(where: { $0.consent?.tnc?.document?.id == "ATTWIFICONSENT" })
                self.consent = marketingConsent
                self.isConsentOn = marketingConsent?.consent?.isActive ?? false
                self.isConsentLoading = false
            case .failure(let error):
                if let serverError = error as? AttServerError {
                    switch serverError.httpCode{
                    case 202:
                        self.isConsentLoading = false
                    case 404:
                        self.isConsentLoading = false
                        AttConsentsServices.shared.resetCachedData()
                    default:
                        self.isConsentLoading = false
                        AttConsentsServices.shared.resetCachedData()
                    }
                }
                
                self.isConsentOn = false
            }
        }
    }
    
    private func toggleAutoRenew(_ value: Bool) {
        AttDashboardServices.shared.resetCachedData()
        ApolloSDK.current.clientSessionId = UUID.init().uuidString
        viewModel.isLoading = true
        guard let id = viewModel.subscription.id else { return }
        isRenewLoading = true
        let vin = ApolloSDK.current.getVin()
        AttSubscriptionsServices.shared.toggleAutoRenew(id: id, autoRenew: value, vin: vin) { (result) in
            isRenewLoading = false
            
            switch result {
            case .success(_): viewModel.fetchDashboardData(checkCached: false, completion: {
                viewModel.isLoading = false
                viewModel.showLoading = false
            })
            case .failure(_): viewModel.subscription.autoRenew = !value
            }
        }
    }
    
//    private func createManageSubscription() -> AnyView {
//        return AnyView(
//            Button(action: {}) {
//                HStack(alignment: .center, spacing: 0) {
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text("manage_subscription_title".localized())
//                            .font(.custom(.bold, size: 14))
//                            .foregroundColor(AttAppTheme.primaryColor)
//                            .lineLimit(nil)
//                            .multilineTextAlignment(.leading)
//                    }.padding().frame(maxWidth: .infinity, alignment: .leading)
//                }
//            }
//                .foregroundColor(.init(.label)).frame(maxWidth: .infinity, maxHeight: 70, alignment: .leading)
//        )
//    }
    
    private func createLegalAndRegulatory() -> AnyView {
        return AnyView(
            Button(action: onLegalAndRegulatory ) {
                HStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("legal_and_regulatory_title".localized())
                            .font(.custom(.bold, size: 14))
                            .foregroundColor(AttAppTheme.primaryColor)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                    }.padding().frame(maxWidth: .infinity, alignment: .leading)
                }
            }
                .foregroundColor(.init(.label)).frame(maxWidth: .infinity, maxHeight: 70, alignment: .leading)
        )
    }
}

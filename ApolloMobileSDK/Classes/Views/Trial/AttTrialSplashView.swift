//  TrialView.swift
//  ATTORMRetailSDK
//
//  Created by Selma Suvalija on 7/3/20.

import SwiftUI

public struct AttTrialSplashView: View {
    
    // - State
    @State private var openConsent = false
    @State private var useUserData = false
    @State private var canContinue = false
    
    // - Properties
    var product: AttProduct
    var offer: AttProductOffer
    var onExit: (() -> Void)? = nil
    var onNext: ((Bool, AttProduct, AttProductOffer) -> Void) = { _, _, _ in }
    
    // - Body
    public var body: some View {
            ZStack {
                LinearGradient(gradient: Gradient(
                               colors: [AttAppTheme.attSDKBackgroundColor, AttAppTheme.attSDKBackgroundColor]),
                               startPoint: .top,
                               endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()
                    
                    // - Header
                    VStack {
                        Text("good_news".localized())
                            .font(.custom(ApolloSDK.current.getBoldFont(), size: 30))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        
                        HStack(alignment: .center, spacing: 2) {
                            Text("$")
                                .font(.custom(.regular, size: 30))
                                .foregroundColor(AttAppTheme.primaryColor)
                                .baselineOffset(30)
                            
                            Text("0")
                                .font(.custom(.regular, size: 100))
                                .foregroundColor(AttAppTheme.primaryColor)
                        }
                        
                        Text("dashboard_trial_title".localized())
                            .font(.custom(ApolloSDK.current.getMediumFont(), size: 16))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                            .frame(maxWidth: 300)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                    
                    // - Actions
                    VStack(alignment: .center) {
                        Button("get_started".localized()) { openConsent.toggle() }
                            .buttonStyle(AttPrimaryButtonStyle())
                            .padding(.horizontal, 16)
                            .frame(maxWidth: 400)
                        
                        Spacer().frame(height: 8)
                        
                        Button(ApolloSDK.current.getDashboardButtonFirstTitle(), action: onExit ?? {})
                            .buttonStyle(AttSecondaryButtonStyle())
                            .padding(.horizontal, 16)
                            .frame(maxWidth: 400)
                        
                        Text("trial_data_plan_desciption".localized())
//                            .foregroundColor(Color(hex: "#9A9A9A"))
                            .font(.custom(ApolloSDK.current.getMediumFont(), size: 11))
                            .multilineTextAlignment(.center)
                            .padding(20)
                    }
                }
                
                // - Consent dialog
                if openConsent {
                    AttDialog(
                        open: $openConsent,
                        title: "share_information_registration_dialog_title".localized(),
                        message1: String(format: "share_information_registration_dialog_message_first".localized(), ApolloSDK.current.getTenantString(), ApolloSDK.current.getHostName()),
                        acceptBtnTitle: "share_information_registration_dialog_allow_button".localized(),
                        message2:
                            String(format: "share_information_registration_dialog_message_second".localized(), ApolloSDK.current.getHostName()),
                        cancelBtnTitle: "share_information_registration_dialog_deny_button".localized(),
                        onAccept: {
                            ApolloSDK.current.authenticationDelegate?.requestNewToken()
                            //canContinue.toggle()
                            onNext(true, product, offer)
                            useUserData = true
                        },
                        onCancel: { openConsent.toggle(); useUserData = false }
                    )
                }
            
        }.onDisappear(perform: { openConsent = true })
    }
}

struct AttTrialView_Previews: PreviewProvider {
    static var previews: some View {
        AttTrialSplashView(product: AttMockViewModal.products[0],
                        offer: .init(
                            planName: "FREE 3GB",
                            dataAmount: "3 GB",
                            planExpiration: "3 months"
                        ))
    }
}

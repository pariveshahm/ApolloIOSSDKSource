//
//  AttEditPaymentProfileView.swift
//  ApolloMobileSDK
//
//  Created by Nermin Sabanovic on 19. 10. 2022..
//

import SwiftUI
import WebKit

struct AttEditPaymentProfileView: View {
    
    // - State
    @State
    private var shouldExit = false

    // - Props
    let url: URL?
    var delegate: WKNavigationDelegate?
    var onExit: (Bool) -> Void
    var onBack: () -> Void
    var onComplete: () -> Void
    var shouldUpdateOnly = false
    
    @ObservedObject
    var model: AttPaymentViewModel
    
    public var body: some View {
        NavigationView {
            ZStack {
                AttAppTheme.attSDKBackgroundColor
                    .edgesIgnoringSafeArea(.all)

                if model.showLoading{

                    AttNavigationBarView(titleContent: {
                        HStack(spacing: 8) {
                            Spacer().frame(width: 8, height: 0, alignment: .center)

                            Image("att-logo", bundle: .resourceBundle)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18, alignment: .center)
                                .scaledToFit()

                            Text(PurchaseWiFiStepTitles.transactionSummaryy.value()).font(Font.custom(ApolloSDK.current.getBoldFont(), size: 17)).foregroundColor(AttAppTheme.attSDKTextPrimaryColor)

                            Spacer()
                        }.frame(height: 44, alignment: .center)
                    }, backgroundColor: AttAppTheme.attSDKBackgroundColor, contentView: {
                        VStack{
                            Spacer()
                            AttActivityIndicator()
                                .frame(minHeight: 10, maxHeight: 100)
                            
                            Text("loading_please_wait".localized())
                                .multilineTextAlignment(.center)
                                .font(.custom(ApolloSDK.current.getBoldFont(), size: 20))
                                .foregroundColor(AttAppTheme.primaryColor)
                            Text("loading_activating_prepaid_service_message".localized())
                                .padding([.leading, .trailing], 16)
                                .multilineTextAlignment(.center)
                                .font(.custom(ApolloSDK.current.getMediumFont(), size: 15))
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                            Spacer()
                        }
                        
                    })
                    
                } else if model.isAddSubscriptionError {
                    AttErrorView(
                        showContact: true,
                        retryTitle: "add_subscription_after_payment_failed_button_text".localized(),
                        onRetry: { self.onExit(true) },
                        contentView:
                            VStack(spacing: 8) {
                                Text("dashboard_error_purchase_failed_title".localized())
                                    .font(.custom(ApolloSDK.current.getBoldFont(), size: 14))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                                
                                Text("dashboard_error_purchase_failed_body".localized())
                                    .font(.custom(ApolloSDK.current.getMediumFont(), size: 14))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                            }
                    )
                } else if model.isValidatePaymentError {
                    AttErrorView(
                        showContact: true,
                        retryTitle: "dashboard_retry".localized(),
                        exitTitle: "back".localized(),
                        onRetry: { model.isValidatePaymentError = false; model.purchaseProduct(completion: onComplete)},
                        onExit: { model.isValidatePaymentError = false },
                        contentView: Text("dashboard_error_something_went_wrong".localized())
                            .font(.custom(ApolloSDK.current.getBoldFont(), size: 14)).multilineTextAlignment(.center)
                    )
                } else {
                    AttNavigationBarView(titleContent: {
                        HStack(spacing: 8) {
                            Spacer().frame(width: 8, height: 0, alignment: .center)

                            Image("att-logo", bundle: .resourceBundle)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18, alignment: .center)
                                .scaledToFit()

                            Text("payment_profile_information_title".localized()).font(Font.custom(ApolloSDK.current.getBoldFont(), size: 17)).foregroundColor(AttAppTheme.attSDKTextPrimaryColor)

                            Spacer()
                        }.frame(height: 44, alignment: .center)
                    }, backgroundColor: AttAppTheme.attSDKBackgroundColor, contentView: {
                        AttSwiftUIWebView(url: url, delegate: delegate).background(AttAppTheme.attSDKBackgroundColor).navigationBarHidden(true)
                    })

                }
            }
        }.background(AttAppTheme.attSDKBackgroundColor)
    }
    
    
    func startPurchase() {
        self.model.purchaseProduct(completion: onComplete)
    }
}

//  PaymentView.swift
//  ApolloMobileSDK
//
//  Created by Shak4l on 12/02/2021.

import SwiftUI
import WebKit

struct AttPaymentView: View {
    
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

                            Button(action: {
                                    UIApplication.shared.endEditing()
                                    shouldExit = true
                            }, label: { Image(systemName: "xmark").imageScale(.large) })
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                                .font(.system(size: 15, weight: .bold))

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

                            Button(action: {
                                    UIApplication.shared.endEditing()
                                    shouldExit = true
                            }, label: { Image(systemName: "xmark").imageScale(.large) })
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                                .font(.system(size: 15, weight: .bold))

                            Image("att-logo", bundle: .resourceBundle)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18, alignment: .center)
                                .scaledToFit()

                            Text(PurchaseWiFiStepTitles.transactionSummaryy.value()).font(Font.custom(ApolloSDK.current.getBoldFont(), size: 17)).foregroundColor(AttAppTheme.attSDKTextPrimaryColor)

                            Spacer()
                        }.frame(height: 44, alignment: .center)
                    }, backgroundColor: AttAppTheme.attSDKDashboardHeaderBackgroundColor, contentView: {
                        AttSwiftUIWebView(url: url, delegate: delegate).background(AttAppTheme.attSDKBackgroundColor).navigationBarHidden(true)
                    })

                }
                if shouldExit {
                    AttDialog(open: $shouldExit,
                           exitTitle: "leave_payment_title".localized(),
                           message1: "leave_payment_body".localized(),
                           acceptBtnTitle: "leave_payment_continue_button".localized(),
                           cancelBtnTitle: "leave_payment_exit_button".localized(),
                           onAccept: { shouldExit = false },
                           onCancel: { self.onExit(false) },
                           messageAlignment: .leading)
                }
            }
        }.background(AttAppTheme.attSDKBackgroundColor)
        

    }
    
    
    func startPurchase() {
        self.model.purchaseProduct(completion: onComplete)
    }
}

struct AttPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        AttPaymentView(url: nil, delegate: nil, onExit: {_ in }, onBack: {}, onComplete: {}, model: .init(autoRenew: false, product: AttMockViewModal.products[0]))
    }
}

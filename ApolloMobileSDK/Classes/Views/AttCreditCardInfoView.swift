//
//  CreditCardInfoView.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/25/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation
import SwiftUI

public struct AttCreditCardInfoView: View {
    @ObservedObject var paymentModel: AttPaymentViewModel
    @ObservedObject var creditCardInfoViewModel: AttCreditCardInfoViewModel
    
    var goBack: () -> Void
    var goNext: () -> Void
    var goToDashboard: () -> Void
    var editPaymentProfile: (AttAddress?) -> Void
    
    public var body: some View {
        return ZStack {
            if paymentModel.showLoading {
                VStack{
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
                }
            } else if creditCardInfoViewModel.showActivityIndicator {
                AttActivityIndicator()
            } else if paymentModel.isAddSubscriptionError  {
                renderPurchaseError()
            } else if paymentModel.isValidatePaymentError {
                renderValidatePaymentError()
            } else {
                renderForm()
            }
        }.onAppear() {
            AttPaymentsServices.shared.resetCachedData()
            self.fetchPaymentProfileData(completion: { _ in })
        }
    }
    
    private func formatHeaderText(headerTitle: String, width: CGFloat) -> some View {
        return Text(headerTitle)
            .font(.custom(ApolloSDK.current.getMediumFont(), size: 11))
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            .frame(width: width, alignment: .leading)
            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
    }
    
    private func formatValueText(headerTitle: String, width: CGFloat) -> some View {
        return Text(headerTitle)
            .font(.custom(ApolloSDK.current.getBoldFont(), size: 11))
            .frame(width: width, alignment: .leading)
            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
    }
    
    private func formatCardValueText(title: String, height: CGFloat) -> some View {
        return Text(title)
            .font(.custom(ApolloSDK.current.getBoldFont(), size: 11))
            .frame(height: height, alignment: .leading)
            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
    }
    
    func renderForm() -> AnyView {
        return AnyView(
            ScrollView {
                VStack(alignment: .center, spacing: 10) {
                    VStack(alignment: .leading, spacing: 10) {
                            Text("payment_info_payment_profile_title".localized())
                                .font(.custom(ApolloSDK.current.getBoldFont(), size: 15))
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                            Spacer().frame(height: 20)
                            Text("payment_info_credit_card_title".localized())
                                .font(.custom(ApolloSDK.current.getMediumFont(), size: 13))
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                            Spacer().frame(height: 8)
                            GeometryReader { metrics in
                                VStack(spacing: 8) {
                                    HStack(spacing: 20) {
                                        self.formatHeaderText(headerTitle: "payment_info_name_on_card_title".localized(),  width: metrics.size.width * 0.25)
                                        Spacer().frame(height: 4)
                                        self.formatHeaderText(headerTitle: "payment_info_card_number_title".localized(),  width: metrics.size.width * 0.33)
                                        Spacer().frame(height: 2)
                                        self.formatHeaderText(headerTitle: "payment_info_expires_title".localized(), width: metrics.size.width * 0.33)
                                    }
                                    .padding([.leading, .trailing], 0)
                                    
                                    HStack(spacing: 20) {
                                        self.formatValueText(headerTitle: creditCardInfoViewModel.nameOnCard,  width: metrics.size.width * 0.25).fixedSize(horizontal: true, vertical: true)
                                        Spacer().frame(height: 4)
                                        self.formatValueText(headerTitle: "\("**** **** ****") \(creditCard(string: creditCardInfoViewModel.creditCardNumber))",  width: metrics.size.width * 0.33)
                                        Spacer().frame(height: 2)
                                        self.formatValueText(headerTitle: "\(lastTwoExpires(string:creditCardInfoViewModel.expires))/\(firstTwoExpires(string:creditCardInfoViewModel.expires))", width: metrics.size.width * 0.33)
                                    }
                                    .padding([.leading, .trailing], 0)
                                }
                            }
                        }
                    
                    Spacer().frame(height: 100)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("payment_info_billing_address_title".localized())
                                .font(.custom(ApolloSDK.current.getMediumFont(), size: 13))
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                                .font(.custom(ApolloSDK.current.getMediumFont(), size: 15))
                            Spacer()
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            self.formatCardValueText(title: creditCardInfoViewModel.address,  height: 15)
                            self.formatCardValueText(title: creditCardInfoViewModel.city,  height: 15)
                            self.formatCardValueText(title: "\(creditCardInfoViewModel.state), \(creditCardInfoViewModel.zipCode)",  height: 15)
                            self.formatCardValueText(title: creditCardInfoViewModel.country,  height: 15)
                        }
                    }
                    
                    Spacer().frame(height: 30)
                    
                    Button(action: {self.editPaymentProfile(creditCardInfoViewModel.billingAddress)}) {
                        HStack {
                            Spacer()
                            Text("payment_info_edit_payment_profile_button".localized())
                                .font(.custom(ApolloSDK.current.getMediumFont(), size: 15))
                                .foregroundColor(AttAppTheme.attSDKSecondaryButtonTextColor)
                            Spacer()
                            
                        }
                    }
                    .buttonStyle(AttSecondaryButtonStyle())
                    
                    Spacer().frame(minHeight: 0, idealHeight: 100, maxHeight: .infinity)
                    
                    HStack {
                        Text("payment_info_note_text".localized())
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                            .font(.custom(ApolloSDK.current.getMediumFont(), size: 11))
                            .multilineTextAlignment(.center)
                    }.padding()
                    
                    VStack(alignment: .center, spacing: 10)  {
                        Button(action: {
                            self.paymentModel.purchaseProduct(completion: self.goNext)
                        }) {
                            HStack {
                                Spacer()
                                Text("payment_info_complete_purchase_button".localized())
                                    .font(.custom(ApolloSDK.current.getMediumFont(), size: 15))
                                    .foregroundColor(AttAppTheme.attSDKPrimaryButtonTextColor)
                                Spacer()
                            }
                        }
                        .disabled(self.creditCardInfoViewModel.showActivityIndicator)
                        .buttonStyle(AttPrimaryButtonStyle())
                        
                        Button(action: {
                            self.goBack()
                        }){
                            HStack {
                                Spacer()
                                Text("back".localized())
                                    .font(.custom(ApolloSDK.current.getMediumFont(), size: 15))
                                    .foregroundColor(AttAppTheme.attSDKSecondaryButtonTextColor)
                                Spacer()
                                
                            }
                        }
                        .buttonStyle(AttSecondaryButtonStyle())
                    }
                }.padding()
            }.background(AttAppTheme.attSDKBackgroundColor))
    }
    
    func renderValidatePaymentError() -> AnyView {
        return AnyView(
            AttErrorView(
                showContact: true,
                retryTitle: "dashboard_retry".localized(),
                exitTitle: "add_subscription_after_payment_failed_button_text".localized(),
                onRetry: { self.fetchPaymentProfileData(completion: self.editPaymentProfile) },
                onExit: goToDashboard,
                contentView: Text("dashboard_error_something_went_wrong".localized())
                    .font(.custom(ApolloSDK.current.getMediumFont(), size: 17))
                    .foregroundColor(AttAppTheme.attSDKTextPrimaryColor))
        )
    }
    
    
    func renderPurchaseError () -> AnyView {
        return AnyView(
            AttErrorView(
                showContact: true,
                retryTitle: "add_subscription_after_payment_failed_button_text".localized(),
                onRetry: goToDashboard,
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
        )
    }
    
    func getExpirationYearDropdownOptions() -> [String] {
        let year = 2012
        return (year...year + 10).map{ year in
            return String(year)
        }
    }
    
    func getExpirationMonthDropdownOptions() -> [String] {
        return (1...12).map{ month in
            return String(format: "%02d", month)
        }
    }
    private func firstTwoExpires(string: String) -> String {
        let string = string
        let substring1 = string.dropLast(2)
        return String(substring1)
    }
    
    private func lastTwoExpires(string: String) -> String {
        let string = string
        let substring1 = string.dropFirst(2)
        return String(substring1)
    }
    private func creditCard(string: String) -> String {
        let string = string
        let substring1 = string.dropFirst(12)
        return String(substring1)
    }
    
    func fetchPaymentProfileData(completion: @escaping (AttAddress?) -> Void) {
        self.creditCardInfoViewModel.showActivityIndicator = true
        self.creditCardInfoViewModel.fetchPaymentProfileData(completion: completion)
    }
}

struct CreditCardInfoView_Preview: PreviewProvider {
    static var previews: some View {
        AttCreditCardInfoView(
            paymentModel: .init(autoRenew: false, product: AttMockViewModal.products[0]),
            creditCardInfoViewModel: AttCreditCardInfoViewModel(),
            goBack: {},
            goNext: {},
            goToDashboard: {},
            editPaymentProfile: {_ in }
        )
            .previewDevice("iPhone 13 Pro Max")
    }
}

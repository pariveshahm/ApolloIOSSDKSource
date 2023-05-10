//
//  AttPaymentProfileView.swift
//  ApolloMobileSDK
//
//  Created by Nermin Sabanovic on 4. 10. 2022..
//

import SwiftUI

struct AttPaymentProfileView: View {
    
    @ObservedObject
    var viewModel: AttCreditCardInfoViewModel
    var onViewPaymentProfile: () -> Void     = { }
    var paymentService: AttPaymentsServices = AttPaymentsServices()
    
    var body: some View {
        var content: [AnyView] = []
        var emptyContent: [AnyView] = []
        
        content.append(paymentInfo())
        content.append(createFullPaymentInfo())
        
        emptyContent.append(emptyInfo())
        
        if (viewModel.showActivityIndicator) {
            let emptyWidget = AttEmptyWidget(screenType: .paymentProfile)
            return AnyView(emptyWidget)
        } else if (viewModel.errorCode) {
                return AnyView(ZStack {
                    return AttCollapseMenu(
                        title: "payment_profile_title".localized(),
                        footnote: ("no_credit_card_added".localized()),
                        content: emptyContent
                    )
                }.disabled(content.isEmpty))
            } else {
                return AnyView(ZStack {
                    return AttCollapseMenu(
                        title: "payment_profile_title".localized(),
                        footnote: "\("**** **** ****") \(creditCard(string: viewModel.creditCardNumber))",
                        content: content
                    )
                }.disabled(content.isEmpty))
            }
        }
    private func creditCard(string: String) -> String {
        let string = string
        let substring1 = string.dropFirst(12)
        return String(substring1)
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
    // - View
    private func paymentInfo() -> AnyView {
        
        return AnyView(
                VStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("dashboard_name_on_card".localized())
                                .font(.custom(.regular, size: 11))
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor).opacity(1)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Text("\(viewModel.nameOnCard)")
                                .font(.custom(.bold, size: 11))
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor).opacity(1)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer().frame(height: 10)
                        HStack {
                            Text("dashboard_card_number".localized())
                                .font(.custom(.regular, size: 11))
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor).opacity(1)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Text("\("**** **** ****") \(creditCard(string: viewModel.creditCardNumber))")
                                .font(.custom(.bold, size: 11))
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor).opacity(1)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer().frame(height: 10)
                        HStack {
                            Text("dashboard_expires".localized())
                                .font(.custom(.regular, size: 11))
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor).opacity(1)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                            Text("         ")
                                .font(.custom(.bold, size: 11))
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor).opacity(1)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                            Text("\(lastTwoExpires(string:viewModel.expires))/\(firstTwoExpires(string:viewModel.expires))")
                                .font(.custom(.bold, size: 11))
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor).opacity(1)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }.padding().frame(maxWidth: .infinity, alignment: .leading)
            }
                    .foregroundColor(.init(.label)).frame(maxWidth: .infinity, maxHeight: 70, alignment: .leading)
        )
    }
    private func emptyInfo() -> AnyView {
        
        return AnyView(
                VStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("no_credit_card_information".localized())
                            .font(.custom(.regular, size: 11))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor).opacity(1)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer().frame(height: 10)
                    }.padding().frame(maxWidth: .infinity, alignment: .leading)
            }
                    .foregroundColor(.init(.label)).frame(maxWidth: .infinity, maxHeight: 70, alignment: .leading)
        )
    }
    
    // - View
    private func createFullPaymentInfo() -> AnyView {
        return AnyView(
            Button(action: onViewPaymentProfile) {
                HStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("view_full_payment_profile".localized())
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


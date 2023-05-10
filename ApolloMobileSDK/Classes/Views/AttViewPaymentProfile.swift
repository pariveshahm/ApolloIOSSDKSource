//
//  AttViewPaymentProfile.swift
//  ApolloMobileSDK
//
//  Created by Nermin Sabanovic on 14. 10. 2022..
//

import SwiftUI

public struct AttViewPaymentProfile: View {
    @ObservedObject var creditCardInfoViewModel: AttCreditCardInfoViewModel
    var goBack: () -> Void
    var editPaymentProfile: (AttAddress?) -> Void
    
    
    public var body: some View {
        AttNavigationBarViewNoBack<AnyView, AnyView>(titleText: "payment_profile_information_title".localized(), backgroundColor: AttAppTheme.attSDKBackgroundColor, contentView: {
            AnyView(
                VStack(alignment: .center, spacing: 0) {
                    ZStack {
                        if creditCardInfoViewModel.showActivityIndicator {
                            VStack{
                                Spacer()
                                AttActivityIndicator()
                                    .frame(minHeight: 10, maxHeight: 100)
                                Spacer()
                            }
                        } else {
                            renderForm()
                        }
                    }.onAppear(perform: {
                        AttPaymentsServices.shared.resetCachedData()
                        self.fetchPaymentProfileData(completion: { _ in })
                    })
                }.navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true)
            )
        }, onBack: {}
                                                     
                                               
        )}

    
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
                    
                    Spacer().frame(minHeight: 0, idealHeight: 100, maxHeight: .infinity)
                    
                    VStack(alignment: .center, spacing: 10)  {
                        
                    Button(action: { self.editPaymentProfile(creditCardInfoViewModel.billingAddress)}) {
                        HStack {
                            Spacer()
                            Text("payment_info_edit_payment_profile_button".localized())
                                .font(.custom(ApolloSDK.current.getMediumFont(), size: 15))
                                .foregroundColor(AttAppTheme.attSDKPrimaryButtonTextColor)
                            Spacer()

                        }
                    }
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
    
    func fetchPaymentProfileData(completion: @escaping (AttAddress?) -> Void) {
        self.creditCardInfoViewModel.showActivityIndicator = true
        self.creditCardInfoViewModel.fetchPaymentProfileData(completion: completion)
    }
}

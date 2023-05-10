//  TransactionSummaryView.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 24/12/2020.

import SwiftUI
import Combine

public struct AttTransactionSummaryView: View {
    
    // - State
    @EnvironmentObject
    private var model: AttTransactionSummaryModel
    
    // - Properties
    var onBack:   () -> Void
    var onExit:   () -> Void
    var onNext:   () -> Void
    var onAccountDashboard: () -> Void
    var offer:    AttProductOffer
    var product:  AttProduct
    
    // - Actions
    private func handleSubmit() {
        if model.isTrial {
            model.activateTrial(onNext)
        } else {
            model.activateDataPlan(onNext)
        }
    }
    
    // MARK: - Views
    public var body: some View {
        ZStack {
            AttAppTheme.attSDKBackgroundColor.edgesIgnoringSafeArea(.all)
            
            if model.showLoading == true {
                AttActivityIndicator()
            } else if model.showLoadingMessage {
                loaderView()
            } else {
                ScrollView {
                    // - HEADER
                        headerView()
                    
                    // - USER INFO
                        userInfoView()
                    Divider().padding(.horizontal)
                    
                    // - INVOICE
                        invoiceView()
                    
                    Divider().padding(.horizontal)
                    
                    // - PAYMENT
                        paymentView()
                    
                    Divider().padding(.horizontal)
                    
                    // - AGGREMENTS
                        aggrementsView()
                    
                    Divider().padding(.horizontal)
                    
                    // - ACTIONS
                        actionsView()
                }//.background(AttAppTheme.attSDKBackgroundColor)
            }
            
            if model.showError {
                AttErrorView(
                    showContact: true,
                    onRetry: { self.model.showError = false; self.handleSubmit() },
                    onExit: onBack,
                    contentView: Text("transaction_summary_error_load_user_data".localized())
                        .font(.custom(ApolloSDK.current.getBoldFont(), size: 14))
                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        .multilineTextAlignment(.center)
                )
            }
            
            if model.showVehicleError {
                AttErrorView(
                    showContact: true,
                    retryTitle: "dashboard_retry".localized(),
                    exitTitle: "transaction_summary_error_create_vehicle_link_exit".localized(),
                    onRetry: { model.showVehicleError = false; model.createVehicleLink() },
                    onExit: onExit,
                    contentView: AttLinkedText(content: [
                        .text(AttContentText(
                            "transaction_summary_error_create_vehicle_link_message".localized(),
                            font: .custom(ApolloSDK.current.getBoldFont(), size: 14)
                        ))
                    ]).padding()
                ).padding([.horizontal], 14)
            }
            
            if model.showActivateSubscriberError {
                AttErrorView(
                    showContact: true,
                    retryTitle: "dashboard_retry".localized(),
                    exitTitle: "dashboard_title".localized(),
                    onRetry: { model.showActivateSubscriberError = false;
                        model.activateSubscriber()
                    },
                    onExit: onAccountDashboard,
                    contentView: AttLinkedText(content: [
                        .text(AttContentText(
                            "transaction_summary_error_activate_subscriber_message".localized(),
                            font: .custom(ApolloSDK.current.getBoldFont(), size: 14)
                        ))
                    ]).padding()
                ).padding([.horizontal], 14)
            }
            
            if model.showConsentError {
                AttErrorView(
                    retryTitle: "dashboard_retry".localized(),
                    exitTitle: (model.isTrial) ? ApolloSDK.current.getDashboardButtonFirstTitle() : "dashboard_title".localized(),
                    onRetry: { model.showConsentError = false; model.initalSetup() },
                    onExit: { (model.isTrial) ? onExit() : onAccountDashboard()  },
                    contentView: AttLinkedText(content: [
                        .text(AttContentText(
                            "transaction_summary_trial_consent_error".localized(),
                            font: .custom(ApolloSDK.current.getBoldFont(), size: 14)
                        )),
                        .link(AttHyperLink(
                            text: "1 (866) 595-1222.",
                            link: URL(string: "tel://18665951222")!,
                            type: .number,
                            font: .custom(ApolloSDK.current.getBoldFont(), size: 14)
                        ))
                    ]).padding()
                ).padding([.horizontal], 14)
            }
                
        }.onAppear(perform: model.initalSetup).navigationBarHidden(true)
    }
    private func headerView() -> some View {
        VStack(spacing: 4) {
            Image("att-logo", bundle: .resourceBundle)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 60)
            
            Spacer().frame(height: 8)
            
            Text("transaction_summary_trial_lets_activate_title".localized())
                .font(.custom(.regular, size: 12))
                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
            if model.isTrial {
                let productLimitCapitalized = "\(product.usage?.limit ?? "")" + "\(product.usage?.unit ?? "")" + " " + "\(product.billingType)".capitalized
                let productLimit =  productLimitCapitalized + " " + "data_plan".localized() + "¹"
                
                Text(productLimit)
                    .font(.custom(.medium, size: 20))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
            } else {
                Text(product.name + "¹")
                    .font(.custom(.medium, size: 20))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
            }
            Spacer().frame(height: 8)
            
            if model.isTrial == false, model.isSpecialOffer == false {
                Button(action: {
                    self.onBack()
                }) {
                    Spacer()
                    Text("transaction_summary_change_plan_button_text".localized())
                        .font(.custom(ApolloSDK.current.getMediumFont(), size: 12))
                    Spacer()
                }
                .frame(width: 100, height: AttAppTheme.attSDKPillButtonHeight)
                .foregroundColor(AttAppTheme.attSDKSecondaryButtonTextColor)
                .background(AttAppTheme.attSDKSecondaryButtonBackgroundColor)
                .if(AttAppTheme.attSDKButtonCurvature > 0, content: {
                    $0.cornerRadius((AttAppTheme.attSDKButtonCurvature * 30) / 55)
                })
                    .if(AttAppTheme.attSDKSecondaryButtonBorderWidth > 0, content: {
                        $0.overlay(RoundedRectangle(cornerRadius: (AttAppTheme.attSDKButtonCurvature * 30) / 55 ).stroke(AttAppTheme.attSDKSecondaryButtonBorderColor, lineWidth: AttAppTheme.attSDKSecondaryButtonBorderWidth))
                    })
                    
                    Spacer().frame(height: 10)
            }
            
            Text("transaction_summary_trial_almost_done_title".localized())
                .font(.custom(.regular, size: 15))
                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
        }
        .padding(30)
    }
    private func loaderView() -> some View {
        Group {
            VStack {
                AttActivityIndicator()
                    .frame(minHeight: 10, maxHeight: 100)
                
                Text("loading_please_wait".localized())
                    .multilineTextAlignment(.center)
                    .font(.custom(ApolloSDK.current.getBoldFont(), size: 20))
                    .foregroundColor(AttAppTheme.primaryColor)
                Text("loading_activating_service_message".localized())
                    .padding([.leading, .trailing], 16)
                    .multilineTextAlignment(.center)
                    .font(.custom(ApolloSDK.current.getMediumFont(), size: 15))
                    .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
            }
        }
    }
    private func userInfoView() -> some View {
        VStack {
            AttTextDisclouserView(label: "transaction_summary_trial_first_name_title".localized(),
                                  value: model.user.firstName)
                .padding(.bottom, 8)
            
            
            AttTextDisclouserView(label: "transaction_summary_trial_last_name_title".localized(),
                                  value: model.user.lastName)
                .padding(.bottom, 8)
            
            AttTextDisclouserView(label: "transaction_summary_trial_email_title".localized(),
                                  value: model.user.email)
                .padding(.bottom, 8)
        }
        .padding()
        
    }
    private func invoiceView() -> some View {
        VStack {
            AttTextDisclouserView(label: "transaction_summary_trial_base_title".localized(),
                                  value: model.base)
                .padding(.bottom, 8)
            
            AttTextDisclouserView(label: "transaction_summary_trial_tax_title".localized(),
                                  value: model.tax)
            .padding(.bottom, 8)
            
            AttTextDisclouserView(label:"transaction_summary_trial_other_fees_title".localized(),
                                  value: model.fees)
            .padding(.bottom, 8)
        }
        .padding()
    }
    private func paymentView() -> some View {
        VStack {
            HStack {
                Text("transaction_summary_trial_total_title".localized())
                    .foregroundColor(AttAppTheme.primaryColor)
                    .font(.custom(.medium, size: 15))
                
                Spacer()
                
                Text(model.total ?? "$0.00")
                    .foregroundColor(AttAppTheme.primaryColor)
                    .font(.custom(.medium, size: 15))
            }
            .padding(.bottom, 4)
            
            if !model.isTrial {
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("transaction_summary_trial_access_charges_title".localized())
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                            .font(.custom(.regular, size: 15))
                        
                        Text(model.monthlyTotal ?? "")
                            .font(.custom(.medium, size: 15))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                    }
                }
            }
        }
        .padding()
    }
    private func actionsView() -> some View {
        VStack {
            Button(model.isTrial ? "transaction_summary_trial_button_activate".localized() : "transaction_summary_enter_your_credit_card".localized(), action: handleSubmit)
                .disabled(model.isTrial ? !model.acceptTerms : !model.acceptTerms || !model.autoRenew)
                .buttonStyle(AttPrimaryButtonStyle())
            
            Spacer().frame(height: 8)
            
            Button("transaction_summary_trial_button_back".localized(), action: self.onBack)
                .buttonStyle(AttSecondaryButtonStyle())
            
            Spacer().frame(height: 16)
            
            // - Fine print
            HStack(alignment: .top, spacing: 0) {
                Text("1")
                    .font(.custom(ApolloSDK.current.getMediumFont(), size: 6))
                    .foregroundColor(Color(.darkGray))
                
                if model.isTrial {
                    AttLinkedText(content: [
                        .text(AttContentText(
                            "transaction_summary_trial_fine_text".localized(),
                            font: .custom(ApolloSDK.current.getMediumFont(), size: 10),
                            color: AttAppTheme.attSDKTextSecondaryColor)
                        ),
                        .link(AttHyperLink(
                            text: "http://www.att.com/USTermsandconditions.",
                            link: URL(string: "http://www.att.com/USTermsandconditions")!,
                            font: .custom(ApolloSDK.current.getMediumFont(), size: 10))
                        ),
                        .text(AttContentText(
                            "offers_terms_pricing".localized(),
                            font:.custom(ApolloSDK.current.getMediumFont(), size: 10),
                            color: AttAppTheme.attSDKTextSecondaryColor)
                        )
                    ])
                } else if model.isSpecialOffer {
                    let disclaimerText = "one_time_offer_disclaimer".localized() + " " + "pricing_offer_and_terms_subject".localized()
                    let links = AttDisclaimerHelper.getDisclaimerLinks()
                    let font = UIFont(name: ApolloSDK.current.getMediumFont(), size: 10.0)!
                    let textColor = AttAppTheme.attSDKTextSecondaryColor.uiColor()
                    let width = UIScreen.main.bounds.width - 32
                    
                    let height1 = disclaimerText.height(withConstrainedWidth: width, font: font, textAlignment: .left, lineHeightMultiple: 1.23) + 32
                    AttTextView(links: links, text: disclaimerText, font: font, color: textColor, textAlignment: .left)
                        .frame(width: width, height: height1)
                        .transition(.opacity)
                    
                } else {
                    let disclaimerText = AttDisclaimerHelper.getDisclaimer(product: product).text
                    let links = AttDisclaimerHelper.getDisclaimerLinks()
                    let font = UIFont(name: ApolloSDK.current.getMediumFont(), size: 10.0)!
                    let textColor = AttAppTheme.attSDKTextSecondaryColor.uiColor()
                    let width = UIScreen.main.bounds.width - 32
                    
                    let height1 = disclaimerText.height(withConstrainedWidth: width, font: font, textAlignment: .left, lineHeightMultiple: 1.23) + 32
                    AttTextView(links: links, text: disclaimerText, font: font, color: textColor, textAlignment: .left)
                        .frame(height: height1)
                        .transition(.opacity)
                }
            }
        }
        .padding()
    }
    private func aggrementsView() -> some View {
        VStack(alignment: .leading) {
            
            if !model.isTrial {
                AttCheckbox(
                    isChecked: $model.autoRenew,
                    contentView: Text("checkbox_text".localized())
                        .lineLimit(nil)
                        .font(.custom(.bold, size: 13))
                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                )
                
                Spacer().frame(height: 12)
                Text("transaction_summary_prepaid_autorenew_note".localized())
                    .foregroundColor(AttAppTheme.attSDKTextSecondaryColor)
                    .font(.custom(.regular, size: 11))
                    .padding(.bottom, 8)
                
                Spacer().frame(height: 12)
                Text("transaction_summary_checkbox_description_message".localized())
                    .foregroundColor(AttAppTheme.attSDKTextSecondaryColor)
                    .font(.custom(.regular, size: 11))
                    .padding(.bottom, 8)
                
            } else {
                
                Text("transaction_summary_trial_checkbox_description_message".localized())
                    .foregroundColor(AttAppTheme.attSDKTextSecondaryColor)
                    .font(.custom(.regular, size: 11))
                    .padding(.bottom, 8)
                
            }
            
            // CheckBox
                checkBoxView()
            
            if model.showConsent {
                Spacer().frame(height: 16)
                
                AttCheckbox(
                    isChecked: $model.acceptConsent,
                    contentView: Text("transactionsummary_termsContact".localized())
                        .font(.custom(ApolloSDK.current.getBoldFont(), size: 13))
                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                )
            }
        }
        .padding()
    }
    private func checkBoxView() -> some View {
        AttCheckbox(
            isChecked: $model.acceptTerms,
            contentView: VStack(alignment: .leading, spacing: 0) {
                AttLinkedText(content: [
                    .text(AttContentText(
                        "i_accept".localized(),
                        font: .custom(.bold, size: 13)
                    )),
                    .link(AttHyperLink(
                        text: "transactionsummary_terms".localized(),
                        link: URL(string: "https://www.att.com/legal/terms.attWebsiteTermsOfUse")!,
                        font: .custom(.bold, size: 13)
                    )),
                    .text(AttContentText(
                        "and".localized(),
                        font: .custom(.bold, size: 13)
                    )),
                    .link(AttHyperLink(
                        text: "legal_and_regulatory_privacy_policy".localized(),
                        link: URL(string: "https://about.att.com/csr/home/privacy.html")!,
                        font: .custom(.bold, size: 13)
                    )),
                ])
                
                AttLinkedText(content: [
                    .text(AttContentText(
                        "i_am_aware_network".localized(),
                        font: .custom(.bold, size: 13)
                    )),
                    .link(AttHyperLink(
                        text: "att.com/broadbandinfo",
                        link: URL(string: "https://about.att.com/sites/broadband")!,
                        font: .custom(.bold, size: 13)
                    ))
                ])
            }
        )
    }

}


struct AttTextDisclouserView: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                .font(.custom(.regular, size: 13))
            
            Spacer()
            
            Text(value)
                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                .font(.custom(.bold, size: 13))
        }
    }
}


struct TransactionSummaryView_Preview: PreviewProvider {
    
    private static var model: AttTransactionSummaryModel {
        let tsm = AttTransactionSummaryModel(AttMockViewModal.products[0])
        
        tsm.user = .init(
            firstName: "Lex",
            lastName: "Test",
            email: "test@gmail.com",
            phone: "",
            address: .init(),
            language: AttCountry.Language(name: "", code: "")
        )
        
        return tsm
    }
    
    static var previews: some View {
        AttTransactionSummaryView(
            onBack: {},
            onExit: {},
            onNext: {},
            onAccountDashboard: {},
            offer: .init(
                planName: "3GB Trial Data Plan",
                dataAmount: "3GB",
                planExpiration: "90 Days"
            ),
            product: .init(id: "", name: "Product name", type: "Product type", billingType: .prepaid)
        )
        .environmentObject(model)
    }
}

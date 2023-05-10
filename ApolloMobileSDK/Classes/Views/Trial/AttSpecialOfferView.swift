//  TrialActivatedView.swift
//  ATTORMRetailSDK
//
//  Created by Selma Suvalija on 7/9/20.

import SwiftUI

public struct AttSpecialOfferView: View {
    
    // - State
    @State private var showDashboard = false
    
    // - Actions
    var onAccept: (AttProduct) -> Void = { _ in }
    var onDeny: () -> Void = { }
    
    private var warnerMediaOffer = AttProduct(
        id: AttConstants.getSpecialOfferId(),
        name: "transaction_summary_trial_ztial_plan_name".localized(),
        type: "",
        billingType: .prepaid,
        price: .init(amount: "20.00", currency: "USD"),
        usage: .init(limit: "unlimited", used: "", unit: "GB"),
        recurrent: .init(interval: 30, unit: "days", autoRenew: false)
    ) 
    
    public var body: some View {
        AttNavigationBarView<AnyView, AnyView>(titleText: "transaction_summary_step_name".localized(), backgroundColor: AttAppTheme.attSDKBackgroundColor, contentView: {
            AnyView(
                ScrollView {
                    VStack(alignment: .center, spacing: 20) {
                        Spacer().frame(height: 20)
                        
                        // - HEADER
                        VStack {
                            Image("att-logo", bundle: .resourceBundle)
                                .resizable()
                                .frame(width: 45, height: 45)
                            
                            Text("congratulations".localized())
                                .font(.custom(ApolloSDK.current.getMediumFont(), size: 18))
                                .padding([.bottom, .top], 12)
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                            
                            Text("one_time_offer_trial_period_started".localized())
                                .font(.custom(ApolloSDK.current.getMediumFont(), size: 14))
                                .lineLimit(3)
                                .multilineTextAlignment(.center)
                                .lineSpacing(3.0)
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                                .frame(height: 70)
                                .padding(.horizontal, 16)
                            
                        }
                        .padding()
                        
                        // - SPECIAL OFFER
                        AttSpecialOfferRideView(product: warnerMediaOffer, onAccept: onAccept)
                            .padding(.horizontal, 16)
                        
                        
                        // - DISCLOUSER TEXT
                        Text("special_offer".localized())
                            .font(.custom(ApolloSDK.current.getRegularFont(), size: 10))
                            .padding(.horizontal, 15)
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        
                        // - ACTIONS
                        VStack(spacing: 12) {
                            
                            Button("one_time_offer_no_thanks_button".localized(), action: onDeny)
                                .buttonStyle(AttSecondaryButtonStyle())
                            
                            Text("one_time_offer_decline_text".localized())
                                .font(.custom(ApolloSDK.current.getRegularFont(), size: 13))
                                .foregroundColor(AttAppTheme.attSDKTextSecondaryColor)
                        }.padding(.horizontal, 14)
                        
                        let disclaimerText = "one_time_offer_disclaimer".localized() //+ " " + "pricing_offer_and_terms_subject".localized()
                        let links = AttDisclaimerHelper.getDisclaimerLinks()
                        let font = UIFont(name: ApolloSDK.current.getMediumFont(), size: 10.0) ?? UIFont.systemFont(ofSize: 10)
                        let textColor = AttAppTheme.attSDKTextSecondaryColor.uiColor()
                        let width = UIScreen.main.bounds.width - 32
                        let height1 = disclaimerText.height(withConstrainedWidth: width, font: font, textAlignment: .left, lineHeightMultiple: 1.23) + 32
                        
                        AttTextView(links: links, text: disclaimerText, font: font, color: textColor, textAlignment: .left)
                            .frame(width: width,height: height1)
                            .transition(.opacity)
                    }
                }.background(AttAppTheme.attSDKBackgroundColor).navigationBarHidden(true))
        }, onBack: nil)
    }
}

struct AttSpecialOfferView_Previews: PreviewProvider {
    static var previews: some View {
        AttSpecialOfferView()
    }
}

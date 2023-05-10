//
//  SpecialOfferRideView.swift
//  ApolloMobileSDK
//
//  Created by Elvis on 12/8/21.
//

import SwiftUI

struct AttSpecialOfferRideView: View {
    var product: AttProduct
    var onAccept: (AttProduct) -> Void = { _ in }
    
    var body: some View {
        VStack(alignment: .center, spacing: 20){
            VStack {
                    Text("one_time_offer_only_available".localized())
                        .foregroundColor(.white)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.custom(ApolloSDK.current.getRegularFont(), size: 15))
                    
                    Spacer().frame(height: 8)
                    
                    Text("transaction_summary_trial_ztial_plan_name".localized())
                        .foregroundColor(AttAppTheme.blueProgressBarColor)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.custom(ApolloSDK.current.getMediumFont(), size: 19))
                    
                    Spacer().frame(height: 20)
                    
                    Divider().background(AttAppTheme.attSDKBackgroundColor).opacity(0.5)
                    
                    Spacer().frame(height: 20)
                    
                    HStack {
                        Text("regular_price".localized())
                            .foregroundColor(.white)
                            .font(.custom(ApolloSDK.current.getRegularFont(), size: 14))
                        
                        AttDiscountedPriceView(
                            currency: "$",
                            amount: "25",
                            period: "per_month".localized(),
                            striked: true
                        )
                    }
                    
                    Spacer().frame(height: 5)
                    
                    HStack {
                        Text("special_offer_price".localized())
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .font(.custom(ApolloSDK.current.getRegularFont(), size: 16))
                            .scaledToFill()
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                        
                        AttDiscountedPriceView(
                            currency: "$",
                            amount: "20",
                            period: "per_month".localized(),
                            amountFontSize: 25.0,
                            amountFontColor: AttAppTheme.blueProgressBarColor,
                            decorationFontColor: .white
                        )
                    }
                
            }
            .padding()
            .background(Color(hex: "#2F2F2F"))
            .frame(maxWidth: .infinity)
            
            VStack(alignment: .center, spacing: 8) {
                Image("warner-ride", bundle: .resourceBundle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 240, height: 60)
                    .clipped()

                Text("ride_special_offer_body".localized())
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.custom(ApolloSDK.current.getMediumFont(), size: 14))
                    .padding(.horizontal, 16)
                    .foregroundColor(.white)

            }.padding(.horizontal, 8)
            
            Button("one_time_offer_get_special_offer_button".localized(), action: { self.onAccept(product) })
                .buttonStyle(AttSecondaryButtonStyle(textColor: .black, backgroundColor: .white))
                .padding(16)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    AttAppTheme.backgroundGradientColor1,
                    AttAppTheme.backgroundGradientColor2
                ]),
                startPoint: .leading,
                endPoint: .trailing))
        .cornerRadius(10)
 
    }
}

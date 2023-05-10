//  EntertainmentPackView.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 24/12/2020.


import SwiftUI

struct AttSpecialOfferHboMaxView: View {
    var product: AttProduct
    var onAccept: (AttProduct) -> Void = { _ in }
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            // - HEADER
            Text("hbomax_special_offer_title".localized())
                .lineLimit(2)
                .font(.custom(ApolloSDK.current.getBoldFont(), size: 19))
                .foregroundColor(AttAppTheme.blueProgressBarColor)
                .frame(width: 200)
            
            Image("hbomax-movies", bundle: .resourceBundle)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
            
            // - BODY
            Group {
                // - BODY TEXT
                Text("hbomax_special_offer_body".localized())
                    .font(.custom(ApolloSDK.current.getMediumFont(), size: 14))
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(Color(.white))
                
                Image("hbomax", bundle: .resourceBundle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 240, height: 60)
                    .clipped()
                
                Divider()
                
                VStack {
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
            }
            
            Button("one_time_offer_get_special_offer_button".localized(), action: { self.onAccept(product) } )
                .buttonStyle(AttPrimaryButtonStyle())
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.black)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
    }
}

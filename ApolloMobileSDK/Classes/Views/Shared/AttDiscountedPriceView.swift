//  DiscountOfferView.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 24/12/2020.

import SwiftUI

struct AttDiscountedPriceView: View {
    // - Properties
    var currency: String
    var amount:   String
    var period:   String
    
    var striked: Bool              = false
    var amountFontSize: CGFloat    = 20.0
    var amountFontColor: Color     = .gray
    var decorationFontColor: Color = .gray
    
    var body: some View {
        HStack(spacing: 0) {
            Text(currency)
                .foregroundColor(decorationFontColor)
                .font(.custom(ApolloSDK.current.getMediumFont(), size: 14))
                .offset(x: 0, y: -5)
            
            Text(amount)
                .foregroundColor(amountFontColor)
                .font(.custom(ApolloSDK.current.getMediumFont(), size: amountFontSize))
                .strikethrough(striked, color: .gray)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            
            Text(period)
                .foregroundColor(decorationFontColor)
                .font(.custom(ApolloSDK.current.getMediumFont(), size: 16))
                .strikethrough(striked, color: .gray)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
    }
}


struct AttDiscountedPriceView_Previews: PreviewProvider {
    static var previews: some View {
        AttDiscountedPriceView(
            currency: "$",
            amount: "15",
            period: "/mo*",
            amountFontSize: 25.0,
            amountFontColor: .blue,
            decorationFontColor: .black
        )
    }
}

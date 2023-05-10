//
//  ProductListHeaderView.swift
//  ApolloMobileSDK
//
//  Created by Elvis on 3/25/21.
//

import SwiftUI

struct AttProductListHeader: View {
    var body: some View {
        GeometryReader { metrics in
            VStack(spacing: 8) {
                HStack() {
                    self.formatHeaderText(headerTitle: "plan_name".localized(),  width: metrics.size.width/3.5)
                    self.formatHeaderText(headerTitle: "plan_price".localized(),  width: metrics.size.width/4.2)
                    self.formatHeaderText(headerTitle: "plan_cost".localized(), width: metrics.size.width/4.2)
                    Spacer()
                        .frame(width: metrics.size.width/4)
                    
                }
                .padding([.leading, .trailing], 0)
              //  .background(FillAll(color: .white))
                Divider().padding([.leading], -16)
            }
        }
    }
    
    func formatHeaderText(headerTitle: String, width: CGFloat) -> some View {
        return Text(headerTitle)
            .lineLimit(nil)
            .font(.custom(ApolloSDK.current.getMediumFont(), size: 10))
            .frame(width: width, alignment: .leading)
            .foregroundColor(AttAppTheme.attSDKTextSecondaryColor)
    }
}

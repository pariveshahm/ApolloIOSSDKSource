//
//  HistoryRow.swift
//  ApolloMobileSDK
//
//  Created by Shak4l on 13/02/2021.
//

import SwiftUI

struct AttHistoryRow: View {
    
    var title:      String
    var subTitle:   String
    var badgeText:  String
    var detailText: String
    var badgeColor: Color
    var badgeTextColor: Color
    var hasPadding: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom(ApolloSDK.current.getBoldFont(), size: 16))
                    .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                
                Text(subTitle)
                    .font(.custom(ApolloSDK.current.getMediumFont(), size: 11))
                    .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                
                Spacer().frame(height: 1)
                
                AttBadge(
                    text: badgeText,
                    color: badgeColor,
                    textColor: badgeTextColor
                )
                .padding(.bottom, 10)
            }
            
            Spacer()
            
            Text(detailText)
                .font(.custom(ApolloSDK.current.getMediumFont(), size: 14))
                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
        }.padding( hasPadding ? 16 : 0)
    }
}

struct AttHistoryRow_Previews: PreviewProvider {
    static var previews: some View {
        AttHistoryRow(title: "Test", subTitle: "Test", badgeText: "Test", detailText: "test", badgeColor: .green, badgeTextColor: .white, hasPadding: true)
    }
}

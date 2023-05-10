//
//  PurchaseListHBO.swift
//  ApolloMobileSDK
//
//  Created by Elvis on 12/8/21.
//

import SwiftUI


struct AttPurchaseListHBO: View {
    @State var expand = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // - HEADER
            HStack {
                Spacer()
                VStack( alignment: .center, spacing: 16) {
                    Image("hbomax", bundle: .resourceBundle)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .clipped()
                    
                    Text("hbomax_products_title".localized())
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .font(.custom(ApolloSDK.current.getBoldFont(), size: 16))
                        .foregroundColor(AttAppTheme.blueProgressBarColor)
                        .frame(height: 30)
                    
                }.frame(width: 220)
                
                Spacer()
            }

            // - BODY
            if (expand) {
                Image("hbomax-movies", bundle: .resourceBundle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 150)
                    .clipped()
                
                Text("hbomax_products_body".localized())
                    .multilineTextAlignment(.center)
                    .font(.custom(ApolloSDK.current.getMediumFont(), size: 14))
                    .lineLimit(nil)
                    .foregroundColor(Color(.white))
                    .fixedSize(horizontal: false, vertical: true)
                
                Divider()
            }
            
            // - COLLAPSE BUTTON
            VStack {
                
                if (!expand) { Divider() }
                
                Button(action: { expand.toggle() }) {
                    HStack(alignment: .center, spacing: 4) {
                        Text("\(expand ? "warner_media_collapsible_see_less".localized() : "warner_media_collapsible_see_more".localized())")
                        Image(systemName: expand ? "chevron.up" : "chevron.down")
                    }
                }
                .foregroundColor(Color.white)
                .font(.custom(.medium, size: 16))
                .padding(5)
                
            }.frame(maxWidth: .infinity)
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.black)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
    }
}


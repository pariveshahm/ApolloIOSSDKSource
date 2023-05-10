//
//  PurchaseListRIde.swift
//  ApolloMobileSDK
//
//  Created by Elvis on 12/8/21.
//

import SwiftUI

struct AttPurchaseListRIde: View {
    @State var expand = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            
            // - HEADER
            HStack {
                Spacer()
                VStack( alignment: .center, spacing: 16) {
                    Text("ride_products_title".localized())
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .font(.custom(ApolloSDK.current.getBoldFont(), size: 21))
                        .foregroundColor(.white)
                        .frame(height: 65)
                    
                    Image("warner-ride", bundle: .resourceBundle)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .clipped()
                }.frame(width: 220)
                
                Spacer()
            }
            
            // - BODY
            if (expand) {
                Text("ride_products_body1".localized())
                    .font(.custom(ApolloSDK.current.getMediumFont(), size: 12))
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(.white))
                    .fixedSize(horizontal: false, vertical: true)
                
                Image("ride-movies", bundle: .resourceBundle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 250)
                    .clipped()

                
                Text("ride_products_body2".localized())
                    .font(.custom(ApolloSDK.current.getMediumFont(), size: 12))
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(.white))
                    .fixedSize(horizontal: false, vertical: true)
                
               // Divider()
            }
            
            // - COLLAPSE BUTTON
            VStack {
                
               // if (!expand) { Divider() }
                
                Button(action: { expand.toggle() }) {
                    HStack(alignment: .center, spacing: 4) {
                        Text("\(expand ? "warner_media_collapsible_see_less".localized() : "warner_media_collapsible_see_more".localized())")
                        Image(systemName: expand ? "chevron.up" : "chevron.down")
                    }
                }
                .foregroundColor(.white)
                .font(.custom(.medium, size: 16))
                .padding(5)
                
            }.frame(maxWidth: .infinity)
            
        }.padding()
            .frame(maxWidth: .infinity)
            .background(LinearGradient(
                gradient: Gradient(colors: [
                    AttAppTheme.backgroundGradientColor1,
                    AttAppTheme.backgroundGradientColor2
                ]),
                startPoint: .leading,
                endPoint: .trailing))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
    }
}


struct AttPurchaseListRIde_Previews: PreviewProvider {
    static var previews: some View {
        AttPurchaseListRIde(expand: true)
            .padding()
    }
}


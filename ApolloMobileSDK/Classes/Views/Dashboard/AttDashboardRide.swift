//
//  DashboardRide.swift
//  ApolloMobileSDK
//
//  Created by Elvis on 12/7/21.
//

import SwiftUI

fileprivate let features = [
    "ride_collapsible_bullet_1".localized(),
    "ride_collapsible_bullet_2".localized()
]

fileprivate let networkImages = [
    "appstore_badge",
    "playstore_badge"
]

fileprivate let networkLinks = [
    "https://apps.apple.com/us/app/id1529665084",
    "http://play.google.com/store/apps/details?id=com.warnermedia.wmce.ride"
]

struct AttDashboardRide: View {
    @State var expand = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // - HEADER
            HStack {
                Spacer()
                VStack( alignment: .center, spacing: 8) {
                    Image("warner-ride", bundle: .resourceBundle)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                        .clipped()
                    
                    Text("ride_title".localized())
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .font(.custom(ApolloSDK.current.getBoldFont(), size: 16))
                        .foregroundColor(.white)
                        .frame(height: 60)
                    
                }.frame(width: 240)
                
                Spacer()
            }
            
            // - BODY
            if (expand) {
                Group {
                    // - BULLET POINTS
                    ForEach(features, id: \.self) { point in
                        HStack {
                            Circle()
                                .frame(width: 6, height: 6)
                                .foregroundColor(.white)
                            
                            Text(point)
                                .font(.custom(ApolloSDK.current.getMediumFont(), size: 13))
                                .lineLimit(nil)
                                .foregroundColor(Color(.white))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                    Divider()
                    
                    // - ENTERTAINMENT BRANDS
                    HStack {
                        ForEach(networkImages, id: \.self) { image in
                            Button(action: {
                                switch image {
                                    case networkImages[0]:
                                        self.openLink(link: networkLinks[0])
                                        break
                                    case networkImages[1]:
                                        self.openLink(link: networkLinks[1])
                                        break
                                default:
                                    break
                                }
                            }, label: {
                                Image(image, bundle: .resourceBundle)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipped()
                            })
                        }
                    }
                }
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
    
    private func openLink(link: String) {
        if let url = URL(string: link), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

struct AttDashboardRide_Previews: PreviewProvider {
    static var previews: some View {
        AttDashboardRide(expand: true)
            .padding()
    }
}


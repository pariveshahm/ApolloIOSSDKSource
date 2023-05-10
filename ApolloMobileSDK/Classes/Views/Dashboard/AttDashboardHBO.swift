//
//  DashboardHBO.swift
//  ApolloMobileSDK
//
//  Created by Elvis on 12/7/21.
//

import SwiftUI

fileprivate let features = [
    "hbomax_collapsible_bullet_1".localized(),
    "hbomax_collapsible_bullet_2".localized(),
    "hbomax_collapsible_bullet_3".localized()
]

fileprivate let networkImages = [
    "appstore_badge",
    "playstore_badge"
]

fileprivate let networkLinks = [
    "https://apps.apple.com/us/app/hbo-max-stream-tv-movies/id971265422",
    "https://play.google.com/store/apps/details?id=com.hbo.hbonow&hl=en_US&gl=US"
]

struct AttDashboardHBO: View {
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
                        .frame(height: 40)
                        .clipped()

                    Text("hbomax_title".localized())
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .font(.custom(ApolloSDK.current.getBoldFont(), size: 16))
                        .foregroundColor(AttAppTheme.blueProgressBarColor)
                        .frame(height: 60)
                    
                }.frame(width: 250)
                
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
                                .foregroundColor(.blue)
                            
                            Text(point)
                                .font(.custom(ApolloSDK.current.getMediumFont(), size: 14))
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
    
    private func openLink(link: String) {
        if let url = URL(string: link), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}



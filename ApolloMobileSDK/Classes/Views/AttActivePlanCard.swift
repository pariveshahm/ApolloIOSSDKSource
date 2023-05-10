//
//  ActivePlanCard.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 4/1/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import SwiftUI

public struct AttActivePlanCard: View {
    let maxCardWidth: CGFloat = UIScreen.main.bounds.width - 30
    var subscriptionViewModel: AttSubscriptionViewModel
    @EnvironmentObject var flowData: AttFlowData
    
    public var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("active_plan_catrd_title".localized()).font(.custom(ApolloSDK.current.getMediumFont(), size: 14)).foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                Spacer()
            }.frame(maxWidth: maxCardWidth)
            VStack {
                Spacer().frame(height: 10)
                HStack {
                    Text(subscriptionViewModel.name).font(.custom(ApolloSDK.current.getBoldFont(), size: 17))
                        .lineLimit(nil).fixedSize(horizontal: false, vertical: true).padding([.leading, .top], 10)
                    Spacer()
                }
              
                if subscriptionViewModel.isUnlimited {
                    RoundedRectangle(cornerRadius: 10).foregroundColor(AttAppTheme.progressBarColor).padding([.leading, .trailing], 8)
                        .frame(height: 4)
                } else {
                    AttProgressBar(value: subscriptionViewModel.used, maxValue: subscriptionViewModel.limit)
                        .frame(height: 4)
                        .padding([.leading, .trailing], 10)
                    
                    HStack {
                        Text(subscriptionViewModel.usage)
                            .font(.custom(ApolloSDK.current.getMediumFont(), size: 12))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        Spacer()
                    }
                    .padding(10)
                }
                HStack {
                    renderAutoRenewDate()
                    Spacer()
                    renderDataPlanType()
                    Spacer()
                }.padding(10)
                Text("dashboard_active_plan_prepaid_note".localized())
                    .font(.custom(ApolloSDK.current.getMediumFont(), size: 13))
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(10)
                    .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                VStack(spacing: 0) {
                    Divider()
                    HStack {
                        renderAutoRenewStatus() 
                        
                        Button(action: { print("question mark button") }, label: {
                            Image(systemName: "questionmark.circle.fill").foregroundColor(AttAppTheme.infoButtonBackgroundColor).font(.system(size: 14)).opacity(0.5)
                        }).contentShape(Rectangle())
                        Spacer()
                        
                    }.padding()
                }
                
            }
            .background(AttAppTheme.attSDKBackgroundColor)
            .cornerRadius(AttAppTheme.attSDKDashboardCardCornerRadius)
            .frame(maxWidth: maxCardWidth)
            .shadow(color: AttAppTheme.shadowColor, radius: AttAppTheme.attSDKDashboardCardShadowElevation, x: 3, y: 3)
            
        }
    }
    
    func renderAutoRenewStatus() -> AnyView {
        let autoRenewText = subscriptionViewModel.autoRenew ? "dashboard_on".localized() : "dashboard_off".localized()
        let color = subscriptionViewModel.autoRenew ? AttAppTheme.successColor : AttAppTheme.errorColor
        return AnyView(Group{
            Text("other_settings_auto_renew".localized()).font(.custom(ApolloSDK.current.getMediumFont(), size: 12)).foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
            Text(autoRenewText).foregroundColor(color).font(.custom(ApolloSDK.current.getBoldFont(), size: 12))
        })
    }
    
    func renderAutoRenewDate() -> AnyView {
        return AnyView(
            VStack(alignment: .leading) {
                Text(subscriptionViewModel.autoRenew ? "renews_in".localized() : "dashboard_expires".localized())
                    .font(.custom(ApolloSDK.current.getMediumFont(), size: 10))
                    .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)

                HStack {
                    Text(subscriptionViewModel.autoRenew ? subscriptionViewModel.autoRenewalDate : subscriptionViewModel.expiresOn)
                        .font(.custom(ApolloSDK.current.getMediumFont(), size: 20))
                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                    Text(subscriptionViewModel.autoRenew ? "days".localized() : "")
                        .foregroundColor(AttAppTheme.attSDKTextSecondaryColor)
                        .font(.custom(ApolloSDK.current.getMediumFont(), size: 16))
                    
                }
            }
        )
    }
    
    func renderDataPlanType() -> AnyView {
        return AnyView(
            VStack(alignment: .leading) {
                Text("data_plan".uppercased().localized())
                    .font(.custom(ApolloSDK.current.getMediumFont(), size: 10))
                
                Text(subscriptionViewModel.planType.capitalized)
                    .font(.custom(ApolloSDK.current.getLightFont(), size: 20))

            }
        )
    }
}

struct ActivePlanCard_Previews: PreviewProvider {
    static var previews: some View {
        AttActivePlanCard(subscriptionViewModel: AttSubscriptionViewModel())
    }
}

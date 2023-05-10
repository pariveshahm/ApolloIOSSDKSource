//
//  PurchaseCompletedView.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/31/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import SwiftUI

public struct AttPurchaseCompletedView: View {
    
    var goToDashboard: () -> Void
    @EnvironmentObject var flowData: AttFlowData
    
    public init(goToDashboard: @escaping () -> Void) {
        self.goToDashboard = goToDashboard
    }

    public var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer().frame(height: 150)
            
            Image("att-logo", bundle: Bundle.resourceBundle)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 80)
            
            Text("thankyou".localized())
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(7)
                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                .font(.custom(ApolloSDK.current.getMediumFont(), size: 16))
                .multilineTextAlignment(.center)
                .padding([.trailing, .leading], 35)
            
            Text("thankyou_data_plan".localized())
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(7)
                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                .font(.custom(ApolloSDK.current.getMediumFont(), size: 16))
                .multilineTextAlignment(.center)
                .padding([.trailing, .leading], 35)

            Spacer()
            
            AttBackgroundShape(height: 150, controlPointY: 210).fill(AttAppTheme.attSDKBackgroundColor).zIndex(-1)

            Button(action: {
                self.goToDashboard()
                AttPaymentsServices.shared.resetCachedData()
                AttPaymentsServices.shared.resetErrorCacheData()
                AttConsentsServices.shared.resetCachedData()
                ApolloSDK.current.clientSessionId = UUID.init().uuidString
                AttDashboardServices.shared.clientSessionId = UUID.init().uuidString
                AttDashboardServices.shared.resetCachedData()
                AttDashboardServices.shared.resetCacheTime()
            }) {
                
                HStack {
                    Spacer()
                    Text("proceed_to_att_wi_fi_dashboard".localized())
                        .font(.custom(ApolloSDK.current.getMediumFont(), size: 15))
                    Spacer()
                    
                }
            }
            .padding([.bottom], 10)
            .padding([.horizontal], 14)
            .buttonStyle(AttPrimaryButtonStyle())
            
            Spacer().frame(height: 16)

        }.background(AttAppTheme.attSDKBackgroundColor)
    }
}

struct PurchaseCompletedView_Previews: PreviewProvider {
    static var previews: some View {
        AttPurchaseCompletedView(goToDashboard: {})
    }
}

//  NoPlanWidget.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 18/01/2021.

import SwiftUI

struct AttNoPlanWidget: View {
    
    // - Properties
    var maxWidth: CGFloat          = 400
    var onPurchase: () -> Void     = { }
    var onDashboard: (() -> Void)? = nil
    var screenType: AttWidgetScreenType
    
    var borderColor: Color {
        return (screenType == .dashboard) ? AttAppTheme.attSDKDashboardWidgetBorderColor : AttAppTheme.attSDKWidgetBorderColor
    }
    
    var borderWidth: CGFloat {
        return AttAppTheme.attSDKDBorderWidth
    }
    
    var shadowRadius: CGFloat {
        return CGFloat((screenType == .dashboard) ? AttAppTheme.attSDKDashboardCardShadowElevation : AttAppTheme.attSDKWidgetCardShadowElevation)
    }
    
    var backgroundColor: Color {
        return (screenType == .dashboard) ? AttAppTheme.attSDKDashboardWidgetBackgroundColor : AttAppTheme.attSDKWidgetBackgroundColor
    }
    
    var cornerRadius: CGFloat {
        return (screenType == .dashboard) ? AttAppTheme.attSDKDashboardCardCornerRadius : AttAppTheme.attSDKWidgetCardCornerRadius
    }
    
    var onWidgetAppeared:   (() -> Void)?
    var body: some View {
        createVStack().onAppear(perform: {
            DispatchQueue.main.async {
                self.onWidgetAppeared?()
            }
        })
    }
    
    private func createVStack() -> AnyView {
        let vStack = VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(Color.yellow)
                .font(.system(size: 25))
            
            Spacer().frame(height: 8)
            
            Text("native_oem_widget_no_data_plan_text".localized())
                .font(.custom(ApolloSDK.current.getBoldFont(), size: 16))
                .foregroundColor(AttAppTheme.attSDKWidgetTextPrimaryColor)
            
            Spacer().frame(height: 20)
            
            if screenType == .dashboard {
                Text("dashboard_no_active_plan_mesage".localized())
                    .font(.custom(ApolloSDK.current.getRegularFont(), size: 13))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
                    .foregroundColor(AttAppTheme.attSDKWidgetTextPrimaryColor)
                
                Spacer().frame(height: 20)
            }
            
            Button("purchase_a_data_plan_button_text".localized(), action: onPurchase)
                .font(.custom(ApolloSDK.current.getBoldFont(), size: 15))
                .buttonStyle(AttPrimaryButtonStyle(height: AttAppTheme.attSDKWidgetButtonHeight,
                                                curvature: AttAppTheme.attSDKWidgetButtonCurvature,
                                                textColor: AttAppTheme.attSDKWidgetPrimaryButtonTextColor,
                                                backgroundColor: AttAppTheme.attSDKWidgetPrimaryButtonColor))
            
            Spacer().frame(height: 8)
            
            if let onDashboard = onDashboard {
                Button("transaction_summary_error_create_vehicle_link_account_dashboard_button".localized(), action: onDashboard)
                    .font(.custom(ApolloSDK.current.getBoldFont(), size: 15))
                    .buttonStyle(AttSecondaryButtonStyle(height: AttAppTheme.attSDKWidgetButtonHeight,
                                                      curvature: AttAppTheme.attSDKWidgetButtonCurvature,
                                                      textColor: AttAppTheme.attSDKWidgetSecondaryButtonTextColor,
                                                      backgroundColor: AttAppTheme.attSDKWidgetSecondaryButtonBackgroundColor,
                                                      borderWidth: AttAppTheme.attSDKWidgetSecondaryButtonBorderWidth,
                                                      borderColor: AttAppTheme.attSDKWidgetSecondaryButtonBorderColor))
            }
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .frame(maxWidth: maxWidth)
        .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(borderColor, lineWidth: borderWidth))
        .shadow(color: AttAppTheme.shadowColor, radius: shadowRadius, x: 0, y: 0)
        
        return AnyView(vStack)
    }
}

struct AttNoPlanWidget_Previews: PreviewProvider {
    static var previews: some View {
        AttNoPlanWidget(screenType: .dashboard)
    }
}

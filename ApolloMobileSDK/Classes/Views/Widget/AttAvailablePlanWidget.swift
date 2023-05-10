//  AvailablePlanWidget.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 18/01/2021.

import SwiftUI

struct AttAvailablePlanWidget: View {
    
    // - Properties
    var maxWidth: CGFloat          = 400
    var onSeePlans: () -> Void     = { }
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
            // - Title
            if screenType == .homePage  {
//                HStack {
//                    Image("att-logo", bundle: .resourceBundle)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(maxWidth: 25)
//                    Text("oem_widget_att_title".localized())
//                        .lineLimit(nil)
//                        .fixedSize(horizontal: false, vertical: true)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .font(.custom(ApolloSDK.current.getBoldFont(), size: 15))
//                        .foregroundColor(AttAppTheme.attSDKWidgetTextPrimaryColor.opacity(0.6))
//                }
//
//                Spacer().frame(height: 16)
            }
            HStack {
                Image("att-logo", bundle: .resourceBundle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 25)

                Text("oem_widget_att_title".localized())
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom(ApolloSDK.current.getBoldFont(), size: 15))
                    .foregroundColor(AttAppTheme.attSDKTextPrimaryColor.opacity(0.6))
            }
            Spacer().frame(height: 16)
            Text("oem_widget_purchase_plan_title".localized())
            
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom(ApolloSDK.current.getBoldFont(), size: 15))
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(AttAppTheme.attSDKWidgetTextPrimaryColor)
            
            Spacer().frame(height: 20)
            
            Button("learn_more_button_text".localized(), action: onSeePlans)
                .font(.custom(ApolloSDK.current.getBoldFont(), size: 15))
                .buttonStyle(AttPrimaryButtonStyle(height: AttAppTheme.attSDKWidgetButtonHeight,
                                                curvature: AttAppTheme.attSDKWidgetButtonCurvature,
                                                textColor: AttAppTheme.attSDKWidgetPrimaryButtonTextColor,
                                                backgroundColor: AttAppTheme.attSDKWidgetPrimaryButtonColor))
            
            Spacer().frame(height: 8)
            
            if let onDashboard = onDashboard {
                Button("account_dashboard_button_text".localized(), action: onDashboard)
                    .font(.custom(ApolloSDK.current.getBoldFont(), size: 15))
                    .buttonStyle(AttSecondaryButtonStyle(height: AttAppTheme.attSDKWidgetButtonHeight,
                                                      curvature: AttAppTheme.attSDKWidgetButtonCurvature,
                                                      textColor: AttAppTheme.attSDKWidgetSecondaryButtonTextColor,
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

struct AttAvailablePlanWidget_Previews: PreviewProvider {
    static var previews: some View {
        AttAvailablePlanWidget(screenType: .dashboard)
    }
}

//  TrialAvailableWidget.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 18/01/2021.

import SwiftUI

struct AttTrialAvailableWidget: View {
    
    // - Properites
    var maxWidth: CGFloat       = 400
    var onLearnMore: () -> Void = { }
    var onWidgetAppeared:   (() -> Void)?
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
    
    var body: some View {
        createVStack().onAppear(perform: {
            DispatchQueue.main.async {
                self.onWidgetAppeared?()
            }
        })
    }
    
    private func createVStack() -> AnyView {
        let vStack = VStack {
            //            // - Title
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
                    .foregroundColor(AttAppTheme.attSDKWidgetTextPrimaryColor.opacity(0.6))
            }
            
            Spacer().frame(height: 16)
            
            Text("oem_widget_get_started_title".localized())
                .font(.custom(ApolloSDK.current.getBoldFont(), size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(AttAppTheme.attSDKWidgetTextPrimaryColor)
            
            Spacer().frame(height: 30)
            
            Button("oem_widget_get_started_button_learn_more".localized(), action: onLearnMore)
                .font(.custom(ApolloSDK.current.getBoldFont(), size: 15))
                .buttonStyle(AttPrimaryButtonStyle(height: AttAppTheme.attSDKWidgetButtonHeight,
                                                curvature: AttAppTheme.attSDKWidgetButtonCurvature,
                                                textColor: AttAppTheme.attSDKWidgetPrimaryButtonTextColor,
                                                backgroundColor: AttAppTheme.attSDKWidgetPrimaryButtonColor))
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

struct AttTrialAvailableWidget_Previews: PreviewProvider {
    static var previews: some View {
        AttTrialAvailableWidget(screenType: .dashboard)
            .padding()
    }
}

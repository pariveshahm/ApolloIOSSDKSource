//  EmptyWidget.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 18/01/2021.

import SwiftUI

public enum AttWidgetScreenType {
    case homePage
    case dashboard
    case orderHistory
    case paymentProfile
}

struct AttEmptyWidget: View {
    
    var maxWidth: CGFloat = 400
    
    var screenType: AttWidgetScreenType
    
    var height: CGFloat  {
        return (screenType == .dashboard || screenType == .homePage) ? 170 : 64
    }

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
    
    
//    private var padding: CGFloat {
//        get {
//            return (2 * ((screenType == .homePage) ? 16.0 : AppTheme.attSDKWidgetHorizontalPadding))
//        }
//    }
//    
//    private var widgetWidth: CGFloat {
//        get {
//            return UIScreen.main.bounds.size.width - padding
//        }
//    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                AttActivityIndicatorSmall()
                Spacer()
            }
        }
        .frame(minHeight: height)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(borderColor, lineWidth: borderWidth))
        .shadow(color: AttAppTheme.shadowColor, radius: shadowRadius, x: 0, y: 0)
    }
}

struct AttEmptyWidget_Previews: PreviewProvider {
    static var previews: some View {
        AttEmptyWidget(screenType: .dashboard)
    }
}

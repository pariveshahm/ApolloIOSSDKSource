//  ErrorWidget.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 18/01/2021

import SwiftUI
import UIKit

let callNumber: String = "1 (866) 595-0020"

struct AttErrorWidget: View {

    // - Properties
    var title:      String
    var message:    String
    var errorCode:  String?
    var onReload:   (() -> Void)?
    var onSupport: (() -> Void)?
    var reloadButtonTitle: String = "oem_widget_error_can_not_load_data_button_retry".localized()
    var contactSupportButtonTitle: String = "contact_support".localized()
    var imageName: String = "exclamationmark.triangle.fill"
    var imageColor: Color = AttAppTheme.errorColor

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
        let vStack = VStack(alignment: .center, spacing: 12) {
            Image(systemName: imageName)
                .foregroundColor(imageColor)
                .font(.system(size:30))

            Text(title)
                .font(.custom(ApolloSDK.current.getBoldFont(), size: 16))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(AttAppTheme.attSDKWidgetTextPrimaryColor)

            let links = AttDisclaimerHelper.getDisclaimerLinks()
            let font = UIFont(name: ApolloSDK.current.getMediumFont(), size: 12.0) ?? UIFont.systemFont(ofSize: 12)
            let textColor = AttAppTheme.attSDKWidgetTextPrimaryColor.uiColor()
            let width = UIScreen.main.bounds.width - 32 - (AttAppTheme.attSDKWidgetHorizontalPadding * 2)

            let height1 = message.height(withConstrainedWidth: width, font: font, textAlignment: .center) + 20

            AttTextView(links: links, text: message, font: font, color: textColor, textAlignment: .center)
                .frame(height: height1)
                .transition(.opacity)
                .padding(.top, -13)

            if let errorCode = errorCode {
                Text(errorCode)
                    .font(.custom(ApolloSDK.current.getMediumFont(), size: 12))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(AttAppTheme.attSDKWidgetTextPrimaryColor)
                    .padding(.top, -13)
            }

            if let reload = onReload {
                Button(reloadButtonTitle, action: reload)
                    .buttonStyle(AttPrimaryButtonStyle(height: AttAppTheme.attSDKWidgetButtonHeight,
                                                    curvature: AttAppTheme.attSDKWidgetButtonCurvature,
                                                    textColor: AttAppTheme.attSDKWidgetPrimaryButtonTextColor,
                                                    backgroundColor: AttAppTheme.attSDKWidgetPrimaryButtonColor))
                    .padding(.top, -2)
            }
            if let support = onSupport {
                Button(contactSupportButtonTitle, action: support)
                    .buttonStyle(AttSecondaryButtonStyle())
                    .padding(.top, -5)
            }

//            if let reload = onReload {
//            Button(contactSupportTitle, action: reload)
//                .buttonStyle(AttSecondaryButtonStyle(height: AttAppTheme.attSDKWidgetButtonHeight,
//                                                curvature: AttAppTheme.attSDKWidgetButtonCurvature,
//                                                textColor: AttAppTheme.attSDKWidgetSecondaryButtonTextColor,
//                                                backgroundColor: AttAppTheme.attSDKWidgetSecondaryButtonBackgroundColor))
//                .padding(.top, 12)
//        }
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(borderColor, lineWidth: borderWidth))
        .shadow(color: AttAppTheme.shadowColor, radius: shadowRadius, x: 0, y: 0)

        return AnyView(vStack)
    }
}

struct AttErrorWidget_Previews: PreviewProvider {
    static var previews: some View {
        AttErrorWidget(
            title: "We can’t seem to load your info right now.",
            message: "Try reloading the page or using the button below. If this doesn't help, you can also contact support at 1 (866) 595-0020 and reference the following error code: 1001.",
            onReload: {},
            onSupport: {},
            screenType: .dashboard,
            onWidgetAppeared: {}
        )
    }
}

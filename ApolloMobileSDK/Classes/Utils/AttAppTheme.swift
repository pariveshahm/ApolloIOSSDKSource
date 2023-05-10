//  AppTheme.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/15/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import SwiftUI

enum AttAppThemeKeys: String {
    case primaryColor
    case attSDKSecondaryButtonBackgroundColor
    case attSDKButtonDisabledBackgroundColor
    case attSDKButtonDisabledTextColor
    case attSDKTextPrimaryColor
    case attSDKTextSecondaryColor
    case attSDKPrimaryButtonTextColor
    case attSDKButtonCurvature
    case attSDKSecondaryButtonTextColor
    case attSDKSecondaryButtonBorderWidth
    case attSDKSecondaryButtonBorderColor
    case attSDKSelectedProductBackgroundColor
    case attSDKDashboardWidgetBackgroundColor
    case attSDKWidgetBackgroundColor
    case attSDKDashboardWidgetBorderColor
    case attSDKBlockBackgroundColor
    case attSDKWidgetBorderColor
    case attSDKButtonHeight
    case attSDKPillButtonHeight
    case attSDKBackgroundColor
    case attSDKDashboardBackgroundColor
    case attSDKDashboardHeaderBackgroundColor
    case attSDKWidgetCardShadowElevation
    case attSDKWidgetButtonHeight
    case attSDKDashboardCardShadowElevation
    case attSDKWidgetCardCornerRadius
    case attSDKDashboardCardCornerRadius
    case attSDKWidgetButtonCurvature
    case attSDKWidgetTextPrimaryColor
    case attSDKWidgetTextSecondaryColor
    case attSDKWidgetPrimaryButtonColor
    case attSDKWidgetPrimaryButtonTextColor
    case attSDKWidgetSecondaryButtonBackgroundColor
    case attSDKWidgetSecondaryButtonTextColor
    case attSDKWidgetSecondaryButtonBorderWidth
    case attSDKWidgetSecondaryButtonBorderColor
    case attSDKWidgetVerticalPadding
    case attSDKWidgetHorizontalPadding
    case attSDKTextColorHint
    
    case errorColor
    case successColor
    case emphasizedTextColor
    case textFieldBorderColor
    case gradientColor1
    case gradientColor2
    case gradientColor3
    case borderColor
    case infoButtonBackgroundColor
    case shadowColor
    case progressBarColor
    case lightTextColor
    case backgroundGradientColor1
    case backgroundGradientColor2
    case lightestTextColor
    case trialButtonColor
    case greenProgressBarColor
    case yellowProgressBarColor
    case redProgressBarColor
}

public struct AttAppTheme {
    
    public static var primaryColor: Color               = Color.white
    public static var attSDKSecondaryButtonBackgroundColor: Color = Color.white
    public static var attSDKTextPrimaryColor: Color               = Color.white
    public static var attSDKTextSecondaryColor: Color             = Color.white
    public static var attSDKPrimaryButtonTextColor: Color         = Color.white
    public static var attSDKSecondaryButtonTextColor: Color       = Color.white
    public static var attSDKButtonCurvature: CGFloat          = 0.0
    public static var attSDKWidgetButtonCurvature: CGFloat    = 0.0
    public static var attSDKSecondaryButtonBorderWidth: CGFloat        = 0.0
    public static var attSDKSecondaryButtonBorderColor: Color     = Color.white
    public static var attSDKDashboardWidgetBackgroundColor: Color   = Color.clear
    public static var attSDKDashboardWidgetBorderColor: Color = Color.white
    public static var attSDKButtonDisabledBackgroundColor: Color  = Color.white
    public static var attSDKButtonDisabledTextColor: Color        = Color.white
    public static var attSDKSelectedProductBackgroundColor: Color = Color.white
    public static var attSDKBlockBackgroundColor: Color        = Color.white
    public static var attSDKWidgetBorderColor: Color = Color.white
    public static var attSDKWidgetBackgroundColor: Color = Color.clear
    public static var attSDKButtonHeight: CGFloat             = 16 // minimum font size
    public static var attSDKWidgetButtonHeight: CGFloat       = 16
    public static var attSDKPillButtonHeight: CGFloat             = 12 // minimum font size
    public static var attSDKBackgroundColor: Color             = Color.white
    public static var attSDKDashboardBackgroundColor: Color             = Color.white
    public static var attSDKDashboardHeaderBackgroundColor: Color = Color.white //Color(hex: "01abee")
    public static var attSDKWidgetCardShadowElevation: CGFloat             = 0.0
    public static var attSDKDashboardCardShadowElevation: CGFloat          = 0.0
    public static var attSDKWidgetCardCornerRadius: CGFloat          = 0.0
    public static var attSDKDashboardCardCornerRadius: CGFloat          = 0.0
    public static var attSDKWidgetTextPrimaryColor: Color          = Color.white
    public static var attSDKWidgetTextSecondaryColor: Color         = Color.white
    public static var attSDKWidgetPrimaryButtonColor: Color         = Color.white
    public static var attSDKWidgetPrimaryButtonTextColor: Color     = Color.white
    public static var attSDKWidgetSecondaryButtonBackgroundColor: Color = Color.white
    public static var attSDKWidgetSecondaryButtonTextColor: Color  = Color.white
    public static var attSDKWidgetSecondaryButtonBorderWidth: CGFloat = 0.0
    public static var attSDKWidgetSecondaryButtonBorderColor: Color  = Color.white
    public static var attSDKDBorderWidth: CGFloat = 1.0
    public static var attSDKWidgetVerticalPadding: CGFloat = 0
    public static var attSDKWidgetHorizontalPadding: CGFloat = 0
    public static var attSDKTextColorHint: Color = Color(hex: "a9a9a9")
    public static var yellowCircleColor: Color                = Color(hex: "#FFBF00")
    public static var greenCircleColor: Color                = Color(hex: "#00FF00")
    public static var attHeaderBackgroundColor: Color                = Color(hex: "#00FF00")
    
    public static var shadowColor: Color                = Color(hex: "929090")
    public static var errorColor: Color                 = Color(hex: "DE1919")
    public static var successColor: Color               = Color(hex: "077603")
    public static var emphasizedTextColor: Color        = Color(hex: "292929")
    public static var textFieldBorderColor: Color       = Color(hex: "D2D2D2")
    public static var textFieldBackgroundColor: Color       = Color.white
    public static var infoButtonBackgroundColor: Color  = Color(hex: "94C6DC")
    public static var progressBarColor: Color           = Color(hex: "71c5e8")
    public static var backgroundGradientColor1: Color   = Color(hex: "0079b1")
    public static var backgroundGradientColor2: Color   = Color(hex: "00c9ff")
    public static var greenProgressBarColor: Color      = Color.green
    public static var yellowProgressBarColor: Color     = Color.yellow
    public static var blueProgressBarColor: Color       = Color(hex: "01abee")
    public static var redProgressBarColor: Color        = Color.red
    public static var entertaintmentBackgroundColor: Color = Color(hex: "#DDE7ED")//.opacity(0.5)
    public static var pillButtonBackgroundColor: Color = Color(hex: "EEEDEF")
    
    public mutating func loadTheme(path: String) {
        var appTheme: NSDictionary?
        appTheme = NSDictionary(contentsOfFile: path)
        
        if let primaryColor = appTheme?[AttAppThemeKeys.primaryColor.rawValue] as? String {
            AttAppTheme.primaryColor = Color(hex: primaryColor)
        }

        if let secondaryButtonBackgroundColor = appTheme?[AttAppThemeKeys.attSDKSecondaryButtonBackgroundColor.rawValue] as? String {
            AttAppTheme.attSDKSecondaryButtonBackgroundColor = Color(hex: secondaryButtonBackgroundColor)
        }
        
        if let textPrimaryColor = appTheme?[AttAppThemeKeys.attSDKTextPrimaryColor.rawValue] as? String {
            AttAppTheme.attSDKTextPrimaryColor = Color(hex: textPrimaryColor)
        }
        
        if let textSecondaryColor = appTheme?[AttAppThemeKeys.attSDKTextSecondaryColor.rawValue] as? String {
            AttAppTheme.attSDKTextSecondaryColor = Color(hex: textSecondaryColor)
        }
        
        if let textPrimaryColor = appTheme?[AttAppThemeKeys.attSDKWidgetTextPrimaryColor.rawValue] as? String {
            AttAppTheme.attSDKWidgetTextPrimaryColor = Color(hex: textPrimaryColor)
        }
        
        if let textColor = appTheme?[AttAppThemeKeys.attSDKPrimaryButtonTextColor.rawValue] as? String {
            AttAppTheme.attSDKPrimaryButtonTextColor = Color(hex: textColor)
        }
        
        if let textColor = appTheme?[AttAppThemeKeys.attSDKSecondaryButtonTextColor.rawValue] as? String {
            AttAppTheme.attSDKSecondaryButtonTextColor = Color(hex: textColor)
        }
        
        if let textColor = appTheme?[AttAppThemeKeys.attSDKWidgetTextSecondaryColor.rawValue] as? String {
            AttAppTheme.attSDKWidgetTextSecondaryColor = Color(hex: textColor)
        }
        
        if let buttonDisabledBackgroundColor = appTheme?[AttAppThemeKeys.attSDKButtonDisabledBackgroundColor.rawValue] as? String {
            AttAppTheme.attSDKButtonDisabledBackgroundColor = Color(hex: buttonDisabledBackgroundColor)
        }
        
        if let buttonDisabledTextColor = appTheme?[AttAppThemeKeys.attSDKButtonDisabledTextColor.rawValue] as? String {
            AttAppTheme.attSDKButtonDisabledTextColor = Color(hex: buttonDisabledTextColor)
        }
        
        if let buttonRadiusValue = appTheme?[AttAppThemeKeys.attSDKButtonCurvature.rawValue] as? CGFloat {
            AttAppTheme.attSDKButtonCurvature = buttonRadiusValue
        }
        
        if let buttonRadiusValue = appTheme?[AttAppThemeKeys.attSDKWidgetButtonCurvature.rawValue] as? CGFloat {
            AttAppTheme.attSDKWidgetButtonCurvature = buttonRadiusValue
        }
        
        if let secondaryButtonBorderWidth = appTheme?[AttAppThemeKeys.attSDKSecondaryButtonBorderWidth.rawValue] as? CGFloat {
            AttAppTheme.attSDKSecondaryButtonBorderWidth = secondaryButtonBorderWidth
        }
        
        if let secondaryButtonBorderWidth = appTheme?[AttAppThemeKeys.attSDKWidgetSecondaryButtonBorderWidth.rawValue] as? CGFloat {
            AttAppTheme.attSDKWidgetSecondaryButtonBorderWidth = secondaryButtonBorderWidth
        }
        
        if let secondaryButtonBorderColor = appTheme?[AttAppThemeKeys.attSDKSecondaryButtonBorderColor.rawValue] as? String {
            AttAppTheme.attSDKSecondaryButtonBorderColor = Color(hex: secondaryButtonBorderColor)
        }

        if let secondaryButtonBorderColor = appTheme?[AttAppThemeKeys.attSDKWidgetSecondaryButtonBorderColor.rawValue] as? String {
            AttAppTheme.attSDKWidgetSecondaryButtonBorderColor = Color(hex: secondaryButtonBorderColor)
        }
        
        if let selectedProductBackgroundColor = appTheme?[AttAppThemeKeys.attSDKSelectedProductBackgroundColor.rawValue] as? String {
            AttAppTheme.attSDKSelectedProductBackgroundColor = Color(hex: selectedProductBackgroundColor)
        }
        
        if let selectedProductBackgroundColor = appTheme?[AttAppThemeKeys.attSDKDashboardWidgetBackgroundColor.rawValue] as? String {
            AttAppTheme.attSDKDashboardWidgetBackgroundColor = Color(hex: selectedProductBackgroundColor)
        }
        
        if let blockBorderColor = appTheme?[AttAppThemeKeys.attSDKDashboardWidgetBorderColor.rawValue] as? String {
            AttAppTheme.attSDKDashboardWidgetBorderColor = Color(hex: blockBorderColor)
        }
        
        if let blockBackgroundColor = appTheme?[AttAppThemeKeys.attSDKBlockBackgroundColor.rawValue] as? String {
            AttAppTheme.attSDKBlockBackgroundColor = Color(hex: blockBackgroundColor)
        }
        
        if let blockBorderColor = appTheme?[AttAppThemeKeys.attSDKWidgetBorderColor.rawValue] as? String {
            AttAppTheme.attSDKWidgetBorderColor = Color(hex: blockBorderColor)
        }
        
        if let blockBorderColor = appTheme?[AttAppThemeKeys.attSDKBackgroundColor.rawValue] as? String {
            AttAppTheme.attSDKBackgroundColor = Color(hex: blockBorderColor)
        }
        
        if let blockBorderColor = appTheme?[AttAppThemeKeys.attSDKDashboardBackgroundColor.rawValue] as? String {
            AttAppTheme.attSDKDashboardBackgroundColor = Color(hex: blockBorderColor)
        }
        
        if let blockBorderColor = appTheme?[AttAppThemeKeys.attSDKDashboardHeaderBackgroundColor.rawValue] as? String {
            AttAppTheme.attSDKDashboardHeaderBackgroundColor = Color(hex: blockBorderColor)
        }
        
        if let attSDKWidgetShadow = appTheme?[AttAppThemeKeys.attSDKWidgetCardShadowElevation.rawValue] as? CGFloat {
            AttAppTheme.attSDKWidgetCardShadowElevation = attSDKWidgetShadow
        }
        
        if let attSDKWidgetShadow = appTheme?[AttAppThemeKeys.attSDKDashboardCardShadowElevation.rawValue] as? CGFloat {
            AttAppTheme.attSDKDashboardCardShadowElevation = attSDKWidgetShadow
        }
        
        if let selectedProductBackgroundColor = appTheme?[AttAppThemeKeys.attSDKWidgetBackgroundColor.rawValue] as? String {
            AttAppTheme.attSDKWidgetBackgroundColor = Color(hex: selectedProductBackgroundColor)
        }
        
        if let attSDKWidgetCardCornerRadius = appTheme?[AttAppThemeKeys.attSDKWidgetCardCornerRadius.rawValue] as? CGFloat {
            AttAppTheme.attSDKWidgetCardCornerRadius = attSDKWidgetCardCornerRadius
        }
        
        if let attSDKDashboardCardCornerRadius = appTheme?[AttAppThemeKeys.attSDKDashboardCardCornerRadius.rawValue] as? CGFloat {
            AttAppTheme.attSDKDashboardCardCornerRadius = attSDKDashboardCardCornerRadius
        }
        
        if let primaryColor = appTheme?[AttAppThemeKeys.attSDKWidgetPrimaryButtonColor.rawValue] as? String {
            AttAppTheme.attSDKWidgetPrimaryButtonColor = Color(hex: primaryColor)
        }
        
        if let primaryColor = appTheme?[AttAppThemeKeys.attSDKWidgetPrimaryButtonTextColor.rawValue] as? String {
            AttAppTheme.attSDKWidgetPrimaryButtonTextColor = Color(hex: primaryColor)
        }
        
        if let primaryColor = appTheme?[AttAppThemeKeys.attSDKWidgetSecondaryButtonBackgroundColor.rawValue] as? String {
            AttAppTheme.attSDKWidgetSecondaryButtonBackgroundColor = Color(hex: primaryColor)
        }
        
        if let primaryColor = appTheme?[AttAppThemeKeys.attSDKWidgetSecondaryButtonTextColor.rawValue] as? String {
            AttAppTheme.attSDKWidgetSecondaryButtonTextColor = Color(hex: primaryColor)
        }
        
        if let buttonHeight = appTheme?[AttAppThemeKeys.attSDKButtonHeight.rawValue] as? CGFloat {
            if (buttonHeight > AttAppTheme.attSDKButtonHeight) {
                AttAppTheme.attSDKButtonHeight = buttonHeight
            }
        }
        
        if let buttonHeight = appTheme?[AttAppThemeKeys.attSDKPillButtonHeight.rawValue] as? CGFloat {
            if (buttonHeight > AttAppTheme.attSDKPillButtonHeight) {
                AttAppTheme.attSDKPillButtonHeight = buttonHeight
            }
        }
        
        if let buttonHeight = appTheme?[AttAppThemeKeys.attSDKWidgetButtonHeight.rawValue] as? CGFloat {
            if (buttonHeight > AttAppTheme.attSDKWidgetButtonHeight) {
                AttAppTheme.attSDKWidgetButtonHeight = buttonHeight
            }
        }
        
        if let padding = appTheme?[AttAppThemeKeys.attSDKWidgetVerticalPadding.rawValue] as? CGFloat {
            AttAppTheme.attSDKWidgetVerticalPadding = padding
        }
        
        if let padding = appTheme?[AttAppThemeKeys.attSDKWidgetHorizontalPadding.rawValue] as? CGFloat {
            AttAppTheme.attSDKWidgetHorizontalPadding = padding
        }
        
        if let hintColor = appTheme?[AttAppThemeKeys.attSDKTextColorHint.rawValue] as? String {
            AttAppTheme.attSDKTextColorHint = Color(hex: hintColor)
        }
        
        DispatchQueue.main.async {
            if AttAppTheme().isDarkTheme() {
                AttAppTheme.shadowColor = .clear
                AttAppTheme.attSDKDBorderWidth = 1
                AttAppTheme.textFieldBackgroundColor = AttAppTheme.attSDKBackgroundColor
            } else {
                AttAppTheme.attSDKDBorderWidth = 0
                AttAppTheme.shadowColor = Color(hex: "929090")
                AttAppTheme.textFieldBackgroundColor = .white
            }
        }
    }
    
    func isDarkTheme() -> Bool {
        let vc = UIViewController()
        if vc.traitCollection.userInterfaceStyle == .dark {
            /// Return Dark Mode file name
            return true
        } else {
            /// Return Light Mode file name
            return false
        }
    }
    
    public static func checkIsDarkTheme() -> Bool {
        let vc = UIViewController()
        if vc.traitCollection.userInterfaceStyle == .dark {
            /// Return Dark Mode file name
            return true
        } else {
            /// Return Light Mode file name
            return false
        }
    }
}

public extension String {
    
    func localized() -> String {
        let path = Bundle.languagePath
        let bundle = Bundle(url: URL(fileURLWithPath: path))!
        let string = NSLocalizedString(self, tableName: nil, bundle: bundle, value: self, comment: "")
        return string
    }
}

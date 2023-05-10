//  Button.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/17/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import SwiftUI

public struct AttPrimaryButtonStyle: ButtonStyle {
    
    var buttonHeight: CGFloat
    var buttonCurvature: CGFloat
    var textColor: Color
    var backgroundColor: Color
    
    public init(height: CGFloat = AttAppTheme.attSDKButtonHeight,
                curvature: CGFloat = AttAppTheme.attSDKButtonCurvature,
                textColor: Color = AttAppTheme.attSDKPrimaryButtonTextColor,
                backgroundColor: Color = AttAppTheme.attSDKWidgetPrimaryButtonColor) {
        self.buttonHeight = height
        self.buttonCurvature = curvature
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        AttStyle(buttonHeight: buttonHeight,
              buttonCurvature: buttonCurvature,
              textColor: textColor,
              backgroundColor: backgroundColor,
              config: configuration)
    }
    
    private struct AttStyle: View {
        
        // - State
        @Environment(\.isEnabled)
        private var isEnabled: Bool
        
        var buttonHeight: CGFloat
        var buttonCurvature: CGFloat
        var textColor: Color
        var backgroundColor: Color = AttAppTheme.attSDKWidgetPrimaryButtonColor
        
        // - Props
        let config: ButtonStyle.Configuration
        
        var body: some View {
            config.label
                .multilineTextAlignment(.center)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: buttonHeight)
                .foregroundColor(isEnabled ? textColor : AttAppTheme.attSDKButtonDisabledTextColor)
                .background(isEnabled ? backgroundColor : AttAppTheme.attSDKButtonDisabledBackgroundColor)
                .font(.custom(.medium, size: 16))
                .if(buttonCurvature > 0, content: {
                    $0.cornerRadius(buttonCurvature)
                })
        }
    }
}

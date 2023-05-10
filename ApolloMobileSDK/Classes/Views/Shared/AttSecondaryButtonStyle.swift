//  SecondaryButtonStyle.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/17/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import SwiftUI

public struct AttSecondaryButtonStyle: ButtonStyle {

    var buttonHeight: CGFloat
    var buttonCurvature: CGFloat
    var textColor: Color
    var backgroundColor: Color
    var borderWidth: CGFloat
    var borderColor: Color
    
    public init(height: CGFloat = AttAppTheme.attSDKButtonHeight,
                curvature: CGFloat = AttAppTheme.attSDKButtonCurvature,
                textColor: Color = AttAppTheme.attSDKSecondaryButtonTextColor,
                backgroundColor: Color = AttAppTheme.attSDKSecondaryButtonBackgroundColor,
                borderWidth: CGFloat = AttAppTheme.attSDKSecondaryButtonBorderWidth,
                borderColor: Color = AttAppTheme.attSDKSecondaryButtonBorderColor) {
        self.buttonHeight = height
        self.buttonCurvature = curvature
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        Style(buttonHeight: buttonHeight,
              buttonCurvature: buttonCurvature,
              textColor: textColor,
              backgroundColor: backgroundColor,
              borderWidth: borderWidth,
              borderColor: borderColor,
              config: configuration)
    }
    
    private struct Style: View {
        
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        let buttonHeight: CGFloat
        let buttonCurvature: CGFloat
        let textColor: Color
        let backgroundColor: Color
        var borderWidth: CGFloat
        var borderColor: Color
        let config: ButtonStyle.Configuration
        
        var body: some View {
            config.label
                .multilineTextAlignment(.center)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: buttonHeight)
                .foregroundColor(textColor)
                .background(isEnabled ? backgroundColor : Color(.systemGray4))
                .if(buttonCurvature > 0, content: {
                    $0.cornerRadius(buttonCurvature)
                })
                .if(AttAppTheme.attSDKSecondaryButtonBorderWidth > 0, content: {
                    $0.overlay(RoundedRectangle(cornerRadius: buttonCurvature).stroke(borderColor, lineWidth: borderWidth))
                })
        }
    }
}

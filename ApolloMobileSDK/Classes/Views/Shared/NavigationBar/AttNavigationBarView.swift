//
//  AttNavigationBar.swift
//  ApolloMobileSDK
//
//  Created by Elvis on 4/19/21.
//

import Foundation
import SwiftUI

struct AttNavigationBarView<Content: View, NavigationContent: View>: View {
    var titleText: String
    var titleContent: (() -> NavigationContent)?
    var backgroundColor: Color = AttAppTheme.attSDKDashboardHeaderBackgroundColor
    var headerBacgroundColor: Color = AttAppTheme.attSDKDashboardHeaderBackgroundColor
    
    // - Stored properties
    var font   = Font.custom(ApolloSDK.current.getBoldFont(), size: 17)
    var borderColor = AttAppTheme.textFieldBorderColor
    
    // - Properties
    var contentView: () -> Content
    var onBack: (() -> Void)?
    
    init(titleText: String, backgroundColor: Color, contentView: @escaping () -> Content, onBack: (() -> ())?) {
        self.titleText = titleText
        self.titleContent = nil
        let currentLanguage = Bundle.getPreferredLocale().languageCode?.lowercased()
        if (titleText == "dashboard_title" && currentLanguage == "es") {
            self.font = Font.custom(ApolloSDK.current.getBoldFont(), size: 10)
        }
        self.backgroundColor = backgroundColor
        self.contentView = contentView
        self.onBack = onBack
    }
    
    init(titleContent: @escaping () -> NavigationContent, backgroundColor: Color, contentView: @escaping () -> Content) {
        self.titleText = ""
        self.titleContent = titleContent
        
        let currentLanguage = Bundle.getPreferredLocale().languageCode?.lowercased()
        if (titleText == "dashboard_title" && currentLanguage == "es") {
            self.font = Font.custom(ApolloSDK.current.getBoldFont(), size: 10)
        }
        self.backgroundColor = backgroundColor
        self.contentView = contentView
        self.onBack = nil
    }
    
    // - Body
    var body: some View {
        return
            AnyView(
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                    // safe area for iphone X, 11 ....
                    if UIDevice().hasNotch {
                        HStack{ Spacer() }.frame(height: 44, alignment: .center).background(headerBacgroundColor)
                    } else {
                        HStack{ Spacer() }.frame(height: 20, alignment: .center).background(headerBacgroundColor)
                    }
                    
                    // navigation bar
                    if let titleContent = titleContent {
                        // custom ones for webview
                        titleContent().background(backgroundColor)
                    } else {
                        // default navigationBar with back button
                        defaultNavigationBarContent()
                    }
                        Rectangle()
                            .fill(.gray)
                            .opacity(1)
                            .frame(height: 1)
                            .edgesIgnoringSafeArea(.horizontal)
                            Rectangle()
                                .fill(.gray)
                                .opacity(0.3)
                                .frame(height: 1)
                                .edgesIgnoringSafeArea(.horizontal)
                        Rectangle()
                            .fill(.gray)
                            .opacity(0.1)
                            .frame(height: 1)
                            .edgesIgnoringSafeArea(.horizontal)
                }
                    contentView()
                    
                    Spacer()
                    
//                    if UIDevice().hasNotch {
//                        HStack{ Spacer() }.frame(height: 20, alignment: .center).background(backgroundColor)
//                    }
                    
                }.edgesIgnoringSafeArea([.top, .bottom])
            ).background(backgroundColor)
    }
    
    func defaultNavigationBarContent() -> AnyView {
        return AnyView(
            HStack(spacing: 8) {
                Spacer().frame(width: 8, height: 0, alignment: .center)
                
                // back button
                if let onBack = onBack {
                    Button(action: {
                        onBack()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left") // set image here
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        }
                    }
                }
                
                Image("att-logo", bundle: .resourceBundle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18, alignment: .center)
                    .scaledToFit()
                
                Text(titleText)
                    .font(font)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                
                Spacer()
            }
                .frame(height: 50, alignment: .center)
                .background(headerBacgroundColor)
        )
    }
}

struct AttNavigationBar_Preview: PreviewProvider {
    static var previews: some View {
        AttNavigationBarView<Text, Text>(titleText: "AT&T Wi-fi Dashboard", backgroundColor: Color.red, contentView: {Text("Test")}, onBack: {})
    }
}


extension UIViewController {
    func hideAttNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.navigationBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
    }
    
    func showAttNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
    }
}

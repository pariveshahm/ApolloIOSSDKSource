//  CollapseMenu.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 18/01/2021.

import SwiftUI

struct AttCollapseMenu<Content: View>: View {
    
    // - State
    @State private var expand = false
    var isLoaded: Bool = true
    
    // - Properties
    var title: String
    var footnote: String?
    var content: [Content]
    
    var borderColor: Color {
        return AttAppTheme.attSDKDashboardWidgetBorderColor
    }
    
    var borderWidth: CGFloat {
        return AttAppTheme.attSDKDBorderWidth
    }
    
    var shadowRadius: CGFloat {
        return CGFloat(AttAppTheme.attSDKDashboardCardShadowElevation)
    }
    
    var backgroundColor: Color {
        return AttAppTheme.attSDKBlockBackgroundColor
    }
    
    var cornerRadius: CGFloat {
        return AttAppTheme.attSDKDashboardCardCornerRadius
    }
    
    var body: some View {
        VStack {
            // - Header
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.custom(ApolloSDK.current.getBoldFont(), size: 18))
                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    if let footnote = footnote {
                        Text(footnote)
                            .font(.custom(ApolloSDK.current.getMediumFont(), size: 11))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                            .lineLimit(nil)
                    }
                }
                
                Spacer()
                
                if isLoaded {
                    if !content.isEmpty {
                        Image(systemName: expand ? "chevron.up" : "chevron.down")
                            .foregroundColor(AttAppTheme.primaryColor)
                            .frame(width: 20, height: 20)
                    } else {
                        Image(systemName: "minus")
                            .foregroundColor(AttAppTheme.primaryColor)
                            .frame(width: 20, height: 20)
                    }
                } else {
                    Image(systemName: expand ? "chevron.up" : "chevron.down")
                        .foregroundColor(AttAppTheme.primaryColor)
                        .frame(width: 20, height: 20)
                }
            }
            .background(AttAppTheme.attSDKDashboardWidgetBackgroundColor)
            .onTapGesture { expand.toggle() }
            .padding()
            
            // - Content
            if expand {
                ForEach(content.indices, id: \.self) { index in
                    if index == 0 { Divider() }
                    content[index]
                    Divider()
                }
            }
        }
        .onAppear(perform: {
            UISwitch.appearance().onTintColor = AttAppTheme.attSDKDashboardWidgetBackgroundColor.uiColor()
        })
        
        .background(AttAppTheme.attSDKDashboardWidgetBackgroundColor)
        .cornerRadius(cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(borderColor, lineWidth: borderWidth))
        .shadow(color: AttAppTheme.shadowColor, radius: shadowRadius, x: 0, y: 0)
    }
}

struct AttCollapseMenu_Previews: PreviewProvider {
    @State static var value = false
    
    static var previews: some View {
        AttCollapseMenu(
            title: "order_history_title".localized(),
            content: [
                
                AnyView(
                    VStack {
                        if #available(iOS 14.0, *) {
                            Toggle("other_settings_auto_renew".localized(), isOn: $value)
                                .font(.custom(.medium, size: 13))
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                                .toggleStyle(SwitchToggleStyle(tint: AttAppTheme.primaryColor))
                                .disabled(false)
                        } else {
                            // Fallback on earlier versions
                            Toggle("other_settings_auto_renew".localized(), isOn: $value)
                                .font(.custom(.medium, size: 13))
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                                .disabled(false)
                        }
                        
                        Text("other_settings_auto_renew_body".localized())
                            .font(.custom(.regular, size: 10))
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                    }
                    .padding(.horizontal, 10)
                ),
                
                AnyView(
                    VStack {
                        if #available(iOS 14.0, *) {
                            Toggle("other_settings_marketing_consent".localized(), isOn: $value)
                                .font(.custom(.medium, size: 13))
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                                .toggleStyle(SwitchToggleStyle(tint: AttAppTheme.primaryColor))
                                .disabled(false)
                        } else {
                            // Fallback on earlier versions
                            Toggle("other_settings_marketing_consent".localized(), isOn: $value)
                                .font(.custom(.medium, size: 13))
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                                .disabled(false)
                        }
                        
                        Text("transactionsummary_termsContact".localized())
                            .font(.custom(.regular, size: 10))
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                    }
                    .padding(.horizontal, 10)
                )
                
            ]
        )
        .padding()
    }
}

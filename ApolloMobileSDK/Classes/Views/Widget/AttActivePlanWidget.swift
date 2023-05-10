//  ActivePlanWidget.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 18/01/2021.

import SwiftUI

struct AttActivePlanWidget: View {
    
    // - State
    @Binding
    var model: AttSubscriptionViewModel
    var now = Date()

    // - Properties
    var maxWidth:   CGFloat        = 400
    var onPurchase: () -> Void     = { }
    var onRefresh:  (() -> Void)?
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
            if screenType == .homePage {
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
            }
            
            // - Progress
            Text(model.name)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom(ApolloSDK.current.getBoldFont(), size: 16))
                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
            Spacer().frame(height: 10)
            
            if let cacheDateTime = ApolloSDK.current.cacheTime {
                Text("cache_update".localized() + " " + "\(AttDateUtils.formatCachedTimeString(timeAgo: cacheDateTime))")
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom(ApolloSDK.current.getMediumFont(), size: 12))
                .foregroundColor(AttAppTheme.attSDKWidgetTextSecondaryColor)
            }
            
            if model.usageNotReturned == false {
                AttProgressBar(
                    value: model.progressValue,
                    maxValue: model.progressMaxValue,
                    shouldShowProgress: !model.isUnlimited && !model.usageNotReturned,
                    shouldShowError: model.usageNotReturned || model.hasUsedAllTheData
                ).frame(height: 5)
                
                Spacer().frame(height: 16)
                
                // - Labels
                HStack {
                    if model.isUnlimited == false {
                        VStack(alignment: .leading) {
                            Text(model.usageNotReturned ? "widget_error_getting_data".localized() : model.usage)
                                .font(.custom(ApolloSDK.current.getRegularFont(), size: 20))
                                .foregroundColor((model.hasUsedAllTheData || model.usageNotReturned) ? AttAppTheme.errorColor : AttAppTheme.attSDKTextPrimaryColor)
                            Text("data_used".localized())
                                .font(.custom(ApolloSDK.current.getRegularFont(), size: 10))
                                .foregroundColor(AttAppTheme.attSDKWidgetTextSecondaryColor)
                        }
                    }
                    
                    Spacer()
                    
                    if model.hasEndDate {
                        
                        VStack(alignment: .trailing) {
                            Text(model.autoRenew ? "renews".localized() : "expires".localized())
                                .font(.custom(ApolloSDK.current.getRegularFont(), size: 20))
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                            
                            Text("\("on".localized())\(model.autoRenew ? model.autoRenewalDate : model.expiresOn)")
                                .font(.custom(ApolloSDK.current.getRegularFont(), size: 10))
                                .foregroundColor(AttAppTheme.attSDKWidgetTextSecondaryColor)
                        }
                    }
                }
                
            }
            // - Disclaimer
            if (screenType == .dashboard || model.usageNotReturned), let disclamer = model.disclamerText {
                Spacer().frame(height: 20)
                
                Text(disclamer)
                    .font(.custom(ApolloSDK.current.getRegularFont(), size: 13))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
            }
            
            Spacer().frame(height: 20)
            
            // - Actions
            VStack(spacing: 8) {
                Button("purchase_a_data_plan".localized(), action: onPurchase)
                    .font(.custom(ApolloSDK.current.getBoldFont(), size: 15))
                    .buttonStyle(AttPrimaryButtonStyle(height: AttAppTheme.attSDKWidgetButtonHeight,
                                                    curvature: AttAppTheme.attSDKWidgetButtonCurvature,
                                                    textColor: AttAppTheme.attSDKWidgetPrimaryButtonTextColor,
                                                    backgroundColor: AttAppTheme.attSDKWidgetPrimaryButtonColor))
                
                if !model.usageNotReturned, let onDashboard = onDashboard {
                    Button("account_dashboard_button_text".localized(), action: onDashboard)
                        .font(.custom(ApolloSDK.current.getBoldFont(), size: 15))
                        .buttonStyle(AttSecondaryButtonStyle(height: AttAppTheme.attSDKWidgetButtonHeight,
                                                          curvature: AttAppTheme.attSDKWidgetButtonCurvature,
                                                          textColor: AttAppTheme.attSDKWidgetSecondaryButtonTextColor,
                                                          borderWidth: AttAppTheme.attSDKWidgetSecondaryButtonBorderWidth,
                                                          borderColor: AttAppTheme.attSDKWidgetSecondaryButtonBorderColor))
                }
                
                if model.usageNotReturned, let onRefresh = onRefresh {
                    Button("refresh".localized(), action: onRefresh)
                        .font(.custom(ApolloSDK.current.getBoldFont(), size: 15))
                        .buttonStyle(AttSecondaryButtonStyle(height: AttAppTheme.attSDKWidgetButtonHeight,
                                                          curvature: AttAppTheme.attSDKWidgetButtonCurvature,
                                                          textColor: AttAppTheme.attSDKWidgetSecondaryButtonTextColor,
                                                          backgroundColor: AttAppTheme.attSDKWidgetSecondaryButtonBackgroundColor,
                                                          borderWidth: AttAppTheme.attSDKWidgetSecondaryButtonBorderWidth,
                                                          borderColor: AttAppTheme.attSDKWidgetSecondaryButtonBorderColor))
                }
            }
        }
            .padding()
            .background(AttAppTheme.attSDKDashboardWidgetBackgroundColor)
            .cornerRadius(cornerRadius)
            .frame(maxWidth: maxWidth)
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(borderColor, lineWidth: borderWidth))
            .shadow(color: AttAppTheme.shadowColor, radius: shadowRadius, x: 0, y: 0)
        
        return AnyView(vStack)
    }
}

struct AttActivePlanWidget_Previews: PreviewProvider {
    private static var model = AttSubscriptionViewModel(
        name: "3 GB data plan",
        autoRenewalDate: "23/09/2021",
        planType: "Trial",
        expiresOn: "12/04/2020",
        usage: "2.5 of 3GB",
        limit: 3.0,
        used: 0.5,
        autoRenew: false,
        isUnlimited: false,
        hasUsedAllTheData: false,
        usageNotReturned: false
    )
    
    static var previews: some View {
        AttActivePlanWidget(model: .constant(model), screenType: .dashboard)
    }
}

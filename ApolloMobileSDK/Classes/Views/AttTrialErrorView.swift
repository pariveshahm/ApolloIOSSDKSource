//
//  AttTrialErrorView.swift
//  ApolloMobileSDK
//
//  Created by Nermin Sabanovic on 13. 9. 2022..
//

import SwiftUI

public struct AttTrialErrorView<Content: View>: View {
    
    var showContact: Bool      = false
    var retryTitle:  String    = "dashboard_retry".localized()
    var exitTitle:   String    = "back".localized()
    var onRetry: (() -> Void)? = nil
    var onBack:  (() -> Void)? = nil
    let contentView: Content
    
    public var body: some View {
        AttNavigationBarNoLogo<AnyView, AnyView>(titleText: "", backgroundColor: AttAppTheme.attSDKBackgroundColor, contentView: {
            AnyView(
                VStack {
                    Spacer()
                    
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(AttAppTheme.errorColor)
                        .font(.system(size: 50))
                        .padding(.bottom, 10)
                    
                    contentView
                    
                    Spacer()
                    
                    if showContact {
                        Text("transaction_summary_trial_error_have_questions".localized())
                            .font(.custom(ApolloSDK.current.getBoldFont(), size: 15))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        
                        Text("transaction_summary_trial_error_please_contact_support".localized())
                            .font(.custom(ApolloSDK.current.getMediumFont(), size: 11))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        
                        Spacer().frame(height: 8)
                        
                        Button("1 (866) 595-0020") {
                            let number = "tel://18665950020"
                            guard let url = URL(string: number) else { return }
                            UIApplication.shared.open(url)
                        }
                        .font(.custom(ApolloSDK.current.getMediumFont(), size: 15))
                        .foregroundColor(AttAppTheme.primaryColor)
                        
                        Spacer().frame(height: 32)
                    }
                    
                    if let onRetry = self.onRetry {
                        Button(retryTitle, action: onRetry)
                            .buttonStyle(AttPrimaryButtonStyle())
                        
                        Spacer().frame(height: 8)
                    }
                    
                    if let onBack = self.onBack {
                        Button(exitTitle, action: onBack)
                            .buttonStyle(AttSecondaryButtonStyle())
                    }
                }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding([.bottom, .horizontal], 20)
                    .background(AttAppTheme.attSDKBackgroundColor)
                )
        }, onBack: nil)
                                               }
    }

struct AttTrialErrorView_Previews: PreviewProvider {
    static var previews: some View {
        AttTrialErrorView(
            showContact: true,
            onRetry: {},
            onBack: {},
            contentView: EmptyView()
        )
    }
}

//  ErrorView.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 4/2/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import SwiftUI

public struct AttErrorView<Content: View>: View {
    
    var showContact: Bool      = false
    var retryTitle:  String    = "dashboard_retry".localized()
    var exitTitle:   String    = "back".localized()
    var onRetry: (() -> Void)? = nil
    var onExit:  (() -> Void)? = nil
    var exitFromSdk: (() -> Void)? = nil
    let contentView: Content
    
    public var body: some View {
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
            
            if let onExit = self.onExit {
                Button(exitTitle, action: onExit)
                    .buttonStyle(AttSecondaryButtonStyle())
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding([.bottom, .horizontal], 20)
        .background(AttAppTheme.attSDKBackgroundColor)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        AttErrorView(
            showContact: true,
            onRetry: {},
            onExit: {},
            exitFromSdk: {},
            contentView: EmptyView()
        )
    }
}

//  Dialog.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 30/12/2020.

import SwiftUI

struct AttDialog: View {
    
    // - State
    @Binding var open: Bool
    
    // - Properties
    var title: String?          = nil
    var exitTitle: String?      = nil
    var message1: String?        = nil
    var acceptBtnTitle: String? = nil
    var message2: String?        = nil
    var cancelBtnTitle: String? = nil
    var onAccept: (() -> Void)? = nil
    var onCancel: (() -> Void)? = nil
    var messageAlignment: TextAlignment = .center
    
    var body: some View {
        ZStack {
            
            Color.black.opacity(0.7)
            
            GeometryReader() { proxy in
                VStack {
                    Button(action: { open.toggle() }) {
                        if let exitTitle = exitTitle {
                            Text(exitTitle)
                                .font(.custom(.bold, size: 16))
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "xmark")
                            .resizable()
                            .foregroundColor(AttAppTheme.primaryColor)
                            .font(.system(size: 11, weight: .light))
                            .frame(width: 15, height: 15)
                    }
                    
                    if let title = title {
                        Text(title)
                            .font(.custom(ApolloSDK.current.getMediumFont(), size: 18))
                            .padding(.bottom, 10)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                    }
                    
                    // first text
                    if let message = message1 {
                        Text(message)
                            .font(.custom(ApolloSDK.current.getMediumFont(), size: 16))
                            .multilineTextAlignment(messageAlignment)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                    }
                    
                    Spacer().frame(height: 8)
                    
                    // second text
                    if let message = message2 {
                        Text(message)
                            .font(.custom(ApolloSDK.current.getMediumFont(), size: 16))
                            .multilineTextAlignment(messageAlignment)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                    }
                    Spacer(minLength: 16).frame(maxHeight: 32)
                    
                    // first button
                    if let onAccept = onAccept {
                        Button(acceptBtnTitle ?? "confirm".localized(), action: onAccept)
                            .buttonStyle(AttPrimaryButtonStyle())
                    }
                    
                    Spacer().frame(height: 8)
                    
                    // second button
                    if let onCancel = onCancel {
                        Button(cancelBtnTitle ?? "cancel_service_modal_cancel".localized(), action: onCancel)
                            .buttonStyle(AttSecondaryButtonStyle())
                    }
                }
                .padding()
                .frame(width: proxy.size.width - 32)
                .background(AttAppTheme.attSDKBlockBackgroundColor)
                .cornerRadius(8)
                .position(x: proxy.frame(in: .local).midX, y: proxy.frame(in: .local).midY)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
}

struct AttDialog_Previews: PreviewProvider {
    static var previews: some View {
        AttDialog(
            open: .constant(true),
            title: "Share your information with AT&T?",
            message1: "\(ApolloSDK.current.getTenantString()) can prepopulate your AT&T mobility account with name, address, email address and mobile phone number (if available) from your \(ApolloSDK.current.getHostName()) account.​",
            message2: "By proceeding, your information will be shared with AT&T to create and manage your AT&T Mobility account. AT&T will also share your subscription status with \(ApolloSDK.current.getHostName()) for administration purposes if you activate a free trial or purchase a data plan.",
            onAccept: {},
            onCancel: {}
        )
    }
}

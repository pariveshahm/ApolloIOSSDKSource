//  CancelSubscriptionView.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 20/01/2021.

import SwiftUI

struct AttCancelSubscriptionView: View {
    
    @Binding var open: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                //TEST
                VStack {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 25))
                            .padding(.vertical, 10)
                            .padding(.leading, 10)
                        
                        Text("cancel_service_modal_title".localized())
                            .foregroundColor(.yellow)
                            .font(.custom(ApolloSDK.current.getMediumFont(), size: 20))
                        
                        Spacer()
                        
                        Button(action: { open.toggle() }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .foregroundColor(AttAppTheme.primaryColor)
                                .font(.system(size: 11, weight: .light))
                                .frame(width: 15, height: 15)
                                .padding()
                        }
                    }
                    
                    Text("cancel_service_modal_text".localized())
                        .font(.custom(ApolloSDK.current.getMediumFont(), size: 16))
                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .onTapGesture {
                            let number = "tel://18665950020"
                            guard let url = URL(string: number) else { return }
                            UIApplication.shared.open(url)
                        }
                    
                    
                    Spacer().frame(height: 32)
                    Divider().padding(.horizontal)
                    
                    Button("share_information_registration_dialog_close_button".localized(), action: { open.toggle() })
                        .font(.custom(ApolloSDK.current.getMediumFont(), size: 16))
                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        .padding()
                    
                    Spacer().frame(height: 16)
                }
                .frame(maxWidth: .infinity)
                .background(AttAppTheme.attSDKBlockBackgroundColor)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct AttCancelSubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        AttCancelSubscriptionView(open: .constant(true))
    }
}

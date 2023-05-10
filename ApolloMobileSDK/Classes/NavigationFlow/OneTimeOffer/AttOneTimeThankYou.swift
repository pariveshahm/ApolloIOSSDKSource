//  OneTimeThankYou.swift
//  ApolloMobileSDK
//
//  Created by Shak4l on 15/02/2021.

import SwiftUI

struct AttOneTimeThankYou: View {
    
    var onContinue: () -> Void
    
    var body: some View {
        ZStack {
            AttBackgroundShape()
                .fill(AttAppTheme.attSDKBackgroundColor)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Spacer()
                
                Image("att-logo", bundle: .resourceBundle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 55)
                    .padding()
                
                Text("thankyou".localized())
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(7)
                    .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                    .font(.custom(.medium, size: 16))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 35)
                    .padding(.bottom, 64)
                
                Spacer()
                
                Button("proceed_to_att_wi_fi_dashboard".localized(), action: onContinue)
                    .buttonStyle(AttPrimaryButtonStyle())
                    .padding()
                
                Spacer().frame(height: 16)
            }.background(AttAppTheme.attSDKBackgroundColor).navigationBarHidden(true)
        }
    }
}

struct OneTimeThankYou_Previews: PreviewProvider {
    static var previews: some View {
        AttOneTimeThankYou(onContinue: { })
    }
}

//
//  ContentView.swift
//  FCAExample
//
//  Created by Selma Suvalija on 6/24/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import SwiftUI
import ApolloMobileSDK

struct ContentView: View {
    @State var username: String = ""
    @State var password: String = ""

    var body: some View {
        VStack {
            VStack {
                Image("uconnect").frame(height: 80)
                TextField("enter_email".localized(), text: $username)
                Divider()
                    .frame(height: 1)
                    .padding(.horizontal, 30)
                    .background(AttAppTheme.attSDKBackgroundColor)
                TextField("enter_password".localized(), text: $username)
                Divider()
                    .frame(height: 1)
                    .padding(.horizontal, 30)
                    .background(AttAppTheme.attSDKBackgroundColor)
                
            }
            Spacer()
        }.background(AttAppTheme.primaryColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

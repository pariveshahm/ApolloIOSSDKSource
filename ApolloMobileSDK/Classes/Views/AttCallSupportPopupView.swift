//
//  CallSupportPopup.swift
//  ApolloMobileSDK
//
//  Created by Elvis on 7/16/21.
//

import Foundation
import SwiftUI

struct AttCallSupportPopupView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                
                VStack {
                    createTitle()
                    Divider()
                    createCallItem(number: callNumber)
                    Divider()
                    createHelpDataItem()
                    Divider()
                    
                    Spacer().frame(height: 16)
                    Button("share_information_registration_dialog_close_button".localized(), action: {
                        NotificationCenter.default.post(name: Notification.Name("dismissModal"), object: nil)
                    }).font(.custom(ApolloSDK.current.getMediumFont(), size: 16)).foregroundColor(AttAppTheme.attSDKTextPrimaryColor).padding()
                        .buttonStyle(AttSecondaryButtonStyle())
                    
                    Spacer().frame(height: 20)
                }
                .frame(maxWidth: .infinity)
                .background(AttAppTheme.attSDKBlockBackgroundColor)
            }.edgesIgnoringSafeArea(.bottom)
        }
    }
    
    private func createTitle() -> AnyView {
        return AnyView(
            VStack {
                // - Header
                HStack {
                    VStack(alignment: .leading) {
                        Text("have_questions_title".localized())
                            .font(.custom(ApolloSDK.current.getBoldFont(), size: 18))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("have_questions_contact_support".localized())
                            .font(.custom(ApolloSDK.current.getMediumFont(), size: 11))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                            .lineLimit(nil)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(AttAppTheme.primaryColor)
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            NotificationCenter.default.post(name: Notification.Name("dismissModal"), object: nil)
                        }
                }
                .background(AttAppTheme.attSDKBlockBackgroundColor)
                .padding()
                
            }
            .onAppear(perform: {
                UISwitch.appearance().onTintColor = AttAppTheme.primaryColor.uiColor()
            })
            .background(AttAppTheme.attSDKBlockBackgroundColor)
        )
    }
    
    // - View
    private func createCallItem(number: String) -> AnyView {
        return AnyView(
            Button(action: call ) {
                HStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("have_questions_title_second_line".localized())
                            .font(.custom(.medium, size: 10))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor).opacity(0.7)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(number)
                            .font(.custom(.bold, size: 14))
                            .foregroundColor(AttAppTheme.primaryColor)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                    }.padding().frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    HStack(alignment: .center) {
                        Text("have_questions_tap_to_call".localized())
                            .font(.custom(.regular, size: 12))
                            .foregroundColor(AttAppTheme.primaryColor)
                            .lineLimit(nil)
                            .multilineTextAlignment(.trailing)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(alignment: .trailing)
                        
                        Image("headphones", bundle: Bundle.resourceBundle)
                            // .resizable()
                            .foregroundColor(AttAppTheme.primaryColor)
                            .aspectRatio(contentMode: .fit)
                            .frame(alignment: .trailing)
                            .padding([.trailing])
                    }
                    
                }
            }
            .foregroundColor(.init(.label)).frame(maxWidth: .infinity, maxHeight: 70, alignment: .leading)
        )
    }
    
    private func createHelpDataItem() -> AnyView {
        return AnyView(
            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("have_questions_vehicle_mobile_number".localized())
                            .font(.custom(.medium, size: 10))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor).opacity(0.7)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding([.top])
                        
                        Text(ApolloSDK.current.getMsisdn())
                            .font(.custom(.bold, size: 14))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                    }.padding([.top])
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("have_questions_vehicle_brand".localized())
                            .font(.custom(.medium, size: 10))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor).opacity(0.7)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                        
                        Text(ApolloSDK.current.getTenantString())
                            .font(.custom(.bold, size: 14))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding([.bottom])
                    }.padding([.bottom])
                }.padding()
                .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("have_questions_country".localized())
                            .font(.custom(.medium, size: 10))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor).opacity(0.7)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding([.top])
                        
                        Text(ApolloSDK.current.getCountry().rawValue)
                            .font(.custom(.bold, size: 14))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                    }.padding([.top])
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("have_questions_vin".localized())
                            .font(.custom(.medium, size: 10))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor).opacity(0.7)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(ApolloSDK.current.getVin())
                            .font(.custom(.bold, size: 14))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .padding([.bottom])
                    }.padding([.bottom])
                    
                }.frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
            }
        )
    }
    
    // - Actions
    private func call() {
        let number = "tel://18665950020"
        guard let url = URL(string: number), UIApplication.shared.canOpenURL(url)  else { return }
        UIApplication.shared.open(url)
    }
}

struct CallSupportPopupView_Previews: PreviewProvider {
    static var previews: some View {
        AttCallSupportPopupView()
    }
}

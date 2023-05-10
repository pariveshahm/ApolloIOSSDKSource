//
//  DashboardHelp.swift
//  ApolloMobileSDK
//
//  Created by Elvis on 4/20/21.
//
import SwiftUI

struct AttDashboardHelp: View {
    var body: some View {
        var content: [AnyView] = []
        
        content.append(createCallItem(number: callNumber))
        content.append(createHelpDataItem())
        
        return AttCollapseMenu(
            title: "have_questions_title".localized(),
            footnote: "have_questions_contact_support".localized(),
            content: content
        )
    }
    
    // - View
    private func createCallItem(number: String) -> AnyView {
        return AnyView(
            Button(action: call ) {
                HStack(alignment: .center, spacing: 0) {
                    Image("headphones", bundle: Bundle.resourceBundle)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(AttAppTheme.primaryColor)
                        .aspectRatio(contentMode: .fit)
                        .frame(alignment: .trailing)
                        .padding([.trailing])
                    VStack(alignment: .leading, spacing: 4) {
                        Text("have_questions_title_second_line".localized())
                            .font(.custom(.medium, size: 12))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor).opacity(0.7)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(number)
                            .font(.custom(.bold, size: 14))
                            .foregroundColor(AttAppTheme.primaryColor)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                        
                        
                        HStack(alignment: .center) {
                            Text("have_questions_tap_to_call".localized())
                                .font(.custom(.regular, size: 12))
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor).opacity(0.7)
                                .lineLimit(nil)
                                .multilineTextAlignment(.trailing)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(alignment: .trailing)
                        }
                    }
                }
                .padding(.leading, 16)
                .foregroundColor(.init(.label)).frame(maxWidth: .infinity, maxHeight: 80, alignment: .leading)
            }
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
    // - Actions
    private func call() {
        let number = "tel://18665950020"
        guard let url = URL(string: number), UIApplication.shared.canOpenURL(url)  else { return }
        UIApplication.shared.open(url)
    }
}

struct AttDashboardHelp_Previews: PreviewProvider {
    static var previews: some View {
        AttDashboardHelp().padding()
    }
}

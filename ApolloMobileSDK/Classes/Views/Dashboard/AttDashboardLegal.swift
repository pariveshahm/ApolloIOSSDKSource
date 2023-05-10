//
//  DashboardLegal.swift
//  ApolloMobileSDK
//
//  Created by Elvis on 4/20/21.
//

import SwiftUI

private struct AttLegalLink {
    let name: String
    let url: String
}

struct AttDashboardLegal: View {
    
    var onBack: () -> Void
    
    var body: some View {
        AttNavigationBarView<AnyView, AnyView>(titleText: "legal_and_regulatory_title".localized(), backgroundColor: AttAppTheme.attSDKBackgroundColor, contentView: {
            AnyView(
                Group {
                    legal()
                }
            )
        }, onBack: onBack
                                               
    )}
    private func legal() -> some View {
        VStack {
            HStack {
                Button(action: { openLink(url: "https://www.att.com/legal/terms.attWebsiteTermsOfUse.html") }) {
                    HStack(alignment: .center) {
                        Text("legal_and_regulatory_terms_of_use".localized())
                            .font(.custom(.regular, size: 14))
                            .lineLimit(nil)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .padding([.leading, .trailing])
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        
                        Image("link", bundle: Bundle.resourceBundle)
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 10, alignment: .trailing)
                            .padding(.trailing)
                            .foregroundColor(AttAppTheme.primaryColor)
                    }
                }
                .font(.custom(.medium, size: 14))
                .frame(maxHeight: 50, alignment: .leading)
            }
            Divider()
            HStack {
                Button(action: { openLink(url: "https://about.att.com/csr/home/privacy.html") }) {
                    HStack(alignment: .center) {
                        Text("legal_and_regulatory_privacy_policy".localized())
                            .font(.custom(.regular, size: 14))
                            .lineLimit(nil)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .padding([.leading, .trailing])
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        
                        Image("link", bundle: Bundle.resourceBundle)
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 10, alignment: .trailing)
                            .padding(.trailing)
                            .foregroundColor(AttAppTheme.primaryColor)
                    }
                }
                .font(.custom(.medium, size: 14))
                .frame(maxHeight: 50, alignment: .leading)
            }
            Divider()
            HStack {
                Button(action: { openLink(url: "https://about.att.com/sites/broadband") }) {
                    HStack(alignment: .center) {
                        Text("legal_and_regulatory_broadband_details".localized())
                            .font(.custom(.regular, size: 14))
                            .lineLimit(nil)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .padding([.leading, .trailing])
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        
                        Image("link", bundle: Bundle.resourceBundle)
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 10, alignment: .trailing)
                            .padding(.trailing)
                            .foregroundColor(AttAppTheme.primaryColor)
                    }
                }
                .font(.custom(.medium, size: 14))
                .frame(maxHeight: 50, alignment: .leading)
            }
            Divider()
            HStack {
                Button(action: { openLink(url: "https://about.att.com/csr/home/privacy/full_privacy_policy.html#choice") }) {
                    HStack(alignment: .center) {
                        Text("legal_and_regulatory_advertising_choices".localized())
                            .font(.custom(.regular, size: 14))
                            .lineLimit(nil)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .padding([.leading, .trailing])
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        
                        Image("link", bundle: Bundle.resourceBundle)
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 10, alignment: .trailing)
                            .padding(.trailing)
                            .foregroundColor(AttAppTheme.primaryColor)
                    }
                }
                .font(.custom(.medium, size: 14))
                .frame(maxHeight: 50, alignment: .leading)
            }
            Divider()
            HStack {
                Button(action: { openLink(url: "https://about.att.com/sites/accessibility") }) {
                    HStack(alignment: .center) {
                        Text("legal_and_regulatory_accessibility".localized())
                            .font(.custom(.regular, size: 14))
                            .lineLimit(nil)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .padding([.leading, .trailing])
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        
                        Image("link", bundle: Bundle.resourceBundle)
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 10, alignment: .trailing)
                            .padding(.trailing)
                            .foregroundColor(AttAppTheme.primaryColor)
                    }
                }
                .font(.custom(.medium, size: 14))
                .frame(maxHeight: 50, alignment: .leading)
            }
            Group  {
                Divider()
                HStack {
                    Button(action: { openLink(url: "https://about.att.com/csr/home/privacy/rights_choices.html") }) {
                        HStack(alignment: .center) {
                            Text("legal_and_regulatory_do_not_sell_information".localized())
                                .font(.custom(.regular, size: 14))
                                .lineLimit(nil)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .padding([.leading, .trailing])
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                            
                            Image("link", bundle: Bundle.resourceBundle)
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 10, alignment: .trailing)
                                .padding(.trailing)
                                .foregroundColor(AttAppTheme.primaryColor)
                        }
                    }
                    .font(.custom(.medium, size: 14))
                    .frame(maxHeight: 50, alignment: .leading)
                }
                Divider()
            }
            
        }
    }
    // - Actions
    private func openLink(url link: String) {
        if let url = URL(string: link) {
            UIApplication.shared.open(url)
        }
    }
}


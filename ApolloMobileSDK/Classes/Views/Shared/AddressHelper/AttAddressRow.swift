//  AddressRow.swift
//  ApolloMobileSDK
//
//  Created by Shak4l on 09/02/2021.

import SwiftUI

struct AttAddressRow: View {
    
    // - Statevar isSelected: Bool
    var isSelected: Bool
    
    // - Props
    let address: AttAddress
    let onSelect: () -> Void
    
    var body: some View {
        HStack {
            Text(createLabel(address))
                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                .font(.system(size: 13))
            Spacer()
            Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(isSelected ? .blue : .gray)
        }
        .onTapGesture(perform: onSelect)
        .background(AttAppTheme.attSDKBlockBackgroundColor)
    }
    
    private func createLabel(_ adrs: AttAddress) -> String {
        var label = ""
        label += adrs.line1      != nil ? "\(adrs.line1!) " : ""
        label += adrs.city       != nil ? "\(adrs.city!), " : ""
        label += adrs.postalCode != nil ? "\(adrs.postalCode!), " : ""
        label += adrs.region     != nil ? "\(adrs.region!), " : ""
        label += adrs.region     != nil ? "\(adrs.country!)" : ""
        return label
    }
}

struct AttAddressRow_Previews: PreviewProvider {
    
    static let address = AttAddress(
        line1: "Settler Ave.",
        line2: "",
        postalCode: "53158",
        city: "Windlake",
        region: "WI",
        country: "US"
    )
    
    static var previews: some View {
        AttAddressRow(isSelected: false, address: address, onSelect: { })
    }
}

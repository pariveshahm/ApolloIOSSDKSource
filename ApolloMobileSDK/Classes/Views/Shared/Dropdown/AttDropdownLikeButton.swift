//
//  DropdownLikeButton.swift
//  ATTORMRetailSDK
//
//  Created by Selma Suvalija on 6/4/20.
//

import Foundation
import SwiftUI

struct AttDropdownLikeButton: View {
    @Binding var displayText: String
    @State var label: String
    @State var errorLabel: String = ""
    @Binding var shouldShowDropdown: Bool
    let dropdownCornerRadius: CGFloat = 5
    let buttonHeight: CGFloat = 35
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).foregroundColor(AttAppTheme.emphasizedTextColor)
            Button(action: {
                 self.shouldShowDropdown.toggle()
            }) {
                HStack {
                    Text(displayText)
                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        .font(.custom(ApolloSDK.current.getMediumFont(), size: 15))

                    Spacer()
                    Image(systemName: self.shouldShowDropdown ? "chevron.up" : "chevron.down").foregroundColor(AttAppTheme.primaryColor)
                }
            }
            .padding(.horizontal)
            .contentShape(RoundedRectangle(cornerRadius: dropdownCornerRadius))
            .frame(minWidth: 100, maxWidth: .infinity, minHeight: buttonHeight, maxHeight: buttonHeight)
            .overlay(
                RoundedRectangle(cornerRadius: dropdownCornerRadius)
                    .stroke((errorLabel.isEmpty ? AttAppTheme.textFieldBorderColor : AttAppTheme.errorColor), lineWidth: 1)
            )
        }
    }
}

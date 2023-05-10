//
//  DrodownButton.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/26/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import SwiftUI

struct AttDropdownButton: View, AttFormField {

    @Binding var displayText: String
    @State var label: String
    @State var errorLabel: String = ""
    @State var onSelect: ((_ key: String) -> Void)?
    @State var shouldShowDropdown = false {
        didSet {
            let validationResult = self.isValid()
            self.errorLabel = validationResult .valid ? "": validationResult.errors
        }
    }

    var validators: [AttValidator]
    var options: [AttDropdownOption]
    var buttonHeight: CGFloat = 35
    var dropdownCornerRadius: CGFloat = 5
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).foregroundColor(AttAppTheme.emphasizedTextColor)
            Button(action: { self.shouldShowDropdown.toggle() }) {
                HStack {
                    Text(displayText).foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                    Spacer()
                    Image(systemName: self.shouldShowDropdown ? "chevron.up" : "chevron.down")
                        .foregroundColor(AttAppTheme.primaryColor)
                }
            }
            .padding(.horizontal)
            .contentShape(RoundedRectangle(cornerRadius: dropdownCornerRadius))
            .frame(minWidth: 100, maxWidth: .infinity, minHeight: buttonHeight, maxHeight: buttonHeight)
            .overlay(
                RoundedRectangle(cornerRadius: dropdownCornerRadius)
                    .stroke((errorLabel.isEmpty ? AttAppTheme.textFieldBorderColor : AttAppTheme.errorColor), lineWidth: 1)
            )
            
            VStack {
                if self.shouldShowDropdown {
                    AttDropdown(options: self.options, onSelect: self.onSelect)
                }
            }
            
            Text(errorLabel)
                .foregroundColor(AttAppTheme.errorColor)
                .font(.custom(ApolloSDK.current.getMediumFont(), size: 13))
                .fixedSize(horizontal: false, vertical: true)
            
        }.onAppear() {
            self.onSelect = { key in
                self.displayText = key
                self.shouldShowDropdown = false
            }
        }
    }
    
    func isValid() -> (valid: Bool, errors: String) {
        var valid = true
        var errors = ""
        for validator in self.validators {
            if  !validator.isValid() {
                valid = false
                errors.append(validator.errorMessage)
                errors.append("\n")
            }
        }
        return (valid, errors)
    }
}


struct AttDropDownButton_Preview:  PreviewProvider {
    static var previews: some View {
        AttDropdownButton(
            displayText: .constant("Hello!"),
            label: "World",
            errorLabel: "",
            onSelect: nil,
            shouldShowDropdown: true,
            validators: [],
            options: [
                AttDropdownOption(key: "1", val: "Aloha"),
                AttDropdownOption(key: "2", val: "Marhaba"),
                AttDropdownOption(key: "3", val: "Xiao"),
            ]
        )
    }
}

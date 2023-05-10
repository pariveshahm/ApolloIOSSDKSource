//
//  LebeledTextField.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/27/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import SwiftUI

struct AttLabeledTextField: View, AttFormField {
    
    var validators: [AttValidator]
    @State var label: String
    @State var errorLabel: String = ""
    @Binding var textFieldValue: String
    @State var textFieldStyle = RoundedBorderTextFieldStyle()
    @State var keyboardType: UIKeyboardType = .default
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).foregroundColor(AttAppTheme.emphasizedTextColor)
            TextField("", text: $textFieldValue,  onCommit: {
                let validationResult = self.isValid()
                self.errorLabel = validationResult .valid ? "": validationResult.errors
            })
            .frame(height: 35)
            .font(.custom(ApolloSDK.current.getMediumFont(), size: 15))
            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
            .keyboardType(keyboardType)
            .padding([.leading, .trailing], 10)
            .background(AttAppTheme.textFieldBackgroundColor)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(AttAppTheme.textFieldBorderColor, lineWidth: 1))
            .border((errorLabel.isEmpty ? Color.clear : AttAppTheme.errorColor), width: 1)
            Text(errorLabel).foregroundColor(AttAppTheme.errorColor).font(.custom(ApolloSDK.current.getMediumFont(), size: 13)).fixedSize(horizontal: false, vertical: true)
            
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


struct AttLebeledTextField_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            AttLabeledTextField(validators: [AttNotEmptyValidator(value: .constant("aaaa"))], label: "Credit card", textFieldValue: .constant(""))
            AttLabeledTextField(validators: [AttNotEmptyValidator(value: .constant("aaaa"))], label: "Security number", textFieldValue: .constant(""))
        }
    }
}


//  InputField.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 18/12/2020.

import SwiftUI
import Combine

struct AttInputField: View {
    
    // - State
    @Binding var value: String
    @State private var editing = false
    @State private var pristine = true
    
    // - Properties
    var label       = ""
    var placeholder = ""
    
    var submitError: String?            = nil
    var error:       String?            = nil
    var textType:    UITextContentType? = .none
    var keyType:     UIKeyboardType?    = .none
    var disabled:    Bool               = false
    var uppercased:  Bool               = false
    var textLimit:   Int?               = nil
    
    // - Computed
    private var isError: Bool {
        (error != nil || submitError != nil) && (!pristine || submitError != nil)
    }
    
    private var isDisabled: Bool {
        disabled   //|| textLimit == nil ? false : textLimit! < value.count
    }
    
    var body: some View {
        // Hack for updating pristine value when submit error changes
        if submitError != nil && pristine {
            DispatchQueue.main.async { pristine = false }
        }
        
        return VStack(alignment: .leading) {
            Text(label).font(.subheadline).foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
            
            HStack {
                TextField("",
                          text: $value,
                          onEditingChanged: { isEditing in
                            // Editing was stoped
                            DispatchQueue.main.async {
                                self.editing = isEditing
                                
                                if !isEditing && pristine { pristine = false }
                            }
                            
                            if uppercased { self.value = value.uppercased() }
                            
                          },
                          onCommit: {
                            if pristine { pristine = false }
                          })
                    .onReceive(Just(value)) { text in
                        limitText(textLimit)
                    }
                    .placeholder(when: value.isEmpty ) {
                        Text(placeholder).foregroundColor(AttAppTheme.attSDKTextColorHint).background(AttAppTheme.textFieldBackgroundColor)
                    }
                    .textContentType(textType)
                    .keyboardType(keyType ?? .default)
                    .padding(10)
                    .disabled(isDisabled)
                    .if(disabled == true) {
                        $0.overlay(Color(.black).opacity(0.1))
                    }
                    .autocapitalization(uppercased ? .allCharacters : .none)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(isError ? AttAppTheme.errorColor : AttAppTheme.textFieldBorderColor, lineWidth: 1)
                    )
                    .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                    .background(AttAppTheme.textFieldBackgroundColor)
                
                if [.phonePad, .decimalPad, .numberPad].contains(keyType) && editing {
                    Button("done".localized()) {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        if pristine { pristine = false }
                    }
                    .font(.custom(.medium, size: 14))
                    .padding([.bottom, .top], 2)
                }
            }
            
            if let error = error ?? submitError, !error.isEmpty && (!pristine || submitError != nil) {
                Text(error)
                    .foregroundColor(Color(UIColor.systemRed))
                    .font(.footnote)
                    .padding(.bottom, 2)
            }
        }
    }

    func limitText(_ upper: Int?) {
        if let upper = upper, value.count > upper {
            value = String(value.prefix(upper))
        }
    }
}

struct AttInputField_Previews: PreviewProvider {
    static var previews: some View {
        return AttInputField(
            value: .constant(""),
            label: "Username",
            placeholder: "JohnDoe",
            error: "Oops! This field is required",
            textType: .telephoneNumber,
            keyType: .numberPad,
            textLimit: 10
        )
    }
}

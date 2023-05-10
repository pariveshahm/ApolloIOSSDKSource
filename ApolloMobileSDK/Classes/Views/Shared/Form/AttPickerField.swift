//  PickerField.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 18/12/2020.

import SwiftUI

struct AttPickerField<T: Hashable>: View {
    
    // - State
    @State private var expand = false
    @State private var pristine = true
    private var value: Binding<T>
    
    // - Properties
    var label:       String
    var options:     [T]
    var nameKey:     KeyPath<T, String>
    var placeholder: String?
    var error:       String?
    var submitError: String?
    var disabled:    Bool
    
    // - Computed
    private var isPlaceholder: Bool {
        value.wrappedValue[keyPath: nameKey].hashValue == "".hashValue
    }
    
    private var isError: Bool {
        (error != nil || submitError != nil) && (!pristine || submitError != nil)
    }
    
    // - Actions
    func onExpand() {
        if !disabled { expand = !expand }
    }
    
    // - Init
    init(value: Binding<T>,
         label: String = "",
         options: [T] = [],
         placeholder: String? = nil,
         nameKey: KeyPath<T, String>,
         error: String? = nil,
         submitError: String? = nil,
         disabled: Bool = false,
         pristine: Bool? = nil) {
        
        self.placeholder = placeholder
        self.label = label
        self.options = options
        self.error = error
        self.nameKey = nameKey
        self.submitError = submitError
        self.value = value
        self.disabled = disabled
        self.pristine = pristine ?? true
    }
    
    // - Body
    var body: some View {
        // Hack for updating pristine value when submit error changes
        if submitError != nil && pristine {
            DispatchQueue.main.async { pristine = false }
        }
        
        return VStack(alignment: .leading) {
            Text(label)
                .font(.subheadline)
                .padding(.bottom, 1)
                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
            
            VStack {
                ZStack {
                    Text(isPlaceholder ? placeholder! : value.wrappedValue[keyPath: nameKey])
                        .frame(maxWidth: .infinity,
                               minHeight: 42,
                               alignment: .leading)
                        .padding(.horizontal, 8)
                        .foregroundColor(isPlaceholder ? .gray : AttAppTheme.attSDKTextPrimaryColor)
                    
                    HStack {
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(AttAppTheme.primaryColor)
                            .padding()
                    }
                }
                
                if expand {
                    Picker("", selection: value.onChange({ _ in
                        onExpand()
                        if pristine { pristine = false }
                    })) {
                        if placeholder != nil { Text(placeholder!) }
                        ForEach(options, id: \.self) {
                            Text($0[keyPath: nameKey])
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .labelsHidden()
                }
            }
            .background(AttAppTheme.textFieldBackgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 3).stroke(isError ? AttAppTheme.errorColor : AttAppTheme.textFieldBorderColor, lineWidth: 1)
            )
            .onTapGesture(perform: onExpand)
            .padding([.bottom, .top], 2)
            .disabled(disabled)
            
            if let error = error ?? submitError, !error.isEmpty && (!pristine || submitError != nil) {
                Text(error)
                    .foregroundColor(Color(UIColor.systemRed))
                    .font(.footnote)
                    .padding(.bottom, 2)
            }
        }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            alignment: .leading
        )
    }
}
struct AttPickerField_Previews: PreviewProvider {
    
    @State static var value = ""
    
    static var previews: some View {
        AttPickerField(
            value: $value,
            label: "State",
            options: [
                "Ohio",
                "Wisconsin",
                "New York",
            ], placeholder: "States",
            nameKey: \.self
        )
    }
}

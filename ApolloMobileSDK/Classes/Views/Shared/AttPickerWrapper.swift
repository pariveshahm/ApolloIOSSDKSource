//
//  PickerWrapper.swift
//  ATTORMRetailSDK
//
//  Created by Selma Suvalija on 6/4/20.
//

import SwiftUI

struct AttPickerWrapper: View {
    var options: [String]
    
    @Binding var selectedOption: String
    
    var body: some View {
        Picker("", selection: $selectedOption) {
            ForEach(options.indices, id: \.self) { index in
                Text(self.options[index]).tag(self.options[index])
            }
        }
        .labelsHidden()
        .id("1111")
        .pickerStyle(WheelPickerStyle())
        
    }
}

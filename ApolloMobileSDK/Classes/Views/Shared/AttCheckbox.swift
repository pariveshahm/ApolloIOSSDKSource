//  Checkbox.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/18/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import Foundation
import SwiftUI

struct AttCheckbox<Content: View>: View {
    
    // - State
    @Binding var isChecked: Bool
    
    // - Properties
    var contentView: Content
    
    // - Stored properties
    var font   = Font.custom(ApolloSDK.current.getMediumFont(), size: 13)
    var borderColor = AttAppTheme.textFieldBorderColor
    
    // - Body
    var body: some View {
        HStack(alignment: .top) {
            // - Checkbox
            Button(action: { isChecked.toggle() }) {
                Image(systemName: isChecked ? "checkmark.square": "square")
                    .font(.system(size: 30))
            }
            .foregroundColor(
                isChecked ? AttAppTheme.primaryColor : AttAppTheme.attSDKButtonDisabledBackgroundColor
            )
            
            // - Content
            contentView
        }
    }
}

struct AttCheckbox_Preview: PreviewProvider {
    static var previews: some View {
        AttCheckbox(isChecked: .constant(false),
                 contentView: Text("This is a test text that will be shown with teh checkbox for demonstration purposes."))
    }
}

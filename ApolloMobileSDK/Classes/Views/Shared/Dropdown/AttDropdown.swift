//
//  Dropdown.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/26/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation
import SwiftUI

struct AttDropdown: View {
    var options: [AttDropdownOption]
    var onSelect: ((_ key: String) -> Void)?
    let dropdownCornerRadius: CGFloat = 5

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(self.options, id: \.self) { option in
                AttDropdownOptionElement(val: option.val, key: option.key, onSelect: self.onSelect)
            }
        }

        .background(Color.black)
        .cornerRadius(dropdownCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: dropdownCornerRadius)
                .stroke(AttAppTheme.textFieldBorderColor, lineWidth: 1)
        )
    }
}

//
//  DropdownOptionElement.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/26/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation
import SwiftUI

struct AttDropdownOptionElement: View {
    var val: String
    var key: String
    var onSelect: ((_ key: String) -> Void)?

    var body: some View {
        Button(action: {
            if let onSelect = self.onSelect {
                onSelect(self.key)
            }
        }) {
            Text(self.val).foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 5)
    }
}

//
//  DropdownOption.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/26/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

struct AttDropdownOption: Hashable {
    public static func == (lhs: AttDropdownOption, rhs: AttDropdownOption) -> Bool {
        return lhs.key == rhs.key
    }

    var key: String
    var val: String
}

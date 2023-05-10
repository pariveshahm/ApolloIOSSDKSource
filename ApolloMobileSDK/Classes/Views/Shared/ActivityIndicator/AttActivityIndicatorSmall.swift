//  ActivityIndicator.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 4/2/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import SwiftUI

struct AttActivityIndicatorSmall: View {
    var body: some View {
        ZStack {
            AttLoader()
                .foregroundColor(Color.gray)
                .frame(width: 30, height: 30).zIndex(1)
        }
    }
}
struct AttActivityIndicatorSmall_Previews: PreviewProvider {
    static var previews: some View {
        AttActivityIndicatorSmall()
    }
}

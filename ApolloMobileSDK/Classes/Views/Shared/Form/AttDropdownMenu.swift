//  DropdownMenu.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 19/12/2020.

import SwiftUI

struct AttDropdownMenu: View {
    
    // - Properties
    var label = ""
    var options = [String]()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(label)
                Spacer()
                Image(systemName: "chevron.down").foregroundColor(AttAppTheme.primaryColor)
            }
            
            VStack(alignment: .leading) {
                ForEach(options, id: \.self) {
                    Text($0)
                }
            }.frame(minHeight: 0, maxHeight: 200)
            
        }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            alignment: .leading
        ).padding()
    }
}

struct AttDropdownMenu_Previews: PreviewProvider {
    static var previews: some View {
        AttDropdownMenu(
            label: "States",
            options: [
                "Ohio",
                "Wisconsin",
                "California"
            ]
        )
    }
}

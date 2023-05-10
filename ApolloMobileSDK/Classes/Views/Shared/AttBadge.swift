//  Badge.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 18/01/2021.

import SwiftUI

struct AttBadge: View {
    // - Properties 
    var text: String
    var color: Color
    var textColor: Color
    
    var body: some View {
        Text(text)
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            .background(color)
            .clipShape(Capsule())
            .font(.custom(ApolloSDK.current.getBoldFont(), size: 12))
            .foregroundColor(textColor)
    }
}

struct AttBadge_Previews: PreviewProvider {
    static var previews: some View {
        AttBadge(text: "Hello world", color: .red, textColor: .white)
    }
}

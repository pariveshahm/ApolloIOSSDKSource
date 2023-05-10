//  HyperLink.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 15/01/2021.

import SwiftUI

struct AttHyperLink: View {
    
    // - State
    @State
    private var open = false
    
    // - Properties
    var text: String
    var link: URL
    var type: LinkType = .url
    
    var font: Font = .body
    var color: Color = AttAppTheme.primaryColor
    
    var body: some View {
        Text(text)
            .font(font)
            .foregroundColor(color)
            .onTapGesture(perform: {
                if #available(iOS 14, *), type == .url {
                    open.toggle()
                } else {
                    UIApplication.shared.open(link)
                }
            })
            .sheet(isPresented: $open, content: { AttSafariView(url: link) })
    }
}

enum LinkType {
    case url
    case number
}

struct AttLinkText_Previews: PreviewProvider {
    static var previews: some View {
        AttHyperLink(text: "Google", link: URL(string: "https://google.com")!)
    }
}

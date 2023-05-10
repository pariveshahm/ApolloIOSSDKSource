//
//  ExpandableSection.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/17/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import SwiftUI

struct AttExpandableSection: View {
    
    @State var showContent = false
    @State var showDivider = false
    @State var rotation: Double = 0
    @State var text: String
    @State var links: [LinkObject]
    @State var titleFont: Font = Font.custom(ApolloSDK.current.getMediumFont(), size: 15)
    
    var title = "title"
    var contentColor: Color
    
    var disclaimerHeight: CGFloat = 0
    let chevron: some View = Image(systemName: "chevron.down").font(.system(size: 12, weight: .bold))
    let content = Text("Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet \nLorem ipsum dolor sit amet Lorem ipsum dolor sit amet \nLorem ipsum dolor sit amet Lorem ipsum dolor sit amet")
        .font(.custom(ApolloSDK.current.getMediumFont(), size: 15))
        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(titleFont)
                    .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                
                Spacer()
                chevron
                    .foregroundColor(AttAppTheme.primaryColor)
                    .rotationEffect(.degrees(rotation))
            }.onTapGesture  {
                withAnimation {
                    self.showContent.toggle()
                    self.rotation = (self.showContent ? 180.0 : 0.0)
                }
            }
            
            if showContent {
                let font = UIFont(name: ApolloSDK.current.getMediumFont(), size: 15.0)!
                let width = UIScreen.main.bounds.size.width - 32
                let height = self.text.height(withConstrainedWidth: width, font: font, textAlignment: .left, lineHeightMultiple: 1.23) + 32
                
                AttTextView(links: self.links, text: self.text, font: font, color: contentColor.uiColor(), textAlignment: .left)
                    .frame(height: height)
                    .transition(.opacity)
            }
            
            (showDivider ? Divider() : nil)
            Spacer()
        }.padding([.leading, .trailing], 0)
        
    }
}

struct AttExpandableSection_Previews: PreviewProvider {
    static var previews: some View {
        AttExpandableSection(showContent: true, text: "saldhasjkdhakjdhaskjdhajkshd saldhasjkdhakjdhaskjdhajkshd saldhasjkdhakjdhaskjdhajkshd saldhasjkdhakjdhaskjdhajkshd saldhasjkdhakjdhaskjdhajkshd saldhasjkdhakjdhaskjdhajkshdsaldhasjkdhakjdhaskjdhajkshd saldhasjkdhakjdhaskjdhajkshd saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak  saldhasjkdhakjdhaskjdhajkshd saldhasjkdhakjdhaskjdhajkshd saldhasjkdhakjdhaskjdhajkshd saldhasjkdhakjdhaskjdhajkshd saldhasjkdhakjdhaskjdhajkshd saldhasjkdhakjdhaskjdhajkshdsaldhasjkdhakjdhaskjdhajkshd saldhasjkdhakjdhaskjdhajkshd saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhaksjkdhakjdhaskjdhajkshd saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak saldhasjkdhak  ", links: [], contentColor: AttAppTheme.attSDKTextPrimaryColor)
    }
}

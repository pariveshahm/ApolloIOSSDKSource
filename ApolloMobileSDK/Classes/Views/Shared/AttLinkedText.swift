//  ContentText.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 15/01/2021.

import SwiftUI

struct AttLinkedText: View {
    // The current height of the view
    @State private var height: CGFloat = 20
    var content: [LinkedTextContent]
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                // Needs to be .topLeading so we can modify alignments on top and leading
                ZStack(alignment: .topLeading) {
                    self.zStackViews(geometry)
                }
                .background(calculateHeight($height))
            }
        }.frame(height: height)
    }
    
    // Determine the alignment of every view in the ZStack
    func zStackViews(_ geometry: GeometryProxy) -> some View {
        // These are used to track the current horizontal and vertical position
        // in the ZStack. As a new text or link is added, horizontal is decreased.
        // When a new line is required, vertical is decreased & horizontal is reset to 0.
        var horizontal: CGFloat = 0
        var vertical: CGFloat = 0
        
        // Determine the alignment for the view at the given index
        func forEachView(_ index: Int) -> some View {
            let numberOfViewsInContent: Int
            let view: AnyView
            
            // Determine the number of views in the Content at the given index
            switch content[index] {
            case .text(let text):
                numberOfViewsInContent = text.count
                view = AnyView(text)
            case .link(let link):
                numberOfViewsInContent = 1
                view = AnyView(link)
            }
            
            var numberOfViewsRendered = 0
            
            // Note that these alignment guides can get called multiple times per view
            // since ContentText returns a ForEach
            return view
                .alignmentGuide(.leading, computeValue: { dimension in
                    numberOfViewsRendered += 1
                    
                    let viewShouldBePlacedOnNextLine = geometry.size.width < -1 * (horizontal - dimension.width)
                    if viewShouldBePlacedOnNextLine {
                        // Push view to next line
                        vertical -= dimension.height
                        horizontal = -dimension.width
                        return 0
                    }
                    
                    let result = horizontal
                    
                    // Set horizontal to the end of the current view
                    horizontal -= dimension.width
                    
                    return result
                })
                .alignmentGuide(.top, computeValue: { _ in
                    let result = vertical
                    
                    // if this is the last view, reset everything
                    let isLastView = index == content.indices.last && numberOfViewsRendered == numberOfViewsInContent
                    if isLastView {
                        vertical = 0
                        horizontal = 0
                        numberOfViewsRendered = 0
                    }
                    
                    return result
                })
        }
        
        return ForEach(content.indices, content: forEachView)
    }
    
    // Determine the height of the view containing our combined Text and Link views
    func calculateHeight(_ binding: Binding<CGFloat>) -> some View {
        GeometryReader { geometry -> Color in
            DispatchQueue.main.async {
                binding.wrappedValue = geometry.size.height
            }
            
            return .clear
        }
    }
}

// View to split up a string into Text views, split by spaces.
struct AttContentText: View {
    private var color: Color
    private var font: Font
    private var splitText: [String]
    
    let count: Int
    
    init(_ text: String, font: Font = .body, color: Color = AttAppTheme.attSDKTextPrimaryColor) {
        self.color = color
        self.font = font
        self.splitText = text.split(separator: " ").map { "\($0) " }
        
        if text.hasPrefix(" ") {
            self.splitText = [" "] + self.splitText
        }
        
        self.count = splitText.count
    }
    
    var body: some View {
        ForEach(self.splitText.indices) { index in
            Text(splitText[index])
                .font(font)
                .foregroundColor(color)
                .multilineTextAlignment(.center)
                
        }
        .multilineTextAlignment(.center)
    }
}

enum LinkedTextContent {
    case text(AttContentText)
    case link(AttHyperLink)
}

struct AttContentView_Previews: PreviewProvider {
    static var previews: some View {
        AttLinkedText(content: [
            .text(AttContentText("As with other views, you can style links using standard view modifiers depending on the view type of the link’s label. For example, a ")),
            .link(AttHyperLink(text: "Google", link: URL(string: "https://google.com")!)),
            .text(AttContentText("This is a test text")),
            .link(AttHyperLink(text: "which is", link: URL(string: "https://google.com")!))
        ])
    }
}

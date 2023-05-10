//
//  PhoneNumberLinkModifier.swift
//  ApolloMobileSDK
//
//  Created by Elvis on 11/3/21.
//

import Foundation
import SwiftUI
import UIKit

struct LinkObject {
    let text: String
    let url: String
}

internal class WrappedUITextView: UITextView, UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {

        // link or phone
        if UIApplication.shared.canOpenURL(URL) {
            print("Link clicked \(URL)")
            UIApplication.shared.open(URL)
        }

        return false
    }
}

struct AttTextView: UIViewRepresentable {
    let links: [LinkObject]
    let text: String
    let font: UIFont
    var color: UIColor
    var lineHeight: CGFloat = 1.2
    var textAlignment: NSTextAlignment
    
    func makeUIView(context: Context) -> UITextView {
        let textView = WrappedUITextView()
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.alwaysBounceVertical = false
        
        textView.textAlignment = textAlignment
        textView.text = text
        textView.textColor = color
        textView.font = font
        
        textView.dataDetectorTypes = [.phoneNumber, .link]
        textView.textContainer.maximumNumberOfLines = 0
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.delegate          = textView
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<Self>) {
        let style = NSMutableParagraphStyle()
        style.alignment = self.textAlignment
        style.lineHeightMultiple = lineHeight
        style.lineBreakMode = .byWordWrapping
        
        let standardTextAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.paragraphStyle: style
        ]
        
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttributes(standardTextAttributes, range: attributedText.range )
    
        for link in links {
            let ranges = text.ranges(of: link.text)
            for range in ranges.map({ NSRange($0, in: text) }) {
                let hyperlinkTextAttributes: [NSAttributedString.Key : Any] = [
                    NSAttributedString.Key.font: font,
                    NSAttributedString.Key.foregroundColor: AttAppTheme.primaryColor.uiColor(),
                    NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                    NSAttributedString.Key.link: link.url
                ]
                
                attributedText.addAttributes(hyperlinkTextAttributes, range: range)
            }
        }
        let linkTextAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: AttAppTheme.primaryColor.uiColor(),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.paragraphStyle: style
        ]
    
        uiView.linkTextAttributes = linkTextAttributes
        uiView.attributedText = attributedText
        uiView.textAlignment = textAlignment
    }
}



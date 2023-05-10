//
//  ActivityIndicator.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 4/2/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import SwiftUI


public struct AttActivityIndicator: View {
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black)
                .opacity(0.4)
                .frame(width: 100, height: 100)
                
//            ActivityIndicator(isAnimating: true)
//                .configure { $0.color = .white }
//                .frame(width: 100, height: 100)
//                .background(Color.clear)
//                .zIndex(1)
           
            AttLoader()
                .foregroundColor(Color.white)
                .frame(width: 50, height: 50).zIndex(1)

        }
    }
}

struct AttActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        AttLoader()
    }
}


//
//struct ActivityIndicator: UIViewRepresentable {
//
//    typealias UIView = UIActivityIndicatorView
//    var isAnimating: Bool
//
//    var configuration = { (indicator: UIView) in}
//
//    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIView {
//        let view = UIView()
//        view.style = UIActivityIndicatorView.Style.large
//
//        return view
//    }
//    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Self>) {
//        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
//        configuration(uiView)
//    }
//}
//extension View where Self == ActivityIndicator {
//    func configure(_ configuration: @escaping (Self.UIView)->Void) -> Self {
//        Self.init(isAnimating: self.isAnimating, configuration: configuration)
//    }
//}

//  OneTimeOfferView.swift
//  ApolloMobileSDK
//
//  Created by Shak4l on 11/02/2021.

import SwiftUI

struct AttOneTimeOfferView: UIViewControllerRepresentable {
    
    // - Properties
    var product: AttProduct
    var user: AttUser
    
    typealias UIViewControllerType = AttOneTimeOfferFlowController
    
    func makeUIViewController(context: Context) -> AttOneTimeOfferFlowController {
        return .init(product, user: user)
    }
    
    func updateUIViewController(_ uiViewController: AttOneTimeOfferFlowController, context: Context) { }
}

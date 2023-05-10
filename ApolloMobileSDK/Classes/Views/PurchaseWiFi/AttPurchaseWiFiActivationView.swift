//
//  DataPlanActivationView.swift
//  ApolloMobileSDK
//
//  Created by Elvis on 3/19/21.
//

import SwiftUI

struct AttPurchaseWiFiActivationView: UIViewControllerRepresentable {
    
    // - Properties
    var useUserData: Bool
    var registeredUser: AttUser?

    var product: AttProduct
    var productOffer: AttProductOffer
    
    typealias UIViewControllerType = AttPurchaseWiFiFlowController
    
    func makeUIViewController(context: Context) -> AttPurchaseWiFiFlowController {
        return AttPurchaseWiFiFlowController(
            useUserData: useUserData,
            product: product,
            user: registeredUser ?? ApolloSDK.current.getUser(),
            productOffer: productOffer)
    }
    
    func updateUIViewController(_ uiViewController: AttPurchaseWiFiFlowController,
                                context: Context) {}
}

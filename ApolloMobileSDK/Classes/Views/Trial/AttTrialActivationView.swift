//  TrialActivationView.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 24/12/2020.

import SwiftUI

struct AttTrialActivationView: UIViewControllerRepresentable {
    
    // - State
   // @Binding var shouldDimiss: Bool
    
    // - Properties
    var useUserData: Bool
    var product: AttProduct
    var productOffer: AttProductOffer
    var onBack: () -> Void
    
    typealias UIViewControllerType = AttTrialActivationFlowController
    
    func makeUIViewController(context: Context) -> AttTrialActivationFlowController {
        return AttTrialActivationFlowController(
            useUserData: useUserData,
            product: product,
            productOffer: productOffer,
            onBack: onBack)
    }
    
    func updateUIViewController(_ uiViewController: AttTrialActivationFlowController,
                                context: Context) {}
}

//  AttDashboardRepresentable.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 19/01/2021.

import SwiftUI

public struct AttDashboardRepresentable: UIViewControllerRepresentable {
    
    public typealias UIViewControllerType = AttDashboardController
    
    public func makeUIViewController(context: Context) -> AttDashboardController {
        return .init(type: .normal)
    }
    
    public func updateUIViewController(_ uiViewController: AttDashboardController, context: Context) {}
}

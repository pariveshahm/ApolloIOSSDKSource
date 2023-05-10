//  AttWidgetRepresentable.swift
//  ATTORMRetailSDK
//
//  Created by Selma Suvalija on 10/12/2020.

import SwiftUI

public protocol AttNavigationDelegate: AnyObject {
    func present(viewController: UIViewController)
    func push(viewController: UIViewController)
    func pop(viewController: UIViewController, completion: @escaping () -> Void)
}

public struct AttWidgetRepresentable: UIViewControllerRepresentable {
    
    // - Type
    public typealias UIViewControllerType = AttWidgetController
    // - Properties
    private var widgetViewModel: AttWidgetViewModel?
    private var widgetViewController: AttWidgetController?
    private var isOnDashboard: Bool
    
    // - Init
    public init() {
        self.isOnDashboard = true
    }
    
    public init(onDashboard: Bool, navigationDelegate: AttNavigationDelegate? = nil, model: AttWidgetViewModel, screenType: AttWidgetScreenType) {
        self.isOnDashboard = onDashboard
        self.widgetViewModel = model
        self.widgetViewController = AttWidgetController(isOnDashboard: isOnDashboard, navigationDelegate: navigationDelegate, model: self.widgetViewModel!, screenType: screenType)
    }
    
    public func makeUIViewController(context: Context) -> AttWidgetController {
        widgetViewController?.view.backgroundColor = .clear
        return widgetViewController!
    }

    public func updateUIViewController(_ uiViewController: AttWidgetController, context: Context) {
        print("UPDATE view controller ==================")
    }
    
    public func getRootView() -> AnyView {
        return AnyView(self.widgetViewController?.rootView)
    }
}

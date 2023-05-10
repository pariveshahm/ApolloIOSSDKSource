//  AttWidgetController.swift
//  ATTORMRetailSDK
//
//  Created by Selma Suvalija on 12/10/20.

import SwiftUI

public class AttWidgetController: UIHostingController<AttWidgetView> {
    var navigationDelegate: AttNavigationDelegate?
    
    public init(isOnDashboard: Bool = false,
                isForCellView: Bool = false,
                navigationDelegate: AttNavigationDelegate?,
                model: AttWidgetViewModel = AttWidgetViewModel(),
                screenType: AttWidgetScreenType)
    {
        let widgetView: AttWidgetView = AttWidgetView(model: model, isForCellView: isForCellView, screenType: screenType)
        super.init(rootView: widgetView)
        self.rootView.onActivateTrial    = onActivateTrial
        self.rootView.onActivateDataPlan = onActivateDataPlan
        self.rootView.onShowDashboard = isOnDashboard ? nil : onShowDashboard
        self.navigationDelegate = navigationDelegate
    }
    
    @objc
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        self.hideAttNavigationBar()
        super.viewDidAppear(animated)
        
        removeAdditionalTopSpacing()
    }
    
    private var savedView: UIView?
    
    private func removeAdditionalTopSpacing() {
        if view.subviews.count < 2  {
            return
        }
        
        var widgetFrame = view.subviews[0].frame
        let widgetStartingPoint = widgetFrame.origin.y
        widgetFrame.origin.y = 0
        widgetFrame.origin.x = 0
        
        self.view.subviews[0].frame = widgetFrame
        self.view.subviews[1].frame = widgetFrame
        
        if widgetStartingPoint > 0 {
            self.savedView = self.view

            self.savedView?.translatesAutoresizingMaskIntoConstraints = false
            self.savedView?.widthAnchor.constraint(equalTo: self.savedView!.subviews[0].widthAnchor).isActive = true
            self.savedView?.heightAnchor.constraint(equalTo: self.savedView!.subviews[0].heightAnchor).isActive = true
            self.savedView?.centerXAnchor.constraint(equalTo: self.savedView!.subviews[0].centerXAnchor).isActive = true
            self.savedView?.centerYAnchor.constraint(equalTo: self.savedView!.subviews[0].centerYAnchor).isActive = true

            self.view = self.savedView
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        removeAdditionalTopSpacing()
    }
    
    // MARK: - Actions
    
    public lazy var onActivateTrial = {
        self.showLoader()
        guard let navigationDelegate = self.navigationDelegate else { return }
        ApolloSDK.current.startTrialFlow(presentationDelegate: navigationDelegate, failure: { error in
            self.hideLoader()
        })
    }
     func showLoader() {
        guard let navigationDelegate = self.navigationDelegate else { return }
        ApolloSDK.current.showLoading(presentationDelegate: navigationDelegate, failure: { error in })
    }
    private func hideLoader() {
        guard let navigationDelegate = self.navigationDelegate else { return }
        ApolloSDK.current.hideLoading(presentationDelegate: navigationDelegate)
    }
    private lazy var onActivateDataPlan = {
        let controller = AttPurchaseWiFiController()
        let navigationVc = UINavigationController(rootViewController: controller)
        navigationVc.modalTransitionStyle = .crossDissolve
        navigationVc.modalPresentationStyle = .fullScreen
        
        if let presentationDelegate = self.navigationDelegate {
            presentationDelegate.present(viewController: navigationVc)
            return
        }
        
        self.navigationController?.present(navigationVc, animated: true)
    }
    
    private lazy var onShowDashboard = {
        let dashboardVC = AttDashboardController(type: .normal)
        dashboardVC.modalPresentationStyle = .fullScreen
        
        if let navigationDelegate = self.navigationDelegate {
            navigationDelegate.push(viewController: dashboardVC)
            if(AttDashboardServices.shared.shouldLoadDataFromCache() == false) {
                AttDashboardServices.shared.resetCachedData()
            }
            return
        }
        
        self.navigationController?.pushViewController(dashboardVC, animated: true)
    }
}

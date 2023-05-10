//  AttDashboardController.swift
//  ATTORMRetailSDK
//
//  Created by Selma Suvalija on 7/3/20.

import SwiftUI
import WebKit

public enum AttDashboardType {
    case normal
    case error
    case learnMore
}

public class AttDashboardController: UIHostingController<AttDashboardView> {
    // renaming
    @ObservedObject var productListViewModel = AttProductListViewModel()
    @ObservedObject var model = AttWidgetViewModel()
    @ObservedObject var creditCardModel = AttCreditCardInfoViewModel()
    
    //Web
    private var paymentView: UIHostingController<AttEditPaymentProfileView>?
    
    private var dashboardView = AttDashboardView(onBack: { })
    
    init(type: AttDashboardType) {
        dashboardView.type = type
        super.init(rootView: dashboardView)
        dashboardView.navigationDelegate = self
        dashboardView.onShowOEM = onExit
        dashboardView.onShowHistory = showHistory
        dashboardView.onShowHotspot = showHotspot
        dashboardView.onBack = onBack
        dashboardView.showLegalAndRegulatory = showLegalAndRegulatory
        dashboardView.showViewPaymentProfile = showViewPaymentProfile
        self.rootView = dashboardView
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideAttNavigationBar()
        scrollToTopIfNeeded()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hideAttNavigationBar()
        
    }
    
    public func setType(type: AttDashboardType) {
        self.rootView.type = type
    }
    
    private func scrollToTopIfNeeded() {
        if let scrollView = self.view.subviews.last as? UIScrollView {
            let offset = CGPoint(
                x: -scrollView.adjustedContentInset.left,
                y: -scrollView.adjustedContentInset.top
            )
            
            scrollView.setContentOffset(offset, animated: true)
        }
    }
    
    @objc
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // This is hack only for trial flow propert navigaiton needs to get implemented
    private func onExit() {
        self.presentingViewController?.dismiss(animated: false)
        if let presentingViewController = self.presentingViewController {
            presentingViewController.dismiss(animated: false)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    // This is hack only for trial flow propert navigaiton needs to get implemented
    func onBack() {
        if self.navigationController?.viewControllers.count == 1 {
            let homeVc = self.presentingViewController as? AttNavigationDelegate
            self.navigationController?.dismiss(animated: true, completion: nil)
            homeVc?.push(viewController: UIViewController())
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showLegalAndRegulatory() {
        let onBack: () -> Void = { self.presentedViewController?.dismiss(animated: true) }
        let dashboardLegal = AttDashboardLegal(onBack: onBack)
        let hostingVC = UIHostingController(rootView: dashboardLegal)
        hostingVC.view.backgroundColor = AttAppTheme.attSDKBackgroundColor.uiColor()
        hostingVC.modalPresentationStyle = .fullScreen
        self.present(hostingVC, animated: true)
    }
    
    func showViewPaymentProfile() {
        let paymentProfileView = AttViewPaymentProfile(creditCardInfoViewModel: creditCardModel, goBack: onBack, editPaymentProfile: { (billingAddress: AttAddress?) in self.goToAddCreditCardStep(address: billingAddress) })
        let vc = UIHostingController(rootView: paymentProfileView)
        vc.view.backgroundColor = AttAppTheme.attSDKBackgroundColor.uiColor()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func presentAddressValidationDialog(_ onConfirmCallback: @escaping (AttAddress) -> (), addresses: [AttAddress]) {
        let validateAddressView = AttAddressValidationDialog(
            addresses: addresses,
            onConfirm: { address in
                onConfirmCallback(address)
                self.dismiss(animated: false)
            },
            onCancel: {
                self.dismiss(animated: false)
            })

        let hostingVC = UIHostingController(rootView: validateAddressView)
        hostingVC.modalPresentationStyle = .overCurrentContext
        hostingVC.view.backgroundColor = .clear
        self.present(hostingVC, animated: false)
    }
    
    func goToAddCreditCardStep(address: AttAddress?) {
       // Create link
       var path = ""
        
        let product = AttProduct(id: "", name: "", type: "", billingType: .none)
        let summaryModel = AttTransactionSummaryModel(product)
        
       if let address = address {
           path = "update/"
           path = path + AttPaymentLinkUtil.updatePayment(
            ApolloSDK.current.getUser(),
            cardAddress: address,
            autoRenew: false
           )
       } else {
           path = "create/"
           path = path + AttPaymentLinkUtil.createPaymentPath(
            product,
            summaryModel.user,
            autoRenew: false
           )
       }
       
       let url = URL(string: "\(ApolloSDK.current.getEnvironment().paymentBaseUrl())/payment-app-1/#/\(path)")
       //  let url = URL(string: "https://myvehicle-qc-payment.stage.att.com/payment-app-1/#/\(path)")
       //  let url = URL(string: "https://maestraltesting.net/payment-app-1/#/create/\(path)")
       
        let onExit: (Bool) -> Void = { goToDashboard in
        }

       
       let onBack: () -> Void = {
           self.dismiss(animated: false)
       }
       
       let onComplete: () -> Void = {
           self.presentedViewController?.dismiss(animated: true, completion: {})
       }
       
       let view: AttEditPaymentProfileView = AttEditPaymentProfileView(
           url: url,
           delegate: self,
           onExit: onExit,
           onBack: onBack,
           onComplete: onComplete,
           shouldUpdateOnly: (address != nil),
           model: AttPaymentViewModel(
            autoRenew: false,
            product: product
           )
       )
    
       let webViewVC = UIHostingController(rootView: view)
       self.paymentView = webViewVC
       webViewVC.modalPresentationStyle = .fullScreen
       self.present(webViewVC, animated: true)
   }

    private func showHistory() {
        let onBack: () -> Void = { self.presentedViewController?.dismiss(animated: true) }
        let orderHistory = AttOrderHistory(onBack)
        let hostingVC = UIHostingController(rootView: orderHistory)
        hostingVC.view.backgroundColor = AttAppTheme.attSDKBackgroundColor.uiColor()
        hostingVC.modalPresentationStyle = .fullScreen
        self.present(hostingVC, animated: true)
    }
    
    private func showHotspot() {
        ApolloSDK.current.delegate?.openHotspotSetupGuide()
    }
    private func exitFromSdk() {
        ApolloSDK.current.delegate?.exitFromSDKListener()
    }
    
    func setType(){
    }
}

extension AttDashboardController: AttNavigationDelegate {
    public func pop(viewController: UIViewController, completion: @escaping () -> Void) {
        completion()
        
        if let pushedVC = self.navigationController?.viewControllers.last, pushedVC.view.tag == viewController.view.tag {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
    
    public func present(viewController: UIViewController) {
        self.present(viewController, animated: false, completion: nil)
    }
    
    public func push(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
// MARK: - WKNavigationDelegate
extension AttDashboardController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .other, let url = navigationAction.request.url {
            let paths = url.absoluteString.split(separator: "/")
            
            if paths.contains("restore") && paymentView?.rootView.shouldUpdateOnly == false {
                paymentView?.rootView.startPurchase()
                decisionHandler(.cancel)
                return
            }
            
            if let paymentView = paymentView, paymentView.rootView.shouldUpdateOnly, paths.contains("restore") {
                paymentView.rootView.onBack()
                decisionHandler(.cancel)
                return
            }
            
            if paths.contains("back") {
                paymentView?.rootView.onBack()
                decisionHandler(.cancel)
                return
            }
            

        }
        
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        let topMargin = webView.url?.absoluteString.contains("/update") ?? false ? 60 : 240
        let removeNavbarScript = "document.getElementsByClassName('header-cpm')[0].style.display='none';"
        let liftFormUpScript = "document.getElementsByClassName('theme-payment-portal')[0].style='margin-top: -\(topMargin)px;';"
        let removeFooterScript = "document.getElementsByClassName('global-footer')[0].style.display='none';"
        
        webView.rexecuteJavascript(script: removeNavbarScript)
        webView.rexecuteJavascript(script: liftFormUpScript)
        webView.rexecuteJavascript(script: removeFooterScript)
    }
}

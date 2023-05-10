//  OneTimeOfferController.swift
//  ApolloMobileSDK
//
//  Created by Shak4l on 11/02/2021.

import SwiftUI
import WebKit

fileprivate let firstStepKey      = "1"
fileprivate let sumaryStepKey     = "transaction_summary_step_title".localized()
fileprivate let thirdStepKey      = "3"
fileprivate let thankYouStepKey   = "purchase_complete_step_title".localized()

class AttOneTimeOfferFlowController: AttFlowController {
    
    // - Properties
    private var paymentView: UIHostingController<AttPaymentView>?
    private let user: AttUser
    private let product: AttProduct
    private let model: AttTransactionSummaryModel
    
    init(_ product: AttProduct, user: AttUser) {
        self.product = product
        self.user = user
        self.model = AttTransactionSummaryModel(product)
        self.model.user = user
        self.model.isTransactionSummaryViewVisible = true
        try! super.init(firstStep: sumaryStepKey, flowTitle: "transaction_summary_step_name".localized())
    }
    
    override func loadView() {
        super.loadView()
        addStep(step: firstEmptyStep)
        addStep(step: summaryStep)
        addStep(step: thirdEmptyStep)
        addStep(step: thankYouStep)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - Steps
    private var summaryStep: AttStep {
        let onNext = {
            self.model.isTransactionSummaryViewVisible = false
            // Create link
            let path = AttPaymentLinkUtil.createPaymentPath(
                self.product,
                self.user,
                autoRenew: self.model.autoRenew
            )
            
          //  let url = URL(string: "https://myvehicle-qc-payment.stage.att.com/payment-app-1/#/create/\(path)")
            let url = URL(string: "\(ApolloSDK.current.getEnvironment().paymentBaseUrl())/payment-app-1/#/create/\(path)")

            let onExit: (Bool) -> Void = { goToDashboard in

                if goToDashboard {
                    // it depends on rootVC, if it is implemented as presentation or push
                    if let navigationVc = self.presentingViewController as? UINavigationController  {
                        navigationVc.pushDashboardViewController()
                        
                        self.parent?.dismiss(animated: false, completion: nil)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.dismiss(animated: false, completion: nil)
                        }
                        
                    } else {
                        let navigationVC = self.presentingViewController?.navigationController
                        self.dismiss(animated: false, completion: {
                            navigationVC?.setRootDashboardViewController()
                        })
                    }

                } else {
                    if let presented = self.presentedViewController {
                        presented.dismiss(animated: false, completion: {
                            self.dismiss(animated: true, completion: {})
                        })
                    } else {
                        self.dismiss(animated: true, completion: {})
                    }
                }
            }
            
            let onComplete: () -> Void = {
                try! self.goToStep(name: thankYouStepKey)
                self.flowTitle = "purchase_complete_step_name".localized()
                self.presentedViewController?.dismiss(animated: true, completion: nil)
            }
            
            let onBack: () -> Void = {
                self.model.isTransactionSummaryViewVisible = false
                self.presentedViewController?.dismiss(animated: true, completion: nil)
            }
            
            let view = AttPaymentView(
                url: url,
                delegate: self,
                onExit: onExit,
                onBack: onBack,
                onComplete: onComplete,
                model: .init(
                    autoRenew: self.model.autoRenew,
                    product: self.product
                )
            )
            
            let webViewVC = UIHostingController(rootView: view)
            self.paymentView = webViewVC
            webViewVC.modalPresentationStyle = .fullScreen
            self.present(webViewVC, animated: true)
        }
        
        let onBack: () -> Void = {
            self.model.isTransactionSummaryViewVisible = false
            self.navigationController?.popViewController(animated: true)
        }

        let onExit: () -> Void = {
            self.model.isTransactionSummaryViewVisible = false
            self.navigationController?.popToRootViewController(animated: false)
            self.dismiss(animated: true, completion: {})
        }
        
        let onAccountDashboard = {
            self.model.isTransactionSummaryViewVisible = false
            
            // it depends on rootVC, if it is implemented as presentation or push
            if let navigationVc = self.presentingViewController as? UINavigationController  {
                navigationVc.pushDashboardViewController()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.dismiss(animated: false, completion: nil)
                    
                }
                
            } else {
                self.navigationController?.setRootDashboardViewController()
            }
        }
        
        let offer = AttProductOffer(
            planName: "connected_car_prepaid_unlimited".localized(),
            dataAmount: "",
            planExpiration: "30_days".localized()
        )
        
        let view = AttTransactionSummaryView(
            onBack: onBack,
            onExit: onExit,
            onNext: onNext,
            onAccountDashboard: onAccountDashboard,
            offer: offer,
            product: product
        )
        .environmentObject(model)
        
        return AttStep(
            name: sumaryStepKey,
            view: AnyView(view),
            showNavigationBar: true,
            stepOrder: 2
        )
    }
    
    private var thankYouStep: AttStep {
        
        let onContinue: () -> Void = {            
            // it depends on rootVC, if it is implemented as presentation or push
            if let navigationVc = self.presentingViewController as? UINavigationController  {
                navigationVc.pushDashboardViewController(type: .normal)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.dismiss(animated: false, completion: nil)
                }
                
            } else {
                self.navigationController?.setRootDashboardViewController()
            }
        }
        
        return .init(
            name: thankYouStepKey,
            view: .init(AttOneTimeThankYou(onContinue: onContinue)),
            showNavigationBar: true,
            stepOrder: 4
        )
    }
    
    private var firstEmptyStep: AttStep {
        .init(
            name: firstStepKey,
            view: .init(EmptyView()),
            showNavigationBar: false,
            stepOrder: 1
        )
    }
    
    private var thirdEmptyStep: AttStep {
        .init(
            name: thirdStepKey,
            view: .init(EmptyView()),
            showNavigationBar: false,
            stepOrder: 3
        )
    }
}

// MARK: - WKNavigationDelegate
extension AttOneTimeOfferFlowController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .other, let url = navigationAction.request.url {
            let paths = url.absoluteString.split(separator: "/")
            if paths.contains("restore") {
                paymentView?.rootView.startPurchase()
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
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //let topMargin = webView.url?.absoluteString.contains("/update") ?? false ? 60 : 240
        let removeNavbarScript = "document.getElementsByClassName('header-cpm')[0].style.display='none';"
        let liftFormUpScript = "document.getElementsByClassName('theme-payment-portal')[0].style='margin-top: -240px;';"
        let removeFooterScript = "document.getElementsByClassName('global-footer')[0].style.display='none';"
        
        webView.rexecuteJavascript(script: removeNavbarScript)
        webView.rexecuteJavascript(script: liftFormUpScript)
        webView.rexecuteJavascript(script: removeFooterScript)
    }
}

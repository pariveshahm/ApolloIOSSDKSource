//
//  PurchaseWiFiFlow.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/16/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.


import SwiftUI
import WebKit

class AttPurchaseWiFiFlowController: AttFlowController {
    // - Properties
    private var paymentView: UIHostingController<AttPaymentView>?
    private var useUserData:  Bool
    private var product:      AttProduct
    private var productOffer: AttProductOffer
    private var summaryModel: AttTransactionSummaryModel
    
    override func loadView() {
        super.loadView()
        
        if (ApolloSDK.current.getIsNewUser()) {
            addStep(step: configureCreateAccountStep(stepOrder: 1))
            addStep(step: configureTransactionSummaryStep(stepOrder: 2))
            addStep(step: configureCreditCardInfoStep(stepOrder: 3))
            addStep(step: configureCompletePurchaseStep(stepOrder: 4))
        } else {
            addStep(step: configureFirstEmptyStep(stepOrder: 1))
            addStep(step: configureTransactionSummaryStep(stepOrder: 2))
            addStep(step: configureCreditCardInfoStep(stepOrder: 3))
            addStep(step: configureCompletePurchaseStep(stepOrder: 4))
        }
    }
    init(useUserData: Bool, product: AttProduct, user: AttUser, productOffer: AttProductOffer) {
        self.product = product
        self.useUserData = useUserData
        self.productOffer = productOffer
        self.summaryModel = AttTransactionSummaryModel(product)
        
        var title = ""
        var step = ""
        
        if (ApolloSDK.current.getIsNewUser()) {
            title = PurchaseWiFiStepTitles.createAccountt.value()
            step = AttPurchaseWiFiSteps.createAccountt.value()
            if useUserData {
                summaryModel.user = user
            } else {
                summaryModel.user = .init()
            }
        } else {
            title = PurchaseWiFiStepTitles.transactionSummaryy.value()
            step = AttPurchaseWiFiSteps.transactionSummaryy.value()
            summaryModel.user = user
            summaryModel.isTransactionSummaryViewVisible = true
        }
        
        try! super.init(firstStep: step, flowTitle: title)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureFirstEmptyStep(stepOrder: Int) -> AttStep {
        .init(
            name: AttPurchaseWiFiSteps.firstStepKeyy.value(),
            view: .init(EmptyView()),
            showNavigationBar: false,
            stepOrder: stepOrder
        )
    }
    
    private func configureCreateAccountStep(stepOrder: Int) -> AttStep {
        let onNext: () -> Void = {
            self.flowTitle = PurchaseWiFiStepTitles.transactionSummaryy.value()
            self.summaryModel.isTransactionSummaryViewVisible = true
            self.steps[AttPurchaseWiFiSteps.transactionSummaryy.value()] = self.configureTransactionSummaryStep(stepOrder: 2)
            try? self.goToStep(name: AttPurchaseWiFiSteps.transactionSummaryy.value())
        }
        
        let onBack: () -> Void = {
            self.flowTitle = PurchaseWiFiStepTitles.planSelectionn.value()
            //  ApolloSDK.current.resetNavigationBarStyle()
            self.navigationController?.popViewController(animated: true)
        }
        
        let view = AttCreateAccountView(
            user: summaryModel.user,
            product: flowData.product ?? AttProduct(id: "", name: "", type: "", billingType: .none),
            onNext: onNext,
            onExit: onBack,
            onPresentDialogHandler: presentAddressValidationDialog,
            onShowStepper: showStepIndicator
        )
            .environmentObject(summaryModel)
        
        return AttStep(
            name: AttPurchaseWiFiSteps.createAccountt.value(),
            view: AnyView(view),
            showNavigationBar: true,
            stepOrder: stepOrder
        )
    }
    
    private func configureTransactionSummaryStep(stepOrder: Int) -> AttStep {
        let onNext: () -> Void = {
            self.flowTitle = PurchaseWiFiStepTitles.transactionSummaryy.value()
            self.summaryModel.isTransactionSummaryViewVisible = false
            
            if ApolloSDK.current.creditCard == 200 {
                let creditCardInfoViewModel = AttCreditCardInfoViewModel()
                let paymentInfo = AttPurchaseWiFiSteps.paymentInfoo.value()
                self.steps[paymentInfo] = self.configureCreditCardInfoStep(stepOrder: 3, creditCardInfoViewModel: creditCardInfoViewModel)
                try? self.goToStep(name: paymentInfo)
            } else {
                self.steps[AttPurchaseWiFiSteps.paymentInfoo.value()] = self.configureThirdEmptyStep(stepOrder: 3)
                self.goToAddCreditCardStep(address: nil)
            }
        }
        
        let onBack: () -> Void = {
            
            self.summaryModel.isTransactionSummaryViewVisible = false
            if (ApolloSDK.current.getIsNewUser()) {
                self.flowTitle = PurchaseWiFiStepTitles.createAccountt.value()
                self.goToPreviousStep()
            } else {
                self.flowTitle = PurchaseWiFiStepTitles.planSelectionn.value()
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        let onExit: () -> Void = {
            self.summaryModel.isTransactionSummaryViewVisible = false
            
            //  ApolloSDK.current.resetNavigationBarStyle()
            if let presented = self.presentedViewController {
                presented.dismiss(animated: false, completion: {
                    self.dismiss(animated: false, completion: {})
                })
            } else {
                self.dismiss(animated: true, completion: {})
            }
        }
        
        let onAccountDashboard = {
            self.summaryModel.isTransactionSummaryViewVisible = false
            
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
        
        let dataAmount = "\(self.flowData.product?.usage?.limit ?? "N/a")\(self.flowData.product?.usage?.unit ?? "GB")"
        let planInterval = self.flowData.product?.recurrent?.interval ?? 0
        let planUnit     = self.flowData.product?.recurrent?.unit ?? ""
        
        let offer = AttProductOffer(
            planName: self.flowData.product?.name ?? "",
            dataAmount: dataAmount,
            planExpiration: "\(planInterval) \(planUnit)"
        )
        
        let view = AttTransactionSummaryView(
            onBack: onBack,
            onExit: onExit,
            onNext: onNext,
            onAccountDashboard: onAccountDashboard,
            offer: offer,
            product: product
        )
            .environmentObject(summaryModel)
        
        return AttStep(
            name: AttPurchaseWiFiSteps.transactionSummaryy.value(),
            view: AnyView(view),
            showNavigationBar: true,
            stepOrder: stepOrder
        )
    }
    
    private func configureThirdEmptyStep(stepOrder: Int) -> AttStep {
        .init(
            name: AttPurchaseWiFiSteps.paymentInfoo.value(),
            view: .init(EmptyView()),
            showNavigationBar: false,
            stepOrder: stepOrder
        )
    }
    
    private func configureCreditCardInfoStep(stepOrder: Int, creditCardInfoViewModel: AttCreditCardInfoViewModel = AttCreditCardInfoViewModel()) -> AttStep {
        let onNext: () -> Void = {
            self.flowTitle = PurchaseWiFiStepTitles.transactionSummaryy.value()
            try? self.goToStep(name: AttPurchaseWiFiSteps.completePurchasee.value())
        }
        
        let onBack: () -> Void = {
            self.summaryModel.isTransactionSummaryViewVisible = true
            self.flowTitle = PurchaseWiFiStepTitles.transactionSummaryy.value()
            self.goToPreviousStep()
        }
        
        let onGoToDashboard: () -> Void = {
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
        
        let view = AttCreditCardInfoView(
            paymentModel: AttPaymentViewModel(
                autoRenew: self.summaryModel.autoRenew,
                product: self.product
            ),
            creditCardInfoViewModel: creditCardInfoViewModel,
            goBack: onBack,
            goNext: onNext,
            goToDashboard: onGoToDashboard,
            editPaymentProfile: { (billingAddress: AttAddress?) in self.goToAddCreditCardStep(address: billingAddress) }
        )
        
        return AttStep(
            name: AttPurchaseWiFiSteps.paymentInfoo.value(),
            view: AnyView(view),
            showNavigationBar: true,
            stepOrder: stepOrder
        )
    }
    
    private func goToAddCreditCardStep(address: AttAddress?) {
        // Create link
        var path = ""
        
        if let address = address {
            path = "update/"
            path = path + AttPaymentLinkUtil.updatePaymentPath(
                self.product,
                self.summaryModel.user,
                cardAddress: address,
                autoRenew: self.summaryModel.autoRenew
            )
        } else {
            path = "create/"
            path = path + AttPaymentLinkUtil.createPaymentPath(
                self.product,
                self.summaryModel.user,
                autoRenew: self.summaryModel.autoRenew
            )
        }
        
        let url = URL(string: "\(ApolloSDK.current.getEnvironment().paymentBaseUrl())/payment-app-1/#/\(path)")
        //  let url = URL(string: "https://myvehicle-qc-payment.stage.att.com/payment-app-1/#/\(path)")
        //  let url = URL(string: "https://maestraltesting.net/payment-app-1/#/create/\(path)")
        
        let onExit: (Bool) -> Void = { goToDashboard in
            
            if goToDashboard {
                // it depends on rootVC, if it is implemented as presentation or push
                if let navigationVc = self.presentingViewController as? UINavigationController  {
                    navigationVc.pushDashboardViewController()
                    
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
                        if let navigationVc = self.presentingViewController as? UINavigationController  {
                            navigationVc.pushDashboardViewController(type: .normal)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.dismiss(animated: false, completion: nil)
                            }
                        } else {
                            self.navigationController?.setRootDashboardViewController()
                        }
                    })
                } else {
                    self.dismiss(animated: true, completion: {})
                }
            }
        }
        
        let onBack: () -> Void = {
            self.summaryModel.isTransactionSummaryViewVisible = true
            self.presentedViewController?.dismiss(animated: true, completion: {})
        }
        
        let onComplete: () -> Void = {
            self.flowTitle = PurchaseWiFiStepTitles.transactionSummaryy.value()
            try? self.goToStep(name: AttPurchaseWiFiSteps.completePurchasee.value())
            self.presentedViewController?.dismiss(animated: true, completion: {})
        }
        
        let view: AttPaymentView = AttPaymentView(
            url: url,
            delegate: self,
            onExit: onExit,
            onBack: onBack,
            onComplete: onComplete,
            shouldUpdateOnly: (address != nil),
            model: AttPaymentViewModel(
                autoRenew: self.summaryModel.autoRenew,
                product: self.product
            )
        )
        
        let webViewVC = UIHostingController(rootView: view)
        self.paymentView = webViewVC
        webViewVC.modalPresentationStyle = .fullScreen
        self.present(webViewVC, animated: true)
        
    }
    
    private func configureCompletePurchaseStep(stepOrder: Int) -> AttStep {
        let onNext: () -> Void = {
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
        
        let view = AttPurchaseCompletedView(
            goToDashboard: onNext
        )
        
        return AttStep(
            name: AttPurchaseWiFiSteps.completePurchasee.value(),
            view: AnyView(view),
            showNavigationBar: true,
            stepOrder: stepOrder
        )
    }
}

// MARK: - WKNavigationDelegate
extension AttPurchaseWiFiFlowController: WKNavigationDelegate {
    
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
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        let topMargin = webView.url?.absoluteString.contains("/update") ?? false ? 60 : 240
        let removeNavbarScript = "document.getElementsByClassName('header-cpm')[0].style.display='none';"
        let liftFormUpScript = "document.getElementsByClassName('theme-payment-portal')[0].style='margin-top: -\(topMargin)px;';"
        let removeFooterScript = "document.getElementsByClassName('global-footer')[0].style.display='none';"
        
        webView.rexecuteJavascript(script: removeNavbarScript)
        webView.rexecuteJavascript(script: liftFormUpScript)
        webView.rexecuteJavascript(script: removeFooterScript)
    }
}



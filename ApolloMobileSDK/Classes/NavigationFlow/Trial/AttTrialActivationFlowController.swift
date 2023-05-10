//  TrialActivationController.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 24/12/2020.

import SwiftUI

fileprivate let sumaryStepKey    = "transaction_summary_step_title".localized()
fileprivate let createAccountKey = "registration_step_title".localized()

class AttTrialActivationFlowController: AttFlowController {
    
    // - Properties
    var onBack:       () -> Void
    var useUserData:  Bool
    var product:      AttProduct
    var productOffer: AttProductOffer
    
    // - Stored
    lazy var summaryModel = AttTransactionSummaryModel(product)
    
    override func loadView() {
        super.loadView()
        addStep(step: createAccountStep)
        addStep(step: summaryStep)
    }
    
    init(useUserData: Bool, product: AttProduct, productOffer: AttProductOffer, onBack: @escaping () -> Void) {
        let title = "createAccount_fragmentTitle".localized()
        self.onBack = onBack
        self.product = product
        self.useUserData = useUserData
        self.productOffer = productOffer
        try! super.init(firstStep: createAccountKey, flowTitle: title)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - Steps
    private var summaryStep: AttStep {
        let onNext = {
            self.summaryModel.isTransactionSummaryViewVisible = false
            
            let specialVC = AttSpecialOfferController(
                self.summaryModel.user
            )
            
            self.navigationController?.pushViewController(specialVC, animated: true)
        }
        
        let onBack = {
            self.summaryModel.isTransactionSummaryViewVisible = false
            self.flowTitle = "createAccount_fragmentTitle".localized()
            self.goToPreviousStep()
        }
        
        let onExit = {
            self.summaryModel.isTransactionSummaryViewVisible = false
            ApolloSDK.current.delegate?.exitFromSDKListener()
           // ApolloSDK.current.resetNavigationBarStyle()
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
        
        let view = AttTransactionSummaryView(
            onBack: onBack,
            onExit: onExit,
            onNext: onNext,
            onAccountDashboard: onAccountDashboard,
            offer: productOffer,
            product: product
        )
        .environmentObject(summaryModel)
        
        return AttStep(
            name: sumaryStepKey,
            view: AnyView(view),
            showNavigationBar: true,
            stepOrder: 2
        )
    }
    
    private var createAccountStep: AttStep {
        let onNext = {
            // - Show next view
            self.summaryModel.isTransactionSummaryViewVisible = true
            try! self.goToStep(name: sumaryStepKey)
            self.flowTitle = "transaction_summary_trial_step_name".localized()
        }
        
        let view = AttCreateAccountView(
            user: useUserData ? ApolloSDK.current.getUser() : .init(),
            product: product,
            onNext: onNext,
            onExit: onBack,
            onPresentDialogHandler: presentAddressValidationDialog,
            onShowStepper: showStepIndicator
        )
        .environmentObject(summaryModel)
        
        return AttStep(
            name: createAccountKey,
            view: AnyView(view),
            showNavigationBar: true,
            stepOrder: 1
        )
    }
}

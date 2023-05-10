//  TrialController.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 20/12/2020.

import SwiftUI

class AttTrialActivationController: UIHostingController<AttTrialSplashView> {
    @State private var isTrial = true
    // - Properties
    private var product: AttProduct
    
    // - Computed properties
    private lazy var onExit = { [unowned self] in
        self.dismiss(animated: false)
        ApolloSDK.current.delegate?.exitFromSDKListener()
    }
    
    private lazy var onNext: ( (Bool, AttProduct, AttProductOffer) -> Void) = { useUserData, product, offer in
        let view = AttTrialActivationView(
            useUserData: useUserData,
            product: product,
            productOffer: offer,
            onBack: {
                self.navigationController?.popViewController(animated: true)
            })
        
        let vc = UIHostingController(rootView: view)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    init(_ product: AttProduct) {
        self.product = product
        
        let dataAmount = "\(product.usage?.limit ?? "N/a")\(product.usage?.unit ?? "GB")"
    
        let offer = AttProductOffer(
            planName: "\(dataAmount) " + "trial_data_plan".localized(),
            dataAmount: dataAmount,
            planExpiration: "90_days".localized()
        )
        super.init(rootView: AttTrialSplashView(product: product, offer: offer))
        self.rootView.onExit = onExit
        self.rootView.onNext = onNext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isTrial = false
        DispatchQueue.main.async {
            self.hideAttNavigationBar()
            
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hideAttNavigationBar()
    }
    
    @objc
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

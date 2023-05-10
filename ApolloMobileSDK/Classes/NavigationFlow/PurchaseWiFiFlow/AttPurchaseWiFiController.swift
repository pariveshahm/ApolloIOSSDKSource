//
//  PurchaseWiFiController.swift
//  ApolloMobileSDK
//
//  Created by Elvis on 3/19/21.
//

import SwiftUI

class AttPurchaseWiFiController: UIHostingController<AttProductListView> {
    weak var navigationDelegate: AttNavigationDelegate?
    // - Computed properties
    private lazy var onDismiss = { [unowned self] in
        self.dismiss(animated: false)
        
    }
    
    private lazy var onSelected = { (product: AttProduct, productOffer: AttProductOffer, registeredUser: AttUser?, useUserData: Bool) in
        let view = AttPurchaseWiFiActivationView(useUserData: useUserData,
                                              registeredUser: registeredUser,
                                              product: product,
                                              productOffer: productOffer)
        
        let vc = UIHostingController(rootView: view)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    init() {
        super.init(rootView: .init() )
        self.rootView.goBack = self.onDismiss
        self.rootView.goNext = self.onSelected
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideAttNavigationBar()
        
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

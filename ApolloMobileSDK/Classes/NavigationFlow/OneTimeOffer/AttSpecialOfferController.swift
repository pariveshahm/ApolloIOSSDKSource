//  SpecialOfferView.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 17/01/2021.

import SwiftUI

class AttSpecialOfferController: UIHostingController<AttSpecialOfferView> {
    @ObservedObject var model = AttWidgetViewModel()
    // - Properties
    var user: AttUser
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideAttNavigationBar()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hideAttNavigationBar()
    }
    
    // - Init 
    init(_ user: AttUser) {
        self.user = user
        super.init(rootView: AttSpecialOfferView())
        self.rootView.onDeny = showDashboard
        self.rootView.onAccept = showSpecialOffer
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - Actions
    private func showDashboard() {
        // it depends on rootVC, if it is implemented as presentation or push
        if let navigationVc = self.presentingViewController as? UINavigationController  {
            navigationVc.pushDashboardViewController(type: .normal)
            AttDashboardServices.shared.resetCachedData()
            AttConsentsServices.shared.resetCachedData()
            ApolloSDK.current.clientSessionId = UUID.init().uuidString
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.dismiss(animated: false, completion: nil)
            }
        } else {
            self.navigationController?.setRootDashboardViewController()
        }
    }
    
    private func showSpecialOffer(product: AttProduct) {
        ApolloSDK.current.isNewUser(false)
        let view = AttOneTimeOfferView(product: product, user: user)
        let specialOfferFlow = UIHostingController(rootView: view)
        navigationController?.pushViewController(specialOfferFlow, animated: true)
    }
}

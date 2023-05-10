//
//  RemoteViewController.swift
//  HondaExample
//
//  Created by Elvis on 7/22/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//
import SwiftUI
import ApolloMobileSDK

class RemoteViewController: UIHostingController<RemoteView> {
    
    let remoteViewModel = AttWidgetViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        remoteViewModel.setViewActive()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        remoteViewModel.setViewInactive()
    }
    
    // - Init
    init(carImage: String, navigationDelegate: AttNavigationDelegate?) {
        let remoteView = RemoteView(model: remoteViewModel, carImage: carImage, navigationDelegate: navigationDelegate)
        super.init(rootView: remoteView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

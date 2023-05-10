//
//  LoadingController.swift
//  Alamofire
//
//  Created by Elvis on 8/10/22.
//

import Foundation
import SwiftUI

class LoadingViewController: UIHostingController<AttActivityIndicator> {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.hideAttNavigationBar()
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        hideAttNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.showAttNavigationBar()
    }
    
    init() {
        let remoteView = AttActivityIndicator()
        super.init(rootView: remoteView)
        
        view.backgroundColor = AttAppTheme.attSDKBackgroundColor.uiColor()
        view.tag = 7777
        
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

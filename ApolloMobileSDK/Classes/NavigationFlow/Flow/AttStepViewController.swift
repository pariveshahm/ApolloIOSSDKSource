//  StepViewController.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/17/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import SwiftUI

class AttStepViewController: UIHostingController<AnyView> {
    
    var step: AttStep?
    var flowData: AttFlowData
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 99999) {
            self.hideAttNavigationBar()
        }
//        hideAttNavigationBar()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hideAttNavigationBar()
    }
    
    init(step: inout AttStep, flowData: inout AttFlowData) {
        self.step = step
        self.flowData = flowData
        let view: AnyView = AnyView(step.view.environmentObject(flowData).background(AttAppTheme.attSDKBackgroundColor).navigationBarHidden(true))
        super.init(rootView: view)
        
        self.view.backgroundColor = AttAppTheme.attSDKBackgroundColor.uiColor()
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



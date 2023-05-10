//
//  Step.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/17/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation
import SwiftUI

struct AttStep {
    var name: String
    var view: AnyView
    var navigationBarTitle: String = ""
    var showNavigationBar: Bool = false
    var showStepIndicator: Bool = true
    var stepOrder: Int
    
    public init(name: String, view: AnyView, navigationBarTitle: String = "", showNavigationBar: Bool, showStepIndicator: Bool = true, stepOrder: Int) {
        self.name = name
        self.view = view
        self.navigationBarTitle = navigationBarTitle
        self.showNavigationBar = showNavigationBar
        self.showStepIndicator = showStepIndicator
        self.stepOrder = stepOrder
    }
}

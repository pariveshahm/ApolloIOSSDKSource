//
//  Flow.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/16/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation
import SwiftUI

protocol AttFlow {
    func addStep(name: String, step: AnyView)
    func goToStep(name: String)
}

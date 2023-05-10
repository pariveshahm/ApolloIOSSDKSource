//  RefreshModel.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 20/01/2021.

import Foundation

struct AttRefreshModel {
    var startOffset: CGFloat = 0
    var offset: CGFloat      = 0
    var invalid: Bool        = false
    var started: Bool
    var released: Bool
    
    
    var shouldUpdate: Bool {
        startOffset == offset && started && !released
    }
    
    var hasStarted: Bool {
        offset - startOffset > 70 && !started
    }
}

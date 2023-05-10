//
//  BackgroundShape.swift
//  ATTORMRetailSDK
//
//  Created by Selma Suvalija on 6/4/20.
//

import SwiftUI

struct AttBackgroundShape: Shape {
    var height: CGFloat = 245
    var controlPointY: CGFloat = 305
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY - height))
        
        
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.maxY - height), control1: CGPoint(x: -90, y: rect.maxY - controlPointY), control2: CGPoint(x: 200, y: rect.maxY - controlPointY))
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - height))
        
        return path
    }
    
    
}

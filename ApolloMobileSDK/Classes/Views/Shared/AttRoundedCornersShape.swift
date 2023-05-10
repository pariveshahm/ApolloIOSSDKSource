//
//  ViewExtensions.swift
//  ATTORMRetailSDK
//
//  Created by Selma Suvalija on 7/15/20.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( AttRoundedCorner(radius: radius, corners: corners) )
    }
}

struct AttRoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct AttTopCornersRoundedOverlayShape: Shape {
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let bl =  CGPoint(x: rect.minX, y: rect.maxY)
        let br =  CGPoint(x: rect.maxX, y: rect.maxY)
        
        let tls = CGPoint(x: rect.minX, y: rect.minY + radius)
        let tlc = CGPoint(x: rect.minX + radius, y: rect.minY + radius)
        
        let trs = CGPoint(x: rect.maxX - radius, y: rect.minY)
        let trc = CGPoint(x: rect.maxX - radius, y: rect.minY + radius)
        
        path.move(to: br)
        path.addLine(to: bl)
        path.addLine(to: tls)
        path.addRelativeArc(center: tlc, radius: radius,
                            startAngle: Angle.degrees(180), delta: Angle.degrees(90))
        path.addLine(to: trs)
        path.addRelativeArc(center: trc, radius: radius,
                            startAngle: Angle.degrees(-90), delta: Angle.degrees(90))
        
        path.addLine(to: br)
      
        
        return path
    }
}



struct AttBottomCornersRoundedOverlayShape: Shape {
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let tl = CGPoint(x: rect.minX, y: rect.minY)
        let tr = CGPoint(x: rect.maxX, y: rect.minY)
        
        let brs = CGPoint(x: rect.maxX, y: rect.maxY - radius)
        let brc = CGPoint(x: rect.maxX - radius, y: rect.maxY - radius)

        let bls = CGPoint(x: rect.minX + radius, y: rect.maxY)
        let blc = CGPoint(x: rect.minX + radius, y: rect.maxY - radius)

        
        path.move(to: tl)
        path.addLine(to: tr)
        path.addLine(to: brs)
        path.addRelativeArc(center: brc, radius: radius,
                            startAngle: Angle.degrees(0), delta: Angle.degrees(90))
        path.addLine(to: bls)
        path.addRelativeArc(center: blc, radius: radius,
                            startAngle: Angle.degrees(90), delta: Angle.degrees(90))
        
        //path.addLine(to: tl)
      
        
        return path
    }
}

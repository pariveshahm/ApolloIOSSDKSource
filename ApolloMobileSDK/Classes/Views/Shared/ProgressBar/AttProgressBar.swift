//
//  ProgressBar.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 4/9/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//
import SwiftUI
struct AttProgressBar: View {
    private let value: Double
    private let maxValue: Double
    private let backgroundColor: Color = AttAppTheme.textFieldBorderColor
    private let foregroundColor: Color = AttAppTheme.greenProgressBarColor
    private var shouldShowProgress: Bool = true
    private var shouldShowError: Bool = false
    
    init(value: Double,
         maxValue: Double,
         shouldShowProgress: Bool = true,
         shouldShowError: Bool = false) {
        self.value = value
        self.maxValue = maxValue
        self.shouldShowProgress = shouldShowProgress
        self.shouldShowError = shouldShowError
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geometryReader in
                Capsule().foregroundColor(self.backgroundColor)
                Capsule()
                    .frame(width: self.progress(value: self.value,
                                                maxValue: self.maxValue,
                                                width: geometryReader.size.width))
                    .foregroundColor(getColor(percentage: getPercentage()))
                   // .animation(.easeIn)
            }
        }
    }
    
    private func getPercentage() -> Double {
        return value / maxValue * 100
    }
    
    private func progress(value: Double,
                          maxValue: Double,
                          width: CGFloat) -> CGFloat {
        let percentage = (value == 0 && maxValue == 0) ? 1 : value / maxValue
        return width *  CGFloat(percentage)
    }
    
    private func getColor(percentage: Double) -> Color {
        
        if shouldShowProgress {
            if percentage < 75 {
                return AttAppTheme.greenProgressBarColor
            } else if percentage > 75 && percentage < 100 {
                return AttAppTheme.yellowProgressBarColor
            } else {
                return AttAppTheme.redProgressBarColor
            }
        } else if shouldShowError {
            return AttAppTheme.redProgressBarColor
        } else {
            return AttAppTheme.greenProgressBarColor
        }
    }
}

struct AttProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        AttProgressBar(value: 5, maxValue: 10)
            .frame(height: 10)
            .padding(30)
    }
}

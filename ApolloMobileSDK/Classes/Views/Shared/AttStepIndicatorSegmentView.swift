//
//  StepIndicatorSegmentView.swift
//  ApolloMobileSDK
//
//  Created by Elvis on 9/20/21.
//

import Foundation
import SwiftUI

class AttStepIndicatorSegmentModel: ObservableObject {
    @Published var segmentTitle = ""
    @Published var isCompleted = false {
        willSet(newIsCompleted) {
            color = newIsCompleted ? AttAppTheme.primaryColor : AttAppTheme.attSDKButtonDisabledBackgroundColor
        }
    }
    
    var color: Color = AttAppTheme.attSDKButtonDisabledBackgroundColor
    var showNavigationBar: Bool = false
    
    init(title: String, showNavigationBar: Bool, isCompleted: Bool) {
        self.segmentTitle = title
        self.isCompleted = isCompleted
        self.showNavigationBar = showNavigationBar
    }
}

struct AttStepIndicatorSegmentView: View, Identifiable {
    var id: Int
    @ObservedObject var stepIndicatorSegmentModel: AttStepIndicatorSegmentModel
    var body: some View {
        Rectangle()
            .fill(stepIndicatorSegmentModel.color)
            .frame(height: 3)
            .animation(.linear)
    }
}

struct AttStepIndicatorSegmentView_Previews: PreviewProvider {
    static var previews: some View {
        AttStepIndicatorSegmentView(id: 0, stepIndicatorSegmentModel: AttStepIndicatorSegmentModel(title: "Title", showNavigationBar: true, isCompleted: false))
    }
}

//
//  StepIndicatorView.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/14/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import SwiftUI

struct AttStepIndicatorView: View {
    
    @ObservedObject var stepIndicatorViewModel: AttStepIndicatorViewModel
    var headerBacgroundColor: Color = AttAppTheme.attSDKDashboardHeaderBackgroundColor
    
    var body: some View {
        if (stepIndicatorViewModel.steps[stepIndicatorViewModel.currentStep].stepIndicatorSegmentModel.showNavigationBar) {
                AttPurchaseNavigarionBarView<AnyView, AnyView>(titleText: stepIndicatorViewModel.title, backgroundColor: AttAppTheme.attSDKBackgroundColor, contentView: {
                    getContent()
                }, onBack: nil)
        } else {
            getContent()
        }
    }
    
    func getContent() -> AnyView {
        AnyView(
            ZStack {
            AttAppTheme.attSDKBackgroundColor
                .edgesIgnoringSafeArea(.all)
        
            VStack(alignment: .leading) {
                HStack {
                    ForEach(stepIndicatorViewModel.steps, id: \.stepIndicatorSegmentModel.segmentTitle) { step in
                        step
                    }

                }

                if (stepIndicatorViewModel.currentStep < stepIndicatorViewModel.steps.count) {
                    HStack {
                        Text(String(format: "step".localized(), stepIndicatorViewModel.currentStep + 1, stepIndicatorViewModel.steps.count))
                            .font(.custom(ApolloSDK.current.getMediumFont(), size: 13))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        Text("\(stepIndicatorViewModel.steps[stepIndicatorViewModel.currentStep].stepIndicatorSegmentModel.segmentTitle)")
                            .foregroundColor(AttAppTheme.primaryColor)
                            .font(.custom(ApolloSDK.current.getMediumFont(), size: 13))

                    }
                }
                Text(" ")
                    .foregroundColor(AttAppTheme.primaryColor)
                    .font(.custom(ApolloSDK.current.getMediumFont(), size: 13))
            }
            .onAppear(){
                if (self.stepIndicatorViewModel.currentStep < self.stepIndicatorViewModel.steps.count) {
                    self.stepIndicatorViewModel.steps[self.stepIndicatorViewModel.currentStep].stepIndicatorSegmentModel.isCompleted = true
                }
            }
            .padding(.horizontal)
            .background(headerBacgroundColor)
            .navigationBarHidden(true)
                Rectangle()
                    .fill(.gray)
                    .opacity(1)
                    .frame(height: 1)
                    .edgesIgnoringSafeArea(.horizontal)
                    .offset(y: 29)
                Rectangle()
                    .fill(.gray)
                    .opacity(0.3)
                    .frame(height: 1)
                    .edgesIgnoringSafeArea(.horizontal)
                    .offset(y: 30)
                Rectangle()
                    .fill(.gray)
                    .opacity(0.1)
                    .frame(height: 1)
                    .edgesIgnoringSafeArea(.horizontal)
                    .offset(y: 30.5)
        })
        
    }
    
    
    func goToNextStep() {
        
        self.stepIndicatorViewModel.steps[self.stepIndicatorViewModel.currentStep].stepIndicatorSegmentModel.isCompleted = true
        
        let nextStep = self.stepIndicatorViewModel.currentStep + 1
        if (nextStep < self.stepIndicatorViewModel.steps.count) {
            self.stepIndicatorViewModel.steps[nextStep].stepIndicatorSegmentModel.isCompleted = true
            self.stepIndicatorViewModel.currentStep = nextStep
        }
    }
    
    func goToStep(_ step: AttStep) {
        let currentStepIndex = self.stepIndicatorViewModel.currentStep
        let nextStepIndex = step.stepOrder - 1
        
        guard currentStepIndex < nextStepIndex else { return }
        
        
        for n in currentStepIndex ..< nextStepIndex {
            self.stepIndicatorViewModel.steps[n].stepIndicatorSegmentModel.isCompleted = true
        }
        
        if (nextStepIndex < self.stepIndicatorViewModel.steps.count) {
            self.stepIndicatorViewModel.steps[nextStepIndex].stepIndicatorSegmentModel.isCompleted = true
            self.stepIndicatorViewModel.currentStep = nextStepIndex
        }
    }
    
    func goToPreviousStep() {
        let previousStep = self.stepIndicatorViewModel.currentStep - 1
        if (previousStep >= 0) {
            self.stepIndicatorViewModel.steps[self.stepIndicatorViewModel.currentStep].stepIndicatorSegmentModel.isCompleted = false
            self.stepIndicatorViewModel.currentStep = previousStep
        }
        
    }
    
    func restart() {
        self.stepIndicatorViewModel.currentStep = 0
        for step in self.stepIndicatorViewModel.steps {
            step.stepIndicatorSegmentModel.isCompleted = false
        }
        
        self.stepIndicatorViewModel.steps[self.stepIndicatorViewModel.currentStep].stepIndicatorSegmentModel.isCompleted = true
        
    }

}

class AttStepIndicatorViewModel: ObservableObject {
    var title: String 
    @Published var steps: [AttStepIndicatorSegmentView]
    @Published var currentStep: Int = 0
    
    init(steps: [AttStepIndicatorSegmentView], title: String, currentStep: Int = 0) {
        self.steps = steps
        self.title = title
        self.currentStep = currentStep
    }
}

struct AttStepIndicator_Previews: PreviewProvider {
    static var previews: some View {
        AttStepIndicatorView(stepIndicatorViewModel: AttStepIndicatorViewModel(
            steps: AttMockViewModal.getStepIndicatorSteps(),
            title: "Title"
        )
        )
    }
}

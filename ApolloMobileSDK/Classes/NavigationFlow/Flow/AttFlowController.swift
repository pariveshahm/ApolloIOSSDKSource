//  FlowController.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/14/20.
//  Edited by Shak4l XX/XX/21.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import SwiftUI

class AttFlowController: UIViewController {
    
    ///data shared between flow steps
    var flowData: AttFlowData
    
    ///dictionary of all step views
    var steps: [String: AttStep] = [:]
    
    var flowTitle: String {
        didSet {
            self.stepIndicatorView?.stepIndicatorViewModel.title = flowTitle
        }
    }
    
    ///initial step in the flow
    public var firstStep: String
    
    ///navigation controller responsible for pushing and popping flow steps
    var stepsStack = UINavigationController(nibName: nil, bundle: nil)
    
    ///view holder for step content
    var stepContent: UIView!
    
    ///view holder for step indicator component
    var stepIndicatorViewHolder: UIView!
    var stepIndicatorViewHolderHeightConstraint: NSLayoutConstraint!
    let stepIndicatorViewHolderHeight: CGFloat = UIDevice().hasNotch ? 147.0 : 92.0
    let topConstant: CGFloat = UIDevice().hasNotch ? -62 : -20
    
    ///step indicator component
    var stepIndicatorView: AttStepIndicatorView?
    var stepIndicatorViewModel: AttStepIndicatorViewModel
    
    /**
     Flow controller initializer. Accepts name of the first step in the flow that will be automatically shown.
     */    
    init(firstStep: String, flowData: AttFlowData = AttFlowData(), flowTitle: String) throws {
        do {
            self.firstStep = firstStep
            self.flowData = flowData
            self.flowTitle = flowTitle
            self.stepIndicatorViewModel = AttStepIndicatorViewModel(steps: [], title: flowTitle)
            super.init(nibName: nil, bundle: nil)
            setupUI()
            try goToStep(name: firstStep)
        } catch let error as AttSDKError {
            throw error
        }
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addStep(step: AttStep){
        self.steps[step.name] = step
        stepIndicatorViewModel.steps.append(AttStepIndicatorSegmentView(id: step.stepOrder, stepIndicatorSegmentModel: AttStepIndicatorSegmentModel(title: step.name, showNavigationBar: step.showNavigationBar, isCompleted: false)))
    }
    
    /**
     Push step with provided name on top of the navigation stack and updates step indicator.
     */
    func goToStep(name: String) throws {
        if var step = steps[name] {
            
            if step.showStepIndicator && step.stepOrder != 1 {
                stepIndicatorView?.goToStep(step)
            }
            
            showStepIndicator(step.showStepIndicator)
            
            let hostingVC = AttStepViewController(step: &step, flowData: &self.flowData)
            
            stepsStack.setNavigationBarHidden(true, animated: false)
            stepsStack.navigationBar.isHidden = true
            stepsStack.isNavigationBarHidden = true
            hostingVC.hideAttNavigationBar()
            
            stepsStack.view.backgroundColor = AttAppTheme.attSDKBackgroundColor.uiColor()
            stepsStack.navigationController?.view.backgroundColor = AttAppTheme.attSDKBackgroundColor.uiColor()
            
            stepsStack.pushViewController(hostingVC, animated: true)
            
        } else {
            throw AttSDKError.unknownStepError("Unknown step \(name)")
        }
    }
    
    func goToPreviousStep() {
        stepsStack.popViewController(animated: true)
        
        //get next step that will be shown and if necessary hide step indicator
        if let previousVC = stepsStack.viewControllers.last as? AttStepViewController {
            let previousStep = previousVC.step
            showStepIndicator(previousStep?.showStepIndicator ?? true)
        }
        
        stepIndicatorView?.goToPreviousStep()
    }
    
    func restartFlow() {
        stepsStack.popToRootViewController(animated: true)
        stepIndicatorView?.restart()
        showStepIndicator(false)
    }
    
    /**
     Creates view holders for step indicator and content and set auto layout constraints.
     */
    func setupUI() {
        stepIndicatorView = AttStepIndicatorView(stepIndicatorViewModel: stepIndicatorViewModel)

        createViewsAndConstraints()
        addStepIndicator()
        addStepContent()
    }
    
    func createViewsAndConstraints() {
        setupStepIndicatorViewAndConstraints()
        setupStepContentViewAndConstraints()
    }

    func addStepIndicator() {
        let hostingVC = UIHostingController(rootView: stepIndicatorView)

        let navVC = UINavigationController(rootViewController: hostingVC)
        navVC.navigationBar.isHidden = true
        navVC.view.frame = stepIndicatorViewHolder.bounds

        addChild(navVC)
        self.stepIndicatorViewHolder.addSubview(navVC.view)
        navVC.didMove(toParent: self)
    }
    
    func addStepContent() {
        stepsStack.view.frame = stepContent.bounds
        addChild(stepsStack)
        self.stepContent.addSubview(stepsStack.view)
        stepsStack.didMove(toParent: self)
        
    }
    
    func presentAddressValidationDialog(onConfirmCallback: @escaping (AttAddress) -> (), addresses: [AttAddress]) {
        let validateAddressView = AttAddressValidationDialog(
            addresses: addresses,
            onConfirm: { address in
                onConfirmCallback(address)
                self.dismiss(animated: false)
            },
            onCancel: {
                self.dismiss(animated: false)
            })

        let hostingVC = UIHostingController(rootView: validateAddressView)
        hostingVC.modalPresentationStyle = .overCurrentContext
        hostingVC.view.backgroundColor = .clear
        self.present(hostingVC, animated: false)
    }
    
    fileprivate func setupStepIndicatorViewAndConstraints() {
        stepIndicatorViewHolder = UIView()
        stepIndicatorViewHolder.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stepIndicatorViewHolder)
        stepIndicatorViewHolderHeightConstraint = stepIndicatorViewHolder.heightAnchor.constraint(equalToConstant: stepIndicatorViewHolderHeight)
        NSLayoutConstraint.activate([
            stepIndicatorViewHolder.topAnchor.constraint(equalTo: view.topAnchor, constant: topConstant),
            stepIndicatorViewHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stepIndicatorViewHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stepIndicatorViewHolderHeightConstraint
        ])
    }
    
    fileprivate func setupStepContentViewAndConstraints() {
        stepContent = UIView()
        stepContent.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stepContent)
        
        NSLayoutConstraint.activate([
            stepContent.topAnchor.constraint(equalTo: stepIndicatorViewHolder.bottomAnchor, constant: 0),
            stepContent.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stepContent.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: UIDevice().hasNotch ? 34 : 0),
            stepContent.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    //TODO: For now step indicator steps are hard coded, need to figure out how to dynamically update them
    func setupStepIndicatorSteps() -> AttStepIndicatorViewModel {
        
        var steps:[AttStepIndicatorSegmentView] = []
        for (key, value) in self.steps {
            steps.append(AttStepIndicatorSegmentView(id: value.stepOrder, stepIndicatorSegmentModel: AttStepIndicatorSegmentModel(title: key, showNavigationBar: value.showNavigationBar, isCompleted: false)))
        }
        
        steps.sort{ $0.id < $1.id}
        
        let stepIndicatorModel = AttStepIndicatorViewModel(steps: steps, title: "transaction_summary_step_name_prepaid".localized())
        return stepIndicatorModel
    }
    
    func showStepIndicator(_ show: Bool) {
        stepIndicatorViewHolder.isHidden = !show
        stepIndicatorViewHolderHeightConstraint.constant = show ? stepIndicatorViewHolderHeight : 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideAttNavigationBar()
        
        self.view.backgroundColor = AttAppTheme.attSDKBackgroundColor.uiColor()
        self.parent?.view.backgroundColor = AttAppTheme.attSDKBackgroundColor.uiColor()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hideAttNavigationBar()
    }

}

protocol ShowStepIndicator {
    func showStepIndicator(_ show: Bool)
    func goToNextStep()
    func goToPreviousStep()
    func restartStepIndicator()
}

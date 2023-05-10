//  AttDashboardView.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 18/01/2021.

import SwiftUI

public struct AttDashboardView: View {
    
    // - State
    @ObservedObject
    private var widgetModel = AttWidgetViewModel()
    weak var navigationDelegate: AttNavigationDelegate?

    @ObservedObject
    private var creditCardViewModel = AttCreditCardInfoViewModel()
    
    @State
    private var refresh = AttRefreshModel(started: false, released: false)
    @ObservedObject var productListViewModel = AttProductListViewModel()
    @State
    private var openAlert = false
    
    @State
    private var isViewVisible = false
    
    @State
    var type: AttDashboardType = .normal
    
    // - Properties
    var onBack:     (() -> Void)?
    var onShowOEM:     () -> Void
    var onShowHotspot: () -> Void
    var onShowHistory: () -> Void
    var exitFromSdk: () -> Void
    var showLegalAndRegulatory: () -> Void
    var showViewPaymentProfile: () -> Void
    
    // - Init
    public init(
        type: AttDashboardType = AttDashboardType.normal,
        onBack: (() -> Void)?,
        onShowOEM: @escaping     () -> Void = { },
        onShowHotspot: @escaping () -> Void = { },
        onShowHistory: @escaping () -> Void = { },
        exitFromSdk: @escaping     () -> Void = { },
        showLegalAndRegulatory: @escaping () -> Void = { },
        showViewPaymentProfile: @escaping () -> Void = { }
    ) {
        self.onBack = onBack
        self.onShowOEM = onShowOEM
        self.onShowHotspot = onShowHotspot
        self.onShowHistory = onShowHistory
        self.exitFromSdk = exitFromSdk
        self.showLegalAndRegulatory = showLegalAndRegulatory
        self.showViewPaymentProfile = showViewPaymentProfile
    }
    
    private func normalView() -> some View {
        AttNavigationBarView<AnyView, AnyView>(titleText: "dashboard_title".localized(), backgroundColor: AttAppTheme.attSDKDashboardBackgroundColor, contentView: {
                AnyView(
                    ScrollView {
                        
                        if !(widgetModel.showError || widgetModel.showAuthenticationError || widgetModel.showSubscriptionError || widgetModel.isVehicleNonEligible || widgetModel.isNewUser || widgetModel.showLoading) {
                            refreshView()

                            // - Pull tu refresh
                            if refresh.started && refresh.released {
                                AttActivityIndicatorSmall().offset(y: -5)
                            }
                            Spacer().frame(height: 10)
                            // - HeaderView
                            AttHeaderView()
                                .padding(.horizontal)
                                .background(Color.clear)
                        }
                        Spacer().frame(height: 0)
                        
                        AttDashboardPlan(model: widgetModel, navigationDelegate: navigationDelegate)
                        
                        
                        if !(widgetModel.showError || widgetModel.showAuthenticationError || widgetModel.showSubscriptionError || widgetModel.isVehicleNonEligible || widgetModel.isNewUser || widgetModel.showLoading) {
                            // - Actions
                            if ApolloSDK.current.getIsHotspotSetupGuideButtonVisible() {
                                VStack(spacing: 10) {
                                    Spacer().frame(height: 10)
                                    
                                    Button(ApolloSDK.current.getHotspotSetupGuideButtonText(), action: onShowHotspot)
                                        .buttonStyle(AttSecondaryButtonStyle(backgroundColor: Color.clear))
                                    Spacer().frame(height: 20)
                                }.padding([.horizontal], 30)
                            }
                            
                            dashboardHistoryGroup()
                        }
                    }.background(AttAppTheme.attSDKDashboardBackgroundColor)
                        .offset(y: refresh.released ? 20 : 0)
                )
            }, onBack: self.onBack).navigationBarHidden(true)
    }
    
    private func dashboardHistoryGroup() -> some View {
        Group {
            // - Order history
            AttDashboardHistory(dashboardResult: $widgetModel.dashboardResult, onShowHistory: onShowHistory, isLoading: widgetModel.isLoading).padding(.horizontal)
            
            Spacer().frame(height: 20)
            
            Group {
                paymentAndSubscriberInformationView()
                settingsAndHelpView()

                VStack(alignment: .center, spacing: 20) {
                    AttDashboardRide()
                        .padding(.horizontal)
                }
                
                Spacer().frame(height: 20)
            }
        }
    }
    private func paymentAndSubscriberInformationView() -> some View {
        Group {
            // - Payment profile
            if (creditCardViewModel.otherError){
                //No payment view
            } else {
                AttPaymentProfileView(viewModel: creditCardViewModel, onViewPaymentProfile: {showViewPaymentProfile()}).onAppear(perform: {
                    self.creditCardViewModel.fetchCreditCard { creditCard in }
                })
                .padding(.horizontal)
                
                Spacer().frame(height: 20)
            }

        }
    }
    private func settingsAndHelpView() -> some View {
        Group {
            // - Settings
            AttDashboardSettings(
                viewModel: widgetModel,
                onCancel: { openAlert.toggle() },
                onLegalAndRegulatory: {
                    showLegalAndRegulatory()
                }
            )
            .padding(.horizontal)
            
            Spacer().frame(height: 20)
            
            // - Help
            AttDashboardHelp()
                .padding(.horizontal)
            
            Spacer().frame(height: 20)
            
        }
    }
    private func refreshView() -> some View {
        GeometryReader { proxy -> Color in
            // GeometryReader can cause crash if it is called
            guard isViewVisible else { return .clear }
            
            DispatchQueue.main.async {
                
                if refresh.startOffset == 0 {
                    refresh.startOffset = proxy.frame(in: .global).minY
                }
                
                refresh.offset = proxy.frame(in: .global).minY
                
                // - Check if user passed the treshold of 70 to start refresh
                if refresh.hasStarted {
                    refresh.started = true
                }
                
                // - Check if refresh started and drag was released
                if refresh.shouldUpdate {
                    AttSubscriptionsServices.shared.resetClientSessionData()
                    AttDashboardServices.shared.clientSessionId = UUID.init().uuidString
                    updateData()
                    withAnimation(.linear) { refresh.released = true }
                }
            }
            
            return .clear
        }
        .frame(width: 0, height: 0)
        .background(Color.clear)
    }
    
    private func errorView() -> some View {
        AttNavigationBarView<AnyView, AnyView>(titleText: "dashboard_title".localized(), backgroundColor: AttAppTheme.attSDKBackgroundColor, contentView: {
            AnyView(
                ScrollView {
                    GeometryReader { proxy -> Color in
                        // GeometryReader can cause crash if it is called
                        guard isViewVisible else { return .clear }
                        
                        DispatchQueue.main.async {
                            
                            if refresh.startOffset == 0 {
                                refresh.startOffset = proxy.frame(in: .global).minY
                            }
                            
                            refresh.offset = proxy.frame(in: .global).minY
                            
                            // - Check if user passed the treshold of 70 to start refresh
                            if refresh.hasStarted {
                                refresh.started = true
                            }
                            
                            // - Check if refresh started and drag was released
                            if refresh.shouldUpdate {
                                updateData()
                                withAnimation(.linear) { refresh.released = true }
                            }
                        }
                        
                        return .clear
                    }
                    .frame(width: 0, height: 0)
                    .background(Color.clear)
                    
                    // - Pull tu refresh
                    if refresh.started && refresh.released {
                        AttActivityIndicatorSmall().offset(y: -5)
                    }
                    // - Widget
                    
                    AttDashboardPlan(model: widgetModel, navigationDelegate: navigationDelegate)
                    
                    
                }
                    .offset(y: refresh.released ? 20 : 0)
            )
        }, onBack: self.onBack).navigationBarHidden(true)
    }
    
    private func learnMoreView() -> some View {
        AttNavigationBarView<AnyView, AnyView>(titleText: "dashboard_title".localized(), backgroundColor: AttAppTheme.attSDKBackgroundColor, contentView: {
            AnyView(
                ScrollView {
                    GeometryReader { proxy -> Color in
                        // GeometryReader can cause crash if it is called
                        guard isViewVisible else { return .clear }
                        
                        DispatchQueue.main.async {
                            
                            if refresh.startOffset == 0 {
                                refresh.startOffset = proxy.frame(in: .global).minY
                            }
                            
                            refresh.offset = proxy.frame(in: .global).minY
                            
                            // - Check if user passed the treshold of 70 to start refresh
                            if refresh.hasStarted {
                                refresh.started = true
                            }
                            
                            // - Check if refresh started and drag was released
                            if refresh.shouldUpdate {
                                updateData()
                                withAnimation(.linear) { refresh.released = true }
                            }
                        }
                        
                        return .clear
                    }
                    .frame(width: 0, height: 0)
                    .background(Color.clear)
                    
                    // - Pull tu refresh
                    if refresh.started && refresh.released {
                        AttActivityIndicatorSmall().offset(y: -5)
                    }
                    // - Widget
                    
                    AttDashboardPlan(model: widgetModel, navigationDelegate: navigationDelegate)
                    
                    
                }
                    .offset(y: refresh.released ? 20 : 0)
            )
        }, onBack: self.onBack).navigationBarHidden(true)
    }

    public var body: some View {
        ZStack {
            AttAppTheme.attSDKDashboardBackgroundColor
                .edgesIgnoringSafeArea(.all)
            
            switch type {
            case .normal:
                    normalView()
                case .error:
                    errorView()
                case .learnMore:
                    learnMoreView()
            }
            
            if openAlert {
                AttCancelSubscriptionView(open: $openAlert)
            }
        }.onAppear { isViewVisible = true }
            .onDisappear { isViewVisible = false }
            .navigationBarHidden(true)
    }
    
    func updateData() {
        AttSubscriptionsServices.shared.resetClientSessionData()
        widgetModel.setViewActive()
        widgetModel.noDataPlan = false
        ApolloSDK.current.setDelegate(self)
        widgetModel.loadData(checkCached: false)
    }
}

extension AttDashboardView: ApolloSDKDelegate {
    public func vinStateUpdated(vehicleAvailability: String) {
        ApolloSDK.current.setDelegate(nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.linear) {
                refresh.released = false
                refresh.started  = false
            }
        }
    }
    
    public func openHotspotSetupGuide() {
        ApolloSDK.current.setDelegate(nil)
    }
    
    public func exitFromSDKListener() {
        ApolloSDK.current.setDelegate(nil)
    }
}
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        AttDashboardView(onBack: {})
    }
}

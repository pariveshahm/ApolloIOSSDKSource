//  RemoteView.swift
//  FCAExample
//
//  Created by Selma Suvalija on 7/2/20.
//  Copyright © 2020 CocoaPods. All rights reserved.

import SwiftUI
import ApolloMobileSDK

struct RemoteView: View {

    var model: AttWidgetViewModel
    var carImage: String
    weak var navigationDelegate: AttNavigationDelegate?
    
    @State
    public var buttonClickType : AttButtonClickType = AttButtonClickType.Connectivity
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            Spacer().frame(height: 32)
            
//            AttWidgetRepresentable(onDashboard: false, navigationDelegate: self.navigationDelegate, model: self.model, screenType: .homePage).getRootView()
//                .padding(.horizontal, model.horizontalPadding)
//                .padding(.vertical, model.verticalPadding)
//                .environmentObject(model)
            
            Image(carImage)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
            
            createInvokeButtons()
            
            HStack(spacing: 80) {
                ItemView(imageName: "lock.fill", title: "lock".localized())
                ItemView(imageName: "lock.open.fill", title: "unlock".localized())
            }
            Spacer().frame(height: 30).background(Color.red)
            
            Divider().padding([.leading, .trailing], 20)
            
            HStack(spacing: 80) {
                ItemView(imageName: "arrow.clockwise", title: "start".localized())
                ItemView(imageName: "arrow.clockwise", title: "cancel_service_modal_cancel".localized(), additionalImage: true, additionalImageName: "xmark")
            }
            Spacer().frame(height: 30)
            
            Divider().padding([.leading, .trailing], 20)
        }
        .background(Color.clear)
        .frame(maxWidth: .infinity)
        
    }
    
    private func createInvokeButtons() -> AnyView {
        return AnyView(VStack(spacing: 20) {
            Button("invoke_trial_screen".localized()) {startTrial()}.buttonStyle(AttPrimaryButtonStyle())
            Button("invoke_available_plans".localized()) {startPurchaseWifi()}.buttonStyle(AttPrimaryButtonStyle())
            Button("invoke_vehicle_availability".localized()) {getVehicleAvailability()}.buttonStyle(AttPrimaryButtonStyle())
            Button("switch_vehicle".localized()) {switchVehicleExample()}.buttonStyle(AttPrimaryButtonStyle())
            Button("Connectivity") {getConnectivity()}.buttonStyle(AttPrimaryButtonStyle())
        }.padding(.horizontal, 16))
    }

    private func getConnectivity() {
        buttonClickType = AttButtonClickType.Connectivity
        ApolloSDK.current.setDelegate(self)

        // present loader screen
        showLoader()
        let viewModel = AttWidgetViewModel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            viewModel.getConnectivityData()
        }
        
    }
    private func invokeTrialScreen() {
        guard let navigationDelegate = navigationDelegate else { return }
        ApolloSDK.current.startTrialFlow(presentationDelegate: navigationDelegate, failure: { error in
        })
    }
    
    private func startTrial() {
        showLoader()
        guard let navigationDelegate = navigationDelegate else { return }
        ApolloSDK.current.startTrialFlow(presentationDelegate: navigationDelegate, failure: { error in })
    }
    
    private func startPurchaseWifi() {
        guard let navigationDelegate = navigationDelegate else { return }
        ApolloSDK.current.startPrepaidFlow(presentationDelegate: navigationDelegate, failure: { error in })
    }
    private func openActiveDashboard(){
        guard let navigationDelegate = navigationDelegate else { return }
        ApolloSDK.current.goToDashboard(presentationDelegate: navigationDelegate, failure: { error in })
    }
    private func openNoDataPlanDashboard(){
        guard let navigationDelegate = navigationDelegate else { return }
        ApolloSDK.current.goToDashboardNoDataPlan(presentationDelegate: navigationDelegate, failure: { error in })
    }
    private func openDashboard(){
        guard let navigationDelegate = navigationDelegate else { return }
        ApolloSDK.current.showError(presentationDelegate: navigationDelegate, failure: { error in })
    }
    
    private func showLoader() {
        guard let navigationDelegate = navigationDelegate else { return }
        ApolloSDK.current.showLoading(presentationDelegate: navigationDelegate, failure: { error in })
    }
    private func hideLoader() {
        guard let navigationDelegate = navigationDelegate else { return }
        ApolloSDK.current.hideLoading(presentationDelegate: navigationDelegate)
    }
    private func showLearnMoreWidget(){
        guard let navigationDelegate = navigationDelegate else { return }
        ApolloSDK.current.showLearnMoreWidget(presentationDelegate: navigationDelegate, failure: { error in })
    }
    private func getVehicleAvailability() {
        buttonClickType = AttButtonClickType.InvokeVehicleAvailability
        ApolloSDK.current.setDelegate(self)
        
        let viewModel = AttWidgetViewModel()
        viewModel.getAvailabilityData()
    }
    
    private func switchVehicleExample() {
        // set the values here
        model.resetAllCacheData()
        ApolloSDK
            .current
            .vin("F021660HONERM4851")
            .accessToken("eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyaG5uclFjQW5ieTRLb3FUWV9FM0k3LTRiTWxnZjZjb0gzazJWWjg4T2ZzIn0.eyJleHAiOjE2NjMxNzYyNTUsImlhdCI6MTY2MzE2OTA1NSwianRpIjoiNjMyZmMwYTAtZGY5Yy00NmFkLWI5MmUtZjM2YmFhM2Q5NGEwIiwiaXNzIjoiaHR0cHM6Ly9teXZlaGljbGUtcWMuc3RhZ2UuYXR0LmNvbS9hdXRoL3JlYWxtcy9pb3RhLWN2Yy1vcGVuaWQtcmVhbG0iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjo5NGE0NDY2OC05YzZmLTRlMjEtOWQ5NC1hMTk2NjI5YjM4ZDU6NWQyYWU3OTktMDljNi00YjYyLTkxY2ItNjQ3OGU2NjIyNjE1IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiaW90LWN2Yy1vcGVuaWQtY2xpZW50LXFjIiwic2Vzc2lvbl9zdGF0ZSI6ImNhYzAwMDBmLTBjNjYtNGZhYi04MTlhLWVlYWU2MTk1ZThjNiIsImFjciI6IjEiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoib3BlbmlkIGVtYWlsIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJlbWFpbCI6Im5lcm1pbnNhQG1hZXN0cmFsc29sdXRpb25zLmNvbSJ9.PCTVh9RoRzzoxeRJ8ieCleu5-rRdje5mOSOUlH-nyRlECxL30E8b9PgQ5eCl2IRKqhuumW2csNrqIQF9OWs3Cxz6UI4wGCxSzG3pcW5HJH0NLdtbiourX491eYF1PaewpF3y0ueDlmQw9A1YtgaSMzsAIfScyUb3ql1OauZOgVNI4OtT2fRNoCr_ijjNjre_ACHYT41bUGzjhW19u4Gvqn8n0GfkAGGv4LYa85UxPxcd2-GEQ5IMk1m0teEZFmEiTT0RA6qWvh0gvMFxuwm2K-8eHxMyCUhgHgrJp4k_NzlJx2i7VV3XfDMjaX789PBGDStojaqUBC1JM58WmTLaKQ")
            .build()

        // reload the widget
        model.setViewActive()
        model.loadData()
    }
}

extension RemoteView: ApolloSDKDelegate {
        func vinStateUpdated(vehicleAvailability: String) {
            ApolloSDK.current.setDelegate(nil)
            
            switch(buttonClickType) {
                
            case .Connectivity:
                switch vehicleAvailability {
                    case "vehicleHasDataPlan":
                        openActiveDashboard()
                    case "vehicleNotEligible":
                        openDashboard()
                    case "vehicleTrialEligible":
                        invokeTrialScreen()
                    case "vehicleNoDataPlan":
                        openNoDataPlanDashboard()
                    case "vehicleNonTrialEligible":
                        openDashboard()
                    case "error":
                        openDashboard()
                    case "unableToProcessError":
                        openDashboard()
                    case "invalidTokenError":
                        openDashboard()
                case "userNotPermittedError":
                    openDashboard()
                    default:
                        openDashboard()
                }
            case .InvokeVehicleAvailability:
                switch vehicleAvailability {
                    case "vehicleHasDataPlan":
                        print("vehicleHasDataPlan")
                    case "vehicleNotEligible":
                        print("vehicleNotEligible")
                    case "vehicleTrialEligible":
                        print("vehicleTrialEligible")
                    case "vehicleNonTrialEligible":
                        print("vehicleNonTrialEligible")
                    case "error":
                        print("Error")
                    case "vehicleNoDataPlan":
                        print("vehicleNonTrialEligible")
                    case "unableToProcessError":
                        print("unableToProcessError")
                    case "invalidTokenError":
                        print("invalidTokenError")
                    case "userNotPermittedError":
                        print("userNotPermittedError")
                    default:
                         print("")
                }
            }
        }
    
    func openHotspotSetupGuide() {
        ApolloSDK.current.setDelegate(nil)
    }
    
    func exitFromSDKListener(){
        ApolloSDK.current.setDelegate(nil)
    }
}

struct ItemView: View {
    var imageName = "lock.fill"
    var title = "lock".localized()
    var additionalImage: Bool = false
    var additionalImageName = "xmark"
    var body: some View {
        VStack {
            ZStack {
                Image(systemName: "circle").font(.system(size: 90, weight: .ultraLight)).frame(width: 100, height: 100).foregroundColor(AttAppTheme.primaryColor)
                Image(systemName: imageName).font(.system(size: 35, weight: .ultraLight)).frame(width: 100, height: 100).foregroundColor(AttAppTheme.primaryColor)
                (additionalImage ? Image(systemName: additionalImageName).font(.system(size: 15, weight: .light)).frame(width: 100, height: 100).foregroundColor(AttAppTheme.primaryColor).offset(y: 8) : nil)
            }
            Text(title)
        }
        
    }
}

struct RemoteView_Previews: PreviewProvider {
    static var previews: some View {
        RemoteView(model: AttWidgetViewModel(), carImage: "jeep-gladiator", navigationDelegate: nil)
    }
}

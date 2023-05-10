//  DashboardPlan.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 18/01/2021.

import SwiftUI

struct AttDashboardPlan: View {
    
    @ObservedObject
    var model: AttWidgetViewModel
    weak var navigationDelegate: AttNavigationDelegate?
    
    var body: some View {
        VStack {
            createWidgetView()
                .padding(.horizontal)
                .environmentObject(model)
        }
        .padding(.vertical)
        .background(Color.clear)
        .onAppear(perform: {
            model.setViewActive()
        }).onDisappear(perform: {
            model.setViewInactive()
        })
    }
    
    private func createWidgetView() -> AnyView {
        let representable = AttWidgetRepresentable(onDashboard: true, navigationDelegate: self.navigationDelegate, model: model, screenType: .dashboard)
        return representable.getRootView()
    }
}

// - Views
struct AttHeaderView: View {
    var body: some View {
        HStack {
            Text("active_plan_catrd_title".localized())
                .lineLimit(nil)
                .font(.custom(ApolloSDK.current.getMediumFont(), size: 13))
                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
            
            Spacer()
            
            Text("active_plan_swipe_to_refresh_title".localized().uppercased())
                .lineLimit(nil)
                .multilineTextAlignment(.trailing)
                .fixedSize(horizontal: false, vertical: true)
                .font(.custom(ApolloSDK.current.getMediumFont(), size: 13))
                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor.opacity(0.6))
        }
    }
}

struct AttDashboardPlan_Previews: PreviewProvider {
    static var previews: some View {
        AttDashboardPlan(model: .init())
    }
}

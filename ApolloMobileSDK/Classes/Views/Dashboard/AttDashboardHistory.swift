//  DashboardHistory.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 18/01/2021.

import SwiftUI

struct AttDashboardHistory: View {

    @Binding
    var dashboardResult: AttDashboardResponse?
    var onShowHistory: () -> Void
    // - State
    @State private var expand = false
    var isLoaded: Bool = true
  
    var isLoading: Bool = true
    var body: some View {
        let content = loadSubscriptions()
        let firstItem = getFirstItem()
        
        
        if(isLoading) {
            let emptyWidget = AttEmptyWidget(screenType: .orderHistory)
            return AnyView(emptyWidget)
        } else {
            return AnyView(ZStack {
                if firstItem == nil {
                    AttCollapseMenu(
                        isLoaded: firstItem != nil,
                        title: "order_history_title".localized(),
                        footnote: "no_purchase_order_history".localized(),
                        content: content.map { $0.padding(.horizontal) }
                )
            } else {
                VStack {
                    //firstItem?.status == AttSubscription.SubscriptionStatus.none ? nil : getFootnote(),
                    // - Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("order_history_title".localized())
                                .font(.custom(ApolloSDK.current.getBoldFont(), size: 18))
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                            if firstItem?.status == .stacked {
                                HStack(alignment: .top, spacing: 5) {
                                    Circle()
                                        .foregroundColor(AttAppTheme.yellowCircleColor)
                                        .frame(width: 11, height: 11)
                                        .padding(3)
                                    Text("status_pending_pill".localized())
                                        .font(.custom(ApolloSDK.current.getBoldFont(), size: 11))
                                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding(1)
                                    
                                    Text(" | ")
                                        .font(.custom(ApolloSDK.current.getMediumFont(), size: 11))
                                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    Text("\((firstItem?.status == AttSubscription.SubscriptionStatus.none ? nil : getFootnote()) ?? "")")
                                        .font(.custom(ApolloSDK.current.getMediumFont(), size: 11))
                                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            } else if firstItem?.status == .active || firstItem?.status == .depleted {
                                HStack(alignment: .top, spacing: 5) {
                                    Circle()
                                        .foregroundColor(.green)
                                        .frame(width: 11, height: 11)
                                        .padding(3)
                                    Text("order_history_active_status".localized())
                                        .font(.custom(ApolloSDK.current.getBoldFont(), size: 11))
                                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    Text(" | ")
                                        .font(.custom(ApolloSDK.current.getMediumFont(), size: 11))
                                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    Text("\((firstItem?.status == AttSubscription.SubscriptionStatus.none ? nil : getFootnote()) ?? "")")
                                        .font(.custom(ApolloSDK.current.getMediumFont(), size: 11))
                                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        if isLoaded {
                            if !content.isEmpty {
                                Image(systemName: expand ? "chevron.up" : "chevron.down")
                                    .foregroundColor(AttAppTheme.primaryColor)
                                    .frame(width: 20, height: 20)
                            } else {
                                Image(systemName: "minus")
                                    .foregroundColor(AttAppTheme.primaryColor)
                                    .frame(width: 20, height: 20)
                            }
                        } else {
                            Image(systemName: expand ? "chevron.up" : "chevron.down")
                                .foregroundColor(AttAppTheme.primaryColor)
                                .frame(width: 20, height: 20)
                        }
                    }
                    .background(AttAppTheme.attSDKDashboardWidgetBackgroundColor)
                    .onTapGesture { expand.toggle() }
                    .padding()
                    
                    // - Content
                    if expand {
                        ForEach(content.indices, id: \.self) { index in
                            if index == 0 { Divider() }
                            VStack{
                                content[index]
                            }.padding(.horizontal, 20)
                            Divider()
                        }
                    }
                }
                .onAppear(perform: {
                    UISwitch.appearance().onTintColor = AttAppTheme.attSDKDashboardWidgetBackgroundColor.uiColor()
                })
                
                .background(AttAppTheme.attSDKDashboardWidgetBackgroundColor)
                .cornerRadius(cornerRadius)
                .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(borderColor, lineWidth: borderWidth))
                .shadow(color: AttAppTheme.shadowColor, radius: shadowRadius, x: 0, y: 0)
            }

        }.disabled(content.isEmpty))
        
        }
        
    }
    
    private func getFootnote() -> String? {
        guard let dashboardData = dashboardResult else { return nil}
        guard let items = dashboardData.items?.first?.subscriptions else { return nil}
        
        if let planName = items.last?.getName(){
            return String(format: "order_history_last_order".localized(), planName)
        }
        
        return nil
    }
    
    private func getFirstItem() -> AttSubscription? {
        guard let dashboardData = dashboardResult else { return nil}
        guard let items = dashboardData.items?.first?.subscriptions else { return nil}
        
        let firstActiveItem = items
            .filter{ $0.status != .stacked && $0.billingType != AttBillingType.none }
            .first{ $0.status == .active || $0.status == .depleted }
        
        let firstPendingItem = items
            .filter{ $0.status == .stacked && $0.billingType != AttBillingType.none }
            .sorted(by: { (getStartDate($0) > getStartDate($1)) })
            .first
        
        let firstItem = firstPendingItem ?? firstActiveItem
        
        return firstItem
    }
    
    private func loadSubscriptions() -> [AnyView] {
        var content: [AnyView] = []
        guard let _ = dashboardResult else { return []}
        let firstItem = getFirstItem()
        
        if var firstItem = firstItem  {
            var stringDate = "–"
            let startTime = firstItem.startTime
            if let startTime = startTime, let date =  AttDateUtils.convertISO8601(string: startTime){
                stringDate = getStartTime(date, item: firstItem)
            }
            
            if firstItem.billingType == .trial {
                firstItem.name = "trial_plan_order_history_card".localized()
            }
            
            let row = AttHistoryRow(
                title: firstItem.name ?? "–",
                subTitle: stringDate,
                badgeText: firstItem.status?.value().uppercased() ?? "–",
                detailText: "",
                badgeColor: (firstItem.status == .active || firstItem.status == .depleted) ? .green : AttAppTheme.pillButtonBackgroundColor,
                badgeTextColor: (firstItem.status == .active || firstItem.status == .depleted) ? .white: .black,
                hasPadding: false
            )
            
            content.append(AnyView(row))
        }
        
        content.append(AnyView(AttHistoryAction(title: "order_history_view_all".localized(), onClick: { onShowHistory() } )))
        
        return content
    }
    
    private func getStartTime(_ date: Date, item: AttSubscription) -> String {
        return (item.status == .active || item.status == .depleted) ?
        String(format: "order_history_activated_on".localized(), AttDateUtils.prettyFormatDate(date)) :
        String(format: "order_history_purchased_on".localized(), AttDateUtils.prettyFormatDate(date))
    }
    
    private func getEndDate(_ subscription: AttSubscription?) -> Date {
        let now = Date()
        return AttDateUtils.convertToShortDate(string: subscription?.recurrent?.endTime ?? "") ?? now
    }
    
    private func getStartDate(_ subscription: AttSubscription?) -> Date {
        let now = Date()
        return AttDateUtils.convertToShortDate(string: subscription?.recurrent?.startTime ?? "") ?? now
    }
    
}

private struct AttHistoryAction: View {
    
    var title: String
    var onClick: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom(.bold, size: 14))
                .foregroundColor(AttAppTheme.primaryColor)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .padding(.vertical)
            Spacer()
        }.onTapGesture(perform: onClick).frame(maxWidth: .infinity, alignment: .leading)
    }
    
}
extension AttDashboardHistory {

    
    var borderColor: Color {
        return AttAppTheme.attSDKDashboardWidgetBorderColor
    }
    
    var borderWidth: CGFloat {
        return AttAppTheme.attSDKDBorderWidth
    }
    
    var shadowRadius: CGFloat {
        return CGFloat(AttAppTheme.attSDKDashboardCardShadowElevation)
    }
    
    var backgroundColor: Color {
        return AttAppTheme.attSDKBlockBackgroundColor
    }
    
    var cornerRadius: CGFloat {
        return AttAppTheme.attSDKDashboardCardCornerRadius
    }
}
//struct AttDashboardHistory_Previews: PreviewProvider {
//    static var previews: some View {
//        AttDashboardHistory(dashboardResult: .failure(Error()), onShowHistory: { _ in }).padding()
//    }
//}

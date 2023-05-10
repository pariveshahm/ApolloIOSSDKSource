//  OrderHistory.swift
//  ApolloMobileSDK
//
//  Created by Shak4l on 13/02/2021.

import SwiftUI

struct AttOrderHistory: View {
    
    @State
    private var refresh = AttRefreshModel(started: false, released: false)
    @State
    private var isViewVisible = false
    @State
    var isLoading = false
    @State
    var showIndicator = true
    // - Properties
    @State
    var data: [[AttSubscriptionItem]] = []
    var onExit: () -> Void
    
    init(_ onExit: @escaping () -> Void) {
        self.onExit = onExit
       // self.data = sortSubscriptions(items)
    }
    
    var body: some View {
        AttNavigationBarView<AnyView, AnyView>(titleText: "order_history_title".localized(), backgroundColor: AttAppTheme.attSDKBackgroundColor, contentView: {
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
                            let hasStared = refresh.hasStarted
                            if hasStared {
                                refresh.started = true
                                isLoading = true
                            }
                            
                            // - Check if refresh started and drag was released
                            let shouldUpdate = refresh.shouldUpdate
                            if shouldUpdate {
                                AttOrdersService.shared.searchReceipt(msisdn: ApolloSDK.current.getMsisdn()) { (result) in
                                    switch (result) {
                                    case .success(let response):
                                        guard let items = response.items else { return }
                                        self.data = sortSubscriptions(items)
                                        resetRefreshState()
                                        self.showIndicator = false
                                    case .failure(_):
                                        print("ERROR")
                                    }
                                }
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
                    
                    Spacer().frame(height: 0)
                    ZStack {
                        if showIndicator == true {
                            VStack{
                                Spacer().frame(height: 300)
                                AttActivityIndicator()
                                Spacer()
                            }
                        } else {
                            if !isLoading {
                                // Pending
                                VStack{
                                    OrderList(title: "order_history_pending_title".localized(), orderState: .pending, data: data[0], noDataText: "order_history_no_pending".localized()).padding()
                                    OrderList(title: "order_history_past_orders_title".localized(), orderState: .past, data: data[1], noDataText: "order_history_no_past".localized()).padding()
                                }
                            }
                        }
                    }.onAppear(perform: {
                        fetchOrderData()
                    })
                    
                }.offset(y: refresh.released ? 20 : 0)
            )
        }, onBack: onExit).onAppear { isViewVisible = true }
            .onDisappear { isViewVisible = false }
    }
    
    private func resetRefreshState() {
        isLoading = false
        refresh.started = false
        refresh.released = false
    }
    private func fetchOrderData() {
        AttOrdersService.shared.searchReceipt(msisdn: ApolloSDK.current.getMsisdn()) { (result) in
            switch (result) {
            case .success(let response):
                guard let items = response.items else { return }
                self.data = sortSubscriptions(items)
                self.showIndicator = false
            case .failure(let error):
                print("ERROR")
            }
        }
    }
    private func sortSubscriptions(_ data: [AttSubscriptionItem]) -> [[AttSubscriptionItem]] {
        var items: [[AttSubscriptionItem]] = []
        
        let now = Date()
        // - Add pendings orders
        let pendingSubscriptions = data
            .filter({ (getEndDate($0.subscription) >= now) && ($0.subscription?.status == .stacked)})
            .sorted(by: { (getStartDate($0.subscription) < getStartDate($1.subscription)) })
        
        items.append(pendingSubscriptions)
        
        
        // - Add past orders
        var other = data
            .filter({ $0.subscription != nil && getEndDate($0.subscription) < now  })
            .sorted(by: { (getEndDate($0.subscription) > getEndDate($1.subscription)) })
        
        if let trialPlanIndex = other.firstIndex(where: { $0.payment?.method?.lowercased() == "trial" }) {
            other.remove(at: trialPlanIndex)
        }
        
        items.append(other)
        
        return items
    }
    
    private func getEndDate(_ subscription: AttSubscription?) -> Date {
        let now = Date()
        return AttDateUtils.convertToShortDate(string: subscription?.recurrent?.endTime ?? "") ?? now
    }
    
    private func getStartDate(_ subscription: AttSubscription?) -> Date {
        let now = Date()
        return AttDateUtils.convertToShortDate(string: subscription?.recurrent?.startTime ?? "") ?? now
    }
    
    private enum OrderState: String {
        case past
        case pending
    }
    
    private struct OrderList: View {
        
        var title: String?
        var orderState: OrderState
        var data: [AttSubscriptionItem]
        var noDataText: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                
                Text(title?.uppercased() ?? data[0].subscription!.status?.rawValue.uppercased() ?? "–")
                    .font(.custom(.medium, size: 13))
                
                ForEach(data.indices, id: \.self) { index -> AnyView in
                    let item = data[index].subscription
                    
                    var stringDate = "–"
                    if let recurrent = item?.recurrent {
                        stringDate = getDateTime(recurrent, orderState: orderState)
                    }
                    
                    return AnyView(
                        AttHistoryRow(
                            title: item?.name ?? "",
                            subTitle: stringDate,
                            badgeText: item?.status?.value().uppercased() ?? "–",
                            detailText:  "$" + (data[index].payment?.grandTotal?.amount ?? ""),
                            badgeColor: (item?.status == .some(.active) || item?.status == .some(.depleted)) ? .green : AttAppTheme.pillButtonBackgroundColor,
                            badgeTextColor: (item?.status == .some(.active) || item?.status == .some(.depleted)) ? .white: .black,
                            hasPadding: true
                        )
                            .background(AttAppTheme.attSDKDashboardWidgetBackgroundColor)
                            .cornerRadius(AttAppTheme.attSDKDashboardCardCornerRadius)
                            .shadow(color: AttAppTheme.shadowColor, radius: AttAppTheme.attSDKDashboardCardShadowElevation, x: 0, y: 0)
                    )
                }
                
                if data.isEmpty {
                    AnyView(
                        HStack {
                            Spacer()
                            Text(noDataText)
                                .font(.custom(ApolloSDK.current.getMediumFont(), size: 11))
                                .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                                .padding(10)
                            Spacer()
                        }
                            .background(Color.clear)
                    )
                }
            }
        }
        
        private func getDateTime(_ recurrent: AttRecurrent, orderState: OrderState) -> String {
            return (orderState == .pending) ?
            String(format: "order_history_purchased_on".localized(), AttDateUtils.prettyFormatDate(AttDateUtils.convertToShortDate(string: recurrent.startTime ?? "")!)) :
            String(format: "order_history_expired_on".localized(), AttDateUtils.prettyFormatDate(AttDateUtils.convertToShortDate(string: recurrent.endTime ?? "")!))
        }
    }
}
struct AttOrderHistory_Previews: PreviewProvider {
    static var previews: some View {
        AttOrderHistory({})
    }
}


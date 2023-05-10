//  AttWidgetView.swift
//  ATTORMRetailSDK
//
//  Created by Selma Suvalija on 07/12/2020.

import SwiftUI

/*
 Widgets
 - TrialAvailableWidget | Trial
 - ActivePlanWidget     | Current plan
 - ErrorWidget          | Error
 - NoPlanWidget         | No plan
 - AvailablePlanWidget  | Available plans
 - EmptyWidget          | Loader
 */

public struct AttWidgetView: View {

    @Environment(\.viewController) private var viewControllerHolder: UIViewController?

    // - State
    @ObservedObject var model: AttWidgetViewModel
    @ObservedObject var productListViewModel = AttProductListViewModel()
    private var dashboardView = AttDashboardView(onBack: { })
    // - Properties
    public var onActivateTrial: () -> Void       = {}
    public var onActivateDataPlan: () -> Void       = {}
    public var onShowDashboard: (() -> Void)? = nil
    var isForCellView: Bool = false
    var screenType: AttWidgetScreenType

    public init(model: AttWidgetViewModel, isForCellView: Bool = false, screenType: AttWidgetScreenType) {
        self.model = model
        self.isForCellView = isForCellView
        self.screenType = screenType
    }

    // - Body
    public var body: some View {
        VStack {
            loadWidgets()
        }
        .onAppear(perform: {
            model.loadData()
        })
    }

    private func loadWidgets() -> AnyView {
        
        if model.isLoading {
            let emptyWidget = AttEmptyWidget(screenType: screenType)
            return AnyView(emptyWidget)
        }

        // for testing purposes
        #if DEBUG
        if WidgetDebuggingFlags().showError {
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData()
                },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )
            print("WidgetDebuggingFlags().showError is ON")
            return AnyView(errorWidget)
        }
        #endif
        // for testing purposes
        #if DEBUG
        if ErrorDebuggingFlags().showMissingBilingTypeError && ErrorDebuggingFlags().showMissingSubscriberInfoError && ErrorDebuggingFlags().showMissingVehicleInfoError && ErrorDebuggingFlags().showMissingDeviceInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1001".localized() + ("\n") +
                "error_msg_1002".localized() + ("\n") +
                "error_msg_1003".localized() + ("\n") +
                "error_msg_1004".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData()
                },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if ErrorDebuggingFlags().showMissingBilingTypeError && ErrorDebuggingFlags().showMissingSubscriberInfoError && ErrorDebuggingFlags().showMissingVehicleInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1001".localized() + ("\n") + "error_msg_1002".localized() + ("\n") + "error_msg_1003".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData()
                },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if ErrorDebuggingFlags().showMissingBilingTypeError && ErrorDebuggingFlags().showMissingSubscriberInfoError && ErrorDebuggingFlags().showMissingDeviceInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1001".localized() + ("\n") + "error_msg_1002".localized() + ("\n") + "error_msg_1004".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData()
                },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if ErrorDebuggingFlags().showMissingBilingTypeError && ErrorDebuggingFlags().showMissingVehicleInfoError && ErrorDebuggingFlags().showMissingDeviceInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1001".localized() + ("\n") +
                "error_msg_1003".localized() + ("\n") +
                "error_msg_1004".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData()
                },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if ErrorDebuggingFlags().showMissingBilingTypeError && ErrorDebuggingFlags().showMissingSubscriberInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1001".localized() + ("\n") + "error_msg_1002".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData()
                },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if ErrorDebuggingFlags().showMissingBilingTypeError && ErrorDebuggingFlags().showMissingDeviceInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1001".localized() + ("\n") + "error_msg_1004".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData()
                },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if ErrorDebuggingFlags().showMissingBilingTypeError && ErrorDebuggingFlags().showMissingVehicleInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1001".localized() + ("\n") + "error_msg_1003".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData()
                },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if ErrorDebuggingFlags().showMissingBilingTypeError {
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1001".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData()
                },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }
        if ErrorDebuggingFlags().showMissingSubscriberInfoError && ErrorDebuggingFlags().showMissingVehicleInfoError && ErrorDebuggingFlags().showMissingDeviceInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1002".localized() + ("\n") + "error_msg_1003".localized() + ("\n") + "error_msg_1004".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData()
                },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if ErrorDebuggingFlags().showMissingSubscriberInfoError && ErrorDebuggingFlags().showMissingVehicleInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1002".localized() + ("\n") + "error_msg_1003".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData()
                },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if ErrorDebuggingFlags().showMissingSubscriberInfoError && ErrorDebuggingFlags().showMissingDeviceInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1002".localized() + ("\n") + "error_msg_1004".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData()
                },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if ErrorDebuggingFlags().showMissingSubscriberInfoError {
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1002".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }
        if ErrorDebuggingFlags().showMissingVehicleInfoError && ErrorDebuggingFlags().showMissingDeviceInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1003".localized() + ("\n") + "error_msg_1004".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if ErrorDebuggingFlags().showMissingBilingTypeError && ErrorDebuggingFlags().showMissingVehicleInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1001".localized() + ("\n") + "error_msg_1003".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if ErrorDebuggingFlags().showMissingVehicleInfoError {
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1003".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )
            return AnyView(errorWidget)
        }
        if ErrorDebuggingFlags().showMissingBilingTypeError && ErrorDebuggingFlags().showMissingDeviceInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1001".localized() + ("\n") + "error_msg_1004".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if ErrorDebuggingFlags().showMissingDeviceInfoError {
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1004".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }
        #endif

        // for testing purposes
        #if DEBUG
        if WidgetDebuggingFlags().showTrial {
            self.model.product = AttProduct(id: "", name: "", type: "", billingType: .trial)
            let trialAvailableWidget = AttTrialAvailableWidget(
                onLearnMore: onActivateTrial,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil,
                screenType: screenType
            )
            print("WidgetDebuggingFlags().showTrial is ON")
            return AnyView(trialAvailableWidget)
        }
        #endif

        // for testing purposes
        #if DEBUG
        if WidgetDebuggingFlags().showActivePlan {
            self.model.product = AttProduct(id: "", name: "", type: "", billingType: .prepaid)
            let activePlanWidget = AttActivePlanWidget(
                model: $model.subscription,
                onPurchase: onActivateDataPlan,
                onRefresh: { model.loadData() },
                onDashboard: onShowDashboard,
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )
            print("WidgetDebuggingFlags().showActivePlan is ON")
            return AnyView(activePlanWidget)
        }
        #endif

        // for testing purposes
        #if DEBUG
        if WidgetDebuggingFlags().showAvailablePlan {
            self.model.product = AttProduct(id: "", name: "", type: "", billingType: .postpaid)
            let availablePlanWidget = AttAvailablePlanWidget(
                onSeePlans: onActivateDataPlan,
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )
            print("WidgetDebuggingFlags().showAvailablePlan is ON")
            return AnyView(availablePlanWidget)
        }
        #endif

        // for testing purposes
        #if DEBUG
        if WidgetDebuggingFlags().showNoPlan {
            self.model.product = AttProduct(id: "", name: "", type: "", billingType: .postpaid)
            let noPlanWidget = AttNoPlanWidget(
                onPurchase: onActivateDataPlan,
                onDashboard: onShowDashboard,
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )
            print("WidgetDebuggingFlags().showNoPlan is ON")
            return AnyView(noPlanWidget)
        }
        #endif

        if model.showAuthenticationError {
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_2001".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }

        if model.showSubscriptionError {
            let errorWidget = AttErrorWidget(
                title: "unable_to_link_vehicle".localized(),
                message: String(format: "unable_to_link_your_profile".localized(), ApolloSDK.current.getHostName()),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                reloadButtonTitle: "contact_support".localized(),
                imageColor: AttAppTheme.yellowProgressBarColor,
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }

        if model.showError {
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1005".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }


        // dashboard errors
        var errorCodesString = ""

        if model.showMissingBilingTypeError && model.showMissingSubscriberInfoError && model.showMissingVehicleInfoError && model.showMissingDeviceInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1001".localized() + ("\n") + "error_msg_1002".localized() + ("\n") + "error_msg_1003".localized() + ("\n") + "error_msg_1004".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if model.showMissingBilingTypeError && model.showMissingSubscriberInfoError && model.showMissingVehicleInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1001".localized() + ("\n") + "error_msg_1002".localized() + ("\n") + "error_msg_1003".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if model.showMissingBilingTypeError && model.showMissingSubscriberInfoError && model.showMissingDeviceInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1001".localized() + ("\n") + "error_msg_1002".localized() + ("\n") + "error_msg_1004".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if model.showMissingBilingTypeError && model.showMissingVehicleInfoError && model.showMissingDeviceInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1001".localized() + ("\n") +
                "error_msg_1003".localized() + ("\n") +
                "error_msg_1004".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if model.showMissingBilingTypeError && model.showMissingSubscriberInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1001".localized() + ("\n") + "error_msg_1002".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if model.showMissingBilingTypeError && model.showMissingDeviceInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1001".localized() + ("\n") + "error_msg_1004".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if model.showMissingBilingTypeError && model.showMissingVehicleInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1001".localized() + ("\n") + "error_msg_1003".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if model.showMissingBilingTypeError {
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "1001 - Missing billing information.",
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }
        if model.showMissingSubscriberInfoError && model.showMissingVehicleInfoError && model.showMissingDeviceInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1002".localized() + ("\n") + "error_msg_1003".localized() + ("\n") + "error_msg_1004".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if model.showMissingSubscriberInfoError && model.showMissingVehicleInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1002".localized() + ("\n") + "error_msg_1003".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if model.showMissingSubscriberInfoError && model.showMissingDeviceInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1002".localized() + ("\n") + "error_msg_1004".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if model.showMissingSubscriberInfoError {
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "1002 - Missing email or address information.",
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }
        if model.showMissingVehicleInfoError && model.showMissingDeviceInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1003".localized() + ("\n") + "error_msg_1004".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if model.showMissingBilingTypeError && model.showMissingVehicleInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1001".localized() + ("\n") + "error_msg_1003".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if model.showMissingVehicleInfoError {
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "1003 - Missing vehicle information.",
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )
            return AnyView(errorWidget)
        }
        if model.showMissingBilingTypeError && model.showMissingDeviceInfoError{
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "error_msg_1001".localized() + ("\n") + "error_msg_1004".localized(),
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }else if model.showMissingDeviceInfoError {
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_load_data_title".localized(),
                message: "oem_widget_error_text".localized(),
                errorCode: "1004 - Missing device information.",
                onReload: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }

        // dashboard errors
        if model.isVehicleNonEligible {
            let errorWidget = AttErrorWidget(
                title: "oem_widget_error_can_not_register_title".localized(),
                message: "oem_widget_error_can_not_register_text".localized(),
                onSupport: {
                    self.viewControllerHolder?.present(style: .overFullScreen) {
                        AttCallSupportPopupView()
                    }
                },
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )

            return AnyView(errorWidget)
        }

        // trial activation flow
        if model.isTrialEligible {
            let trialAvailableWidget = AttTrialAvailableWidget(
                onLearnMore: onActivateTrial,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil,
                screenType: screenType
            )
            return AnyView(trialAvailableWidget)
        }

        // has active plan flow
        if model.hasActivePlan {
            let activePlanWidget = AttActivePlanWidget(
                model: $model.subscription,
                onPurchase: onActivateDataPlan,
                onRefresh: {
                    AttSubscriptionsServices.shared.resetValidateSubscriptionData()
                    model.loadData() },
                onDashboard: onShowDashboard,
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )
            return AnyView(activePlanWidget)
        }

        // available data plans flow
        if ApolloSDK.current.getIsNewUser(), model.isPurchaseWifiDataEligible {
            let availablePlanWidget = AttAvailablePlanWidget(
                onSeePlans: onActivateDataPlan,
                screenType: screenType,
                onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
            )
            return AnyView(availablePlanWidget)
        }

        // has no plan flow
        let noPlanWidget = AttNoPlanWidget(
            onPurchase: onActivateDataPlan,
            onDashboard: onShowDashboard,
            screenType: screenType,
            onWidgetAppeared: isForCellView ? model.updateWidgetHeight : nil
        )

        return AnyView(noPlanWidget)
    }
}

struct DashboardWidget_Preview: PreviewProvider {
    private static let model = AttWidgetViewModel()

    static var previews: some View {
        AttWidgetView(model: model, screenType: .dashboard)
    }
}

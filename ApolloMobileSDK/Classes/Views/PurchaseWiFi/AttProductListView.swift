//
//  ProductListView.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/14/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import SwiftUI

public struct AttProductListView: View {
    @ObservedObject var productListViewModel = AttProductListViewModel()
    
    @State private var openConsent = false
    @State private var useUserData = false
    @State private var canContinue = false
    
    // - Properties
    var goBack: (() -> Void) = {}
    var goNext: ((AttProduct, AttProductOffer, AttUser?, Bool) -> Void) = { product, productOffer, user, useUserData in }

    public var body: some View {
        ZStack {
            AttAppTheme.attSDKBackgroundColor
                .edgesIgnoringSafeArea(.all)
            
            if (productListViewModel.showError) {
                renderError()
            } else {
                renderBody()
            }
            
            if ApolloSDK.current.getIsNewUser() && openConsent {
                AttDialog(
                    open: $openConsent,
                    title: "share_information_registration_dialog_title".localized(),
                    message1: String(format: "share_information_registration_dialog_message_first".localized(), ApolloSDK.current.getTenantString(), ApolloSDK.current.getHostName()),
                    acceptBtnTitle: "share_information_registration_dialog_allow_button".localized(),
                    message2: String(format: "share_information_registration_dialog_message_second".localized(), ApolloSDK.current.getHostName()),
                    cancelBtnTitle: "share_information_registration_dialog_deny_button".localized(),
                    onAccept: {
                        useUserData = true
                        ApolloSDK.current.authenticationDelegate?.requestNewToken()
                        self.closeAndNavigateTo()
                    },
                    onCancel: { useUserData = false; self.close() }
                )
            }
            
        }
        .onAppear {
            UITableView.appearance().tableFooterView = UIView()
            UITableViewCell.appearance().selectionStyle = .none
        }
    }
    
    func closeAndNavigateTo() {
        openConsent.toggle();
        navigateTo()
    }
    
    func close() {
        openConsent.toggle();
    }
    
    func navigateTo() {
        canContinue.toggle();
        let product = productListViewModel.selectedProduct ?? AttProduct(id: "", name: "", type: "", billingType: .none)
        let productOffer = productListViewModel.selectedOffer ?? AttProductOffer()
        let user = productListViewModel.existingUser
        self.goNext(product, productOffer, user, useUserData)
    }
    
    func renderBody() -> AnyView {
        return AnyView(
            AttNavigationBarView<AnyView, AnyView>(titleText: PurchaseWiFiStepTitles.planSelectionn.value(), backgroundColor: AttAppTheme.attSDKBackgroundColor, contentView: {
                AnyView(
                    VStack {
                        if (productListViewModel.showActivityIndicator) {
                            Spacer()
                            AttActivityIndicator()
                            Spacer()
                        } else {
                            renderProductsList()
                        }
                    }
                    .frame(minWidth: UIScreen.main.bounds.maxX)
                    .background(AttAppTheme.attSDKBackgroundColor)
                    .onAppear {
                        self.fetchProductsList()
                    }.onDisappear(perform: { openConsent = false })
                )
            }, onBack: nil)
            
        )
    }
    
    func renderProductsList() -> AnyView {
        return AnyView(
            ScrollView {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        
                        Spacer().frame(height: 20)
                        AttProductListHeader().frame(height: (ApolloSDK.current.getLanguage() != .en) ? 60 : 20)
                        
                        if let viewModels = productListViewModel.viewModels {
                            
                            let warnerViewModels = viewModels.filter({ $0.productType == .warnermedia })
                            if warnerViewModels.count > 0 {
                                renderRows(viewModels: warnerViewModels)
                                Spacer().frame(height: 8)
                                AttPurchaseListRIde()
                                Spacer().frame(height: 32)
                            }
                            
                            let standardViewModels = viewModels.filter({ $0.productType == .standard })
                            if standardViewModels.count > 0 {
                                renderRows(viewModels: standardViewModels)
                            }
                        }

                    }
                    
                    Spacer()
                    
                    AttExpandableSection(showDivider: true,
                                      text: AttDisclaimerHelper.getDisclaimersString(products: productListViewModel.viewModels?.map({ $0.productData }) ?? []),
                                      links: AttDisclaimerHelper.getDisclaimerLinks(),
                                      titleFont: .custom(ApolloSDK.current.getBoldFont(), size: 15),
                                      title: "disclaimers_title".localized(),
                                      contentColor: AttAppTheme.attSDKTextSecondaryColor)
                    
                    Spacer().frame(height: 10)
                    
                    Text("learn_more_about_data".localized())
                        .font(.custom(ApolloSDK.current.getBoldFont(), size: 15))
                        .padding([.bottom], 10)
                        .padding([.top], 0)
                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                    AttExpandableSection(showDivider: true, text: AttConstants.audioStreaming, links: [], title: "streaming_audio_title".localized(), contentColor: AttAppTheme.attSDKTextPrimaryColor)
                    AttExpandableSection(showDivider: true, text: AttConstants.videoStreaming, links: [], title: "streaming_video_title".localized(), contentColor: AttAppTheme.attSDKTextPrimaryColor)
                    
                    Spacer().frame(height: 30)
                    
                    Button(action: {
                        (self.goBack)()
                    }){
                        HStack {
                            Spacer()
                            Text("share_information_registration_dialog_deny_button".localized())
                                .font(.custom(ApolloSDK.current.getMediumFont(), size: 15))
                            Spacer()
                        }
                    }
                    .buttonStyle(AttSecondaryButtonStyle())
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }.padding(.horizontal)
        )
    }
    
    func renderRows(viewModels: [AttProductListRowViewModel]) -> AnyView {
        return AnyView(
            ForEach(viewModels, id: \.self) { viewModel in
                let selectedProduct = self.productListViewModel.selectedProduct
                
                AttProductListRowView(
                    productViewModel: viewModel,
                    isSelected: selectedProduct?.id != viewModel.id,
                    onProductSelected: { newSelectedProduct in
                        self.productListViewModel.selectedProduct = newSelectedProduct
                        let dataAmount = "\(self.productListViewModel.selectedProduct?.usage?.limit ?? "N/a")\(self.productListViewModel.selectedProduct?.usage?.unit ?? "GB")"
                        let planInterval = self.productListViewModel.selectedProduct?.recurrent?.interval ?? 0
                        let planUnit     = self.productListViewModel.selectedProduct?.recurrent?.unit ?? ""
                        
                        self.productListViewModel.selectedOffer = AttProductOffer(
                            planName: self.productListViewModel.selectedProduct?.name ?? "",
                            dataAmount: dataAmount,
                            planExpiration: "\(planInterval) \(planUnit)"
                        )
                        
                        if ApolloSDK.current.getIsNewUser() == false {
//                            self.productListViewModel.fetchDashboardData(completion: {
                                self.navigateTo()
//                            })
                        } else {
                            self.openConsent.toggle()
                        }
                    }
                ).listRowInsets(EdgeInsets())
                
                Spacer().frame(height: 16)
            }
        )
    }
    
    func renderError() -> AnyView {
        return AnyView(
            AttErrorView(
                showContact: true,
                retryTitle: "dashboard_retry".localized(),
                exitTitle: "share_information_registration_dialog_deny_button".localized(),
                onRetry: self.fetchProductsList,
                onExit: self.goBack,
                contentView: Text("dashboard_error_something_went_wrong".localized())
                    .font(.custom(ApolloSDK.current.getMediumFont(), size: 17))
                    .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                    .multilineTextAlignment(.center)
            )
        )
    }
    
    func fetchProductsList() {
        self.productListViewModel.showError = false
        self.productListViewModel.showActivityIndicator = true
        self.productListViewModel.fetchProducts(vin: ApolloSDK.current.getVin())
    }
}

struct AttProductListView_Previews: PreviewProvider {
    static var previews: some View {
        AttProductListView(goBack: {})
    }
}

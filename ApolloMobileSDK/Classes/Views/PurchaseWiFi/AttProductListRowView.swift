//
//  ProductListRowView.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/15/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import SwiftUI

struct AttProductListRowView: View {
    var productViewModel: AttProductListRowViewModel
    var rowHeight: CGFloat = 80
    var isSelected = false
    var onProductSelected: (AttProduct) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            if productViewModel.productType != .standard {
                HStack {
                    Text(productViewModel.productType.name())
                        .font(.custom(ApolloSDK.current.getMediumFont(), size: 12))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(productViewModel.productType.color())
                    Spacer()
                }
                Spacer().frame(height: 4)
            }


            HStack(spacing: 5) {
                Text(productViewModel.name + AttDisclaimerHelper.getDisclaimer(product: productViewModel.productData).smallNumber)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(minWidth: 110, maxWidth: .infinity, alignment: .leading)
                    .font(.custom(ApolloSDK.current.getMediumFont(), size: 14))
                    .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                    .lineLimit(nil)
                
                renderPrice()

                Text(productViewModel.costPerMonth)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(.custom(ApolloSDK.current.getRegularFont(), size: 11))
                    .foregroundColor(AttAppTheme.attSDKTextSecondaryColor)
                
                Button(action: {
                    self.onProductSelected(self.productViewModel.productData)
                }) {
                    Spacer()
                    Text("purchase".localized())
                        .font(.custom(ApolloSDK.current.getMediumFont(), size: 14))
                        .lineLimit(nil)
                        .fixedSize(horizontal: true, vertical: false)
                    Spacer()
                }
                .frame(width: 100, height: AttAppTheme.attSDKPillButtonHeight)
                .foregroundColor(AttAppTheme.attSDKPrimaryButtonTextColor)
                .background(AttAppTheme.primaryColor)
                .if(AttAppTheme.attSDKButtonCurvature > 0, content: {
                    $0.cornerRadius((AttAppTheme.attSDKButtonCurvature * 30) / 55)
                })
                .shadow(color: AttAppTheme.shadowColor.opacity(0.6), radius: 2, x: 2, y: 3)
            }
            .background(!isSelected ?
                            LinearGradient(gradient: Gradient(colors: [AttAppTheme.attSDKBackgroundColor, AttAppTheme.attSDKSelectedProductBackgroundColor.opacity(0.5), AttAppTheme.attSDKBackgroundColor]), startPoint: .leading, endPoint: .trailing) : nil)
                
            .padding([.leading, .trailing], 0)
            
        }
        .background(Color.clear)
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: rowHeight)

    }
    
    func renderPrice() -> AnyView {
        let price = productViewModel.price.split(separator: "/")
        
        if price.count == 2 {
            return AnyView(
                HStack(alignment: .center, spacing: 0) {
                    Text(price[0])
                        .font(.custom(ApolloSDK.current.getMediumFont(), size: 13))
                        .allowsTightening(true)
                        .foregroundColor(AttAppTheme.primaryColor)
                    
                    Text("/" + (price[1]))
                        .font(.custom(ApolloSDK.current.getRegularFont(), size: 11))
                        .allowsTightening(true)
                        .foregroundColor(AttAppTheme.attSDKTextSecondaryColor)
                }
                .frame(maxWidth: .infinity)
                
            )
        } else {
            return AnyView(Text(productViewModel.price)
                .font(.custom(ApolloSDK.current.getMediumFont(), size: 13))
                .frame(minWidth: 80)
                .foregroundColor(AttAppTheme.primaryColor))
        }
    }
}


struct AttProductListRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            let product = AttProduct(id: "", name: "Test", type: "type", billingType: .prepaid, description: "Description", status: "Status", expirationTime: "ExpirationTime", startTime: "startTime", bundle: true, price: AttPrice(amount: "amount", currency: "currency"), usage: AttUsage(limit: "Limit", used: "USed", unit: "Unit"), recurrent: nil)
            let viewModel = AttProductListRowViewModel(id: "", name: "Test", price: "Price", costPerMonth: "Cost", autoRenew: true, billingType: "Prepaid", productData: product)
            
            AttProductListRowView(productViewModel: viewModel, onProductSelected: { _ in })
                .listRowInsets(EdgeInsets())
            AttProductListRowView(productViewModel: viewModel, onProductSelected: { _ in })
                .listRowInsets(EdgeInsets())
            AttProductListRowView(productViewModel: viewModel, onProductSelected: { _ in })
                .listRowInsets(EdgeInsets())
            AttProductListRowView(productViewModel: viewModel, onProductSelected: { _ in })
                .listRowInsets(EdgeInsets())
            AttProductListRowView(productViewModel: viewModel, onProductSelected: { _ in })
                .listRowInsets(EdgeInsets())
            
        }

    }
}

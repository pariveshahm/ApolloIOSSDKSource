//
//  ProductListViewModel.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 4/6/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation

class AttProductListViewModel: ObservableObject {
    @Published var viewModels: [AttProductListRowViewModel]?
    @Published var showActivityIndicator = true
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var existingUser: AttUser?
    
    @Published var selectedProduct: AttProduct?
    @Published var selectedOffer: AttProductOffer?
    
    let filterByBillingType = AttBillingType.prepaid
    
    func fetchProducts(vin: String) {
        AttProductsServices.shared.getAllProducts(vin: vin,  completion: {result in
            self.showActivityIndicator = false
            
            switch result {
            case .success(let res):
                guard let plans = res.items else {
                    self.showError = true
                    self.errorMessage = "dashboard_error_something_went_wrong".localized()
                    return
                }
                
                let prepaidPlans = plans
                    .map { $0.product }
                    .filter{ $0.billingType == self.filterByBillingType }
                
                self.viewModels = prepaidPlans.map{ self.mapProductToListRow($0) }
                
            case .failure(let error):
                self.showError = true
                self.errorMessage = error.localizedDescription
            }
        })
    }
    
    func fetchDashboardData(completion: @escaping () -> Void) {
        self.showActivityIndicator = true
        AttDashboardServices.shared.getDashboard(msisdn: ApolloSDK.current.getMsisdn(), responseHandler: {result in
            self.showActivityIndicator = false
            switch result {
            case .success(let dashboardData):
                if let subscriber = dashboardData.items?.first?.subscriber {
                    let country = AttCountry(code: subscriber.address?.country ?? "", label:  subscriber.address?.country ?? "")
                    let countryState = AttCountry.State(name: subscriber.address?.region ?? "", code: subscriber.address?.region ?? "")
                    let address = AttUser.AttAddress.init(country: country,
                                                          city: subscriber.address?.city ?? "",
                                                          street: subscriber.address?.line1 ?? "",
                                                          zipCode: subscriber.address?.postalCode ?? "",
                                                          state: countryState,
                                                          appartmentNumber: "")
                    let user: AttUser = AttUser(
                        firstName: subscriber.firstName ?? "",
                        lastName: subscriber.lastName ?? "",
                        email: subscriber.email?.address ?? "",
                        phone: subscriber.phone?.number ?? "",
                        address: address,
                        language: .init(name: subscriber.language ?? "English", code: subscriber.language ?? "US")
                    )
                    
                    self.existingUser = user
                    completion()
                }
            case .failure(let error):
//                self.errorMessage = error.localizedDescription
//                self.showError = true
                print(error)
                completion()
                return
            }
        })
    }
    
    
    func mapProductToListRow(_ product: AttProduct) -> AttProductListRowViewModel {
        let productListRow =  AttProductListRowViewModel(
            id: product.id,
            name: product.name,
            price: getFormattedTotalPrice(product),
            costPerMonth: "\(getFormattedMonthlyPrice(product))",
            autoRenew: product.recurrent?.autoRenew ?? false,
            billingType: product.billingType.rawValue,
            productData: product
        )
        
        return productListRow
    }
    
    func getFormattedTotalPrice(_ product: AttProduct) -> String {
        var formattedPrice = ""
        formattedPrice = "\(product.price?.currency?.getCurrencySymbol() ?? "$")\(product.price?.amount ?? "0.00")\(formatPeriodUnit(unit: product.recurrent?.unit, interval: Int(product.recurrent?.interval ?? 0) ))"
        return formattedPrice
    }
    
    func getFormattedMonthlyPrice(_ product: AttProduct) -> String {
        var formattedPrice = ""
        formattedPrice = "\(product.price?.currency?.getCurrencySymbol() ?? "$")\(calculateCostPerMonth(unit: product.recurrent?.unit, interval: Int(product.recurrent?.interval ?? 0) , amount: Double(product.price?.amount ?? "0.00")!))"
        return formattedPrice
    }
    
    func formatPeriodUnit(unit: String?, interval: Int) -> String {
        var periodUnit = ""
        switch unit?.lowercased() {
        case "days", "day":
            if (interval > 1 && interval < 30) {
                periodUnit = "/\(interval) days"
            } else if (interval % 30 == 0 ) {
                let months = interval/30
                if (months > 1) {
                    periodUnit = "/\(months) mo"
                } else {
                    periodUnit = "per_month".localized()
                }
            } else {
                periodUnit = "per_day".localized()
            }
        case "months":
            if (interval % 12 == 0) {
                let years = (interval/12)
                if (years > 1) {
                    periodUnit = "/\(years) yr"
                } else {
                    periodUnit = "per_year".localized()
                }
            } else if interval > 1 {
                periodUnit = "/\(interval) mo"
            } else {
                periodUnit = "per_month".localized()
            }
        case "years":
            periodUnit = interval > 1 ? "/\(interval) yr" : "per_year".localized()
        default:
            periodUnit = "per_month".localized()
        }
        
        return periodUnit
    }
    
    
    func calculateCostPerMonth(unit: String?, interval: Int, amount: Double) ->  String {
        var costPerMonth = 0.00
        switch unit {
        case "Days":
            if (interval % 30 == 0 ) {
                let months = interval/30
                costPerMonth = amount/Double(months)
            }
        case "Months":
            if (interval % 12 == 0) {
                costPerMonth = amount/Double(interval)
            } else if interval > 1 {
                costPerMonth = amount/Double(interval)
            } else {
                costPerMonth = amount
            }
        case "Years":
            let months = interval*12
            costPerMonth = amount/Double(months)
        default:
            costPerMonth = amount
        }
        
        let decimalplaces = (costPerMonth == Double(Int(costPerMonth))) ? 0 : 2
        return costPerMonth.toString(decimalPlaces: decimalplaces)
    }
}


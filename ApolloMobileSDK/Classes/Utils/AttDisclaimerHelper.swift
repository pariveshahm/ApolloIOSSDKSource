//
//  DisclaimerHelper.swift
//  ApolloMobileSDK
//
//  Created by Elvis on 3/25/21.
//

import Foundation

struct AttDisclaimerHelper {
    static let values: [DisclaimerModel] = [
        DisclaimerModel(smallNumber: "⁴", text: "disclaimer_4".localized()),
        DisclaimerModel(smallNumber: "¹", text: "transaction_summary_trial_fine_text_prepaid".localized()),
        DisclaimerModel(smallNumber: "³", text: "disclaimer_3".localized()),
        DisclaimerModel(smallNumber: "²", text: "transaction_summary_trial_fine_text_annual".localized()),
                                            
        DisclaimerModel(smallNumber: "⁵", text: ""),
        DisclaimerModel(smallNumber: "⁶", text: ""),
        DisclaimerModel(smallNumber: "⁷", text: ""),
        DisclaimerModel(smallNumber: "⁸", text: ""),
        DisclaimerModel(smallNumber: "⁹", text: ""),
        DisclaimerModel(smallNumber: "¹⁰", text: "")
    ]
    
    static func getDisclaimer(product: AttProduct) -> DisclaimerModel {
        if let unit = product.recurrent?.unit?.lowercased(), let interval = product.recurrent?.interval {
            
            if unit == "days" || unit == "day" {
                return AttDisclaimerHelper.values[1] // months
            }
            
            if unit == "months", interval < 12 {
                return AttDisclaimerHelper.values[1] // months
            }
            
            if unit == "months" || unit == "year" {
                return AttDisclaimerHelper.values[3] // year
            }
        }
        
        return DisclaimerModel(smallNumber: "", text: "")
    }
    
    static func getDisclaimers(products: [AttProduct]) -> [DisclaimerModel] {
        var results: [DisclaimerModel] = []
        
        for product in products {
            let disclaimer = getDisclaimer(product: product)
            if results.first(where: { $0.smallNumber == disclaimer.smallNumber }) == nil {
                results.append(disclaimer)
            }
        }
        results = results.sorted{ $0.smallNumber > $1.smallNumber }
        return results
    }
    // render product list
    static func getDisclaimersString(products: [AttProduct]) -> String {
        var result = ""
        for disclaimer in getDisclaimers(products: products) {
            result = result + disclaimer.smallNumber + disclaimer.text + "\n\n"
        }
        if !result.isEmpty {
            result = String(result.dropLast())
            result = String(result.dropLast())
            result = String(result.dropLast())
            result = String(result.dropLast())
        }
        return result
    }
    // render product list
    static func getDisclaimerLinks() -> [LinkObject] {
        let links: [LinkObject] = [
            LinkObject(text: "http://www.att.com/USTermsandconditions", url: "http://www.att.com/USTermsandconditions"),
            LinkObject(text: "att.com/broadbandinfo", url: "https://about.att.com/sites/broadband"),
            LinkObject(text: "att.com/wca", url: "https://www.att.com/legal/terms.wirelessCustomerAgreement-list.html")
        ]
        
        return links
    }
    
    struct DisclaimerModel {
        let smallNumber: String
        let text: String
    }
}

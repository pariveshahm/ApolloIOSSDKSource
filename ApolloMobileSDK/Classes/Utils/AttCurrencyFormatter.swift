//  CurrencyFormatter.swift
//  ApolloMobileSDK
//
//  Created by Shak4l on 19/02/2021.

import Foundation

final class AttCurrencyFormatter {
    
    static func format(amount: String, curreny: String) -> String {
        let foundCurrency = currencySymbolf(for: curreny)
        let floutAmount = Double(amount)!
        let formatter = NumberFormatter()
        // formatter.numberStyle = .currency
        //  formatter.currencyCode = ""
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ","
        
        if let formatedAmount = formatter.string(for: floutAmount) {
            return "\(foundCurrency)\(formatedAmount)"
        }
        
        return "\(foundCurrency)\(amount)"
    }
    
    private static func currencySymbolf(for code: String) -> String {
        // let result = Locale.availableIdentifiers.map { Locale(identifier: $0) }.first { $0.currencyCode == code }
        //   return result?.currencySymbol
        return "$"
    }
}

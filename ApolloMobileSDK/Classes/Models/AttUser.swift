//  AttUser.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 18/12/2020.

import Foundation

public struct AttUser {
    var firstName: String
    var lastName:  String
    var email:     String
    var phone:     String
    var address:   AttAddress
    var language:  AttCountry.Language
    
    // - Protected
    init() {
        self.firstName = ""
        self.lastName  = ""
        self.email     = ""
        self.phone     = ""
        self.address   = AttAddress()
        self.language  = .init(name: "", code: "")
    }
    
    init(firstName: String,
         lastName:String,
         email: String,
         phone: String,
         address: AttAddress,
         language: AttCountry.Language) {
        
        self.firstName = firstName
        self.lastName  = lastName
        self.email     = email
        self.phone     = phone
        self.address   = address
        self.language  = language
    }
    
    // - Public
    public init(firstName: String,
                lastName:  String,
                email:     String,
                phone:     String,
                country: AttCountryType,
                state: String,
                city: String,
                street: String,
                zipCode: String) {
        
        self.firstName = firstName
        self.lastName  = lastName
        self.email     = email
        self.phone     = phone
        
        let storedCountries: [AttCountry] = loadFile("countries.json")
        let pickedCountry = storedCountries.first(where: { $0.code == country.rawValue })
        
        if let pickedCountry = pickedCountry {
            self.language  = pickedCountry.languages[0]
            let foundState = pickedCountry.states.first(where: { $0.code == state })
            self.address  = .init(
                country: pickedCountry,
                city: city,
                street: street,
                zipCode: String(zipCode.prefix(country == .CA ? 6 : 5)),
                state: foundState != nil ? foundState! : .init(name: "", code: ""),
                appartmentNumber: ""
            )
        } else {
            self.language  = .init(name: "", code: "")
            self.address   = .init(
                country: .init(code: "", label: ""),
                city: "",
                street: "",
                zipCode: "",
                state: .init(name: "", code: ""),
                appartmentNumber: ""
            )
        }
    }
}

extension AttUser {
    struct AttAddress {
        var country: AttCountry
        var city:    String
        var street:  String
        var zipCode: String
        var state:   AttCountry.State
        var appartmentNumber: String
        
        init() {
            self.country = .init()
            self.city    = ""
            self.street  = ""
            self.zipCode = ""
            self.state   = .init(name: "", code: "")
            self.appartmentNumber = ""
        }
        
        init(country: AttCountry,
             city: String,
             street: String,
             zipCode: String,
             state: AttCountry.State,
             appartmentNumber: String) {
            
            self.country = country
            self.city = city
            self.street = street
            self.zipCode = zipCode
            self.state = state
            self.appartmentNumber = appartmentNumber
        }
    }
}

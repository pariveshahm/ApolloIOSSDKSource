//  PaymentLinkUtil.swift
//  ApolloMobileSDK
//
//  Created by Shak4l on 12/02/2021.

import Foundation

class AttPaymentLinkUtil {
    
    static func createPaymentPath(_ product: AttProduct,_ attUser: AttUser, autoRenew: Bool) -> String {
        
        let object = """
        {
               "accessToken":"\(ApolloSDK.current.getAccessToken() ?? "")",
               "accountInfo":{
                  "identifier":{
                     "type":"msisdn",
                     "value": "\(ApolloSDK.current.getMsisdn())"
                  },
                  "simType":"embedded",
                  "generation":null,
                  "tenant":"\(ApolloSDK.current.getTenantValue().lowercased())",
                  "country":"\(ApolloSDK.current.getCountry().rawValue)",
                  "homeAddress":[
                     "\(attUser.address.street)",
                     "",
                     "\(attUser.address.zipCode)",
                     "\(attUser.address.city)",
                     "\(attUser.address.state.code)",
                     "\(attUser.address.country.code)",
                     null
                  ],
                  "subscriber":{
                     "email":"\(attUser.email)"
                  },
                  "product":[
                     "\(product.id)",
                     "\(product.name)",
                     "\(product.description ?? "")",
                     "prepaid",
                     [
                        "\(product.usage?.limit ?? "")",
                        "\(product.usage?.unit ?? "")",
                        null
                     ],
                     [
                        30,
                        "days",
                        \(autoRenew),
                        null,
                        null
                     ],
                     [
                        "\(product.price?.amount ?? "")",
                        "\(product.price?.currency ?? "")"
                     ],
                     null,
                     null
                  ],
                  "billing":{
                     "autoRenew": \(autoRenew),
                     "savePaymentProfile":true,
                     "payment":{
                        "amount": "\(product.price?.amount ?? "")",
                        "currency": "\(product.price?.currency ?? "")"
                     }
                  }
               },
               "restoreState":{
                  "source":"sdk",
                  "flow":"add-new-vehicle",
                  "openIdPayloadCookieSDK": "\(ApolloSDK.current.openIdPayload ?? "")",
                  "redirectAction":"ecc",
                  "language":"\(ApolloSDK.current.getLanguage().value())",
                  "channel":"\(ApolloSDK.current.getChannel().rawValue)",
                  "iccid":"\(ApolloSDK.current.getIccid())",
                  "vin":"\(ApolloSDK.current.getVin())",
                  "csrfToken":"ef537ffa-c5d6-4c30-907c-ed4bb6a6b137",
                  "previousLocation":"payment-app",
                  "state":"signup.retail.purchase.prepaid.transaction-summary",
                  "make":"\(ApolloSDK.current.getTenantValue().lowercased())",
                  "totalSurchargeAmount":"0",
                  "totalTaxAmount":"0.00",
                  "baseAmount":"\(product.price?.amount ?? "")",
                  "successCallbackState":"signup.retail.purchase.prepaid.thank-you",
                  "successCallbackStateParams":{
                     "vehicle":[
                        "\(ApolloSDK.current.getTenantValue().lowercased())",
                        "\(ApolloSDK.current.getCountry().rawValue)",
                        "\(ApolloSDK.current.getVin())",
                        "\(ApolloSDK.current.getMsisdn())",
                        "\(ApolloSDK.current.getIccid())",
                        "vin",
                        "embedded",
                        null
                     ]
                  }
               },
               "uiLanguage":"en-us",
               "referrerUrl":"https://maestraltesting.net/",
               "IP":"0.0.0.0"
            }
        """
           .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let base64 = object.toBase64()
        return base64
    }
    
    static func updatePaymentPath(_ product: AttProduct,_ attUser: AttUser, cardAddress: AttAddress, autoRenew: Bool) -> String {
        let object = """
        {
               "accessToken":"\(ApolloSDK.current.getAccessToken() ?? "")",
               "accountInfo":{
                  "identifier":{
                     "type":"msisdn",
                     "value": "\(ApolloSDK.current.getMsisdn())"
                  },
                  "tenant":"\(ApolloSDK.current.getTenantValue().lowercased())",
                  "country":"\(ApolloSDK.current.getCountry().rawValue)",
                    "billingAddress": [
                        "\(cardAddress.line1 ?? "")",
                        "",
                        "\(cardAddress.postalCode ?? "")",
                        "\(cardAddress.city ?? "")",
                        "\(cardAddress.region ?? "")",
                        "\(cardAddress.country ?? "")",
                          null
                        ],
                  "homeAddress":[
                     "\(attUser.address.street)",
                     "",
                     "\(attUser.address.zipCode)",
                     "\(attUser.address.city)",
                     "\(attUser.address.state.code)",
                     "\(attUser.address.country.code)",
                        [
                             {
                               "verified": "true"
                             }
                        ]
                  ],
                  "subscriber":{
                     "id": null,
                     "email": null
                  }
               },
               "restoreState":{
                  "source":"sdk",
                  "flow": "Payment Management flow",
                  "openIdPayloadCookieSDK": "\(ApolloSDK.current.openIdPayload ?? "")",
                  "redirectAction": "SDK",
                  "language":"\(ApolloSDK.current.getLanguage().value())",
                  "channel":"\(ApolloSDK.current.getChannel().rawValue)",
                  "previousLocation":"payment-app",
                  "state": "dashboard.vehicle.payment-profile",
                  "msisdn": "\(ApolloSDK.current.getMsisdn())",
                  "make":"\(ApolloSDK.current.getTenantValue().lowercased())",
                  "successCallbackStateParams":{
                     "vehicle":[
                        "\(ApolloSDK.current.getTenantValue().lowercased())",
                        "\(ApolloSDK.current.getCountry().rawValue)",
                        "\(ApolloSDK.current.getVin())",
                        "\(ApolloSDK.current.getMsisdn())",
                        "\(ApolloSDK.current.getIccid())",
                        "vin",
                        "embedded",
                        null
                     ]
                  },
                  "successCallbackState": "dashboard.vehicle.payment-profile"
               },
               "uiLanguage":"en-us",
               "referrerUrl":"https://maestraltesting.net/",
               "IP":"0.0.0.0"
            }
        """
           .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let base64 = object.toBase64()
        return base64
    }
    static func updatePayment(_ attUser: AttUser, cardAddress: AttAddress, autoRenew: Bool) -> String {
        let object = """
        {
               "accessToken":"\(ApolloSDK.current.getAccessToken() ?? "")",
               "accountInfo":{
                  "identifier":{
                     "type":"msisdn",
                     "value": "\(ApolloSDK.current.getMsisdn())"
                  },
                  "tenant":"\(ApolloSDK.current.getTenantValue().lowercased())",
                  "country":"\(ApolloSDK.current.getCountry().rawValue)",
                    "billingAddress": [
                        "\(cardAddress.line1 ?? "")",
                        "",
                        "\(cardAddress.postalCode ?? "")",
                        "\(cardAddress.city ?? "")",
                        "\(cardAddress.region ?? "")",
                        "\(cardAddress.country ?? "")",
                          null
                        ],
                  "homeAddress":[
                     "\(attUser.address.street)",
                     "",
                     "\(attUser.address.zipCode)",
                     "\(attUser.address.city)",
                     "\(attUser.address.state.code)",
                     "\(attUser.address.country.code)",
                        [
                             {
                               "verified": "true"
                             }
                        ]
                  ],
                  "subscriber":{
                     "id": null,
                     "email": null
                  }
               },
               "restoreState":{
                  "source":"sdk",
                  "flow": "Payment Management flow",
                  "openIdPayloadCookieSDK": "\(ApolloSDK.current.openIdPayload ?? "")",
                  "redirectAction": "SDK",
                  "language":"\(ApolloSDK.current.getLanguage().value())",
                  "channel":"\(ApolloSDK.current.getChannel().rawValue)",
                  "previousLocation":"payment-app",
                  "state": "dashboard.vehicle.payment-profile",
                  "msisdn": "\(ApolloSDK.current.getMsisdn())",
                  "make":"\(ApolloSDK.current.getTenantValue().lowercased())",
                  "successCallbackStateParams":{
                     "vehicle":[
                        "\(ApolloSDK.current.getTenantValue().lowercased())",
                        "\(ApolloSDK.current.getCountry().rawValue)",
                        "\(ApolloSDK.current.getVin())",
                        "\(ApolloSDK.current.getMsisdn())",
                        "\(ApolloSDK.current.getIccid())",
                        "vin",
                        "embedded",
                        null
                     ]
                  },
                  "successCallbackState": "dashboard.vehicle.payment-profile"
               },
               "uiLanguage":"en-us",
               "referrerUrl":"https://maestraltesting.net/",
               "IP":"0.0.0.0"
            }
        """
           .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let base64 = object.toBase64()
        return base64
    }
}

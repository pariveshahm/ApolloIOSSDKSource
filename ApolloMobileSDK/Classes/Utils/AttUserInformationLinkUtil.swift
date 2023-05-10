//
//  AttUserInformationLinkUtil.swift
//  ApolloMobileSDK
//
//  Created by Nermin Sabanovic on 21. 10. 2022..
//

import Foundation

class AttUserInformationLinkUtil {
    
    static func createInformationPath(_ product: AttAddress) -> String {
        
        let object = """
        {
           "includes":[
              "device",
              "subscriber"
           ],
           "subscriber":{
              "firstName":"\(ApolloSDK.current.getUser().firstName)",
              "lastName":"\(ApolloSDK.current.getUser().firstName)",
              "language":"\(ApolloSDK.current.getUser().language)",
              "email":{
                 "address":"\(ApolloSDK.current.getUser().email)"
              },
              "phone":{
                 "number":"\(ApolloSDK.current.getUser().phone)"
              },
              "address":{
                 "line1":"\(ApolloSDK.current.getUser().address.street)",
                 "line2":"",
                 "postalCode":"\(ApolloSDK.current.getUser().address.zipCode)",
                 "city":"\(ApolloSDK.current.getUser().address.city)",
                 "region":"\(ApolloSDK.current.getUser().address.state)",
                 "country":"\(ApolloSDK.current.getUser().address.country)"
              }
           },
           "requestId":"\(UUID.init().uuidString)"
        }
        """
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let base64 = object.toBase64()
        return base64
    }
}

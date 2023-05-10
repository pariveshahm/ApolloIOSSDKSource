//  TextBindingManager.swift
//  ApolloMobileSDK
//
//  Created by Shak4l on 01/03/2021.

import Foundation

class AttTextBindingManager: ObservableObject {
   @Published var text = "" {
       didSet {
           if text.count > characterLimit && oldValue.count <= characterLimit {
               text = oldValue
           }
       }
   }
   let characterLimit: Int

   init(limit: Int = 1){
       characterLimit = limit
   }
}

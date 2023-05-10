//
//  DashboardResponse.swift
//  ApolloMobileSDK
//
//  Created by Elvis on 3/19/21.
//

import Foundation

class AttDashboardResponse:  Codable {
    var type: String?
    var pagination: Bool?
    var items: [DashboardItem]?

    enum CodingKeys: String, CodingKey {
        case type, pagination, items
    }
    
    struct DashboardItem: Codable {
        let id: String?
        let provider: String?
        let billing: DashboardItemBilingStatus?
        let subscriber: AttSubscriber?
        let vehiclelinks: [AttVehiclelink]?
        let subscriptions: [AttSubscription]?
    }
    
    struct DashboardItemBilingStatus: Codable {
        let status: String
    }
}

extension AttDashboardResponse: Equatable {
    static func == (lhs: AttDashboardResponse, rhs: AttDashboardResponse) -> Bool {
        lhs.items?.count == rhs.items?.count
    }
}

//  "items": [
//    {
//      "vehiclelinks": [
//        {
//          "subscriber": {
//            "id": "dada0052-7bb9-4895-9f54-7224ad3587d7"
//          },
//          "name": "Lex's car",
//          "type": "data",
//          "device": {
//            "country": "US",
//            "metas": [
//              {
//                "imei": "419008686977977"
//              }
//            ],
//            "idType": "imei",
//            "sim": {
//              "metas": [
//                {
//                  "msisdnStatus": "dialable"
//                }
//              ],
//              "country": "US",
//              "iccid": "12133095122071658000",
//              "imsi": "719183095292533",
//              "msisdn": "7497412895",
//              "type": "embedded",
//              "tenant": "honda"
//            },
//            "id": "419008686977977",
//            "type": "data",
//            "tenant": "honda"
//          },
//          "vehicle": {
//            "metas": [
//              {
//                "vehicleSaleDate": "2021-07-16"
//              },
//              {
//                "exteriorColor": "Red"
//              },
//              {
//                "engine": "3.2L"
//              }
//            ],
//            "country": "US",
//            "year": 2020,
//            "model": "test",
//            "vin": "F7A1949HONERM1842",
//            "id": "ac4b2b91-2f12-4a5a-9ec3-97f1cc8ecdbc",
//            "make": "acura",
//            "tenant": "honda"
//          }
//        }
//      ],
//    }
//  ]
//
//
//

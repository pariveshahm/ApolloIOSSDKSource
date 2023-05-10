//
//  Recurrent.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/30/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import Foundation


// MARK: - Recurrent
struct AttRecurrent: Codable {
    var interval: String?
    var unit: String?
    var startTime: String?
    var endTime: String?
    var autoRenew: Bool?
    
}

extension AttRecurrent {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            interval = try values.decode(String.self, forKey: .interval)
        } catch {
            let i = try? values.decode(Int.self, forKey: .interval) 
            interval = String(i ?? 0)
        }
        unit = try? values.decode(String.self, forKey: .unit)
        startTime = try? values.decode(String.self, forKey: .startTime)
        endTime = try? values.decode(String.self, forKey: .endTime)
        autoRenew = try? values.decode(Bool.self, forKey: .autoRenew)
    }
}

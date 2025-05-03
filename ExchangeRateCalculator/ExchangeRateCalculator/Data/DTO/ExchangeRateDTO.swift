//
//  ExchangeRateDTO.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/16/25.
//

import Foundation

struct ExchangeRateDTO: Decodable {
    let timeLastUpdateUtc: String
    let rates: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case timeLastUpdateUtc = "time_last_update_utc"
        case rates
    }
}

//
//  ExchangeRate.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/16/25.
//

import Foundation

struct ExchangeRateResult: Decodable {
    let timeLastUpdateUtc: String
    let rates: [String: ]
}

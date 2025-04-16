//
//  Constants.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/16/25.
//

import Foundation

enum CellIdentifier {
    static let exchangeRate = "ExchangeRateCell"
}

enum API {
    static let baseURL = "https://open.er-api.com/v6"
    static let latestRates = "\(baseURL)/latest/USD"
}

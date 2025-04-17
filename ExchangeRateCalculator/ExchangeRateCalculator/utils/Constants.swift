//
//  Constants.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/16/25.
//

import UIKit

enum CellIdentifier {
    static let exchangeRate = "ExchangeRateCell"
}

enum API {
    static let baseURL = "https://open.er-api.com/v6"
    static let latestRates = "\(baseURL)/latest/USD"
}

enum FontStyle {
    static let currencyCode = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let countryName = UIFont.systemFont(ofSize: 14)
    static let rate = UIFont.systemFont(ofSize: 16)
}

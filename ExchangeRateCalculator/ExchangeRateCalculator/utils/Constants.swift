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
    static let titleLabel = UIFont.systemFont(ofSize: 24, weight: .bold)
    
    enum HomeView {
        static let currencyCode = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let countryName = UIFont.systemFont(ofSize: 14)
        static let rate = UIFont.systemFont(ofSize: 16)
    }
    
    enum CalculatorView {
        static let currencyCode = UIFont.systemFont(ofSize: 24, weight: .bold)
        static let countryName = UIFont.systemFont(ofSize: 16)
        static let convertButton = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let resultLabel = UIFont.systemFont(ofSize: 20, weight: .medium)
    }
}

enum ColorStyle {
    static var text: UIColor {
        return UIColor(named: "TextColor") ?? .label
    }

    static var secondaryText: UIColor {
        return UIColor(named: "SecondaryTextColor") ?? .secondaryLabel
    }

    static var cellBackground: UIColor {
        return UIColor(named: "CellBackgroundColor") ?? .secondarySystemBackground
    }
    
    static var buttonBackground: UIColor {
        return UIColor(named: "ButtonColor") ?? .systemBlue
    }
}

//
//  FetchFavoriteCurrencyCodesUseCase.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/25/25.
//

import Foundation

protocol FetchFavoriteCurrencyCodesUseCase {
    func execute() -> [String]
}

//
//  FetchExchangeRatesUseCase.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/24/25.
//

import Foundation

protocol FetchExchangeRatesUseCase {
    func execute() async throws -> [ExchangeRateItem]
}

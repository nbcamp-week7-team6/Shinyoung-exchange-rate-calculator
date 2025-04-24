//
//  ExchangeRateRepository.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/25/25.
//

import Foundation

protocol ExchangeRateRepository {
    func fetchLatestRates() async throws -> [ExchangeRateItem]
}

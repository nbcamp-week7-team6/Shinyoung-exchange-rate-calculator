//
//  DefaultFetchExchangeRatesUseCase.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/24/25.
//

import Foundation

final class DefaultFetchExchangeRatesUseCase: FetchExchangeRatesUseCase {    
    private let repository: ExchangeRateRepository
    
    init(repository: ExchangeRateRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [ExchangeRateItem] {
        return try await repository.fetchLatestRates()
    }
}

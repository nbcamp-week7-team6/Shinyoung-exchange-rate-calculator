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
    
    func execute() async throws -> (items: [ExchangeRateItem], updatedAt: String) {
        let cachedRates = CoreDataService.shared.fetchCachedRates()
        
        let result = try await repository.fetchLatestRates()
        
        let mapped = result.map { item -> ExchangeRateItem in
            var mutableItem = item
            if let oldRate = cachedRates[item.code] {
                let diff = abs(oldRate - item.rate)
                if diff <= 0.01 {
                    mutableItem.change = .same
                } else {
                    mutableItem.change = (item.rate > oldRate) ? .up : .down
                }
            } else {
                mutableItem.change = .unknown
            }
            return mutableItem
        }
        
        CoreDataService.shared.updateCachedRates(with: mapped, updatedAt: result.updatedAt)
        
        return mapped
    }
}

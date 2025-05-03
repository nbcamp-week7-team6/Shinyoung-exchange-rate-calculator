//
//  DefaultUpdateExchangeRateCacheUseCase.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/25/25.
//

import Foundation

final class DefaultUpdateExchangeRateCacheUseCase: UpdateExchangeRateCacheUseCase {
    func execute(items: [ExchangeRateItem], updatedAt: String) {
        CoreDataService.shared.updateCachedRates(with: items, updatedAt: updatedAt)
    }
}

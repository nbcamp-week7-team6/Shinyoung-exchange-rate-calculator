//
//  UpdateExchangeRateCacheUseCase.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/25/25.
//

import Foundation

protocol UpdateExchangeRateCacheUseCase {
    func execute(items: [ExchangeRateItem], updatedAt: String)
}

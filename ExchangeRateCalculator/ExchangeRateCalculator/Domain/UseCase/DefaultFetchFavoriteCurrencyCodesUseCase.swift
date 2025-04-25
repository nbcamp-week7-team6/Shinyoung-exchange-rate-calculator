//
//  DefaultFetchFavoriteCurrencyCodesUseCase.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/25/25.
//

import Foundation

final class DefaultFetchFavoriteCurrencyCodesUseCase: FetchFavoriteCurrencyCodesUseCase {
    func execute() -> [String] {
        return CoreDataService.shared.fetchFavorites()
    }
}

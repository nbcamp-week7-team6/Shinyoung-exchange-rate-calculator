//
//  DefaultToggleFavoriteCurrencyUseCase.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/25/25.
//

import Foundation

final class DefaultToggleFavoriteCurrencyUseCase: ToggleFavoriteCurrencyUseCase {
    func execute(code: String) {
        let isFavorite = CoreDataService.shared.fetchFavorites().contains(code)
        
        if isFavorite {
            CoreDataService.shared.removeFavorite(code: code)
        } else {
            CoreDataService.shared.addFavorite(code: code)
        }
    }
}

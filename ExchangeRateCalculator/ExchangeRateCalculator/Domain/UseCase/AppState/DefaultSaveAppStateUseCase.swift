//
//  DefaultSaveAppStateUseCase.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/25/25.
//

import Foundation

final class DefaultSaveAppStateUseCase: SaveAppStateUseCase {
    func execute(screen: String, code: String?) {
        CoreDataService.shared.saveAppState(screen: screen, code: code)
    }
}

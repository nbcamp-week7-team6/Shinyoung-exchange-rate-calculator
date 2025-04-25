//
//  SaveAppStateUseCase.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/25/25.
//

import Foundation

protocol SaveAppStateUseCase {
    func execute(screen: String, code: String?)
}

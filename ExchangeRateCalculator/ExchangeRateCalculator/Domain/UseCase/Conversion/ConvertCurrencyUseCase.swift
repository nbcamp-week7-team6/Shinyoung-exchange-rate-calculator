//
//  ConvertCurrencyUseCase.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 5/3/25.
//

import Foundation

protocol ConvertCurrencyUseCase {
    func execute(input: String, rate: Double, code: String) -> Result<String, Error>
}

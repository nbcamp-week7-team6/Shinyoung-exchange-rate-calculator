//
//  CalculatorViewModelProtocol.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/21/25.
//

import Foundation

protocol CalculatorViewModelProtocol {
    func convert(amountText: Double) -> Result<String, CalculatorError>
}

enum CalculatorError: Error {
    case emptyInput
    case invalidNumber
}

//
//  CalculatorViewModel.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/21/25.
//

import Foundation

final class CalculatorViewModel: ViewModelProtocol {
    enum Action {
        case convert(input: String)
    }
    
    struct State {
        var resultText: String?
    }
    
    enum ViewState {
        case showResult(String)
        case showError(message: String)
    }
    
    let exchangeRateItem: ExchangeRateItem
    
    var action: ((Action) -> Void)?
    private(set) var state = State()
    var onStateChange: ((ViewState) -> Void)?
    
    init(exchangeRateItem: ExchangeRateItem) {
        self.exchangeRateItem = exchangeRateItem
        
        bind()
    }
    
    private func bind() {
        action = { [weak self] action in
            switch action{
            case .convert(let input):
                self?.convertAmount(input)
            }
        }
    }
    
    private func convertAmount(_ input: String) {
        guard !input.isEmpty else {
            onStateChange?(.showError(message: "금액을 입력해주세요."))
            return
        }
        guard let amount = Double(input) else {
            onStateChange?(.showError(message: "올바른 숫자를 입력해주세요."))
            return
        }
        
        let result = amount * exchangeRateItem.rate
        let formattedAmount = String(format: "%.2f", amount)
        let formattedResult = String(format: "%.2f", result)
        let resultText = "$\(formattedAmount) → \(formattedResult) \(exchangeRateItem.code)"
        
        state.resultText = resultText
        onStateChange?(.showResult(resultText))
    }
}

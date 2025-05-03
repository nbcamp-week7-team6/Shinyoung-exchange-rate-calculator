//
//  DefaultConvertCurrencyUseCase.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 5/3/25.
//

import Foundation

enum CurrencyConversionError: LocalizedError {
    case emptyInput
    case invalidNumber
    
    var errorDescription: String? {
        switch self {
        case .emptyInput:
            return "금액을 입력해주세요."
        case .invalidNumber:
            return "올바른 숫자를 입력해주세요."
        }
    }
}

final class DefaultConvertCurrencyUseCase: ConvertCurrencyUseCase {
    func execute(input: String, rate: Double, code: String) -> Result<String, Error> {
        // 입력값이 비어있으면 에러 반환
        guard !input.isEmpty else {
            return .failure(CurrencyConversionError.emptyInput)
        }
        // 숫자로 변환되지 않으면 에러 반환
        guard let amount = Double(input) else {
            return .failure(CurrencyConversionError.invalidNumber)
        }
        
        // 환율 계산 및 결과 포맷팅
        let result = amount * rate
        let formattedAmount = String(format: "%.2f", amount)
        let formattedResult = String(format: "%.2f", result)
        let resultText = "$\(formattedAmount) → \(formattedResult) \(code)"
        
        return .success(resultText)
    }
    
    
}

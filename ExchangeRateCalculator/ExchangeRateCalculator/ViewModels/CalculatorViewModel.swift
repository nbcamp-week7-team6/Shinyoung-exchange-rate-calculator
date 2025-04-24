//
//  CalculatorViewModel.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/21/25.
//

import Foundation

/// 환율 계산 화면의 ViewModel
/// - 사용자가 입력한 금액을 선택된 환율 기준으로 계산하여 결과를 전달
final class CalculatorViewModel: ViewModelProtocol {
    /// View에서 발생하는 사용자 액션 정의
    enum Action {
        // 환율 계산 요청
        case convert(input: String)
    }
    
    /// 내부 상태값
    struct State {
        var resultText: String?
    }
    
    /// View로 전달되는 결과 상태 (UI 변경 유도)
    enum ViewState {
        // 계산 결과를 화면에 표시
        case showResult(String)
        // 오류 메시지 표시
        case showError(message: String)
    }
    
    /// 선택된 환율 아이템
    let exchangeRateItem: ExchangeRateItem
    
    /// 외부에서 액션을 전달받는 클로저
    var action: ((Action) -> Void)?
    /// 읽기 전용 상태
    private(set) var state = State()
    /// ViewController에서 결과를 처리하기 위한 클로저
    var onStateChange: ((ViewState) -> Void)?
    
    /// 초기화 시 환율 데이터를 주입받고 액션을 바인딩
    init(exchangeRateItem: ExchangeRateItem) {
        self.exchangeRateItem = exchangeRateItem
        
        bind()
    }
    
    deinit {
        print("#### CalculatorViewModel deinit")
    }
    
    /// 사용자 액션을 처리할 클로저 바인딩
    private func bind() {
        action = { [weak self] action in
            switch action{
            case .convert(let input):
                self?.convertAmount(input)
            }
        }
    }
    
    /// 입력된 문자열을 Double로 변환 후 환율 계산 로직 실행
    private func convertAmount(_ input: String) {
        // 입력값이 비어있으면 에러 반환
        guard !input.isEmpty else {
            onStateChange?(.showError(message: "금액을 입력해주세요."))
            return
        }
        // 숫자로 변환되지 않으면 에러 반환
        guard let amount = Double(input) else {
            onStateChange?(.showError(message: "올바른 숫자를 입력해주세요."))
            return
        }
        
        // 환율 계산 및 결과 포맷팅
        let result = amount * exchangeRateItem.rate
        let formattedAmount = String(format: "%.2f", amount)
        let formattedResult = String(format: "%.2f", result)
        let resultText = "$\(formattedAmount) → \(formattedResult) \(exchangeRateItem.code)"
        
        // 상태 업데이트 및 결과 전달
        state.resultText = resultText
        onStateChange?(.showResult(resultText))
    }
}

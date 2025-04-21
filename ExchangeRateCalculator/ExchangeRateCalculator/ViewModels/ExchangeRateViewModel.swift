//
//  ExchangeRateViewModel.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/21/25.
//

import Foundation

final class ExchangeRateViewModel: ViewModelProtocol {
    private let exchangeRateService = ExchangeRateService()
    
    enum Action {
        case fetch
        case search(String)
    }
    
    struct State {
        var items = [ExchangeRateItem]()
    }
    
    var action: ((Action) -> Void)?
    private(set) var state = State()
    
    enum ViewState {
        case success([ExchangeRateItem])
        case failure(message: String)
    }
    
    var onStateChange: ((ViewState) -> Void)?
    
    init() {
        bind()
    }
    
    private func bind() {
        action = { [weak self] action in
            switch action {
            case .fetch:
                self?.fetchExchangeRate()
            case .search(let keyword):
                print("search: \(keyword)")
                break
            }
        }
    }
    
    private func fetchExchangeRate() {
        guard let url = URL(string: API.latestRates) else { return }
        
        exchangeRateService.fetchData(url: url) { [weak self] (result: ExchangeRateResult?) in
            guard let self else { return }
            
            DispatchQueue.main.async {
                guard let result else {
                    self.onStateChange?(.failure(message: "데이터를 불러올 수 없습니다."))
                    return
                }
                
                let mapped = result.items
                self.state.items = mapped
                self.onStateChange?(.success(mapped))
            }
        }
    }
}

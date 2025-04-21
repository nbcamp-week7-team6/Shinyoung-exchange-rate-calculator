//
//  ExchangeRateViewModel.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/21/25.
//

import Foundation

final class ExchangeRateViewModel: ExchangeRateViewModelProtocol {
    enum Action {
        case fetch
        case search(String)
        case selectItem(index: Int)
    }
    
    struct State {
        var items = [ExchangeRateItem]()
    }
    
    enum ViewState {
        case success([ExchangeRateItem])
        case failure(message: String)
        case navigateToCalculator(selectedItem: ExchangeRateItem)
    }
    
    private let exchangeRateService = ExchangeRateService()
    
    private var allExchangeRates = [ExchangeRateItem]()
    
    var action: ((Action) -> Void)?
    private(set) var state = State()
    
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
                self?.filterExchangeRates(with: keyword)
            case .selectItem(index: let index):
                self?.handleSelection(at: index)
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
                self.allExchangeRates = mapped
                self.state.items = mapped
                self.onStateChange?(.success(mapped))
            }
        }
    }
    
    private func filterExchangeRates(with keyword: String) {
        let filteredExchangeRates: [ExchangeRateItem]
        
        if keyword.isEmpty {
            filteredExchangeRates = allExchangeRates
        } else {
            filteredExchangeRates = allExchangeRates.filter {
                $0.code.lowercased().contains(keyword.lowercased()) ||
                $0.countryName.contains(keyword)
            }
        }
        
        self.state.items = filteredExchangeRates
        DispatchQueue.main.async {
            self.onStateChange?(.success(filteredExchangeRates))            
        }
    }
    
    private func handleSelection(at index: Int) {
        guard index >= 0, index < state.items.count else { return }
        
        let selectedItem = state.items[index]
        onStateChange?(.navigateToCalculator(selectedItem: selectedItem))
    }
}

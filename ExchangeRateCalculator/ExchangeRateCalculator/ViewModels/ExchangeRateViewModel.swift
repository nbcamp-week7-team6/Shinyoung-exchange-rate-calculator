//
//  ExchangeRateViewModel.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/21/25.
//

import Foundation

final class ExchangeRateViewModel: ViewModelProtocol {
    enum Action {
        case fetch
        case search(String)
    }
    
    struct State {
        var items = [ExchangeRateItem]()
    }
    
    var action: ((Action) -> Void)?
    private(set) var state = State()
    
    init() {
        bind()
    }
    
    private func bind() {
        action = { [weak self] action in
            switch action {
            case .fetch:
                print("fetch")
                break
            case .search(let keyword):
                print("search: \(keyword)")
                break
            }
        }
    }
}

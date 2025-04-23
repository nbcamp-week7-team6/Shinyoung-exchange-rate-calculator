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
        case selectItem(index: Int)
        case toggleFavorite(code: String)
    }
    
    struct State {
        var items = [ExchangeRateItem]()
    }
    
    enum ViewState {
        case success([ExchangeRateItem])
        case failure(message: String)
        case navigateToCalculator(selectedItem: ExchangeRateItem)
    }
    
    private let networkService: NetworkServiceProtocol
    private var allExchangeRates = [ExchangeRateItem]()
    
    var action: ((Action) -> Void)?
    private(set) var state = State()
    var onStateChange: ((ViewState) -> Void)?
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
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
            case .toggleFavorite(let code):
                self?.toggleFavorite(code: code)
            }
        }
    }
    
    private func fetchExchangeRate() {
        guard let url = URL(string: API.latestRates) else { return }
        
        networkService.fetchData(url: url) { [weak self] (result: ExchangeRateResult?) in
            guard let self else { return }
            
            guard let result else {
                DispatchQueue.main.async {
                    self.onStateChange?(.failure(message: "데이터를 불러올 수 없습니다."))
                }
                return
            }
            
            let prevRates = CoreDataService.shared.fetchCachedRates()
            
            let mapped = result.items.map { item -> ExchangeRateItem in
                var mutableItem = item
                if let oldRate = prevRates[item.code] {
                    let diff = abs(oldRate - item.rate)
                    if diff <= 0.01 {
                        mutableItem.change = .same
                    } else {
                        mutableItem.change = (item.rate > oldRate) ? .up : .down
                    }
                } else {
                    mutableItem.change = .unknown
                }
                return mutableItem
            }
            
            CoreDataService.shared.updateCachedRates(with: mapped, updatedAt: result.timeLastUpdateUtc)
            
            let sorted = self.applyFavoriteSorting(to: mapped)
            
            self.allExchangeRates = sorted
            self.state.items = sorted
            
            DispatchQueue.main.async {
                self.onStateChange?(.success(sorted))
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
        
        let sorted = applyFavoriteSorting(to: filteredExchangeRates)
        self.state.items = sorted
        
        DispatchQueue.main.async {
            self.onStateChange?(.success(sorted))
        }
    }
    
    private func handleSelection(at index: Int) {
        guard index >= 0, index < state.items.count else { return }
        
        let selectedItem = state.items[index]
        onStateChange?(.navigateToCalculator(selectedItem: selectedItem))
    }
    
    private func toggleFavorite(code: String) {
        let isFavorite = CoreDataService.shared.fetchFavorites().contains(code)
        
        if isFavorite {
            CoreDataService.shared.removeFavorite(code: code)
        } else {
            CoreDataService.shared.addFavorite(code: code)
        }
        
        filterExchangeRates(with: "")
    }
    
    private func applyFavoriteSorting(to items: [ExchangeRateItem]) -> [ExchangeRateItem] {
        let favorites = Set(CoreDataService.shared.fetchFavorites())
        
        return items.sorted {
            if favorites.contains($0.code) == favorites.contains($1.code) {
                return $0.code < $1.code
            }
            return favorites.contains($0.code)
        }
    }
}

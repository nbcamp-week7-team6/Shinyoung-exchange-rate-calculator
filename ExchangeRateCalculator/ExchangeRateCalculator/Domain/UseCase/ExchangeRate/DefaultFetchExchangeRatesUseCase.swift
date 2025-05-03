//
//  DefaultFetchExchangeRatesUseCase.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/24/25.
//

import Foundation

final class DefaultFetchExchangeRatesUseCase: FetchExchangeRatesUseCase {    
    private let repository: ExchangeRateRepository
    
    init(repository: ExchangeRateRepository) {
        self.repository = repository
    }
    
    func execute(completion: @escaping (Result<([ExchangeRateItem], String), Error>) -> Void) {
        repository.fetchLatestRates { result in
            switch result {
            case .success(let (items, updatedAt)):
                let cachedRates = CoreDataService.shared.fetchCachedRates()
                
                let mapped = items.map { item -> ExchangeRateItem in
                    var mutableItem = item
                    if let oldRate = cachedRates[item.code] {
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
                
                CoreDataService.shared.updateCachedRates(with: mapped, updatedAt: updatedAt)
                completion(.success((mapped, updatedAt)))
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
}

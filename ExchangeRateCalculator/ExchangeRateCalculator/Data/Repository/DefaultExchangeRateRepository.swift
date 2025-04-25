//
//  DefaultExchangeRateRepository.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/25/25.
//

import Foundation

final class DefaultExchangeRateRepository: ExchangeRateRepository {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchLatestRates(completion: @escaping (Result<([ExchangeRateItem], String), Error>) -> Void) {
        guard let url = URL(string: API.latestRates) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        networkService.fetchData(url: url) { (response: ExchangeRateResult?) in
            if let response {
                completion(.success((response.items, response.timeLastUpdateUtc)))
            } else {
                completion(.failure(URLError(.badServerResponse)))
            }
        }
    }
}

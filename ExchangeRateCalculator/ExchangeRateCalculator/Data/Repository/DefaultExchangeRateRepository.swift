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
    
    func fetchLatestRates() async throws -> (items: [ExchangeRateItem], updatedAt: String) {
        guard let url = URL(string: API.latestRates) else {
            throw URLError(.badURL)
        }
        
        let result: ExchangeRateResult = try await withCheckedThrowingContinuation { continuation in
            networkService.fetchData(url: url) { (response: ExchangeRateResult?) in
                if let response {
                    continuation.resume(returning: response)
                } else {
                    continuation.resume(throwing: URLError(.badServerResponse))
                }
            }
        }
        
        return (items: result.items, updatedAt: result.timeLastUpdateUtc)
    }
}

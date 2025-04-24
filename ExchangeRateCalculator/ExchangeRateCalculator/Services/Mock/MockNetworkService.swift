//
//  MockNetworkService.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/23/25.
//

import Foundation

final class MockNetworkService: NetworkServiceProtocol {
    func fetchData<T>(url: URL, completion: @escaping (T?) -> Void) where T : Decodable {
        guard let url = Bundle.main.url(forResource: "mock_exchange_rate", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(T.self, from: data)
        else {
            completion(nil)
            return
        }
        completion(decoded)
    }
}

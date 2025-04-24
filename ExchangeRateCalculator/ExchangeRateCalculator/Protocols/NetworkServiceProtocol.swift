//
//  NetworkServiceProtocol.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/23/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchData<T: Decodable>(url: URL, completion: @escaping (T?) -> Void)
}

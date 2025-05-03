//
//  ExchangeRateService.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/16/25.
//

import Foundation

/// 실시간 네트워크 요청을 처리하는 서비스 클래스
/// - `fetchData` 메서드를 통해 제네릭 타입의 데이터를 받아올 수 있습니다.
final class NetworkService: NetworkServiceProtocol {
    /// URLSession을 사용하여 비동기 네트워크 요청을 수행하고 응답 데이터를 디코딩합니다.
    /// - Parameters:
    ///   - url: 요청할 URL
    ///   - completion: 요청 완료 후 디코딩된 데이터를 전달하는 클로저
    func fetchData<T: Decodable>(url: URL, completion: @escaping (T?) -> Void) {
        // 기본 구성의 URLSession 생성
        let session = URLSession(configuration: .default)
        // URL 요청 수행
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            // 에러 또는 데이터가 없는 경우
            guard let data = data, error == nil else {
                print("데이터 로드 실패")
                completion(nil)
                return
            }
            // HTTP 응답 코드가 성공 범위(200~299)에 있는지 확인
            let successRange = 200..<300
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                // JSON 데이터를 제네릭 타입으로 디코딩 시도
                guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                    print("JSON 디코딩 실패")
                    completion(nil)
                    return
                }
                // 성공적으로 디코딩된 데이터 전달
                completion(decodedData)
            } else {
                print("응답 오류")
                completion(nil)
            }
        }.resume() // 네트워크 요청 시작
    }
}

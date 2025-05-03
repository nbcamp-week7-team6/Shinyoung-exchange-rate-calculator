//
//  CoreDataService.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/22/25.
//

import UIKit
import CoreData

/// Core Data 관련 작업을 관리하는 싱글톤 서비스 클래스
final class CoreDataService {
    /// 전역에서 접근 가능한 공유 인스턴스
    static let shared = CoreDataService()
    /// Core Data 작업을 위한 컨텍스트
    private var context: NSManagedObjectContext!
    
    /// 외부에서 인스턴스를 생성하지 못하도록 private 초기화
    private init() { }
    
    /// 앱 시작 시 외부에서 컨텍스트를 주입받아 설정합니다.
    /// - Parameter context: NSManagedObjectContext 인스턴스
    func configure(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - 즐겨찾기 관리
        
    /// 통화 코드를 즐겨찾기에 추가합니다.
    /// 이미 추가된 경우 중복 저장하지 않습니다.
    func addFavorite(code: String) {
        guard !isFavorite(code: code) else { return }
        
        let favorite = FavoriteCurrency(context: context)
        favorite.code = code
        
        saveContext()
    }
    
    /// 즐겨찾기된 통화 코드 목록을 반환합니다.
    /// - Returns: [String] 형태의 통화 코드 배열
    func fetchFavorites() -> [String] {
        let request = FavoriteCurrency.fetchRequest()
        
        do {
            let favorites = try context.fetch(request)
            return favorites.compactMap { $0.code }
        } catch {
            print("즐겨찾기 로드 실패: \(error.localizedDescription)")
            return []
        }
    }
    
    /// 즐겨찾기에서 특정 통화 코드를 제거합니다.
    func removeFavorite(code: String) {
        let request = FavoriteCurrency.fetchRequest()
        request.predicate = NSPredicate(format: "code == %@", code)
        
        do {
            let results = try context.fetch(request)
            results.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("즐겨찾기 삭제 실패: \(error.localizedDescription)")
        }
    }
    
    /// 특정 통화 코드가 즐겨찾기 상태인지 여부를 반환합니다.
    private func isFavorite(code: String) -> Bool {
        let request = FavoriteCurrency.fetchRequest()
        request.predicate = NSPredicate(format: "code == %@", code)
        request.fetchLimit = 1
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            return false
        }
    }
    
    // MARK: - 캐시 관리
        
    /// 캐시된 환율 데이터를 [통화 코드: 환율] 형태로 반환합니다.
    func fetchCachedRates() -> [String: Double] {
        let request = CachedExchangeRate.fetchRequest()
        do {
            let results = try context.fetch(request)
            return Dictionary(uniqueKeysWithValues: results.compactMap {
                guard let code = $0.code else { return nil }
                return (code, $0.rate)
            })
        } catch {
            print("캐시 데이터 로드 실패: \(error.localizedDescription)")
            return [:]
        }
    }
    
    /// 새 환율 데이터가 API 응답값 기준으로 갱신된 경우에만 캐시를 업데이트합니다.
    /// - Parameters:
    ///   - items: 새로 받은 환율 정보
    ///   - updatedAt: 업데이트 시각 문자열
    func updateCachedRates(with items: [ExchangeRateItem], updatedAt: String) {
        // 동일한 시간에 이미 캐시된 경우 업데이트하지 않음
        let currentRequest = CachedExchangeRate.fetchRequest()
        currentRequest.predicate = NSPredicate(format: "lastUpdatedAt == %@", updatedAt)
        currentRequest.fetchLimit = 1
        
        if let count = try? context.count(for: currentRequest), count > 0 { return }
        
        // 기존 데이터 모두 삭제
        let deleteRequest = CachedExchangeRate.fetchRequest()
        do {
            let oldCachedRates = try context.fetch(deleteRequest)
            let copy = oldCachedRates.map { $0 }
            copy.forEach { context.delete($0) }
        } catch {
            print("기존 캐시 삭제 실패: \(error.localizedDescription)")
        }
        
        // 새로운 데이터 저장
        items.forEach { item in
            let cached = CachedExchangeRate(context: context)
            cached.code = item.code
            cached.rate = item.rate
            cached.lastUpdatedAt = updatedAt
        }
        
        saveContext()
    }
    
    // MARK: - 앱 상태 저장 및 복원
        
    /// 현재 보고 있는 화면 상태를 Core Data에 저장합니다.
    /// - Parameters:
    ///   - screen: "list" 또는 "calculator"
    ///   - code: 선택된 통화 코드 (list일 경우 nil)
    func saveAppState(screen: String, code: String?) {
        deleteAppState()

        let state = AppState(context: context)
        state.screen = screen
        state.code = code

        saveContext()
    }
    
    /// 저장된 앱 상태를 복원합니다.
    /// - Returns: 화면 타입과 선택된 코드가 포함된 튜플
    func fetchAppState() -> (screen: String, code: String?)? {
        let request = AppState.fetchRequest()
        request.fetchLimit = 1

        do {
            if let state = try context.fetch(request).first {
                return (state.screen ?? "list", state.code)
            }
        } catch {
            print("앱 상태 불러오기 실패: \(error.localizedDescription)")
        }
        return nil
    }
    
    /// 저장된 앱 상태를 초기화합니다.
    func deleteAppState() {
        let request = AppState.fetchRequest()
        if let states = try? context.fetch(request) {
            states.forEach { context.delete($0) }
            saveContext()
        }
    }
    
    /// Core Data 변경사항을 저장합니다.
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Core Data 저장 실패: \(error.localizedDescription)")
        }
    }
}

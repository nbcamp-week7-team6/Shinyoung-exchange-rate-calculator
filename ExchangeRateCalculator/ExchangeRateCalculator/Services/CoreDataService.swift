//
//  CoreDataService.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/22/25.
//

import UIKit
import CoreData

final class CoreDataService {
    static let shared = CoreDataService()
    private var context: NSManagedObjectContext!
    
    private init() { }
    
    func configure(context: NSManagedObjectContext) {
        self.context = context
    }
    
//    private var safeContext: NSManagedObjectContext {
//        guard let context else {
//            fatalError("CoreDataService의 context가 nil")
//        }
//        return context
//    }
    
    func addFavorite(code: String) {
        guard !isFavorite(code: code) else { return }
        
        let favorite = FavoriteCurrency(context: context)
        favorite.code = code
        
        saveContext()
    }
    
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
    
    func updateCachedRates(with items: [ExchangeRateItem], updatedAt: String) {
        let currentRequest = CachedExchangeRate.fetchRequest()
        currentRequest.predicate = NSPredicate(format: "lastUpdatedAt == %@", updatedAt)
        currentRequest.fetchLimit = 1
        
        if let count = try? context.count(for: currentRequest), count > 0 { return }
        
        let deleteRequest = CachedExchangeRate.fetchRequest()
        if let old = try? context.fetch(deleteRequest) {
            old.forEach { context.delete($0) }
        }
        
        items.forEach { item in
            let cached = CachedExchangeRate(context: context)
            cached.code = item.code
            cached.rate = item.rate
            cached.lastUpdatedAt = updatedAt
        }
        
        saveContext()
    }
    
    func saveAppState(screen: String, code: String?) {
        deleteAppState()

        let state = AppState(context: context)
        state.screen = screen
        state.code = code

        saveContext()
    }

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

    func deleteAppState() {
        let request = AppState.fetchRequest()
        if let states = try? context.fetch(request) {
            states.forEach { context.delete($0) }
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Core Data 저장 실패: \(error.localizedDescription)")
        }
    }
}

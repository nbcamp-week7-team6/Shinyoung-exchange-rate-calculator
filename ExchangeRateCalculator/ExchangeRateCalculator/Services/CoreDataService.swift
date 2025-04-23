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
    private var context: NSManagedObjectContext?
    
    private init() { }
    
    func configure(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private var safeContext: NSManagedObjectContext {
        guard let context else {
            fatalError("CoreDataService의 context가 nil")
        }
        return context
    }
    
    func addFavorite(code: String) {
        guard !isFavorite(code: code) else { return }
        
        let favorite = FavoriteCurrency(context: safeContext)
        favorite.code = code
        
        saveContext()
    }
    
    func fetchFavorites() -> [String] {
        let request = FavoriteCurrency.fetchRequest()
        
        do {
            let favorites = try safeContext.fetch(request)
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
            let results = try safeContext.fetch(request)
            results.forEach { safeContext.delete($0) }
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
            let count = try safeContext.count(for: request)
            return count > 0
        } catch {
            return false
        }
    }
    
    func fetchCachedRates() -> [String: Double] {
        let request = CachedExchangeRate.fetchRequest()
        do {
            let results = try safeContext.fetch(request)
            return Dictionary(uniqueKeysWithValues: results.compactMap {
                guard let code = $0.code else { return nil }
                return (code, $0.rate)
            })
        } catch {
            print("캐시 데이터 로드 실패")
            return [:]
        }
    }
    
    func updateCachedRates(with items: [ExchangeRateItem], updatedAt: String) {
        let currentRequest = CachedExchangeRate.fetchRequest()
        currentRequest.predicate = NSPredicate(format: "lastUpdatedAt == %@", updatedAt)
        currentRequest.fetchLimit = 1
        if let count = try? safeContext.count(for: currentRequest), count > 0 { return }
        
        let deleteRequest = CachedExchangeRate.fetchRequest()
        if let old = try? safeContext.fetch(deleteRequest) {
            old.forEach { safeContext.delete($0) }
        }
        
        items.forEach { item in
            let cached = CachedExchangeRate(context: safeContext)
            cached.code = item.code
            cached.rate = item.rate
            cached.lastUpdatedAt = updatedAt
        }
        
        saveContext()
    }
    
    private func saveContext() {
        do {
            try safeContext.save()
        } catch {
            print("Core Data 저장 실패: \(error.localizedDescription)")
        }
    }
}

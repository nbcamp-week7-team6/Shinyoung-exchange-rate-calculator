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
    private let context: NSManagedObjectContext
    
    private init() {
        guard let appDelegete = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate 접근 실패")
        }
        self.context = appDelegete.persistentContainer.viewContext
    }
    
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
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Core Data 저장 실패: \(error.localizedDescription)")
        }
    }
}

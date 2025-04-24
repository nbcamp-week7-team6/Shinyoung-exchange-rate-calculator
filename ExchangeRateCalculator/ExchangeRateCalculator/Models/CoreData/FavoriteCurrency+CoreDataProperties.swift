//
//  FavoriteCurrency+CoreDataProperties.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/22/25.
//
//

import Foundation
import CoreData


extension FavoriteCurrency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCurrency> {
        return NSFetchRequest<FavoriteCurrency>(entityName: "FavoriteCurrency")
    }

    @NSManaged public var code: String?

}

extension FavoriteCurrency : Identifiable {

}

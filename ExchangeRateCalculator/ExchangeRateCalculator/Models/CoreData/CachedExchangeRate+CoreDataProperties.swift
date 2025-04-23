//
//  CachedExchangeRate+CoreDataProperties.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/22/25.
//
//

import Foundation
import CoreData


extension CachedExchangeRate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedExchangeRate> {
        return NSFetchRequest<CachedExchangeRate>(entityName: "CachedExchangeRate")
    }

    @NSManaged public var code: String?
    @NSManaged public var rate: Double
    @NSManaged public var lastUpdatedAt: String?

}

extension CachedExchangeRate : Identifiable {

}

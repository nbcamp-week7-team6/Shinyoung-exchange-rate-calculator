//
//  AppState+CoreDataProperties.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/23/25.
//
//

import Foundation
import CoreData


extension AppState {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppState> {
        return NSFetchRequest<AppState>(entityName: "AppState")
    }

    @NSManaged public var screen: String?
    @NSManaged public var code: String?

}

extension AppState : Identifiable {

}

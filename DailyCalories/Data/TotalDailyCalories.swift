//
//  TotalDailyCalories.swift
//  DailyCalories
//
//  Created by Vincent Siu on 8/18/23.
//

import Foundation
import CoreData

class TotalDailyCalories: NSManagedObject{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TotalDailyCalories> {
        return NSFetchRequest<TotalDailyCalories>(entityName: "TotalDailyCalories")
    }
    @NSManaged public var calorieCounter: Int
}

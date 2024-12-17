//
//  PrevCalories.swift
//  DailyCalories
//
//  Created by Vincent Siu on 8/31/23.
//

import CoreData
import Foundation


protocol saveFoodDelegate: AnyObject{
    func didSaveFood()
}

class PrevCalories: ObservableObject{
    
    static let shared = PrevCalories()
    
    weak var delegate: saveFoodDelegate?
    
    let container: NSPersistentContainer
    init(){
        container = NSPersistentContainer(name: "PrevCalories")
        container.loadPersistentStores{(storeDescription, error) in
            if let error = error as NSError?{
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }}
    }
    
    var viewContext: NSManagedObjectContext{
        return container.viewContext
    }
    
    
    
    
    func addFooditem(date: Date, food: String, numCalories: Int, mealType: String, context: NSManagedObjectContext){
        // Save entry for all of history
        let entity = NSEntityDescription.entity(forEntityName: "PastCalories", in: context)!
        let newCalorieEntry = NSManagedObject(entity: entity, insertInto: context)
        
        newCalorieEntry.setValue(date, forKey: "date")
        newCalorieEntry.setValue(food, forKey: "foodItem")
        newCalorieEntry.setValue(numCalories, forKey: "calories")
        
        do{
            try context.save()
            delegate?.didSaveFood()
        } catch let error as NSError{
            print("Unable to save. \(error), \(error.userInfo)")
        }
        
        
        
        let todayEntity = NSEntityDescription.entity(forEntityName: "TodayCalories", in: context)!
        let todayCalorieEntry = NSManagedObject(entity: todayEntity, insertInto: context)
        
        todayCalorieEntry.setValue(food, forKey: "foodItem")
        todayCalorieEntry.setValue(numCalories, forKey: "calories")
        todayCalorieEntry.setValue(mealType, forKey: "mealType")
        do{
            try context.save()
            delegate?.didSaveFood()
        } catch let error as NSError{
            print("Unable to save. \(error), \(error.userInfo)")
        }
        
        
        
    }
    
}


//
//  CoreDataManager.swift
//  DailyCalories
//
//  Created by Vincent Siu on 8/18/23.
//

import Foundation
import CoreData //this gives you access to the core data library

//creaqtes and initializes a NISManagedObjectModel, PersistentStoreCoordinator, and NSmanagedObjectContext.

struct CoreDataManager{
    let container: NSPersistentContainer
    
    init(){
        container = NSPersistentContainer(name: "DailyCaloriesModel")
        container.loadPersistentStores{
            (storeDesc,error)in error.map{
                print($0)
            }
        }
    }
}

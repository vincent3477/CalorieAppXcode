//
//  HistoryViewController.swift
//  DailyCalories
//
//  Created by Vincent Siu on 8/28/23.
//

import Foundation
import UIKit
import CoreData


class HistoryViewController: UITableViewController{
    private var dates: [DateItem] = []
    
    
    //var provider = HistoryProvider.shared
    
    
    
    var log = [String]()

    
    func fetch_log(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //to give you access to managed object context.

        
        //In order to get the data we want from core data, we have to initiate a NSFetchRequest that is responsible for asking for fetch data from the core data. We also have to the ask for the type of data we want to fetch.
        let fetchRequest: NSFetchRequest <PastCalories> = PastCalories.fetchRequest()
        do{
            let results = try context.fetch(fetchRequest)
            print("Fetching history from core data.")
            for logs in results{
                /*print(logs.foodItem as Any)
                
                let foodItem = logs.foodItem ?? "Unknown Food Item"
                let numCalories = String(logs.calories)
                if let date = logs.date{
                    log.append("\(String(describing: date)): \(String(describing: foodItem))\((numCalories))")
                }
                else{
                    log.append("No Date: \(String(describing: logs.foodItem))\((numCalories))")
                }
                 */
                //This results in the interpreter think many fo the values will be optional.
                
                
                
                if let foodItem = logs.value(forKey: "foodItem") as? String, let numCal = logs.value(forKey: "calories") as? Int32, let date = logs.value(forKey: "date") as? Date{
                    
                    //let dateFormat = dateFormatter.date(from: date)!
                    var dateFormatted = dateFormatter.string(from: date)
                    log.append("\(dateFormatted): \(foodItem) - \(numCal) Cals")
                }else{
                    print("Wrong format. Could not print to log.")
                }
                
                
                
            }
        } catch{
            print("Error fetching data \(error)")
        }

        print(log)
    }

    
    /*func addCalorieLog(new_date: Int, total_cal: Int) {
        
        print("add cal log called")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        //access an instance of the app delegate
        
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let log = NSEntityDescription.insertNewObject(forEntityName: "PastCalories", into: managedContext)
        log.setValue(total_cal,forKey:"calories")
        log.setValue(new_date,forKey:"date")
        
        do {
            try managedContext.save()
        } catch {
            print("Fatal Error: Could not save data.")
        }
        
    }
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch_log()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("history log count is \(log.count)")
        return log.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "date_cell", for:indexPath)
        tableViewCell.textLabel?.text = log[indexPath.row]
        return tableViewCell
    }
    
    
    
    
    
    
    
    
}

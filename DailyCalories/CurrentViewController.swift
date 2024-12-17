//
//  CurrentViewController.swift
//  DailyCalories
//
//  Created by Vincent Siu on 8/1/23.
//

import Foundation
import SwiftUI
import UIKit
import CoreData

protocol calorieLogDelegate{
    func addCalorieLog(new_date: Int, total_cal: Int)
}


class CurrentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    /* CalcCaloriesDelegate, the name of the protocol is on top because THE CURRENT VIEW CONTROLLER MUST CONFORM TO THE PROTOCOL, MEANING THAT IT DEFINES WHAT FUNCTION OR VARIABLES THEY ARE WITHIN THE PROTOCOL */
    
    var previousDateLoggedIn = UserDefaults.standard.integer(forKey: "Prev_Date")
    
    @IBOutlet weak var todayTableView: UITableView!
    
    private let viewResultController = ViewResultController()
    
    
    @IBOutlet var calorieCounter: UILabel!
    
    var todayLog = [String]()
    
    
    //var calorieCounterInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        fetch_today_log()
        todayTableView.dataSource = self
        todayTableView.delegate = self
        
        
        let currentDate = Date()
        
        let this_date = Int(dateFormatter.string(from: currentDate))
        
        if(previousDateLoggedIn != this_date){
            clearTodayCalories()
            print("Different day. Reset calorie counter.")
        }
        
        UserDefaults.standard.set(this_date,forKey: "Prev_Date")
        
        
    }
    
    
    
    @IBAction func ResetButton(_ sender: Any) {
        let popup = UIAlertController(title: "Are you sure you want to reset your calorie counter?", message: "Doing so will reset your day progress!", preferredStyle: .alert)
        
        let yesOption = UIAlertAction(title: "Yes", style: .destructive){_ in
            
            self.clearTodayCalories()
        }
        
        let cancelOption = UIAlertAction(title: "No", style: .default)
        
        popup.addAction(yesOption)
        popup.addAction(cancelOption)
        present(popup,animated: true,completion: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        fetch_today_log()
        todayTableView.reloadData()
        
    }
    
    
    private func clearTodayCalories(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TodayCalories")
        do{
            let results = try context.fetch(fetchRequest)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            try context.execute(deleteRequest)
            self.calorieCounter.text = String(0)
            print("Fetching after clearing the data. It should be empty.")
            fetch_today_log()
            todayTableView.reloadData()
        }catch{
            print("Unable to fetch or delete data. \(error.localizedDescription)")
        }
    }
    
   /*
    func updateCalories(addValue: Int, addFoods: [String]) {
        
        let newValue = calorieCounterCurr + addValue
        
        UserDefaults.standard.set(newValue,forKey: "Calorie_Value")
        
        calorieCounterCurr = newValue
        
        calorieCounter.text = String(calorieCounterCurr)
                
        print("the foods to be added to our table are ")
        print(addFoods)
        
        
    }
    */
    
    func fetch_today_log(){
        
        todayLog = [String]()
        
        var calorieCount = 0
                
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //to give you access to managed object context.
        
        
        //In order to get the data we want from core data, we have to initiate a NSFetchRequest that is responsible for asking for fetch data from the core data. We also have to the ask for the type of data we want to fetch.
        let fetchRequest = NSFetchRequest <NSManagedObject>(entityName: "TodayCalories")
        do{
            let results = try context.fetch(fetchRequest)
            print("Fetching today from core data.")
            for logs in results{
               
                if let foodItem = logs.value(forKey: "foodItem") as? String, let numCal = logs.value(forKey: "calories") as? Int32, let mealType = logs.value(forKey: "mealType") as? String{
                    
                    calorieCount += Int(numCal)
                    todayLog.append("\(mealType): \(foodItem) - \(numCal) Cals")
                }else{
                    print("Wrong format. Could not print to log.")
                }
                
                self.calorieCounter.text = String(calorieCount)
                
                
                
            }
        } catch{
            print("Error fetching data \(error)")
        }
    }

    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectMealTableViewController = segue.destination as? SelectMealTableViewController{
            selectMealTableViewController.delegate = self
        }
    }
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print(todayLog.count)
        return todayLog.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath)
        tableViewCell.textLabel?.text = todayLog[indexPath.row]
        return tableViewCell
    }
    
    
    
    
 
}




//
//  CurrentViewController.swift
//  DailyCalories
//
//  Created by Vincent Siu on 8/1/23.
//

import Foundation
import SwiftUI
import UIKit

protocol calorieLogDelegate{
    func addCalorieLog(new_date: Int, total_cal: Int)
}

class CurrentViewController: UIViewController, CalcCaloriesDelegate{
    /* CalcCaloriesDelegate, the name of the protocol is on top because THE CURRENT VIEW CONTROLLER MUST CONFORM TO THE PROTOCOL, MEANING THAT IT DEFINES WHAT FUNCTION OR VARIABLES THEY ARE WITHIN THE PROTOCOL */
    
    @IBOutlet var calorieCounter: UILabel!
    
    var calorieCounterCurr = UserDefaults.standard.integer(forKey: "Calorie_Value")
    var previousDateLoggedIn = UserDefaults.standard.integer(forKey: "Prev_Date")
    
    
    
    
    //var calorieCounterInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        
        
        let currentDate = Date()
        
        let this_date = Int(dateFormatter.string(from: currentDate))
        
        if(previousDateLoggedIn != this_date){
            
            //add calorie log
            var delegate: calorieLogDelegate?
            
            delegate?.addCalorieLog(new_date: previousDateLoggedIn, total_cal: calorieCounterCurr)
            
            
            UserDefaults.standard.set(0,forKey: "Calorie_Value")
            print("Different day. Reset calorie counter.")
        }
        
        UserDefaults.standard.set(this_date,forKey: "Prev_Date")
        
        
        calorieCounter.text = String(calorieCounterCurr)
    }
    
    
    func updateCalories(addValue: Int) {
        let newValue = calorieCounterCurr + addValue
        
        UserDefaults.standard.set(newValue,forKey: "Calorie_Value")
        
        calorieCounterCurr = newValue
        
        calorieCounter.text = String(calorieCounterCurr)
                
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectMealTableViewController = segue.destination as? SelectMealTableViewController{
            selectMealTableViewController.delegate = self
        }
    }
 
}


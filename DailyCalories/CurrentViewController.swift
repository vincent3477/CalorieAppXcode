//
//  CurrentViewController.swift
//  DailyCalories
//
//  Created by Vincent Siu on 8/1/23.
//

import Foundation
import UIKit

class CurrentViewController: UIViewController, CalcCaloriesDelegate{
    /* CalcCaloriesDelegate, the name of the protocol is on top because THE CURRENT VIEW CONTROLLER MUST CONFORM TO THE PROTOCOL, MEANING THAT IT DEFINES WHAT FUNCTION OR VARIABLES THEY ARE WITHIN THE PROTOCOL */
    
    @IBOutlet var calorieCounter: UILabel!
    
    
    var calorieCounterInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func updateCalories(addValue: Int) {
        
        calorieCounterInt += addValue
        
        calorieCounter.text = String(calorieCounterInt)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectMealTableViewController = segue.destination as? SelectMealTableViewController{
            selectMealTableViewController.delegate = self
        }
    }
 
}


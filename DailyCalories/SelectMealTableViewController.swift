//
//  SelectMealTableViewController.swift
//  DailyCalories
//
//  Created by Vincent Siu on 8/3/23.
//  this is myt code

import Foundation
import UIKit

protocol CalcCaloriesDelegate {
    func updateCalories(addValue: Int)
    /* we create a protocol on top of the source view controller, it is like a header for a C program. */
}


class SelectMealTableViewController: UITableViewController{
    

    var calorie = 0
    
    private var foods: [Food] = []
    
    var delegate: CalcCaloriesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFoods()
        
        //foods = ["Eggs (80 Calories)":70,"Steak (679 Calories)":89,"Slice of Bread (78 Calories)":88]
        
    }
    
    
    @IBAction func submitCalories(_ sender: Any) {
        delegate?.updateCalories(addValue: calorie)
    }
    
    
    func addFoods(){
        
        foods.append(Food(name: "Boiled Egg (78)", calories: 78))
        foods.append(Food(name: "Brown Medium Grain Rice (110)", calories: 110))
        foods.append(Food(name: "Chicken Drumstick (155)", calories: 155))
        foods.append(Food(name: "Duck (330)", calories: 330))
        foods.append(Food(name: "Fried Egg (90)", calories: 90))
        foods.append(Food(name: "Poached Egg(71)", calories: 71))
        foods.append(Food(name: "Pork Belly (585)", calories: 585))
        foods.append(Food(name: "Regular French Fries (375)", calories: 375))
        foods.append(Food(name: "Sausage (230)",  calories: 230))
        foods.append(Food(name: "Slice Of Bread (78)", calories: 78))
        foods.append(Food(name: "Slice Of Pizza (285)", calories: 285))
        foods.append(Food(name: "Shrimp Scampi Pasta (1000)", calories: 1000))
        foods.append(Food(name: "Steak (679)", calories: 679))
        foods.append(Food(name: "White Rice (105)", calories: 105))
        foods.append(Food(name: "Whole Beef Burger (400)", calories: 400))
        
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if(cell.accessoryType != .checkmark){
                cell.accessoryType = .checkmark
                let addCalorie = foods[indexPath.row].calories
                calorie += addCalorie
            }
            else{
                cell.accessoryType = .none
                let subtractCalorie = foods[indexPath.row].calories
                calorie -= subtractCalorie
                
            }
        }
    }
            
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        tableViewCell.textLabel?.text = foods[indexPath.row].name
        return tableViewCell
    }
    
}







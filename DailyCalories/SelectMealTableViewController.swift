//
//  SelectMealTableViewController.swift
//  DailyCalories
//
//  Created by Vincent Siu on 8/3/23.
//  this is myt code

import Foundation
import UIKit

protocol CalcCaloriesDelegate {
    func updateCalories(addValue: Int, addFoods: [String])
    /* we create a protocol on top of the source view controller, it is like a header for a C program. */
}
//protocol calorieFoodLogDelegate{
//    func updateLogTable(addFoods: [String])
//}

var food_array = [String]()
var filter_food_array = [String]()
var searching = false


class SelectMealTableViewController: UITableViewController{
    

    var calorie = 0
    
    var food_to_add = [String]()
    
    private var foods: [Food] = []
    
    var delegate: CalcCaloriesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFoods()
        
        //foods = ["Eggs (80 Calories)":70,"Steak (679 Calories)":89,"Slice of Bread (78 Calories)":88]
        
    }
    
    
    
    @IBAction func submitCalories(_ sender: Any) {
        delegate?.updateCalories(addValue: calorie, addFoods: food_to_add)
        //delegate1?.updateLogTable(addFoods: food_to_add)
        
    }
    
    
    func addFoods(){
        
        foods.append(Food(name: "Apple (95)", calories: 95))
        food_array.append("Apple")
        
        foods.append(Food(name: "Banana (105)", calories: 105))
        food_array.append("Banana")
        
        foods.append(Food(name: "Boiled Egg (78)", calories: 78))
        food_array.append("Boiled Egg")
        
        foods.append(Food(name: "Brown Medium Grain Rice (110)", calories: 110))
        food_array.append("Brown Medium Grain Rice")
        
        foods.append(Food(name: "Cheese Tart Piece(230)", calories: 230))
        food_array.append("Cheese Tart Piece")
        
        foods.append(Food(name: "Cheesecake - 1 Slice (401)", calories: 401))
        food_array.append("Cheesecake - 1 Slice")
        
        foods.append(Food(name: "Chicken Drumstick - 1 Piece (155)", calories: 155))
        food_array.append("Chicken Drumstick")
        
        foods.append(Food(name: "Chicken Pot Pie - 1 Pie (599)", calories: 600))
        food_array.append("Chicken Pot Pie - 1 Pie")
        
        foods.append(Food(name: "Cupcake without icing - 1 Piece (110)", calories: 110))
        food_array.append("Cupcake without icing - 1 Piece")
        
        foods.append(Food(name: "Cupcake with icing (178)", calories: 178))
        food_array.append("Cupcake with icing")
        
        foods.append(Food(name: "Donut Hole - 1 Piece (52)", calories: 52))
        
        foods.append(Food(name: "Duck (330)", calories: 330))
        food_array.append("Donut Hole - 1 Piece")
        
        foods.append(Food(name: "Fried Egg (90)", calories: 90))
        food_array.append("Fried Egg")
        
        foods.append(Food(name: "Hash Brown (470)", calories: 470))
        food_array.append("Hash Brown")
        
        foods.append(Food(name: "Milk - 1 Cup (103)", calories: 103))
        food_array.append("Milk - 1 Cup")
        
        foods.append(Food(name: "Peanut Butter and Jelly Sandwich (326)", calories: 326))
        food_array.append("Peanut Butter and Jelly Sandwich")
        
        foods.append(Food(name: "Poached Egg(71)", calories: 71))
        food_array.append("Poached Egg")
        
        foods.append(Food(name: "Pork Belly (585)", calories: 585))
        food_array.append("Pork Belly")
        
        foods.append(Food(name: "Regular French Fries (375)", calories: 375))
        food_array.append("Regular French Fries")
        
        foods.append(Food(name: "Sausage (230)",  calories: 230))
        food_array.append("Sausage")
        
        foods.append(Food(name: "Slice Of White Bread (133)", calories: 133))
        food_array.append("Slice Of White Bread")
        
        foods.append(Food(name: "Slice Of Pizza (285)", calories: 285))
        food_array.append("Slice Of Pizza")
        
        foods.append(Food(name: "Shrimp Scampi Pasta (1000)", calories: 1000))
        food_array.append("Shrimp Scampi Pasta")
        
        foods.append(Food(name: "Steak (679)", calories: 679))
        food_array.append("Steak")
        
        foods.append(Food(name: "Strawberries - approx. 5 Pieces (30)", calories: 30))
        food_array.append("Strawberries")
        
        foods.append(Food(name: "Strawberry Jam Sandwich (200)", calories: 200))
        food_array.append("Strawberry Jam Sandwich")
        
        foods.append(Food(name: "White Rice (105)", calories: 105))
        food_array.append("White Rice")
        
        foods.append(Food(name: "Whole Beef Burger (400)", calories: 400))
        food_array.append("Whole Beef Burger")
        
        foods.append(Food(name: "Wonton Soup Noodle (213)", calories: 213))
        food_array.append("Wonton Soup Noodle")
        
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching{
            return filter_food_array.count
        }
        else{
            return foods.count
        }

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if(cell.accessoryType != .checkmark){
                cell.accessoryType = .checkmark
                let addCalorie = foods[indexPath.row].calories
                let addFoodItem = foods[indexPath.row].name
                print("adding" + addFoodItem)
                food_to_add.append(addFoodItem)
                print(food_to_add)
                calorie += addCalorie
            }
            else{
                cell.accessoryType = .none
                let subtractCalorie = foods[indexPath.row].calories
                let removeFoodItem = foods[indexPath.row].name
                if food_to_add.contains(removeFoodItem){
                    food_to_add = food_to_add.filter({$0 != removeFoodItem})
                }
                
                calorie -= subtractCalorie
                
            }
        }
    }
            
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //display the contents of the table
        if searching{
            let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            tableViewCell.textLabel?.text = filter_food_array[indexPath.row]
            return tableViewCell
            
        }
        else{
            print("return table viewcontents")
            let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            tableViewCell.textLabel?.text = foods[indexPath.row].name
            return tableViewCell
        }
        
        
    }
    
}

extension UITableViewController: UISearchBarDelegate{
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        print("searching initiated")
        searching = true
        filter_food_array = food_array.filter({$0.prefix(searchText.count) == searchText})
        tableView.reloadData()
    }
}







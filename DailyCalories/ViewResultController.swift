//
//  ViewResultController.swift
//  DailyCalories
//
//  Created by Vincent Siu on 9/8/24.
//

import Foundation
import UIKit
import TensorFlowLite
import SwiftUI
import CoreData




class ViewResultController: UIViewController, saveFoodDelegate{
    
    @IBOutlet weak var mealTypeSelection: UIButton!
    
    var mealType = "Snack/Other"
    var foodItem = "None"
    var numCalories = 0
    var date = Date()
    
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated )
        retrieveImage(imageName: "photo.jpg")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDropdownOptions()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH"
        let dateToConvert = Date()
        let time = Int(timeFormatter.string(from: dateToConvert))
        print("hour of the day is \(time)")
        if time ?? 0 >= 6 && time ?? 0 <= 11{
            mealType = "Breakfast"
            mealTypeSelection.titleLabel?.text = "Breakfast"
        }
        else if time ?? 0 > 11 && time ?? 0 <= 14{
            mealType = "Lunch"
            mealTypeSelection.titleLabel?.text = "Lunch"
        }
        if time ?? 0 >= 17 && time ?? 0 <= 21{
            mealType = "Dinner"
            mealTypeSelection.titleLabel?.text = "Dinner"
        }
        else{
            mealType = "Snack/Other"
            mealTypeSelection.titleLabel?.text = "Snack/Other"
        }
        
    }
    
    func setupDropdownOptions(){
        
        guard let mealTypeSelection = mealTypeSelection else{
            print("selection is nil")
            return
        }
        
        let breakfastOption = {(action: UIAction) in
            self.mealType = "Breakfast"
            mealTypeSelection.titleLabel?.text = "Breakfast"
        }
        let lunchOption = {(action: UIAction) in
            self.mealType = "Lunch"
            mealTypeSelection.titleLabel?.text = "Lunch"
        }
        let dinnerOption = {(action: UIAction) in
            self.mealType = "Dinner"
            mealTypeSelection.titleLabel?.text = "Dinner"
        }
        let snackOption = {(action: UIAction) in
            self.mealType = "Snack/Other"
            mealTypeSelection.titleLabel?.text = "Snack/Other"
        }
        
        mealTypeSelection.menu = UIMenu(children:[
            UIAction(title:"Breakfast", handler: breakfastOption),
            UIAction(title:"Lunch", handler: lunchOption),
            UIAction(title:"Dinner", handler: dinnerOption),
            UIAction(title:"Snack/Other", handler: snackOption)])
        
        mealTypeSelection.showsMenuAsPrimaryAction = true
    }
    
    
    var prevCalories = PrevCalories()
    
    
    
    
    @IBOutlet weak var displayedResult: UIImageView!
    
    @IBOutlet weak var textResult: UILabel!
    
    
    
    func didSaveFood(){
        print("Food was saved.")
    }
 
        
    
    func retrieveImage(imageName: String){
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            
            let obtainedImage = UIImage(contentsOfFile: imagePath)
            displayedResult.image = obtainedImage
            if let resultCGImage = obtainedImage?.cgImage{
                analyzeImage(imageData: resultCGImage)
            }else{
                print("failed to obtain cgiamge")
            }
        }
        else{
            print("Error: Failed to find image")
        }
    }
    
    
    func analyzeImage(imageData: CGImage){
        
        let image: CGImage = imageData
        
        guard let context = CGContext(data: nil, width: image.width, height: image.height, bitsPerComponent: 8, bytesPerRow: image.width * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)else{return}
        
        context.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
        guard let imageData = context.data else {return}
        
        var inputData = Data()
        for row in 0 ..< 180{
            for col in 0 ..< 180{
                let offset = 4 * (row * context.width + col)
                    // (Ignore offset 0, the unused alpha channel)
                let red = imageData.load(fromByteOffset: offset+1, as: UInt8.self)
                let green = imageData.load(fromByteOffset: offset+2, as: UInt8.self)
                let blue = imageData.load(fromByteOffset: offset+3, as: UInt8.self)
                
                //We need to normalize the RGB values to be between [-1,1]
                var normalizedRed = Float32(red)/255.0
                var normalizedGreen = Float32(green)/255.0
                var normalizedBlue = Float32(blue)/255.0
                
                let elementSize = MemoryLayout.size(ofValue: normalizedRed)
                var bytes = [UInt8](repeating: 0, count: elementSize)
                memcpy(&bytes, &normalizedRed, elementSize)
                inputData.append(&bytes, count:elementSize)
                memcpy(&bytes, &normalizedGreen, elementSize)
                inputData.append(&bytes, count:elementSize)
                memcpy(&bytes, &normalizedBlue, elementSize)
                inputData.append(&bytes, count:elementSize)
            }
            
        }
        
       // guard let modelPath = Bundle.main.path(forResource: "example_model", ofType:"tflite")else{
        //    fatalError("Model not found at \(modelPath)")
        //}
        guard let modelPath = Bundle.main.path(forResource:"example_model",ofType: "tflite")else{
            fatalError("Could not find model")
        }
        do{
            
            let interpreter = try Interpreter(modelPath: modelPath)
            try interpreter.allocateTensors()
            try interpreter.copy(inputData, toInputAt: 0)
            try interpreter.invoke()
            let output = try interpreter.output(at: 0)
            print("tensorflow invoked")
            let probabilities = UnsafeMutableBufferPointer<Float32>.allocate(capacity:1000)
            output.data.copyBytes(to: probabilities)
            guard let labelPath = Bundle.main.path(forResource: "testlabels", ofType: "txt")else{return}
            let fileContents = try? String(contentsOfFile: labelPath, encoding: .utf8)
            guard let labels = fileContents?.components(separatedBy: "\n")else{return}
            var max_index = 0
            for i in labels.indices{
                print("\(labels[i]): \(probabilities[i])")
                if (probabilities[i] > probabilities[max_index]){
                    max_index = i
                }

            }
            
            
            
            print("a \(labels[max_index]) was detected with the probability of \(probabilities[max_index])")
            textResult.text = "a \(labels[max_index]) was detected with the probability of \(probabilities[max_index])"
            
            self.foodItem = labels[max_index]
            self.numCalories = 55
            
            
            
            
            
        } catch let error{
            print("Error: \(error)")
        }
        
        
        
    }
    
    @IBAction func TriggerAddMeal(_ sender: UIButton){
        
        if self.foodItem != "None"{
            self.foodItem = "None"
            let context = PrevCalories.shared.viewContext
            
            prevCalories.addFooditem(date: self.date, food: self.foodItem, numCalories: Int(self.numCalories), mealType: self.mealType, context: context)
            
            //let date = Date()
            
            //prevCalories.delegate = self
            //self.numCalories = 55
            //self.foodItem = labels[max_index]
            //prevCalories.addFooditem(date: date, food: (labels[max_index]), numCalories: 55, mealType: "breakfast", context: context)
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PastCalories")
            do{
                let entries = try context.fetch(fetchRequest)
                for ent in entries{
                    if let foodItem = ent.value(forKey: "foodItem") as? String, let numCal = ent.value(forKey: "calories") as? Int32, let date = ent.value(forKey: "date") as? Date{
                        print("date fetched")
                        print("food: \(foodItem), Calories: \(numCal), Date: \(date)")
                    }
                }
            } catch let error as NSError{
                print("unable to fetch, \(error), \(error.userInfo)")
            }
        }
        else{
            let popup = UIAlertController(title: "Data already saved!", message: "You have already saved your entry. To add more, go back and take another photo.", preferredStyle: .alert)
            let okOption = UIAlertAction(title: "Ok", style: .default)
            popup.addAction(okOption)
            present(popup, animated: true, completion: nil)
        }
        
        
    }
    
}

    


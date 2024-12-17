//
//  AddMeal.swift
//  DailyCalories
//
//  Created by Vincent Siu on 9/6/24.
//

import Foundation
import UIKit

protocol capturePhotoDelegate: AnyObject{
    func capturePhoto()
}



class AddMeal: UIViewController{
        
    
    private let cameraManager = CameraManager()
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    weak var delegate: capturePhotoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task{
            for await cgImage in cameraManager.previewStream{
                DispatchQueue.main.async{
                    self.imageView.image = UIImage(cgImage: cgImage)
                }
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleSavedPhoto), name: .photoSavedNotification, object: nil)
    }
    

    @IBAction func captPhoto(_ sender: UIButton){
        
        
        NotificationCenter.default.post(name: .buttonPressedNotification, object: nil)
    }
    
    @objc func handleSavedPhoto(){
        performSegue(withIdentifier: "openResults", sender: self)
    }
    
    
    
    
}

extension Notification.Name{
    static let buttonPressedNotification = Notification.Name("buttonPressedNotification")
}

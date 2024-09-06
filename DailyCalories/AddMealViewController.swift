//
//  AddMealViewController.swift
//  DailyCalories
//
//  Created by Vincent Siu on 9/5/24.
//

import Foundation
import UIKit



class AddMealViewController: UIViewController{
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        imageView.backgroundColor = .secondarySystemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("called")
        captureImage()
    }
    
    
    
    func captureImage(){
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
        print("main called")
    }
}

extension AddMealViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        let defaultViewController = storyboard?.instantiateViewController(withIdentifier: "CurrentViewController") as! CurrentViewController
        navigationController?.pushViewController( defaultViewController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        imageView.image = image
    }
    
}

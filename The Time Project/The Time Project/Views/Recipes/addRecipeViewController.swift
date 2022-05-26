//
//  addRecipeViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 25.04.22.
//

import Foundation
import UIKit

class addRecipeViewController:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var imageField: UILabel!
    @IBOutlet var imageButton: UIButton!
    @IBOutlet var commentField: UITextView!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var errorLabel:UILabel!

    var chosenImage:UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturn))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }
    
    @IBAction func safeButtonPressed(_ sender: Any) {
        self.errorLabel.isHidden = true
        DatabaseRecipesManager.shared.addRecipes(name: nameField.text, image: imageField.text, recipe: commentField.text){ success, error in
            if success{
                if self.imageField.text != "Image "{
                    StorageManager.shared.setRecipeImage(imageName: self.imageField.text, image: self.chosenImage)
                }
                
                _ = self.navigationController?.popViewController(animated: true)
            }
            else{
                self.setErrorLabel(error: error!)
                self.errorLabel.isHidden = false
            }
        }
    }
    
    
    @IBAction func imageButtonPressed(_ sender:Any){
        let vc = UIImagePickerController();
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            imageField.text = imageURL.lastPathComponent
        }
        
        //Get selected image
        if let image = info[UIImagePickerController.InfoKey(rawValue:"UIImagePickerControllerEditedImage")] as? UIImage{
            chosenImage = image
        }
        dismiss(animated: true);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func setErrorLabel(error:DatabaseRecipesManager.RecipesError){
        switch error {
        case .noName:
            errorLabel.text = "Name requred"
            break
        case .noRecipe:
            errorLabel.text = "Recipe requred"
            break
        }
    }
}

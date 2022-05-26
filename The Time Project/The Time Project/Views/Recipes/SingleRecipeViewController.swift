//
//  SingleRecipeViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 26.05.22.
//

import Foundation
import UIKit
import Kingfisher

class singleRecipeViewController:UIViewController{
    
    var edit = false
    var recipe = Recipe()
    let priority = ["Low","Middle", "High"]
    let priorityPicker = UIPickerView()
    var selectedPriority:Int? = nil
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var commentField: UITextView!
    @IBOutlet var safeButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var deleteButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturn))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        recipe = DatabaseRecipesManager.shared.chosenRecipe
        
        setRecipe()
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }
    
    func setRecipe(){
        titleField.text = recipe.name
        commentField.text = recipe.recipe
        StorageManager.shared.getRecepiePicture(imageName: recipe.image){urlString in
            let url=URL(string: urlString)
            self.recipeImage.kf.setImage(with:url)
        }
        
        titleField.isEnabled = false
        commentField.isEditable = false
        safeButton.isHidden = true
    }
    
    func editRecipe(){
        titleField.isEnabled = true
        commentField.isEditable = true
        
        safeButton.isHidden = false
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        if edit{
            edit = false
            setRecipe()
        }
        else{
            edit = true
            editRecipe()
        }
    }
    
    @IBAction func safeButtonPressed(_ sender: UIButton) {
        errorLabel.isHidden = true
        guard let title = titleField.text else{
            setErrorLabel(error: .noName)
            errorLabel.isHidden = false
            return
        }
        
        guard let comment = commentField.text else{
            setErrorLabel(error: .noRecipe)
            errorLabel.isHidden = false
            return
        }
        
        recipe.name = title
        recipe.recipe = comment
        
        DatabaseRecipesManager.shared.editRecipes(recipe: recipe)
        self.alertSuccess(sender,true)
        setRecipe()
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        DatabaseRecipesManager.shared.deleteRecipes(recipe: recipe){ success in
            if success{
                self.alertSuccess(sender, false)
            }
        }
    }
    
    
    func alertSuccess(_ sender: UIButton,_ edit:Bool) {
        
        var title="",message=""
        if edit{
            title = "Recipe Edited"
            message = "You have successfully edited this recipe!"
        }
        else{
            title = "Recipe Deleted"
            message = "You have successfully deleted this Recipe!"
        }
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default,handler: { _ in _ = self.navigationController?.popViewController(animated: true)}))
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = sender.bounds
        }
        
        present(alert, animated: true)
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


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
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var commentField: UITextView!
    @IBOutlet var safeButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var recipeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLanguage()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturn))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        recipe = DatabaseRecipesManager.shared.chosenRecipe
        
        setRecipe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLanguage()
    }
    
    func setLanguage(){
        if DatabaseUserManager.shared.bg{
            deleteButton.setTitle("Изтрии", for: .normal)
            nameLabel.text = "Име:"
            recipeLabel.text = "Рецепта:"
            safeButton.setTitle("Запази", for: .normal)
        }
        else{
            deleteButton.setTitle("Delete", for: .normal)
            nameLabel.text = "Name:"
            recipeLabel.text = "Recipe:"
            safeButton.setTitle("Save", for: .normal)
        }
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
        
        if title == ""{
            setErrorLabel(error: .noName)
            errorLabel.isHidden = false
            return
        }
        else if comment == ""{
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
        if edit && DatabaseUserManager.shared.bg{
            title = "Рецепта редактирана"
            message = "Успешно редактирахте тази рецепта!"
        }
        else if !edit && DatabaseUserManager.shared.bg{
            title = "Рецепта изтрита"
            message = "Успешно изтрихте тази рецепта!"
        }
        else if !edit{
            title = "Deleted recipe"
            message = "You successfully deleted this recipe!"
        }
        else{
            title = "Recipe edited"
            message = "You successfully edited this recipe!"
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
        if DatabaseUserManager.shared.bg{
            switch error {
            case .noName:
                errorLabel.text = "Трябва име."
                break
            case .noRecipe:
                errorLabel.text = "Трябва да има рецепта"
                break
            }
        }
        else{
            switch error {
            case .noName:
                errorLabel.text = "Name required."
                break
            case .noRecipe:
                errorLabel.text = "Recipe required"
                break
            }
        }
        
    }
}


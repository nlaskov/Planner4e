//
//  DatabaseRecipesManager.swift
//  The Time Project
//
//  Created by Nikola Laskov on 21.04.22.
//

import Foundation
import FirebaseDatabase
import Firebase
import FirebaseFirestoreSwift


class DatabaseRecipesManager:NSObject{
    
    static let shared = DatabaseRecipesManager()
    private let ref = Firestore.firestore()
    
    var recipes:[Recipe]=[Recipe("Recipe 1", "", "", "1"),Recipe("Recipe 2", "", "", "2"),Recipe("Recipe 3", "", "", "3"),Recipe("Recipe 4", "", "", "4"),Recipe("Recipe 5", "", "", "5"),Recipe("Recipe 6", "", "", "6"),Recipe("Recipe 7", "", "", "7"),Recipe("Recipe 8", "", "", "8"),Recipe("Recipe 9", "", "", "9"),Recipe("Recipe 0", "", "", "0")]
    
    var chosenRecipe:Recipe = Recipe()
    
    func getRecipes(completion: @escaping () -> () ){
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Recipes").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for document in querySnapshot!.documents{
                    let recipe = Recipe(document["name"] as! String, document["image"] as! String, document["recipe"] as! String, document["id"] as! String)
                    self.recipes.append(recipe)
                }
                completion()
            }
            
        }
    }
    
    func addRecipes(name:String?,image:String? ,recipe:String?,completion: @escaping (_ success: Bool, _ error: RecipesError?) -> ()){
        
        guard let name = name else {
            completion(false, RecipesError.noName)
            return
        }
    
        guard let recipe = recipe else {
            completion(false, RecipesError.noRecipe)
            return
        }
        
        guard let image = image else {
            let temp = UUID().uuidString
            ref.collection("\(DatabaseUserManager.shared.user.UID)_Recipes").document(temp).setData([
                "name": name,
                "image": "",
                "recipe": recipe,
                "id":temp])
            
            recipes.append(Recipe(name, "", recipe, temp))
            completion(true, nil)
            return
        }
        
        let temp = UUID().uuidString
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Recipes").document(temp).setData([
            "name": name,
            "image": image,
            "recipe": recipe,
            "id":temp])
        
        recipes.append(Recipe(name, image, recipe, temp))
        completion(true, nil)
        
    }
    
    func editRecipes(recipe:Recipe){
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Recipes").document(recipe.id).setData([
            "name": recipe.name,
            "image": recipe.image,
            "recipe":recipe.recipe,
            "id":recipe.id])
    }
    
    func deleteRecipes(recipe:Recipe,completion: @escaping (_ success: Bool) -> ()){
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Recipes").document(recipe.id).delete(){ error in
            if let _ = error{
                completion(false)
                return
            }
        }
        
        var count=0
        for item in recipes{
            if item.id == recipe.id{
                recipes.remove(at: count)
                completion(true)
            }
            else{
                count+=1
            }
        }
        
    }
    
    enum RecipesError: Error{
        case noName
        case noRecipe
    }
    
}

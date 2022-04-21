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
    
    var recipes:[Recipe]=[]
    
    var chosenRecipe:Recipe = Recipe()
    
    func getRecipes(completion: @escaping () -> () ){
        
    }
    
    func addRecipes(name:String?,priority:Int? ,author:String?,comment:String?,completion: @escaping (_ success: Bool, _ error: RecipesError?) -> ()){
        
        
    }
    
    func editRecipes(book:Book){
        
    }
    
    func deleteRecipes(book:Book,completion: @escaping (_ success: Bool) -> ()){
        
    }
    
    enum RecipesError: Error{
        case noName
        case noRecipe
    }
    
}

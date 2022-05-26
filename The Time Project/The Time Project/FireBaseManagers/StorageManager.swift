//
//  storageManager.swift
//  The Time Project
//
//  Created by Nikola Laskov on 20.04.22.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseAuth

class StorageManager: NSObject{
    
    static let shared = StorageManager()
    private var ref = Storage.storage().reference()
    var recipesImages:[String] = []
    
    func getProfilePicture(imageName:String, completion: @escaping (_ urlString:String) -> () ){
        ref.child(Auth.auth().currentUser!.uid).child(imageName).downloadURL{ url, error in
            if let error = error {
                print(error)
                
            } else {
                guard let url = url else {
                    return
                }
                completion(url.absoluteString)
            }
        }
    }
    
    func getRecepiePicture(imageName:String, completion: @escaping (_ urlString:String) -> () ){
        ref.child(Auth.auth().currentUser!.uid).child("Recipes").child(imageName).downloadURL{ url, error in
            if let error = error {
                print(error)
            } else {
                guard let url = url else {
                    return
                }
                completion(url.absoluteString)
            }
        }
    }
    
    func changeProfilePicture(newImageName:String, newImage:UIImage){
        
    }
    
    func setProfileImage(imageName:String?, image:UIImage){
        guard let imageName = imageName else{
            let recipeRef = ref.child(DatabaseUserManager.shared.user.UID).child(UUID().uuidString)
            let imageData = image.pngData()
            let _ = ref.putData(imageData!, metadata: nil)
            return
        }
        let recipeRef = ref.child(DatabaseUserManager.shared.user.UID).child(imageName)
        let imageData = image.pngData()
        let _ = recipeRef.putData(imageData!, metadata: nil)
    }
    
    func setRecipeImage(imageName:String?, image:UIImage){
        
        guard let imageName = imageName else{
            let recipeRef = ref.child("\(Auth.auth().currentUser!.uid)/Recipes/\(UUID().uuidString)")
            let imageData = image.pngData()
            let _ = recipeRef.putData(imageData!, metadata: nil)
            return
        }
        let recipeRef = ref.child(Auth.auth().currentUser!.uid).child("Recipes").child(imageName)
        let imageData = image.pngData()
        let _ = recipeRef.putData(imageData!, metadata: nil)
        
    }
    
    
    
}

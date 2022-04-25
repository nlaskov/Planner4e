//
//  storageManager.swift
//  The Time Project
//
//  Created by Nikola Laskov on 20.04.22.
//

import Foundation
import UIKit
import FirebaseStorage

class StorageManager: NSObject{
    
    static let shared = StorageManager()
    private var ref = Storage.storage().reference()
    var profilePicture: String? = nil
    
    func getProfilePicture(imageName:String, completion: @escaping () -> () ){
        ref.child(DatabaseUserManager.shared.user.UID).child(imageName).downloadURL{ url, error in
            if let error = error {
                print(error)
                
            } else {
                guard let url = url else {
                    return
                }
                self.profilePicture = url.absoluteString
                completion()
            }
        }
    }
    
    func getRecepiePicture(imageName:String, completion: @escaping () -> () )->UIImage{
        ref.child(DatabaseUserManager.shared.user.UID).child("Recepies").child(imageName)
        return UIImage(named: "eclair") ?? UIImage()
    }
    
    func changePrifilePicture(oldImageName:String, newImageName:String, newImage:UIImage){
        
    }
    
    func changeRecipePicture(oldImageName:String, newImageName:String, newImage:UIImage){
        
    }
    
    func setProfileImage(imageName:String, image:UIImage){
        
    }
    
    func setRecipeImage(imagename:String, image:UIImage){
    }
    
    
    
}

//
//  DatabaseUserManager.swift
//  The Time Project
//
//  Created by Nikola Laskov on 16.04.22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import UIKit
class DatabaseUserManager:NSObject{
    
    static let shared = DatabaseUserManager()
    private let ref = Firestore.firestore()
    var user = User()
    
    func getUser(UID:String) -> User{

        ref.collection("Users").document(UID).getDocument(as: User.self){result in
            switch result {
                case .success(let result):
                self.user = result

                case .failure:
                self.user = User()
            }
        }
        return user
    }
    
    func addUser(user:User){
        
        ref.collection("Users").document(user.UID).setData([
            "name": user.name,
            "email":user.email,
            "image":user.image
        ])
    }
    
    func changeEmail(newEmail:String?){
        
        guard let newEmail = newEmail else {
            return
        }
        user.email = newEmail
        ref.collection("Users").document(user.UID).setData(["email":user.email],merge: true)
        
    }
    
    func changeName(newName:String?){
        
        guard let newName = newName else {
            return
        }
        user.name = newName
        ref.collection("Users").document(user.UID).setData(["name":user.name],merge: true)
        
    }
    
    func changeImage(newImageName:String?, newImage:UIImage){
        
        guard let newImageName = newImageName else {
            return
        }
        user.image = newImageName
        ref.collection("Users").document(user.UID).setData(["image":user.image])
        
        
    }
    
}

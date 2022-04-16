//
//  DatabaseUserManager.swift
//  The Time Project
//
//  Created by Nikola Laskov on 16.04.22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
class DatabaseUserManager:NSObject{
    
    static let shared = DatabaseUserManager()
    let ref = Firestore.firestore()
    var user:User = User()
    
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
    
    func changeEmail(){
        
    }
    
    func changePassword(){
        
    }
    
}

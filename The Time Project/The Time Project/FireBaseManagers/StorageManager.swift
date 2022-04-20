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
    var recepies: [String] = []
    
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
    
    func getRecepiePicture(imageName:String, completion: @escaping () -> () ){
        ref.child(DatabaseUserManager.shared.user.UID).child("Recepies").listAll { (result, error) in
            
            if let error = error {
                print(error)
            }
            
            var count = result!.items.count
            for item in result!.items {
                
                item.downloadURL { url, error in
                    if let error = error {
                        print(error)
                        
                    } else {
                        guard let url = url else {
                            return
                        }
                        self.recepies.append(url.absoluteString)
                        count -= 1
                        if count == 0 {
                            completion()
                        }
                    }
                }
            }
    }
    }
    
    
    
}

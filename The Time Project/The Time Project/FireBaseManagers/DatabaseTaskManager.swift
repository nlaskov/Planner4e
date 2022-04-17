//
//  DatabaseTaaskManager.swift
//  The Time Project
//
//  Created by Nikola Laskov on 17.04.22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
class DatabaseTaskManager:NSObject{
    
    static let shared = DatabaseTaskManager()
    let ref = Firestore.firestore()
    
    var tasks:[Task] = []
    var user:User? = nil
    
   
    func getTasks(){
        ref.collection("\(AuthManager.shared.currentUser.UID)_Tasks").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.getDocument(as: Task.self){result in
                        
                        switch result {
                            case .success(let result):
                                self.tasks.append(result)
                            case .failure(let error):
                                print("Error decoding city: \(error)")
                        }
                    }
                }
            }
        }
    }
    //func addTask
    //func changeTask
    //func deleteTask
    //
    
}

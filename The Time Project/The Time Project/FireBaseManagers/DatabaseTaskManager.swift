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
    
   
    func getTasks(completion: @escaping () -> ()){
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Tasks").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    var task = Task(_name: document["name"] as! String, _priority: document["priority"] as! Int, _category: document["category"] as! Int, _day: document["day"] as! Int, _month: document["month"] as! Int, _year: document["year"] as! Int, _done: document["done"] as! Bool)
                    
                    self.tasks.append(task)
                }
                completion()
            }
        }
    }
    //func addTask
    //func changeTask
    //func deleteTask
    //
    
}

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
    private let ref = Firestore.firestore()
    
    var tasks:[Task] = []
    
   
    func getTasks(completion: @escaping () -> ()){
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Tasks").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let task = Task(_name: document["name"] as! String, _priority: document["priority"] as! Int, _category: document["category"] as! Int, _day: document["day"] as! Int, _month: document["month"] as! Int, _year: document["year"] as! Int, _done: document["done"] as! Bool)
                    
                    self.tasks.append(task)
                }
                completion()
            }
        }
    }
    
    func addTask(name:String?, priority:Int?, category:Int?, date:String?, comment:String?,completion: @escaping (_ success: Bool, _ error: TaskError?) -> ()){
        
        guard let name = name else {
            completion(false, TaskError.noName)
            return
        }
        
        guard let priority = priority else {
            completion(false, TaskError.noPriority)
            return
        }
        
        guard let category = category else {
            completion(false, TaskError.noCategory)
            return
        }
        guard let date = date else {
            completion(false,TaskError.noDate)
            return
        }

        let IntDate = getDate(date:date)
        
        guard let comment = comment else {
            ref.collection("\(DatabaseUserManager.shared.user.UID)_Tasks").document(UUID().uuidString).setData([
                "name":name,
                "priority":priority,
                "category":category,
                "day":IntDate[0],
                "month":IntDate[1],
                "year":IntDate[2],
                "done":false
            ])
            tasks.append(Task(_name: name, _priority: priority, _category: category, _day: IntDate[0], _month: IntDate[1], _year: IntDate[2], _done: false))
            completion(true,nil)
            return
        }
        
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Tasks").document(UUID().uuidString).setData([
            "name":name,
            "priority":priority,
            "category":category,
            "day":IntDate[0],
            "month":IntDate[1],
            "year":IntDate[2],
            "done":false
        ])
        tasks.append(Task(_name: name, _priority: priority, _category: category, _day: IntDate[0], _month: IntDate[1], _year: IntDate[2], _done: false))
        completion(true,nil)
        return
    }
    
    func getDate(date:String)-> [Int]{
        let split = date.components(separatedBy: "/")
        print(split)
        var intDate:[Int] = []
        intDate.append(Int(split[1])!)
        intDate.append(Int(split[0])!)
        intDate.append(Int(split[2])!+2000)
        return intDate
    }
    
    enum TaskError:Error{
        case noName
        case noPriority
        case noCategory
        case noDate
    }
    
}

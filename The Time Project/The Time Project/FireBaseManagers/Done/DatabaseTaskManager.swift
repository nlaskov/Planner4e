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
    var chosenTask:Task = Task()
    
    var tasks:[Task] = []
    
   
    func getTasks(completion: @escaping () -> ()){
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Tasks").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let task = Task(document["name"] as! String, document["priority"] as! Int, document["category"] as! Int, document["day"] as! Int, document["month"] as! Int, document["year"] as! Int, document["done"] as! Bool, document["comment"] as! String, document["id"] as! String)
                    
                    self.tasks.append(task)
                }
                completion()
            }
        }
    }
    
    func dateCheck(date:Date,task:Task) ->Bool {
        let used_month = task.month
        let month = Calendar.current.component(.month, from: date)
        
        if(month != 12 && month != 1){
            if(used_month - month > 1 || used_month - month < -1){
                return false
            }
            else {return true}
        }
        else{
            if((month == 12 && (used_month == 1 || used_month == 11)) || (month == 1 && (used_month == 12 || used_month == 2)) ){
                return true
            }
        }
        return false
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
            let temp = UUID().uuidString
            ref.collection("\(DatabaseUserManager.shared.user.UID)_Tasks").document(temp).setData([
                "name":name,
                "priority":priority,
                "category":category,
                "day":IntDate[0],
                "month":IntDate[1],
                "year":IntDate[2],
                "done":false,
                "comment":"",
                "id":temp
            ])
            
            tasks.append(Task(name, priority, category, IntDate[0], IntDate[1], IntDate[2], false,"",temp))
            completion(true,nil)
            return
        }
        
        let temp = UUID().uuidString
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Tasks").document(temp).setData([
            "name":name,
            "priority":priority,
            "category":category,
            "day":IntDate[0],
            "month":IntDate[1],
            "year":IntDate[2],
            "done":false,
            "comment":comment,
            "id":temp
        ])
        tasks.append(Task(name, priority, category, IntDate[0], IntDate[1], IntDate[2], false, comment, temp))
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
    
    func deleteTask(task:Task,completion: @escaping (_ success: Bool) -> ()){
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Tasks").document(task.id).delete(){ error in
            if let _ = error{
                completion(false)
                return
            }
            var count=0
            for item in self.tasks{
                if item.id == task.id{
                    self.tasks.remove(at: count)
                }
                else{
                    count+=1
                }
            }
        }
    }
    
    func editTask(task:Task){
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Tasks").document(task.id).setData([
            "name":task.name,
            "priority":task.priority,
            "category":task.category,
            "day":task.day,
            "month":task.month,
            "year":task.year,
            "done":task.done,
            "comment":task.comment,
            "id":task.id])
    }
    
    enum TaskError:Error{
        case noName
        case noPriority
        case noCategory
        case noDate
    }
    
}

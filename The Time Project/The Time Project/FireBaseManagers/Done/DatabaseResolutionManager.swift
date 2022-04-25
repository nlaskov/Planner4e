//
//  DatabaseResolutionManager.swift
//  The Time Project
//
//  Created by Nikola Laskov on 21.04.22.
//

import Foundation
import FirebaseDatabase
import Firebase
import FirebaseFirestoreSwift


class DatabaseResolutionManager:NSObject{
    
    static let shared = DatabaseResolutionManager()
    private var ref = Firestore.firestore()
    
    var resolutions_undone:[Resolution]=[]
    var resolutions_done:[Resolution]=[]
    var chosenResolution:Resolution = Resolution()
    
    func getResolution(completion: @escaping () -> ()){
        
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Resolutions").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let resolution = Resolution(document["name"] as! String, document["priority"] as! Int, document["done"] as! Bool, document["comment"] as! String, document["id"] as! String)
                    if resolution.done{
                        self.resolutions_done.append(resolution)
                    }
                    else{
                        self.resolutions_undone.append(resolution)
                    }
                }
                completion()
            }
        }
    }
    
    func addResolution(name:String?,priority:Int?,comment:String?,completion: @escaping (_ success: Bool, _ error: ResolutionError?) -> ()){
        
        guard let name = name else {
            completion(false, .noName)
            return
        }
        
        guard let priority = priority else {
            completion(false, .noPriority)
            return
        }

        guard let comment = comment else {
            let temp = UUID().uuidString
            ref.collection("\(DatabaseUserManager.shared.user.UID)_Resolutions").document(temp).setData([
                "name":name,
                "priority":priority,
                "done":false,
                "comment":"",
                "id":temp])
            
            resolutions_undone.append(Resolution(name, priority, false, "", temp))
            completion(true, nil)
            return
        }
        
        let temp = UUID().uuidString
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Resolutions").document(temp).setData([
            "name":name,
            "priority":priority,
            "done":false,
            "comment":comment,
            "id":temp])
        
        resolutions_undone.append(Resolution(name, priority, false, comment, temp))
        completion(true, nil)
        
    }
    
    func editResolution(resolution:Resolution){
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Resolutions").document(resolution.id).setData([
            "name": resolution.name,
            "priority": resolution.priority,
            "done": resolution.done,
            "comment": resolution.comment,
            "id": resolution.id])
    }
    
    func deleteResolution(resolution:Resolution,completion: @escaping (_ success: Bool) -> ()){
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Resolutions").document(resolution.id).delete(){ error in
            if let _ = error{
                completion(false)
                return
            }
            
            var count=0
            if resolution.done{
                for item in self.resolutions_done{
                    if item.id == resolution.id{
                        self.resolutions_done.remove(at: count)
                    }
                    else{
                        count+=1
                    }
                }
            }
            else{
                for item in self.resolutions_undone{
                    if item.id == resolution.id{
                        self.resolutions_undone.remove(at: count)
                    }
                    else{
                        count+=1
                    }
                }
            }
            completion(true)
            
        }
    }
    
    enum ResolutionError: Error{
        case noName
        case noPriority
    }
}

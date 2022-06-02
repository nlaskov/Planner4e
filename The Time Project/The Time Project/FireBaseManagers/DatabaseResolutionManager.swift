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
import FirebaseAuth

class DatabaseResolutionManager:NSObject{
    
    static let shared = DatabaseResolutionManager()
    private var ref = Firestore.firestore()
    
    var resolutions_undone:[Resolution]=[]
    var resolutions_done:[Resolution]=[]
    var chosenResolution:Resolution = Resolution()
    
    func getResolution(completion: @escaping () -> ()){
        
        ref.collection("\(Auth.auth().currentUser!.uid)_Resolutions").getDocuments(){ (querySnapshot, err) in
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
    
    func sortResolutions(){
        var temp = Resolution()
        if resolutions_done.count == 0 || resolutions_done.count == 1{
            return
        }
        
        for i in 0...resolutions_done.count-2 {
            for j in i...resolutions_done.count-1{
                if resolutions_done[i].priority < resolutions_done[j].priority{
                    temp = resolutions_done[i]
                    resolutions_done[i] = resolutions_done[j]
                    resolutions_done[j] = temp
                }
                else if resolutions_done[i].priority == resolutions_done[j].priority {
                    if resolutions_done[i].name > resolutions_done[j].name{
                        temp = resolutions_done[i]
                        resolutions_done[i] = resolutions_done[j]
                        resolutions_done[j] = temp
                    }
                }
            }
        }
        
        if resolutions_undone.count == 0 || resolutions_undone.count == 1{
            return
        }
        
        for i in 0...resolutions_undone.count-2 {
            for j in i...resolutions_undone.count-1{
                if resolutions_undone[i].priority < resolutions_undone[j].priority{
                    temp = resolutions_undone[i]
                    resolutions_undone[i] = resolutions_undone[j]
                    resolutions_undone[j] = temp
                }
                else if resolutions_undone[i].priority == resolutions_undone[j].priority {
                    if resolutions_undone[i].name > resolutions_undone[j].name{
                        temp = resolutions_undone[i]
                        resolutions_undone[i] = resolutions_undone[j]
                        resolutions_undone[j] = temp
                    }
                }
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
            ref.collection("\(Auth.auth().currentUser!.uid)_Resolutions").document(temp).setData([
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
        ref.collection("\(Auth.auth().currentUser!.uid)_Resolutions").document(temp).setData([
            "name":name,
            "priority":priority,
            "done":false,
            "comment":comment,
            "id":temp])
        
        resolutions_undone.append(Resolution(name, priority, false, comment, temp))
        completion(true, nil)
        
    }
    
    func editResolution(resolution:Resolution){
        ref.collection("\(Auth.auth().currentUser!.uid)_Resolutions").document(resolution.id).setData([
            "name": resolution.name,
            "priority": resolution.priority,
            "done": resolution.done,
            "comment": resolution.comment,
            "id": resolution.id])
    }
    
    func deleteResolution(resolution:Resolution,completion: @escaping (_ success: Bool) -> ()){
        ref.collection("\(Auth.auth().currentUser!.uid)_Resolutions").document(resolution.id).delete(){ error in
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

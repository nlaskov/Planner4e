//
//  DatabaseTravelManager.swift
//  The Time Project
//
//  Created by Nikola Laskov on 2.06.22.
//


import Foundation
import FirebaseDatabase
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth

class DatabaseTravelManager:NSObject{
    
    static let shared = DatabaseTravelManager()
    private let ref = Firestore.firestore()
    
    var unvisited:[Destination]=[]
    var visited:[Destination]=[]
    var chosenDestnation:Destination = Destination()
    
    func getDestinations(completion: @escaping () -> () ){
        
        ref.collection("\(Auth.auth().currentUser!.uid)_Travel").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let destination = Destination(document["name"] as! String, document["priority"] as! Int, document["done"] as! Bool, document["comment"] as! String, document["id"] as! String)
                    if destination.done{
                        self.visited.append(destination)
                    }
                    else{
                        self.unvisited.append(destination)
                    }
                }
                completion()
            }
        }
    }
    
    func sortDestinations(){
        var temp = Destination()
        if visited.count == 0 || visited.count == 1{
            return
        }
        for i in 0...visited.count-2 {
            for j in i...visited.count-1{
                if visited[i].priority < visited[j].priority{
                    temp = visited[i]
                    visited[i] = visited[j]
                    visited[j] = temp
                }
                else if visited[i].priority == visited[j].priority {
                    if visited[i].name > visited[j].name{
                        temp = visited[i]
                        visited[i] = visited[j]
                        visited[j] = temp
                    }
                }
            }
        }
        
        if unvisited.count == 0 || unvisited.count == 1{
            return
        }
        for i in 0...unvisited.count-2 {
            for j in i...unvisited.count-1{
                if unvisited[i].priority < unvisited[j].priority{
                    temp = unvisited[i]
                    unvisited[i] = unvisited[j]
                    unvisited[j] = temp
                }
                else if unvisited[i].priority == unvisited[j].priority {
                    if unvisited[i].name > unvisited[j].name{
                        temp = unvisited[i]
                        unvisited[i] = unvisited[j]
                        unvisited[j] = temp
                    }
                }
            }
        }
        
    }
    
    func addDestination(name:String?,priority:Int? ,comment:String?,completion: @escaping (_ success: Bool, _ error: TravelError?) -> ()){
        
        guard let name = name, !name.isEmpty else {
            completion(false, TravelError.noName)
            return
        }
        
        guard let priority = priority else {
            completion(false, TravelError.noPriority)
            return
        }
        
        guard let comment = comment else {
            let temp = UUID().uuidString
            ref.collection("\(Auth.auth().currentUser!.uid)_Travel").document(temp).setData([
                "name": name,
                "priority": priority,
                "done": false,
                "comment": "",
                "id":temp
                ])
            
            unvisited.append(Destination(name, priority, false,"",temp))
            completion(true, nil)
            return
        }

        let temp = UUID().uuidString
        ref.collection("\(Auth.auth().currentUser!.uid)_Travel").document(temp).setData([
            "name": name,
            "priority": priority,
            "done": false,
            "comment": comment,
            "id": temp
            ])
        
        unvisited.append(Destination(name, priority, false,comment,temp))
        
        completion(true, nil)
    }
    
    func editDestination(destination:Destination){
        ref.collection("\(Auth.auth().currentUser!.uid)_Travel").document(destination.id).setData([
            "name": destination.name,
            "priority": destination.priority,
            "done": destination.done,
            "comment": destination.comment,
            "id": destination.id])
    }
    
    func deleteDestination(destination:Destination,completion: @escaping (_ success: Bool) -> ()){
        ref.collection("\(Auth.auth().currentUser!.uid)_Travel").document(destination.id).delete(){ error in
            if let _ = error{
                completion(false)
                return
            }
            
            var count=0
            if destination.done{
                for item in self.visited{
                    if item.id == destination.id{
                        self.visited.remove(at: count)
                    }
                    else{
                        count+=1
                    }
                }
            }
            else{
                for item in self.unvisited{
                    if item.id == destination.id{
                        self.unvisited.remove(at: count)
                    }
                    else{
                        count+=1
                    }
                }
            }
            completion(true)
        }
    }
    
    enum TravelError: Error{
        case noName
        case noPriority
    }
    
}

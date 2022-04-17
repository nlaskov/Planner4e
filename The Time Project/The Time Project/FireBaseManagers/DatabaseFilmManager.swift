//
//  DatabaseFilmManager.swift
//  The Time Project
//
//  Created by Nikola Laskov on 17.04.22.
//

import Foundation
import FirebaseDatabase
import Firebase
import FirebaseFirestoreSwift


class DatabaseFilmManager:NSObject{
    
    static let shared = DatabaseFilmManager()
    let ref = Firestore.firestore()
    var films_unwatched:[Film]=[]
    var films_watched:[Film]=[]
    
    func getFilms(completion: @escaping () -> ()){
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Films").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    var film = Film(_name: document["name"] as! String, _priority: document["priority"] as! Int, _done: document["done"] as! Bool)
                    
                    if film.done{
                        self.films_watched.append(film)
                    }
                    else{
                        self.films_unwatched.append(film)
                    }
                }
                completion()
            }
        }
    }
    
    func addFilm(name:String?,priority:Int ,completion: @escaping (_ success: Bool, _ error: Error?) -> ()){
        
        guard let name = name, !name.isEmpty else {
            completion(false, FilmError.noName)
            return
        }
        
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Films").document(UUID().uuidString).setData([
            "name": name,
            "priority": priority,
            "done": false,
            ])
        
        films_unwatched.append(Film(_name: name, _priority: priority, _done: false))
        
        completion(true, nil)
    }
    
    enum FilmError: Error{
        case noName
    }
    
}


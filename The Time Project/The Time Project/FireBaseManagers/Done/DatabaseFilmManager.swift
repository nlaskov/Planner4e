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
    private let ref = Firestore.firestore()
    
    var films_unwatched:[Film]=[]
    var films_watched:[Film]=[]
    var chosenFilm:Film = Film()
    
    func getFilms(completion: @escaping () -> ()){
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Films").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let film = Film(document["name"] as! String, document["priority"] as! Int, document["done"] as! Bool, document["director"] as! String, document["comment"] as! String, document["id"] as! String)
                    
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
    
    func addFilm(name:String?,priority:Int?,director:String?,comment:String? ,completion: @escaping (_ success: Bool, _ error: FilmError?) -> ()){
        
        guard let name = name, !name.isEmpty else {
            completion(false, FilmError.noName)
            return
        }
        
        guard let priority = priority else {
            completion(false, FilmError.noPriority)
            return
        }
        
        guard let director = director else {
            
            guard let comment = comment else {
                let temp = UUID().uuidString
                ref.collection("\(DatabaseUserManager.shared.user.UID)_Films").document(temp).setData([
                    "name": name,
                    "priority": priority,
                    "done": false,
                    "director":"",
                    "comment":"",
                    "id": temp
                    ])
                films_unwatched.append(Film(name, priority, false, "", "", temp))
                
                completion(true, nil)
                return
            }
            let temp = UUID().uuidString
            ref.collection("\(DatabaseUserManager.shared.user.UID)_Films").document(temp).setData([
                "name": name,
                "priority": priority,
                "done": false,
                "director":"",
                "comment":comment,
                "id": temp
                ])
            films_unwatched.append(Film(name, priority, false, "", comment, temp))
            
            completion(true, nil)
            return
        }
        
        guard let comment = comment else {
            let temp = UUID().uuidString
            ref.collection("\(DatabaseUserManager.shared.user.UID)_Films").document(temp).setData([
                "name": name,
                "priority": priority,
                "done": false,
                "director":director,
                "comment":"",
                "id": temp
                ])
            
            films_unwatched.append(Film(name, priority, false, director, "", temp))
            
            completion(true, nil)
            return
        }

        let temp = UUID().uuidString
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Films").document(temp).setData([
            "name": name,
            "priority": priority,
            "done": false,
            "director":director,
            "comment":comment,
            "id": temp
            ])
        
        films_unwatched.append(Film(name, priority, false, director, comment, temp))
        
        completion(true, nil)
    }
    
    func editFilm(film:Film){
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Films").document(film.id).setData([
            "name": film.name,
            "priority": film.priority,
            "done": film.done,
            "director": film.director,
            "comment": film.comment,
            "id": film.id])
    }
    
    func deleteFilm(film:Film, completion: @escaping (_ success: Bool) -> ()){
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Films").document(film.id).delete(){ error in
            if let _ = error{
                completion(false)
                return
            }
            
            var count=0
            if film.done{
                for item in self.films_watched{
                    if item.id == film.id{
                        self.films_watched.remove(at: count)
                    }
                    else{
                        count+=1
                    }
                }
            }
            else{
                for item in self.films_unwatched{
                    if item.id == film.id{
                        self.films_unwatched.remove(at: count)
                    }
                    else{
                        count+=1
                    }
                }
            }
            completion(true)
        }
    }
    
    
    enum FilmError: Error{
        case noName
        case noPriority
    }
    
}


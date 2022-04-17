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
    
    func getFilms(){
        ref.collection("\(AuthManager.shared.currentUser.UID)_Films").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.getDocument(as: Film.self) { result in
                        switch result {
                        case .success(let film):
                            if film.done{
                                self.films_watched.append(film)
                            }
                            else{
                                self.films_unwatched.append(film)
                            }
                        case .failure(let error):
                            print("Error decoding city: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func addFilm(_ film:Film){
        ref.collection("\(AuthManager.shared.currentUser.UID)_Films").document(UUID().uuidString).setData([
            "name": film.name,
            "priority": film.priority,
            "done": false,
            ])
        films_unwatched.append(film)
    }
    
}


//
//  DatabaseBookManager.swift
//  The Time Project
//
//  Created by Nikola Laskov on 16.04.22.
//

import Foundation
import FirebaseDatabase
import Firebase
import FirebaseFirestoreSwift


class DatabaseBookManager:NSObject{
    
    static let shared = DatabaseBookManager()
    private let ref = Firestore.firestore()
    
    var books_unread:[Book]=[]
    var books_read:[Book]=[]
    
    func getBooks(completion: @escaping () -> () ){
        
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Books").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let book = Book(_name: document["name"] as! String, _priority: document["priority"] as! Int, _done: document["done"] as! Bool)
                    if book.done{
                        self.books_read.append(book)
                    }
                    else{
                        self.books_unread.append(book)
                    }
                }
                completion()
            }
        }
    }
    
    func addBook(name:String?,priority:Int ,completion: @escaping (_ success: Bool, _ error: Error?) -> ()){
        
        guard let name = name, !name.isEmpty else {
            completion(false, BookError.noName)
            return
        }
        
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Books").document(UUID().uuidString).setData([
            "name": name,
            "priority": priority,
            "done": false,
            ])
        
        books_unread.append(Book(_name: name, _priority: priority, _done: false))
        
        completion(true, nil)
    }
    
    enum BookError: Error{
        case noName
    }
    
}

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
    var chosenBook:Book = Book()
    
    func getBooks(completion: @escaping () -> () ){
        
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Books").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let book = Book(document["name"] as! String, document["priority"] as! Int, document["done"] as! Bool, document["author"] as! String, document["comment"] as! String, document["id"] as! String)
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
    
    func addBook(name:String?,priority:Int? ,author:String?,comment:String?,completion: @escaping (_ success: Bool, _ error: BookError?) -> ()){
        
        guard let name = name, !name.isEmpty else {
            completion(false, BookError.noName)
            return
        }
        
        guard let priority = priority else {
            completion(false, BookError.noPriority)
            return
        }
        
        guard let author = author else {
            completion(false, BookError.noAuthor)
            return
        }

        guard let comment = comment else {
            let temp = UUID().uuidString
            ref.collection("\(DatabaseUserManager.shared.user.UID)_Books").document(temp).setData([
                "name": name,
                "priority": priority,
                "done": false,
                "author": author,
                "comment": "",
                "id":temp
                ])
            
            books_unread.append(Book(name, priority, false, author,"",temp))
            completion(true, nil)
            return
        }

        let temp = UUID().uuidString
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Books").document(temp).setData([
            "name": name,
            "priority": priority,
            "done": false,
            "author": author,
            "comment": comment,
            "id": temp
            ])
        
        books_unread.append(Book(name, priority, false,author,comment,temp))
        
        completion(true, nil)
    }
    
    func EditBook(book:Book){
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Books").document(book.id).setData([
            "name": book.name,
            "priority": book.priority,
            "done": book.done,
            "author": book.author,
            "comment": book.comment,
            "id": book.id])
    }
    
    func deleteBook(book:Book,completion: @escaping (_ success: Bool) -> ()){
        ref.collection("\(DatabaseUserManager.shared.user.UID)_Books").document(book.id).delete(){ error in
            if let _ = error{
                completion(false)
                return
            }
            
            var count=0
            if book.done{
                for item in self.books_read{
                    if item.id == book.id{
                        self.books_read.remove(at: count)
                    }
                    else{
                        count+=1
                    }
                }
            }
            else{
                for item in self.books_unread{
                    if item.id == book.id{
                        self.books_unread.remove(at: count)
                    }
                    else{
                        count+=1
                    }
                }
            }
            completion(true)
        }
    }
    
    enum BookError: Error{
        case noName
        case noPriority
        case noAuthor
    }
    
}

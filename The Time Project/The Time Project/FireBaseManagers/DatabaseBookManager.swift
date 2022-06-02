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
import FirebaseAuth

class DatabaseBookManager:NSObject{
    
    static let shared = DatabaseBookManager()
    private let ref = Firestore.firestore()
    
    var books_unread:[Book]=[]
    var books_read:[Book]=[]
    var chosenBook:Book = Book()
    
    func getBooks(completion: @escaping () -> () ){
        
        ref.collection("\(Auth.auth().currentUser!.uid)_Books").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let book = Book(document["name"] as! String, document["priority"] as! Int, document["done"] as! Bool, document["comment"] as! String, document["id"] as! String)
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
    
    func sortBooks(){
        var temp = Book()
        if books_read.count == 0 || books_read.count == 1{
            return
        }
        for i in 0...books_read.count-2 {
            for j in i...books_read.count-1{
                if books_read[i].priority < books_read[j].priority{
                    temp = books_read[i]
                    books_read[i] = books_read[j]
                    books_read[j] = temp
                }
                else if books_read[i].priority == books_read[j].priority {
                    if books_read[i].name > books_read[j].name{
                        temp = books_read[i]
                        books_read[i] = books_read[j]
                        books_read[j] = temp
                    }
                }
            }
        }
        
        if books_unread.count == 0 || books_unread.count == 1{
            return
        }
        for i in 0...books_unread.count-2 {
            for j in i...books_unread.count-1{
                if books_unread[i].priority < books_unread[j].priority{
                    temp = books_unread[i]
                    books_unread[i] = books_unread[j]
                    books_unread[j] = temp
                }
                else if books_unread[i].priority == books_unread[j].priority {
                    if books_unread[i].name > books_unread[j].name{
                        temp = books_unread[i]
                        books_unread[i] = books_unread[j]
                        books_unread[j] = temp
                    }
                }
            }
        }
        
    }
    
    func addBook(name:String?,priority:Int? ,comment:String?,completion: @escaping (_ success: Bool, _ error: BookError?) -> ()){
        
        guard let name = name, !name.isEmpty else {
            completion(false, BookError.noName)
            return
        }
        
        guard let priority = priority else {
            completion(false, BookError.noPriority)
            return
        }
        
        guard let comment = comment else {
            let temp = UUID().uuidString
            ref.collection("\(Auth.auth().currentUser!.uid)_Books").document(temp).setData([
                "name": name,
                "priority": priority,
                "done": false,
                "comment": "",
                "id":temp
                ])
            
            books_unread.append(Book(name, priority, false,"",temp))
            completion(true, nil)
            return
        }

        let temp = UUID().uuidString
        ref.collection("\(Auth.auth().currentUser!.uid)_Books").document(temp).setData([
            "name": name,
            "priority": priority,
            "done": false,
            "comment": comment,
            "id": temp
            ])
        
        books_unread.append(Book(name, priority, false,comment,temp))
        
        completion(true, nil)
    }
    
    func editBook(book:Book){
        ref.collection("\(Auth.auth().currentUser!.uid)_Books").document(book.id).setData([
            "name": book.name,
            "priority": book.priority,
            "done": book.done,
            "comment": book.comment,
            "id": book.id])
    }
    
    func deleteBook(book:Book,completion: @escaping (_ success: Bool) -> ()){
        ref.collection("\(Auth.auth().currentUser!.uid)_Books").document(book.id).delete(){ error in
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
    }
    
}

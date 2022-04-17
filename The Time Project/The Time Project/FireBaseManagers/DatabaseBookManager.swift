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
    let ref = Firestore.firestore()
    
    var books_unread:[Book]=[]
    var books_read:[Book]=[]
    
    func getBooks(){
        ref.collection("\(AuthManager.shared.currentUser.UID)_Books").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.getDocument(as: Book.self) { result in
                        switch result {
                        case .success(let book):
                            if book.done{
                                self.books_read.append(book)
                                
                            }
                            else{
                                self.books_unread.append(book)
                                
                            }
                        case .failure(let error):
                            print("Error decoding city: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func addBook(_ book:Book){
        ref.collection("\(AuthManager.shared.currentUser.UID)_Books").document(UUID().uuidString).setData([
            "name": book.name,
            "priority": book.priority,
            "done": false,
            ])
        books_unread.append(book)
    }
    
}

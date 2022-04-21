//
//  Book.swift
//  The Time Project
//
//  Created by Nikola Laskov on 16.04.22.
//

import Foundation

class Book{
    var name:String
    var priority:Int
    var done:Bool
    var author:String
    var comment:String
    var id:String
    
    init(_ name:String,_ priority:Int,_ done:Bool,_ author:String,_ comment:String,_ id:String) {
        self.name = name
        self.priority = priority
        self.done = done
        self.author = author
        self.comment = comment
        self.id = id
        
    }
    
    init (){
        name = ""
        priority = -1
        done = false
        author = ""
        comment = ""
        id = "0"
    }
}

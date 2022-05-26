//
//  Task.swift
//  The Time Project
//
//  Created by Nikola Laskov on 29.03.22.
//

import Foundation

class Task{
    var name:String = ""
    var priority:Int = -1
    var category:Int = -1
    var day:Int = -1
    var month:Int = -1
    var year:Int = -1
    var done:Bool = false
    var comment:String = ""
    var id:String = ""
    
    init(_ name:String,_ priority:Int,_ category:Int,_ day:Int, _ month:Int,_ year:Int,_ done:Bool,_ comment:String,_ id:String) {
        self.name = name
        self.priority = priority
        self.category = category
        self.day = day
        self.month = month
        self.year = year
        self.done = done
        self.comment = comment
        self.id = id
    }
    
    init(){
         name = ""
         priority = -1
         category = -1
         day = -1
         month = -1
         year = -1
         done = false
         comment = ""
         id = ""
    }
}

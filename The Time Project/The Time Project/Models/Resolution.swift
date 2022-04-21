//
//  Resolution.swift
//  The Time Project
//
//  Created by Nikola Laskov on 16.04.22.
//

import Foundation

class Resolution{
    var name:String
    var priority:Int
    var done:Bool
    var comment:String
    var id:String
    
    init(_ name:String,_ priority:Int,_ done:Bool,_ comment:String,_ id:String) {
        self.name = name
        self.priority = priority
        self.done = done
        self.comment = comment
        self.id = id
    }
    init(){
        name = ""
        priority = -1
        done = false
        comment = ""
        id = ""
    }
}

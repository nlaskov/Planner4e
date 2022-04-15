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
    
    init(_name:String, _priority:Int, _category:Int, _day:Int, _month:Int, _year:Int, _done:Bool) {
        self.name = name
        self.priority = priority
        self.category = category
        self.day = day
        self.month = month
        self.year = year
        self.done = done
    }
    /* Имената на файловете да са Тask Book Film Recepie ect. и всеки клас да е наследник на класа Тask за да можем да ги извикваме така от базата дани firebaseFirestore */
    
}

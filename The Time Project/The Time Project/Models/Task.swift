//
//  Task.swift
//  The Time Project
//
//  Created by Nikola Laskov on 29.03.22.
//

import Foundation

class Task: Codable{
    var name:String = ""
    var priority:Int = -1
    var category:Int = -1
    var day:Int = -1
    var month:Int = -1
    var year:Int = -1
    var done:Bool = false
    
    init(_name:String, _priority:Int, _category:Int, _day:Int, _month:Int, _year:Int, _done:Bool) {
        self.name = _name
        self.priority = _priority
        self.category = _category
        self.day = _day
        self.month = _month
        self.year = _year
        self.done = _done
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case priority
        case category
        case day
        case month
        case year
        case done
    }
    /* Имената на файловете да са Тask Book Film Recepie ect. и всеки клас да е наследник на класа Тask за да можем да ги извикваме така от базата дани firebaseFirestore */
    
}

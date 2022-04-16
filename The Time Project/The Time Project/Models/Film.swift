//
//  Film.swift
//  The Time Project
//
//  Created by Nikola Laskov on 16.04.22.
//

import Foundation

class Film: Codable{
    var name:String
    var priority:Int
    var done:Bool
    
    init(_name:String, _priority:Int, _done:Bool) {
        self.name = _name
        self.priority = _priority
        self.done = _done
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case priority
        case done
    }
}

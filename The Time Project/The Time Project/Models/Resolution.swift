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
    
    init(_name:String, _priority:Int, _done:Bool) {
        self.name = _name
        self.priority = _priority
        self.done = _done
    }
}

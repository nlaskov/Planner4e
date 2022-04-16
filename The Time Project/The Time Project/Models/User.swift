//
//  User.swift
//  The Time Project
//
//  Created by Nikola Laskov on 29.03.22.
//

import Foundation

class User: Codable{
    var name:String = ""
    var UID:String = ""
    var email:String = ""
    var image:String = ""
    
    /*init(_ name:String,_ UID:String,_ email:String,_ image:String) {
        self.name = name
        self.UID = UID
        self.email = email
        self.image = image
    }*/
    
    init(){
        name = ""
        UID = ""
        email = ""
        image = ""
    }
    
    enum CodingKeys: String, CodingKey {
            case name
            case email
            case UID
            case image
        }
}

/* Image да бъде името на файла който се пази в firebaseStorage */

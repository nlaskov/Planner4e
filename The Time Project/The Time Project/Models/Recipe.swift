//
//  Recipes.swift
//  The Time Project
//
//  Created by Nikola Laskov on 21.04.22.
//

import Foundation
class Recipe{
    var name:String
    var image:String
    var recipe:String
    var id:String
    
    init(){
        name = ""
        image = ""
        recipe = ""
        id = "0"
    }
    
    init(_ name:String,_ image:String,_ recipe:String,_ id:String){
        self.name = name
        self.image = image
        self.recipe = recipe
        self.id = id
    }
    
}

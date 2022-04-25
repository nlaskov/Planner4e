//
//  recipesCollectionViewCell.swift
//  The Time Project
//
//  Created by Nikola Laskov on 25.04.22.
//

import Foundation
import UIKit

class recipesCollectionViewCell:UICollectionViewCell{
    
    var recipe:Recipe = Recipe()
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var name: UITextView!
    
    func setCell(recipe:Recipe){
        self.recipe = recipe
        name.text = recipe.name
        //image.image = StorageManager.shared.getRecepiePicture(imageName: recipe.image){}
    }
}

//
//  recipesCollectionViewCell.swift
//  The Time Project
//
//  Created by Nikola Laskov on 25.04.22.
//

import Foundation
import UIKit
import Kingfisher

class recipesCollectionViewCell:UICollectionViewCell{
    
    var recipe:Recipe = Recipe()
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var name: UILabel!
    
    func setCell(recipe:Recipe){
        self.recipe = recipe
        name.text = recipe.name
        if recipe.image != "Image "{
            StorageManager.shared.getRecepiePicture(imageName: recipe.image){ urlString in
                let url = URL(string: urlString)
                self.image.kf.setImage(with:url)
            }
        }
        else {
            image.image = UIImage(named: "eclair")
        }
    }
}

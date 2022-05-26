//
//  recipesViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 25.04.22.
//

import Foundation
import UIKit

class recepiesViewController:UIViewController{
    
    
    @IBOutlet var recipeCollectionView: UICollectionView!
    @IBOutlet var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeCollectionView.delegate = self
        recipeCollectionView.dataSource = self
        if (DatabaseRecipesManager.shared.recipes.isEmpty){
            DatabaseRecipesManager.shared.getRecipes {
                self.recipeCollectionView.reloadData()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recipeCollectionView.reloadData()
    }
    
}

extension recepiesViewController:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DatabaseRecipesManager.shared.recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for: indexPath) as! recipesCollectionViewCell
        
        cell.layer.borderWidth = 0.0
        cell.setCell(recipe: DatabaseRecipesManager.shared.recipes[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 4.0, height: collectionView.frame.size.height / 3.0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DatabaseRecipesManager.shared.chosenRecipe = DatabaseRecipesManager.shared.recipes[indexPath.row]
        performSegue(withIdentifier: "toSingleRecipe", sender: self)
    }
}

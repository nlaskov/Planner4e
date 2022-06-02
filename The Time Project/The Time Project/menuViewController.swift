//
//  menuViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 17.04.22.
//

import Foundation
import UIKit
import FirebaseAuth

class menuViewController:UIViewController{
    
    @IBOutlet var calendarButton: UIButton!
    @IBOutlet var bookButton: UIButton!
    @IBOutlet var filmButton: UIButton!
    @IBOutlet var resolutionButton: UIButton!
    @IBOutlet var travelButton: UIButton!
    @IBOutlet var recipeButton: UIButton!
    @IBOutlet var profileButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if Auth.auth().currentUser == nil {
            let loginVC = storyboard?.instantiateViewController(withIdentifier: "loginMenu") as! UINavigationController
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
            
        }
        else{
            let uid = Auth.auth().currentUser!.uid
            let _ = DatabaseUserManager.shared.getUser(UID: uid){
                self.setLanguage()
                
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        setLanguage()
    }
    
    func setLanguage(){
        if DatabaseUserManager.shared.bg{
            calendarButton.setTitle("Календар", for: .normal)
            bookButton.setTitle("Книги", for: .normal)
            filmButton.setTitle("Филми", for: .normal)
            resolutionButton.setTitle("Цели", for: .normal)
            travelButton.setTitle("Пътуване", for: .normal)
            recipeButton.setTitle("Рецепти", for: .normal)
            profileButton.setTitle("Профил", for: .normal)
        }
        else{
            calendarButton.setTitle("Calendar", for: .normal)
            bookButton.setTitle("Books", for: .normal)
            filmButton.setTitle("Films", for: .normal)
            resolutionButton.setTitle("Resolutions", for: .normal)
            travelButton.setTitle("Travel", for: .normal)
            recipeButton.setTitle("Recipes", for: .normal)
            profileButton.setTitle("Profile", for: .normal)
        }
    }
}

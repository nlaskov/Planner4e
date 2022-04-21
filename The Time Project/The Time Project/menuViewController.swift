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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if Auth.auth().currentUser == nil {
            let loginVC = storyboard?.instantiateViewController(withIdentifier: "loginMenu") as! UINavigationController
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
            
        }
        else{
            let uid = Auth.auth().currentUser?.uid
            let _ = DatabaseUserManager.shared.getUser(UID:uid!)
        }
        
        
    }
}

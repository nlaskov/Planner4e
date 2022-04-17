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
    
    @IBAction func profilePress(_ sender: Any) {
        
        let alert = UIAlertController(title: "Log Out", message:"Are you sure you want to log out?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            AuthManager.shared.logout { success in
                if (success) {
                    self.goToLogoutScene()
                   
                }
            }
        }))
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = (sender as AnyObject).bounds
        }
        
        present(alert, animated: true)
    }
    private func goToLogoutScene() {
        
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginMenu") as! UINavigationController
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true)
            self.tabBarController?.selectedIndex = 0
    }
    
    
    
}

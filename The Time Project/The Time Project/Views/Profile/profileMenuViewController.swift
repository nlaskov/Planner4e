//
//  profileMenuViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 20.04.22.
//

import Foundation
import UIKit

class profileMenuViewController:UIViewController{
    
    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    @IBOutlet var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUser()
        
    }
    
    func setUser(){
        nameLabel.text = "Name: " + DatabaseUserManager.shared.user.name
        emailLabel.text = "Email: " + DatabaseUserManager.shared.user.email
        //setImage
    }
    
    @IBAction func loguot(_ sender: Any) {
        
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
    }
    
    
}

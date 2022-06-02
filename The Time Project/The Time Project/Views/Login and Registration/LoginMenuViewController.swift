//
//  LoginMenuViewController.swift
//  Time_Project
//
//  Created by Nikola Laskov on 26.03.22.
//

import Foundation
import UIKit

class LoginMenuViewController: UIViewController{
    
    
    @IBOutlet var loginEmailButton: UIButton!
    @IBOutlet var noAccountLabel: UILabel!
    @IBOutlet var noAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setLanguage()
    }
    
    func setLanguage(){
        if DatabaseUserManager.shared.bg{
            loginEmailButton.setTitle("Вход с поща", for: .normal)
            noAccountLabel.text = "Нямаш акаунт?"
            noAccountButton.setTitle("Регистрирай се!", for: .normal)
        }
        else{
            loginEmailButton.setTitle("Login with email", for: .normal)
            noAccountLabel.text = "New user?"
            noAccountButton.setTitle("Sign Up!", for: .normal)
        }
    }
    
   
    
    
}

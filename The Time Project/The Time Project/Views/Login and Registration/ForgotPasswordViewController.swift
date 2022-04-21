//
//  ForgotPasswordViewController.swift
//  Time_Project
//
//  Created by Nikola Laskov on 26.03.22.
//

import Foundation
import UIKit

class ForgotPasswordViewController: UIViewController{
    
    @IBOutlet var email: UITextField!
    @IBOutlet var sentEmailButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturn))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }
    
    @IBAction func sentEmailButtonPressed(_ sender: Any) {
        self.errorLabel.isHidden = true
        
        AuthManager.shared.forgotPassword(email: email.text){ success, error in
            if success {
                self.navigationController?.popToRootViewController(animated: true)
            }
            else{
                self.errorSetter(error: error as! AuthError)
                self.errorLabel.isHidden = false
            }
        }
        
        
    }
    
    func errorSetter(error: AuthError){
        if error == .defaultError {
           self.errorLabel.text = "Something is wrong"
           
       } else if error == .noEmail {
            self.errorLabel.text = "Email is required"
            
        } else if error == .noPassword {
            self.errorLabel.text = "Password is required"
            
        } else if error == .noUser {
            self.errorLabel.text = "Email or password incorect"
            
        } else if error == .invalidEmail {
            self.errorLabel.text = "Invalid email"
            
        } else if error == .emailAlreadyInUse {
            self.errorLabel.text = "The email is already used"
            
        } else if error == .weakPassword {
            self.errorLabel.text = "Password should be at least 6 characters"
            
        }
    }
    
    
    
    
    
    
}

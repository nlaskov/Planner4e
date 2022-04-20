//
//  SignUpViewController.swift
//  Time_Project
//
//  Created by Nikola Laskov on 26.03.22.
//

import Foundation
import UIKit


class SignUpViewController: UIViewController{
    
   
    @IBOutlet var fullName: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        //Hide error button
        self.errorLabel.isHidden = true
        
        //Start loading animation
        
        AuthManager.shared.singUp(email: email.text, password: password.text, fullname: fullName.text) { success, error in
            if success {
                //If registration successful return to TemplateViewController
                //DatabaseUserManager.shared.addUser(fullName: self.fullName.text)
                self.dismiss(animated: true, completion: nil)
            }
            else {
                //If registration isn`t successful show Error lable
                self.errorSetter(error: error as! AuthError)
                self.errorLabel.isHidden = false
            }
            
            //Stop animation
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

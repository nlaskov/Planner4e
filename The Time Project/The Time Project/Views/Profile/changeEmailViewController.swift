//
//  changeEmailViewControll.swift
//  The Time Project
//
//  Created by Nikola Laskov on 20.04.22.
//

import Foundation
import UIKit

class changeEmailViewController: UIViewController{

    @IBOutlet var newEmailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func done(_ sender: UIButton) {
        self.errorLabel.isHidden = true
        
        AuthManager.shared.changeEmail(newEmail: newEmailField.text, password: passwordField.text) { success, error in
            if success {
                
                DatabaseUserManager.shared.changeEmail(newEmail: self.newEmailField.text)
                
                self.newEmailField.text = ""
                self.passwordField.text = ""
                self.alertSuccess(sender)
            }
            else {
                self.errorLabel.isHidden = false
                self.errorSetter(error: error as! AuthError)
            }
        }
    }
    
    func alertSuccess(_ sender: UIButton) {
        let alert = UIAlertController(title: "Changed Email", message:"You have successfully changed your email!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = sender.bounds
        }
        
        present(alert, animated: true)
    }
    
    func errorSetter(error: AuthError){
        if error == .defaultError {
           self.errorLabel.text = "Something is wrong"
           
       } else if error == .noEmail {
            self.errorLabel.text = "Email is required"
            
        } else if error == .noPassword {
            self.errorLabel.text = "Password is required"
            
        } else if error == .incorrectPassword {
            self.errorLabel.text = "Incorrect Password"
            
        } else if error == .invalidEmail {
            self.errorLabel.text = "Invalid email"
            
        } else if error == .emailAlreadyInUse {
            self.errorLabel.text = "The email is already used"
            
        }
    }
}

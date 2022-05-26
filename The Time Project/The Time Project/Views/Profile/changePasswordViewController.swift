//
//  changePasswordViewControl.swift
//  The Time Project
//
//  Created by Nikola Laskov on 20.04.22.
//

import Foundation
import UIKit

class changePasswordViewController:UIViewController{
    
    @IBOutlet var oldPasswordField: UITextField!
    @IBOutlet var newPasswordField: UITextField!
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
    
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        self.errorLabel.isHidden = true
        
        AuthManager.shared.changePassword(oldPassword: oldPasswordField.text, newPassword: newPasswordField.text) { success, error in
            if success {
                
                self.oldPasswordField.text = ""
                self.newPasswordField.text = ""
                self.alertSuccess(sender)
            }
            else {
                self.errorLabel.isHidden = false
                self.errorSetter(error: error as! AuthError)
            }
        }
    }
    
    
    func alertSuccess(_ sender: UIButton) {
        let alert = UIAlertController(title: "Changed Password", message:"You have successfully changed your password!", preferredStyle: .alert)
        
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

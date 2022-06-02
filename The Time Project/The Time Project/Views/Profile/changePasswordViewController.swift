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
        
        var title = ""
        var message = ""
        
        if DatabaseUserManager.shared.bg{
            title = "Сменена парола"
            message = "Успешно смени паролата си!"
        }
        else{
            title = "Password changed"
            message = "You successfully changed your password!"
        }
        
        let alert = UIAlertController(title:title , message:message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = sender.bounds
        }
        
        present(alert, animated: true)
    }
    
    func errorSetter(error: AuthError){
        
        if DatabaseUserManager.shared.bg{
            if error == .defaultError {
               self.errorLabel.text = "Нещо не е наред"
               
           } else if error == .noEmail {
                self.errorLabel.text = "Трябва имейл"
                
            } else if error == .noPassword {
                self.errorLabel.text = "Трябва парола"
                
            } else if error == .incorrectPassword {
                self.errorLabel.text = "Грешна парола"
                
            } else if error == .invalidEmail {
                self.errorLabel.text = "Грешен имейл"
                
            } else if error == .emailAlreadyInUse {
                self.errorLabel.text = "Този имейл вече се използва"
            }
        }
        else{
            if error == .defaultError {
               self.errorLabel.text = "Something isn`t right"
               
           } else if error == .noEmail {
                self.errorLabel.text = "Email required"
                
            } else if error == .noPassword {
                self.errorLabel.text = "Password required"
                
            } else if error == .incorrectPassword {
                self.errorLabel.text = "Wronge password"
                
            } else if error == .invalidEmail {
                self.errorLabel.text = "Wrong email"
                
            } else if error == .emailAlreadyInUse {
                self.errorLabel.text = "This email is already used"
            }
        }
    }
    
    func setLanguage(){
        if DatabaseUserManager.shared.bg{
            oldPasswordField.placeholder = "Стара парола"
            newPasswordField.placeholder = "Нова парола"
        }
        else{
            oldPasswordField.placeholder = "Old Password"
            newPasswordField.placeholder = "New Password"
        }
    }
    
}
